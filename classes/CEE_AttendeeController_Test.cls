/***************************************************************************************************
Name    : CEE_AttendeeController_Test 
Author  : Eric Pesch
Purpose : Test for the custom VF page for CEE Attendee edit
Created Date: Dec 1 2014
Modification History: 
Eric Pesch - Jan 5 2015: Added Comments, cleanup   
Jay Dash - Aug 8 2015 : And added getOpty()    
Aditya S - June 6 2017 : Added test method to test shadow functionality in CEE_AttendeeController
*****************************************************************************************************/

@isTest
private class CEE_AttendeeController_Test {
    
    /*@method: Test for creating a new CEE Attendee*/
    static testMethod void ceeAttendeeTestNew() {
        //Setup Account
        User admin = CEE_TestUtility.getUser('admin', true);
        Account acct = null;
        Opportunity oppty = null;
        CEE_Location__c loc = null;
        CEE_Room__c room = null;
        Opportunity opppt =  null;
        
        System.runAs(admin){
            CEE_TestUtility.loadCustomSettings();
            acct = CEE_TestUtility.getAccount('brief', true);
        
        
        //Setup location
        loc = CEE_TestUtility.getLocation('brief', true, 'EBC/EC');
        room = CEE_TestUtility.getRoom('brief', true, loc, false, 6);
        
        //Setup briefing
        opppt =  CEE_TestUtility.getOpty();
        }
        CEE__c briefing = CEE_TestUtility.getBriefing('brief', true, 'OBX', acct, opppt, loc);
        Topic__c topic = CEE_TestUtility.getTopic('brief', true, false);
        Agenda_Room__c agendaRoom = CEE_TestUtility.getAgendaRoom('brief', true, briefing, room);
        
        
        //Setup agenda item
        Agenda_Item__c agenda = CEE_TestUtility.getAgendaItem('brief', true, briefing, loc, agendaRoom, topic);
        
        //Setup Presenter
        CEE_Attendee__c presenter = CEE_TestUtility.getAttendee('brief', false, briefing, agenda, true);
        
        ApexPages.StandardController stdItem = new ApexPages.StandardController(presenter);
        
        Test.startTest();
        CEE_AttendeeController attendeeController = new CEE_AttendeeController(stdItem);
        
        //Utility methods
        attendeeController.checkType();
        attendeeController.popUser();
        
        //Save
        attendeeController.doSaveNew();
        Test.stopTest();
    }
    
    /*@method: Test method for creating a non-SFDC User CEE Attendee*/
    static testMethod void ceeAttendeeNonSFDCTest() {
        //Setup Account
        User admin = CEE_TestUtility.getUser('admin', true);
        Account acct = null;
        Opportunity oppty = null;
        CEE_Location__c loc = null;
        CEE_Room__c room = null;
        Opportunity opppt =  null;
        
        System.runAs(admin){
            CEE_TestUtility.loadCustomSettings();
            acct = CEE_TestUtility.getAccount('brief', true);
        
        
        //Setup location
        loc = CEE_TestUtility.getLocation('brief', true, 'EBC/EC');
        room = CEE_TestUtility.getRoom('brief', true, loc, false, 6);
        
        //Setup briefing
        opppt =  CEE_TestUtility.getOpty();
       }
        CEE__c briefing = CEE_TestUtility.getBriefing('brief', true, 'OBX', acct, opppt, loc);
        Topic__c topic = CEE_TestUtility.getTopic('brief', true, false);
        Agenda_Room__c agendaRoom = CEE_TestUtility.getAgendaRoom('brief', true, briefing, room);
        
        
        //Setup agenda item
        Agenda_Item__c agenda = CEE_TestUtility.getAgendaItem('brief', true, briefing, loc, agendaRoom, topic);
        
        //Setup Presenter
        CEE_Attendee__c presenter = CEE_TestUtility.getAttendee('brief', false, briefing, agenda, false);
        
        ApexPages.StandardController stdItem = new ApexPages.StandardController(presenter);
        
        Test.startTest();
        CEE_AttendeeController attendeeController = new CEE_AttendeeController(stdItem);
        
        //Utility methods
        attendeeController.checkType();
        attendeeController.popUser();
        attendeeController.getAgendaOptions();
        //Save
        attendeeController.doSaveNew();
        Test.stopTest();
    }
    
