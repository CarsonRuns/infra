/************************************************************************************************************************************
Name    : C360_SuccessPlan_Trigger_HandlerTest
Author  : C360 Dev team
Purpose : Contains logic to execute test methods of Handler class for success plan object trigger 
Date    : 28/06/2019
Change History : None
*************************************************************************************************************************************/
@isTest
public class C360_SuccessPlan_Trigger_HandlerTest {
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
        
        insert new ObjectRecordTypeIds__c(Account_Customer_RecordTypeId__c=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId());
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
            
            test.startTest();
            try
            {
                List<Success_Plan__c> SPList = new List<Success_Plan__c>();
                Success_Plan__c sp= new Success_Plan__c();
                sp.Name = 'SP Name';
                sp.Active__c = 'Yes';
                sp.Customer_Name__c = acc.Id;
                sp.Customer_BU_Name__c=acc2.Id;
                insert sp;  
                SPList.add(sp);
                // sp.Customer_BU_Name__c = acc2.Id;
                // update sp;
                Success_Plan__c sp2= new Success_Plan__c();
                sp2.Name = 'SP Name Test';
                sp2.Active__c = 'No';
                sp2.Customer_Name__c = acc.Id;
                sp2.Customer_BU_Name__c = acc2.Id;    
                insert sp2; 
                sp2.Active__c='Yes';
                sp2.Name='Test';
                update sp2;
                SPList.add(sp2);
                
                Success_Plan__c sp3= new Success_Plan__c();
                sp3.Name = 'SP Name';
                sp3.Active__c = 'Yes';
                sp3.Customer_Name__c = acc.Id;
                insert sp3; 
                SPList.add(sp3);
                Success_Plan__c sp4= new Success_Plan__c();
                sp4.Name = 'SP Name Test1';
                sp4.Active__c = 'Yes';
                sp4.Customer_Name__c = acc.Id;
                insert sp4; 
                // sp4.Active__c='Yes';
                // sp4.Name= 'SP Test';
                // update sp4;
                SPList.add(sp4);
            }
            
            catch(Exception e) {
                Boolean expectedExceptionThrown = e.getMessage().contains('A new Success Plan cannot be created for this BU. Please mark any existing active Success Plans as not Active before creating a new Success Plan') ? true : false;
                //   System.Assert(expectedExceptionThrown,true);
                Boolean expectedExceptionThrown1 = e.getMessage().contains('A new Success Plan cannot be created for this customer. Please mark any existing active Success Plans as not Active before creating a new Success Plan') ? true : false;
                //   System.Assert(expectedExceptionThrown1,true);
                Boolean expectedExceptionThrown2 = e.getMessage().contains('Success Plan Name you have selected already exists, Please select another Name for the Success Plan .') ? true : false;
                //   System.Assert(expectedExceptionThrown2,true);
            } 
            
            test.stopTest();            
        }}
    static testMethod void testMethod2() 
    {
        C360_SuccessPlan_Trigger_Handler.processAfterDelete();
        C360_SuccessPlan_Trigger_Handler.processAfterInsert();
        C360_SuccessPlan_Trigger_Handler.processAfterUnDelete();
        C360_SuccessPlan_Trigger_Handler.processAfterUpdate();
        C360_SuccessPlan_Trigger_Handler.processBeforeDelete();
        C360_SuccessPlan_Trigger_Handler.processBeforeUpdate();
    }
}