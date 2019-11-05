/************************************************************************************************************************************
Name    : BatchDeleteJobId
Author  : Bramha
Purpose : Contains logic for Deleting the FF_Batch_details__c which are in-Active and this will increase the storage capacity.
Created Date:  12/21/2017
*************************************************************************************************************************************/
global class BatchDeleteJobId implements Database.Batchable<sObject>,Database.Stateful {
   public BatchDeleteJobId() {
        
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
         //Passing FF_Batch_details__c records which are In-Active
         return Database.getQueryLocator([select Id, isActive__c from FF_Batch_details__c where isActive__c=false]);
    }

    global void execute(Database.BatchableContext BC, List<FF_Batch_details__c> batchDetails) {
        //Deleting all of the records which are received from Start Method.
        //SCAVA FIX
            if (FF_Batch_details__c.sObjectType.getDescribe().isDeletable())
               {
                    delete batchDetails;
                }
    }   

    global void finish(Database.BatchableContext BC) {
               
    }
}