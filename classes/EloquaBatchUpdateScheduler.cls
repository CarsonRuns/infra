/************************************************************************************************************************************
Name    : EloquaBatchUpdateScheduler 
Author  : Mukesh Srivastava
Purpose : Schedulable class for Executing EloquaBatchScheduledUpdates
Created Date: 3/18/2015
Modification History: 

*************************************************************************************************************************************/
global class  EloquaBatchUpdateScheduler implements Schedulable {
    global void execute(SchedulableContext SC) {
        EloquaBatchScheduledUpdates elqBatch = new EloquaBatchScheduledUpdates();
        Database.executeBatch(elqBatch,50); 
    }
}