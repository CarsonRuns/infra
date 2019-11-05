/***************************************************************************************************
Name    : CEE_LocationAvailabilityController_Test 
Author  : Eric Pesch
Purpose : Test for availability method of a CEE Location 
Created Date: Dec 1 2014
Modification History: 
Eric Pesch - Jan 5 2015: Added Comments, cleanup                     
*****************************************************************************************************/

@isTest
private class CEE_LocationAvailabilityController_Test {

	/*@method: CEE Location function tests*/
    private static testMethod void ceeLocationAvailabilityTest() {
        //Variables
    	String testRoot = null, testEnv = null;
    	
        //Setup Account
    	User admin = CEE_TestUtility.getUser('admin', true);
    	Account acct = null;
    	Opportunity oppty = null;
    	
    	System.runAs(admin){
    		CEE_TestUtility.loadCustomSettings();
	    	acct = CEE_TestUtility.getAccount('brief', true);
    	}
    	
    	//Setup location
    	CEE_Location__c loc = CEE_TestUtility.getLocation('brief', true, 'EBC/EC');
    	CEE_Room__c room = CEE_TestUtility.getRoom('brief', true, loc, false, 6);
    	
		//Get standard parameters
		Test.setCurrentPage(new PageReference(''));
		testRoot = Utilities.getConstant_CS('CEE Outlook URL');
		testEnv = Utilities.getConstant_CS('CEE Environment');
		
		//APEX Page testing
		ApexPages.StandardController stdItem = new ApexPages.StandardController(loc);
		CEE_LocationAvailabilityController locationController = new CEE_LocationAvailabilityController(stdItem);
		
		
		//Change current URL
		//System.assertEquals(testRoot + CEE_Utility.ROOT_URL_REDIRECT, locationController.ifrURL);
		locationController.changeUrl();
		
		//Assertion tests
		//System.assert(true, locationController.ifrURL.contains('&Command=agenda_item_availability'));
    }
}