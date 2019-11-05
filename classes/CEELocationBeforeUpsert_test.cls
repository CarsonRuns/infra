/***************************************************************************************************
Name    : CEELocationBeforeUpsert_test 
Author  : Eric Pesch
Purpose : Trigger Tests for the CEE_Location__c object  
Created Date: Dec 1 2014
Modification History: 
Eric Pesch - Jan 5 2015: Added Comments, cleanup                     
*****************************************************************************************************/

@isTest
private class CEELocationBeforeUpsert_test {
	
	/*@method: Test for inserting a CEE Location*/
    static testMethod void ceeLocationInsert() {
        Test.startTest();
        CEE_Location__c locA = CEE_TestUtility.getLocation('siteA', true, 'EBC/EC');
    	CEE_Location__c locB = CEE_TestUtility.getLocation('siteB', true, 'Non EBC/EC');
        Test.stopTest();
        
        System.assert(true, (locA.Id != null) && (locB.Id != null));
        //Type
        System.assertEquals('EBC/EC', locA.Location_Type__c);
        System.assertEquals('Non EBC/EC', locB.Location_Type__c);
        //Users
        System.assert(true, locA.Primary_Scheduler__c != null);
        User sampleScheduler = [select Id, Email from User where Id =: locA.Primary_Scheduler__c];
        System.assertEquals(sampleScheduler.Email, locA.Primary_Scheduler_Email__c);
    }
}