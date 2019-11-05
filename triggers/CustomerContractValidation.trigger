trigger CustomerContractValidation on CRMDB__c (before insert, before update, after update, after insert) 
{
    
    if(Trigger.isUpdate && Trigger.isbefore){
         CRMDB_Helper.childCapFieldsUpdateValidation(Trigger.new,Trigger.old);
         //CRMDB_Helper.totalandAnnualContractValidation(Trigger.new,Trigger.oldMap);
         CRMDB_Helper.totalandAnnualContractUpdate(Trigger.oldmap,Trigger.new);
     }
     
    if(Trigger.isUpdate && Trigger.isafter){
        CRMDB_Helper.capFieldsUpdate(Trigger.new,Trigger.old);
        CRMDB_Helper.qualificationUpdate(Trigger.oldmap,Trigger.new);
    }
   
}