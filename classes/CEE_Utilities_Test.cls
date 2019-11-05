/***************************************************************************************************
Name    : CEE_Utilities_Test 
Author  : Eric Pesch
Purpose : Tests for Utility classes 
Created Date: Dec 1 2014
Modification History: 
Eric Pesch - Jan 5 2015: Added Comments, cleanup                     
*****************************************************************************************************/

@isTest
private class CEE_Utilities_Test {       
    /*@method: Test for test data factory methods*/
    static testMethod void ceeTestUtilityTestA() {
        
        Test.startTest();
        User admin = CEE_TestUtility.getUser('admin', true);
        Account acct = null;
        Opportunity oppty = null;
        
        //Setup accounts and users
        System.runAs(admin){
            CEE_TestUtility.loadCustomSettings();
            acct = CEE_TestUtility.getAccount('brief', true);
        }
        Account_Executive_Sponsor__c esp = CEE_TestUtility.getAccountExecutiveSponsor('test', true);
        Presenter__c expertise = CEE_TestUtility.getExpertise('exp', true);
        
        //Setup location
        CEE_Location__c loc = CEE_TestUtility.getLocation('brief', true, 'EBC/EC');
        CEE_Location__c locB = CEE_TestUtility.getLocation('roomB', true, 'Non EBC/EC');
        Briefing_PM__c briefPM = CEE_TestUtility.getBriefingPM('pm', true, loc);
        CEE_Room__c room = CEE_TestUtility.getRoom('brief', true, loc, false, 6);
        CEE_Room__c roomB = CEE_TestUtility.getRoom('roomB', true, locB, false, 6);
        Test.stopTest();
    }
    
    /*@method: Test for test data factory methods*/
    static testMethod void ceeTestUtilityTestB() {
        User admin = CEE_TestUtility.getUser('admin', true);
        Account acct = null;
        Opportunity oppty = null;
        
        //Setup accounts and users
        System.runAs(admin){
            CEE_TestUtility.loadCustomSettings();
            acct = CEE_TestUtility.getAccount('brief', true);
        }
        Account_Executive_Sponsor__c esp = CEE_TestUtility.getAccountExecutiveSponsor('test', true);
        Presenter__c expertise = CEE_TestUtility.getExpertise('exp', true);
        
        //Setup location
        CEE_Location__c loc = CEE_TestUtility.getLocation('brief', true, 'EBC/EC');
        CEE_Location__c locB = CEE_TestUtility.getLocation('roomB', true, 'Non EBC/EC');
        Briefing_PM__c briefPM = CEE_TestUtility.getBriefingPM('pm', true, loc);
        CEE_Room__c room = CEE_TestUtility.getRoom('brief', true, loc, false, 6);
        CEE_Room__c roomB = CEE_TestUtility.getRoom('roomB', true, locB, false, 6);
        
        Test.startTest();
        //Setup briefing
        Opportunity opppt =  CEE_TestUtility.getOpty();
        CEE__c briefing = CEE_TestUtility.getBriefing('brief', true, 'OBX', acct, opppt, loc);
        
        //topics
        Topic__c topic = CEE_TestUtility.getTopic('brief', true, false);
        CEE_TestUtility.getOtherTopic();
        
        //Aux briefing items
        Agenda_Room__c agendaRoom = CEE_TestUtility.getAgendaRoom('brief', true, briefing, room);
        Briefing_Site__c siteB = CEE_TestUtility.getBriefingSite('siteB', true, briefing, locB); //insert alternate location
        Test.stopTest();
    }
    
