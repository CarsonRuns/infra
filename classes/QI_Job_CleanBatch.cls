/************************************************************************************************************************************
Name    : QI_Job_CleanBatch 
Author  : Eric Pesch (epesch)
Purpose : This class is used for deleting Quote Integration Jobs
Created Date: 12/09/2017
Modification History: 
* Modified By - bodurais on 04.23.2018
* Description - Added logic to fix SCAVA scan issues.
*************************************************************************************************************************************/
global class QI_Job_CleanBatch implements Database.Batchable<sObject>{
    private static String TAG = '[QI_Job_CleanBatch] - ';
    public String query;
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<sObject> scope){
        try{
            //SCAVA fix
            list<Quote_Integration_Job__c> deleteList = scope;
            if(Quote_Integration_Job__c.sObjectType.getDescribe().isDeletable()) {  
                delete deleteList;
            }
        } catch (Exception e){
            System.debug(TAG + 'Delete error - ' + e.getStackTraceString());
        }
    }
    
    global void finish(Database.BatchableContext bc){ 
        System.debug(TAG + 'Job finished');
    }
}