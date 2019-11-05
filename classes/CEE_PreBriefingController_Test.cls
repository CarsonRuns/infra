/***************************************************************************************************
Name    : CEE_PreBriefingController_Test 
Author  : Akeem Shirley
Purpose : Tests for the Pre Briefing PDF class  
Created Date: Dec 1 2014
Modification History: 
Eric Pesch - Jan 5 2015: Added Comments, cleanup                     
*****************************************************************************************************/

@isTest
public class CEE_PreBriefingController_Test {

    public static testMethod void testMyController() {

        User admin = CEE_TestUtility.getUser('admin', true);

        Account testAcct;
        System.runAs(admin){
            CEE_TestUtility.loadCustomSettings();
            testAcct = CEE_TestUtility.getAccount('cee', true);
        }
        
        
        
        //Opportunity testOpt = null;
        Opportunity opppt =  CEE_TestUtility.getOpty();
        CEE_Location__c testLoc = CEE_TestUtility.getLocation('cee', true, 'EBC/EC');
        CEE__c briefing= CEE_TestUtility.getBriefing('cee', true, 'OBX', testAcct, opppt, testLoc);
        
        //attendee and invitee details
        Topic__c topic = CEE_TestUtility.getTopic('brief', true, false);
        CEE_Room__c room = CEE_TestUtility.getRoom('brief', true, testLoc, false, 6);
        Agenda_Room__c agendaRoom = CEE_TestUtility.getAgendaRoom('brief', false, briefing, room);
        Agenda_Item__c agenda = CEE_TestUtility.getAgendaItem('brief', true, briefing, testLoc, agendaRoom, topic);
       //CEE_Attendee__c attendee = CEE_TestUtility.getAttendee('brief', false, briefing,agenda,true);
        //CEE_Invite__c invite = CEE_TestUtility.getInvite('brief', false, briefing,attendee,agenda,agendaRoom);
        
        
        briefing.Primary_Account__c = testAcct.id;
        briefing.Post_Engagement_Message_Sent__c = true;
        briefing.emailHasNotBeenSent__c = true;
        briefing.Request_Status__c = 'Confirmed';
        update briefing;
        
   
        
        ApexPages.StandardController sc = new ApexPages.standardController(briefing);
        CEE_PreBriefingController myPage = new CEE_PreBriefingController(sc);

        CEE__c test = myPage.getBriefing();
        myPage.setBriefing(briefing);
        myPage.getAttendeeMap();
        
        List<Agenda_Item__c> testAI = myPage.getLstAgendaItems();
        
    }
}