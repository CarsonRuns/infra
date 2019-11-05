trigger CRMDBContactTrigger on CRMDB_Contact__c (after insert, after update) {
if(Trigger.isInsert){
        if( Trigger.isafter){
        CRMDBContactTriggerHandler.ParentFieldUpdate(Trigger.New);
        }
    }
   if(Trigger.isUpdate && Trigger.isAfter){
        CRMDBContactTriggerHandler.updateContacts(Trigger.New,Trigger.old);
    }

    
}