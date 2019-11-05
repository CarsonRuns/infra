/***************************************************************************************************
Name    : CEE_AgendaItemController_Test 
Author  : Eric Pesch
Purpose : Controller test for the Agenda Item Edit Page Controller
Created Date: Dec 1 2014
Modification History: 
Eric Pesch - Jan 5 2015: Added Comments, cleanup                     
*****************************************************************************************************/ 

@isTest
private class CEE_AgendaItemController_Test {
    
    /*@method: Test for a new Agenda Item insert*/
    private static testMethod void agendaItemNewTest() {
        //Variables
        String testRoot = null, testEnv = null;
        
        //Setup Account
        User admin = CEE_TestUtility.getUser('admin', true);
        Account acct = null;
        Opportunity oppty = null;
        
        System.runAs(admin){
            CEE_TestUtility.loadCustomSettings();
            acct = CEE_TestUtility.getAccount('brief', true);
        }
        
        //Setup locations
        CEE_Location__c loc = CEE_TestUtility.getLocation('brief', true, 'EBC/EC');
        CEE_Location__c locB = CEE_TestUtility.getLocation('roomB', true, 'Non EBC/EC');
        CEE_Room__c room = CEE_TestUtility.getRoom('brief', true, loc, false, 6);
        CEE_Room__c roomB = CEE_TestUtility.getRoom('roomB', true, locB, false, 6);
        
        //Setup briefing
        Opportunity opppt =  CEE_TestUtility.getOpty();
        CEE__c briefing = CEE_TestUtility.getBriefing('brief', true, 'OBX', acct, opppt, loc);
        Briefing_Site__c siteB = CEE_TestUtility.getBriefingSite('siteB', true, briefing, locB); //insert alternate location
        
        //Setup topics
        Topic__c topic = CEE_TestUtility.getTopic('brief', true, false);
        Topic__c topicB = CEE_TestUtility.getTopic('brief2', true, false);
        CEE_TestUtility.getOtherTopic();
        
        Test.startTest();
        Agenda_Room__c agendaRoom = CEE_TestUtility.getAgendaRoom('brief', true, briefing, room);
        Agenda_Room__c agendaRoomB = CEE_TestUtility.getAgendaRoom('roomB', true, briefing, roomB);
        
        //Setup agenda item
        Agenda_Item__c agenda = CEE_TestUtility.getAgendaItem('brief', false, briefing, loc, agendaRoom, topic);
        agenda.Topic__c = null;
        agenda.Start_Date_Time__c = null;
        agenda.Catering_Attendees__c = null;
        agenda.Catering_Department_Code__c = null;
        agenda.Catering_Type__c = ' Drinks Only';
       // agenda.Catering_Department_Code__c = siteB.Primary_FSO__r.Department_Code__c;
        
        
        //Get standard parameters
        Test.setCurrentPage(new PageReference(''));
        testRoot = Utilities.getConstant_CS('CEE Outlook URL');
        testEnv = Utilities.getConstant_CS('CEE Environment');
        
        //APEX Page testing
        
        ApexPages.StandardController stdItem = new ApexPages.StandardController(agenda);
        CEE_AgendaItemController agendaItemController = new CEE_AgendaItemController(stdItem);
        List<SelectOption> dynRooms = agendaItemController.getDynRooms();
        agendaItemController.setDynRooms(null);
        
        List<SelectOption> architecture = agendaItemController.getArchitectureOptions();
        agendaItemController.setArchitectureOptions(null);
        
        List<SelectOption> subArch = agendaItemController.getSubArchitectureOptions();
        agendaItemController.setSubArchitectureOptions(null);
        
        List<SelectOption> solution = agendaItemController.getSolutionOptions();
        agendaItemController.setSolutionOptions(null);
        
        agendaItemController.populateCatering();
        
        agendaItemController.populateSites();
        agendaItemController.checkName();
        
        agendaItemController.selectedRooms.add(agendaRoomB.Id);
        
        //Save test
        PageReference save = agendaItemController.doSave();
        //Savenew test
        PageReference saveNew = agendaItemController.doSaveNew();
        
        Test.stopTest();
    }
    
