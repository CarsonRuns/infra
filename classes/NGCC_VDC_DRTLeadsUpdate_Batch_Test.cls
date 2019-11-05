/***************************************************************************************************
Name    : NGCC_VDC_DRTLeadsUpdate_Batch_Test
Author  : Zakeahmed
Purpose : This class is responsible for testing NGCC_VDC_DRTLeadsUpdate_Batch Apex class
Created Date: 05/20/2019
Go Live: May-31st-2019
****************************************************************************************************/

@isTest(seeAllData=true)
public class NGCC_VDC_DRTLeadsUpdate_Batch_Test {
    
    public static void loadCustomData(){
        ObjectRecordTypeIds__c objrecType = new ObjectRecordTypeIds__c();
        objrecType.ACCOUNTCHANNELRECORDTYPEID__C='0123000000004aV';
        objrecType.ACCOUNT_END_USER_RECORDTYPEID__C='0123000000004aU';
        objrecType.ACCOUNTPARTNERCOMPANYRECORDTYPEID__C='01280000000G6ts';
        objrecType.CONTACT_MANUAL_ENDUSER_RECORDTYPEID__C='0123000000004aT';
        objrecType.CONTACT_MANUAL_PARTNER_RECORDTYPEID__C='01280000000G6ti';
        objrecType.CONTACT_PDB_RECORDTYPEID__C='01280000000G6tn';
        objrecType.CLOSED_LEAD_RECORDTYPEID__C='012300000001O02';
        objrecType.ELEADSRECORDTYPEID__C='0123000000004aR';
        objrecType.MANUAL_LEAD_RECORDTYPEID__C='0123000000004aS';
        objrecType.OPPORTUNITY_PARENT_RECORDTYPEID__C='0123000000003yk';
        objrecType.OPPORTUNITY_PARTNER_PARENT_RECORDTYPEID__C='0128000000020Dl';
        objrecType.OPPORTUNITY_PARTNER_PHASE_RECORDTYPEID__C='0128000000020Dq';
        objrecType.OPPORTUNITY_PHASE_RECORDTYPEID__C='012300000000CDL';
        objrecType.OPPORTUNITY_SOLUTION_PLAN_RECORDTYPEID__C='012300000000bfZ';
        objrecType.OPPORTUNITY_VOID_MERGED_RECORDTYPEID__C='012800000002e0M';
        objrecType.PARTNER_GENERATED_LEAD_RECORDTYPEID__C='012300000000lFW';
        objrecType.GSPO_QUALIFICATION_RECORD_TYPE__C='01280000000G7GD';
        objrecType.LCD_QUALIFICATION_RECORD_TYPE_ID__C='012800000003c7X';
        objrecType.BTX_ENGAGEMENT_ACTIVITY__C='01280000000G6LR';
        objrecType.BTX_NON_ENGAGEMENT_ACTIVITY__C='01280000000G6Lb';
        objrecType.CASE_TSN_RECORDTYPE__C='01280000000G78n';
        objrecType.MARKETING_LEAD_RECORDTYPE__C='012S00000000fSJ';
        objrecType.MARKETING_QUALIFIED_LEAD__C='012S00000000fSK';
        objrecType.CEE_OBX_Record_Type_ID__c='01280000000GFZzAAO';
        objrecType.CEE_CPOC_Record_Type_ID__c = '01234000000BmCR';
    }
  
