/************************************************************************************************************************************
Name    : RenewalLazyLoadingTest
Author  : C360 Dev team
Purpose : Contains logic to execute test methods of RenewalOpportunity
Date    : 02/03/2019
Change History : none
*************************************************************************************************************************************/
@isTest
public class RenewalLazyLoadingTest {
    static testMethod void testMethod1() 
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
            Opportunity opp = new Opportunity();
            opp.Partner_Required__c = true;
            opp.AccountId = acc3.Id;
            opp.StageName = '1 - Prospect';
            opp.Name = 'opp name';
            Opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewals Opportunity').getRecordTypeId();
            opp.CloseDate = date.today();
            opp.Prior_Contract_Expiration_Date__c = date.today();
            insert opp;
            
            //Starting test
            Test.startTest(); 
            Boolean isCustomerRT = RenewalLazyLoading.getRecordtype(acc.Id);
            System.assertEquals(isCustomerRT,true);
             List<Id> testId = new List<Id>();
            List<Opportunity> oppList = RenewalLazyLoading.fetchParentRenewalOpp(acc.Id,testId, true);
            System.assertEquals(oppList.size(),1);
            Test.stopTest(); 
  }}
    static testMethod void test2(){
        test.startTest();
        Integer numberOpp = RenewalLazyLoading.TotalOpportunity('',true,'');
        System.assertEquals(numberOpp,numberOpp);
        List<Opportunity> oppList1 = RenewalLazyLoading.getOpportunity(30,'', true,'');
        System.assertEquals(oppList1.size(),oppList1.size());
        test.stopTest();
    }
}