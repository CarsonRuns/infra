/***************************************************************************************************
Name    : addPresenterToAccountTeam_Test 
Author  : Kathleen Gannon
Purpose : Trigger Tests for the Account_Executive_Sponsor__c object  
Created Date: Dec 1 2014
Modification History: 
Eric Pesch - Dec 4 2014: Converted to CEE_TestUtility record creation
Eric Pesch - Jan 5 2015: Added Comments, cleanup
Jay Dash - Aug 8 2015 : Added for getOpty()                     
*****************************************************************************************************/

@isTest
private class addPresenterToAccountTeam_Test {

    /* @method: Test to add a Presenter to the Account team */
    static testMethod void addAttendee() {
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
        delete presenter;       
        Test.stopTest();
    }
     /* @method: Test to add a Presenter to the Account team */
    static testMethod void addAttendee1() {
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
        presenter.salesforce_user__c = null;
        presenter.Email__c = 'test@cisco.com';
        presenter.Name= 'test';
        update presenter;
        delete presenter;       
        Test.stopTest();
    }
}