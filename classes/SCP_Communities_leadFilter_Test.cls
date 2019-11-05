@isTest
public class SCP_Communities_leadFilter_Test {
  /***************/
    static testMethod void myUnitTest() {
        
        // Create Org_Constant_CS__c custom settings data
        String timestamp = String.valueOf(Datetime.now().getTime());
        UtilUnitTest.loadAllStaticData();
        String channelAccountRecTypeId = [Select Id,Name, DeveloperName from RecordType where sobjecttype='Account' and Name = 'Channel'].Id;        
        LnP_Constants__c lnpC = new LnP_Constants__c();
        lnpC.Archive_Days__c = 180;
        lnpC.Reset_Date__c = system.today();
        insert lnpC;
        
        // Get PA record
        user pauser1 = GenericStaticTestData.gettestPAUserRecord();
        Contact c = GenericStaticTestData.gettestPartnerProvidedPAContactRecord();
        c.Partner_Admin_Roles__c = 'PARTNER_LED_APP_ADMIN,PARTNER_LED_APP_USER';
        update c;
        string roleName = pauser1.UserRole.name;
        
        user psruser1 = GenericStaticTestData.gettestPSRUserRecord();
        psruser1.LanguageLocaleKey = 'en_US';
        
        //update psruser1;
        Contact c2 = GenericStaticTestData.gettestPartnerProvidedPSRContactRecord();
        c2.Partner_Admin_Roles__c = 'PARTNER_LED_APP_USER';
        update c2;
        
        // Get End customer account
        Account eca =new Account();
        eca = GenericStaticTestData.getTestEndUserAccountRecordRed();
        eca.Name = 'testec'+timestamp;
        eca.Unallocated_Account__c = 'Yes';
        eca.Release_to_Unallocated_Pool__c = 'Yes';
        eca.RecordTypeId = '0123000000004aUAAQ';
        eca.CRName__c = 'testec CRName'+timestamp;
        eca.Country__c='UNITED STATES';
        eca.Industry = 'Center/ISPs';
        eca.Wallet_Wireless_000__c = 20 ;
        eca.Wallet_Video_000__c = 20 ;
        eca.Wallet_Unified_Communications_000__c = 20 ;
        eca.Wallet_Switching_000__c = 20 ;
        eca.Wallet_Services_000__c = 20 ;
        eca.Wallet_Security_000__c = 20 ;
        eca.Wallet_Routing_000__c = 20 ;
        eca.Wallet_Other_000__c = 20 ;
        eca.Wallet_Data_Center_UCS_000__c = 20 ;
        eca.Wallet_Collab_Applications__c = 20 ;
        eca.Wallet_Unified_Communications_000__c = 20 ;
        eca.Wallet_Wireless_000__c = 20 ;
        eca.Expected_Bookings_Wireless_000__c = 40 ;
        eca.Expected_Bookings_Telepresence_000__c = 40 ;
        eca.Expected_Bookings_Switching_000__c = 40 ;
        eca.Expected_Bookings_Services_000__c = 40 ;
        eca.Expected_Bookings_Security_000__c = 40 ;
        eca.Expected_Bookings_Routing_000__c = 40 ;
        eca.Expected_Bookings_Data_Center_UCS_000__c = 40 ;
        eca.Expected_Bookings_Collab_Voice_000__c = 40 ;
        eca.Expected_Bookings_Collab_App_000__c = 40 ;
        eca.Expected_Booking_Other__c = 40 ;
        eca.Allocated_Partner_1__c = null;
        eca.Allocated_Partner_2__c = null;
        eca.Allocated_Partner_3__c = null;
        eca.Allocated_Partner_4__c = null;
       // eca.OwnerId = pauser1.Id;
        update eca;
        
        List<Sobject> l3 = Test.loadData( SCP_Communities_LeadFilter_Columns__c.SobjectType, 'SCP_LeadFilter_Columns_data' );
        List<sObject> orgCS = Test.loadData(Org_Constant_CS__c.sobjectType, 'OrgConstantCS_data') ;
          System.runAs(pauser1) {           
            Id partnerAccountId = GenericStaticTestData.gettestChannelAccountRecord1().Id;
            Lead testLead = new Lead(firstName='Test Manual',LastName ='Lead', RECORDTYPEID='0123000000004aSAAQ', Partner_Lead_Status__c = 'Partner Assigned',LeadSource='test',company='Test End-User Account',email='test@test.com.test', Channel_Partner__c = partnerAccountId);
            insert testLead;
           
            SCP_Communities_listviews__c viewRec2 = SCP_Communities_listviews__c.getValues('My Newly Assigned Leads');
            User_Preference__c   usp = new User_Preference__c(view_id__c = viewRec2.id, user__c = pauser1.id, Columns_Sort_Order__c='Partner Status~~asc',Selected_column_order__c='Partner Status');
            insert usp; 
            
            Test.startTest();            
            SCP_Communities_leadFilter_CT leadcon = new SCP_Communities_leadFilter_CT();
            PageReference pageRef = Page.SCP_Communities_leadFilter;            
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('view', 'newleads');
            leadCon.getSearchPageUrl();
            leadCon.toggelSelectAll();
            leadCon.massUpdate();           
            leadCon.clearFields();
            leadCon.AssignPartnerName(channelAccountRecTypeId);
            SCP_Communities_listviews__c viewRec1 = SCP_Communities_listviews__c.getValues('My Newly Assigned Leads');
            SCP_Communities_leadFilter_CT.getListViewStatus(viewRec1.Id);
            LeadCon.getViewListComponent();
            
            // Testing SCP_Communiiteis_LeadFilter_Clone page            
            SCP_Communities_leadFilter_CT_Clone leadcon1 = new SCP_Communities_leadFilter_CT_Clone();
            PageReference pageRef1 = Page.SCP_Communities_leadFilter_Clone;         
            Test.setCurrentPage(pageRef1);
            ApexPages.currentPage().getParameters().put('view', 'newleads');
            leadCon1.getSearchPageUrl();            
            leadCon1.massUpdate();           
            leadCon1.clearFields();
            leadCon1.AssignPartnerName(channelAccountRecTypeId);
            SCP_Communities_leadFilter_CT_Clone.getListViewStatus(viewRec1.Id);
            LeadCon1.getViewListComponent();
            leadCon1.getDataTableComponent();
            leadCon1.getGirdHeaderlocal('Industry');
            leadCon1.refresh();
            leadCon1.sObjectName='';
            leadCon1.country='usa';            
            List<String> mPickVals1= new List<String>{'VIEW','SCB'};
            leadCon1.getMultiPickSelectedValue(mPickVals1);
            List<String> mPickVals= new List<String>{'ALL','SCB'};
            leadCon1.getMultiPickSelectedValue(mPickVals);
            //leadCon1.isPSR=false;
            
            string strId = [select id from SCP_Communities_listviews__c where name='My Newly Assigned Leads' and objectType__c = 'Lead'].Id;
            User_Preference__c usPref = new User_Preference__c(View_Id__c=strId,User__c=userinfo.getUserId(),Selected_column_order__c='Lead Source;City',Columns_Sort_Order__c = 'Date Added~~desc;Lead Source~~asc');
            insert usPref;            
            leadCon1.getDataTableComponent();            
            leadCon1.first();           
            Boolean isHasNext = leadCon1.hasNext;
            Boolean isHasPrevious = leadCon1.hasPrevious;
            leadCon1.next();
            leadCon1.previous();
            leadCon1.last();
            leadCon1.setPageNum();            
            if( ! leadCon1.pageRecords.isEmpty() ) {
                leadCon1.pageRecords[0].isSelected = true;
                leadCon1.toggelPSR();
            }
            
            Integer totalPages = leadCon1.totalPages;            
            leadCon1.cancelMassUpdate();
            leadCon1.selectedView = strId;
            Boolean isMYNL = leadCon1.isNewlyAssignedLeads;
            leadCon1.getDataTableComponent();
            
            leadCon1.assignPSRs();
            leadCon1.pageRecords[0].leadRec.Partner_Lead_Status__c = 'Partner Assigned';
            leadCon1.AssignPartnerName(partnerAccountId);
            leadCon1.checkForExistingCookie();
            leadCon1.clearAsignPSRFields();
            
            leadCon1.pageRecords[0].isSelected = true;
            SCP_Communities_PSRBulk_CT psr = leadCon1.getPsr();
            psr.psr1_Id = userInfo.getUserId();
            leadCon1.assignPSRs();
            leadCon1.getViewSettingsUrl();
            Component.Apex.SelectList viewList = leadCon1.getViewListComponent();
            leadCon1.setViewList(viewList);
            SCP_Communities_leadFilter_CT_Clone.getListViewStatus(strId);
            lead rec = leadCon1.pageRecords[0].leadRec;
            rec.Partner_Lead_Status__c = 'Assigned to PSR';
            leadCon1.pageRecords[0].isSelected = true;
            leadCon1.updateStatus(rec);
            leadCon1.enableMassEdit('Actively Working');     
            leadCon1.massUpdate();
            leadCon1.getIsChekAccesLead();
            SCP_Communities_leadFilter_CT_Clone.updateTC();
            System.debug('********* Exception : ' +ApexPages.getMessages() );

            leadCon1.cancelMassUpdate();
            String userLang = leadCon1.Userlang;
            String cecId = leadCon1.CCOId;
            String currentUserAccId = leadCon1.Currentuseraccount;
            leadCon1.doSearch();
            SCP_Communities_listviews__c viewRec3 = SCP_Communities_listviews__c.getValues('My Archived Leads');
            SCP_Communities_leadFilter_CT.getListViewStatus(viewRec3.Id);
            SCP_Communities_leadFilter_CT_Clone.getListViewStatus(viewRec3.Id);
            leadCon1.doSearch();
            SCP_Communities_listviews__c viewRec4 = SCP_Communities_listviews__c.getValues('All Active Leads');
            SCP_Communities_leadFilter_CT.getListViewStatus(viewRec4.Id);
            SCP_Communities_leadFilter_CT_Clone.getListViewStatus(viewRec4.Id);
            leadCon1.doSearch();
            User_Preference__c usPref1 = new User_Preference__c(View_Id__c=strId,User__c=userinfo.getUserId(),Selected_column_order__c='Lead Source;PSR 1',Columns_Sort_Order__c = 'Date Added~~desc;Lead Source~~asc');
            insert usPref1;            
            leadCon1.getDataTableComponent();            
            Test.stopTest();           
        }
    }
    
