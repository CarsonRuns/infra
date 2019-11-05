public class TaskHandler
    implements ITrigger{
    // Constructor
    public TaskHandler()
    {
    }
 
    public void bulkBefore()
    {
        if(Trigger.isInsert){
            autoTaskCreation(Trigger.new);
        }
    }
 
    public void bulkAfter()
    {
        if(!Trigger.isDelete) {
            System.debug('NoteHandler.bulkAfter(): calling prmUtils.processPrmNotes');
            prmUtils.processPrmEventTask(Trigger.new);
            System.debug('NoteHandler.bulkAfter(): return from calling prmUtils.processPrmNotes');
        }
    }
 
    public void beforeInsert(SObject so)
    {
    }
 
    public void beforeUpdate(SObject oldSo, SObject so)
    {
    }
 
    public void beforeDelete(SObject so)
    {
    }
 
    public void afterInsert(SObject so)
    {
    }
 
    public void afterUpdate(SObject oldSo, SObject so)
    {
    }
 
    public void afterDelete(SObject so)
    {
    }
 
    public void andFinally()
    {
    }
    /*Auto Task Creation*/
    public void autoTaskCreation(List<Task> Tasks){
        Set<Id> OptyIds = new Set<Id>();
        for(Task tsk :Tasks){
            if(tsk.Subject == 'Keep Customer Warm for Deal ID ::'){
                OptyIds.add(tsk.WhatId);
            }
        }
        Map<Id,Opportunity> taskAssociatedOpptties = new Map<Id,Opportunity>([select id,DealId__c from Opportunity where Id IN:OptyIds]);
        for(Task tsk :Tasks){
            Opportunity opp =taskAssociatedOpptties.get(tsk.WhatId);
              if(opp!=null){
                tsk.Subject='Keep Customer Warm for Deal ID #'+opp.DealId__c;
                tsk.Category_Type__c='Follow Up Engagement';
                tsk.Theater__c='EMEAR';
                tsk.ActivityDate=Date.Today()+90;
              }  
            }    
        }

}