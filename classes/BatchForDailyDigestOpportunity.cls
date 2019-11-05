global class BatchForDailyDigestOpportunity implements schedulable
{
    global void execute(SchedulableContext sc)
    {
      Database.executeBatch(new BatchForDailyDigest('Opportunity'),200);
    }
}