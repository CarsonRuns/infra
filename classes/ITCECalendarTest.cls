/****************************************************************************
 * Name : ITCECalendarTest
 * Description : Test class for ITCECalendarCtrl
 * Author : Aditya S
 * Created Date : 6/6/2017
 ****************************************************************************/ 
@isTest
private class ITCECalendarTest{
    
    
    //function to test the presenter view in calendar
    @isTest
    static void testPresenterView()
    {
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
        
        
        //Testing starts here
        Test.startTest();
        
        //get the sample presenter created for testing purpose
        CEE_Attendee__c presenter = CEE_TestUtility.getAttendee('brief', true, briefing, agenda, true);
        User presenterUsr = [select Alias from User where Id=:presenter.Salesforce_User__c limit 1];
        String presenterAlias = presenterUsr.Alias;
        
        //run the ITCECalendarCtrl code as a presenter
        System.runAs(presenterUsr)
        {
        	ITCECalendarCtrl calendarCtrl = new ITCECalendarCtrl();
            
            //ensuring that for a presenter the following values are always false
            System.assertEquals(false,calendarCtrl.isShadower);
            System.assertEquals(false,calendarCtrl.isPmScheduler);
            
            ITCECalendarCtrl.ITCEWrapper wrapper;
            wrapper = calendarCtrl.loadCalendarData(presenterAlias, 'All Requests', 'presenter');
            

            //ensuring that the right record is fetched in soql with all the necessary content
            System.assertEquals(1,calendarCtrl.IDlistq.size());
            System.assertEquals(briefing.Name,calendarCtrl.IDlistq[0].Customer_Engagement_Events__r.Name);
            System.assertEquals(briefing.Name,calendarCtrl.sessions[0].Customer_Engagement_Events__r.Name);
            System.assertEquals(presenter.Id,calendarCtrl.sessions[0].Id);
            
            //ensure that a presenter can never have 'My Assigned Requests'
            ITCECalendarCtrl.ITCEWrapper wrapperMy;
            wrapperMy = calendarCtrl.loadCalendarData(presenterAlias, 'My Assigned Requests', 'presenter');
            System.assertEquals(1,calendarCtrl.IDlistq.size());
            System.assertEquals(briefing.Name,calendarCtrl.IDlistq[0].Customer_Engagement_Events__r.Name);
            System.assertEquals(briefing.Name,calendarCtrl.sessions[0].Customer_Engagement_Events__r.Name);
            System.assertEquals(presenter.Id,calendarCtrl.sessions[0].Id);
            
            //ensure that a presenter can access only his/her engagements
            ITCECalendarCtrl.ITCEWrapper wrapperOther;
            wrapperOther = calendarCtrl.loadCalendarData('other', 'All Requests', 'presenter');
            System.assertEquals(1,calendarCtrl.IDlistq.size());
            System.assertEquals(briefing.Name,calendarCtrl.IDlistq[0].Customer_Engagement_Events__r.Name);
            System.assertEquals(briefing.Name,calendarCtrl.sessions[0].Customer_Engagement_Events__r.Name);
            System.assertEquals(presenter.Id,calendarCtrl.sessions[0].Id);
            
            
            
        }
        
        Test.stopTest();
       
    }
    
    //function to test the PM view in calendar
    @isTest
    static void testPMView()
    {
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
        

        //Testing starts here
        Test.startTest();
        
        //get the sample presenter created for testing purpose
        CEE_Attendee__c presenter = CEE_TestUtility.getAttendee('brief', true, briefing, agenda, true);
        User presenterUsr = [select Alias from User where Id=:presenter.Salesforce_User__c limit 1];
        String presenterAlias = presenterUsr.Alias;
        
        //creating a user with PM Scheduler permission set 
        User PMUser = CEE_TestUtility.getUser('pm',true);
        System.runAs(admin) {
            try{
				PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'CEE_Scheduler_Program_Manager'];
				PermissionSetAssignment psa = new PermissionSetAssignment();
        		psa.AssigneeId = PMUser.Id;
        		psa.PermissionSetId = ps.Id;
        		insert psa;
            }
            catch(Exception e)
            {
                System.debug(e.getStackTraceString());
            }
		}
        
