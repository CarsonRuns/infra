/************************************************************************************************************************************
Name    : JiffleNowReporting_Emails_Batchable_Test 
Author  : Mukesh Srivastava
Purpose : This Test class to perform Reconcile Email generation and Reporting Updates
Created Date: 5/25/2015
Modification History: 
	Author  : Ghattamaneni Chaithanya
	Purpose : test Custom setting records are added to fix test class failure line no# 20-24
	Date	: 17-May-2019
*************************************************************************************************************************************/
@isTest
public class JiffleNowReporting_Emails_Batchable_Test {
    //Setting Up data for This test class
    @testSetup static void setupTestData() {
        List < sObject > cUsers = Test.loadData(User.sObjectType,'GlobalTestUsers');
        List < User > userlist = (List < User > ) cUsers;
        system.debug('userlist[0]'+userlist[0].profileId);
        System.RunAs(userlist[0]){
            
        // Added by gchaitha to fix test failure
        ProfileID__c ProfileIDObj = new ProfileID__c();
        ProfileIDObj.SetupOwnerId = UserInfo.getOrganizationId();
        ProfileIDObj.Cisco_Renewals__c = 'test';
        insert ProfileIDObj;
            
        CEE_TestUtility.loadCustomSettings();           
        //List < sObject > cOrgCS = Test.loadData(Org_Constant_CS__c.sObjectType, 'GlobalTestOrgConstantCS');
        List < sObject > cOrgConstantObject = Test.loadData(Org_Constants__c.sObjectType, 'OrgConstants');
       // List < sObject > cObjRecId = Test.loadData(ObjectRecordTypeIds__c.sObjectType, 'GlobalTestObjectRecordTypeIds');
        List < sObject > cMappings = Test.loadData(NGCC_Mapping_Object__c.sObjectType, 'GlobalTestMapping');
        List < sObject > cAccounts = Test.loadData(Account.sObjectType, 'GlobalTestAccounts');
        List < sObject > cEvents = Test.loadData(Jiffle_Event__c.sObjectType, 'GlobalTestEvents');
        
       
        GlobalTriggerManagement__c gm = new GlobalTriggerManagement__c();
        gm.Name = 'JiffleR1_CEE';
        gm.Active__c = false;
        insert gm;
        
        List < Account > alist = (List < Account > ) cAccounts;
        List < Jiffle_Event__c > evtlist = (List < Jiffle_Event__c > ) cEvents;
        List < Jiffle_Agenda_Item__c> agendalist = new List < Jiffle_Agenda_Item__c> ();
        
        Integer j = 0;
        for (Jiffle_Event__c jfEObj: evtlist) {
            if (j == 0) { //Before Event
                jfEObj.Event_Start_Date__c = date.today();
                jfEObj.Event_End_Date__c = date.today() + 5;
            } else if (j == 1) { //After Event
                jfEObj.Event_Start_Date__c = date.today() - 32;
                jfEObj.Event_End_Date__c = date.today() - 29;
                Integer daysAfterEvent = jfEObj.Event_End_Date__c.daysBetween(System.today());
                system.debug('fffffff'+daysAfterEvent);
            } else {
                jfEObj.Event_Start_Date__c = date.today() - (j + 4);
                jfEObj.Event_End_Date__c = date.today() - (j + 2);
            }
            Jiffle_Agenda_Item__c jfAgenda = new Jiffle_Agenda_Item__c();
            jfAgenda.Name = 'Agenda' + j;
            jfAgenda.Jiffle_Event__c = jfEObj.Id;
            agendalist.add(jfAgenda);
            j++;
        }

        update evtlist;
        system.debug('ttttttt'+evtlist);
        insert agendalist;

        List < CEE__c > lstCEE = new List < CEE__c > ();
        List < Opportunity > lstOppty = new List < Opportunity > ();

        Id idOfJiffleRec = Schema.SObjectType.CEE__c.getRecordTypeInfosByName().get('Jifflenow (Event, Tradeshow, Conference)').getRecordTypeId();
        Integer i = 0;
        Date vCloseDate = System.today();
        List< Jiffle_Meeting_Session__c> meetingList = new List< Jiffle_Meeting_Session__c>();
        
        for (Account accObj: alist) {
            CEE__c ceeObj = new CEE__c();
            ceeObj.Primary_Account__c = accObj.Id;
            ceeObj.Jiffle_Event__c = evtlist[i].Id;
            ceeObj.RecordTypeId = idOfJiffleRec;
            lstCEE.add(ceeObj);

            Opportunity opptyObj = new Opportunity(Name = 'Test1' + i, StageName = '1 - Identify', CloseDate = vCloseDate,
                Expected_Product__c = 10, Forecast_Discount__c = 1, CurrencyIsoCode = UserInfo.getDefaultCurrency(),
                AccountId = accObj.Id, Competitors__c = 'Allot', Has_Competitors__c = true, Opportunity_Status__c = 'Booked',skipValidations__c = true,Partner_Required__c =false);
            lstOppty.add(opptyObj);
            
            Jiffle_Meeting_Session__c jfMeeting=new Jiffle_Meeting_Session__c();
            jfMeeting.Jiffle_Agenda_Item__c = agendalist[i].Id;
            jfMeeting.Meeting_UUID__c = 'UUID'+i;
            meetingList.add(jfMeeting);
            
            i = i + 1;
        }
        insert lstCEE;
        insert lstOppty;
        insert meetingList;
        
        List<CEE__c> ceels = [Select Jiffle_event__r.Event_End_Date__c from CEE__c];
        system.debug('tttttttt'+ceels);
        
        List< Jiffle_Attendee_Invitee__c > jfAttendee= new List< Jiffle_Attendee_Invitee__c >();
        Integer p = 0;
        for(Jiffle_Meeting_Session__c jfMeetingObj: meetingList){
            Id idCEE = lstCEE[p].Id;
            for(Integer k=0;k<10;k++){
                Jiffle_Attendee_Invitee__c jfAtt = new Jiffle_Attendee_Invitee__c();
                jfAtt.Attendee_First_Name__c = 'FirstAtt'+k;
                jfAtt.Attendee_Last_Name__c = 'LastAtt'+k;
                jfAtt.Attendee_Email__c = 'LastAtt@test.com'+k;
                jfAtt.Jiffle_Session_Meeting__c = jfMeetingObj.Id;
                jfAtt.Customer_Engagements_Events__c = idCEE;
                jfAtt.Requestor_Email__c  = userlist[k].Email;
                jfAtt.Requestor__c = userlist[k].FirstName;
                jfAtt.Contact_Sync__c = false;
                jfAtt.Title__c = 'CFO'+k;
                jfAtt.SFDC_Source__c = true;           
                jfAttendee.add(jfAtt);
            }  
            p++;             
        }
        
        insert jfAttendee;
        }
    }
    
    //@ Testing Reporting Batch Updates which tracks new Opportunities and Event Metrics
    static testMethod void testReportingUpdateBatchTest() {
        Test.startTest();
            JiffleNowReporting_Batchable ejfUpdate = new JiffleNowReporting_Batchable();
            Id batchinstanceid = database.executeBatch(ejfUpdate, 50);
        Test.stopTest();
    }

    //@ Testing Email Reminder to Reconcile Contacts
    static testMethod void testEmailReminderBatchTest() {
        Test.startTest();        
            JiffleNowWeeklyConfirmation_Batchable ejfEmailUpdate = new JiffleNowWeeklyConfirmation_Batchable();
            Id batchinstanceid = database.executeBatch(ejfEmailUpdate, 50);
        Test.stopTest();
    }

}