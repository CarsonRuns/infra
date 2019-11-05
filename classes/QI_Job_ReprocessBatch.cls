/************************************************************************************************************************************
Name    : QI_Job_ReprocessBatch 
Author  : Eric Pesch (epesch)
Purpose : This class is used for unlocking Quote Integration Jobs
Created Date: 12/09/2017
Modification History: 
* Modified By - bodurais on 04.23.2018
* Description - Added logic to fix SCAVA scan issues.
*************************************************************************************************************************************/
global class QI_Job_ReprocessBatch implements Database.Batchable<sObject>{
    private static String TAG = '[QI_Job_ReprocessBatch] - ';
    public String query;
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<sObject> scope){
        List<Quote_Integration_Job__c> jobUpdate = new List<Quote_Integration_Job__c>();
        System.debug(TAG + 'Jobs found - ' + scope.size());
        try{
            for(sObject sobj : scope){
                Quote_Integration_Job__c job = (Quote_Integration_Job__c) sobj;
                //SCAVA fix
                if (Schema.sObjectType.Quote_Integration_Job__c.fields.Is_Processing__c.isUpdateable()){
                    job.Is_Processing__c = false;
                }
                jobUpdate.add(job);
            }
            update jobUpdate;
        } catch (Exception e){
            System.debug(TAG + 'Update error - ' + e.getStackTraceString());
        }
    }
    
    global void finish(Database.BatchableContext bc){ 
        System.debug(TAG + 'Job finished');
    }
}