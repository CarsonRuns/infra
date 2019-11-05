/***************************************************************************************************
Name    : CEEAttendeeBeforeDelete_Test 
Author  : Eric Pesch
Purpose : Trigger Tests for the CEE Attendee object  
Created Date: Dec 1 2014
Modification History: 
Eric Pesch - Jan 5 2015: Added Comments, cleanup                     
*****************************************************************************************************/

@isTest
private class CEEAttendeeBeforeDelete_Test {
    
    /*@method: Attendee deletion test*/
    static testMethod void attendeeDelete() {
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
        //CEE_Room__c room = CEE_TestUtility.getRoom('brief', true, loc, false, 6);
        
        //Setup briefing
        Opportunity opppt =  CEE_TestUtility.getOpty();
        CEE__c briefing = CEE_TestUtility.getBriefing('brief', true, 'OBX', acct, opppt, loc);
        Topic__c topic = CEE_TestUtility.getTopic('brief', true, false);
        //Agenda_Room__c agendaRoom = CEE_TestUtility.getAgendaRoom('brief', true, briefing, room);
        
        
        //Setup agenda item
        Agenda_Item__c agenda = CEE_TestUtility.getAgendaItem('brief', true, briefing, loc, null, topic);
        //Agenda_Item__c agenda1 = CEE_TestUtility.getAgendaItem('brief1', true, briefing, loc, null, topic); 
        //Setup Presenter
        CEE_Attendee__c presenter = CEE_TestUtility.getAttendee('brief', true, briefing, agenda, true);
        CEE_Invite__c invite = CEE_TestUtility.getInvite('brief', true, briefing, presenter, agenda, null);
        CEE_Invite__c invite1 = CEE_TestUtility.getInvite('brief', true, briefing, presenter, agenda, null);
        invite1.Outlook_Status__c = 'Accepted';
        update invite1;
        CEE_TestUtility.simulatePresenterInvite(invite);
        
        Test.startTest();
        //Exception - has Outlook invite active
        try{
            //delete presenter;
        } catch (Exception e){}
        
        invite.Outlook_Status__c = 'Accepted';
        update invite;
        
        //Succeed
        //delete presenter;
        Test.stopTest();
        
        //Check if presenter was deleted
        //System.assert(true, presenter.Id != null);
        //Check linkage is maintained between Invite and Presenter
        //System.assertEquals(invite.CEE_Attendee__c, presenter.Id);
    }
      /*@method: Attendee deletion test*/
    static testMethod void attendeeUpdate() {
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
        //CEE_Room__c room = CEE_TestUtility.getRoom('brief', true, loc, false, 6);
        
        //Setup briefing
        Opportunity opppt =  CEE_TestUtility.getOpty();
        CEE__c briefing = CEE_TestUtility.getBriefing('brief', true, 'OBX', acct, opppt, loc);
        Topic__c topic = CEE_TestUtility.getTopic('brief', true, false);
        //Agenda_Room__c agendaRoom = CEE_TestUtility.getAgendaRoom('brief', true, briefing, room);
        
        
        //Setup agenda item
        Agenda_Item__c agenda = CEE_TestUtility.getAgendaItem('brief', true, briefing, loc, null, topic);
        
        //Setup Presenter
        CEE_Attendee__c presenter = CEE_TestUtility.getAttendee('brief', true, briefing, agenda, true);
        CEE_Invite__c invite = CEE_TestUtility.getInvite('brief', true, briefing, presenter, agenda, null);
        CEE_TestUtility.simulatePresenterInvite(invite);
        
        Test.startTest();
        //Exception - has Outlook invite active
        try{
            delete presenter;
        } catch (Exception e){}
        
        invite.Outlook_Invite_ID__c = 'null';
        update invite;
        
        //Succeed
        delete presenter;
        Test.stopTest();
        
        //Check if presenter was deleted
        //System.assert(true, presenter.Id != null);
        //Check linkage is maintained between Invite and Presenter
        //System.assertEquals(invite.CEE_Attendee__c, presenter.Id);
    }
}