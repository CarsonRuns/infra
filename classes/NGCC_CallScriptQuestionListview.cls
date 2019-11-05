/***********************************************************************************
Name    : NGCC_CallScriptQuestionListview 
Author  : Bapu
Purpose : This class contains the functionality of creating a CC_Call_Script_Q_A__c record related to Call_Script__c 
with the values of selected CC_Master_Question_Answer_Bank__c record. 
Created Date: 3/17/2014 
************************************************************************************/

public class NGCC_CallScriptQuestionListview {

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

    public list<CC_Master_Question_Answer_Bank__c>  MasterQBAB ;
    public list<Id> lstIds = new list<Id>();
    public CC_Call_Script_Q_A__c lstCallScript{get;set;}
    public ApexPages.StandardSetController controller;
    
    public NGCC_CallScriptQuestionListview(ApexPages.StandardSetController c){
        MasterQBAB = new List<CC_Master_Question_Answer_Bank__c>();
        lstCallScript = new CC_Call_Script_Q_A__c();//Instance of a CC_Call_Script_Q_A__c Object used to populate lookup field in visualforcepage
        MasterQBAB = c.getSelected();// To get the SObject data of the selected records

    if(MasterQBAB!=null && MasterQBAB.size()>0)
        for(CC_Master_Question_Answer_Bank__c str : MasterQBAB) {
            lstIds.add(str.id);//Adding selected record Id's to query neccesary fields from CC_Master_Question_Answer_Bank__c
        }
    }
       
    public PageReference SaveCallScript() {
        system.debug('MasterQBAB===='+MasterQBAB);
        list<CC_Call_Script_Q_A__c> ccCallScriptLst = new list<CC_Call_Script_Q_A__c>();
        for(CC_Master_Question_Answer_Bank__c ccMasterIterate : MasterQBAB)
        {
            CC_Call_Script_Q_A__c  ccCallScript = new CC_Call_Script_Q_A__c();
            
            // SCAVA Fix
            if(flsGet(CC_Call_Script_Q_A__c.Name)||flsUpdateGet(CC_Call_Script_Q_A__c.Name)){
            ccCallScript.Name = ccMasterIterate.Name;
            }
            if(flsGet(CC_Call_Script_Q_A__c.CC_Master_Question_Bank__c)||flsUpdateGet(CC_Call_Script_Q_A__c.CC_Master_Question_Bank__c)){
            ccCallScript.CC_Master_Question_Bank__c = ccMasterIterate.Id;
            }
            if(flsGet(CC_Call_Script_Q_A__c.Question_Text__c)||flsUpdateGet(CC_Call_Script_Q_A__c.Question_Text__c)){
            ccCallScript.Question_Text__c = ccMasterIterate.Question_Text__c ;
            }
            if(flsGet(CC_Call_Script_Q_A__c.Question_Type__c)||flsUpdateGet(CC_Call_Script_Q_A__c.Question_Type__c)){
            ccCallScript.Question_Type__c = ccMasterIterate.Question_Type__c ;
            }
            if(flsGet(CC_Call_Script_Q_A__c.Local_to_SFDC__c)||flsUpdateGet(CC_Call_Script_Q_A__c.Local_to_SFDC__c)){
            ccCallScript.Local_to_SFDC__c = ccMasterIterate.Local_to_SFDC__c;
            }
            if(flsGet(CC_Call_Script_Q_A__c.Answer_Options__c)||flsUpdateGet(CC_Call_Script_Q_A__c.Answer_Options__c)){
            ccCallScript.Answer_Options__c = ccMasterIterate.Answer_Options_Id__c;
            }
            if(flsGet(CC_Call_Script_Q_A__c.Question_Category__c)||flsUpdateGet(CC_Call_Script_Q_A__c.Question_Category__c)){
            ccCallScript.Question_Category__c = ccMasterIterate.Question_Category__c;
            }
            ccCallScript.Call_Script__c = lstCallScript.Call_Script__c;
            
            ccCallScriptLst.add(ccCallScript);
        }
        system.debug('ccCallScriptLst***size**'+ccCallScriptLst.size()+'====='+ccCallScriptLst);

        //save results allowing Call Script success
        Database.SaveResult[] saveResults = Database.insert(ccCallScriptLst, false);

        system.debug('********saveResults size*****'+saveResults);

        // get success and failure stats
        Integer failures = 0;
        Integer successes = 0;
        Set<String> errors = new Set<String>();
        for (Database.SaveResult saveResult : saveResults) {
            if (!saveResult.success) {
                failures++;
                for (Database.Error err : saveResult.getErrors()) {
                    errors.add(err.getMessage());
                }
            } else {
                successes++;
            }
        }
        
        // to show number of failed updates and error messages
        if (failures > 0) {
            String result = successes + ' record(s) updated successfully. <br/><br/>';
            
            result += '<font color="red">' + failures + ' record(s) failed to update due to below errors: <ul>';
            for(String msg: errors) {
               result += '<li>' + msg + '</li>';
            }
            result += '</font></ul>';
            
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.INFO, result);
            ApexPages.addMessage(errMsg);
            return null;
        } else {
            String strUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/' + lstCallScript.Call_Script__c;
            system.debug('strUrl==='+strUrl);
            PageReference pgRef = new PageReference(strUrl);
            return pgRef;
        }
    }
    
    public Boolean getHasSelected() {
        //Get selected records   
    if(lstIds!=null && lstIds.size()>0)
        MasterQBAB = [Select Id,Name,Question_Text__c,Question_Type__c, Local_to_SFDC__c,Answer_Options_Id__c,Question_Category__c From CC_Master_Question_Answer_Bank__c Where Id =: lstIds];  
        system.debug('MasterQBAB*****'+MasterQBAB.size()+'::::'+MasterQBAB);
        Boolean retval;
        if (MasterQBAB == null || MasterQBAB.size() == 0) {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select at least one record for assignment');
            ApexPages.addMessage(errMsg);
            retval = false;
        } else {
            retval = true;
        }
        return retval;
    }
    
    public Boolean getHasMessages() {
        Boolean retval;
        if (ApexPages.getMessages().size() == 0) {
            retval = false;
        } else {
            retval = true;
        }
        return retval;
    }
}