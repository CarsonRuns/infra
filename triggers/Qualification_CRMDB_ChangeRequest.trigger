trigger Qualification_CRMDB_ChangeRequest on Qualification__c (before insert, before update, after update, after insert) {

     if(Trigger.isInsert && Trigger.isBefore){
       QualificationTriggerHandler.UpdateCRMDBIntegrationFields(Trigger.new);
     }

    if(Trigger.isUpdate && Trigger.isafter){
       QualificationTriggerHandler.ChangeRequestFieldUpdate(Trigger.new,Trigger.oldMap);
    }
}