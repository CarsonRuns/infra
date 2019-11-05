trigger AssignedPartnerTrigger on Assigned_Partner__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
    //SCP_triggerFlag__c flag = SCP_triggerFlag__c.getInstance();
    //if(flag != null && flag.Assigned_Partner__c) {
        TriggerFactory.createAndExecuteHandler(AssignedPartnerHandler.class);
    //}
}