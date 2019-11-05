/************************************************************************************************************
Name    : CPOC_PersonnelTrigger 
Author  : Abinash Das
Purpose : This is a Trigger for CPOC_Personnel__c SObject.This is redirecting to CPOC_PersonnelTriggerImpl class to process all requests.
Created Date: 7/4/2016
Modification History: 

*************************************************************************************************************/

trigger CPOC_PersonnelTrigger on CPOC_Personnel__c (before insert, after insert, before update,after update, before delete,after delete,after undelete){

    //Invoke trigger handle class and pass on the implementation class
    TriggerHandler.execute(CPOC_PersonnelTriggerImpl.class);
    
}