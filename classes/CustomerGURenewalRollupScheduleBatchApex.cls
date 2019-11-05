/******************************************************************************
Name    : CustomerGURenewalRollupScheduleBatchApex
Author  : Narasimharao Muppalla
Purpose : Scheduler class for 
Created Date:  31/1/2019

*******************************************************************************/
global class CustomerGURenewalRollupScheduleBatchApex implements Schedulable {
    
    Public String query1 = Apex_Batch_Job__c.getInstance('OppRollupToAccount').query__c;
    Public String query2 = Apex_Batch_Job__c.getInstance('OppRollupToAccount').query1__c;
    Public String query = query1 + ' ' + query2;

    global void execute(SchedulableContext sc){         
        CustomerGURenewalRollupToAccount optyRollup= new CustomerGURenewalRollupToAccount(query);
        ID JobId = Database.executeBatch(optyRollup,2000);    
    } 
}