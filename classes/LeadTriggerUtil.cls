public class LeadTriggerUtil {
     /*
        Author: Nirup
        Below method will update Lead priority, by comparing on lead , CC responce and cc repsoce detail record's 
        Information with CC Lead Priority Rules
        Fazurulla : Added new logic for @ PBI800000001721/INC000034697976 
                    1)  Inactive the lead status
                    2)  Lead owner will get changed from NGCC Integration to respective inactive Queue name based on mapping object
                    3)  It will Create one CC responce.
                        Whenever phone status or contact status comes as inactive or invalid from MODS & NGCC Sync process for only NGCC Integration User
    */
    public static void NGCC_updateLeadPriority(list<Lead> newRec){

    
    ID rtId=Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Prospect').getRecordTypeID();//
    List<Lead> leadList= new List<Lead>();
    List<String> theatreList=new List<String>();
    Set<String> countryLeadSet=new Set<String>();
    Set<Id> leadSetId= new Set<Id>();
    
    NGCC_createResonseRecordBasedOnPhone(newRec,rtId);        
    getCountriesAndTheater(rtId,theatreList,countryLeadSet,newRec,leadList,leadSetId);
    
      
    
    //Query to get Get RuleAssignemnt
    List<NGCC_Rule_Assignment__c> ruleAssignmentList=[select id,Countries__c,Lead_Attribute__c,All_Countries__c,MODS_Leads__c,MODS_Q_A__r.name,Priority__c,Rank__c,Theater__c,Value__c from NGCC_Rule_Assignment__c where theater__c in:theatreList and Active__c = true Order BY Rank__c desc];
    
    map<string, set<string>> leadAttr = new map<string, set<string>>();
    map<string, set<string>> ccResp = new map<string, set<string>>();
    
    if(!ruleAssignmentList.isEmpty())
    {
            //Perparing all possible rule Combintation for Lead Attributes and MODS Q/A
      for(NGCC_Rule_Assignment__c la : ruleAssignmentList){
        set<string> tmp1= new set<string>();
                
        if(la.mods_leads__C != null && la.MODS_Leads__c.contains('Lead')) //get all rules related to Lead attribute.
        {
          prepareLeadCombinations(la,countryLeadSet,leadAttr,tmp1);
        } 
                
        
        else if( la.mods_leads__C != null && la.MODS_Leads__c.contains('MODS'))
        {
           prepareCCDCombinations(la,countryLeadSet,ccResp,tmp1);
          
        } 
        
      }  
    }
        
        
     
    //Query CC Responce along with Child records (CC Response Details) and Preparing all combination
    Map<id,CC_Response__c> leadGrandChildMap= new Map <id,CC_Response__c>([select Lead__c,(select name,Customer_Response_Detail_Local__c,Customer_Response_Detail__c,CC_Master_Question_Answer_Bank__r.name from CC_Response_Detail__r)from CC_Response__c where lead__c in:leadSetID]);
    Map<String,String> ccResponseDetailMap= new Map<String,String>();
    prepareccResponseDetailData(leadGrandChildMap,ccResponseDetailMap);
    
    List<Lead> leadrecords = new list<lead>();
    
        //Check Lead and CC Resonse Detail Values against every rule combination, if matches set the priority
    for(Lead l:leadList)
    {
      String rankPriorityLead;
      String rankPriorityCCD;  
      
            //Check for lead Attribute
      if((!(leadAttr.isEmpty())))
      {
        integer i = 0;                  
        for(String la:leadAttr.KeySet())
        {
          
          for(String s:leadAttr.get(la))  
          {
            string theater = s.split('~')[0];
            String country=s.split('~')[1];
            String leadAt=s.split('~')[2];
            String value=(s.split('~')[3]).toLowerCase(); 
            if(leadAt.equalsIgnoreCase('Program_Event_Name__c') || leadAt.equalsIgnoreCase('Program_Event_Description__c')){
                            if(l.get(leadAt) != null){
                                    if(l.Theater__c == theater && l.CustomCountry__c==country &&  string.valueOf(l.get(leadAt)).toLowerCase().contains(value) && la !=null){
                                    rankPriorityLead=la;
                                }
              }
            }else{
              if(l.Theater__c == theater && l.CustomCountry__c==country && l.get(leadAt)!= null &&  string.valueOf(l.get(leadAt))==value && la !=null){
                rankPriorityLead=la;
              }
                            
            }
          } 
        }
          
      }
      
            //Check for CC Cresponse Details
      if(!(ccResp.isEmpty()))
      {
        
        for(String la:ccResp.keySet())
        {
          
          for(String s:ccResp.get(la))  
          {  
                        string theater = s.split('~')[0];
            String country=s.split('~')[1];
            String ccAt=s.split('~')[2];
            String value=s.split('~')[3];
              if(l.Theater__c == theater && l.CustomCountry__c==country && !ccResponseDetailMap.isEmpty() && ccResponseDetailMap.get(l.id+'~'+ccAt)==value)
              rankPriorityCCD=la;
                        
          }
        }  
           
      } 
      
      if(rankPriorityLead!=null && rankPriorityCCD!=null)//if there is a rank found for both Lead and CC Response Detail combination set the  
      {
        String rankLead=rankPriorityLead.split('~')[0];
        String rankCCD=rankPriorityCCD.split('~')[0];
        l.CC_Call_Priority__c=rankLead>rankCCD ?rankPriorityCCD.split('~')[1]:rankPriorityLead.split('~')[1];
        if(rankLead==rankCCD)
          l.CC_Call_Priority__c=rankPriorityLead.split('~')[1];   
        
      }
      else if(rankPriorityLead!=null)
        l.CC_Call_Priority__c=rankPriorityLead.split('~')[1]; 
      else if(rankPriorityCCD!=null)
        l.CC_Call_Priority__c=rankPriorityCCD.split('~')[1];
      
      
      // if CC Call Priority is '4-N/A' set the fileds 
      if(l.CC_Call_Priority__c == '4-N/A'){
        leadrecords.add(l);
      }
    }    
    
    if(leadrecords.size() > 0){
      callPriorityNA(leadrecords,countryLeadSet);
    }
    
  }
    
  
  
  
  public static void callPriorityNA(List<Lead> leadrecords, set<String> countryLeadSet){
    list<CC_Response__c> ccResToInsert = new list<CC_Response__c>();
    // Query to Get Mapping records where queue name is Lead Country name, and set the Lead owner to inactive queue if prirority is '4-N/A'
    map<id,NGCC_Mapping_Object__c> mapping = new map<id,NGCC_Mapping_Object__c>([select id, name , Unassigned_Queue_Name__c, Inactive_Queue_Name__c from NGCC_Mapping_Object__c where name=:countryLeadSet]);
    list<QueueSObject> queueLst = new list<QueueSObject>();
    map<string , string> tmpQueNames = new map<string, string>();
    if(!mapping.isEmpty()){
            for(NGCC_Mapping_Object__c mm : mapping.values()){
              if(mm.name !=Null && mm.Inactive_Queue_Name__c!=Null){
                tmpQueNames.put(mm.name.toLowerCase().trim(),mm.Inactive_Queue_Name__c.toLowerCase().trim());
              } 
            }
        }
    
    //Get all inactive Queue records from Queue 
    //queueLst = [select id,name, developerName from Group where name like :queueNameFormat and type='Queue'];
    queueLst = [select id, Queue.Name,Queue.id from QueueSObject where queue.name =: tmpQueNames.values()];
    map<string,string> queueNAmes = new map<string,string>();
    if(!queueLst.isEmpty()){
        for(QueueSObject q:queueLst){
            queueNAmes.put(string.valueOf(q.queue.name).toLowerCase().trim(),q.queue.id);
        }
        }
    for(Lead l : leadrecords){  
      l.Call_Status__c = 'Invalid';
      l.status= 'Inactive';
      l.Outcome__c = 'Do Not Call';
      if(l.CustomCountry__c != null && tmpQueNames.get(l.CustomCountry__c.toLowercase()) != null && queueNAmes.get(tmpQueNames.get(l.CustomCountry__c.toLowercase())) != null){
        
        l.ownerId = queueNAmes.get(tmpQueNames.get(l.CustomCountry__c.toLowercase()));
      }
      CC_Response__c ccr = new CC_Response__c();
      ccr.Lead__c = l.id;
      ccr.Name = 'Do Not Call';
      ccr.Status__c = 'Do Not Call';
      ccr.Key_Code__c = l.ProgramEvent__c;
      ccr.Start_Date_Time__c = system.now();
            ccr.Response_Type__c = 'Outbound Call';
            ccr.Response_Date_Time__c = system.now();
      ccResToInsert.add(ccr);
    }
    if(ccResToInsert.size() > 0){
      insert ccResToInsert;
      for(CC_Response__c cc : ccResToInsert){
        cc.Source_Event_Number__c = cc.id;
      }
      update ccResToInsert;
    } 
  }
  
  
  public static void prepareCCDCombinations(NGCC_Rule_Assignment__c la,set<string> countryLeadSet,map<string, set<string>> ccResp,set<string> tmp1){
        set<string> tmpCountries = new set<string>();
    if(la.All_Countries__c){
      if(countryLeadSet.size()> 0){
        tmpCountries.addAll(countryLeadSet);
      }
    }
    else{
      if(la.Countries__c != null){
        tmpCountries.addAll(la.Countries__c.split(';'));
      }
    }
    
    for(string s1 :tmpCountries ){
      string tmp;
      
      for(string s: la.value__c.split(';')){
        tmp='';
        tmp = la.theater__c+'~'+s1+'~' +la.MODS_Q_A__r.name;
        tmp = tmp + '~' +s;
        if(ccResp!=null && ccResp.get(la.rank__c+'~'+la.Priority__c)!=null)
          tmp1.addAll(ccResp.get(la.rank__c+'~'+la.Priority__c));//exisiting MODS Combination
        tmp1.add(tmp);//New MODS Combination
        ccResp.put(la.rank__c+'~'+la.Priority__c,tmp1);
        
      }
    }
    
    
    }
    
    
    
    public static void getCountriesAndTheater(Id rtId,list<string> theatreList,set<string> countryLeadSet, List<lead> newRec, List<Lead> leadList,Set<Id> leadSetId){
       for(Lead ld: newRec)
    {
      if(ld.recordTypeId==rtId && ld.ETL_Load_Flag__c)
      {
        ld.CC_Call_Priority__c = '5-No Call Priority'; //Set Call Prority to 5 By Defalut.
        ld.ETL_Load_Flag__c=false; //Set the falg to False
        leadList.add(ld);
        leadSetId.add(ld.id);
        if(ld.CustomCountry__c!=null) //Get Lead Country Name
        {
          countryLeadSet.add(ld.CustomCountry__c);
        }  
        
        if(ld.Theater__c!= null) //Get Theater Name
        {
          theatreList.add(ld.Theater__c);
        }
        
      }
    } 
    }
    
    public static void prepareLeadCombinations(NGCC_Rule_Assignment__c la,set<string> countryLeadSet,map<string, set<string>> leadAttr,set<string> tmp1){
        set<string> tmpCountries = new set<string>();
        if(la.All_Countries__c){
            if(countryLeadSet.size()> 0){
                tmpCountries.addAll(countryLeadSet);
            }
        }
        else{
            if(la.Countries__c != null){
                tmpCountries.addAll(la.Countries__c.split(';'));
            }
        }
        for(string s1 :tmpCountries ){
            string tmp;
            for(string s: la.value__c.split(';')){
                tmp='';
                tmp = la.theater__c+'~'+s1+'~' +la.Lead_Attribute__c;
                tmp = tmp + '~' +s;
                if(leadAttr!=null && leadAttr.get(la.rank__c+'~'+la.Priority__c)!=null)
                    tmp1.addAll(leadAttr.get(la.rank__c+'~'+la.Priority__c)); // Existing Lead combination
                tmp1.add(tmp); // New Lead combination
                leadAttr.put(la.rank__c+'~'+la.Priority__c,tmp1);
            }
        }
    
    }
    
    public static void prepareccResponseDetailData(Map<id,CC_Response__c> leadGrandChildMap,Map<String,String> ccResponseDetailMap){
        if(leadGrandChildMap!=null && leadGrandChildMap.size()>0){           
      for(Id l:leadGrandChildMap.keySet()){
        //check if CC resopnse exist and CC response Detail.
        if(leadGrandChildMap.get(l) !=null && leadGrandChildMap.get(l).CC_Response_Detail__r!=null && leadGrandChildMap.get(l).CC_Response_Detail__r.size()>0){
          for(CC_Response_Detail__c ccrd:leadGrandChildMap.get(l).CC_Response_Detail__r){
                        if(ccrd.Customer_Response_Detail_Local__c != null){
                            ccResponseDetailMap.put(leadGrandChildMap.get(l).Lead__c+'~'+ccrd.CC_Master_Question_Answer_Bank__r.name,ccrd.Customer_Response_Detail_Local__c);
                        }
                        else{
                            ccResponseDetailMap.put(leadGrandChildMap.get(l).Lead__c+'~'+ccrd.CC_Master_Question_Answer_Bank__r.name,ccrd.Customer_Response_Detail__c);// all CC Response combination
                        }    
          }
          
        }
        
      }
    }
    }
    //@Fazu: This method will create one response record and update some fields in lead object only whenever update happens from MODS to NGCC using NGCC Integration User
   public static void NGCC_createResonseRecordBasedOnPhone(List<Lead> newRec,ID rtId){       
       list<CC_Response__c> ccResToInsert = new list<CC_Response__c>();
       list<CC_Response__c> ccResToUpdate = new list<CC_Response__c>();
       Set<String> gettingCountry = new Set<String>();
       map<string , string> tmpQueNames = new map<string, string>();
       map<string,string> queueNAmes = new map<string,string>();
       getCountryInactiveGroupFromMappingObject(newRec,tmpQueNames,queueNAmes);
       List<User> currentUserDetails = [select id,name,username,alias,profileid,profile.name from user where id =: UserInfo.getUserId() limit 1];
       for(Lead ld: newRec){
            if (!currentUserDetails.isEmpty()) {
                IF(ld.recordTypeId==rtId && (currentUserDetails[0].name.contains('NGCC Integration') ||currentUserDetails[0].name.contains('ninte'))
                   && ((ld.Phone_Status__c =='Invalid' || ld.Contact_Status__c == 'Inactive')&& ld.Call_Status__c =='Open')){                       
                       ld.status ='Inactive';
                       ld.Outcome__c = 'Do Not Call';
                       ld.Call_Status__c = 'Invalid';
                       ld.Latest_Agent_Notes__c = 'NGCC Note: Closed automatically due to Invalid Contact,Phone Status/Permission';  
                       if(ld.CustomCountry__c != null && tmpQueNames.get(ld.CustomCountry__c.toLowercase()) != null && queueNAmes.get(tmpQueNames.get(ld.CustomCountry__c.toLowercase())) != null){                
                           ld.ownerId = queueNAmes.get(tmpQueNames.get(ld.CustomCountry__c.toLowercase()));
                       }
                       CC_Response__c ccr = new CC_Response__c();
                            ccr.Lead__c = ld.id;
                            ccr.Name = 'Do Not Call';
                            ccr.Status__c = 'Do Not Call';
                            ccr.Key_Code__c = ld.ProgramEvent__c;
                            ccr.Start_Date_Time__c = system.now();
                            ccr.Response_Type__c = 'Outbound Call';
                            ccr.Response_Date_Time__c = system.now();
                            ccResToInsert.add(ccr);
                       } 
                    }
              }
       if(ccResToInsert.size() > 0){
           insert ccResToInsert;          
           for(CC_Response__c cc : ccResToInsert){
               cc.Source_Event_Number__c = cc.id;
           }
           update ccResToInsert;
       }
     }  
    //@Fazu : This method will get Inactive Queue name from NGCC mapping object based on current updating lead country
    public static void getCountryInactiveGroupFromMappingObject(List<Lead> newRec,map<string , string> tmpQueNames,map<string,string> queueNAmes){
        list<CC_Response__c> ccResToInsert = new list<CC_Response__c>();
        // Query to Get Mapping records where queue name is Lead Country name, and set the Lead owner to inactive queue.
        map<id,NGCC_Mapping_Object__c> mapping = new map<id,NGCC_Mapping_Object__c>([select id, name , Unassigned_Queue_Name__c, Inactive_Queue_Name__c from NGCC_Mapping_Object__c where name=:newRec[0].customcountry__c limit 1]);
        list<QueueSObject> queueLst = new list<QueueSObject>();
        if(!mapping.isEmpty()){
        for(NGCC_Mapping_Object__c mm : mapping.values()){
          if(mm.name !=Null && mm.Inactive_Queue_Name__c!=Null){
                tmpQueNames.put(mm.name.toLowerCase().trim(),mm.Inactive_Queue_Name__c.toLowerCase().trim());
              } 
            }
        }    
        // Query to Get Queue id from QueueSObject object     
        queueLst = [select id, Queue.Name,Queue.id from QueueSObject where queue.name =: tmpQueNames.values()];
        if(!queueLst.isEmpty()){
            for(QueueSObject q:queueLst){
                queueNAmes.put(string.valueOf(q.queue.name).toLowerCase().trim(),q.queue.id);
            }
        }
    }
}