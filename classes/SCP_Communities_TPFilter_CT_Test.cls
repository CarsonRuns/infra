@isTest(SeeAllData = false)
private class SCP_Communities_TPFilter_CT_Test {
    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        // Create Org_Constant_CS__c custom settings data
        String timestamp = String.valueOf(Datetime.now().getTime());
        UtilUnitTest.loadAllStaticData();
        // Get PA record
        
        user pauser1 = GenericStaticTestData.gettestPAUserRecord();
        string roleName = pauser1.UserRole.name;
        //System.assertEquals('Partner Executive',roleName);
        System.assertEquals(1,[select COUNT() from userrole where portalaccountid =:GenericStaticTestData.gettestChannelAccountRecord1().id and Name like '%Partner Executive' limit 1]);
        //System.assert(roleName.endsWith('Partner Executive'));
        
        user psruser1 = GenericStaticTestData.gettestPSRUserRecord();
        
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
        
        System.assertEquals('TRUE', [Select Show_Account_in_Unallocated_Pool__c FROM Account Where Id = :eca.Id].Show_Account_in_Unallocated_Pool__c);
        Assigned_Partner__c tp = new Assigned_Partner__c ();
        tp.Target_Architecture__c = 'Any/All Technologies';
        tp.Target_Description__c = 'test target';
        tp.Marketing_Play_Name__c = 'testtpmarketingname';
        tp.Cisco_Recomended_Partner_Sales_Rep__c =  psruser1.Id;
        tp.Customer_Account__c = eca.Id;
        tp.Assigned_Partner__c = GenericStaticTestData.gettestChannelAccountRecord1().Id;
        insert tp;
        
        Contact c = GenericStaticTestData.gettestPartnerProvidedPAContactRecord();
        c.Partner_Admin_Roles__c = 'PARTNER_LED_APP_ADMIN,PARTNER_LED_APP_USER';
        update c;
        
        System.runAs(pauser1) {
            Test.startTest();
           // System.assertEquals(1, [Select COUNT() FROM Account Where Account.Show_Account_in_Unallocated_Pool__c = 'TRUE']);
            // Crate TP Records
            /*
            Select a.Technology_Filter__c, a.Target_Description__c, 
            a.Target_Architecture__c, a.Name, a.Marketing_Play_Name__c, 
            a.Assigned_Partner__c, a.Assigned_Partner_Sales_Rep__c 
            From Assigned_Partner__c a
            */
            
            SCP_Communities_TPFilter_CT con = new SCP_Communities_TPFilter_CT();
            PageReference pageRef = Page.SCP_Communities_targetprospectfilter;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('view', 'newprospects');
            ApexPages.currentPage().getparameters().put('tpc','1');
            String msg = con.uncoveredProspectsMsg;
            List<SelectOption> views = con.viewOptions;
            con.marketingPlay = 'testtpmarketingname';
            con.customername = 'Test End';
            con.selectedTagetArchitecture =  new String[]{'Any/All Technologies'};
            con.ciscoRecommendedPSR =  psruser1.Id;
            con.selectedIndustry =  new String[] {'Center/ISPs'};
            con.selectedTechnology = 'Collab Applications';
            con.selectedCountry = new String [] {'UNITED STATES','INDIA'};
            con.city = 'San Jose';
            con.stateorProvince ='CA';                
            con.doSearch();
            con.getSearchPageUrl();
            con.getPsr();
            system.assert(con.isNewlyAssignedProspect);
            //system.assert(con.pageRecords.size() > 0);

            System.debug(con.pageRecords);
            con.clearfields();
            
            con.selectedView = views[3].getValue();
            con.doSearch();
            con.marketingPlay = 'testtpmarketingname';
            con.customername = 'Test';
            con.selectedTagetArchitecture =  new String[]{'Any/All Technologies'};
            con.ciscoRecommendedPSR =  psruser1.Id;
            con.selectedIndustry =  new String[] {'Center/ISPs'};
            con.selectedTechnology = 'Collab Applications';
            con.selectedCountry = new String [] {'UNITED STATES','INDIA'};
            con.city = 'San Jose';
            con.stateorProvince ='CA';                
            con.myPg = null;
            con.doSearch();
            
            con.clearFields();
            con.selectedView = views[3].getValue();
            con.doSearch();
            //system.assert(con.pageRecords.size() > 0);
            if(con.pageRecords != null && con.pageRecords.size() >0 ) {
                con.pageRecords[0].isSelected = true;
            }
            Pagereference pg = con.openWorkProspectPage();
            con.getViewListComponent();
            
            Map<String, SCP_Communities_ComponentControllerBase> ccbmap = con.getComponentControllerMap();
            SCP_Communities_PSRBulk_CT psrbulkcon = con.getPsr();
            psrbulkcon.setKey(con.psrKey);
            psrbulkcon.setPageController(con.getThis());
            psrbulkcon.psr1_Id = pauser1.Id;
            psrbulkcon.assignPSRs();
           // System.assert(con.isPA);
            Test.stopTest();
        }
        
    }
}