    static testMethod void myUnitTest_WITHOUTORGCONSTENTDATA() {
    
        LnP_Constants__c lnpC = new LnP_Constants__c();
        lnpC.Archive_Days__c = 180;
        lnpC.Reset_Date__c = system.today();
        insert lnpC;
        
        // Create Org_Constant_CS__c custom settings data
        String timestamp = String.valueOf(Datetime.now().getTime());
        UtilUnitTest.loadAllStaticData();
        String channelAccountRecTypeId = [Select Id,Name, DeveloperName from RecordType where sobjecttype='Account' and Name = 'Channel'].Id;

        // Get PA record
        user pauser1 = GenericStaticTestData.gettestPAUserRecord();
        Contact c = GenericStaticTestData.gettestPartnerProvidedPAContactRecord();
        c.Partner_Admin_Roles__c = 'PARTNER_LED_APP_ADMIN,PARTNER_LED_APP_USER';
        update c;
        string roleName = pauser1.UserRole.name;
        
        user psruser1 = GenericStaticTestData.gettestPSRUserRecord();
        psruser1.LanguageLocaleKey = 'en_US';        
        Contact c2 = GenericStaticTestData.gettestPartnerProvidedPSRContactRecord();
        c2.Partner_Admin_Roles__c = 'PARTNER_LED_APP_USER';
        update c2;
        
        // Get End customer account
        Account eca =new Account();
        eca = GenericStaticTestData.getTestEndUserAccountRecordRed();
        eca.Name = 'testec'+timestamp;
        eca.Unallocated_Account__c = 'Yes';
        eca.Release_to_Unallocated_Pool__c = 'Yes';
        eca.RecordTypeId = '0123000000004aUAAQ';
        eca.CRName__c = 'testec CRName'+timestamp;
        eca.Country__c='UNITED STATES';
        eca.Industry = 'Center/ISPs';
        eca.Wallet_Wireless_000__c = 20 ;
        eca.Wallet_Video_000__c = 20 ;
        eca.Wallet_Unified_Communications_000__c = 20 ;
        eca.Wallet_Switching_000__c = 20 ;
        eca.Wallet_Services_000__c = 20 ;
        eca.Wallet_Security_000__c = 20 ;
        eca.Wallet_Routing_000__c = 20 ;
        eca.Wallet_Other_000__c = 20 ;
        eca.Wallet_Data_Center_UCS_000__c = 20 ;
        eca.Wallet_Collab_Applications__c = 20 ;
        eca.Wallet_Unified_Communications_000__c = 20 ;
        eca.Wallet_Wireless_000__c = 20 ;
        eca.Expected_Bookings_Wireless_000__c = 40 ;
        eca.Expected_Bookings_Telepresence_000__c = 40 ;
        eca.Expected_Bookings_Switching_000__c = 40 ;
        eca.Expected_Bookings_Services_000__c = 40 ;
        eca.Expected_Bookings_Security_000__c = 40 ;
        eca.Expected_Bookings_Routing_000__c = 40 ;
        eca.Expected_Bookings_Data_Center_UCS_000__c = 40 ;
        eca.Expected_Bookings_Collab_Voice_000__c = 40 ;
        eca.Expected_Bookings_Collab_App_000__c = 40 ;
        eca.Expected_Booking_Other__c = 40 ;
        eca.Allocated_Partner_1__c = null;
        eca.Allocated_Partner_2__c = null;
        eca.Allocated_Partner_3__c = null;
        eca.Allocated_Partner_4__c = null;
      //  eca.OwnerId = pauser1.Id;
        update eca;
        
        List<Sobject> l3 = Test.loadData( SCP_Communities_LeadFilter_Columns__c.SobjectType, 'SCP_LeadFilter_Columns_data' );
        System.runAs(pauser1) {
            Id partnerAccountId = GenericStaticTestData.gettestChannelAccountRecord1().Id;
            user pauser3 = GenericStaticTestData.gettestPAUserRecord();
            Lead testLead = new Lead(firstName='Test Manual',LastName ='Lead', RECORDTYPEID='0123000000004aSAAQ', Partner_Lead_Status__c = 'Actively Working',LeadSource='test',company='Test End-User Account',email='test@test.com.test', Channel_Partner__c = partnerAccountId, PSR_1__c = pauser3.id);
            insert testLead;
            Test.startTest();
            // Testing SCP_Communiites_LeadFilter page
            SCP_Communities_leadFilter_CT leadcon = new SCP_Communities_leadFilter_CT();
            PageReference pageRef = Page.SCP_Communities_leadFilter;            
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('view', 'newleads');
            leadCon.getSearchPageUrl();
            leadCon.toggelSelectAll();
            leadCon.massUpdate();           
            leadCon.clearFields();
            leadCon.AssignPartnerName(channelAccountRecTypeId);
            SCP_Communities_listviews__c viewRec1 = SCP_Communities_listviews__c.getValues('My Newly Assigned Leads');
            SCP_Communities_leadFilter_CT.getListViewStatus(viewRec1.Id);
            LeadCon.getViewListComponent();
            
            SCP_Communities_leadFilter_CT_Clone leadcon1 = new SCP_Communities_leadFilter_CT_Clone();
            PageReference pageRef1 = Page.SCP_Communities_leadFilter_Clone;         
            Test.setCurrentPage(pageRef1);
            ApexPages.currentPage().getParameters().put('view', 'newleads');
            leadCon1.getSearchPageUrl();            
            leadCon1.massUpdate();           
            leadCon1.clearFields();
            leadCon1.AssignPartnerName(channelAccountRecTypeId);
            SCP_Communities_leadFilter_CT_Clone.getListViewStatus(viewRec1.Id);
            LeadCon1.getViewListComponent();
            leadCon1.getDataTableComponent();            
            leadCon1.refresh();
            
            string strId = [select id from SCP_Communities_listviews__c where name='My Newly Assigned Leads' and objectType__c = 'Lead'].Id;
            User_Preference__c usPref = new User_Preference__c(View_Id__c=strId,User__c=userinfo.getUserId(),Selected_column_order__c='Lead Source;City',Columns_Sort_Order__c = 'Date Added~~desc;Lead Source~~asc');
            insert usPref;            
            leadCon1.getDataTableComponent();            
            leadCon1.first();           
            Boolean isHasNext = leadCon1.hasNext;
            Boolean isHasPrevious = leadCon1.hasPrevious;
            leadCon1.next();
            leadCon1.previous();
            leadCon1.last();
            leadCon1.setPageNum();            
            if( ! leadCon1.pageRecords.isEmpty() ) {
                leadCon1.pageRecords[0].isSelected = true;
                leadCon1.toggelPSR();
            }
            
            Integer totalPages = leadCon1.totalPages;            
            leadCon1.cancelMassUpdate();
            leadCon1.selectedView = strId;
            leadCon1.getDataTableComponent();            
            leadCon1.assignPSRs();
            //leadCon1.pageRecords[0].leadRec.Partner_Lead_Status__c = 'Partner Assigned';
            leadCon1.AssignPartnerName(partnerAccountId);
            leadCon1.checkForExistingCookie();
            leadCon1.clearAsignPSRFields();
            
            //leadCon1.pageRecords[0].isSelected = true;
            SCP_Communities_PSRBulk_CT psr = leadCon1.getPsr();
            psr.psr1_Id = userInfo.getUserId();
            leadCon1.assignPSRs();
            
           /* lead rec = leadCon1.pageRecords[0].leadRec;
            rec.Partner_Lead_Status__c = 'Assigned to PSR';
            leadCon1.pageRecords[0].isSelected = true;
            leadCon1.updateStatus(rec);*/
            leadCon1.enableMassEdit('Actively Working');     
            leadCon1.massUpdate();
            System.debug('********* Exception : ' +ApexPages.getMessages() );

            leadCon1.cancelMassUpdate();
            String userLang = leadCon1.Userlang;
            String cecId = leadCon1.CCOId;
            String currentUserAccId = leadCon1.Currentuseraccount;
            Test.stopTest();                        
        }
    }    
  /*************/
}