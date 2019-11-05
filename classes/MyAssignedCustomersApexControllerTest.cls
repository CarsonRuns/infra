/************************************************************************************************************************************
Name    : MyAssignedCustomersApexControllerTest
Author  : C360 Dev team
Purpose : Contains logic to execute test methods of MyAssignedCustomersApexController
Date    : 02/24/2019
Change History : none
*************************************************************************************************************************************/
@isTest(seeAllData=false)

public class MyAssignedCustomersApexControllerTest {
    static testMethod void testMethod1() 
    {
        //Creating Account Records for Customer and BU
        // Create Test User
        User u = CEE_TestUtility.getUser('admin', true);
        List < sObject > objRecTypeData = Test.loadData(ObjectRecordTypeIds__c.sObjectType,'GlobalTestObjectRecordTypeIds');
        List < sObject > osCSData = Test.loadData(Org_Constants__c.sObjectType,'OrgConstants');
        Org_Constant_CS__c ocs = new Org_Constant_CS__c();
        ocs.name = 'Exclude From PUI and Competitor Popup';
        ocs.Non_Production_Value__c = 'Cisco_ADMIN';
        ocs.Production_Value__c = 'Cisco_ADMIN';
        insert ocs; 
        Id RecordtypeIdValue;

         List<C360ListViewIds__c> apiSettings = C360_TestDataFactory.prepareListViewSettings();
            insert apiSettings;
        
        System.runas(u){
            Account a = new Account();
            //Insert Customer Account Record
            Account CustomerAcc = new Account();
            Id CustrRcrdId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            CustomerAcc.RecordTypeId = CustrRcrdId;
            CustomerAcc.Name = 'CustomerTestAccount';
            CustomerAcc.AccountNumber='1234';
            CustomerAcc.Assigned_CSE__c=u.id;
            insert CustomerAcc;
            Account BusinessAcc = new Account();
            Id BusinessRcrdId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Unit').getRecordTypeId();
            BusinessAcc.RecordTypeId = BusinessRcrdId;
            BusinessAcc.Name = 'BusinessTestAccount';
            BusinessAcc.AccountNumber='4576';
            BusinessAcc.Assigned_CSE__c = u.Id;
            insert BusinessAcc;
           
            Test.startTest();
                String myAssign = MyAssignedCustomersApexController.MyAssignedCustomers(u.id);
            Test.stopTest();
        }
    }
}