/***************************************************************************************************
Name    : CEE_AgendaRoomEditController_Test 
Author  : Eric Pesch
Purpose : Tests for the Agenda Room Edit Visualforce Page  
Created Date: Dec 1 2014
Modification History: 
Eric Pesch - Jan 5 2015: Added Comments, cleanup                     
*****************************************************************************************************/

@isTest
private class CEE_AgendaRoomEditController_Test {

    /*@method: Agenda Room page new test method*/
    static testMethod void agendaRoomTestNew() {
        //Setup Account
        User admin = CEE_TestUtility.getUser('admin', true);
        Account acct = null;
        Opportunity oppty = null;
        CEE_Location__c loc = null;
        CEE_Room__c room = null;
        Opportunity opppt =  null;
        
        System.runAs(admin){
            CEE_TestUtility.loadCustomSettings();
            acct = CEE_TestUtility.getAccount('brief', true);
        
        //Setup location
        loc = CEE_TestUtility.getLocation('brief', true, 'EBC/EC');
        room = CEE_TestUtility.getRoom('brief', true, loc, false, 6);
        
        //Setup briefing
        opppt =  CEE_TestUtility.getOpty();
        }
        CEE__c briefing = CEE_TestUtility.getBriefing('brief', true, 'OBX', acct, opppt, loc);
        Topic__c topic = CEE_TestUtility.getTopic('brief', true, false);

        //TEST = setup agenda Room      
        Agenda_Room__c agendaRoom = CEE_TestUtility.getAgendaRoom('brief', false, briefing, room);
        ApexPages.StandardController stdItem = new ApexPages.StandardController(agendaRoom);
        CEE_AgendaRoomEditController roomController = new CEE_AgendaRoomEditController(stdItem);
        
        //Utility methods
        roomController.getRoomOptions();
        roomController.setRoomOptions(null);

        
        //Save
        roomController.doSaveNew();
        roomController.doSave(true);
        roomcontroller.docancel();
    }
    
    /*@method: Agenda Room old update/insert test*/
    static testMethod void agendaRoomTest() {
        //Setup Account
        User admin = CEE_TestUtility.getUser('admin', true);
        Account acct = null;
        Opportunity oppty = null;
        Opportunity opppt =null;
        CEE_Location__c loc =null;
        CEE_Room__c room =null;
        System.runAs(admin){
            CEE_TestUtility.loadCustomSettings();
            acct = CEE_TestUtility.getAccount('brief', true);
        
        
        //Setup location
        loc = CEE_TestUtility.getLocation('brief', true, 'EBC/EC');
        room = CEE_TestUtility.getRoom('brief', true, loc, false, 6);
        
        //Setup briefing
         opppt =  CEE_TestUtility.getOpty();
        }
        CEE__c briefing = CEE_TestUtility.getBriefing('brief', true, 'OBX', acct, opppt, loc);
        Topic__c topic = CEE_TestUtility.getTopic('brief', true, false);
        Agenda_Room__c agendaRoom = CEE_TestUtility.getAgendaRoom('brief', true, briefing, room);
        
        Test.startTest();
        ApexPages.StandardController stdItem = new ApexPages.StandardController(agendaRoom);
        CEE_AgendaRoomEditController roomController = new CEE_AgendaRoomEditController(stdItem);
        
        //Utility methods
        
        roomController.getRoomOptions();
        roomController.setRoomOptions(null);

        
        //Save
        roomController.doSaveNew();
        roomController.doSave(true);
        

        Test.stopTest();
    }
    
}