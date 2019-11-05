/***************************************************************************************************
Name    : CEE_InviteList_Controller_Test 
Author  : Eric Pesch
Purpose : Test methods for the Invite List Visualforce Page component  
Created Date: Dec 1 2014
Modification History: 
Eric Pesch - Jan 5 2015: Added Comments, cleanup                     
*****************************************************************************************************/

@isTest
private class CEE_InviteList_Controller_Test {

    /*@method: Tests for Briefing-based functionality*/
    private static testMethod void inviteListBriefingTest() {
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
        Opportunity opppt = CEE_TestUtility.getOpty();
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
        CEE_InviteList_Controller inviteController = new CEE_InviteList_Controller();
        inviteController.briefing = briefing;
        inviteController.objectName = 'CEE__c';
        inviteController.redirectUrl = '/'+briefing.Id;
        
        //Initialize controller
        inviteController.initInvites();
        inviteController.setInvites();
        inviteController.toggleIsUpdate();
        
        //Save invites
        inviteController.doSave();
        Test.stopTest();
    }
    
    /*@method: Test for Agenda Item based functionality*/
    private static testMethod void inviteListAgendaItemTest() {
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
        Opportunity opppt = CEE_TestUtility.getOpty();
        CEE__c briefing = CEE_TestUtility.getBriefing('brief', true, 'OBX', acct, opppt, loc);
        Topic__c topic = CEE_TestUtility.getTopic('brief', true, false);
       // Agenda_Room__c agendaRoom = CEE_TestUtility.getAgendaRoom('brief', true, briefing, room);
        
        //Setup agenda item
         Agenda_Item__c agenda = CEE_TestUtility.getAgendaItem('brief', true, briefing, loc, null, topic);
        
        
        //Setup Presenter
        CEE_Attendee__c presenter = CEE_TestUtility.getAttendee('brief', true, briefing, agenda, true);
        CEE_Invite__c invite = CEE_TestUtility.getInvite('brief', true, briefing, presenter, agenda, null);
        CEE_TestUtility.simulatePresenterInvite(invite);
        
        //Get standard parameters
        Test.setCurrentPage(new PageReference(''));
        testRoot = Utilities.getConstant_CS('CEE Outlook URL');
        testEnv = Utilities.getConstant_CS('CEE Environment');
        
        Test.startTest();
        CEE_InviteList_Controller inviteController = new CEE_InviteList_Controller();
        inviteController.agendaItem = agenda;
        inviteController.objectName = 'Agenda_Item__c';
        inviteController.redirectUrl = '/'+agenda.Id;
        
        //Initialize controller
        inviteController.initInvites();
        inviteController.setInvites();
        inviteController.selectCriteria = 'All';
        inviteController.toggleIsUpdate();
        
        
        //Save invites
        inviteController.doSave();
        inviteController.saveTPInvites();   
        inviteController.selectCriteria = 'Rooms';
        inviteController.toggleIsUpdate();  
        inviteController.selectCriteria = 'People';
        inviteController.toggleIsUpdate();          
        inviteController.validateCheckbox();
       
        Test.stopTest();      
        
    }
     /*@method: Test for Agenda Item based functionality*/
    private static testMethod void inviteListAgendaItemTest1() {
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
        Opportunity opppt = CEE_TestUtility.getOpty();
        CEE__c briefing = CEE_TestUtility.getBriefing('brief', true, 'OBX', acct, opppt, loc);
        Topic__c topic = CEE_TestUtility.getTopic('brief', true, false);
       // Agenda_Room__c agendaRoom = CEE_TestUtility.getAgendaRoom('brief', true, briefing, room);
        
        //Setup agenda item
         Agenda_Item__c agenda = CEE_TestUtility.getAgendaItem('brief', true, briefing, loc, null, topic);
        
        
        //Setup Presenter
        CEE_Attendee__c presenter = CEE_TestUtility.getAttendee('brief', true, briefing, agenda, true);
        CEE_Invite__c invite = CEE_TestUtility.getInvite('brief', true, briefing, presenter, agenda, null);
        CEE_TestUtility.simulatePresenterInvite(invite);
        
        //Get standard parameters
        Test.setCurrentPage(new PageReference(''));
        testRoot = Utilities.getConstant_CS('CEE Outlook URL');
        testEnv = Utilities.getConstant_CS('CEE Environment');
        
        Test.startTest();
        CEE_InviteList_Controller inviteController = new CEE_InviteList_Controller();
        inviteController.agendaItem = agenda;
        inviteController.objectName = 'Agenda_Item__c';
        inviteController.redirectUrl = '/'+agenda.Id;
        
        //Initialize controller
        inviteController.initInvites();
        inviteController.setInvites();
        inviteController.selectCriteria = 'All';
        inviteController.toggleIsUpdate();
        
        
        //Save invites
        inviteController.doSave();
        inviteController.saveTPInvites();   
        inviteController.selectCriteria = 'Rooms';
        inviteController.toggleIsUpdate();  
        inviteController.selectCriteria = 'People';
        inviteController.toggleIsUpdate();          
        inviteController.validateCheckbox();
       
        Test.stopTest();      
        
    }
}