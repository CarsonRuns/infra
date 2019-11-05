global with sharing class OptyFlagUpdateBatchScheduler_FY2017 implements Schedulable{
 global void execute(SchedulableContext sc) 
        
    {
        Oppty_OpptyWorkspace_BatchUpdate OptyFlagUpdateBatch = new Oppty_OpptyWorkspace_BatchUpdate();
        Database.executeBatch(OptyFlagUpdateBatch, 100);
        
    }
}