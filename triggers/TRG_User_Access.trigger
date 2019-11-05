/*
This trigger controls the execution of user access provisioning logic.

#SQL Queries: 0
#DML: 0
#Author: Akeem Shirley
*/
trigger TRG_User_Access on User_Access_Requests__c (before insert, before update,after insert,after update) {
    if(!Utilities.getskipFuture()) {
        if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
           
            User_Access_Helper.newUser(Trigger.new);
        }
    }
    
    if(Trigger.isAfter)
    {
        User_Access_Helper.submitForApproval(Trigger.new[0]);
    }
}