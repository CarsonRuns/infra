@isTest
public class NGCC_UpdateLeadContactInfo_Test 
{

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
    
    public static testmethod void testmeth()
    {
        loadOrgRecTypeCS();
        // Fetch profile (Cisco_NGCC) Id using below code.
        Profile p = new Profile();
        p=[select Id,Name from Profile where Name='Cisco_NGCC'];
        
        // create the user with the above collected profile.
        User u = new User();
        u.FirstName='Test First';
        u.LastName='Test Last';
        u.Alias='Tes';
        u.Email='bsrigadd@cisco.com';
        u.UserName='test1234@prudential.com';
        u.CommunityNickname='TestF';
        u.Profileid=p.Id;
        u.EmailEncodingKey='UTF-8';     
        u.TimeZoneSidKey='America/Los_Angeles';
        u.LocaleSidKey='en_US';
        u.LanguageLocaleKey='en_US';
        u.Theatre__c ='Americas-US Commercial';
        u.Additional_User_Permissions__c ='Enable EndUser ACCTCreation';
        insert u;

        RecordType r1 = new RecordType();
        r1 =[select Id,Name,SobjectType from RecordType where Name='End-User' and SobjectType='Account'];
       
        //create contact      
        contact c = new Contact();
        c.lastName = 'TestLastname';
        //c.AccountId=a.Id;
        
        insert c;
       
        // Fetching Record type  (Prospect)
        RecordType r = new RecordType();
        r=[select Id,Name,SobjectType from RecordType where Name='Prospect' and SobjectType='Lead'];
        System.runAs(u) {
        list<Lead> leads = new list<Lead>();
        for(Integer i=0;i<180;i++)
        {
            Lead l = new Lead(OwnerId=u.Id,LastName='Srigadde', Company='myTestcompany', Status='1 Waiting', Lead_Contact__c=c.Id,RecordTypeId=r.Id);
            leads.add(l);
        }
        
        insert leads;
        }
        Test.StartTest();
        NGCC_UpdateLeadContactInfo n = new NGCC_UpdateLeadContactInfo();
      
        ID batchprocessid = Database.executeBatch(n);
        Test.StopTest();
        
    }
}