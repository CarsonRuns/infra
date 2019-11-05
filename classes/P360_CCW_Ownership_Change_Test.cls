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
@isTest(seeAllData=true)
private class P360_CCW_Ownership_Change_Test {

    static testMethod void multiQueueOwnershipTest() {
        
        GenericStaticTestData.insertTestAccountRecords();
        GenericStaticTestData.insertTestUserRecords();
        
        Assigned_partner__c t1 = new Assigned_partner__c(Assigned_Partner__c=GenericStaticTestData.testChannelAccountRecord1.id,Customer_Account__c=GenericStaticTestData.testEndUserAccountRecordGreen.id, Name='Test Target Prospect Record',Marketing_Play_Name__c='FY14 Q1 GTM',TARGET_ARCHITECTURE__C='Any/All Technologies',TARGET_DESCRIPTION__C='Test Target Prospect Record');
        insert t1;
          
        Multi_Object_Quote__c moq = new Multi_Object_Quote__c(name='Test',Target_Prospect__c=t1.Id);  
        insert moq;
        
        test.starttest();          
        
        t1.OwnerId =   GenericStaticTestData.testPSRUserRecord.Id;
        update t1;
          
        Assigned_partner__c t2 = new Assigned_partner__c(Assigned_Partner__c=GenericStaticTestData.testChannelAccountRecord1.id,Customer_Account__c=GenericStaticTestData.testEndUserAccountRecordGreen.id, Name='Test Target Prospect Record',Marketing_Play_Name__c='FY14 GTM',TARGET_ARCHITECTURE__C='Any/All Technologies',TARGET_DESCRIPTION__C='Test Target Prospect Record');
        insert t2;
         
        test.stoptest();
      
      
        
    }
}