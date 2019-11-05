/************************************************************************************************************************************
Name    : MyAccountTeamContactControllerTest
Author  : C360 Dev team
Purpose : Contains logic to execute test methods of MyAccountTeamContactController - First Release
Date    : 02/24/2019
Change History : none
*************************************************************************************************************************************/

@isTest
public class MyAccountTeamContactControllerTest { 
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
        String Name=u.LastName;
        Name = 'Test';
        update u;
        System.runas(u){
            Account a = new Account();
            //Insert Customer Account Record
            Account CustomerAcc = new Account();
            Id CustrRcrdId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            CustomerAcc.RecordTypeId = ObjectRecordTypeIds__c.getInstance().AccountChannelRecordTypeId__c;
            CustomerAcc.Name = 'CustomerTestAccount';
            insert CustomerAcc;
            system.debug('CustomerAcc>>>'+CustomerAcc); 
            Account BusinessAcc = new Account();
            Id BusinessRcrdId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Unit').getRecordTypeId();
            BusinessAcc.RecordTypeId = BusinessRcrdId;
            BusinessAcc.Name = 'BusinessTestAccount';
            BusinessAcc.ParentId = CustomerAcc.Id;
            insert BusinessAcc;
            system.debug('BusinessAcc>>>'+BusinessAcc);
            //Insert Offer Records
            Offer__c offerObj = new Offer__c();
            offerObj.Name = 'CiscoTest';
            offerObj.Customer_Name__c = CustomerAcc.Id;
            offerObj.Customer_BU_Name__c = BusinessAcc.Id;
            insert offerObj;
            system.debug('offerObj>>>'+offerObj);
            CEE_TestUtility.loadCustomSettings();
            system.debug('Customsettings>>>'+ObjectRecordTypeIds__c.getInstance().AccountChannelRecordTypeId__c);
            //Get account
            Id EURcrdId = ObjectRecordTypeIds__c.getInstance().AccountChannelRecordTypeId__c;
            a = new Account(name='Test End-User Account1',parentid=BusinessAcc.id,RECORDTYPEID=EURcrdId);
            insert a;
            system.debug('account>>>'+a);
            accountteammember atm= new accountteammember();
            atm.AccountId=a.id;
            atm.userid=u.id;
            atm.teammemberrole='Sales Engineer'; 
            insert atm;
            system.debug('teammember>>>'+atm);
            Integer Limits=10;
            String URL='ciscourl';
            
            Test.startTest();
            Boolean isCustomerRT = false;
            List<AccountTeamMember> accTeamMemAcc = MyAccountTeamContactController.getTeamLists(a.id);
            List<AccountTeamMember> accTeamMemAcc1 = MyAccountTeamContactController.getTeamLists(BusinessAcc.id);
            List<AccountTeamMember> accTeamMemOff = MyAccountTeamContactController.getTeamLists(offerObj.id);
            Integer teamMemCountAcc= MyAccountTeamContactController.TotalTeamMembers(BusinessAcc.id);  
            Integer teamMemCountOff= MyAccountTeamContactController.TotalTeamMembers(offerObj.id);
            system.debug('teamMemCountOff'+teamMemCountOff);
             system.debug('teamMemCountAcc'+teamMemCountAcc);
            MyAccountTeamContactController.getAccountTeamMemberListLazy(Limits,offerObj.id);
            MyAccountTeamContactController.getAccountTeamMemberListLazy(Limits,BusinessAcc.id);
            MyAccountTeamContactController.AccountTeamMemberWrapper obj = new MyAccountTeamContactController.AccountTeamMemberWrapper(u.name,atm.teammemberrole,u.Alias,u.User_Id_18__c,URL);
            system.assertNotEquals(teamMemCountAcc, 0);
            //system.assertEquals(teamMemCountOff, 1); 
            Test.stopTest();
        }
    }
    
}