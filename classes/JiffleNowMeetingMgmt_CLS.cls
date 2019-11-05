/************************************************************************************************************************************
Name    : JiffleNowMeetingMgmt_CLS 
Author  : Mukesh Srivastava
Purpose : This Class is to handle all Jiffle Meetings Releated processing required scoped by Trigger
Created Date: 4/15/2015
Modification History: 

*************************************************************************************************************************************/
public class JiffleNowMeetingMgmt_CLS {
    //@ Method: To Accept all newly created meeting and process as per needed
     public void JiffleMeetings(List < Jiffle_Meeting_Session__c > lstJMeetings) {
         Set<Id> setMeetings = new Set<Id>();
         
         for (Jiffle_Meeting_Session__c jMtgObj: lstJMeetings) {
             if(jMtgObj.Request_Status__c == 'Cancelled' || jMtgObj.Request_Status__c == 'Deleted'){
                 setMeetings.add(jMtgObj.Id);
             }
         }
         
         if(!setMeetings.isEmpty()){
             JiffleMeetingsAttendeeUpdate(setMeetings);
         }
     } 
     
     public void JiffleMeetingsAttendeeUpdate (Set<Id> setCDMeetings){
         List<Jiffle_Attendee_Invitee__c> lstJSAI = [Select Id,Reporting_Meeting_Status__c from Jiffle_Attendee_Invitee__c Where FirstAttendeeFlag__c = TRUE AND Jiffle_Session_Meeting__c IN :setCDMeetings]; 
         for(Jiffle_Attendee_Invitee__c jsObj: lstJSAI ){
             jsObj.Reporting_Meeting_Status__c  = 'Cancelled/Deleted';             
         }  
              
         Database.saveResult[] dbSaveResult = Database.Update(lstJSAI ,false);
     }   
}