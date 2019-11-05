/************************************************************************************************************************************
Name    : JiffleNowReportingBatch_Schedular
Author  : Mukesh Srivastava
Purpose : Schedulable class for Executing JiffleNowReporting_Batchable 
Created Date: 5/25/2015
Modification History: 

*************************************************************************************************************************************/
global class  JiffleNowReportingBatch_Schedular implements Schedulable {
    global void execute(SchedulableContext SC) {
        JiffleNowReporting_Batchable jfBatch = new JiffleNowReporting_Batchable();
        Database.executeBatch(jfBatch,50); 
    }
}