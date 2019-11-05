/************************************************************************************************************************************
Name    : ScheduleASWorkspaceShareBatchApex
Author  : Bramha
Purpose : Contains logic to execute a batch which is for sharing the "AS Workspcae" to service one
*************************************************************************************************************************************/
global class ScheduleASWorkspaceShareBatchApex implements Schedulable{  

  public ScheduleASWorkspaceShareBatchApex(){  
  }
      
  global void execute(SchedulableContext ctx){     
      // Executing the batch class, this batch will share the "Phase Opportunity" LineItems to ServiceOne.
      ASWorkspaceSharingBatch asW = new ASWorkspaceSharingBatch();
      database.executeBatch(asW);
  }
  
}