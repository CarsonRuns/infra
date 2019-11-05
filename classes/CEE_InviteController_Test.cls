/***************************************************************************************************
Name    : CEE_InviteController_Test 
Author  : Eric Pesch
Purpose : Tests for the Briefing Invite controller  
Created Date: Dec 1 2014
Modification History: 
Eric Pesch - Jan 5 2015: Added Comments, cleanup                     
*****************************************************************************************************/

@isTest
private class CEE_InviteController_Test {

    /*@method: Agenda Item invitation tests*/
    private static testMethod void ceeInviteAgendaItemTest() {
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
        //Agenda_Room__c agendaRoom = CEE_TestUtility.getAgendaRoom('brief', true, briefing, room);
        
        //Setup agenda item
        //Agenda_Item__c agenda = CEE_TestUtility.getAgendaItem('brief', true, briefing, loc, agendaRoom, topic);
        Agenda_Item__c agenda = CEE_TestUtility.getAgendaItem('brief', true, briefing, loc, null, topic);
        
        //Setup Presenter
        CEE_Attendee__c presenter = CEE_TestUtility.getAttendee('brief', true, briefing, agenda, true);
        CEE_Invite__c invite = CEE_TestUtility.getInvite('brief', true, briefing, presenter, agenda, null);
        //CEE_Invite__c inviteB = CEE_TestUtility.getInvite('brief', true, briefing, null, null, agendaRoom);
        CEE_TestUtility.simulatePresenterInvite(invite);
        
        //Get standard parameters
        Test.setCurrentPage(new PageReference(''));
        testRoot = Utilities.getConstant_CS('CEE Outlook URL');
        testEnv = Utilities.getConstant_CS('CEE Environment');
        
        //APEX Page testing
        ApexPages.currentPage().getParameters().put('butCommand','Modify');
        ApexPages.currentPage().getParameters().put('recordType','Agenda_Item__c');
        ApexPages.currentPage().getParameters().put('id',agenda.Id);
        
        
        Test.startTest();
        CEE_InviteController ceeController = new CEE_InviteController();
        
        //Add invitation attributes
        ceeController.addInvitationEmails();
        
        //Change current URL
        //System.assertEquals(testRoot + CEE_Utility.ROOT_URL_REDIRECT, ceeController.ifrURL);
        ceeController.changeUrl();
        ceeController.iframeLoaded();
        
        //Get back Page Reference
        PageReference backRef = ceeController.backMethod();
        Test.stopTest();
        //Assertion tests
        //System.assert(true, ceeController.ifrURL.contains('&Command=agenda_item_invite'));
    }
    
    /*@method: Briefing invitation tests*/
    private static testMethod void ceeInviteBriefingTest() {
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
        
        //Setup Presenter
        //CEE_Attendee__c presenter = CEE_TestUtility.getAttendee('brief', true, briefing, agenda, true);
        //CEE_Invite__c invite = CEE_TestUtility.getInvite('brief', true, briefing, presenter, agenda, null);
        CEE_Invite__c inviteB = CEE_TestUtility.getInvite('brief', true, briefing, null, null, agendaRoom);
        //CEE_TestUtility.simulatePresenterInvite(invite);
        
        //Get standard parameters
        Test.setCurrentPage(new PageReference(''));
        testRoot = Utilities.getConstant_CS('CEE Outlook URL');
        testEnv = Utilities.getConstant_CS('CEE Environment');
        
        Test.startTest();
        //APEX Page testing
        ApexPages.currentPage().getParameters().put('butCommand','Modify');
        ApexPages.currentPage().getParameters().put('recordType','CEE__c');       
        ApexPages.currentPage().getParameters().put('id',briefing.Id);
        
        //constructrer
        CEE_InviteController ceeController = new CEE_InviteController();
        
        //Add invitation attributes
        ceeController.addInvitationEmails();
        
        //Change current URL
        //System.assertEquals(testRoot + CEE_Utility.ROOT_URL_REDIRECT, ceeController.ifrURL);
        ceeController.changeUrl();
        ceeController.iframeLoaded();
        
        //Get back Page Reference
        PageReference backRef = ceeController.backMethod();
        Test.stopTest();
        //Assertion tests
        //System.assert(true, ceeController.ifrURL.contains('&Command=agenda_item_invite'));
    }
}