        //run the ITCECalendarCtrl code as a PM Scheduler
        ITCECalendarCtrl calendarCtrl;
        System.runAs(PMUser)
        {
            
        	calendarCtrl = new ITCECalendarCtrl();
            ITCECalendarCtrl.ITCEWrapper wrapperAll;
            ITCECalendarCtrl.ITCEWrapper wrapperMy;
            
            //ensuring that for PM scheduler the following value is set to true
            System.assertEquals(true,calendarCtrl.isPmScheduler);
            
            //check for PM view with All Requests
            wrapperAll = calendarCtrl.loadCalendarData(presenterAlias, 'All Requests', 'presenter');
            System.assertEquals(1,calendarCtrl.IDlistq.size());
            System.assertEquals(briefing.Name,calendarCtrl.IDlistq[0].Customer_Engagement_Events__r.Name);
            System.assertEquals(briefing.Name,calendarCtrl.sessions[0].Customer_Engagement_Events__r.Name);
            System.assertEquals(presenter.Id,calendarCtrl.sessions[0].Id);
            
            //check for PM view with requests Assigned to the PM
            wrapperMy = calendarCtrl.loadCalendarData(presenterAlias, 'My Assigned Requests', 'presenter');
            System.assertEquals(0,calendarCtrl.IDlistq.size());
        }
        
        
        Test.stopTest();
       
    }
    
    //function to test the Shadow view in calendar
    @isTest
    static void testShadowView()
    {
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
        
        //Testing starts here
        Test.startTest();
       
        //get the sample presenters created for testing purpose
        CEE_Attendee__c presenter = CEE_TestUtility.getAttendee('brief', true, briefing, agenda, true);
        CEE_Attendee__c presenterShadower = CEE_TestUtility.getAttendee('briefs', true, briefing, agenda, true);
        User presenterUsr = [select Alias from User where Id=:presenter.Salesforce_User__c limit 1];
        String presenterAlias = presenterUsr.Alias;
        User presenterShadowUsr = [select Alias from User where Id=:presenterShadower.Salesforce_User__c limit 1];
        String presenterShadowerAlias = presenterShadowUsr.Alias;
        
        //adding the shadow permission set to the shadow user
        System.runAs(admin) {
            try{
				PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'CEE_Shadow'];
				PermissionSetAssignment psa = new PermissionSetAssignment();
        		psa.AssigneeId = presenterShadowUsr.Id;
        		psa.PermissionSetId = ps.Id;
        		insert psa;
            }
            catch(Exception e)
            {
                System.debug(e.getStackTraceString());
            }
		}
        try
        {
            //Setting the Briefing Center Custom Settings
            ITCE_Calendar_Parameters__c itceSettingsBriefing = new ITCE_Calendar_Parameters__c();
            itceSettingsBriefing.Name = 'briefingcenter1';
            itceSettingsBriefing.Briefing_Center__c = loc.Name;
            insert itceSettingsBriefing;
        }
        catch(Exception e)
        {
            System.debug(e.getStackTraceString());
        }
        //run the ITCECalendarCtrl code as a Shadow user
        ITCECalendarCtrl calendarCtrl;
        System.runAs(presenterShadowUsr)
        {
            
        	calendarCtrl = new ITCECalendarCtrl();
            ITCECalendarCtrl.ITCEWrapper wrapperPresenterTab;
            ITCECalendarCtrl.ITCEWrapper wrapperShadowTab;
            ITCECalendarCtrl.ITCEWrapper wrapperPresenterTabMy;
            ITCECalendarCtrl.ITCEWrapper wrapperShadowTabMy;
            
            //ensuring that for a shadower the following variable is always set to true
            System.assertEquals(true,calendarCtrl.isShadower);
            
            //check for Shadower and in Presenter View Tab 
            wrapperPresenterTab = calendarCtrl.loadCalendarData(presenterShadowerAlias, 'All Requests', 'presenter');
            System.assertEquals(1,calendarCtrl.IDlistq.size());
            System.assertEquals(briefing.Name,calendarCtrl.IDlistq[0].Customer_Engagement_Events__r.Name);
            System.assertEquals(2,calendarCtrl.sessions.size());
            
            //check for Shadower and in Shadow View Tab
            wrapperShadowTab = calendarCtrl.loadCalendarData(presenterAlias, 'All requests', 'shadower');
          	System.assertEquals(1,calendarCtrl.IDlistq.size());
            System.assertEquals(briefing.Name,calendarCtrl.IDlistq[0].Customer_Engagement_Events__r.Name);
            System.assertEquals(2,calendarCtrl.sessions.size());
            
            //Ensure that Shadower can never have 'My Assigned Requests'
            wrapperPresenterTabMy = calendarCtrl.loadCalendarData(presenterShadowerAlias, 'My Assigned Requests', 'presenter');
			System.assertEquals(1,calendarCtrl.IDlistq.size());
            System.assertEquals(briefing.Name,calendarCtrl.IDlistq[0].Customer_Engagement_Events__r.Name);
            System.assertEquals(2,calendarCtrl.sessions.size());
            
            wrapperShadowTabMy = calendarCtrl.loadCalendarData(presenterAlias, 'My Assigned Requests', 'shadower');
            System.assertEquals(1,calendarCtrl.IDlistq.size());
            System.assertEquals(briefing.Name,calendarCtrl.IDlistq[0].Customer_Engagement_Events__r.Name);
            System.assertEquals(2,calendarCtrl.sessions.size());
            
        }
        
        
        Test.stopTest();
       
    }
}