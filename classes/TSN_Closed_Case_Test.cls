@isTest

private Class TSN_Closed_Case_Test{
     private static testMethod void test(){
         Case testTSNCase = new Case(RecordTypeId=Utilities.getCaseTSNRecordTypeId(),Contact_Type__c = 'Cisco',Cisco_Contact__c='abc@cisco.com');
         insert testTSNCase; // TSN Case
         Case testPHCase  = new Case(RecordtypeId =Utilities.getCasePHRecordTypeId(),Contact_Type__c = 'Cisco',Cisco_Contact__c='abc@cisco.com',Case_Theater__c = 'Americas-US Commercial');
         insert testPHCase; //PH case
         Test.StartTest();
         ApexPages.StandardController controllerTSN = new ApexPages.StandardController(testTSNCase);      
         PageReference pageRefTSN = ApexPages.currentPage();
         pageRefTSN.getParameters().put('id',testTSNCase.Id);
         TSN_Closed_Case_CTE closeCaseTSN = new TSN_Closed_Case_CTE(controllerTSN);
         closeCaseTSN.start();
         closeCaseTSN.getPageRef(); 
         ApexPages.StandardController controllerPH = new ApexPages.StandardController(testPHCase);      
         PageReference pageRefPH = ApexPages.currentPage();
         pageRefTSN.getParameters().put('id',testPHCase.Id);
         TSN_Closed_Case_CTE closeCasePH = new TSN_Closed_Case_CTE(controllerPH);
         closeCasePH.start();
         closeCasePH.getPageRef(); 
         Test.StopTest();
    }
}