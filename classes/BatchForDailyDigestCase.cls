global class BatchForDailyDigestCase implements schedulable
{
    global void execute(SchedulableContext sc)
    {
      Database.executeBatch(new BatchForDailyDigest('Case'),200);
    }
}