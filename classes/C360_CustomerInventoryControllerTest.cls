/************************************************************************************************************************************
Name    : C360_CustomerInventoryControllerTest
Author  : C360 Dev team
Purpose : Test Class for C360_CustomerInventoryController
Date    : 28/06/2019
Change History : none 
*************************************************************************************************************************************/

@isTest(seeAllData=false)
public class C360_CustomerInventoryControllerTest {
    
    @testSetup
    static void prepareTestData(){
        User u = CEE_TestUtility.getUser('adminT', true);
        //List < sObject > objRecTypeData = Test.loadData(ObjectRecordTypeIds__c.sObjectType,'GlobalTestObjectRecordTypeIds');
         insert new ObjectRecordTypeIds__c(AccountChannelRecordTypeId__c = '33e30000000dcbg', 
       		Account_Customer_RecordTypeId__c=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId());
        
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
        Test.startTest();
        Test.setMock(HttpCalloutMock.class,new TestMockHttpGenerator());
        Account CustomerAcc = [SELECT Id,AccountNumber FROM Account WHERE Name='CustomerTestAccount' and RecordType.Name='Customer' LIMIT 1];
        C360_CustomerInventoryController.fetchAccount(CustomerAcc.Id);
        String result = C360_CustomerInventoryController.initialLoadViewAll(CustomerAcc.AccountNumber,true,0,20);
        C360_CustomerInventoryController.customerInventoryActionsViewAll(CustomerAcc.AccountNumber,false,0,20,
                                                                         new List<String>{'PHONVOC'},
                                                                         new List<String>{'Enterprise Routing'},
                                                                         new List<String>{'Hardware'},
                                                                         'ASC','installLoc');
        system.assertEquals('Enterprise Routing', C360_CustomerInventoryController.businessEntityList[0]);
        Account businessUnitAcc = [SELECT Id,AccountNumber FROM Account WHERE Name='BUTestAccount' LIMIT 1];
        C360_CustomerInventoryController.fetchAccount(businessUnitAcc.Id);
        C360_CustomerInventoryController.initialLoadViewAll(businessUnitAcc.AccountNumber,false,0,20);
        C360_CustomerInventoryController.customerInventoryActionsViewAll(businessUnitAcc.AccountNumber,false,0,20,
                                                                         new List<String>{'PHONVOC'},
                                                                         new List<String>{'Enterprise Routing'},
                                                                         new List<String>{'Hardware'},
                                                                         'ASC','instDate');
        system.assertEquals('Hardware', C360_CustomerInventoryController.prodClassList[0]);
       
        Test.stopTest();
    }
    
    
    
}