/*
Test Class for EcosystemPartnerSharing
*/
@isTest
public class EcosystemPartnerSharingBatch_Test {
    public static testMethod void testprogramenrollment(){  
        List < sObject > objRecTypeData = Test.loadData(ObjectRecordTypeIds__c.sObjectType,'GlobalTestObjectRecordTypeIds');
        List < sObject > osCSData = Test.loadData(Org_Constants__c.sObjectType,'OrgConstants');
        Org_Constant_CS__c ocs = new Org_Constant_CS__c();
        ocs.name = 'Exclude From PUI and Competitor Popup';
        ocs.Non_Production_Value__c = 'Cisco_ADMIN';
        ocs.Production_Value__c = 'Cisco_ADMIN';
        insert ocs;

        Id RecordTypeIdpartneraccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId();
        Id RecordTypeIdchannelaccount1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel').getRecordTypeId();
        Id RecordTypeIdchannelaccountend = Schema.SObjectType.Account.getRecordTypeInfosByName().get('End-User').getRecordTypeId();

        Account endCustomerAccount = new Account(name='Test End-User Account',CRName__c ='Test End-User Account',RECORDTYPEID=RecordTypeIdchannelaccountend,Country__c='UNITED STATES');
        insert endCustomerAccount;

        Account a = new Account(name='TestAccount',Partner_Account_Status__c= 'Active (Registered)',Partner_Company_Status__c='Active (Registered)',recordTypeId=RecordTypeIdpartneraccount,Country__c='UNITED STATES',IsEcosystemPartner__c=false );
        Insert a;

        Partner_Program_Enrollment__c PPE = new Partner_Program_Enrollment__c();
        PPE.Name='Cisco Sales Collaboration Platform1';
        PPE.PROGRAM_ENROLLMENT_STATUS__C='Active';
        PPE.PARTNER_COMPANY__C = a.id;

        PPE.Program_Effective_Date__c = system.today()-1;
        PPE.Program_Expiration_Date__c = system.today()+5;
        PPE.PROGRAM_UN_ID__c = '178662201-AUTHORIZATION-ATP-OPCR';
        insert PPE; 
      
        Account channelAccount = new Account(name='Test Channel Account',Partner_Account_Status__c= 'Active (Registered)',Partner_Company_Status__c='Active (Registered)',Type='Distributor',PDB_BE_GEO_ID__c = '2345',parentid=a.Id, RECORDTYPEID=RecordTypeIdchannelaccount1 ,Country__c='UNITED STATES',IsEcosystemPartner__c=true,Geographic_Region__c='APAC');
        insert channelAccount ; 

        User currentUser = [select defaultCurrencyIsoCode,id from User where Id = :UserInfo.getUserId()];                                
        Test.startTest();
            SchedulableContext sc = null;
            EcosystemPartnerSharingSchedule CSCR = new EcosystemPartnerSharingSchedule();
            CSCR.execute(sc);
        Test.stopTest();   
    }
 }