/***************************************************************************************************
Name    : CEE_PresenterViewController 
Author  : Akeem Shirley
Purpose : Trigger Tests for the Account_Executive_Sponsor__c object  
Created Date: Dec 1 2014
Modification History: 
Eric Pesch - Jan 6 2015: Added Comments, cleanup                     
*****************************************************************************************************/

public class CEE_PresenterViewController {
    private final static String TAG = 'CEE_PresenterViewController';
    private final ApexPages.StandardController controller;
    private CEE__c briefing;
    public boolean downloadword{get;set;}
    public String EngagementContact{get;set;}
    public string AccountName{get;set;}
    public String briefId{get;set;}
    public List<Agenda_Item__c> lstAgendaItems { get; set; }
    public Map<String, String> attendeeMap { get; set; }
    public Map<String, String> attendeeStartMap { get; set;}
    public Map<String, String> attendeeEndMap {get; set;}
    public Map<String, String> itceStartMap { get; set;}
    public Map<String, String> itceEndMap {get; set;}
    public boolean isOBX {get; set;}
    private CEE_Utility utility;
    
    /*@Construcotr: Presenter Consolidated View Constructor*/
    public CEE_PresenterViewController(ApexPages.StandardController stdController){
        List<String> popFields = new List<String>{'Name', 'Opportunity__c', 'Primary_Account__c', 'Timezone__c'};
        this.controller = stdController;
        briefId = '';
        downloadword = false;
        if(!Test.isRunningTest()){
          this.controller.addFields(popFields);
        }
        this.briefing = (CEE__c)stdController.getRecord();
        briefId = briefing.Id;
        EngagementContact = '';
        AccountName ='';
        CEE__c ce = [SELECT Id,Engagement_Contact__r.Name,Primary_Account__r.Name FROM CEE__c WHERE Id =: briefing.Id];
        EngagementContact = ce.Engagement_Contact__r.Name;
        AccountName  = ce.Primary_Account__r.Name;
        String attendees = '';
        isOBX = false;
        integer totalAttendees = 0;
        attendeeMap = new Map<String, String>();
        attendeeStartMap = new Map<String, String>();
        attendeeEndMap = new Map<String, String>();
        itceStartMap = new Map<String, String>();
        itceEndMap = new Map<String, String>();
        Timezone tz = Timezone.getTimeZone('America/Dawson');
        lstAgendaItems = [SELECT Start_Date_Time__c, End_Date_Time__c, Name, Delivery_Method__c, Sales_Objectives__c, Selected_Rooms_Display__c FROM Agenda_Item__c ai WHERE ai.Customer_Engagements_Events__c = :briefing.id ORDER BY Start_Date_Time__c ASC];
        ID obxRecType = [SELECT Id FROM RecordType WHERE SObjectType = 'CEE__c' AND DeveloperName = 'OBX'].Id;
        CEE__c briefings = [select id,RecordTypeID from CEE__c where id =: briefing.id ]; 
        for(Agenda_Item__c a: lstAgendaItems) {
            string agendaId = a.id;
            List<CEE_Attendee__c> lstAttendees = [select Name, Title__c,(SELECT Outlook_Status__c FROM CEE_Invites__r WHERE Outlook_Status__c='Accepted') FROM CEE_Attendee__c WHERE Agenda_Item__r.id = :a.Id AND Type__c = 'Presenter'];
            totalAttendees = lstAttendees.size();
         
            if(briefings.RecordTypeID == obxRecType) {
                isOBX = true;
                attendeeStartMap.put(a.id, convertAgendaTime(a.Start_Date_Time__c));
                attendeeEndMap.put(a.id, convertAgendaTime(a.End_Date_Time__c));
            } else {
                itceStartMap.put(a.id, (CEE_Utility.convertUserTimeToUTC(a.Start_Date_Time__c, tz, briefing.Timezone__c )).format(CEE_Utility.TIME_FORMAT_ITCE)); //CEE_Utility.convertUserTimeToUTC(a.Start_Date_Time__c, tz, briefing.Timezone__c ));
                itceEndMap.put(a.id, (CEE_Utility.convertUserTimeToUTC(a.End_Date_Time__c, tz, briefing.Timezone__c )).format(CEE_Utility.TIME_FORMAT_ITCE)); //CEE_Utility.convertUserTimeToUTC(a.End_Date_Time__c,tz, briefing.Timezone__c ));
            }
            attendees = '';
            for(CEE_Attendee__c x:lstAttendees) {
                if(totalAttendees == 1) {
                   if(!x.CEE_Invites__r.isEmpty())
                    {
                        attendees = x.Name + ' - ' + x.Title__c;
                    }
                } else if(totalAttendees > 1) {
                    if(attendees.equals('')) {
                        if(!x.CEE_Invites__r.isEmpty())
                        {
                            attendees = x.Name + ' - ' + x.Title__c;
                        }
                    } else {
                        if(!x.CEE_Invites__r.isEmpty())
                        {
                            attendees = attendees + ', ' + x.Name + ' - ' + x.Title__c;
                        }
                    }
                }
                System.debug(attendees + ' in for loop');
            }
            System.debug(attendees + ' after for loop');                               
            attendeeMap.put(a.id, attendees);
        }
       
    }
    
    /*@method: getter for Agenda Items*/
    public List<Agenda_Item__c> getLstAgendaItems(){
        return lstAgendaItems;
    }
    
    /*@method: getter for Attendees*/
    public Map<String, String> getAttendeeMap() {
        return attendeeMap;
    }
    
    /*@method: getter for CEE Briefing information*/    
    public CEE__c getBriefing() {
        return briefing;
    }
    public void setBriefing(CEE__c briefing){
        this.briefing = briefing;
    }
    
    /*@method: Conversion of Agenda Item time to timezone*/
    public String convertAgendaTime(Datetime agendaTime){
        String timeZone;
        String format;
     
        format = 'M/d/yyyy h:mm a z';
        timeZone = [SELECT Primary_FSO__r.Site_Time_Zone__c FROM CEE__c WHERE id = :briefing.id].Primary_FSO__r.Site_Time_Zone__c;
    
        return agendaTime.format(format, timeZone);     
    }
    
    public void download(){
        downloadword = true;
    }
    
}