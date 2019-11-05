/**************************************************
Name    : NGCC_Lead_Management_Trg 
Author  : Mukesh Srivastava
Purpose : This trigger will fire for all the below lead related fucntionalities.
            1. Map Cisco Contact Manager based on Contact Center mapping. 
               It helps for routing to lead to CCM for approval 
            2. Lead ReQualification Process - User Story  - Sprint 5
               Based on the rejection reason the lead will be updated with the owner 
            3. Update Campaign Members
Created Date: 1/16/2014
Modification History: 
    Dan Pisciottano (dpisciot) : 10/8/2014
        Added method call after insert and update to update the Lead Qualifier fields based on the
        LastModifiedById field.
                      
*****************************************************/

trigger NGCC_Lead_Management_Trg on Lead (before update,before insert,after insert,after update) {

    if(Trigger.isBefore && Trigger.isupdate) {
        NGCC_Lead_Management_Cls.NGCC_Updated_Lead_Additional_Update(Trigger.New,Trigger.oldMap);      
    }   
        
    if(Trigger.isBefore && Trigger.isInsert) {
        NGCC_Lead_Management_Cls.NGCC_New_Lead_Additional_Update(Trigger.New,Trigger.newMap);
    }
    
    if(Trigger.isAfter && Trigger.isInsert) {
        NGCC_After_Lead_Management_Cls.NGCC_Lead_Campaign_Association(Trigger.New,Null);
    }
    
    if(Trigger.isAfter && Trigger.isUpdate) {
        NGCC_After_Lead_Management_Cls.NGCC_Lead_Campaign_Association(Trigger.New,Trigger.oldMap);
    }
}