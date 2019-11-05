/*********************************************************************************************************************************
Name    : NGCC_Q_A_Bank_English_Translation_Trg 
Author  : Mukesh Srivastava
Purpose : Invoke on whenever a new Answer and Questions are created by default create an English translation record in Q&A Translation object
Created Date:  3/27/2014 
Modification History: 
                      
**********************************************************************************************************************************/

trigger NGCC_Q_A_Bank_English_Translation_Trg on CC_Master_Question_Answer_Bank__c (after update,after insert) {
    if(Trigger.isAfter) {
        NGCC_Q_A_Bank_English_Trans_Trg_Cls.NGCC_Q_A_Bank_English_Translation(Trigger.newMap);
    }
}