    /*@method: Test 2 for test data factory methods*/
    static testMethod void ceeTestUtilityTestC() {
        User admin = CEE_TestUtility.getUser('admin', true);
        Account acct = null;
        Opportunity oppty = null;
        
        //Setup accounts and users
        System.runAs(admin){
            CEE_TestUtility.loadCustomSettings();
            acct = CEE_TestUtility.getAccount('brief', true);
        }
        Presenter__c expertise = CEE_TestUtility.getExpertise('exp', true);
        
        //Setup location
        CEE_Location__c loc = CEE_TestUtility.getLocation('brief', true, 'EBC/EC');
        CEE_Room__c room = CEE_TestUtility.getRoom('brief', true, loc, false, 6);
        
        //Setup briefing
        Opportunity opppt =  CEE_TestUtility.getOpty();
        CEE__c briefing = CEE_TestUtility.getBriefing('brief', true, 'OBX', acct, opppt, loc);
        
        //topics
        Topic__c topic = CEE_TestUtility.getTopic('brief', true, false);
        CEE_TestUtility.getOtherTopic();
        
        //Aux briefing items
        Agenda_Room__c agendaRoom = CEE_TestUtility.getAgendaRoom('brief', true, briefing, room);
        
        Test.startTest();
        //Setup agenda item
        Agenda_Item__c agenda = CEE_TestUtility.getAgendaItem('brief', true, briefing, loc, agendaRoom, topic);
        
        //Setup Presenter
        CEE_Attendee__c presenter = CEE_TestUtility.getAttendee('brief', true, briefing, agenda, true);
        CEE_Invite__c invite = CEE_TestUtility.getInvite('brief', true, briefing, presenter, agenda, null);
        CEE_TestUtility.simulatePresenterInvite(invite);
        
        //Get room invite
        try{
            CEE_Invite__c roomInvite = [select Id, Name from CEE_Invite__c where Room__c =: agendaRoom.Id limit 1];
            CEE_TestUtility.simulateRoomInvite(invite, false, true);
        } catch (Exception e){
            System.debug('CEE_Utilities_Test - issue getting room invite');
        }
        List<Org_Constant_CS__c> orgConstant = new List<Org_Constant_CS__c>();
        orgConstant.add(new Org_Constant_CS__c(Name='HRMS AD Url',Non_Production_Value__c='https://wsgx.cisco.com/ccw/presence/services/PresenceService/',Production_Value__c='https://wsgx.cisco.com/ccw/presence/services/PresenceService/'));
        orgConstant.add(new Org_Constant_CS__c(Name='HRMS AD User Name',Non_Production_Value__c='ccwprs.gen',Production_Value__c='ccwprs.gen'));
        orgConstant.add(new Org_Constant_CS__c(Name='HRMS AD Password',Non_Production_Value__c='ccw123*@#',Production_Value__c='ccw123*@#'));
        insert orgConstant;
        CEE_Utility.calcSiteTime(briefing,datetime.now());       
        presenter.Salesforce_User__c = null;
        presenter.Name ='test123';
        presenter.email__c = 'supitcha@cisco.com';
        update presenter;
        list<id> lstAttId= new list<Id>();
        lstAttId.add(presenter.Id);
        CEE_Utility.updateTitleName(lstAttId);
        
        Test.stopTest();
    }
    
    /*@method: test for Utility dates*/
    static testMethod void ceeUtilityGetMonthDaysTest(){
        Integer year = 2014;
        Integer month = 1;
        Integer day = 1;
        DateTime currDate = DateTime.newInstance(year, month, day);
        List<String> monthDayJanuaryShell = new List<String>();
        List<String> monthDayJanuary = new List<String>();
        
        Test.startTest();
        monthDayJanuaryShell = CEE_Utility.getMonthDays(year, month);
        monthDayJanuary = CEE_Utility.getMonthDays(currDate);               
        Test.stopTest();
        
        //System.assertEquals(monthDayJanuaryShell, monthDayJanuary);
        //System.assertEquals(Date.daysInMonth(year, month), monthDayJanuary.size());
        //System.assertEquals( DateTime.newInstance(year, month, 1).format('E').subString(0,2), monthDayJanuary[0]); 
    }
    
    /*@method: test for Utility date conversions*/
    static testMethod void ceeUtilityUTCTests(){
        Integer year = 2014, month = 1, day = 1;
        TimeZone userZone = TimeZone.getTimeZone('Africa/Abidjan'); //UTC +0
        TimeZone baseZone = TimeZone.getTimeZone('Pacific/Midway'); //UTC -11
        DateTime currDate = DateTime.newInstanceGMT(year, month, day);
        DateTime adjDate = currDate.addSeconds(baseZone.getOffset(currDate)/1000);
        String utcTime = '(UTC-11:00) Samoa Standard Time (Pacific/Pago_Pago)';
        
        test.startTest();
        String convertZone = CEE_Utility.convertUTCtoTZ(utcTime);
        DateTime convertTimeA = CEE_Utility.convertUserTimeToUTC(currDate, userZone, baseZone);
        DateTime convertTimeB = CEE_Utility.convertUserTimeToUTC(currDate, userZone, utcTime);
        DateTime convertTimeC = CEE_Utility.convertUserTimeToUTC(currDate, userZone, baseZone.getOffset(currDate));
        
        test.stopTest();
        
        //System.assertEquals('Pacific/Midway', convertZone);
        //System.assertEquals(adjDate, convertTimeA);
        //System.assertEquals(convertTimeA, convertTimeB);
        //System.assertEquals(convertTimeB, convertTimeC);
    }
}