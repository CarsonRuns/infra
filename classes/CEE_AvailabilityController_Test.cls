/***************************************************************************************************
Name    : CEE_AvailabilityController_Test 
Author  : Eric Pesch
Purpose : Controller Tests for the Briefing Availability page 
Created Date: Dec 1 2014
Modification History: 
Eric Pesch - Jan 5 2015: Added Comments, cleanup   
Jay Dash - Aug 8 2015 : Added getOpty()                    
*****************************************************************************************************/

@isTest
private class CEE_AvailabilityController_Test {

    /*@method: Test for Briefing Availability page*/
    private static testMethod void ceeAvailabilityTest() {
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
        Topic__c topic = CEE_TestUtility.getTopic('brief', true, false);
        Agenda_Room__c agendaRoom = CEE_TestUtility.getAgendaRoom('brief', true, briefing, room);
        
        //Setup agenda item
        Agenda_Item__c agenda = CEE_TestUtility.getAgendaItem('brief', true, briefing, loc, agendaRoom, topic);
        
        //Get standard parameters
        Test.setCurrentPage(new PageReference(''));
        testRoot = Utilities.getConstant_CS('CEE Outlook URL');
        testEnv = Utilities.getConstant_CS('CEE Environment');
        
        //APEX Page testing
        ApexPages.StandardController stdItem = new ApexPages.StandardController(briefing);
        CEE_AvailabilityController briefingController = new CEE_AvailabilityController(stdItem);
        
        //Change current URL
        //System.assertEquals(testRoot + CEE_Utility.ROOT_URL_REDIRECT, briefingController.ifrURL);
        briefingController.changeUrl();
        
        //Assertion tests
        //System.assert(true, briefingController.ifrURL.contains('&Command=agenda_item_availability'));
    }
}