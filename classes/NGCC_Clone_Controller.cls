/************************************************************************************************************************************
Name    : NGCC_Clone_Controller
Author  : Fazurulla Ganganapalli & Awnish Kumar
Purpose : This is the main controller class for Call Script Solution clone button. 
Created Date: 05/12/2014
Modification History: 

*************************************************************************************************************************************/
public class NGCC_Clone_Controller{  

     // SCAVA Helper Method
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }
    
    // SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdateGet(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }

    public Id callScriptId; 
    public boolean error{get;set;}
    public NGCC_Clone_Controller(ApexPages.StandardController sc){    
    error = true;
    }  
        
    public Pagereference cloneCallScript(){ 
    try{
    //Checking the current user role. If SM/CCM user then to proceed to clone.
     callScriptId = ApexPages.CurrentPage().getParameters().get('id'); 
      string pf=UserInfo.getUserRoleId();
      list<UserRole> roles = new list<UserRole>();
        roles= [select Id,Name from UserRole where name like '%NGCC-CC Site Manager%' or name like '%NGCC-CCM%'];        
        //roles = [select id,name from UserRole where name like '%NGCC-SDR%'];               
        set<Id> Ids = new Set<Id>();     
         for(UserRole u:roles){
             Ids.add(u.Id);
         }
         if(Ids.Contains(pf)){
         //Creating new call script and copying values from the existing one. Setting the default status to Draft.               
          CC_Call_Script__c cloneCallScript = new CC_Call_Script__c();
          List<CC_Call_Script__c> parentCallScript  =  [select name, Theater__c ,Question_Categories__c,Total_Questions__c,Number_of_Question_Type__c, Status__c,Default_Language__c,Default_Call_Script__c,MultiSelect_Count__c,  Number_of_Question_Category__c  from CC_Call_Script__c where id  = :callScriptId];
         System.debug('Parent Call Script : '+ parentCallScript);
         //SCAVA
          if(flsGet(CC_Call_Script__c.Name)||flsUpdateGet(CC_Call_Script__c.Name)){
          cloneCallScript.Name = parentCallScript[0].name;
          }
          if(flsGet(CC_Call_Script__c.Theater__c)||flsUpdateGet(CC_Call_Script__c.Theater__c)){
          cloneCallScript.Theater__c = parentCallScript[0].Theater__c;  
          }
          if(flsGet(CC_Call_Script__c.Question_Categories__c)||flsUpdateGet(CC_Call_Script__c.Question_Categories__c)){
          cloneCallScript.Question_Categories__c = parentCallScript[0].Question_Categories__c; 
          }
          if(flsGet(CC_Call_Script__c.Status__c)||flsUpdateGet(CC_Call_Script__c.Status__c)){
          cloneCallScript.Status__c = 'Draft';  
          }
          if(flsGet(CC_Call_Script__c.Default_Language__c)||flsUpdateGet(CC_Call_Script__c.Default_Language__c)){
          cloneCallScript.Default_Language__c = parentCallScript[0].Default_Language__c; 
          }
          if(flsGet(CC_Call_Script__c.Default_Call_Script__c)||flsUpdateGet(CC_Call_Script__c.Default_Call_Script__c)){
          cloneCallScript.Default_Call_Script__c = parentCallScript[0].Default_Call_Script__c; 
          }//SCAVA
          //Database.insert(cloneCallScript,true);
            Database.SaveResult srList = Database.insert(cloneCallScript, true); //SCAVA New
          
          List<CC_Call_Script_Q_A__c> setList = new List<CC_Call_Script_Q_A__c>();
          List<CC_Call_Script_Q_A__c> callScriptQAs = [select name,CurrencyIsoCode,Answer_Options__c,Dependent_Question__c,CC_Master_Question_Bank__c,Conditionally_Required_Criteria__c,Question_Required__c,Conditionaly_Required_If__c,Help_Text__c,Local_to_SFDC__c,Maximum_If_Number_Validation__c, Minimum_If_Number_Validation__c,Question_Category__c,Question_Text__c,Question_Type__c,Required__c,Required_on_Lead_Description__c,Sequence__c,Validation_Both_Conditional_or_Required__c  from CC_Call_Script_Q_A__c where Call_Script__c = :callScriptId]; 
         //Copy the QandA associated with the parent call script
          for(CC_Call_Script_Q_A__c callScriptQA : callScriptQAs ){
             CC_Call_Script_Q_A__c cloneCallScriptQA = callScriptQA.clone();
          
             cloneCallScriptQA.Call_Script__c =  cloneCallScript.id;  
                      
             setList.add(cloneCallScriptQA);     
          }
          //database.insert(setList,true);
            List<Database.SaveResult> srList1 = Database.insert(setList,true); //SCAVA New
          
          PageReference pref = new PageReference('/'+cloneCallScript.Id+'/e?retURL=%2F'+cloneCallScript.Id);   
          return pref;         
       } 
     else{
     error = false;
     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'You have to be NGCC-CC Site Manager/NGCC-CCM to use this button'));
     //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'You have to be NGCC-SDR to use this button'));
     }    
    }catch(Exception e){
    ApexPages.addMessages(e);
    }
     return null;
    }
}