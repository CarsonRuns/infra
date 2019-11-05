/**************************************************
Name    : NGCC_Campaign_Management_Trg
Author  :  Ramzil Cleopas
Purpose : Handle Campaign Related Trigger processing
Created Date: 
Modification History: Mukesh, Cleaned up the code
					: Nirup, Updated the Trigger to fire on Update. this will assign default call script on Campaign on update as well 2/16/16
*****************************************************/ 

trigger NGCC_Campaign_Management_Trg on Campaign (after update,before insert, before update) {

    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        //system.debug('Check1');
        NGCC_Campaign_Management_Cls.NGCC_Campaign_Management_Before(Trigger.New);      
    }   
        
    if(Trigger.isAfter && Trigger.isUpdate) {
        NGCC_Campaign_Management_Cls.NGCC_Campaign_Management_After(Trigger.New,Trigger.OldMap);
    }
        
}