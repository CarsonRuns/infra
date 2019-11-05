/**
* @release - Q1FY15
* @description  - Scheduler to run the P360 daily email notificaiton job. 
* @param - no param
* @return - void
*/ 

global class P360EmailNotificationScheduler implements Schedulable{
    global void execute(SchedulableContext SC) {
        EmailNotification_Batch ENB = new EmailNotification_Batch();
        Database.executeBatch(ENB,5);
   }
}