/************************************************************************************************************************************
Name    : JiffleNowAttendee_Reconcile_Test
Author  : Mukesh Srivastava
Purpose : This Test class is validate New Attendee Creation and Sync as Contact,View my Meetings,Reconcile scenario
Created Date: 5/25/2015
Modification History: 

*************************************************************************************************************************************/
@isTest
public class JiffleNowAttendee_Reconcile_Test {
    //Setting Up data for This test class
    @testSetup static void setupTestData() {
        CEE_TestUtility.loadCustomSettings();
       // List < sObject > cOrgCS = Test.loadData(Org_Constant_CS__c.sObjectType, 'GlobalTestOrgConstantCS');
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
        
        Id idOfJiffleRec = Schema.SObjectType.CEE__c.getRecordTypeInfosByName().get('Jifflenow (Event, Tradeshow, Conference)').getRecordTypeId();

        //Creating New CEE
        CEE__c ceeObj = new CEE__c();
        ceeObj.Primary_Account__c = alist[0].Id;
        ceeObj.Jiffle_Event__c = evtlist[0].Id;
        ceeObj.RecordTypeId = idOfJiffleRec;
        insert ceeObj;
        
        //Creating New Agenda
        Jiffle_Agenda_Item__c jfAgenda = new Jiffle_Agenda_Item__c();
        jfAgenda.Name = 'Agenda';
        jfAgenda.Jiffle_Event__c = evtlist[0].Id;
        insert jfAgenda;

        //Creating New Jiffle Meeting
        Jiffle_Meeting_Session__c jfMeeting = new Jiffle_Meeting_Session__c();
        jfMeeting.Jiffle_Agenda_Item__c = jfAgenda.Id;
        jfMeeting.Request_Status__c = 'Active';
        insert jfMeeting;

        //Creating Attendees
        List < Jiffle_Attendee_Invitee__c > jfAttendee = new List < Jiffle_Attendee_Invitee__c > ();
        for (Integer i = 0; i < 20; i++) {
            Jiffle_Attendee_Invitee__c jfAtt = new Jiffle_Attendee_Invitee__c();
            jfAtt.Attendee_First_Name__c = 'FirstAtt' + i;
            jfAtt.Attendee_Last_Name__c = 'LastAtt' + i;
            jfAtt.Attendee_Email__c = 'LastAtt@test.com' + i;
            jfAtt.Primary_Account__c = alist[0].Id;
            jfAtt.Jiffle_Session_Meeting__c = jfMeeting.Id;
            jfAtt.Customer_Engagements_Events__c = ceeObj.Id;
            jfAtt.Requestor_Email__c = userinfo.getUserEmail();
            jfAtt.Contact_Sync__c = false;
            jfAtt.Title__c = 'CFO' + i;
            if (i == 10) {
                jfAtt.Meeting_Attended__c = 'No';
            }
            jfAttendee.add(jfAtt);
        }

        insert jfAttendee;

    }

    //@ Testing New CEE Creation and Ensuring Region is Populated
    static testMethod void testNewAttendeesCreation() {
        Jiffle_Meeting_Session__c jfMS = [Select Id from Jiffle_Meeting_Session__c Limit 1];
        CEE__c jfCEE = [Select Id from CEE__c Limit 1];
        Account acc = [Select Id from Account Limit 1];

        List < Jiffle_Attendee_Invitee__c > jfAttendee = new List < Jiffle_Attendee_Invitee__c > ();

        for (Integer i = 50; i < 80; i++) {
            Jiffle_Attendee_Invitee__c jfAtt = new Jiffle_Attendee_Invitee__c();
            jfAtt.Attendee_First_Name__c = 'FirstAtt' + i;
            jfAtt.Attendee_Last_Name__c = 'LastAtt' + i;
            jfAtt.Attendee_Email__c = 'LastAtt@test.com' + i;
            jfAtt.Primary_Account__c = acc.Id;
            jfAtt.Jiffle_Session_Meeting__c = jfMS.Id;
            jfAtt.Customer_Engagements_Events__c = jfCEE.Id;
            jfAtt.Requestor_Email__c = userinfo.getUserEmail();
            jfAtt.Contact_Sync__c = True;
            jfAtt.Contact_Type__c = 'Customer';
            jfAtt.Title__c = 'CEO' + i;
            jfAttendee.add(jfAtt);
        }

        Test.startTest();
            insert jfAttendee;
        Test.stopTest();
    }

    //@ Testing when No record was selected from List
    static testMethod void testReconcilationNoSelection() {
        List < Jiffle_Attendee_Invitee__c > lstJSAtt = new List < Jiffle_Attendee_Invitee__c > ();
        Test.startTest();
            Test.setCurrentPageReference(New PageReference('Page.JiffleNowReconcile'));
            ApexPages.StandardSetcontroller stdSetCtlAttendee = New ApexPages.StandardSetController(lstJSAtt);
            System.currentPageReference().getParameters().put('retURL', '/home/home.jsp');
            System.currentPageReference().getParameters().put('action', 'Yes');
            stdSetCtlAttendee.setSelected(lstJSAtt);
            JiffleNowReconcile_CTE setContAtt = new JiffleNowReconcile_CTE(stdSetCtlAttendee);
            setContAtt.cmdDone();
        Test.stopTest();
    }

    //@ Testing when All record was selected from List from Reconcile
    static testMethod void testReconcilationAllSelection() {
        List < Jiffle_Attendee_Invitee__c > lstJSAtt = [Select Id from Jiffle_Attendee_Invitee__c LIMIT 30];
        Test.startTest();
            Test.setCurrentPageReference(New PageReference('Page.JiffleNowReconcile'));
            ApexPages.StandardSetcontroller stdSetCtlAttendee = New ApexPages.StandardSetController(lstJSAtt);
            System.currentPageReference().getParameters().put('retURL', '/home/home.jsp');
            System.currentPageReference().getParameters().put('action', 'Yes');
            stdSetCtlAttendee.setSelected(lstJSAtt);
            JiffleNowReconcile_CTE setContAtt = new JiffleNowReconcile_CTE(stdSetCtlAttendee);
            setContAtt.cmdSubmit();
            setContAtt.cmdDone();
        Test.stopTest();
    }

    //@ Testing to view my Meetings
    static testMethod void testMyMeetingViewer() {
        CEE__c ceeObj = [Select Jiffle_Event__c from CEE__c LIMIT 1];
        Jiffle_Event__c jfEvent = [Select Id from Jiffle_Event__c where Id = : ceeObj.Jiffle_Event__c Limit 1];
        Test.startTest();
            Test.setCurrentPageReference(New PageReference('Page.JiffleNowEventsMeetingViewer'));
            ApexPages.StandardController stdCtlEvent = New ApexPages.StandardController(jfEvent);
            JiffleNowMeetingViewer_CTE contAtt = new JiffleNowMeetingViewer_CTE(stdCtlEvent);
            contAtt.getSessions();
        Test.stopTest();
    }
    
    //@ Testing to Cancelled or Deleted Meeting
    static testMethod void testMeetingCancelledDeleted() {
        Jiffle_Meeting_Session__c  jmObj = [Select Id,Request_Status__c from Jiffle_Meeting_Session__c LIMIT 1];
        jmObj.Request_Status__c = 'Deleted';
        Test.startTest();
            update jmObj;
        Test.stopTest();
    }
}