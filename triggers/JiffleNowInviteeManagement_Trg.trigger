/************************************************************************************************************************************
Name    : JiffleInviteeManagement_Trg 
Author  : Mukesh Srivastava
Purpose : This Class is to handle all Jiffle Invitee related processing
Created Date: 4/20/2015
Modification History: 

*************************************************************************************************************************************/
trigger JiffleNowInviteeManagement_Trg on Jiffle_Attendee_Invitee__c (before insert) {
    JiffleNowInviteeManagement_cls jIM = new JiffleNowInviteeManagement_cls();
    jIM.JiffleInviteeManagement(Trigger.New);
}