/***************************************************************************************************
Name    : CEE_IframeUtility_Test 
Author  : Eric Pesch
Purpose : Tests for the Iframe CEE Utility class methods  
Created Date: Dec 1 2014
Modification History: 
Eric Pesch - Jan 5 2015: Added Comments, cleanup    
Jay Dash - Aug 8 2015 : code cleanup and added getOpty()                    
*****************************************************************************************************/

@isTest
private class CEE_IframeUtility_Test {

    /*@method: Test suite 1 - Iframe Parameter generation*/
    static testMethod void iframeUtilityTest() {
        //rundown of all methods
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
        Test.startTest();
        Agenda_Room__c agendaRoom = CEE_TestUtility.getAgendaRoom('brief', true, briefing, room);
        Test.stopTest();
        //Agenda_Item__c agenda = CEE_TestUtility.getAgendaItem('brief', true, briefing, loc, agendaRoom, topic);
        CEE_Attendee__c presenter = CEE_TestUtility.getAttendee('brief', true, briefing, null, true);       
       
        
        //Basic keys
        CEE_IframeUtility.addBriefingSearchKeys(briefing);
        //CEE_IframeUtility.addAgendaSearchKeys(agenda);
        CEE_IframeUtility.addLocationSearchKeys(loc);
        //CEE_IframeUtility.addPresenterSearchKeys(presenter);
        
        //Briefing times
        CEE_IframeUtility.addBriefingDates(briefing, 'America/Los_Angeles');
        CEE_IframeUtility.addBriefingTimes(briefing, 'America/Los_Angeles');
        //CEE_IframeUtility.addAgendaDates(agenda, 'America/Los_Angeles');
        //CEE_IframeUtility.addAgendaTimes(agenda, 'America/Los_Angeles');
        CEE_IframeUtility.addPermissions();
        
        //Misc. Commands
        
        
    }
    
    /*@method: Test suite 1 - Iframe Parameter generation*/
    static testMethod void iframeUtilityTest2() {
        //rundown of all methods
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
        Test.startTest();
        CEE_Attendee__c presenter = CEE_TestUtility.getAttendee('brief', true, briefing, agenda, true);
        CEE_Invite__c invite = CEE_TestUtility.getInvite('brief', true, briefing, presenter, agenda, null);
        CEE_Invite__c inviteB = CEE_TestUtility.getInvite('brief', true, briefing, null, null, agendaRoom);
        CEE_TestUtility.simulatePresenterInvite(invite);
        
        
        
        //Basic keys
        //CEE_IframeUtility.addBriefingSearchKeys(briefing);
        CEE_IframeUtility.addAgendaSearchKeys(agenda);
        //CEE_IframeUtility.addLocationSearchKeys(loc);
        CEE_IframeUtility.addPresenterSearchKeys(presenter);
        
        //Invite keys
        Map<String, Object> params = new Map<String, Object>();
        params.put('command','agenda_item_invite');
        params.putAll(CEE_IframeUtility.addPrimaryTimezone(briefing));
        params.putAll(CEE_IframeUtility.addAgendaItemInviteKeys(agenda, 'America/Los_Angeles'));
        //NA6 Split changes
        params.putAll(CEE_IframeUtility.addEnvironment(URL.getSalesforceBaseUrl().getHost()));
        briefing.Program_Manager__c = UserInfo.getUserId();
        update briefing;
        CEE_IframeUtility.addBriefingInviteKeys(briefing, true, true, 'America/Los_Angeles');
        CEE_IframeUtility.addInvitations('Modify', 
                            (String)params.get('emailID'),
                            (String)params.get('searchInvitation'), 
                            (String)params.get('searchType'));

        //Briefing times
        //CEE_IframeUtility.addBriefingDates(briefing, 'America/Los_Angeles');
        //CEE_IframeUtility.addBriefingTimes(briefing, 'America/Los_Angeles');
        CEE_IframeUtility.addAgendaDates(agenda, 'America/Los_Angeles');
        CEE_IframeUtility.addAgendaTimes(agenda, 'America/Los_Angeles');
        //CEE_IframeUtility.addPermissions();
        
        //Misc. Commands
        
        Test.stopTest();
    }
}