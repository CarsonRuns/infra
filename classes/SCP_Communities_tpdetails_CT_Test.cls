@isTest
private class SCP_Communities_tpdetails_CT_Test {
    
    static testMethod void extendMessageTest() {
        Test.startTest();
        UtilUnitTest.loadAllStaticData();
        Assigned_Partner__c tptest = UtilUnitTest.getAssigned_Partner_c();
        tptest.Expiration_Date__c = date.newInstance(2015, 01, 01);
        Apexpages.StandardController sc = new Apexpages.standardController(tptest);
        SCP_Communities_tpdetails_CT tpct = new SCP_Communities_tpdetails_CT(sc);
        System.assert(tpct.extendMessage!=null);
        System.assert(tpct.isPA);
        tpct.initTpExtension();
        tptest.Expiration_Date__c = null;
        System.assert(tpct.extendMessage==null);
        Test.stopTest();
    }
    
    static testMethod void addEditPSRTest(){
        
        Test.startTest();
        Assigned_Partner__c tptest = UtilUnitTest.getAssigned_Partner_c();
        tptest.Expiration_Date__c = date.newInstance(2015, 01, 01);
        Apexpages.StandardController sc = new Apexpages.standardController(tptest);
        SCP_Communities_tpdetails_CT tpct = new SCP_Communities_tpdetails_CT(sc);
        System.assert(tpct.addEditPSR()!=null);
        Test.stopTest();
        
    }
    
    
    static testMethod void initTpExtensionTest(){
        
        Test.startTest();
        UtilUnitTest.loadAllStaticData();
        Assigned_Partner__c tptest = UtilUnitTest.getAssigned_Partner_c();
        tptest.Expiration_Date__c = date.newInstance(2015, 01, 01);
        tptest.Extension_Reason__c ='Explicit Extension by Partner';
//        tptest.CreatedDate = date.newInstance(2015, 01, 01);
        Apexpages.StandardController sc = new Apexpages.standardController(tptest);
        SCP_Communities_tpdetails_CT tpct = new SCP_Communities_tpdetails_CT(sc);
        tpct.initTpExtension();
        Test.stopTest();
        
    }
    
    
    
    static testMethod void viewAllDealsTest(){
        Test.startTest();
        UtilUnitTest.loadAllStaticData();
        //Assigned_Partner__c tptest = UtilUnitTest.getAssigned_Partner_c();        
        Id partnerAccountId = GenericStaticTestData.gettestChannelAccountRecord1().Id;
        Assigned_Partner__c tptest = new Assigned_partner__c(Name='Test Target Prospect Record',TARGET_ARCHITECTURE__C='Any/All Technologies',TARGET_DESCRIPTION__C='Test Target Prospect Record',Assigned_Partner__c = partnerAccountId, Partner_Status__c = 'Partner Assigned', Partner_Assigned_Date__c = DateTime.now(), PSR_Assigned_Date_Time__c = DateTime.now());
        insert tptest;
       
        
        
        Prospect_Extension__c  prosp_Ext = UtilUnitTest.getProspect_Extension();
        prosp_Ext.Target_Prospect__c = tptest.Id;
        insert prosp_Ext;
        
        Apexpages.StandardController sc = new Apexpages.standardController(tptest);
        SCP_Communities_tpdetails_CT tpct = new SCP_Communities_tpdetails_CT(sc);
        User    paUser = UtilUnitTest.getUser();
        prmFilterUtility.logUser = paUser;
        System.assert(tpct.viewAllDeals()!=null);
        Test.stopTest();
    }
    
    
    static testMethod void initiateDealTest(){
        
        Test.startTest();
        UtilUnitTest.loadAllStaticData();
        Assigned_Partner__c tptest = UtilUnitTest.getAssigned_Partner_c();
        tptest.Expiration_Date__c = date.newInstance(2014, 09, 30);
        Apexpages.StandardController sc = new Apexpages.standardController(tptest);
        SCP_Communities_tpdetails_CT tpct = new SCP_Communities_tpdetails_CT(sc);
        tpct.initiateDeal();
        Test.stopTest();
        
    }
    
    
    static testMethod void redirectTest(){
        UtilUnitTest.loadAllStaticData();   
        User    paUser = UtilUnitTest.getUser();
        prmFilterUtility.logUser = paUser;

        Id partnerAccountId = GenericStaticTestData.gettestChannelAccountRecord1().Id;
        Assigned_Partner__c tptest = new Assigned_partner__c(Name='Test Target Prospect Record',TARGET_ARCHITECTURE__C='Any/All Technologies',TARGET_DESCRIPTION__C='Test Target Prospect Record',Assigned_Partner__c = partnerAccountId, Partner_Status__c = 'Partner Assigned', Partner_Assigned_Date__c = DateTime.now(), PSR_Assigned_Date_Time__c = DateTime.now());
        Apexpages.StandardController sc = new Apexpages.standardController(tptest);
        SCP_Communities_tpdetails_CT tpct = new SCP_Communities_tpdetails_CT(sc);
        tpct.redirect();
        
    }        
    
    static testMethod void extendTest(){
        Test.startTest();
        UtilUnitTest.loadAllStaticData();
        
        Id partnerAccountId = GenericStaticTestData.gettestChannelAccountRecord1().Id;
        //   Assigned_Partner__c tptest = new Assigned_partner__c(Name='Test Target Prospect Record',TARGET_ARCHITECTURE__C='Any/All Technologies',TARGET_DESCRIPTION__C='Test Target Prospect Record',Assigned_Partner__c = partnerAccountId, Partner_Status__c = 'Partner Assigned', Partner_Assigned_Date__c = DateTime.now(), PSR_Assigned_Date_Time__c = DateTime.now());
        Assigned_Partner__c tptest = UtilUnitTest.getAssigned_Partner_c();
        tptest.Expiration_Date__c = date.newInstance(2014, 09, 30);
        Apexpages.StandardController sc = new Apexpages.standardController(tptest);
        SCP_Communities_tpdetails_CT tpct = new SCP_Communities_tpdetails_CT(sc);
        tpct.extend();
        Test.stopTest();
    }
    
    
}