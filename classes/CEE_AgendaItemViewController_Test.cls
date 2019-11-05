/***************************************************************************************************
Name    : CEE_AgendaItemViewController_Test 
Author  : Eric Pesch
Purpose : Visualforce Page Controller tests for the custom Agenda Item page (small)
Created Date: Dec 1 2014
Modification History: 
Eric Pesch - Jan 5 2015: Added Comments, cleanup                     
*****************************************************************************************************/

@isTest
private class CEE_AgendaItemViewController_Test {

    /*@method: Test for viewing an agenda item*/
    private static testMethod void agendaItemViewTest() {
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
        
        //APEX Page testing
        ApexPages.StandardController stdItem = new ApexPages.StandardController(agenda);
        CEE_AgendaItemViewController agendaItemController = new CEE_AgendaItemViewController(stdItem);
    }
}