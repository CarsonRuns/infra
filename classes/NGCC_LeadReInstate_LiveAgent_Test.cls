@istest(SeeAllData=true)
global class NGCC_LeadReInstate_LiveAgent_Test{ 
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
     public static testmethod void cmdTestMethod(){
        lead l = new lead();
        l.lastname = 'test';
        l.company = 'test';
        l.recordtypeid = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        l.status= 'New Prospect';
        l.customcountry__c='test';
        insert l;
        ApexPages.StandardController setCon = new ApexPages.StandardController(l);
        NGCC_LeadReInstate_LiveAgent_Cls n = new NGCC_LeadReInstate_LiveAgent_Cls(setCon);
        n.tempConcatenate = 'test';
        n.leadStatus = '--None--';
        n.cmdSubmit();
        n.leadStatus = 'New Prospect';
        n.leadStatusChoice ='Single Lead';
        n.cmdChoiceBtn();
        n.userName ='fgangana';
        n.leadId = l.id;
        n.cmdSubmit();
        n.leadStatusChoice ='Multiple Leads';
        n.cmdChoiceBtn();
        
        n.leadStatus = '--None--';
        n.cmdMultpleleadsBtn();
        
        n.leadStatusChoice ='';        
        n.cmdChoiceBtn();
        n.search();
        n.CustomPicklistForNotes();
        n.CustomPicklistForNotes1();
        n.CustomPicklistForNotes2();
        n.CustomPicklistForNotes3();
        n.CustomPicklistForNotes4();
        n.multiLeadList = 'test,test,test';
        n.leadStatus = 'New Status';
        n.cmdMultpleleadsBtn();
        
        n.multiLeadList = l.id;
        n.leadStatus = 'New Status';
        n.cmdMultpleleadsBtn();
        
        
        n.msgString ='test';
        n.cmdConcatinateStringIds();
        
     }
     public static testmethod void cmdTestMethod1(){
         lead l = new lead();
        l.lastname = 'test';
        l.company = 'test';
        l.recordtypeid = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        l.status= 'New Prospect';
        l.customcountry__c='test';
        insert l;
         NGCC_LeadReInstate_LiveAgent_Cls n = new NGCC_LeadReInstate_LiveAgent_Cls();
            n.cmdSearchButton();
            
            n.userName = 'fgangana';
            n.cmdUserHasLiveAgentAccess();
            n.getQuery(); 
            
            n.userStringId = '00580000007Hbuc';
            n.cmdUserHasLiveAgentAccess();
            n.getQuery(); 
            
            n.userStringId = l.id;
            n.cmdUserHasLiveAgentAccess();
            n.getQuery();
            
            n.userName= '';
            n.cmdUserHasLiveAgentAccess();
            n.getQuery(); 
           
     }
}