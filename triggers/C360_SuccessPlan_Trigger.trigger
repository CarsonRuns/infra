/************************************************************************************************************************************
Name    : C360_SuccessPlan_Trigger
Author  : C360 Dev team
Purpose : Trigger for Success Plan object
Date    : 22/05/2019
Change History : None
*************************************************************************************************************************************/
trigger C360_SuccessPlan_Trigger on Success_Plan__c (before insert,before update) {
    
    // Trigger to check for duplicate Name and Active field on Success Plan object
  
    C360_SuccessPlan_Trigger_Handler.preProcess();  
    
    if(Trigger.isInsert){
        if(Trigger.isBefore)
            C360_SuccessPlan_Trigger_Handler.processBeforeInsert();
    }
    if(Trigger.isUpdate){
        if(Trigger.isBefore)
            C360_SuccessPlan_Trigger_Handler.processBeforeUpdate();
    }
    
    C360_SuccessPlan_Trigger_Handler.postProcess(); 
    
}