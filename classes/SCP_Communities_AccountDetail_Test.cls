/**
 * Name : SCP_Communities_AccountDetail_Test
 * Author :  Unit Test Generator
 * Description : Test class used for testing the SCP_Communities_AccountDetail_CT
 * Date : 9/16/14 2:31 PM 
 * Version : <intial Draft> 
 */
@isTest
private class SCP_Communities_AccountDetail_Test { 
    /*
     *@name testRedirect() 
     *@return void 
     *@description This method for redirect () In CLASS SCP_Communities_AccountDetail_CT.cls
     */
     static testMethod void  testRedirect() { 
        Account  accountTest   = UtilUnitTest.getAccount();
        ApexPages.StandardController ctr = new ApexPages.StandardController(accountTest );
        SCP_Communities_AccountDetail_CT sCP_Communities_AccountDetail_CTTest  =  new  SCP_Communities_AccountDetail_CT(ctr);
        Test.startTest();
        Test.setCurrentPage(Page.SCP_Communities_accountDetails);
        PageReference pagereferenceTest = sCP_Communities_AccountDetail_CTTest.redirect();
         System.assert(true);
        Test.stopTest();
    }
}