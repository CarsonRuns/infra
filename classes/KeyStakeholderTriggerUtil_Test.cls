@isTest
private class KeyStakeholderTriggerUtil_Test {

    @testSetup static void setup(){

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
            Account customer = new Account();
            Id customerId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            customer.RecordTypeId = customerId;
            customer.Name = 'Customer';
            insert customer;

            Account bu = new Account();
            Id buId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Unit').getRecordTypeId();
            bu.RecordTypeId = buId;
            bu.Name = 'BUTestSerge';
            bu.ParentId = customer.Id;
            insert bu;

            Contact c = new Contact();
            Id contactRcrdId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('End Customer Contact').getRecordTypeId();
            c.RecordTypeId =contactRcrdId;
            c.FirstName = 'test';
            c.LastName = 'test';
            c.Email = 'testSerge123@cisco.com';
            c.Title = 'test';
            c.Phone = '1234';
            c.AccountId = bu.Id;
            insert c;

        }
    }   


    static testMethod void keyStakeholder_sanityTestPositive() {

        User user = [select Id from User where Username =: 'newuser@cisco.com' limit 1];
        Account bu = [select Id from Account where Name =: 'BUTestSerge' limit 1];
        Contact c = [select Id from Contact where Email =: 'testSerge123@cisco.com' limit 1];


        system.runAs(user){
            Key_Stakeholders__c ks = new Key_Stakeholders__c();
            ks.Business_Unit_Account__c = bu.Id;
            ks.Name = 'Serge';
            ks.Contact__c =c.Id;
            insert ks;

            List<Key_Stakeholders__c> ksConfirm =[select id from Key_Stakeholders__c where Business_Unit_Account__c=: bu.Id];
            System.assertEquals(1,ksConfirm.size());

        }
    }

    static testMethod void keyStakeholder_sanityTestMultiplePositive() {
        User user = [select Id from User where Username =: 'newuser@cisco.com' limit 1];
        Account bu = [select Id from Account where Name =: 'BUTestSerge' limit 1];
        Contact c = [select Id from Contact where Email =: 'testSerge123@cisco.com' limit 1];

        system.runAs(user){
            Key_Stakeholders__c ks = new Key_Stakeholders__c();
            ks.Business_Unit_Account__c = bu.Id;
            ks.Name = 'Serge';
            ks.Contact__c =c.Id;
            insert ks;

            Key_Stakeholders__c ks1 = new Key_Stakeholders__c();
            ks1.Business_Unit_Account__c = bu.Id;
            ks1.Name = 'Serge1';
            ks1.Contact__c =c.Id;
            insert ks1;

            Key_Stakeholders__c ks2 = new Key_Stakeholders__c();
            ks2.Business_Unit_Account__c = bu.Id;
            ks2.Name = 'Serge2';
            ks2.Contact__c =c.Id;
            insert ks2;

            List<Key_Stakeholders__c> ksConfirm =[select id from Key_Stakeholders__c where Business_Unit_Account__c=: bu.Id];
            System.assertEquals(3,ksConfirm.size());

        }
    }
    
    static testMethod void keyStakeholder_MultiplePositive() {
        User user = [select Id from User where Username =: 'newuser@cisco.com' limit 1];
        Account bu = [select Id from Account where Name =: 'BUTestSerge' limit 1];
        Contact c = [select Id from Contact where Email =: 'testSerge123@cisco.com' limit 1];

        system.runAs(user){
            Key_Stakeholders__c ks = new Key_Stakeholders__c();
            ks.Business_Unit_Account__c = bu.Id;
            ks.Name = 'Serge';
            ks.Contact__c =c.Id;
            insert ks;

            Key_Stakeholders__c ks1 = new Key_Stakeholders__c();
            ks1.Business_Unit_Account__c = bu.Id;
            ks1.Name = 'Serge1';
            ks1.Primary_Contact__c = true;
            ks1.Contact__c =c.Id;
            insert ks1;

            Key_Stakeholders__c ks2 = new Key_Stakeholders__c();
            ks2.Business_Unit_Account__c = bu.Id;
            ks2.Name = 'Serge2';
            ks2.Contact__c =c.Id;
            insert ks2;

            List<Key_Stakeholders__c> ksConfirm =[select id from Key_Stakeholders__c where Business_Unit_Account__c=: bu.Id];
            System.assertEquals(3,ksConfirm.size());

        }
    }
    
    static testMethod void keyStakeholder_MultiplePositive2() {
        User user = [select Id from User where Username =: 'newuser@cisco.com' limit 1];
        Account bu = [select Id from Account where Name =: 'BUTestSerge' limit 1];
        Contact c = [select Id from Contact where Email =: 'testSerge123@cisco.com' limit 1];

        system.runAs(user){
            Key_Stakeholders__c ks = new Key_Stakeholders__c();
            ks.Business_Unit_Account__c = bu.Id;
            ks.Name = 'Serge';
            ks.Contact__c =c.Id;
            insert ks;

            Key_Stakeholders__c ks1 = new Key_Stakeholders__c();
            ks1.Business_Unit_Account__c = bu.Id;
            ks1.Name = 'Serge1';
            ks1.Contact__c =c.Id;
            ks1.Primary_Contact__c = true;
            insert ks1;

            Key_Stakeholders__c ks2 = new Key_Stakeholders__c();
            ks2.Business_Unit_Account__c = bu.Id;
            ks2.Name = 'Serge2';
            ks2.Contact__c =c.Id;
            insert ks2;

            List<Key_Stakeholders__c> ksConfirm =[select id from Key_Stakeholders__c where Business_Unit_Account__c=: bu.Id];
            System.assertEquals(3,ksConfirm.size());

        }
    }
    
    static testMethod void keyStakeholder_MultiplePositive3() {
        User user = [select Id from User where Username =: 'newuser@cisco.com' limit 1];
        Account bu = [select Id from Account where Name =: 'BUTestSerge' limit 1];
        Contact c = [select Id from Contact where Email =: 'testSerge123@cisco.com' limit 1];

        system.runAs(user){
            Key_Stakeholders__c ks = new Key_Stakeholders__c();
            ks.Business_Unit_Account__c = bu.Id;
            ks.Name = 'Serge';
            ks.Contact__c =c.Id;
            insert ks;

            Key_Stakeholders__c ks1 = new Key_Stakeholders__c();
            ks1.Business_Unit_Account__c = bu.Id;
            ks1.Name = 'Serge1';
            ks1.Contact__c =c.Id;
            insert ks1;

            Key_Stakeholders__c ks2 = new Key_Stakeholders__c();
            ks2.Business_Unit_Account__c = bu.Id;
            ks2.Name = 'Serge2';
            ks2.Contact__c =c.Id;
            ks2.Primary_Contact__c = true;
            insert ks2;

            List<Key_Stakeholders__c> ksConfirm =[select id from Key_Stakeholders__c where Business_Unit_Account__c=: bu.Id];
            System.assertEquals(3,ksConfirm.size());

        }
    }
    
    static testMethod void keyStakeholder_MultipleNegative() {
        User user = [select Id from User where Username =: 'newuser@cisco.com' limit 1];
        Account bu = [select Id from Account where Name =: 'BUTestSerge' limit 1];
        Contact c = [select Id from Contact where Email =: 'testSerge123@cisco.com' limit 1];

        system.runAs(user){
            Key_Stakeholders__c ks = new Key_Stakeholders__c();
            ks.Business_Unit_Account__c = bu.Id;
            ks.Name = 'Serge';
            ks.Contact__c =c.Id;
            insert ks;

            Key_Stakeholders__c ks1 = new Key_Stakeholders__c();
            ks1.Business_Unit_Account__c = bu.Id;
            ks1.Name = 'Serge1';
            ks1.Primary_Contact__c = true;
            ks1.Contact__c =c.Id;
            insert ks1;

            Key_Stakeholders__c ks2 = new Key_Stakeholders__c();
            ks2.Business_Unit_Account__c = bu.Id;
            ks2.Name = 'Serge2';
            ks2.Contact__c =c.Id;
            ks2.Primary_Contact__c = true;
            try {
                Database.SaveResult insertResult = Database.insert(ks2, false);

            } catch (Exception e){
                Boolean expectedExceptionThrown =  e.getMessage().contains('To mark this key stakeholder') ? true : false;
                System.assertEquals(false, expectedExceptionThrown);
            } 

            List<Key_Stakeholders__c> ksConfirm =[select id from Key_Stakeholders__c where Business_Unit_Account__c=: bu.Id];
            System.assertEquals(2,ksConfirm.size());
        }
    }
        
      static testMethod void keyStakeholder_MultipleNegative2() {
        User user = [select Id from User where Username =: 'newuser@cisco.com' limit 1];
        Account bu = [select Id from Account where Name =: 'BUTestSerge' limit 1];
        Contact c = [select Id from Contact where Email =: 'testSerge123@cisco.com' limit 1];

        system.runAs(user){
            Key_Stakeholders__c ks = new Key_Stakeholders__c();
            ks.Business_Unit_Account__c = bu.Id;
            ks.Name = 'Serge';
            ks.Contact__c =c.Id;
            insert ks;

            Key_Stakeholders__c ks1 = new Key_Stakeholders__c();
            ks1.Business_Unit_Account__c = bu.Id;
            ks1.Name = 'Serge1';
            ks1.Primary_Contact__c = true;
            ks1.Contact__c =c.Id;
            insert ks1;

            Key_Stakeholders__c ks2 = new Key_Stakeholders__c();
            ks2.Business_Unit_Account__c = bu.Id;
            ks2.Name = 'Serge2';
            ks2.Contact__c =c.Id;
            ks2.Primary_Contact__c = true;
            try {
                Database.SaveResult insertResult = Database.insert(ks2, false);

            } catch (Exception e){
                System.assertEquals(true, e.getMessage().contains('To mark this key stakeholder'));
            } 

            List<Key_Stakeholders__c> ksConfirm =[select id from Key_Stakeholders__c where Business_Unit_Account__c=: bu.Id];
            System.assertEquals(2,ksConfirm.size());
        }
      } 
      
      static testMethod void keyStakeholder_updatePositive() {
        User user = [select Id from User where Username =: 'newuser@cisco.com' limit 1];
        Account bu = [select Id from Account where Name =: 'BUTestSerge' limit 1];
        Contact c = [select Id from Contact where Email =: 'testSerge123@cisco.com' limit 1];

        system.runAs(user){
            Key_Stakeholders__c ks = new Key_Stakeholders__c();
            ks.Business_Unit_Account__c = bu.Id;
            ks.Name = 'Serge';
            ks.Contact__c =c.Id;
            insert ks;

            Key_Stakeholders__c ks1 = new Key_Stakeholders__c();
            ks1.Business_Unit_Account__c = bu.Id;
            ks1.Name = 'Serge1';
            ks1.Contact__c =c.Id;
            insert ks1;

            Key_Stakeholders__c ks2 = new Key_Stakeholders__c();
            ks2.Business_Unit_Account__c = bu.Id;
            ks2.Name = 'Serge2';
            ks2.Contact__c =c.Id;
            
            try {
                Database.SaveResult insertResult = Database.insert(ks2, false);

            } catch (Exception e){
                System.assertEquals(true, e.getMessage().contains('To mark this key stakeholder'));
            } 

            ks2.Primary_Contact__c = true;
            update ks2;
            

            List<Key_Stakeholders__c> ksConfirm =[select id from Key_Stakeholders__c where Business_Unit_Account__c=: bu.Id];
            System.assertEquals(3,ksConfirm.size());
        }
      }   
      
       static testMethod void keyStakeholder_updateNegative() {
        User user = [select Id from User where Username =: 'newuser@cisco.com' limit 1];
        Account bu = [select Id from Account where Name =: 'BUTestSerge' limit 1];
        Contact c = [select Id from Contact where Email =: 'testSerge123@cisco.com' limit 1];

        system.runAs(user){
            Key_Stakeholders__c ks = new Key_Stakeholders__c();
            ks.Business_Unit_Account__c = bu.Id;
            ks.Name = 'Serge';
            ks.Contact__c =c.Id;
            insert ks;

            Key_Stakeholders__c ks1 = new Key_Stakeholders__c();
            ks1.Business_Unit_Account__c = bu.Id;
            ks1.Name = 'Serge1';
            ks1.Contact__c =c.Id;
            ks1.Primary_Contact__c = true;
            insert ks1;

            Key_Stakeholders__c ks2 = new Key_Stakeholders__c();
            ks2.Business_Unit_Account__c = bu.Id;
            ks2.Name = 'Serge2';
            ks2.Contact__c =c.Id;
            
            try {
                Database.SaveResult insertResult = Database.insert(ks2, false);

            } catch (Exception e){
                System.assertEquals(true, e.getMessage().contains('To mark this key stakeholder'));
            } 

            ks2.Primary_Contact__c = true;       
            try {
                update ks2;
            } catch (Exception e){
                System.assertEquals(true, e.getMessage().contains('To mark this key stakeholder'));
            } 
            List<Key_Stakeholders__c> ksConfirm =[select id from Key_Stakeholders__c where Business_Unit_Account__c=: bu.Id];
            System.assertEquals(3,ksConfirm.size());
        }
      }     
      
       static testMethod void keyStakeholder_deleteCaseSanityTest() {
       User user = [select Id from User where Username =: 'newuser@cisco.com' limit 1];
        Account bu = [select Id from Account where Name =: 'BUTestSerge' limit 1];
        Contact c = [select Id from Contact where Email =: 'testSerge123@cisco.com' limit 1];

        system.runAs(user){
            Key_Stakeholders__c ks = new Key_Stakeholders__c();
            ks.Business_Unit_Account__c = bu.Id;
            ks.Name = 'Serge';
            ks.Contact__c =c.Id;
            insert ks;

            Key_Stakeholders__c ks1 = new Key_Stakeholders__c();
            ks1.Business_Unit_Account__c = bu.Id;
            ks1.Name = 'Serge1';
            ks1.Contact__c =c.Id;
            ks1.Primary_Contact__c = true;
            insert ks1;

            Key_Stakeholders__c ks2 = new Key_Stakeholders__c();
            ks2.Business_Unit_Account__c = bu.Id;
            ks2.Name = 'Serge2';
            ks2.Contact__c =c.Id;
            
            try {
                Database.SaveResult insertResult = Database.insert(ks2, false);

            } catch (Exception e){
                System.assertEquals(true, e.getMessage().contains('To mark this key stakeholder'));
            } 

            try {
                delete ks2;
            } catch (Exception e){
                System.assertEquals(true, e.getMessage().contains('To mark this key stakeholder'));
            } 
            
            undelete ks2;
            
            List<Key_Stakeholders__c> ksConfirm =[select id from Key_Stakeholders__c where Business_Unit_Account__c=: bu.Id];
            System.assertEquals(3,ksConfirm.size());
        }
       }
        
}