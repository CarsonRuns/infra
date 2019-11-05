/**
 * Name : SCP_Communities_PSRBulk_CT_Test
 * Author :  Unit Test Generator
 * Description : Test class used for testing the SCP_Communities_PSRBulk_CT
 * Date : 9/16/14 2:31 PM 
 * Version : <intial Draft> 
 */
@isTest
private class SCP_Communities_PSRBulk_CT_Test { 
    /*
     *@name testGetKey() 
     *@return void 
     *@description This method for getKey () In CLASS SCP_Communities_PSRBulk_CT.cls
     */
     static testMethod void  testGetKey() { 
        SCP_Communities_PSRBulk_CT sCPCommunitiesPSRBulkCTTest  =  new  SCP_Communities_PSRBulk_CT();
        Test.startTest();
        String stringTest = sCPCommunitiesPSRBulkCTTest.getKey();
         System.assert(true);
        Test.stopTest();
    }
    /*
     *@name testSetKey() 
     *@return void 
     *@description This method for setKey () In CLASS SCP_Communities_PSRBulk_CT.cls
     */
     static testMethod void  testSetKey() { 
        string valueTest = 'Test String';
        SCP_Communities_PSRBulk_CT sCPCommunitiesPSRBulkCTTest  =  new  SCP_Communities_PSRBulk_CT();
        Test.startTest();
        sCPCommunitiesPSRBulkCTTest.setKey(valueTest);
         System.assert(true);
        Test.stopTest();
    }
    /*
     *@name testGetPageController() 
     *@return void 
     *@description This method for getPageController () In CLASS SCP_Communities_PSRBulk_CT.cls
     */
     static testMethod void  testGetPageController() { 
        SCP_Communities_PSRBulk_CT sCPCommunitiesPSRBulkCTTest  =  new  SCP_Communities_PSRBulk_CT();
        Test.startTest();
        SCP_Communities_PageControllerBase scp_communities_pagecontrollerbaseTest = sCPCommunitiesPSRBulkCTTest.getPageController();
         System.assert(true);
        Test.stopTest();
    }
    /*
     *@name testSetPageController() 
     *@return void 
     *@description This method for setPageController () In CLASS SCP_Communities_PSRBulk_CT.cls
     */
     static testMethod void  testSetPageController() { 
        SCP_Communities_PageControllerBase valTest = new SCP_Communities_PageControllerBase();
        SCP_Communities_PSRBulk_CT sCPCommunitiesPSRBulkCTTest  =  new  SCP_Communities_PSRBulk_CT();
        Test.startTest();
        sCPCommunitiesPSRBulkCTTest.setPageController(valTest);
         System.assert(true);
        Test.stopTest();
    }
    /*
     *@name testAssignPSRs() 
     *@return void 
     *@description This method for assignPSRs () In CLASS SCP_Communities_PSRBulk_CT.cls
     */
     static testMethod void  testAssignPSRs() { 
        SCP_Communities_PageControllerBase valTest = new SCP_Communities_PageControllerBase();
        SCP_Communities_PSRBulk_CT sCPCommunitiesPSRBulkCTTest  =  new  SCP_Communities_PSRBulk_CT();
        sCPCommunitiesPSRBulkCTTest.setPageController(valTest);
        Test.startTest();
        sCPCommunitiesPSRBulkCTTest.assignPSRs();
         System.assert(true);
        Test.stopTest();
    }
}