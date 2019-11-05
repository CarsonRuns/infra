@istest(SeeAllData=true)
global class NGCC_LiveAgentTool_Test{ 
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
         NGCC_LiveAgentTool_Cls n = new NGCC_LiveAgentTool_Cls();
         n.leadId = '00000000000000xx';
         n.choiseOption = '-None-';
         n.leadStatus = 'Test';
         n.leadStatusChoice = 'Test';
         n.multiLeadList  = 'Test';
         n.msgString = 'Test';
         n.tempConcatenate = 'Test';
         n.tempmultiLeadList = 'Test';
         n.teststring = 'Test';
         n.userName = 'dchamola';   
         n.showPageBlockTable = false;  
         n.liveAgentUserQuery = 'SELECT Id,isActive,name,UserPermissionsLiveAgentUser,USERPERMISSIONSSUPPORTUSER FROM User limit 1';    
         n.strQuery = 'SELECT Id,skillid,USERID,USER.name,USER.username,USER.Marketing_Call_Center__c,user.userroleid FROM SKILLUSER limit 1';
         list<LiveChatUserConfigUser> chatCapacityList1 = [select id,UserId,LiveChatUserConfig.MasterLabel,user.name,user.username,LiveChatUserConfigId,LiveChatUserConfig.Language,LiveChatUserConfig.Capacity from LiveChatUserConfigUser limit 1];
         n.chatCapacityList  = chatCapacityList1;
         n.skilUserDetails = database.query(n.liveAgentUserQuery) ;
         
         n.cmdSearchButton();
         n.cmdUserHasLiveAgentAccess();
         n.choiseOption = '-None-';
         n.cmdChoiceConfigBtn();
         n.choiseOption = '1';
         n.cmdChoiceConfigBtn();
         
         n.skilUserDetails[0].isActive = true;
         n.skilUserDetails[0].UserPermissionsLiveAgentUser = true;
         n.skilUserDetails[0].USERPERMISSIONSSUPPORTUSER = true;
         n.cmdSearchButton();
         n.cmdUserHasLiveAgentAccess();
         n.choiseOption = '-None-';
         n.cmdChoiceConfigBtn();
         n.choiseOption = '1';
         n.cmdChoiceConfigBtn();
         
         n.skilUserDetails[0].isActive = true;
         n.skilUserDetails[0].UserPermissionsLiveAgentUser = false;
         n.skilUserDetails[0].USERPERMISSIONSSUPPORTUSER = false;
         if(n.skilUserDetails[0].UserPermissionsLiveAgentUser && n.skilUserDetails[0].USERPERMISSIONSSUPPORTUSER){
             n.cmdSearchButton();
             n.cmdUserHasLiveAgentAccess();
             n.choiseOption = '-None-';
             n.cmdChoiceConfigBtn();
             n.choiseOption = '1';
             n.cmdChoiceConfigBtn();
         }
         
         
         n.skilUserDetails[0].isActive = false;
         n.cmdSearchButton();
         n.cmdUserHasLiveAgentAccess();
         n.choiseOption = '-None-';
         n.cmdChoiceConfigBtn();
         n.choiseOption = '1';
         n.cmdChoiceConfigBtn();
         
         n.userName = 'fganganaTest';
         n.cmdSearchButton();
         n.cmdUserHasLiveAgentAccess();
         n.choiseOption = '-None-';
         n.cmdChoiceConfigBtn();
         n.choiseOption = '1';
         n.cmdChoiceConfigBtn();
     }
     public static testmethod void cmdTestMethod1(){
         NGCC_LiveAgentTool_Cls n = new NGCC_LiveAgentTool_Cls();
         n.leadId = '00000000000000xx';
         n.choiseOption = '-None-';
         n.leadStatus = 'Test';
         n.leadStatusChoice = 'Test';
         n.multiLeadList  = 'Test';
         n.msgString = 'Test';
         n.tempConcatenate = 'Test';
         n.tempmultiLeadList = 'Test';
         n.teststring = 'Test';
         n.userStringId = '00580000007Hbuc';         
         n.showPageBlockTable = false;  
         n.liveAgentUserQuery = 'SELECT Id,isActive,name,UserPermissionsLiveAgentUser,USERPERMISSIONSSUPPORTUSER FROM User where isActive = true limit 1';    
         n.strQuery = 'SELECT Id,skillid,USERID,USER.name,USER.username,USER.Marketing_Call_Center__c,user.userroleid FROM SKILLUSER limit 1';
         list<LiveChatUserConfigUser> chatCapacityList1 = [select id,UserId,LiveChatUserConfig.MasterLabel,user.name,user.username,LiveChatUserConfigId,LiveChatUserConfig.Language,LiveChatUserConfig.Capacity from LiveChatUserConfigUser limit 1];
         n.chatCapacityList  = chatCapacityList1;
         n.cmdSearchButton();
         n.cmdUserHasLiveAgentAccess();
         n.choiseOption = '-None-';
         n.cmdChoiceConfigBtn();
         n.choiseOption = '1';
         n.cmdChoiceConfigBtn();
         
         n.userName = NULL;
         n.userStringId = NULL; 
         n.cmdSearchButton();
         n.cmdUserHasLiveAgentAccess();
         n.choiseOption = '-None-';
         n.cmdChoiceConfigBtn();
         n.choiseOption = '1';
         n.cmdChoiceConfigBtn();
         
         n.beginning();
         n.next();
         n.previous();
         n.last();
         n.getDisableNext();
         n.getDisablePrevious();
         n.refreshPageSize();
     }
}