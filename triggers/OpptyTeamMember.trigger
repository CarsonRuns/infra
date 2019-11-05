/**
* @release - MAY Q4FY14
* @author - majanard 
* @date - 09-May-2014
* @description  - This trigger is used to for duplicate Security Contact check & updating the Oportunity based on user role mapping.
* Developed for Work Request - WR-00626.
*/ 


trigger OpptyTeamMember on OpportunityTeamMember (before insert, before update, after insert, after update, after delete) {
        
    if(Trigger.isAfter && Trigger.isInsert) {
        Oppty_SecurityContact optTeamInsert = new Oppty_SecurityContact();
        if(optTeamInsert.runOnce()){
            
            optTeamInsert.SecurityRoleDuplicateCheck_Insert(Trigger.new);
        }
    }
    
    if(Trigger.isAfter && Trigger.isUpdate) {
        Oppty_SecurityContact optTeamUpdate = new Oppty_SecurityContact();
        if(optTeamUpdate.runOnce()){
            optTeamUpdate.SecurityRoleDuplicateCheck_Update(Trigger.new);
            optTeamUpdate.SecurityRoleOpptyUpdate_Clear(Trigger.new, Trigger.old);
        }
    }
    
    if(Trigger.isDelete) {
        Oppty_SecurityContact optTeamDelete = new Oppty_SecurityContact();
        optTeamDelete.SecurityRoleOppty_Delete(Trigger.old);
    }
}