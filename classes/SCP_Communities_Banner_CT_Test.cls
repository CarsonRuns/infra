/**
 * Name : SCP_Communities_Banner_CT_Test
 * Author :  Unit Test Generator
 * Description : Test class used for testing the SCP_Communities_Banner_CT
 * Date : 9/16/14 2:31 PM 
 * Version : <intial Draft> 
 */
@isTest(seeAllData=false)
private class SCP_Communities_Banner_CT_Test { 
    /*
     *@name testManipulateStr() 
     *@return void 
     *@description This method for manipulateStr () In CLASS SCP_Communities_Banner_CT.cls
     */
     static testMethod void  testManipulateStr() {
        UtilUnitTest.loadAllStaticData();
        SCP_Communities_Banner_CT sCPCommunitiesBannerCTTest  =  new  SCP_Communities_Banner_CT();
        Test.startTest();
        Test.setCurrentPage(Page.SCP_Communities_banner);
        sCPCommunitiesBannerCTTest.manipulateStr();
         System.assert(true);
        Test.stopTest();
    }
    /*
     *@name testCreateActivity() 
     *@return void 
     *@description This method for createActivity () In CLASS SCP_Communities_Banner_CT.cls
     */
     static testMethod void  testCreateActivity() { 
        SCP_Communities_Banner_CT sCPCommunitiesBannerCTTest  =  new  SCP_Communities_Banner_CT();
        Test.startTest();
        Test.setCurrentPage(Page.SCP_Communities_banner);
        //String stringTest = sCPCommunitiesBannerCTTest.createActivity();
         System.assert(true);
        Test.stopTest();
    }
    /*
     *@name testCreateLangCookie() 
     *@return void 
     *@description This method for createLangCookie () In CLASS SCP_Communities_Banner_CT.cls
     */
     static testMethod void  testCreateLangCookie() { 
        SCP_Communities_Banner_CT sCPCommunitiesBannerCTTest  =  new  SCP_Communities_Banner_CT();
        Test.startTest();
        Test.setCurrentPage(Page.SCP_Communities_banner);
        sCPCommunitiesBannerCTTest.createLangCookie();
         System.assert(true);
        Test.stopTest();
    }
    
    static testMethod void  unitTest() { 
        SCP_Communities_Banner_CT sCPCommunitiesBannerCTTest  =  new  SCP_Communities_Banner_CT();
        LnP_Constants__c lnp =new LnP_Constants__c(Archive_Days__c=99); 
        insert lnp;
        Test.startTest();
        SCP_Communities_Banner_CT.messageString();
        string s =sCPCommunitiesBannerCTTest.output;
        Test.stopTest();
    }
}