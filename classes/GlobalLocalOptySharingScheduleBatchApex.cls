/******************************************************************************
Name    : GlobalLocalOptySharingScheduleBatchApex 
Author  : Narasimharao Muppalla
Purpose : Scheduler class for Global local opportunity sharing batch apex
Created Date:  11/29/2016

*******************************************************************************/
global class GlobalLocalOptySharingScheduleBatchApex implements Schedulable {

    Public String query = Apex_Batch_Job__c.getInstance('GlobalLocalOptySharing').query__c;

    global void execute(SchedulableContext sc){         
        GlobalLocalOptySharingBatchApex globalLocalOptys = new GlobalLocalOptySharingBatchApex(query);
        ID JobId = Database.executeBatch(globalLocalOptys,200);  
    } 
    
}