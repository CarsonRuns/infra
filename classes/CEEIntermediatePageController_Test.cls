/***************************************************************************************************
Name    : CEEIntermediatePageController_Test 
Author  : Sudi Pitchaiah
Purpose : Test class for CEE intermediatePageController
Created Date: Oct 27 2015
Modification History: 
                     
*****************************************************************************************************/
@isTest
private class CEEIntermediatePageController_Test {

    static testMethod void myUnitTest() {
        test.startTest();
        User admin = CEE_TestUtility.getUser('admin', true);
        Account acct = null;
        Opportunity oppty = null;
         CEE_Location__c loc = null;
        Opportunity opppt =  null;
        System.runAs(admin){
            CEE_TestUtility.loadCustomSettings();
            acct = CEE_TestUtility.getAccount('brief', true);
        
        loc = CEE_TestUtility.getLocation('brief', true, 'EBC/EC');
        //CEE_Room__c room = CEE_TestUtility.getRoom('brief', true, loc, false, 6);
        
        //Setup briefing
        opppt =  CEE_TestUtility.getOpty();
        }
        CEE__c briefing = CEE_TestUtility.getBriefing('brief', true, 'OBX', acct, opppt, loc);              
        
        PageReference pageRef = Page.CEEIntermediatePage;
        Test.setCurrentPage(pageRef);       
        CEEIntermediatePageController objController = new CEEIntermediatePageController(new ApexPages.StandardController(briefing));   
        ApexPages.currentPage().getParameters().put('strURLRedirect', 'apex/CEEIntermediatePage');      
        objController.DisagreeCancelRequest();
        objController.getAgendaItemsData();
        objController.continueNext();
        objController.getCEE();
        test.stopTest();
    }
}