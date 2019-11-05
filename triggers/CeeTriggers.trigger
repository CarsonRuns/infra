/************************************************************************************************************
Name    : CeeTriggers 
Author  : Jay Dash
Purpose : This is a Trigger for CEE_c SObject.This is redirecting to ceeHandler class to process all requests.
Created Date: 7/10/2015
Modification History: 

*************************************************************************************************************/

trigger CeeTriggers on CEE__c(after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
    TriggerFactory.createAndExecuteHandler(CeeHandler.class);
}