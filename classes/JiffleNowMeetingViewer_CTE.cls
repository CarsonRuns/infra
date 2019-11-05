/************************************************************************************************************************************
Name    : JiffleNowMeetingViewer_CTE
Author  : Mukesh Srivastava
Purpose : This class is a controller extension for viewing meetings listing
           
Created Date: 4/15/2015
Modification History: 

*************************************************************************************************************************************/
public with sharing class JiffleNowMeetingViewer_CTE {
    public List < Jiffle_Attendee_Invitee__c > lstAttMeetingSession {get;set;}
    public ApexPages.StandardSetController jiffleMySession {get;set;}
    public Integer setSize {get;set;}
    Private final Jiffle_Event__c jiffleEvent;
    public Integer NumberOfRecord {get;set;}

    //@ Constructor to process all the parameter from different scenarios
    public JiffleNowMeetingViewer_CTE(ApexPages.StandardController controller) {
        
        this.jiffleEvent = (Jiffle_Event__c) controller.getRecord();
        setSize = 5;
        viewMyMeeting();
    }


    //@ Method Get the list of meetings/sessions scheduled by logged in users  
    public void viewMyMeeting() {
        lstAttMeetingSession = new List < Jiffle_Attendee_Invitee__c > ();
        Set < String > setUniqueId = new Set < String > ();
        NumberOfRecord = 0;
        for (Jiffle_Attendee_Invitee__c jAIObj: [Select Customer_Engagements_Events__c, Jiffle_Session_Meeting__c, Event__c, Meeting_Host__c,
                Account__c, Opportunity__c, Meeting_Objective__c, Jiffle_Session_Meeting__r.End_Date_Time__c,
                Jiffle_Session_Meeting__r.Name, Jiffle_Session_Meeting__r.LastModifiedDate,Jiffle_Session_Meeting__r.Jiffle_Meeting_Location__c,
                Jiffle_Session_Meeting__r.Meeting_Type__c, Jiffle_Session_Meeting__r.Total_Number_Attendees__c,Jiffle_Session_Meeting__r.Request_Status__c,
                Jiffle_Session_Meeting__r.Start_Date_Time__c, Jiffle_Session_Meeting__r.Jiffle_Agenda_Item__c,
                Requestor_Email__c, UniqueCombination__c from Jiffle_Attendee_Invitee__c
                WHERE Requestor_Email__c =: UserInfo.getUserEmail() AND Customer_Engagements_Events__r.Jiffle_Event__c = : jiffleEvent.Id Order by Jiffle_Session_Meeting__r.LastModifiedDate DESC
                    ]) {
            if (!setUniqueId.contains(jAIObj.UniqueCombination__c)) {
                setUniqueId.add(jAIObj.UniqueCombination__c);
                lstAttMeetingSession.add(jAIObj);
                NumberOfRecord = NumberOfRecord +1;
            }
        }
        jiffleMySession = new ApexPages.StandardSetController(lstAttMeetingSession);
    }

    public List < Jiffle_Attendee_Invitee__c > getSessions() {
        jiffleMySession.setPageSize(setSize);
        return (List < Jiffle_Attendee_Invitee__c > ) jiffleMySession.getRecords();
    }
   
}