/***************************************************************************************************
Name    : CEE_OBX_Reports_Schedulars_Test 
Author  : Sudi Pitchaiah
Purpose : Test class for 4 OBX schedule jobs and 1 OBX Batchable class 
Created Date: Oct 26 2015
Modification History: 
                     
*****************************************************************************************************/
@isTest(seealldata=true)
private class CEE_OBX_Reports_Schedulars_Test {
	
    static testMethod void myUnitTest_AMER() {   
    	//CEE_TestUtility.loadCustomSettings(); 	
     	Test.StartTest();
        CEE_OBX_Reports_AMER_Schedular  sh1 = new CEE_OBX_Reports_AMER_Schedular();
        String sch = '0 0 14 * * ?';
        system.schedule('Test coverage AMER', sch, sh1);
        System.assertEquals('0 0 14 * * ?',sch);
        Test.stopTest();
     	
    
    }
    static testMethod void myUnitTest_APJC() { 
    	//CEE_TestUtility.loadCustomSettings(); 	    	
     	Test.StartTest();
        CEE_OBX_Reports_APJC_Schedular  sh1 = new CEE_OBX_Reports_APJC_Schedular();
        String sch = '0 0 10 * * ?';
        system.schedule('Test coverage APJC', sch, sh1);
        System.assertEquals('0 0 10 * * ?',sch);
        Test.stopTest();
     	
    
    }
    static testMethod void myUnitTest_EMEAR() {   
    	//CEE_TestUtility.loadCustomSettings(); 	  	
     	Test.StartTest();
        CEE_OBX_Reports_EMEAR_Schedular  sh1 = new CEE_OBX_Reports_EMEAR_Schedular();
        String sch = '0 0 20 * * ?';
        system.schedule('Test coverage EMEAR', sch, sh1);
        System.assertEquals('0 0 20 * * ?',sch);
        Test.stopTest();
     	
    
    }
    static testMethod void myUnitTest_SanJose() {    	             		     
     	Test.StartTest();
        CEE_OBX_Reports_SanJose_Schedular  sh1 = new CEE_OBX_Reports_SanJose_Schedular();
        String sch = '0 0 21 * * ?';
        system.schedule('Test coverage Sanjose', sch, sh1);
        System.assertEquals('0 0 21 * * ?',sch);
        Test.stopTest();
     	
    
    }
}