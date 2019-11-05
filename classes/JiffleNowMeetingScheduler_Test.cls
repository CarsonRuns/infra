/************************************************************************************************************************************
Name    : JiffleNowMeetingScheduler_Test 
Author  : Mukesh Srivastava
Purpose : This Test class are to validate Meeting Scheduler page and its parameters
Created Date: 5/25/2015
Modification History: 
	Modification History: 
	Author  : Ghattamaneni Chaithanya
	Purpose : test Custom setting records are added to fix test class failure line no# 16-21
	Date	: 17-May-2019
*************************************************************************************************************************************/
@isTest
public class JiffleNowMeetingScheduler_Test{
    //Setting Up data for This test class
    @testSetup static void setupTestData() {
        // Added by gchaitha to fix test failure
        ProfileID__c ProfileIDObj = new ProfileID__c();
        ProfileIDObj.SetupOwnerId = UserInfo.getOrganizationId();
        ProfileIDObj.Cisco_Renewals__c = 'testRenewals';
        ProfileIDObj.Cisco_PSS__c = 'testPSS';
        insert ProfileIDObj;
        
        List < sObject > cOrgCS = Test.loadData(Org_Constant_CS__c.sObjectType, 'GlobalTestOrgConstantCS');
        List < sObject > cOrgConstantObject = Test.loadData(Org_Constants__c.sObjectType, 'OrgConstants');
        List < sObject > cMappings = Test.loadData(NGCC_Mapping_Object__c.sObjectType, 'GlobalTestMapping');
        List < sObject > cObjRecId = Test.loadData(ObjectRecordTypeIds__c.sObjectType, 'GlobalTestObjectRecordTypeIds');
        List < sObject > cAccounts = Test.loadData(Account.sObjectType, 'GlobalTestAccounts');
        List < sObject > cEvents = Test.loadData(Jiffle_Event__c.sObjectType, 'GlobalTestEvents');
        GlobalTriggerManagement__c gm = new GlobalTriggerManagement__c();
        gm.Name = 'JiffleR1_CEE';
        gm.Active__c = false;
        insert gm;

    }

    //@ Testing New CEE Creation and Ensuring Region is Populated
    static testMethod void testNewCEERecordCreation() {
        List < CEE__c > lstCEE = new List < CEE__c > ();
        List < Account > lstAcc = [Select Id from Account LIMIT 20];       
        User admin = CEE_TestUtility.getUser('admin', true);
        System.runAs(admin){
            CEE_TestUtility.loadCustomSettings();           
        }    
        List < Jiffle_Event__c > lstJF = [Select Id from Jiffle_Event__c Limit 20];
        Id idOfJiffleRec = Schema.SObjectType.CEE__c.getRecordTypeInfosByName().get('Jifflenow (Event, Tradeshow, Conference)').getRecordTypeId();
        Integer i = 0;
        for (Account accObj: lstAcc) {
            CEE__c ceeObj = new CEE__c();
            ceeObj.Primary_Account__c = lstAcc[i].Id;
            ceeObj.Jiffle_Event__c = lstJF[i].Id;
            ceeObj.RecordTypeId = idOfJiffleRec;
            lstCEE.add(ceeObj);
            i = i + 1;
        }
        Test.startTest();
            insert lstCEE;
            CEE__c cCEE = [Select Region__c from CEE__c LIMIT 1];
            //system.assertequals('APJ', cCEE.Region__c);
        Test.stopTest();
    }

    //@ Testing Meeting schedular page which are initiated Jiffle and redirected to SFDC
    static testMethod void testNewMeetingCreationFromEvent() {
        Jiffle_Event__c jfEvent = [Select Id, EVENT_UUID__c from Jiffle_Event__c Limit 1];
        Test.startTest();
            Test.setCurrentPageReference(Page.JiffleNowMeetingSchedular);
            ApexPages.currentPage().getParameters().put('eventId', jfEvent.EVENT_UUID__c);
            CEE__c ceeObj = new CEE__c();
            ApexPages.StandardController sc = new ApexPages.StandardController(ceeObj);
            JiffleNowMeetingSchedular_CTE testCTE = new JiffleNowMeetingSchedular_CTE(sc);
        Test.stopTest();
    }

    //@ Testing Meeting schedular page which are initiated Jiffle Event page
    static testMethod void testNewMeetingCreationFromEventRedirection() {
        Jiffle_Event__c jfEvent = [Select Id, EVENT_UUID__c from Jiffle_Event__c Limit 1];
        Test.startTest();
            Test.setCurrentPageReference(Page.JiffleNowMeetingSchedular);
            ApexPages.currentPage().getParameters().put('eId', jfEvent.Id);
            CEE__c ceeObj = new CEE__c();
            ApexPages.StandardController sc = new ApexPages.StandardController(ceeObj);
            JiffleNowMeetingSchedular_CTE testCTE = new JiffleNowMeetingSchedular_CTE(sc);
        Test.stopTest();
    }

    //@ Testing Meeting schedular page which are initiated Account page
    static testMethod void testNewMeetingCreationFromAccount() {
        Account jfacc = [Select Id, Name from Account Limit 1];
        Test.startTest();
            Test.setCurrentPageReference(Page.JiffleNowMeetingSchedular);
            ApexPages.currentPage().getParameters().put('accId', jfacc.Id);
            CEE__c ceeObj = new CEE__c();
            ApexPages.StandardController sc = new ApexPages.StandardController(ceeObj);
            JiffleNowMeetingSchedular_CTE testCTE = new JiffleNowMeetingSchedular_CTE(sc);
            testCTE.readAccount();
        Test.stopTest();
    }

