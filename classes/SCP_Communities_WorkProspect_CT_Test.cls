@isTest
private class SCP_Communities_WorkProspect_CT_Test {
    
    static testMethod void testasPA() {
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
            PageReference pageRef = Page.SCP_Communities_WorkProspects;
            Test.setCurrentpage(pageRef);
            String retURL = '/apex/SCP_Communities_targetProspectFilter';
            ApexPages.currentPage().getParameters().put('retURL',retURL);
            SCP_Communities_WorkProspect_CT con = new SCP_Communities_WorkProspect_CT();
            //1. AccountId = null
            Pagereference pg = con.doSave();
            System.assertEquals(Null,pg);
            // 2. Target Acrchitecture = null
            ApexPages.currentPage().getParameters().put('Id',eca.Id);            
            con.doSave();
            // 3. Target Description = null
            Assigned_Partner__c tp = new Assigned_Partner__c();
            tp.Target_Description__c = '';
            tp.Target_Architecture__c = 'Any/All Technologies';
            con.tp1 = tp;
            pg = con.doSave();
           // System.assertEquals(Null, pg);
            //5. pa1, pa2, p3 = null
            tp.Target_Description__c = 'test target description';
            tp.Target_Architecture__c = 'Any/All Technologies';
            con.tp1 = tp;
            con.psr1Id = null;
            con.psr2Id = null;
            con.psr3Id = null;
            
            pg = con.doSave();
            System.assertEquals(Null, pg);
            
            // All Values
            con.psr1Id = pauser1.Id;
            con.psr2Id = psruser1.Id;
            con.tp1 = tp;
            con.doSave();
            con.cancel();
           // System.AssertEquals(retUrl,pg.getUrl());
        }
        
        
    }
     static testMethod void testasPSR() {
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
        System.runAs(psruser1) {
             PageReference pageRef = Page.SCP_Communities_WorkProspects;
            Test.setCurrentpage(pageRef);
            String retURL = '/apex/SCP_Communities_targetProspectFilter';
            ApexPages.currentPage().getParameters().put('retURL',retURL);
            SCP_Communities_WorkProspect_CT con = new SCP_Communities_WorkProspect_CT();
            //1. AccountId = null
            Pagereference pg = con.doSave();
            System.assertEquals(Null,pg);
            // 2. Target Acrchitecture = null
            ApexPages.currentPage().getParameters().put('Id',eca.Id);            
            con.doSave();
            // 3. Target Description = null
            Assigned_Partner__c tp = new Assigned_Partner__c();
            tp.Target_Description__c = '';
            tp.Target_Architecture__c = 'Any/All Technologies';
            con.tp1 = tp;
            pg = con.doSave();
           // System.assertEquals(Null, pg);
            //5. pa1, pa2, p3 = null
            tp.Target_Description__c = 'test target description';
            tp.Target_Architecture__c = 'Any/All Technologies';
            con.psr1Id = Null;
            con.psr2Id = Null;
            con.psr3Id = Null;
            con.tp1 = tp;
            pg = con.doSave();
            //System.assertEquals(Null, pg);
            
            // All Values
            con.psr1Id = pauser1.Id;
            con.psr2Id = psruser1.Id;
            con.tp1 = tp;
            con.doSave();
            con.cancel();
           // System.AssertEquals(retUrl,pg.getUrl());
        }
        
        
    }
    
}