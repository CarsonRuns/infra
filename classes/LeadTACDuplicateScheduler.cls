/* 
	Name    		: LeadTACDuplicateScheduler 
	Author  		: Eric Pesch (epesch)
	Release 		: 1.0
	Functionality 	: Scheduler for running TAC Duplicate de-dupe batch job
						Scheduled Job Name: Lead TAC Duplicate Delete
						Scheduled Job Property: Run at midnight PST every day
	Created			: Sep 14 2015
	
	Modification History:
	Date		Author			Change 
*/
global class LeadTACDuplicateScheduler implements Schedulable {
	private static final String TAG = '[LeadTACDuplicateScheduler] - ';
	
	/*
	 * @description Override on execute method for scheduled jobs
	 */
	global void execute(SchedulableContext sc){
		System.debug(TAG + 'Starting batch');
		Id job = Database.executeBatch(new LeadTACDuplicateBatchApex());
		System.debug(TAG + 'Batch ID - ' + job);
	}

}