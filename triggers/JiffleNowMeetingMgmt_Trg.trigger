/************************************************************************************************************************************
Name    : JiffleNowMeetingMgmt_Trg 
Author  : Mukesh Srivastava
Purpose : This Class is to handle all Jiffle meeting related processing
Created Date: 4/20/2015
Modification History: 

*************************************************************************************************************************************/
trigger JiffleNowMeetingMgmt_Trg on Jiffle_Meeting_Session__c (after update) {
     JiffleNowMeetingMgmt_CLS jMM = new JiffleNowMeetingMgmt_CLS();
     jMM.JiffleMeetings(Trigger.New);
}