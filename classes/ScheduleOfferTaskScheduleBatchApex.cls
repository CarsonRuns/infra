/************************************************************************************************************************************
Name    : ScheduleOfferTaskScheduleBatchApex
Author  : C360 Dev team
Purpose : Contains logic to Implement ScheduleOfferTask batch apex Scheduler
Date    : 25/01/2019
Change History : none
*************************************************************************************************************************************/

global class ScheduleOfferTaskScheduleBatchApex implements Schedulable {
Public String query = Apex_Batch_Job__c.getInstance('ScheduleOfferTask').query__c;
global void execute(SchedulableContext sc)
     {         
        ScheduleOfferTask load = new ScheduleOfferTask(query);
        ID JobId = Database.executeBatch(load,100);  
     }
}