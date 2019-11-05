/***************************************************************************************************
Name    : CEE_PreBriefingController 
Author  : Akeem Shirley
Purpose : Controller for outputting Pre-Briefing information
Created Date: Dec 1 2014
Modification History: 
Eric Pesch - Jan 5 2015: Minor commenting and cleanup                     
*****************************************************************************************************/

public class CEE_PreBriefingController  { 
    //Default controller variables
    private final static String TAG = 'CEE_PreBriefingController';

    //Controller variables
    private final ApexPages.StandardController controller;
    private CEE__c briefing;
    private Opportunity opty;
    
    //List containers
    private List<Agenda_Item__c> lstAgendaItems;
    private List<CEE_Attendee__c> lstPrevExecs;
    public List<Agenda_Item__c> lstAgendaItems1 { get; set; }
    private String pastBriefings; 
    public Map<String, String> attendeeMap { get; set; }
    public Map<String, String> attendeeStartMap { get; set;}
    public Map<String, String> attendeeEndMap {get; set;}
    public Map<String, String> itceStartMap { get; set;}
    public Map<String, String> itceEndMap {get; set;}
    public boolean isOBX {get; set;}
    public CEE_Utility utility;

    //Display information 
    public String lstExecs{get; set;}
    public String relReqs{get; set;}
    public boolean canAccess{get; set;}
    public String competitors{get; set;}
    String[] comps{get; set;}

    /*@Constructor: Controller initialization*/
    public CEE_PreBriefingController(ApexPages.StandardController stdController){
        List<String> popFields = new List<String>{'Name', 'Opportunity__c', 'Primary_Account__c','Timezone__c'};
        this.controller = stdController;
        if(!Test.isRunningTest()){
          this.controller.addFields(popFields);
        }
        this.briefing = (CEE__c)stdController.getRecord();
        relReqs = '';
        competitors = '';
        lstExecs = '';
        Set<String> permissions = new Set<String>();
        // Newly Added Start_
        String attendees = '';
        isOBX = false;
        integer totalAttendees = 0;
        attendeeMap = new Map<String, String>();
        attendeeStartMap = new Map<String, String>();
        attendeeEndMap = new Map<String, String>();
        itceStartMap = new Map<String, String>();
        itceEndMap = new Map<String, String>();
        Timezone tz = Timezone.getTimeZone('America/Dawson');
        lstAgendaItems1 = [SELECT Start_Date_Time__c, End_Date_Time__c, Name, Delivery_Method__c, Sales_Objectives__c, Selected_Rooms_Display__c FROM Agenda_Item__c ai WHERE ai.Customer_Engagements_Events__c = :briefing.id ORDER BY Start_Date_Time__c ASC];
        ID obxRecType = [SELECT Id FROM RecordType WHERE SObjectType = 'CEE__c' AND DeveloperName = 'OBX'].Id;
        CEE__c briefings = [select id,RecordTypeID from CEE__c where id =: briefing.id ]; 
        
        for(Agenda_Item__c a: lstAgendaItems1) {
            string agendaId = a.id;
            List<CEE_Attendee__c> lstAttendees = [select Name, Title__c,(SELECT Outlook_Status__c FROM CEE_Invites__r WHERE Outlook_Status__c='Accepted' ) FROM CEE_Attendee__c WHERE Agenda_Item__r.id = :agendaId AND Type__c = 'Presenter'];
            totalAttendees = lstAttendees.size();
            
            if(briefings.RecordTypeID == obxRecType) {
                isOBX = true;
                attendeeStartMap.put(a.id, convertAgendaTime(a.Start_Date_Time__c));
                attendeeEndMap.put(a.id, convertAgendaTime(a.End_Date_Time__c));
            } else {
                System.debug('Briefing Timezone ' + briefing.Timezone__c);
                System.debug('Timezone ' + tz);
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
        System.debug(attendeeStartMap);
        System.debug(attendeeEndMap);
        // Newly Added End
      
        //User permission determination
        List<PermissionSetAssignment> lstUserPermissions = [select PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId =:UserInfo.getUserId()];
        for(PermissionSetAssignment p : lstUserPermissions) {
            permissions.add(p.permissionSetId);
        }
        
        //Access flags
        if(permissions.contains('0PSQ00000008eHX')) {
            canAccess = true;
        } else if (permissions.contains('0PSQ00000008ewV')) {
            canAccess = true;
        } else {
            canAccess = false;
        }
        
        //Retrieve related Agenda Items
        lstAgendaItems = [select name, Topic__r.name, Start_Date_Time__c, End_Date_Time__c FROM Agenda_Item__c a WHERE a.Customer_Engagements_Events__c = :briefing.id 
                          ORDER BY Start_Date_Time__c ASC];

        //Previous Engagements
        try{
            List<CEE__c> prevEng = new List<CEE__c>();
            for (CEE__c req : [select c.name from CEE__c c where c.Primary_Account__c = :briefing.Primary_Account__c AND c.id != :briefing.id]) {
                //CEE__c oldReq = req.clone(true);
                prevEng.add(req);
            }
            for (Integer i = 0; i < prevEng.size() - 1; i++) {
                relReqs += (String)prevEng.get(i).name + ', ';
            }
            relReqs += (String)prevEng.get(prevEng.size()-1).name;
        } catch (Exception e) {
            System.debug(e.getStackTraceString());
        }

        pastBriefings = '(' + relReqs + ')';        

        //Previous Executives       
        lstPrevExecs = [select Name, Type__c FROM CEE_Attendee__c WHERE Customer_Engagement_Events__c IN (select c.id from CEE__c c where c.Primary_Account__c = :briefing.Primary_Account__c) AND Type__c = 'Cisco'];  
        Set<String> execNames = new Set<String>();

        for(CEE_Attendee__c a : lstPrevExecs)
        {
            execNames.add(a.Name);
        }

        for(String s : execNames)
        {
            lstExecs += (lstExecs==''?'':', ')+s;
        }        

        //Retrieve Opportunity details 
        try{
            this.opty = [select Competitors__c from Opportunity o where o.id =: briefing.Opportunity__c ];
            //Formatting Competitors Picklist
            if(opty.Competitors__c != null){
                comps = opty.Competitors__c.split(';');
            }
            for (Integer i = 0; i < comps.size() - 1; i++) {
                competitors += comps[i] + ', ';
            }  
            competitors += comps[(comps.size()-1)];   
        } catch (Exception e) {
            System.debug(e.getStackTraceString());
        }
    }
    
    /*@method: get agenda items listing*/
    public List<Agenda_Item__c> getLstAgendaItems() {
        return lstAgendaItems;
    }

    /*@method: getter/setter for CEE Briefing*/
    public CEE__c getBriefing() {
        return this.briefing;
    }
    public void setBriefing(CEE__c briefing) {
        this.briefing = briefing;
    }
    
    /*@method: getter for Attendees*/
    public Map<String, String> getAttendeeMap() {
        return attendeeMap;
    }
    
    /*@method: Conversion of Agenda Item time to timezone*/
    public String convertAgendaTime(Datetime agendaTime){
        String timeZone;
        String format;
     
        format = 'M/d/yyyy h:mm a ';
        timeZone = [SELECT Primary_FSO__r.Site_Time_Zone__c FROM CEE__c WHERE id = :briefing.id].Primary_FSO__r.Site_Time_Zone__c ;
    
        return agendaTime.format(format, timeZone);     
    }
    

}