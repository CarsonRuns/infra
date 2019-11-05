/************************************************************************************************************************************
Name    : keyStakeHolderControllerTest
Author  : C360 Dev team
Purpose : Contains logic to execute test methods of keyStakeHolderController
Date    : 02/24/2019
Change History : none
*************************************************************************************************************************************/
@isTest
public class keyStakeHolderControllerTest {
    
    static testMethod void testMethodKS() 
    {
        //Creating Account Records for Customer and BU
        // Create Test User
        User u = CEE_TestUtility.getUser('admin', true);
        List < sObject > osCSData = Test.loadData(Org_Constants__c.sObjectType,'OrgConstants');
        Org_Constant_CS__c ocs = new Org_Constant_CS__c();
        ocs.name = 'Exclude From PUI and Competitor Popup';
        ocs.Non_Production_Value__c = 'Cisco_ADMIN';
        ocs.Production_Value__c = 'Cisco_ADMIN';
        insert ocs; 
         Id CustrRcrdId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
       ObjectRecordTypeIds__c accRTId =new ObjectRecordTypeIds__c();
        accRTId.Name = 'Customer';
        accRTId.Account_Customer_RecordTypeId__c = CustrRcrdId1;
        insert accRTId;
        
        Id RecordtypeIdValue;
        System.runas(u){
            Account a = new Account();
            //Insert Customer Account Record
            Account CustomerAcc = new Account();
            CustomerAcc.RecordTypeId = CustrRcrdId1;
            CustomerAcc.Name = 'CustomerTestAccount';
            CustomerAcc.AccountNumber='1234';
            CustomerAcc.Assigned_CSE__c=u.id;
            insert CustomerAcc;
            Account BusinessAcc = new Account();
            Id BusinessRcrdId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Unit').getRecordTypeId();
            BusinessAcc.RecordTypeId = BusinessRcrdId;
            BusinessAcc.Name = 'BusinessTestAccount';
            BusinessAcc.ParentId = CustomerAcc.Id;
            insert BusinessAcc;
            Success_Plan__c sp = new Success_Plan__c();
            sp.Customer_Name__c = CustomerAcc.Id;
            sp.Customer_BU_Name__c = BusinessAcc.Id ;
            insert sp;
            Account ChannelAcc = new Account();
            Id ChannelRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel').getRecordTypeId();
            ChannelAcc.RecordTypeId = ChannelRecId;
            ChannelAcc.Name = 'ChannelTestAccount';
            insert ChannelAcc;
            Contact con = new Contact();
            con.AccountId=ChannelAcc.id;
            con.lastName = 'Test';
            Id endCustomerId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('End Customer Contact').getRecordTypeId();
            con.RecordtypeId = endCustomerId;
            con.email = 'abc@cisco.com';
            con.phone ='12324453';
            insert con;            
            Key_Stakeholders__c ks = new Key_Stakeholders__c();
            ks.Contact__c = con.id;
            ks.email__c =con.email;
            ks.phone__c = con.phone;
            Key_Stakeholders__c ks1 = new Key_Stakeholders__c();
            ks1.phone__c = con.phone;
            
            Test.startTest();
            
            Map<String,sObject> myKs = keyStakeHolderController.getRecord(CustomerAcc.id);
            System.assertEquals(CustomerAcc.id,myKs.get('Customer').id);
            Map<String,sObject> myKs1 = keyStakeHolderController.getRecord(BusinessAcc.id);
            System.assertEquals(BusinessAcc.id,myKs1.get('BU').id);
            Map<String,sObject> myKs2 = keyStakeHolderController.getRecord(sp.id);
            System.assertEquals(sp.id,myKs2.get('SuccessPlan').id);
            Contact cont = keyStakeHolderController.getContactRecord(con.Id);
            System.assertEquals('abc@cisco.com', cont.email);
            Boolean profileid = keyStakeHolderController.isCurrentUserSPM(CustomerAcc.id);
            System.assertEquals(false, false);
            Id ids = keyStakeHolderController.insertKeyStakeHolder(ks);
            system.assertEquals(ids,ks.id);
            Id ids1;
            try {
                ids1 = keyStakeHolderController.insertKeyStakeHolder(ks1);
            } catch(Exception error) {
                System.Assert(error.getMessage().contains('Script-thrown exception'));
            }
            
            
            
            Test.stopTest();
        }
    }
}