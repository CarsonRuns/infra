/************************************************************************************************************************************
Name    : C360_HealthScoreControllerTest
Author  : C360 Dev team
Purpose : Test class for C360_HealthScoreController which displays in customer/BU view
Date    : 28/06/2019
Change History : NA
*************************************************************************************************************************************/
@isTest
public class C360_HealthScoreControllerTest {
    
    static testMethod void testMethod1(){
        
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
            acc.AccountNumber = '12378';
            insert acc;
            accts.add(acc);
            
            Account acc2 = new Account();
            acc2.Name = 'Bu acc';
            acc2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Unit').getRecordTypeId();
            acc2.AccountNumber = '34543';
            insert acc2;
            accts.add(acc2);
            
            
            List<C360HealthScore__c> healthScores = new List<C360HealthScore__c>();
            C360HealthScore__c HS1 = new C360HealthScore__c();
            HS1.Name = 'Test';
            HS1.Account_Number__c = acc.AccountNumber;
            HS1.Index__c = 45 ;
            HS1.Finance_Score__c = 34 ;
            HS1.Customer_hi__c = 76 ;
            HS1.Quality_Score__c = 57 ;
            insert HS1; 
            healthScores.add(HS1);
            
            C360HealthScore__c HS2 = new C360HealthScore__c();
            HS2.Name = 'Test123';
            HS2.Account_Number__c = acc2.AccountNumber;
            HS2.Index__c = 77 ;
            HS2.Finance_Score__c = 84 ;
            HS2.Customer_hi__c = 56 ;
            HS2.Quality_Score__c = 45 ;
            insert HS2; 
            healthScores.add(HS2);
            
            //Starting test
            Test.startTest(); 
            
            string testHS = C360_HealthScoreController.gethealthScores(acc.Id);
            system.assert(testHS!=null); 
            
            Test.stopTest();
        } 
        
    }
}