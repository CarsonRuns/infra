/***************************************************************************************************
Name    : AccountExecSponsorBeforeUpsert_Test 
Author  : Eric Pesch
Purpose : Trigger Tests for the Account_Executive_Sponsor__c object  
Created Date: Dec 1 2014
Modification History: 
Eric Pesch - Jan 5 2015: Added Comments, cleanup                     
*****************************************************************************************************/ 

@isTest
private class AccountExecSponsorBeforeUpsert_Test {
	
	/* @method: Test inserting an Account Executive Sponsor record*/
    private static testMethod void accountESPInsert() {
        Test.startTest();
        Account_Executive_Sponsor__c esp = CEE_TestUtility.getAccountExecutiveSponsor('test', true);
        Test.stopTest();
        
        List<Account_Executive_User__c> espUsers = [select id from Account_Executive_User__c where Account_Executive_Sponsor__c =: esp.Id];        
        //System.assert(true, esp.Id != null); //Validate record was inserted
        //System.assertEquals(4, espUsers.size()); //Validate the associated Users to the record
    }
    
    /* @method: Test updating and removing a User from the Executive Sponsor record*/
    private static testMethod void accountESPUpdate(){
    	Account_Executive_Sponsor__c esp = CEE_TestUtility.getAccountExecutiveSponsor('test', true);
    	User vp = CEE_TestUtility.getUser('vpnew', true);
    	esp.VP_CEC__c = 'vpnew';
    	
        Test.startTest();
        update esp;
        
        esp.VP_CEC__c = 'vpnew';
        update esp;
        Test.stopTest();
        
        //Previous validation tests
        List<Account_Executive_User__c> espUsers = [select id, User__c from Account_Executive_User__c where Account_Executive_Sponsor__c =: esp.Id];        
        //System.assert(true, esp.Id != null);
        //System.assertEquals(4, espUsers.size());
        
        Boolean espVPValid = false;
        for(Account_Executive_User__c user : espUsers){
			if(user.User__c == vp.Id){
				espVPValid = true;
			}        	
        }
        //System.assert(true, espVPValid); //Test to see if VP User was swapped out correctly
    }
}