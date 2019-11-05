/************************************************************************************************************************************
Name    : ScheduleOpptyShareSOneBatchApex  
Author  : Bramha
Purpose : Contains logic to execute a batch which is for sharing the "Phase Opportunity Line Items" to service one
*************************************************************************************************************************************/
global class ScheduleOpptyShareSOneBatchApex  implements Schedulable{  

  public ScheduleOpptyShareSOneBatchApex(){  
  }
      
  global void execute(SchedulableContext ctx){     
      // Executing the batch class, this batch will share the "Phase Opportunity" LineItems to ServiceOne.
      OpptyShareSOneBatchApex  optW = new OpptyShareSOneBatchApex();
      database.executeBatch(optW);
  }
  
}