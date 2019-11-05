/************************************************************************************************************************************
 * @Release:Sep'2015
 * @Author: Platform Services
 * @Functionality: Implementation of Trigger factory
 * @Modification History: Initial Creation
************************************************************************************************************************************/

trigger AccountTrigger on Account  (before insert, after insert, before update,after update, before delete,after delete,after undelete){

    //Invoke trigger handle class and pass on the implementation class
    TriggerHandler.execute(AccountTriggerImpl.class);
    
}