    //@ Testing Meeting schedular page which are initiated Opportunity page
    static testMethod void testNewMeetingCreationFromOppty() {
        Account jfacc = [Select Id, Name from Account Limit 1];
        Date vCloseDate = System.today();
        Opportunity opptyObj = new Opportunity(Name = 'Test1', StageName = '1 - Identify', CloseDate = vCloseDate,
            Expected_Product__c = 10, Forecast_Discount__c = 1, CurrencyIsoCode = UserInfo.getDefaultCurrency(),
            AccountId = jfacc.Id, Competitors__c = 'Allot', Has_Competitors__c = true,skipValidations__c = true,Partner_Required__c =false);
        insert opptyObj;
        Opportunity jfOppty = [Select Id from Opportunity Limit 1];
        Test.startTest();
            Test.setCurrentPageReference(Page.JiffleNowMeetingSchedular);
            ApexPages.currentPage().getParameters().put('opptyId', jfOppty.Id);
            CEE__c ceeObj = new CEE__c();
            ApexPages.StandardController sc = new ApexPages.StandardController(ceeObj);
            JiffleNowMeetingSchedular_CTE testCTE = new JiffleNowMeetingSchedular_CTE(sc);
            testCTE.readAccount();
            testCTE.getJiffleURL();
        Test.stopTest();
    }

    //@ Testing Meeting schedular page which are initiated Opportunity with Name page
    static testMethod void testNewMeetingCreationFromOpptyWithName() {
        Account jfacc = [Select Id, Name from Account Limit 1];
        Date vCloseDate = System.today();
        Opportunity opptyObj = new Opportunity(Name = 'Test1', StageName = '1 - Identify', CloseDate = vCloseDate,
            Expected_Product__c = 10, Forecast_Discount__c = 1, CurrencyIsoCode = UserInfo.getDefaultCurrency(),
            AccountId = jfacc.Id, Competitors__c = 'Allot', Has_Competitors__c = true,skipValidations__c = true,Partner_Required__c =false);
        insert opptyObj;
        Opportunity jfOppty = [Select Id, Name from Opportunity Limit 1];
        Test.startTest();
            Test.setCurrentPageReference(Page.JiffleNowMeetingSchedular);
            ApexPages.currentPage().getParameters().put('opptyId', jfOppty.Id);
            ApexPages.currentPage().getParameters().put('opptyName', jfOppty.Name);
            CEE__c ceeObj = new CEE__c();
            ApexPages.StandardController sc = new ApexPages.StandardController(ceeObj);
            JiffleNowMeetingSchedular_CTE testCTE = new JiffleNowMeetingSchedular_CTE(sc);
            testCTE.readAccount();
            testCTE.getJiffleURL();
        Test.stopTest();
    }

    //@ Testing Meeting schedular page which are initiated Opportunity page but for Booked Opportunity which is not allowed
    static testMethod void testNewMeetingCreationFromBookedOppty() {
        Account jfacc = [Select Id, Name from Account Limit 1];
        Date vCloseDate = System.today();
        Opportunity opptyObj = new Opportunity(Name = 'Test1', StageName = '1 - Identify', CloseDate = vCloseDate,
            Expected_Product__c = 10, Forecast_Discount__c = 1, CurrencyIsoCode = UserInfo.getDefaultCurrency(),
            AccountId = jfacc.Id, Competitors__c = 'Allot', Has_Competitors__c = true, Opportunity_Status__c = 'Booked',skipValidations__c = true,Partner_Required__c =false);
        insert opptyObj;
        Opportunity jfOppty = [Select Id from Opportunity Limit 1];
        Test.startTest();
            Test.setCurrentPageReference(Page.JiffleNowMeetingSchedular);
            ApexPages.currentPage().getParameters().put('opptyId', jfOppty.Id);
            CEE__c ceeObj = new CEE__c();
            ApexPages.StandardController sc = new ApexPages.StandardController(ceeObj);
            JiffleNowMeetingSchedular_CTE testCTE = new JiffleNowMeetingSchedular_CTE(sc);
            testCTE.readAccount();
            testCTE.getJiffleURL();
        Test.stopTest();
    }

    //@ Testing Edit mode of Meeting schedular page which are initiated CEE page
    static testMethod void testEditCEERecord() {
        List <Account> lstAcc = new List<Account>();
        User admin = CEE_TestUtility.getUser('admin', true);
        System.runAs(admin){
            CEE_TestUtility.loadCustomSettings();
            Account acct = CEE_TestUtility.getAccount('brief', true);
            lstAcc.add(acct);
        }        
        List < Jiffle_Event__c > lstJF = [Select Id from Jiffle_Event__c Limit 1];
        Id idOfJiffleRec = Schema.SObjectType.CEE__c.getRecordTypeInfosByName().get('Jifflenow (Event, Tradeshow, Conference)').getRecordTypeId();
        
        CEE__c ceeObj = new CEE__c();
        ceeObj.Primary_Account__c = lstAcc[0].Id;
        ceeObj.Jiffle_Event__c = lstJF[0].Id;
        ceeObj.RecordTypeId = idOfJiffleRec;
        insert ceeObj;

        Test.startTest();
            CEE__c cCEE = [Select Id, Region__c from CEE__c LIMIT 1];
            //system.assertequals('APJ', cCEE.Region__c);
            Test.setCurrentPageReference(Page.JiffleNowMeetingSchedular);
            ApexPages.currentPage().getParameters().put('Id', cCEE.Id);
            ApexPages.currentPage().getParameters().put('retURL', cCEE.Id);
            ApexPages.StandardController sc = new ApexPages.StandardController(cCEE);
            JiffleNowMeetingSchedular_CTE testCTE = new JiffleNowMeetingSchedular_CTE(sc);
            testCTE.getCEESessions();
            testCTE.getOppties();
            testCTE.submitNewRequest();
            testCTE.cmdCancel();
        Test.stopTest();
    }
}