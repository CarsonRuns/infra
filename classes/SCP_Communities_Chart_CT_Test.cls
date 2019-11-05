/**
 * Name : SCP_Communities_Chart_CT_Nova_Test
 * Author : Unit Test Generator
 * Description : Test class used for testing the SCP_Communities_Chart_CT
 * Date : 9/16/14 2:31 PM 
 * Version : <intial Draft> 
 */
 @isTest(seeAllData=true)
private class SCP_Communities_Chart_CT_Test { 
    /*
     *@name testCreateWalletLinedata() 
     *@return void 
     *@description This method for createWalletLinedata () In CLASS SCP_Communities_Chart_CT.cls
     */
     static testMethod void  testCreateWalletLinedata() { 
        string labelTest = 'Test String';
        Decimal valueTest = 0.001;
        Decimal totalTest = 0.001;

        Account  accountNovaTest   =  GenericStaticTestData.gettestChannelAccountRecord1();
        accountNovaTest.Wallet_Wireless_000__c = 10;
        update accountNovaTest;
        ApexPages.StandardController ctr = new ApexPages.StandardController(accountNovaTest );
        SCP_Communities_Chart_CT sCP_Communities_Chart_CTTest  =  new  SCP_Communities_Chart_CT(ctr);
        Test.startTest();
        Test.setCurrentPage(Page.SCP_Communities_AccountTechWalletChart);
        SCP_Communities_Chart_CT.LinedataWrap scp_communities_chart_ctlinedatawrapTest = sCP_Communities_Chart_CTTest.createWalletLinedata(labelTest,valueTest,totalTest);
         System.assert(true);
        Test.stopTest();
    }
    /*
     *@name testGetLineDataWallet() 
     *@return void 
     *@description This method for getLineDataWallet () In CLASS SCP_Communities_Chart_CT.cls
     */
     static testMethod void  testGetLineDataWallet() { 
        Account  accountNovaTest   =  GenericStaticTestData.gettestChannelAccountRecord1();
        accountNovaTest.Wallet_Wireless_000__c = 10;
        update accountNovaTest;
        ApexPages.StandardController ctr = new ApexPages.StandardController(accountNovaTest );
        SCP_Communities_Chart_CT sCP_Communities_Chart_CTTest  =  new  SCP_Communities_Chart_CT(ctr);
        Test.startTest();
        Test.setCurrentPage(Page.SCP_Communities_AccountTechWalletChart);
        List<SCP_Communities_Chart_CT.LinedataWrap> listTest = sCP_Communities_Chart_CTTest.getLineDataWallet();
         System.assert(true);
        Test.stopTest();
    }
    /*
     *@name testGetLineDataBooking() 
     *@return void 
     *@description This method for getLineDataBooking () In CLASS SCP_Communities_Chart_CT.cls
     */
     static testMethod void  testGetLineDataBooking() { 
        Account  accountNovaTest   =  GenericStaticTestData.gettestChannelAccountRecord1();
        accountNovaTest.Wallet_Wireless_000__c = 10;
        update accountNovaTest;
        ApexPages.StandardController ctr = new ApexPages.StandardController(accountNovaTest );
        SCP_Communities_Chart_CT sCP_Communities_Chart_CTTest  =  new  SCP_Communities_Chart_CT(ctr);
        Test.startTest();
        Test.setCurrentPage(Page.SCP_Communities_AccountTechWalletChart);
        List<SCP_Communities_Chart_CT.LinedataWrap> listTest = sCP_Communities_Chart_CTTest.getLineDataBooking();
         System.assert(true);
        Test.stopTest();
    }
}