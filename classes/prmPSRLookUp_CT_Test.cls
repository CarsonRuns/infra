@isTest
private class prmPSRLookUp_CT_Test {
	
    static testMethod void unittest1() {
        String timestamp = String.valueOf(Datetime.now().getTime());
        UtilUnitTest.loadAllStaticData();        
        // Get PA record
        
        user pauser1 = GenericStaticTestData.gettestPAUserRecord();
        Contact c = GenericStaticTestData.gettestPartnerProvidedPAContactRecord();
        c.Partner_Admin_Roles__c = 'PARTNER_LED_APP_ADMIN,PARTNER_LED_APP_USER';
        update c;
        
        // Get PSR user
        user psruser1 = GenericStaticTestData.gettestPSRUserRecord();
        Contact c2 = GenericStaticTestData.gettestPartnerProvidedPSRContactRecord();
        c2.Partner_Admin_Roles__c = 'PARTNER_LED_APP_USER';
        update c2;
        
        // Create uncovered account
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
        
        update eca;
        System.runAs(pauser1) {
            PageReference pageRef = Page.SCP_Communities_psrSearch;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('psrId','psr1');
            ApexPages.currentPage().getParameters().put('uid1',psruser1.Id);
            prmPSRLookUp_CT con = new prmPSRLookUp_CT();
            List<prmPSRLookUp_CT.WrapperUser> usersList = con.getUserList();
            System.assertEquals(1,usersList.size());
            
            
        }
    }
}