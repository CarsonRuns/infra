/************************************************************************************************************************************
Name    : C360_PreventSameFYFQonSuccessPlanTest
Author  : C360 Dev team
Purpose : Contains logic to execute test methods of C360_PreventSameFYFQonSuccessPlan trigger's handler class C360_QsrHandler
Date    : 28/06/2019
Change History : none
*************************************************************************************************************************************/
@isTest
public class C360_PreventSameFYFQonSuccessPlanTest {
    
@testSetup
    static void dataset() 
    {
        //Creating dataset
        Profile prof = [select id from profile where name LIKE '%Cisco_CustomerSuccess%'];
        User user = new User(Alias = 'newUser', Email='newuser@cisco.com',
                             EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                             LocaleSidKey='en_US', ProfileId = prof.id,
                             TimeZoneSidKey='America/Los_Angeles', UserName='newuser@cisco.com', 
                             Theatre__c = 'Americas-US Commercial', Additional_User_Permissions__c='Enable EndUser ACCTCreation');
        
        insert user;
        
        insert new ObjectRecordTypeIds__c(AccountChannelRecordTypeId__c = '33e30000000dcbg', 
                                          Account_Customer_RecordTypeId__c=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId());
        insert new ProfileID__c(Cisco_Renewals__c = '11e30000000dcbg', Cisco_PSS__c='22e30000000dcbg');
        insert new Org_Constants__c(Key__c = 'Oppty: ProfileIds to skip Triggers', prod_value__c='prodval');
        
        system.runAs(user){
            List<Account> accts = new List<Account>();
            
            Account acc = new Account();
            acc.Name = 'customer acc';
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            insert acc;
            accts.add(acc);
            
            Account acc2 = new Account();
            acc2.Name = 'Bu acc';
            acc2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Unit').getRecordTypeId();
            acc2.ParentId = acc.Id;
            insert acc2;
            accts.add(acc2);
            
            Account acc3 = new Account();
            acc3.Name = 'End user acc';
            acc3.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('End-User').getRecordTypeId();
            acc3.ParentId = acc2.Id;
            insert acc3;
            accts.add(acc3);
            
             Success_Plan__c sp= new Success_Plan__c();
            sp.Name = 'SP Name';
            sp.Active__c = 'Yes';
            sp.Customer_BU_Name__c = acc2.Id;
            sp.Customer_Name__c = acc.Id;
            insert sp; 
        }}
        static testMethod void test_FYFQTrigger() {
     		//Start of test
            test.startTest();
            
            Success_Plan__c sp = [SELECT Id FROM Success_Plan__c WHERE Name='SP Name' LIMIT 1];
            try{
            List<QSR__c> qsrList = new List<QSR__c>();
            QSR__c qsr = new QSR__c();
            qsr.Name = 'qsr name';
            qsr.Success_Plan__c = sp.Id;
            qsr.Cisco_FY_FQ__c='Q3FY19';
            insert qsr;
            qsrList.add(qsr);
            
            QSR__c qsr1 = new QSR__c();
            qsr1.Name = 'qsr name1';
            qsr1.Success_Plan__c = sp.Id;
            qsr1.Cisco_FY_FQ__c = 'Q3FY19';
            insert qsr1;
            qsrList.add(qsr1);
            
            C360_QsrHandler qs = new C360_QsrHandler();
            qs.DuplicateChecker(qsrList);
            }
            catch(Exception e) {
                Boolean expectedExceptionThrown = e.getMessage().contains('Please select another option for the Cisco FY/FQ. The one you have selected is already selected for another QSR under the same Success Plan.') ? true : false;
              	System.Assert(expectedExceptionThrown,true);
                } 
            test.stopTest();
        }
}