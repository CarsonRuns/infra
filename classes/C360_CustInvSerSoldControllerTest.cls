/************************************************************************************************************************************
Name    : C360_CustInvSerSoldControllerTest
Author  : C360 Dev team
Purpose : Test Class used for API callout of Customer Inventory/Services Sold in Puchase Tab of Customer and BU (C360_CustInvSerSoldController)
Date	: 28/06/2019
Change History : 
*************************************************************************************************************************************/
@isTest(seeAllData=false)
public class C360_CustInvSerSoldControllerTest {
    @testSetup
    public static void dataload(){ 
        User u = CEE_TestUtility.getUser('admin', true);
        List < sObject > objRecTypeData = Test.loadData(ObjectRecordTypeIds__c.sObjectType,'GlobalTestObjectRecordTypeIds');
        
        System.runas(u){
            
            Account acc = new Account(Name='Test Acc');
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
    static testMethod void testDoCustomer(){
        Account CustomerAcc = [SELECT Id FROM Account WHERE Name='CustomerTestAccount' LIMIT 1];
        Account businessUnitAcc = [SELECT Id FROM Account WHERE Name='BUTestAccount' LIMIT 1];
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new TestMockHttpGenerator());
        C360_CustInvSerSoldController.doCustomerInvAPI(CustomerAcc.id);
        C360_CustInvSerSoldController.doCustomerInvAPI(businessUnitAcc.id);
        test.stopTest();
    }
    
    static testMethod void testDoServices(){
        
        Account CustomerAcc = [SELECT Id FROM Account WHERE Name='CustomerTestAccount' LIMIT 1];
        Account businessUnitAcc = [SELECT Id FROM Account WHERE Name='BUTestAccount' LIMIT 1];
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new TestMockHttpGenerator());
        C360_CustInvSerSoldController.doServicesAPI(CustomerAcc.id);
        system.assertNotEquals(71,C360_CustInvSerSoldController.customerCount);
        String result1 = C360_CustInvSerSoldController.doServicesAPI(businessUnitAcc.id);
        //system.assertEquals(result1,'{"count":"71","data":"[{\"serviceType\":\"TECHNICAL SUPPORT SERVICES\",\"serviceGroup\":\"SMART NET TOTAL CARE\",\"endDate\":null,\"completeDate\":\"2019-05-31\",\"beginDate\":null,\"ACV\":\"46.0\"}]');
        DMLException ex = new DMLException();
        HttpResponse result = new HttpResponse();
        C360_ResponseWrapper res = new C360_ResponseWrapper(ex,result);
        test.stopTest();
    }
    
}