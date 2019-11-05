global class OpptyOwnerScheduleBatchApex implements Schedulable {

Public String query = Apex_Batch_Job__c.getInstance('OpptyOwnerSync').query__c;

global void execute(SchedulableContext sc)
     {         
        OpptyOwnerSyncBatchApex load = new OpptyOwnerSyncBatchApex(query);
        ID JobId = Database.executeBatch(load,200);  
     }
     


}