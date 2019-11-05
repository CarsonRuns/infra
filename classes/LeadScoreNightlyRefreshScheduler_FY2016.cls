global with sharing class LeadScoreNightlyRefreshScheduler_FY2016 implements Schedulable 
{
    global void execute(SchedulableContext sc) 
        
    {
        ID BatchId = Database.executeBatch(new LeadScoreNightlyRefresh (), 100);} 
    	Public static void SchedulerMethod() {
        string con_exp= '0 30 23 1/1 * ? *';
        System.schedule('LeadScoreNightlyRefresh', con_exp, new LeadScoreNightlyRefreshScheduler_FY2016());
    }
}