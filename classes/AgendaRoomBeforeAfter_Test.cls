/***************************************************************************************************
Name    : AgendaRoomBeforeAfter_Test 
Author  : Eric Pesch
Purpose : Trigger Tests for the Agenda_Room__c object  
Created Date: Dec 1 2014
Modification History: 
Eric Pesch - Jan 5 2015: Added Comments, cleanup                     
*****************************************************************************************************/
@isTest
private class AgendaRoomBeforeAfter_Test {
    
    /*@ method: Test for inserting an Agenda Room on a given Briefing object*/
    static testMethod void agendaRoomInsert() {
        //Setup Account
        User admin = CEE_TestUtility.getUser('admin', true);
        Account acct = null;
        Opportunity oppty = null;
        
        System.runAs(admin){
            CEE_TestUtility.loadCustomSettings();
            acct = CEE_TestUtility.getAccount('roomA', true);
        }
        
        //Setup location
        CEE_Location__c loc = CEE_TestUtility.getLocation('roomA', true, 'EBC/EC');
        CEE_Room__c room = CEE_TestUtility.getRoom('roomA', true, loc, false, 6);
        
        //Setup briefing
        Opportunity opppt =  CEE_TestUtility.getOpty();
        CEE__c briefing = CEE_TestUtility.getBriefing('roomA', true, 'OBX', acct, opppt, loc);
        
        
        Test.startTest();
        Agenda_Room__c agendaRoom = CEE_TestUtility.getAgendaRoom('roomA', true, briefing, room);
        Test.stopTest();
        
        //System.assert(true, agendaRoom.Id != null); //Was insert siccessful
        
        List<CEE_Invite__c> invites = [select id, Room__c from CEE_Invite__c where Room__c =: agendaRoom.Id];
        //System.assertEquals(1, invites.size()); //Was the associated Invite object added
    }
    
    /*@ method: Test for inserting Agenda Rooms from multipl Briefing Sites*/
    static testMethod void agendaRoomInsertMultiSite() {
        //Setup Account
        User admin = CEE_TestUtility.getUser('admin', true);
        Account acct = null;
        Opportunity oppty = null;
        
        System.runAs(admin){
            CEE_TestUtility.loadCustomSettings();
            acct = CEE_TestUtility.getAccount('roomA', true);
        }
        
        //Setup locations
        CEE_Location__c locA = CEE_TestUtility.getLocation('roomA', true, 'EBC/EC');
        CEE_Location__c locB = CEE_TestUtility.getLocation('roomB', true, 'Non EBC/EC');
        CEE_Room__c roomA = CEE_TestUtility.getRoom('roomA', true, locA, false, 6);
        CEE_Room__c roomB = CEE_TestUtility.getRoom('roomB', true, locB, false, 6);
        
        //Setup briefing
        Opportunity opppt =  CEE_TestUtility.getOpty();
        CEE__c briefing = CEE_TestUtility.getBriefing('roomA', true, 'OBX', acct, opppt, locA);
        Agenda_Room__c agendaRoomA = CEE_TestUtility.getAgendaRoom('roomA', true, briefing, roomA);
        Agenda_Room__c agendaRoomB = null;


        Test.startTest();
        try{
            agendaRoomB = CEE_TestUtility.getAgendaRoom('roomB', true, briefing, roomB); //fails - site not added
        } catch(Exception e){}
        
        try{
            agendaRoomB = CEE_TestUtility.getAgendaRoom('roomB', true, briefing, roomA); //fails - room already added
        } catch(Exception e){}
        
        //Add briefing Site
        Briefing_Site__c siteB = CEE_TestUtility.getBriefingSite('siteB', true, briefing, locB); //insert alternate location
        
        //Re-add room
        agendaRoomB = CEE_TestUtility.getAgendaRoom('roomB', true, briefing, roomB); //suceeds
        Test.stopTest();
        
        
        //System.assert(true, agendaRoomB.Id != null); //Check to see if agenda room wasn't corrupted
        List<CEE_Invite__c> invites = [select id, Room__c from CEE_Invite__c where Room__c =: agendaRoomB.Id];
        //System.assertEquals(1, invites.size()); //Check to see if the invites were automatically added/removed
    }
    
    /* @method: Test to see if updating/removing an Agenda Room works correctly*/
    static testMethod void agendaRoomUpdate(){
        User admin = CEE_TestUtility.getUser('admin', true);
        Account acct = null;
        Opportunity oppty = null;
        
        System.runAs(admin){
            CEE_TestUtility.loadCustomSettings();
            acct = CEE_TestUtility.getAccount('roomA', true);
        }
        
        //Setup location
        CEE_Location__c loc = CEE_TestUtility.getLocation('roomA', true, 'EBC/EC');
        CEE_Room__c room = CEE_TestUtility.getRoom('roomA', true, loc, false, 6);
        
        //Setup briefing
        Opportunity opppt =  CEE_TestUtility.getOpty();
        CEE__c briefing = CEE_TestUtility.getBriefing('roomA', true, 'OBX', acct, opppt, loc);
        
        Agenda_Room__c agendaRoom = CEE_TestUtility.getAgendaRoom('roomA', true, briefing, room);
        
        
        Test.startTest();
        agendaRoom.Start_Date_Time__c = agendaRoom.Start_Date_Time__c.addHours(1);
        update agendaRoom;
        delete agendaRoom;
        Test.stopTest();
        
        
        //System.assert(true, agendaRoom.Id == null); //Check to see if successfully deleted
        List<CEE_Invite__c> invites = [select id, Room__c from CEE_Invite__c where Room__c =: agendaRoom.Id];
        //System.assertEquals(0, invites.size()); //Check to see if related Invite deleted as well (cascading delete)
    }
}