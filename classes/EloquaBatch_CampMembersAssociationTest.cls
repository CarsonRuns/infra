/************************************************************************************************************************************
Name    : EloquaBatch_CampMembersAssociationTest 
Author  : Mukesh Srivastava
Purpose : This Test class are to validate two Eloqua Functionalities named as EloquaBatchScheduledUpdates and 
          EloquaCampaignAssociationUpdateTrg_Cls
Created Date: 3/18/2015
Modification History: 
    01/10/2016 - US10151 - updated loadOrgRecTypeCS to add data for Eloqua_Lead_Record_Type__c.

*************************************************************************************************************************************/
@isTest
public class EloquaBatch_CampMembersAssociationTest {
    
    static void loadOrgRecTypeCS(){
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
        insert objrecType;    
        
        // US10151 - Insert data in to Custom Setting - Eloqua_Lead_Record_Type__c
        List<Eloqua_Lead_Record_Type__c> eLdList = new List<Eloqua_Lead_Record_Type__c>();
        
        Eloqua_Lead_Record_Type__c mLead = new Eloqua_Lead_Record_Type__c();
        mLead.Name='Manual';
        mLead.Record_Type_Id__c = '0123000000004aSAAQ';
        eLdList.add(mLead);
        
        Eloqua_Lead_Record_Type__c eLead = new Eloqua_Lead_Record_Type__c();
        eLead.Name='eLead';
        eLead.Record_Type_Id__c = '0123000000004aRAAQ';
        eLdList.add(eLead);
        
        insert eLdList;
        
    }
    //Setting Up data for This test class
    @testSetup static void setupTestData() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Cisco_Admin' Limit 1];
        User uEL = new User(Alias = 'newUser', Email = 'eloqua_integration@cisco.com',
            EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'eloqua_integration@cisco.com.testing', Theatre__c = 'Americas-US Commercial');
        system.RunAs(uEL){   
        loadOrgRecTypeCS();
        List < Lead > ld = new List < Lead > ();  
        List < sObject > cCampMemStatus = Test.loadData(EloquaCampaignMemberStatus__c.sObjectType,'EloquaTestCampaignMemberStatus');
        List < sObject > eUpdateCS = Test.loadData(EloquaFieldUpdates__c.sObjectType, 'EloquaTestDataFieldUpdate'); //Custom Setting for Field Mapping
        List < sObject > mLeads = Test.loadData(Lead.sObjectType, 'EloquaTestDataLead'); //Creating Manual Leads
        List < sObject > mCamps = Test.loadData(Campaign.sObjectType, 'EloquaTestDataCampaign'); //Creating Campaigns
        
        //Setting up Notification Id for Batch completion notification
        Apex_Batch_Job__c abJ = new Apex_Batch_Job__c();
        abj.Name = 'EloquaBatchJob';
        abj.NotificationEmailId__c = 'test@test.com';
        insert abj;
        }
    }

    //@ Testing EloquaBatchScheduledUpdates batch class for making sure Eloqua details are copied to Duplicate leads
    static testMethod void testLeadScoreBatchUpdate() {
        Test.startTest();
        EloquaBatchScheduledUpdates eBSUpdate = new EloquaBatchScheduledUpdates();
        Id batchinstanceid;
        batchinstanceid = database.executeBatch(eBSUpdate, 10);
        Test.stopTest();
    }

    //@ Testing EloquaCampaignAssociationUpdateTrg_Cls for updating campaign Detail on Leads
    static testMethod void testLeadCampaignAssociation() {
        List < Campaign > lstCamp = [Select Id from Campaign Limit 10];
        List < Lead > lstLead = [Select Id from Lead Limit 30];
        List < CampaignMember > lstCM = new List < CampaignMember > ();
        List<EloquaCampaignMemberStatus__c> sf=new list<EloquaCampaignMemberStatus__c>([Select Id from EloquaCampaignMemberStatus__c]);
        system.debug('sfsfsfsfsfs'+sf);
        for (Campaign cObj: [Select Id from Campaign Limit 10]) {
            for (Lead lObj: lstLead) {
                CampaignMember cm = new CampaignMember();
                cm.LeadId = lObj.Id;
                cm.CampaignId = cObj.Id;
                cm.Status = 'Sent';
                lstCM.add(cm);
            }
        }
        Test.startTest();
        Insert lstCM;
        Test.stopTest();

    }
}