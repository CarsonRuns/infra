@isTest(seeAllData = true)
Private Class P360_NewTargetProsController_Test{
 
 static testMethod void  NewTargetProsTest(){
 
        Assigned_Partner__c apObj = GenericStaticTestData.gettestTargetProspectRecord();
                
        Test.startTest();
                
        P360_NewTargetProsController testController = new P360_NewTargetProsController();

        ApexPages.StandardController stdCon = new ApexPages.StandardController(apObj);       
        testController = new P360_NewTargetProsController(stdCon);
        testController.getCreateNewValidity(); 
        testController.accountPageRedirect();      
        testController.pageRedirect();
        
        apObj.Partner_Status__c = 'Closed';
        update apObj;
        P360_NewTargetProsController.isNoRejectedClosed = False;
        testController = new P360_NewTargetProsController(stdCon);        
        testController.getCreateNewValidity();
        
        apObj.Customer_Account__c = null;
        stdCon = new ApexPages.StandardController(apObj);       
        testController = new P360_NewTargetProsController(stdCon);
        testController.getCreateNewValidity();
        
        test.stopTest();
 }

}