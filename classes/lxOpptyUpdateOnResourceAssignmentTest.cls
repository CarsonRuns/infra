/**************************************
Author          : R.Hari Krishna(ratharik) 
Release         : May Release
Created         : April 22,2019
Functionality   : Test class

Modification History:
Itrack#        Date        		Author              		Change  
****************************************************************************
US290188    April 22,2019      Hari Krishna(ratharik)    Initial Draft
**********************************************/
@isTest
public class lxOpptyUpdateOnResourceAssignmentTest {
	//helps us to setUp dummy data
    @testSetup static void setup() {
        lxTestDataFactory.createCustomSettings();
    }
    
    @isTest
    static void testSEStatusUpdateOnOppty() { 
        Utilities.setIsTestMethod(true);
        Utilities.setValidationSkip(true);
        User userForTesting = [SELECT Id FROM User WHERE Additional_User_Permissions__c ='SE User' AND isActive= True LIMIT 1];
        //mkella
        // skip all validation rules
        /*    
            Utilities.setSkip(true);   
            Utilities.setValidationSkip(true);
            Utilities.setSkipFuture(true);
		*/
        //mkella
        User testUser = lxTestDataFactory.getLoggedInUser();
        Opportunity testOpty = lxTestDataFactory.createSingleOppty();
        insert testOpty;
        
        Resource_Request_Assignment__c testResrReqAssignmnt = lxTestDataFactory.createSingleResourceRqstAssgmnt(testOpty.Id,testUser.Id);
        testResrReqAssignmnt.Resource_Status__c = 'Assigned';
        
        system.runAs(userForTesting) {
            insert testResrReqAssignmnt;
			update testResrReqAssignmnt;
			delete testResrReqAssignmnt;            
        }
    }   
}