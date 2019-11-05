/***************************************************************************************************
Name    : CEE_Briefing_InviteList_Controller_Test 
Author  : Eric Pesch
Purpose : Test for CEE Brefing Invitelist Shell page 
Created Date: Dec 1 2014
Modification History: 
Eric Pesch - Jan 5 2015: Added Comments, cleanup                     
*****************************************************************************************************/

@isTest
private class CEE_Briefing_InviteList_Controller_Test {

    /*@method: Briefing Invite List test method*/
    static testMethod void ceeBriefingInviteListTest() {
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
        
        CEE_Room__c room = CEE_TestUtility.getRoom('brief', true, loc, false, 6);
        
        //Setup briefing
        Opportunity opppt =  CEE_TestUtility.getOpty();
        CEE__c briefing = CEE_TestUtility.getBriefing('brief', true, 'OBX', acct, opppt, loc);
        
        //APEX Page testing
        ApexPages.StandardController stdItem = new ApexPages.StandardController(briefing);
        CEE_Briefing_InviteList_Controller briefingController = new CEE_Briefing_InviteList_Controller(stdItem);
        
        //Back method
        PageReference backRef = briefingController.backMethod();
    }
}