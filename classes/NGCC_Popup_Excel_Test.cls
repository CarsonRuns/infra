@isTest(seeAllData=True) public class NGCC_Popup_Excel_Test{
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
    }
    public static testMethod void requalification_Mtd(){
       NGCC_Popup_Excel_Cls npc = new NGCC_Popup_Excel_Cls();
       
        npc.endDateFixed = string.valueOf(system.now());
        npc.startDateFixed = string.valueOf(system.now());
        npc.searchCallCenter ='Convergys Manila - Global';
        npc.cmdExportToExcel();
       LeadHistory lhr = [SELECT  LeadId,lead.lastname,lead.firstname,LEAD.STATUS,lead.SDR_Lead_Owner_Name__c,lead.CustomCountry__c, NewValue, OldValue,createdby.name, CreatedDate,Lead.leadsource,
            lead.recordtypeid,lead.Call_Center_Vendor__c,lead.Lead_Qualifier_Call_Center__c FROM LeadHistory limit 1];
        NGCC_Popup_Excel_Cls.RequalificationRecordsTempHolder r = new NGCC_Popup_Excel_Cls.RequalificationRecordsTempHolder(lhr);
       
    }
 }