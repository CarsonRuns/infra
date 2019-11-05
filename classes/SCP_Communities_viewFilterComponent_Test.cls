@isTest
private class SCP_Communities_viewFilterComponent_Test {

    static testMethod void myUnitTest() {
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
        
        //System.assertEquals('Partner Executive',roleName);
        System.assertEquals(1,[select COUNT() from userrole where portalaccountid =:GenericStaticTestData.gettestChannelAccountRecord1().id and Name like '%Partner Executive' limit 1]);
        //System.assert(roleName.endsWith('Partner Executive'));

        user psruser1 = GenericStaticTestData.gettestPSRUserRecord();
        Contact c2 = GenericStaticTestData.gettestPartnerProvidedPSRContactRecord();
        c2.Partner_Admin_Roles__c = 'PARTNER_LED_APP_USER';
        update c2;
        
       // System.assertEquals(1, [SELECT COUNT() FROM USER WHERE username = 'testpa@cisco.com.sales.test']);

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
        //eca.OwnerId = pauser1.Id;
        update eca;
        
        //Lead leadRec = GenericStatictestData.gettesteLeadRecord();
        
        System.runAs(pauser1) {
            Id partnerAccountId = GenericStaticTestData.gettestChannelAccountRecord1().Id;
            Lead testLead = new Lead(firstName='Test Manual',LastName ='Lead', RECORDTYPEID='0123000000004aSAAQ', Partner_Lead_Status__c = 'Partner Assigned',LeadSource='test',company='Test End-User Account',email='test@test.com.test', Channel_Partner__c = partnerAccountId);
            insert testLead;
            System.assertEquals(1, [SELECT COUNT() FROM LEAD WHERE Id != null  AND Partner_Lead_Status__c IN  ( 'Partner Assigned','Assigned To PSR','Actively Working' )]);
           // System.assertEquals(2, [SELECT COUNT() FROM LEAD WHERE Id != null  AND Partner_Lead_Status__c =  ( 'Partner Assigned','Assigned To PSR','Actively Working' )]);
            SCP_Communities_leadFilter_CT leadcon = new SCP_Communities_leadFilter_CT();
            SCP_Communities_leadFilter_CT_Clone leadcon1 = new SCP_Communities_leadFilter_CT_Clone();
            PageReference pageRef = Page.SCP_Communities_leadFilter;            
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('view', 'newleads');
            leadCon.getSearchPageUrl();
            //leadCon.cancelMassUpdate();
            //leadCon.toggelPSR();
            leadCon.toggelSelectAll();
            leadCon.massUpdate();           
            leadCon.clearFields();
            leadCon.AssignPartnerName(channelAccountRecTypeId);
            SCP_Communities_listviews__c viewRec1 = SCP_Communities_listviews__c.getValues('My Newly Assigned Leads');
            SCP_Communities_leadFilter_CT.getListViewStatus(viewRec1.Id);
            //LeadCon.isPA();
            //LeadCon.isPSR();
            //LeadCon.isEnglish();
            LeadCon.getViewListComponent();
            
            //leadCon.Currentuseraccount();
            //leadCon.updateStatus();
            PageReference pageRef1 = Page.SCP_Communities_leadFilter_Clone;         
            Test.setCurrentPage(pageRef1);
            ApexPages.currentPage().getParameters().put('view', 'newleads');
            leadCon1.getSearchPageUrl();
            
            SCP_Communities_viewFilterComponent_CT con = new SCP_Communities_viewFilterComponent_CT();
            
            con.getViewListComponent();
            SCP_Communities_listviews__c viewRec = SCP_Communities_listviews__c.getValues('My Newly Assigned Leads');
            con.selectedView = viewRec.Id;
            con.doSearch();  
            //System.assertEquals('Id != null  AND Partner_Lead_Status__c IN  ( \'Partner Assigned\')', con.q_where);
            System.assertEquals(1, [SELECT COUNT() FROM LEAD WHERE Id != null  AND Partner_Lead_Status__c IN  ( 'Partner Assigned')]);
            //System.assertEquals(1, con.pageRecords.size());
            string cvalue = prmFilterUtility.retriveFilterCookie('Lead');// createFilterCookie
            //System.assertEquals('', cvalue);
            con.checkForExistingCookie();
            con.clearFields();
            con.selectedView = viewRec.Id;
            con.doSearch();
            con.psr1_Id = psruser1.Id;
            //con.pageRecords[0].isselected = true;
            con.assignPSRs();
            con.selectedCountries = new String [] {'INDIA', 'UNITED STATES OF AMERICA'};
                con.selectedIndustries = new String [] {'Center/ISPs'};
                    con.selectedLeadCategory = new String [] {'Appointment'};
                        con.selectedLeadSource = new String [] {'All'};
                            con.selectedMainTechnology = new String [] {'ACCESS'};
                                con.programEventName = 'test';
            con.stateProvince = 'CA';
            con.city = 'SAN JOSE';
            con.doSearch();
            con.checkForExistingCookie();
            SCP_Communities_PSRBulk_CT psrbulk = con.getPsr();
            System.AssertEquals(true,con.isNewlyAssignedLeads);
            System.AssertEquals(true,con.isEnglish);
            System.AssertEquals(true,con.isPA);
            System.AssertEquals(false,con.isPSR);
            String ccoId = con.CCOId;
            String channelAccount = con.channelAccount;
            String cuAccount = con.Currentuseraccount;
        }

    }
}