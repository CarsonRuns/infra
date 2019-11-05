/************************************************************************************************************
Name    : CPOC_RoomTrigger 
Author  : Abinash Das
Purpose : This is a Trigger for CPOC_Room__c SObject.This is redirecting to CPOC_RoomTrigger class to process all requests.
Created Date: 8/4/2016
Modification History: 

*************************************************************************************************************/

trigger CPOC_RoomTrigger on CPOC_Room__c (before insert, after insert, before update,after update, before delete,after delete,after undelete){

    //Invoke trigger handle class and pass on the implementation class
    TriggerHandler.execute(CPOC_RoomTriggerImpl.class);
    
}