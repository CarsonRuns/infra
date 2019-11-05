/***************************************************************************************************
Name    : CEE_Add_Multi_Attendees_Test 
Author  : sudi  
Purpose : Controller test for the Add multiple CEE Attendees in single page
Created Date: Feb 5 2016
Modification History: 

*****************************************************************************************************/ 

@isTest
private class CEE_Add_Multi_Attendees_Test {

    private static testMethod void CeeAttendeesTest() {
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
        
        //Setup briefing
        Opportunity opppt =  CEE_TestUtility.getOpty();
        CEE__c briefing = CEE_TestUtility.getBriefing('brief', true, 'OBX', acct, opppt, loc);
        Topic__c topic = CEE_TestUtility.getTopic('brief', true, false);
        Agenda_Room__c agendaRoom = CEE_TestUtility.getAgendaRoom('brief', true, briefing, room);
        
        
        //Setup agenda item
        Agenda_Item__c agenda = CEE_TestUtility.getAgendaItem('brief', true, briefing, loc, agendaRoom, topic);
        
        //Setup Presenter
        CEE_Attendee__c presenter = CEE_TestUtility.getAttendee('brief', false, briefing, agenda, true);
        CEE_Add_Multi_Attendees objClass = new CEE_Add_Multi_Attendees();
        PageReference pRef = Page.CEE_Add_Multi_Attendess;
        pRef.getParameters().put('CEEId', briefing.Id);
        Test.setCurrentPage(pRef);
        Test.startTest();
        objClass.rowToRemove = 1;
        objClass.addNewRowToAttList();
        objClass.addNewRowToAttList();
        objClass.removeRowFromAttList();
        objClass.SaveMultipleAttendes();
        list<CEE_Add_Multi_Attendees.WrapperpaAttendeeList> lstDate = new list<CEE_Add_Multi_Attendees.WrapperpaAttendeeList>();
        for(CEE_Add_Multi_Attendees.WrapperpaAttendeeList recordData : objClass.waAccList){
            CEE_Attendee__c newAttRecord = new CEE_Attendee__c(); 
            recordData.record.Salesforce_User__c = userinfo.getUserId();    
            recordData.record.Customer_Engagement_Events__c = briefing.Id;      
            recordData.record.type__c = 'Presenter';
            recordData.record.Agenda_Item__c = agenda.Id;
            lstDate.add(recordData);
        }
        objClass.waAccList = lstDate;
        objClass.SaveMultipleAttendes();
        objClass.getAgendaOptions();
        objClass.cancelBtn();
        Test.stopTest();
    }
}