    /*@method: Test for updating an old Agenda Item*/
    private static testMethod void agendaItemUpdateTest() {
        //Variables
        String testRoot = null, testEnv = null;
        
        //Setup Account
        User admin = CEE_TestUtility.getUser('admin', true);
        Account acct = null;
        Opportunity oppty = null;
        
        System.runAs(admin){
            CEE_TestUtility.loadCustomSettings();
            acct = CEE_TestUtility.getAccount('brief', true);
        }
        
        //Setup locations
        CEE_Location__c loc = CEE_TestUtility.getLocation('brief', true, 'EBC/EC');
        //CEE_Location__c locB = CEE_TestUtility.getLocation('roomB', true, 'Non EBC/EC');
        CEE_Room__c room = CEE_TestUtility.getRoom('brief', true, loc, false, 6);
        //CEE_Room__c roomB = CEE_TestUtility.getRoom('roomB', true, locB, false, 6);
        
        //Setup briefing
         Opportunity opppt =  CEE_TestUtility.getOpty();
        CEE__c briefing = CEE_TestUtility.getBriefing('brief', true, 'OBX', acct, opppt, loc);
        //Briefing_Site__c siteB = CEE_TestUtility.getBriefingSite('siteB', true, briefing, locB); //insert alternate location
        
        //Setup topics
        Topic__c topic = CEE_TestUtility.getTopic('brief', true, false);
        //Topic__c topicB = CEE_TestUtility.getTopic('brief2', true, false);
        CEE_TestUtility.getOtherTopic();
        Agenda_Room__c agendaRoom = CEE_TestUtility.getAgendaRoom('brief', true, briefing, room);
        //Agenda_Room__c agendaRoomB = CEE_TestUtility.getAgendaRoom('roomB', true, briefing, roomB);
        
        //Setup agenda item
        Test.startTest();
        Agenda_Item__c agenda = CEE_TestUtility.getAgendaItem('brief', true, briefing, loc, agendaRoom, topic);
        
        //Get standard parameters
        Test.setCurrentPage(new PageReference(''));
        testRoot = Utilities.getConstant_CS('CEE Outlook URL');
        testEnv = Utilities.getConstant_CS('CEE Environment');
        
        //APEX Page testing
         CEE_Attendee__c presenter = CEE_TestUtility.getAttendee('brief', false, briefing, agenda, true);
        ApexPages.StandardController stdItem = new ApexPages.StandardController(agenda);
        CEE_AgendaItemController agendaItemController = new CEE_AgendaItemController(stdItem);
        List<SelectOption> dynRooms = agendaItemController.getDynRooms();
        List<SelectOption> architecture = agendaItemController.getArchitectureOptions();
        List<SelectOption> subArch = agendaItemController.getSubArchitectureOptions();
        List<SelectOption> solution = agendaItemController.getSolutionOptions();
        
        //agendaItemController.selectedRooms.add(agendaRoomB.Id);
        agendaItemController.showFullSolutions = true;
        agendaItemController.checkName();
        
        //Save tests
        PageReference save = agendaItemController.doSave();
        
        //CEEAgendaItemPopupController
        ApexPages.StandardController stdItemBr = new ApexPages.StandardController(briefing);
        CEEAgendaItemPopupController popupController = new CEEAgendaItemPopupController(stdItemBr);
        popupController.loadData();
        popupController.getAgendaitems();
        popupController.deleteAgendaItem();
        
        //Agenda item popup test added 20/8
        PageReference pageRef = Page.CEEAgendaItemModal;
        Test.setCurrentPageReference(pageRef);
        pageRef.getParameters().put('id', agenda.id);
        ApexPages.StandardController stdItem1 = new ApexPages.StandardController(agenda);
        CEEAgendaItemModalController agendaItemController1 = new CEEAgendaItemModalController(stdItem1);
        CEEAgendaItemModalController ceeIgendaCnt = new CEEAgendaItemModalController();
        ceeIgendaCnt.isExcep = true;       
        ceeIgendaCnt.getAgendaItem();
        ceeIgendaCnt.selArchitecture = 'Collaboration';
        ceeIgendaCnt.selSubArchitecture = 'Collaboration Overview';
        ceeIgendaCnt.getSolutionOptions();
        ceeIgendaCnt.getDynRooms();
        ceeIgendaCnt.saveAgendaItem();
        ceeIgendaCnt.showFullSolutions = true;        
       
        List<SelectOption> architecture1 = ceeIgendaCnt.getArchitectureOptions();
        ceeIgendaCnt.setArchitectureOptions(null);
        
        List<SelectOption> subArch1 = ceeIgendaCnt.getSubArchitectureOptions();
        ceeIgendaCnt.setSubArchitectureOptions(null);
        
        List<SelectOption> solution1 = ceeIgendaCnt.getSolutionOptions();
        agendaItemController.setSolutionOptions(null);  
        ceeIgendaCnt.getAgendaItemsData();   
        ceeIgendaCnt.checkName();
        ceeIgendaCnt.getArchitectureOptions();
        ceeIgendaCnt.getSubArchitectureOptions();
        Test.stopTest();
    }
    
    /*@method: Test for updating an old ITCE Agenda Item*/
    private static testMethod void agendaItemUpdateITCETest() {
        //Variables
        String testRoot = null, testEnv = null;
        
        //Setup Account
        User admin = CEE_TestUtility.getUser('admin', true);
        Account acct = null;
        Opportunity oppty = null;

        System.runAs(admin){
            CEE_TestUtility.loadCustomSettings();
            acct = CEE_TestUtility.getAccount('brief', true);
        }
        
        //Setup briefing
        Opportunity opppt =  CEE_TestUtility.getOpty();
        CEE__c briefing = CEE_TestUtility.getBriefing('brief', false, 'Upcoming IT Customer Engagement Briefing', acct, opppt, null);
        briefing.Primary_FSO__c = null;
        briefing.Timezone__c = '(UTC-05:00) Eastern Daylight Time (America/New_York)';
        insert briefing;
        
        //Setup topics
        Topic__c topic = CEE_TestUtility.getTopic('brief', true, false);
        Topic__c topicB = CEE_TestUtility.getTopic('brief2', true, false);
        CEE_TestUtility.getOtherTopic();
        
        //Setup agenda item
        Agenda_Item__c agenda = CEE_TestUtility.getAgendaItem('brief', true, briefing, null, null, topic);
        
        //Get standard parameters
        Test.setCurrentPage(new PageReference(''));
        testRoot = Utilities.getConstant_CS('CEE Outlook URL');
        testEnv = Utilities.getConstant_CS('CEE Environment');
        
        
        
        //APEX Page testing
        Test.startTest();
        ApexPages.StandardController stdItem = new ApexPages.StandardController(agenda);
        CEE_AgendaItemController agendaItemController = new CEE_AgendaItemController(stdItem);
        List<SelectOption> architecture = agendaItemController.getArchitectureOptions();
        List<SelectOption> subArch = agendaItemController.getSubArchitectureOptions();
        List<SelectOption> solution = agendaItemController.getSolutionOptions();
        
        //Save tests
        PageReference save = agendaItemController.doSave();
        Test.stopTest();
    }
    
}