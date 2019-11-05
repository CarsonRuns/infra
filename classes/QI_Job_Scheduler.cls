/************************************************************************************************************************************
Name    : QI_Job_Scheduler 
Author  : Eric Pesch (epesch)
Purpose : This class is the scheduler for the Batchable cleaning jobs for the Quote Integration Jobs
Created Date: 12/09/2017
Modification History: 

*************************************************************************************************************************************/
global class QI_Job_Scheduler implements Schedulable {
	private static String TAG = '[QI_Job_Scheduler] - ';
	
	/*Schedule using the following in Developer Console
	QI_Job_Scheduler job = new QI_Job_Scheduler();
	String cron1 = '0 0 * * * ?';
	String cron2 = '0 15 * * * ?';
	String cron3 = '0 30 * * * ?';
	String cron4 = '0 45 * * * ?'; 
	
	System.schedule('QICleaningJob 00:00',cron1,job);
	System.schedule('QICleaningJob 00:15',cron2,job);
	System.schedule('QICleaningJob 00:30',cron3,job);
	System.schedule('QICleaningJob 00:45',cron4,job);
	*/
	
	global void execute(SchedulableContext ctx){
		//TransactionLogSettings__c.getInstance('PurgeAfterDays').Value__c;
		String unlockMin = QIJobSettings__c.getInstance('UnlockJobsAfterMin').Value__c;
		String cleanDays = QIJobSettings__c.getInstance('PurgeJobsAfterDays').Value__c;
		
		Datetime compDate = system.now().addMinutes(Integer.valueOf(unlockMin));
		
		//Queue reprocess job
		QI_Job_ReprocessBatch bReprocess = new QI_Job_ReprocessBatch();
		bReprocess.query = 'SELECT Id, LastModifiedDate, Is_Processing__c FROM Quote_Integration_Job__c'
						+' WHERE Is_Processing__c = true'
						+' AND LastModifiedDate  <= ' + compDate.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
		System.debug(TAG + 'Query - ' + bReprocess.query);
		ID batchId1 = Database.executeBatch(bReprocess);
		System.debug(TAG + 'Batch Process - ' + batchId1);
		
		//Queue cleaning job
		QI_Job_CleanBatch bDel = new QI_Job_CleanBatch();
		bDel.query = 'SELECT Id, LastModifiedDate FROM Quote_Integration_Job__c WHERE LastModifiedDate < LAST_N_DAYS:' 
							+ cleanDays;
		
		ID batchId2 = Database.executeBatch(bDel);
		System.debug(TAG + 'Batch Process - ' + batchId2);
	}
}