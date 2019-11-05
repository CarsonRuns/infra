/************************************************************************************************************************************
Name    : JiffleNowWeeklyEmailBatch_Schedular 
Author  : Mukesh Srivastava
Purpose : Schedulable class for Executing JiffleNowWeeklyConfirmation_Batchable
Created Date: 5/25/2015
Modification History: 

*************************************************************************************************************************************/
global class JiffleNowWeeklyEmailBatch_Schedular implements Schedulable {
    global void execute(SchedulableContext SC) {
        JiffleNowWeeklyConfirmation_Batchable jfEmailBatch = new JiffleNowWeeklyConfirmation_Batchable();
        Database.executeBatch(jfEmailBatch ,50); 
    }
}