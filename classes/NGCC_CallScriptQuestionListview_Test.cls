@isTest
private class NGCC_CallScriptQuestionListview_Test

{
    public static testMethod void testMeth(){
    
    list<CC_Master_Question_Answer_Bank__c> lstcc = new list<CC_Master_Question_Answer_Bank__c>();
    CC_Master_Question_Answer_Bank__c cc = new CC_Master_Question_Answer_Bank__c();
    cc.Question_Text__c = 'Test';
    cc.Question_Type__c = 'Test1';
    cc.Local_to_SFDC__c = True;
    cc.Answer_Options_Id__c = 'Test3';
    cc.Question_Category__c = 'Test4';
    //cc.Call_Script__c = 'Test5';
    lstcc.add(cc);
    insert cc;
    
    CC_Master_Question_Answer_Bank__c ccm = new CC_Master_Question_Answer_Bank__c();
    ccm.Name = 'Test';
    ccm.Question_Text__c = 'Test1';
    ccm.Question_Type__c = 'Test2';
    ccm.Local_to_SFDC__c = true;
    ccm.Answer_Options_Id__c = 'Test4';
    ccm.Question_Category__c= 'Test5';
    lstcc.add(ccm);
    insert ccm;
    
    ApexPages.StandardSetController stdController = new ApexPages.StandardSetController(lstcc);  
    stdController.setSelected(lstcc);
    NGCC_CallScriptQuestionListview Ngcc = new NGCC_CallScriptQuestionListview(stdController);  
    Ngcc.SaveCallScript();
    Ngcc.getHasSelected();
    Ngcc.getHasMessages();
    
    }


}