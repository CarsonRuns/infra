@isTest
//(seealldata=true)
public class NGCC_Lead_Priority_Test {

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

    static testMethod void NGCC_LeadPriority_Test1(){
       /* Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='testUser@ngcc.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testUser@ngcc.com');
        insert u;
        System.runAs(u) {*/
        loadOrgRecTypeCS();
        Campaign cm = new Campaign();
        cm.name = 'Tst Campaign ';
        insert cm;
 
        CC_Master_Question_Answer_Bank__c ccMaster = new CC_Master_Question_Answer_Bank__c(name='M');
        insert ccMaster;
        
        ID rtId=Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Prospect').getRecordTypeID();
            
        list<NGCC_Rule_Assignment__c> rules = new list<NGCC_Rule_Assignment__c>();
        rules.add(new NGCC_Rule_Assignment__c(MODS_Leads__c='Lead Attribute',Countries__c='UK;US',Lead_Attribute__c='lastName',Priority__c='1',Rank__c='4',Theater__c='APJ',Value__c='m1,m'));
        rules.add(new NGCC_Rule_Assignment__c(MODS_Leads__c='Lead Attribute',Countries__c='UNITED STATES',Lead_Attribute__c='lastName',Priority__c='4-N/A',Rank__c='1',Theater__c='APJY',Value__c='m1,m'));

        rules.add(new NGCC_Rule_Assignment__c(MODS_Q_A__c=ccMaster.id,MODS_Leads__c='MODS Q/A',Countries__c='India;UNITED STATES',Priority__c='2',Rank__c='2',Theater__c='APJX',Value__c='m1,m'));
        rules.add(new NGCC_Rule_Assignment__c(MODS_Q_A__c=ccMaster.id,MODS_Leads__c='MODS Q/A',Countries__c='India;UNITED STATES',Priority__c='4-N/A',Rank__c='3',Theater__c='APJ',Value__c='m1,m'));
        insert rules;
        
        list<lead> leads = new list<lead>();
        leads.add(new lead(Campaign_Name__c = cm.id,lastName='m',CustomCountry__c='UNITED STATES',Theater__c='APJ',Company='Company',Status='1 Waiting',LeadSource='Web',recordtypeId=rtId));
        leads.add(new lead(Campaign_Name__c = cm.id,lastName='n',CustomCountry__c='UNITED STATES',Theater__c='APJY',Company='Company',Status='1 Waiting',LeadSource='Web',recordtypeId=rtId));
        leads.add(new lead(Campaign_Name__c = cm.id,lastName='o',CustomCountry__c='UNITED STATES',Theater__c='APJX',Company='Company',Status='1 Waiting',LeadSource='Web',recordtypeId=rtId));
        insert leads;
        
        list<CC_Response__c> response = new list<CC_Response__c>();
        response.add(new CC_Response__c(name='m',Lead__c=leads[0].id));
        
        insert response;
        
        
        list<CC_Response_Detail__c> detail = new list<CC_Response_Detail__c>();
        detail.add(new CC_Response_Detail__c(name='m',Response_Id__c=response[0].id,Customer_Response_Detail__c='m',CC_Master_Question_Answer_Bank__c=ccMaster.id));
        insert detail;
        
        
        for(Lead l : Leads){
            l.ETL_Load_Flag__c = true;
        }
        test.startTest();
        update leads;
        test.stopTest();
       // }
    }
    
    static testMethod void NGCC_LeadPriority_Bulk(){
        
    /*    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='testUser@ngcc.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testUser@ngcc.com');
        insert u;
        System.runAs(u) {*/
        loadOrgRecTypeCS();
        Campaign cm = new Campaign();
        cm.name = 'Tst Campaign ';
        insert cm;
 
        CC_Master_Question_Answer_Bank__c ccMaster = new CC_Master_Question_Answer_Bank__c(name='m');
        insert ccMaster;
        
        ID rtId=Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Prospect').getRecordTypeID();
            
        list<NGCC_Rule_Assignment__c> rules = new list<NGCC_Rule_Assignment__c>();
        rules.add(new NGCC_Rule_Assignment__c(MODS_Leads__c='Lead Attribute',Countries__c='UK;UNITED STATES',Lead_Attribute__c='lastName',Priority__c='1',Rank__c='1',Theater__c='APJXC',Value__c='m'));
        rules.add(new NGCC_Rule_Assignment__c(MODS_Q_A__c=ccMaster.id,MODS_Leads__c='MODS Q/A',Countries__c='India;UNITED STATES',Priority__c='2',Rank__c='2',Theater__c='APJXC',Value__c='m'));
        rules.add(new NGCC_Rule_Assignment__c(MODS_Q_A__c=ccMaster.id,MODS_Leads__c='MODS Q/A',Countries__c='India;UNITED STATES',Priority__c='4-N/A',Rank__c='3',Theater__c='APJ',Value__c='m'));
        insert rules;
        list<lead> leads;
        for(integer i=0; i<=500; i++){
            leads = new list<lead>();
            
            leads.add(new lead(Campaign_Name__c = cm.id,lastName='m',CustomCountry__c='UNITED STATES',Theater__c='APJXC',Company='Company',status='1 Waiting',LeadSource='Web',recordtypeId=rtId));
            leads.add(new lead(Campaign_Name__c = cm.id,lastName='m',CustomCountry__c='UNITED STATES',Theater__c='APJXC',Company='Company',status='1 Waiting',LeadSource='Web',recordtypeId=rtId));
            leads.add(new lead(Campaign_Name__c = cm.id,lastName='m',CustomCountry__c='UNITED STATES',Theater__c='APJ',Company='Company',status='1 Waiting',LeadSource='Web',recordtypeId=rtId));
        }   
        if(leads.size()  > 0 ){
            insert leads;
        }
        
        list<CC_Response__c> response;
        for(lead l : leads){
            if(l.id != null){
                 response = new list<CC_Response__c>();
                response.add(new CC_Response__c(name='m',Lead__c=l.id));
            }
        
        }
        
        
        if(response.size()  > 0 ){
            insert response;
        }
        list<CC_Response_Detail__c> detail;
        for(CC_Response__c c : response){
            if(c.id != null){
             detail = new list<CC_Response_Detail__c>();
            detail.add(new CC_Response_Detail__c(name='m',Response_Id__c=c.id,Customer_Response_Detail__c='m',CC_Master_Question_Answer_Bank__c=ccMaster.id));
            }
            
        }
            
        if(detail.size()  > 0 ){
            insert detail;
        }   
    
            
        for(Lead l : Leads){
            l.ETL_Load_Flag__c = true;
        }
        
        test.startTest();
        update leads;
        test.stopTest();
        
        for(Lead l : leads){
            l.CC_Call_Priority__c = '4-N/A';
        }
        update leads;
        set<String> countryLeadSet = new set<string>();
        countryLeadSet.add('United States');
        countryLeadSet.add('India');
        LeadTriggerUtil.callPriorityNA(leads, countryLeadSet);
       // }
    }
}