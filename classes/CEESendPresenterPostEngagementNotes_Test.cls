/***************************************************************************************************
Name    : CEESendPresenterPostEngagementNotes_Test 
Author  : Brian Mansfield
Purpose : Test for sending a Presenter post-engagement  
Created Date: Dec 1 2014
Modification History: 
Eric Pesch - Jan 5 2015: Added Comments, cleanup    
Jay Dash - Aug 8 2015 : Added getOpty()                   
*****************************************************************************************************/

@isTest
public class CEESendPresenterPostEngagementNotes_Test {

    /*@method: Testing OBX post-engagement note*/       
    static testMethod void obx (){
        User admin = CEE_TestUtility.getUser('admin', true);
        
        Account testAcct;
        System.runAs(admin){
            CEE_TestUtility.loadCustomSettings();
            testAcct = CEE_TestUtility.getAccount('cee', true);
            // prefix
        }
        
        Opportunity testOpt = null;
        Opportunity opppt =  CEE_TestUtility.getOpty();
        CEE_Location__c testLoc = CEE_TestUtility.getLocation('cee', true, 'EBC/EC');
        CEE__c testCEEOBX = CEE_TestUtility.getBriefing('cee', true, 'OBX', testAcct, opppt, testLoc);

        testCEEOBX.Primary_Account__c = testAcct.id;
        testCEEOBX.Post_Engagement_Message_Sent__c = true;
        testCEEOBX.emailHasNotBeenSent__c = true;
        testCEEOBX.Request_Status__c = 'Confirmed';
        update testCEEOBX;
    }
    
    /*@method: Testing ITCE post-engagement note*/
    static testMethod void itce (){
        User admin = CEE_TestUtility.getUser('admin', true);
        
        Account testAcct2;
        System.runAs(admin){
            CEE_TestUtility.loadCustomSettings();
            testAcct2 = CEE_TestUtility.getAccount('cee2', true);
        }
        
        Opportunity testOpt = null;
        Opportunity opppt =  CEE_TestUtility.getOpty();
        CEE_Location__c testLoc = CEE_TestUtility.getLocation('cee2', true, 'EBC/EC');
        
        CEE__c testCEEITCE = CEE_TestUtility.getBriefing('cee2', false, 'Upcoming_ITCE_Briefing', testAcct2, opppt, testLoc);
        testCEEITCE.Primary_FSO__c = null;
        testCEEITCE.Timezone__c = 'UTC-05:00';
        testCEEITCE.Post_Engagement_Message_Sent__c = true;
        testCEEITCE.emailHasNotBeenSent__c = true;
        testCEEITCE.Request_Status__c = 'Confirmed';
        
        insert testCEEITCE;
    }
}