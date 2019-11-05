/*********************************************************************************************************************************
Name    : NGCC_CallScript_Update_Trg
Author  : Mukesh Srivastava
Purpose : Invoke on Call Script activation and process the Call Script Q&A
Created Date:  3/27/2014 
Modification History: 
                      
**********************************************************************************************************************************/
trigger NGCC_CallScript_Update_Trg on CC_Call_Script__c (before update) {
    if(Trigger.isBefore && Trigger.isUpdate) {
        NGCC_CallScript_Update_Trg_Cls.NGCC_CallScript_Update(Trigger.New);
    }
}