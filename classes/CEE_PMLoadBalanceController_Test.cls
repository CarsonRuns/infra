/***************************************************************************************************
Name    : CEE_PMLoadBalanceController_Test 
Author  : Eric Pesch
Purpose : Tests for the PM Load Balance list controller  
Created Date: Dec 1 2014
Modification History: 
Eric Pesch - Jan 5 2015: Added Comments, cleanup                     
*****************************************************************************************************/

@isTest
private class CEE_PMLoadBalanceController_Test {
    
    /*@method: PM Load Balance VF page tests*/
    private static testMethod void pmLoadBalanceTest() {
        //Variables
        String testRoot = null, testEnv = null;
        
        //Setup Account
        User admin = CEE_TestUtility.getUser('admin', true);
        Account acct = null;
        Opportunity oppty = null;
        
        System.runAs(admin){
            CEE_TestUtility.loadCustomSettings();
            acct = CEE_TestUtility.getAccount('brief', true);
        }
        
        //Setup location
        CEE_Location__c loc = CEE_TestUtility.getLocation('brief', true, 'EBC/EC');
        Briefing_PM__c briefPM = CEE_TestUtility.getBriefingPM('pm', true, loc);
        Briefing_PM__c briefPMB = CEE_TestUtility.getBriefingPM('am', true, loc);
        CEE_Room__c room = CEE_TestUtility.getRoom('brief', true, loc, false, 6);
        
        //Setup briefing
        Opportunity opppt =  CEE_TestUtility.getOpty();
        CEE__c briefing = CEE_TestUtility.getBriefing('brief', true, 'OBX', acct, opppt, loc);
        
        Test.startTest();
        ApexPages.StandardController stdItem = new ApexPages.StandardController(briefing);
        CEE_PMLoadBalanceController balanceController = new CEE_PMLoadBalanceController(stdItem);
        balanceController.setCurrAvailability();
        
        //Get classes
        CEE_PMLoadBalanceController.Header testHeader = new CEE_PMLoadBalanceController.Header();
        CEE_PMLoadBalanceController.Day testDay = new CEE_PMLoadBalanceController.Day();
        CEE_PMLoadBalanceController.PMAvailability testPM1 = new CEE_PMLoadBalanceController.PMAvailability();
        
        //Get utility methods
        List<CEE_PMLoadBalanceController.Header> headers = balanceController.getHeaders();
        
        List<SelectOption> months = balanceController.getDynMonth();
        balanceController.setDynMonth(null);
        
        List<SelectOption> sites = balanceController.getDynSite();
        balanceController.setDynSite(null);
        
        Test.stopTest();
    }
}