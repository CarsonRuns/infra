@isTest
public class SCP_Communities_dashboard_CT_Test {
    public static testMethod void testController(){
        PageReference pageRef = Page.SCP_Communities_dashboard;
        Test.setCurrentPage(pageRef);
        
        UtilUnitTest.loadAllStaticData();       
        
        User pa = GenericStaticTestData.gettestPAUserRecord();
       


        System.runAs(pa){
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel').getRecordTypeId(); 
        Id partnerAccountId = GenericStaticTestData.gettestChannelAccountRecord1().Id;
         string s1 = String.valueof(pa.Id);
            SCP_Alerts__c testAlert = new SCP_Alerts__c();
            testAlert.Notification_for__c = '  Internal Users;Partners Users';
            testAlert.name = 'TEst Alert Messaged';
            testAlert.Start_Date__c = Date.today()-2;
            testAlert.End_Date__c = testAlert.Start_Date__c.addDays(14);
            insert testAlert;
            
            SCP_Communities_DTO__c SCPCO_DTO = new SCP_Communities_DTO__c();
            SCPCO_DTO.City__c  = 'Testcity';
            SCPCO_DTO.Country__c =' UNITED STATES';
            SCPCO_DTO.Industry__c = 'Center/ISPs';
            SCPCO_DTO.PSR__c = pa.id;
            SCPCO_DTO.State_Province__c = 'test';
            SCPCO_DTO.View_Lead__c = 'All Active Leads';
            SCPCO_DTO.View_TP__c = 'My Prospects' ;
            SCPCO_DTO.View_by_Current_Calendar__c = 'YEAR';
            insert SCPCO_DTO ;
            
             
        list<SelectOption> prtnrOptions = new list<SelectOption>();
        set<SelectOption> prtnrOptionsNew = new set<SelectOption>();
        prtnrOptions.add(new SelectOption('All', 'All'));
        
        
           Test.StartTest();  
            Lead testLead1 = new Lead(firstName='Test Manual',LastName ='Lead', RECORDTYPEID='0123000000004aSAAQ', 
            Partner_Lead_Status__c = 'Partner Assigned',LeadSource='test',
            company='Test End-User Account',email='test@test.com.test', 
            Channel_Partner__c = partnerAccountId,CustomCountry__c='',CustomCity__c = 'Hong Kong',CustomState__c  = 'Hong kong',state_Province_English__c = 'state',PSR_1__c = pa.id,
            PSR_Assigned_Date__c=DateTime.now());
            insert testLead1;
            Lead testLead2 = new Lead(firstName='Test Manual',LastName ='Lead', RECORDTYPEID='0123000000004aSAAQ', Partner_Lead_Status__c = 'Partner Assigned',LeadSource='test',company='Test End-User Account',email='test@test.com.test', Channel_Partner__c = partnerAccountId,CustomCountry__c='',PSR_Assigned_Date__c=DateTime.now()-1);
            insert testLead2;
            Lead testLead3 = new Lead(firstName='Test Manual',LastName ='Lead', RECORDTYPEID='0123000000004aSAAQ', Partner_Lead_Status__c = 'Partner Assigned',LeadSource='test',company='Test End-User Account',email='test@test.com.test', Channel_Partner__c = partnerAccountId,CustomCountry__c='',PSR_Assigned_Date__c=DateTime.now()-2);
            insert testLead3;
            Lead testLead4 = new Lead(firstName='Test Manual',LastName ='Lead', RECORDTYPEID='0123000000004aSAAQ', Partner_Lead_Status__c = 'Partner Assigned',LeadSource='test',company='Test End-User Account',email='test@test.com.test', Channel_Partner__c = partnerAccountId,CustomCountry__c='',PSR_Assigned_Date__c= null,CREATEDDATE = DateTime.now()-130);
            insert testLead4 ;
           Test.StopTest();
           System.debug('GL## '+testLead3); 
           
            Assigned_Partner__c testTp = new Assigned_partner__c(Name='Test Target Prospect Record',TARGET_ARCHITECTURE__C='Any/All Technologies',TARGET_DESCRIPTION__C='Test Target Prospect Record',Assigned_Partner__c = partnerAccountId, Partner_Status__c = 'Partner Assigned', Partner_Assigned_Date__c = DateTime.now(), PSR_Assigned_Date_Time__c = DateTime.now());
            insert testTp;
            
            List<Lead> Leadlist = [select id,name,Partner_Lead_Status__c  from lead where id=:testLead1.id];
            
            
            Map<String, String> getlabelMapLead = new Map<String, String>();
            Map<String, Decimal> getValueMapLead = new Map<String, Decimal>();
            Map<String, Integer> dataMap = new Map<String, Integer>();
            Map<String, string> getValueLableMapLead = new Map<String, string>();
            List<String> leadStatusList = new List<String>();
            
            
             
           getlabelMapLead.put(Leadlist[0].Partner_Lead_Status__c,Leadlist[0].Partner_Lead_Status__c);  
              
              
              
            
            Cookie cook = new Cookie('filter'+userinfo.getSessionId()+'dashboard', 'calender:psr:country::psr:country', null, -1, false);
            ApexPages.Currentpage().setCookies(new Cookie[] {cook});
            System.debug('SCP_Communities_dashboard_CT_Test');
            //System.debug(testLead);
            System.debug(testTp);
            System.debug('SCP_Communities_dashboard_CT_Test');
            System.debug([select id, firstName, LastName, RECORDTYPEID, Partner_Lead_Status__c, LeadSource, company, email, Channel_Partner__c from lead limit 100]);
            ApexPages.StandardController ctr = new ApexPages.StandardController(new SCP_Communities_DTO__c());
            SCP_Communities_dashabord_CT dashboardTestCT = new SCP_Communities_dashabord_CT(ctr);
            Test.setCurrentPage(Page.SCP_Communities_dashboard);
            dashboardTestCT.resetSearch();
            dashboardTestCT.getPsrList();
            dashboardTestCT.getPsrList();
            Disti_to_Partner_Mapping__c Distitopartner =  new Disti_to_Partner_Mapping__c();
           // Distitopartner.Distributor__c
            Distitopartner.Partner__c = partnerAccountId;
            insert Distitopartner ;
            dashboardTestCT.getPartnerList() ;
            
            
            
        dashboardTestCT.dashboardDto.City__c = 'Old Town';
        dashboardTestCT.dashboardDto.Country__c = 'United States';
        dashboardTestCT.dashboardDto.State_Province__c = 'San Jose State';
        String cValue = prmFilterUtility.retriveFilterCookie('dashboard');// createFilterCookie
        dashboardTestCT.doSearch();
        
        
     
      
        }
    }
    static testmethod void unittest()
    {
          //Id partnerAccountId = GenericStaticTestData.gettestChannelAccountRecord1().Id;
            UtilUnitTest.loadAllStaticData();
            ApexPages.StandardController ctr = new ApexPages.StandardController(new SCP_Communities_DTO__c());
            SCP_Communities_dashabord_CT dashboardTestCT = new SCP_Communities_dashabord_CT(ctr);
            Test.startTest();
            Test.setCurrentPage(Page.SCP_Communities_dashboard);
            dashboardTestCT.checkForExistingCookie();
            dashboardTestCT.resetSearch();
            dashboardTestCT.getPsrList();
            dashboardTestCT.getPsrList();
            Disti_to_Partner_Mapping__c Distitopartner =  new Disti_to_Partner_Mapping__c();
           //  Distitopartner.Distributor__c = partnerAccountId;
            insert Distitopartner ;
            dashboardTestCT.getPartnerList() ;
            Test.stoptest();
            
    }
   
 
}