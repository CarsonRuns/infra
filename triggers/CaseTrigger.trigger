/************************************************************************************************************************************
Name    : CaseTrigger
Author  : Sourabha
Purpose : Consolidated triggers on case
Created Date:  7/6/2015
Modification History: Initial Creation.

*************************************************************************************************************************************/
trigger CaseTrigger on Case  (before insert,after insert, before update,after update, before delete,after delete,after undelete){

    //Invoke trigger handle class and pass on the implementation class
    TriggerHandler.execute(CaseTriggerImpl.class);
    
}