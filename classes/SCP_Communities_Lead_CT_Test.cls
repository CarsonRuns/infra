/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class SCP_Communities_Lead_CT_Test {

    static testMethod void myUnitTest() {
        Lead leadrec = UtilUnitTest.getLead();
        Test.startTest();
        Apexpages.StandardController sc = new Apexpages.standardController(leadrec);
        SCP_Communities_Lead_CT  sCPCommunitiesLeadCTTest  =  new  SCP_Communities_Lead_CT(sc);
        sCPCommunitiesLeadCTTest.getIsChekAccesLead();
        SCP_Communities_Lead_CT.updateTC();
    }   
    
    
     static testMethod void  initiateDealTest() { 
        Lead leadrec = UtilUnitTest.getLead();
        Test.startTest();
        Apexpages.StandardController sc = new Apexpages.standardController(leadrec);
        SCP_Communities_Lead_CT  sCPCommunitiesLeadCTTest  =  new  SCP_Communities_Lead_CT(sc);
        System.assert(sCPCommunitiesLeadCTTest.initiateDeal()!=null);   
        Test.stopTest();
     } 
        
     static testMethod void  addEditPSR() { 
        Lead leadrec = UtilUnitTest.getLead();
        Test.startTest();
        Apexpages.StandardController sc = new Apexpages.standardController(leadrec);
        SCP_Communities_Lead_CT  sCPCommunitiesLeadCTTest  =  new  SCP_Communities_Lead_CT(sc);
        System.assert(sCPCommunitiesLeadCTTest.addEditPSR()!=null);
        Test.stopTest();
     }
   
     static testMethod void redirectTest(){
        Lead leadrec = UtilUnitTest.getLead();
        Test.startTest();
        Apexpages.StandardController sc = new Apexpages.standardController(leadrec);
        SCP_Communities_Lead_CT  sCPCommunitiesLeadCTTest  =  new  SCP_Communities_Lead_CT(sc);
        User    paUser = UtilUnitTest.getUser();
        prmFilterUtility.logUser = paUser;
        System.assert(!sCPCommunitiesLeadCTTest.isPA);  
        System.assert(sCPCommunitiesLeadCTTest.redirect()!=null);   
        Test.stopTest();
    }
}