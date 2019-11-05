@isTest(SeeAllData = true)
public class NGCC_LeadScreenMashup_Test{
    
    private static testMethod void MarketingActivityTest(){
        String CALL_NOTES = 'CALL_NOTES';
        String CALL_STATUS = 'CALL_STATUS';
        String OFFER_ARCHITECTURE = 'CALL_STATUS';
        String OFFER_DESCRIPTION = 'CALL_STATUS';
        String ACTIVITY_TYPE = 'CALL_STATUS';
        String OFFER_TYPE_NAME = 'CALL_STATUS';
        String PERSON_PARTY_ID = 'CALL_STATUS';
        String OFFER_NAME = 'CALL_STATUS';
        String ACTIVITY_DATE = '01-01-01';
        String ACTIVITY_DATE2 = '01-01-02';
        
        NGCC_LeadScreenMashupCTL.MarketingActivity mark = new NGCC_LeadScreenMashupCTL.MarketingActivity (CALL_NOTES, CALL_STATUS, OFFER_ARCHITECTURE, 
                                                          OFFER_DESCRIPTION,ACTIVITY_TYPE, OFFER_TYPE_NAME, PERSON_PARTY_ID, OFFER_NAME,ACTIVITY_DATE);
    
        NGCC_LeadScreenMashupCTL.MarketingActivity mark2 = new NGCC_LeadScreenMashupCTL.MarketingActivity (CALL_NOTES, CALL_STATUS, OFFER_ARCHITECTURE, 
                                                          OFFER_DESCRIPTION,ACTIVITY_TYPE, OFFER_TYPE_NAME, PERSON_PARTY_ID, OFFER_NAME,ACTIVITY_DATE2);

        mark.compareTo(mark2);
        mark2.compareTo(mark);
        mark.compareTo(mark);
    }
    
    private static testMethod void MODSParseTest(){
        PageReference current = ApexPages.currentPage();
        Test.setCurrentPage(current);
        current.getParameters().put('node', '{"STATUS":"SUCCESS","MESSAGE":"1 Activities(s) found","TOTAL_ACTIVITIES":[{"Marketing":"1"}],"ACTIVITIES":[{"Marketing":[{"CALL_NOTES":"","TREATMENT_NAME":"","CALL_STATUS":"","OFFER_ARCHITECTURE":"SP Routing","OFFER_DESCRIPTION":"CN_CABLE SUMMIT EVENT","ACTIVITY_TYPE":"ATTENDED EVENT IN PERSON","OFFER_TYPE_NAME":"LIVE EVENT - CISCO","OFFER_NAME":" FY14 CN_Cable Summit Event","ACTIVITY_DATE":"12/6/2013"}]}]}');
        Lead a = new Lead();
       
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_LeadScreenMashupCTL searcher = new NGCC_LeadScreenMashupCTL(controller);
        searcher.getMODSData();
    }
    
    public static testMethod void NGCC_LeadScreenMashup_Lead_Test() {
        
        ObjectRecordTypeIds__c orgConstant = ObjectRecordTypeIds__c.getInstance(); 
        Id endCustAcc = orgConstant.Account_End_User_RecordTypeId__c;
        Id endCustCon = orgConstant.Contact_Manual_EndUser_RecordTypeId__c;
        Id eLeadRecType = orgConstant.eLeadsRecordTypeId__c;
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name Like '%Enterprise%'
            Limit 1
        ];
        
        
        User uAM = new User(Alias = 'newUser', Email = 'newuserSM@cisco.com.reg',
            EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',Additional_User_Permissions__c='Enable EndUser ACCTCreation',
            LocaleSidKey = 'en_US', ProfileId = p.Id,Marketing_Call_Center__c = 'Alea Canada',
            TimeZoneSidKey = 'America/Los_Angeles', UserName = 'newuserSM@cisco.com.reg', Theatre__c = 'Americas-US Commercial');
        System.runAs(uAM) {
             Account a = new Account(name='Test End-User Account',CRName__c ='Test End-User Account',RECORDTYPEID=endCustAcc,Country__c='UNITED STATES');
             insert a;
             
             contact c = new contact(firstName='Test',LastName ='EndCustomer', RECORDTYPEID=endCustCon,email='testpa@test.com.test',accountId=a.id);
             insert c;
             
             Lead l = NGCC_CallScript_Data_Test.testLead();
             Lead l2 = NGCC_CallScript_Data_Test.testLead();
             l.Lead_Contact__c = c.Id; 
             l2.Lead_Contact__c = c.Id;
             l2.RecordTypeId = eLeadRecType;
             l2.Status = 'Marketing Qualified';
             l.MODS_Contact__c = 123456; 
             l2.MODS_Contact__c = 123456;           
             update l;
             update l2;
            
             
             l.Lead_Contact__c = NULL;
             update l;
             
             l.Lead_Contact__c = c.Id;             
             update l;
             
              Test.setCurrentPageReference(New PageReference('Page.NGCC_LeadScreenMashup'));
              //System.currentPageReference().getParameters().put('id', l.Id);
              ApexPages.Standardcontroller stdCtlCallScript = New ApexPages.StandardController(l);
              NGCC_LeadScreenMashupCTL ccLeadMashup = new NGCC_LeadScreenMashupCTL(stdCtlCallScript);
              
              
        }
    }
}