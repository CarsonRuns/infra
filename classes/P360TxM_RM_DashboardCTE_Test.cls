@isTest(SeeAllData=True)
public class P360TxM_RM_DashboardCTE_Test{
    public static testMethod void testTxMDashboard(){
    List<Assigned_Partner__c>  testList = new List<Assigned_Partner__c> ();
    List<Lead> leadList  = new List<Lead>();
    
      Id partnerAccountId = GenericStaticTestData.gettestChannelAccountRecord1().Id;
          Lead testLead4 = new Lead(firstName='Test Manual',LastName ='Lead', RECORDTYPEID='0123000000004aSAAQ', Partner_Lead_Status__c = 'Closed-Order Through Disti',LeadSource='test',company='Test End-User Account',email='test@test.com.test', Channel_Partner__c = partnerAccountId,CustomCountry__c='',PSR_Assigned_Date__c= null,CREATEDDATE = DateTime.now()-130);
          insert testLead4;
          testLead4.Partner_Lead_status__c='Rejected-Not My Territory/Account';
          update testLead4;
          
          leadList.add(testLead4);
          Assigned_Partner__c testTp = new Assigned_partner__c(Name='Test Target Prospect Record',TARGET_ARCHITECTURE__C='Any/All Technologies',TARGET_DESCRIPTION__C='Test Target Prospect Record',Assigned_Partner__c = partnerAccountId, Partner_Status__c = 'Partner Assigned', Partner_Assigned_Date__c = DateTime.now(), PSR_Assigned_Date_Time__c = DateTime.now());
          insert testTp;
          testList.add(testTp);
          
          PageReference pageRef = Page.P360TxM_RM_Dashboard;       
          Test.setCurrentPage(pageRef);
          
          P360TxM_RM_DashboardCTE controller=new P360TxM_RM_DashboardCTE();
          
          controller.initDashboard();
          controller.getItems();
          controller.getlstReports();
          P360TxM_RM_DashboardCTE.getChartData();
          string strPartnerFilter = 'Test';
          controller.getstrPartnerFilter();
          controller.setstrPartnerFilter(strPartnerFilter);
          controller.cmdPartnerFilter();
          controller.showAllFilter();
          
          controller.getCountofPartnerAssignedLead();
          controller.SelectedValue = 'test';  
          controller.urlsforDashboards();
    }

}