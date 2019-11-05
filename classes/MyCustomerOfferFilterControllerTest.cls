@isTest
public class MyCustomerOfferFilterControllerTest {
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
        
         String userId = '00580000003G1lsAAC'; 
        
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
            
            //Insert Offer Records
            Offer__c offerObj = new Offer__c();
            offerObj.Name = 'CiscoTest';
            offerObj.Customer_Name__c = acc.Id;
            offerObj.Customer_BU_Name__c = acc2.Id;
            insert offerObj;
            system.debug('offerObj>>>'+offerObj);
            CEE_TestUtility.loadCustomSettings();
            system.debug('Customsettings>>>'+ObjectRecordTypeIds__c.getInstance().AccountChannelRecordTypeId__c);
      
                Test.startTest();
            List<String> testId1 = new List<String>();
            MyCustomerOfferFilterController.accountListWrapper AccWrap = 
                new MyCustomerOfferFilterController.accountListWrapper();
            List<Account> acct  = new List<Account>();
            Map<Id,Offer__c> offtest = new Map<Id,Offer__c>();
            AccWrap.acc = acct;
AccWrap.off = offtest;
            
            Test.stopTest(); 
            
        }
    }
      
 
           static testMethod void testMethod2() {   
            Test.startTest(); 
            List<String> testId = new List<String>();
            List<String> fetchOffers = MyCustomerOfferFilterController.fetchOfferByCustomers(testId);
            MyCustomerOfferFilterController.getAccountList();
            //System.assertEquals(fetchOffers.size(), 1);
            Test.stopTest();
        }            
    }