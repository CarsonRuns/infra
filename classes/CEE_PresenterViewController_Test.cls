/***************************************************************************************************
Name    : CEE_PresenterViewController_Test 
Author  : Akeem Shirley
Purpose : Trigger Tests for the Account_Executive_Sponsor__c object  
Created Date: Dec 1 2014
Modification History: 
Eric Pesch - Jan 6 2015: Added Comments, cleanup                     
*****************************************************************************************************/

@isTest
public class CEE_PresenterViewController_Test {
    
    /*@method: Test for Presenter output PDF view*/
    public static testMethod void testPresenterPDFController() {
        User admin = CEE_TestUtility.getUser('admin', true);
        Account testAcct;

        System.runAs(admin){
            CEE_TestUtility.loadCustomSettings();
            testAcct = CEE_TestUtility.getAccount('cee', true);
        }

        Opportunity testOpt = null;
        Opportunity opppt =  CEE_TestUtility.getOpty();
        CEE_Location__c testLoc = CEE_TestUtility.getLocation('cee', true, 'EBC/EC');
        CEE__c briefing= CEE_TestUtility.getBriefing('cee', true, 'OBX', testAcct, opppt, testLoc);

        briefing.Primary_Account__c = testAcct.id;
        briefing.Post_Engagement_Message_Sent__c = true;
        briefing.emailHasNotBeenSent__c = true;
        briefing.Request_Status__c = 'Confirmed';
        update briefing;
        
        Topic__c topic = CEE_TestUtility.getTopic('brief', true, false);
        CEE_Room__c room = CEE_TestUtility.getRoom('brief', true, testLoc, false, 6);
        Agenda_Room__c agendaRoom = CEE_TestUtility.getAgendaRoom('brief', false, briefing, room);
        Agenda_Item__c agenda = CEE_TestUtility.getAgendaItem('brief', true, briefing, testLoc, agendaRoom, topic);
       
        ApexPages.StandardController sc = new ApexPages.standardController(briefing);
        CEE_PresenterViewController myPage = new CEE_PresenterViewController(sc);

        List<Agenda_Item__c> testAI = myPage.getLstAgendaItems();
        Map<String, String> testMap = myPage.getAttendeeMap();

        CEE__c test = myPage.getBriefing();
        myPage.setBriefing(briefing);

        String testDate = myPage.convertAgendaTime(Date.today());
    }
}