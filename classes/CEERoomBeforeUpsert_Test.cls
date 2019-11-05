/***************************************************************************************************
Name    : CEERoomBeforeUpsert_Test 
Author  : Eric Pesch
Purpose : Trigger Tests for the CEE_Room__c object  
Created Date: Dec 1 2014
Modification History: 
Eric Pesch - Jan 5 2015: Added Comments, cleanup                     
*****************************************************************************************************/

@isTest
private class CEERoomBeforeUpsert_Test {

	/*@method: test for inserting a CEE Room*/
    static testMethod void ceeRoomInsert() {
        //Setup location
    	CEE_Location__c locA = CEE_TestUtility.getLocation('roomA', true, 'EBC/EC');
    	CEE_Location__c locB = CEE_TestUtility.getLocation('roomB', true, 'Non EBC/EC');
    	
    	Test.startTest();
    	//Insert room to one location
    	CEE_Room__c roomA = CEE_TestUtility.getRoom('roomA', true, locA, false, 6);
    	
    	//Insert room to non ebc/ec location
    	CEE_Room__c roomB = CEE_TestUtility.getRoom('roomB', true, locB, false, 6);
    	
    	//Insert same room, different location
    	CEE_Room__c roomC = CEE_TestUtility.getRoom('roomB', false, locA, false, 6);
    	roomC.CEE_Location__c = null;
    	
    	User myUser = [ select Id from User where Id = :UserInfo.getUserId() ];
		System.runAs (myUser) {
    		insert roomC;
		
	    	//Fail to insert duplicate room
	    	try{
	    		CEE_Room__c roomD = CEE_TestUtility.getRoom('roomB', false, locB, false, 6);
	    		roomD.CEE_Location__c = null;
	    		roomD.EBC_CBC_Location__c = null;
	    		roomD.Building__c = locB.Name;
	    		
	    		insert roomD;
	    	} catch(Exception e){}
	    	
	    	//Fail to insert duplicate room (location w/multiple rooms)
	    	try{
	    		CEE_Room__c roomE = CEE_TestUtility.getRoom('roomB', false, locA, false, 6);
	    		roomE.CEE_Location__c = null;
	    		roomE.EBC_CBC_Location__c = null;
	    		roomE.Building__c = locA.Name;
	    		
	    		insert roomE;
	    	} catch(Exception e){}
		}
    	Test.stopTest();
    	
    	List<CEE_Room__c> roomsA = [select Id, Name from CEE_Room__c where CEE_Location__c =: locA.Id];
    	List<CEE_Room__c> roomsB = [select Id, Name from CEE_Room__c where CEE_Location__c =: locB.Id];
    	
    	//System.assert(true, (roomA.Id != null) && (roomB.Id != null) && (roomC.Id != null));
    	//System.assertEquals(2, roomsA.size());
    	//System.assertEquals(1, roomsB.size());
    }
}