    @isTest
    public static void VDCDRTLeads() {
    Id recordTypeIdProspect = Schema.getGlobalDescribe().get('Lead').getDescribe().getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
    Id recordTypeIdClosed = Schema.getGlobalDescribe().get('Lead').getDescribe().getRecordTypeInfosByName().get('Closed').getRecordTypeId();
    Id recordTypeIdVDC = Schema.getGlobalDescribe().get('Lead').getDescribe().getRecordTypeInfosByName().get('VDC').getRecordTypeId();
    String recordTypeNameVDC = 'VDC';
        
        User IntegrationUser = new User(Alias = 'newUser', Email = 'newIntegrationusertest@cisco.com',
                                        EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                                        LocaleSidKey = 'en_US', ProfileId = '00e30000000dcbgAAA',TimeZoneSidKey = 'America/Los_Angeles', 
                                        UserName = 'newIntegrationusertest@testorg.com', Theatre__c = 'EMEAR');
        insert IntegrationUser;
        Lead l;
        l = new Lead(firstname='VDCDRTLead', LastName='VDCDRTLead', company='Test', 
                     customCountry__c = 'UNITED STATES', VDC_Decision__c='DRT', Status='New Prospect', RecordTypeId = recordTypeIdVDC);
        System.runAs(IntegrationUser){
            insert l;
        }
       loadCustomData();
       Test.StartTest();
       NGCC_VDC_DRTLeadsUpdate_Batch ngccDRT = new NGCC_VDC_DRTLeadsUpdate_Batch();
       ID batchprocessid = Database.executeBatch(ngccDRT);
       Test.StopTest();
        //System.AssertEquals(database.countquery('SELECT Id, Status, VDC_Decision__c, RecordType.Name FROM Lead WHERE RecordType.Name =:recordTypeNameVDC AND VDC_Decision__c!=NULL'),200);
            Lead UpdatedLead = [SELECT Id, Status, VDC_Decision__c, RecordType.Name FROM Lead WHERE Id=:l.Id limit 1];
            system.assertEquals('Prospect', UpdatedLead.RecordType.Name);
   }
    @isTest
    public static void VDCNurtureLeads() {
    Id recordTypeIdProspect = Schema.getGlobalDescribe().get('Lead').getDescribe().getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
    Id recordTypeIdClosed = Schema.getGlobalDescribe().get('Lead').getDescribe().getRecordTypeInfosByName().get('Closed').getRecordTypeId();
    Id recordTypeIdVDC = Schema.getGlobalDescribe().get('Lead').getDescribe().getRecordTypeInfosByName().get('VDC').getRecordTypeId();
    String recordTypeNameVDC = 'VDC';
        
        User IntegrationUser = new User(Alias = 'newUser', Email = 'newIntegrationusertest@cisco.com',
                                        EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                                        LocaleSidKey = 'en_US', ProfileId = '00e30000000dcbgAAA',TimeZoneSidKey = 'America/Los_Angeles', 
                                        UserName = 'newIntegrationusertest@testorg.com', Theatre__c = 'EMEAR');
        insert IntegrationUser;
        Lead l;
         l = new Lead(firstname='VDCDRTLead', LastName='VDCDRTLead', company='Test', 
                     customCountry__c = 'UNITED STATES', VDC_Decision__c='Nurture', Status='New Prospect', RecordTypeId = recordTypeIdVDC);
        System.runAs(IntegrationUser){
            insert l;
        }
       loadCustomData();
       Test.StartTest();
       NGCC_VDC_DRTLeadsUpdate_Batch ngccDRT = new NGCC_VDC_DRTLeadsUpdate_Batch();
       ID batchprocessid = Database.executeBatch(ngccDRT);
       Test.StopTest();
        
            Lead UpdatedLead = [SELECT Id, Status, VDC_Decision__c, RecordType.Name FROM Lead WHERE Id=:l.Id limit 1];
        system.assertEquals('Closed', UpdatedLead.RecordType.Name);
        system.assertEquals('Nurture', UpdatedLead.VDC_Decision__c);
        system.assertEquals('Closed For Nurture', UpdatedLead.Status);
                
   }
    @isTest
    public static void VDCSuppressLeads() {
    Id recordTypeIdProspect = Schema.getGlobalDescribe().get('Lead').getDescribe().getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
    Id recordTypeIdClosed = Schema.getGlobalDescribe().get('Lead').getDescribe().getRecordTypeInfosByName().get('Closed').getRecordTypeId();
    Id recordTypeIdVDC = Schema.getGlobalDescribe().get('Lead').getDescribe().getRecordTypeInfosByName().get('VDC').getRecordTypeId();
    String recordTypeNameVDC = 'VDC';
        
        User IntegrationUser = new User(Alias = 'newUser', Email = 'newIntegrationusertest@cisco.com',
                                        EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                                        LocaleSidKey = 'en_US', ProfileId = '00e30000000dcbgAAA',TimeZoneSidKey = 'America/Los_Angeles', 
                                        UserName = 'newIntegrationusertest@testorg.com', Theatre__c = 'EMEAR');
        insert IntegrationUser;
        Lead l;
         l = new Lead(firstname='VDCDRTLead', LastName='VDCDRTLead', company='Test', 
                     customCountry__c = 'UNITED STATES', VDC_Decision__c='Suppress', Status='New Prospect', RecordTypeId = recordTypeIdVDC);
        System.runAs(IntegrationUser){
            insert l;
        }
       loadCustomData();
       Test.StartTest();
       NGCC_VDC_DRTLeadsUpdate_Batch ngccDRT = new NGCC_VDC_DRTLeadsUpdate_Batch();
       ID batchprocessid = Database.executeBatch(ngccDRT);
       Test.StopTest();
       
            Lead UpdatedLead = [SELECT Id, Status, VDC_Decision__c, RecordType.Name FROM Lead WHERE Id=:l.Id limit 1];
        system.assertEquals('Closed', UpdatedLead.RecordType.Name);
        system.assertEquals('Suppress', UpdatedLead.VDC_Decision__c);
        system.assertEquals('Closed For Suppress', UpdatedLead.Status);
                
   }
    @isTest()
    public static void NGCC_VDC_DRTLeadsUpdate_Batch_Schedule_Test(){
        Test.StartTest();
        NGCC_VDC_DRTLeadsUpdate_Batch_Schedule scJob = new NGCC_VDC_DRTLeadsUpdate_Batch_Schedule();      
        String every30Mins = '0 30 * * * ?';
        executeBatch();
        system.schedule('Test check', every30Mins, scJob);
        Test.stopTest();
    }
    
  
    public static void executeBatch() {
        NGCC_VDC_DRTLeadsUpdate_Batch VDCLeads = new NGCC_VDC_DRTLeadsUpdate_Batch ();
        database.executeBatch(VDCLeads);  
    }
}