    /*@method: Test for updating an old CEE Attendee*/
    static testMethod void ceeAttendeeTest() {
        //Setup Account
        User admin = CEE_TestUtility.getUser('admin', true);
        Account acct = null;
        Opportunity oppty = null;
        CEE_Location__c loc = null;
        CEE_Room__c room = null;
        Opportunity opppt =  null;
        
        System.runAs(admin){
            CEE_TestUtility.loadCustomSettings();
            acct = CEE_TestUtility.getAccount('brief', true);
        
        
        //Setup location
       loc = CEE_TestUtility.getLocation('brief', true, 'EBC/EC');
       room = CEE_TestUtility.getRoom('brief', true, loc, false, 6);
        
        //Setup briefing
       opppt =  CEE_TestUtility.getOpty();
       }
        CEE__c briefing = CEE_TestUtility.getBriefing('brief', true, 'OBX', acct, opppt, loc);
        Topic__c topic = CEE_TestUtility.getTopic('brief', true, false);
        //Agenda_Room__c agendaRoom = CEE_TestUtility.getAgendaRoom('brief', true, briefing, room);
                
        //Setup agenda item
        Agenda_Item__c agenda = CEE_TestUtility.getAgendaItem('brief', true, briefing, loc, null, topic);
        
        //Setup Presenter
        Test.startTest();
        CEE_Attendee__c presenter = CEE_TestUtility.getAttendee('brief', true, briefing, agenda, true);
        CEE_Invite__c invite = CEE_TestUtility.getInvite('brief', true, briefing, presenter, agenda, null);
        CEE_TestUtility.simulatePresenterInvite(invite);
        
        
        ApexPages.StandardController stdItem = new ApexPages.StandardController(presenter);
        
        
        CEE_AttendeeController attendeeController = new CEE_AttendeeController(stdItem);
        
        //Utility methods
        attendeeController.checkType();
        attendeeController.popUser();
        
        
        //Save
        attendeeController.doSave();
        attendeeController.doCancel_Light();
        
        //Exceptiion saves
        presenter.Type__c = 'Customer';
        attendeeController.doSave();
        Test.stopTest();
    }
    
    /*@method: Test for Shadow functionality*/
    static testMethod void ceeShadowAttendeeTest() {
        User admin = CEE_TestUtility.getUser('admin', true);
        Account acct = null;
        Opportunity oppty = null;
        CEE_Location__c loc = null;
        CEE_Room__c room = null;
        Opportunity opppt =  null;
        
        System.runAs(admin){
            CEE_TestUtility.loadCustomSettings();
            acct = CEE_TestUtility.getAccount('brief', true);
        
        
        //Setup location
        loc = CEE_TestUtility.getLocation('brief', true, 'EBC/EC');
        room = CEE_TestUtility.getRoom('brief', true, loc, false, 6);
        
        //Setup briefing
        opppt =  CEE_TestUtility.getOpty();
        }
        CEE__c briefing = CEE_TestUtility.getBriefing('brief', true, 'OBX', acct, opppt, loc);
        Topic__c topic = CEE_TestUtility.getTopic('brief', true, false);
        Agenda_Room__c agendaRoom = CEE_TestUtility.getAgendaRoom('brief', true, briefing, room);
        
        
        //Setup agenda item
        Agenda_Item__c agenda = CEE_TestUtility.getAgendaItem('brief', true, briefing, loc, agendaRoom, topic);
        
        //creating a new attendee who is a shadower
        CEE_Attendee__c shadower = new CEE_Attendee__c();
        
        //Testing starts here
        Test.startTest();
        
        //get the sample presenter created for testing purpose
        CEE_Attendee__c presenter = CEE_TestUtility.getAttendee('brief', true, briefing, agenda, true);
        
        //create a shadow user for test purpose
        CEE_Attendee__c presenterShadower = CEE_TestUtility.getAttendee('brf', true, briefing, agenda, true);
        
        //creating a user with shadow permission set 
        User shadowUser = [select Alias from User where Id=:presenterShadower.Salesforce_User__c limit 1];
        System.runAs(admin) {
            try{
                PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'CEE_Shadow'];
                PermissionSetAssignment psa = new PermissionSetAssignment();
                psa.AssigneeId = shadowUser.Id;
                psa.PermissionSetId = ps.Id;
                insert psa;
            }
            catch(Exception e)
            {
                System.debug(e.getStackTraceString());
            }
        }
        
        ApexPages.StandardController stdAttendeeCtrl = new ApexPages.StandardController(shadower);
        
        //get the CEE Attendee visualforce page reference and set the url parameters
        PageReference attendeePageRef = Page.CEE_Attendee_Edit;
        Test.setCurrentPage(attendeePageRef);
        ApexPages.currentPage().getParameters().put('type', 'Shadow');
        ApexPages.currentPage().getParameters().put('presenter' , presenter.Id);
        
        List<CEE_Attendee__c> shadowerList= new List<CEE_Attendee__c>();
        shadowerList.add(presenterShadower);
        CEE_AttendeeController attendeeController;
        
        //initiate the CEE Attendee Controller
        System.runAs(shadowUser)
        {
            attendeeController = new CEE_AttendeeController(stdAttendeeCtrl);
          
            System.assertEquals(attendeeController.attendee.Salesforce_User__c,UserInfo.getUserId());
            
            //Check the shadow limit for a presenter
            Boolean shadowLimit = attendeeController.isShadowLimitExceeded(attendeeController.attendee);
            System.assertEquals(shadowLimit,false);
            
            //Check for duplicate shadow sessions
            Boolean isDuplicateSession = attendeeController.isDuplicateShadowSession(shadowerList);
            System.assertEquals(true,isDuplicateSession);
        }
        System.assertEquals(attendeeController.enableShadow,true);
        System.assertEquals(attendeeController.attendee.Customer_Engagement_Events__c,presenter.Customer_Engagement_Events__c);
        System.assertEquals(attendeeController.attendee.Agenda_Item__c,presenter.Agenda_Item__c);
        System.assertEquals(attendeeController.attendee.Type__c,'Shadow');
        System.assertEquals(attendeeController.attendee.Presenter_User__c,presenter.Salesforce_User__c);
        
        Test.stopTest();
    }
}