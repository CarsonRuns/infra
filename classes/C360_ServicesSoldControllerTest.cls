/************************************************************************************************************************************
Name    : C360_ServicesSoldControllerTest
Author  : C360 Dev team
Purpose : Test class to cover Unit Test for C360_ServicesSoldController
Date    : 28/06/2019
Change History : none
*************************************************************************************************************************************/

@isTest(seeAllData=false)
public class C360_ServicesSoldControllerTest {
    
    @testSetup
    static void prepareTestData(){
        User u = CEE_TestUtility.getUser('adminT', true);
        List < sObject > objRecTypeData = Test.loadData(ObjectRecordTypeIds__c.sObjectType,'GlobalTestObjectRecordTypeIds');
        System.runas(u){
            List<C360_API_Settings__c> apiSettings = C360_TestDataFactory.prepareAPISettings();
            insert apiSettings;
            
            Id CustrRcrdId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            Account CustomerAcc = new Account(RecordTypeId = CustrRcrdId ,Name = 'CustomerTestAccount',AccountNumber='1234',Assigned_CSE__c=u.id);
            insert CustomerAcc;
            Id BusinessRcrdId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Unit').getRecordTypeId();
            Account businessUnitAcc = new Account(RecordTypeId = BusinessRcrdId ,Name = 'BUTestAccount',AccountNumber='1254',Assigned_CSE__c=u.id);
            insert businessUnitAcc;
        }
    }
    static testMethod void fetchAccountMethod(){
        //prepareTestData();
        Id CustrRcrdId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account CustomerAcc = [SELECT Id,AccountNumber FROM Account WHERE name='CustomerTestAccount'  LIMIT 1];
        string customerId =CustomerAcc.AccountNumber;
        Account businessUnitAcc = [SELECT Id,AccountNumber FROM Account WHERE Name='BUTestAccount' LIMIT 1];
        Test.startTest();
        Test.setMock(HttpCalloutMock.class,new TestMockHttpGenerator());
        C360_ServicesSoldController.fetchAccount(CustomerAcc.Id);
        C360_ServicesSoldController.initialLoadViewAll(customerId,true,0,20);
        C360_ServicesSoldController.servicesSoldActionsViewAll(customerId,false,0,20,
                                                          new List<String>{'TECHNICAL SUPPORT SERVICES'},
                                                          new List<String>{'SMART NET TOTAL CARE'},
                                                          'ASC','ACV');
        system.assertEquals('TECHNICAL SUPPORT SERVICES', C360_ServicesSoldController.serviceTypeList[0]);
        C360_ServicesSoldController.fetchAccount(businessUnitAcc.Id);
        C360_ServicesSoldController.initialLoadViewAll(businessUnitAcc.AccountNumber,false,0,20);
        C360_ServicesSoldController.servicesSoldActionsViewAll(businessUnitAcc.AccountNumber,false,0,20,
                                                          new List<String>{'TECHNICAL SUPPORT SERVICES'},
                                                          new List<String>{'SMART NET TOTAL CARE'},
                                                          'ASC','EndDate');
        system.assertEquals('SMART NET TOTAL CARE', C360_ServicesSoldController.serviceGroupList[0]);
        Test.stopTest();
    }   
}