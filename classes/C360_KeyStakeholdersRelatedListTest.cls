/************************************************************************************************************************************
Name    : C360_KeyStakeholdersRelatedListTest
Author  : C360 Dev team
Purpose : Contains logic to execute test methods of C360_KeyStakeholderRelatedList
Date    : 02/24/2019
Change History : none
*************************************************************************************************************************************/
@isTest
public class C360_KeyStakeholdersRelatedListTest {
    
    static testMethod void testMethod1() 
    {
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
            //Insert Customer Account Record
            Account CustomerAcc = new Account();
            Id CustrRcrdId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            CustomerAcc.RecordTypeId = CustrRcrdId;
            CustomerAcc.Name = 'CustomerTestAccount';
            insert CustomerAcc;
            system.debug('CustomerAcc>>>'+CustomerAcc); 
            Account BusinessAcc = new Account();
            Id BusinessRcrdId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Unit').getRecordTypeId();
            BusinessAcc.RecordTypeId = BusinessRcrdId;
            BusinessAcc.Name = 'BusinessTestAccount';
            BusinessAcc.ParentId = CustomerAcc.Id;
            insert BusinessAcc;
            //Insert Contact 
            Contact c = new Contact();
            Id contactRcrdId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Manual Partner Contact').getRecordTypeId();
            c.RecordTypeId =contactRcrdId;
            c.FirstName = 'Bhargav';
            c.LastName = 'Musunoori';
            c.Email = 'bmusunoo@cisco.com';
            c.Title = 'Application Developer';
            c.Phone = '123456789';
            c.AccountId = CustomerAcc.Id;
            insert c;
            //insert Keystakeolder
            Key_Stakeholders__c KS = new Key_Stakeholders__c();
            KS.Customer_Account__c = CustomerAcc.Id;
            KS.Business_Unit_Account__c = BusinessAcc.Id;
            KS.Name = 'StakeholderName';
            KS.Contact__c =c.Id;
            insert KS;
            Key_Stakeholders__c KS1 = new Key_Stakeholders__c();
            KS1.Customer_Account__c = CustomerAcc.Id;
            KS1.Business_Unit_Account__c = BusinessAcc.Id;
            KS1.Name = 'StakeholderName';
            KS1.Contact__c =c.Id;
            Integer limValue = 10;
            
            //Start test methods
            Test.startTest();
            List<Contact> contactsl1=C360_KeyStakeholdersRelatedList.fetchKeyStakeHolders(CustomerAcc.Id);
            system.assertEquals(1, contactsl1.size());
            List<Contact> contactsl2=C360_KeyStakeholdersRelatedList.fetchKeyStakeHolders(BusinessAcc.Id);
            system.assertEquals(1, contactsl2.size());
            List<Contact> contactslist1= C360_KeyStakeholdersRelatedList.fetchKeyStakeHoldersLazy(CustomerAcc.Id,limValue);
            system.assertEquals(1, contactslist1.size());
            List<Contact> contactslist2= C360_KeyStakeholdersRelatedList.fetchKeyStakeHoldersLazy(BusinessAcc.Id,limValue);
            system.assertEquals(1, contactslist2.size());
            Integer var1 = C360_KeyStakeholdersRelatedList.TotalKeyStakeHolders(CustomerAcc.Id);
            system.assertEquals(1, var1);
            Integer var2 = C360_KeyStakeholdersRelatedList.TotalKeyStakeHolders(BusinessAcc.Id);
            system.assertEquals(1, var1);
            C360_KeyStakeholdersRelatedList.insertKeyStakeHolderCustomer(KS1);
            contact c1=C360_KeyStakeholdersRelatedList.getContactRecordCustomer(c.id);
            Test.stopTest();   
        }
    }
}