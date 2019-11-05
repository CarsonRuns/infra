/************************************************************************************************************************************
Name    : ScheduleOpptyShareSOneBatchApex  
Author  : Bramha
Purpose : Contains logic to execute a batch which is for sharing the "Engage Service Resource" to service one
*************************************************************************************************************************************/
global with sharing class ScheduleCaseShareSOneBatchApex  implements Schedulable{  

  public ScheduleCaseShareSOneBatchApex(){  
  }
      
  global void execute(SchedulableContext ctx){     
      // Executing the batch class, this batch will share the "Engage Service Resource" LineItems to ServiceOne.
      EngageCaseSharingBatch  engCase = new EngageCaseSharingBatch();
      database.executeBatch(engCase);
  }
  
}