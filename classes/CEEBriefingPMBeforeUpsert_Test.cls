/***************************************************************************************************
Name    : CEEBriefingPMBeforeUpsert_Test 
Author  : Eric Pesch
Purpose : Trigger Tests for the Briefing_PM__c object  
Created Date: Dec 1 2014
Modification History: 
Eric Pesch - Jan 5 2015: Added Comments, cleanup                     
*****************************************************************************************************/

@isTest
private class CEEBriefingPMBeforeUpsert_Test {
	
	/*@method: Test PM insertion*/
    static testMethod void pmInsertTest() {
        //Setup location
    	CEE_Location__c loc = CEE_TestUtility.getLocation('pm', true, 'EBC/EC');
    	
    	Test.startTest();
    	Briefing_PM__c briefPM = CEE_TestUtility.getBriefingPM('pm', true, loc);
    	
    	Test.stopTest();
    	
    	//System.assert(true, briefPM.Id != null);
    	//Check if user ID were populated correctly
    	//System.assert(true, briefPM.Primary_PM__c != null);
    	//System.assert(true, briefPM.Secondary_PM__c != null);
    }
}