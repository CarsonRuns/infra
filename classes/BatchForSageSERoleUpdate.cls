global class BatchForSageSERoleUpdate implements schedulable
{
    global void execute(SchedulableContext sc)
    {
        System.Queueable job = new NotificationHandler('User');
        System.enqueueJob(job);
    }
}