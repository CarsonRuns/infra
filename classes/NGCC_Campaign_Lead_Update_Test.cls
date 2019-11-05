/**************************************************************************************************
Name    : NGCC_Campaign_Lead_Update_Test
Author  : Fazurulla Ganganapalli
Purpose : NGCC_Campaign_Lead_Update_Test class is usefull for NGCC_Campaign_Lead_Update batch class code coverage.
Created Date: 11/16/2015
Modification History: 
**************************************************************************************************/
@isTest
private class NGCC_Campaign_Lead_Update_Test {
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
        objrecType.MARKETING_LEAD_RECORDTYPE__C='01280000000GEtX';
        objrecType.MARKETING_QUALIFIED_LEAD__C='01280000000GEtX';
        objrecType.CEE_OBX_Record_Type_ID__c='01280000000GFZzAAO';
        insert objrecType;    
    }
    
    static testmethod void test() {
        loadOrgRecTypeCS();
        Campaign camp = new Campaign();
        camp.Name = 'test';
        camp.Priority__c = 2;
        camp.Status = 'Cancelled';
        camp.Maximum_No_Attempts__c = 3;
        insert camp;
        
        Lead ld = new Lead();
        ld.RecordTypeId = Schema.Sobjecttype.Lead.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        ld.LastName = 'My Lead';
        ld.Campaign_Name__c = camp.Id;
        ld.Company = 'My Company';
        ld.CustomCountry__c = 'India';
        ld.LeadSource='Web';
        
        insert ld;        
        
        Set<Id> St = new Set<Id>();
        St.add(camp.id);
        
        Map<Id,Campaign> Mp = new Map<Id,Campaign>();
        Mp.put(camp.id,camp);
        
        Test.startTest();
        NGCC_Campaign_Lead_Update CampaignLU = New NGCC_Campaign_Lead_Update(St,Mp);
        Database.executeBatch(CampaignLU);
        Test.stopTest();
        
        camp.Status = 'Completed';
        update camp;   
            
            system.debug('record type id : '+ ld.recordTypeId);
            
        Campaign camp1 = new Campaign();
        camp1.Name = 'test';
        camp1.Program_Originating_Country__c = 'UNITED STATES';
        camp1.Maximum_No_Attempts__c = 3;
        insert camp1;
        
        ld.Campaign_Name__c = camp1.Id;
        
        update ld;
        
        
    }
}