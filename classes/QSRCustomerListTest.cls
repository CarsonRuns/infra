@isTest
public class QSRCustomerListTest {
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
            
            Success_Plan__c SPlan = new Success_Plan__c();
            SPlan.Name = 'Test123';
            SPlan.Customer_BU_Name__c = acc3.Id;
            insert SPlan;
            
            QSR__c QSR= new QSR__c();
            QSR.Success_Plan__c  = SPLan.Id;      
            QSR.Name = 'opp name';
            QSR.Meeting_Date__c= date.today();
            QSR.Meeting_Status__c = 'In Progress';
            QSR.Cisco_FY_FQ__c ='Q3FY19';
            insert QSR;
            
            //Starting test
            Test.startTest(); 
            
            Boolean isCustomerRT = QSRCustomerList.getRecordtype(acc.Id);
            System.assertEquals(isCustomerRT,true);          
            List<QSR__c> QSRList = QSRCustomerList.fetchParentQSRList(acc3.Id,true);
            System.assertEquals(QSRList.size(),0);
            
            
            Test.stopTest(); 
            
        }
    }
    
    static testMethod void test2(){
        test.startTest();
        Integer numberOpp = QSRCustomerList.TotalQSR('',true);
        System.assertEquals(numberOpp,numberOpp);
        List<QSR__c> QSRList1 = QSRCustomerList.getQSR(30,'', true);
        System.assertEquals(QSRList1.size(),QSRList1.size());
        test.stopTest();
    }   
}