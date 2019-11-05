@IsTest(SeeAllData=true)
private class TC_JabberControllerExt_popUp_Final{
    private static Event eventData = new Event(); 
    private static testMethod void testAllMethods(){
        JabberControllerExt_popUp_Final obj = new JabberControllerExt_popUp_Final();
        obj.insertEvent();
        obj.endButton();
        obj.updateEvent();
        obj.delEvent();
        createEvent();
        ApexPages.currentPage().getParameters().put('eventId',eventData.Id);
        obj.openEvent();
        obj.updateOpenedEvent();
        obj.delOpenedEvent();
    }
    private static void createEvent(){
        eventData.EndDateTime = null;
        eventData.StartDateTime = System.Now();
        eventData.Call_Start_Time_Hidden__c = string.valueOf(eventData.StartDateTime.getTime());
        eventData.Subject = 'Call';
        eventData.Phone_Number__c = '123456786';
        eventData.DurationInMinutes = 10;
        eventData.ActivityDateTime = eventData.StartDateTime;
        insert eventData; 
    }
}