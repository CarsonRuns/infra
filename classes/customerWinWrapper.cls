/*******************************************************************************************************************
Author          : Shivi Srivastava
Created         : Feb 1,2019
Functionality   : Wrapper class to insert thw Customer Win Recommendation records from SalesInsight API
---------------------------------------------------------------------------
Modification History:
---------------------------------------------------------------------------
Date        		Author              		Change  
Mar 28,2019   		Lei Zhou       				Added logic for Customer Stories
*******************************************************************************************************************/
public class customerWinWrapper {
//Deserializing and saving the API response
public static boolean deserializeResp(String recordId,List<String> responseJson){
    boolean flag=false;
    Integer count=1;
    List <Id>newRec=new List<Id>();
    List<Customer_Win_Recommendation__c>delIds=[Select id from Customer_Win_Recommendation__c where Opportunity__c =: recordId];
    List<Customer_Win_Recommendation__c> insertRec=new List<Customer_Win_Recommendation__c>();
    for(String str:responseJson){
    Map<String, Object> m =(Map<String, Object>)JSON.deserializeUntyped(str);
        Customer_Win_Recommendation__c cwr=new Customer_Win_Recommendation__c();
        cwr.Index__c=count;
        if(m.containsKey('bizent')){
             if(m.get('bizent') instanceof List<object>) {
                List<Object>BE =(List<Object>)m.get('bizent');
                cwr.BE__c= String.join(BE, ',');
             }else{
                 cwr.BE__c = String.valueOf(m.get('bizent'));
             }
        
        }
        if(m.containsKey('subbizent')){
            List<Object>subBe=(List<Object>)m.get('subbizent');
            cwr.Sub_BE__c=String.join(subBe, ',');
        }                        
        if(m.containsKey('url')){
        cwr.URL__c=String.valueOf(m.get('url'));
        }
        cwr.Opportunity__c=recordId;
        cwr.Category__c=String.valueOf(m.get('category'));
        if(m.containsKey('date')){
        String t=(String.valueOf(m.get('date'))).replace('T',' ');
        
        Datetime dt2=Datetime.valueOf(t);
        Date gmtDate = dt2.dateGmt();
        Time gmtTime = dt2.timeGmt();
        DateTime gmtTime1 = DateTime.newInstanceGmt(gmtDate, gmtTime);
        cwr.Date__c=gmtTime1;
        }
        //All params are not present for the 3 APIs
        if(m.containsKey('cwaccountname')){
            List<Object>accname=(List<Object>)m.get('cwaccountname');
            cwr.cwAccount_Name__c=String.join(accname, ',');
        }
        if(m.containsKey('cwtheater')){
            //List<Object>theater=(List<Object>)m.get('cwtheater');
            cwr.cwTheater__c=String.valueOf(m.get('cwtheater'));
        }
        if(m.containsKey('cwregion')){
            
            cwr.cwRegion__c=String.valueOf(m.get('cwregion'));         
        }
        if(m.containsKey('cwsegments')){
            //List<Object>segment=(List<Object>)m.get('cwsegments');
            cwr.cwSegments__c=String.valueOf(m.get('cwsegments'));
        }
        if(m.containsKey('cwfiscalyear')){
            cwr.cwFiscal_Year__c=String.valueOf(m.get('cwfiscalyear'));
        }      
        if(m.containsKey('cwvertical')){         
             if(m.get('cwvertical') instanceof List<object>) {
                
                List<Object> vertical  =(List<Object>)m.get('cwvertical');
                cwr.cwVertical__c= String.join(vertical, ',');
             }else{  
               //List<Object>vertical=(List<Object>)m.get('cwvertical');
            	String vertical = String.valueOf(m.get('cwvertical')) ;
                 
            	if(vertical!=null && vertical.length()> 200){ 
                 
                 	cwr.cwVertical__c=String.valueOf(m.get('cwvertical')).substring(0,200) ;     
                    
            	}else{
                	cwr.cwVertical__c=String.valueOf(m.get('cwvertical')) ;
                    
            	} 
             }
        }
        if(m.containsKey('cwcompetitors')){
           //List<Object>competitors=(List<Object>)m.get('cwcompetitors');
           // cwr.cwCompetitors__c=String.join(competitors, ',');
           List<Object>competitors;          
           if(m.get('cwcompetitors') != null){         
                competitors=(List<Object>)m.get('cwcompetitors');
                cwr.cwCompetitors__c=String.join(competitors, ',');
            }                       
        }
        if(m.containsKey('industry')){
            cwr.cwIndustry__c=String.valueOf(m.get('industry'));
        }
        if(m.containsKey('cwprimarytechnology')){
            List<Object>pTech=(List<Object>)m.get('cwprimarytechnology');
            cwr.cwPrimary_Technology__c=String.join(pTech, ',');
        }
        if(m.containsKey('lastmodified')){
        String u=(String.valueOf(m.get('lastmodified'))).replace('T',' ');
        u=u.substring(1,20);
        Datetime dt2=Datetime.valueOf(u);
        Date gmtDate = dt2.dateGmt();
        Time gmtTime = dt2.timeGmt();
        DateTime gmtTime2 = DateTime.newInstanceGmt(gmtDate, gmtTime);
        cwr.last_modified__c=gmtTime2;
        integer N=6;
        cwr.last_modified__c=cwr.last_modified__c+(N/24);
        }
        string TitleValue=String.valueOf(m.get('title'));
        system.debug('TitleValue-->'+TitleValue);
        if(m.containsKey('title')){
            cwr.Title__c=String.valueOf(m.get('title'));
        }
        //if(m.containsKey('subbizent')){}
        count++;
        insertRec.add(cwr);
        system.debug('List Value--->'+insertRec);
    }
    try{
        Database.SaveResult[] srList=Database.insert(insertRec);
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                newRec.add(sr.getId());
            }
        }
    }
    catch(DmlException e) { 
        System.debug('The following exception has occurred: ' + e.getMessage());
    }
    if(!newRec.isEmpty()){
        flag=deleteRec(recordId,delIds);
    }
    
    return flag;
}
//Deleting existing Customer_Win_Recommendation__c records
public static boolean deleteRec(String recordId,List<Customer_Win_Recommendation__c>delIds){
    boolean delSuccess=false;
    try{
        delete delIds;
        delSuccess=true;
    }
    catch(DmlException e) { 
        System.debug('The following exception has occurred: ' + e.getMessage());
    }
    return delSuccess;
}

}