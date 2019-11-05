/************************************************************************************************************************************
Name    : QI_Job_SchedulerTest 
Author  : Eric Pesch (epesch)
Purpose : Test class for QI_Job_CleanBatch items
Created Date: 12/09/2017 
Modification History: 

*************************************************************************************************************************************/
@isTest
public class QI_Job_SchedulerTest {

    private static void insertQIJobSettings(){
        List<QIJobSettings__c> settings = new List<QIJobSettings__c>();
        QIJobSettings__c setting1 = new QIJobSettings__c();
        setting1.Name = 'PurgeJobsAfterDays';
        setting1.Value__c = '7';
        settings.add(setting1);
        
        QIJobSettings__c setting2 = new QIJobSettings__c();
        setting2.Name = 'UnlockJobsAfterMin';
        setting2.Value__c = '-5';
        settings.add(setting2);
        
        insert settings;
    }

    //Custom method to generation Quote_Integration_Job__c
    private static Quote_Integration_Job__c getQIJob(Integer min, Integer days, boolean isProcessing){
        Quote_Integration_Job__c newJob = new Quote_Integration_Job__c();
        
        newJob.Opportunity__c = 'fakeId';
        newJob.Quote__c = 123;
        newJob.Is_Processing__c = isProcessing;
        
        newJob.Published_Date__c = system.now().addMinutes(min).addDays(days);        
        newJob.LastModifiedDate = system.now().addMinutes(min).addDays(days);        
        newJob.CreatedDate = system.now().addMinutes(min).addDays(days);
        
        return newJob;
    }
    
    //TEST 1 - test scheduled reprocessing job (async)
    static testMethod void testScheduleReprocess() {
        List<Quote_Integration_Job__c> jobs = null;
        String cronExp = '0 0 0 ? * 1';
        
        //Insert custom settings
        insertQIJobSettings();
        
        //Insert sample job
        Quote_Integration_Job__c newJob = getQIJob(-30, 0, true);        
        insert newJob;
        
        //Check if jobs inserted correctly
        jobs = [SELECT Id, Is_Processing__c, CreatedDate, LastModifiedDate FROM Quote_Integration_Job__c];
        System.assertEquals(1, jobs.size());
        for(Quote_Integration_Job__c job : jobs){
            System.assertEquals(true, job.Is_Processing__c);    
        }
        
        //Begin testing
        Test.startTest();
        
        //Test the scheduler
        QI_Job_Scheduler scheduledJob = new QI_Job_Scheduler();
        String jobId = System.schedule('testQIJobReprocessApex', cronExp, scheduledJob);
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                            FROM CronTrigger WHERE id =: jobId];
        System.assertEquals(cronExp, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        
        scheduledJob.execute(null);
        Test.stopTest();
   
        //Ended test, run scheduled jobs to delete Transaction
        jobs = [SELECT Id,Is_Processing__c FROM Quote_Integration_Job__c];
        System.assertEquals(1, jobs.size());
        for(Quote_Integration_Job__c job : jobs){
            System.assertEquals(false, job.Is_Processing__c);   
        }
    }
    
    //TEST 2 - test scheduled cleaning job (async)
    static testMethod void testScheduleClean() {
        List<Quote_Integration_Job__c> jobs = null;
        String cronExp = '0 0 0 ? * 1';
        
        //Insert custom settings
        insertQIJobSettings();
        
        //Insert sample job
        Quote_Integration_Job__c oldJobTrue = getQIJob(0, -8, true);         
        insert oldJobTrue;
        Quote_Integration_Job__c oldJobFalse = getQIJob(0, -8, false);    
        oldJobFalse.Opportunity__c = 'fakeId1';
        insert oldJobFalse;
        Quote_Integration_Job__c newJobTrue = getQIJob(0, -6, true);    
        newJobTrue.Opportunity__c = 'fakeId2';
        insert newJobTrue;
        Quote_Integration_Job__c newJobFalse = getQIJob(0, -6, false);   
        newJobFalse.Opportunity__c = 'fakeId3';
        insert newJobFalse;
        
        //Check if jobs inserted correctly
        jobs = [SELECT Id, LastModifiedDate FROM Quote_Integration_Job__c];
        System.assertEquals(4, jobs.size());
        
        //Begin testing
        Test.startTest();
        
        //Test the scheduler
        QI_Job_Scheduler scheduledJob = new QI_Job_Scheduler();
        String jobId = System.schedule('testQIJobCleanApex', cronExp, scheduledJob);
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                            FROM CronTrigger WHERE id =: jobId];
        System.assertEquals(cronExp, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        
        scheduledJob.execute(null);
        Test.stopTest();
   
        //Ended test, run scheduled jobs to delete Transaction
        jobs = [SELECT Id, LastModifiedDate FROM Quote_Integration_Job__c];
        System.assertEquals(2, jobs.size());
    }
}