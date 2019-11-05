global class JabberBatchUpdateScheduler implements Schedulable
{
	string strObjectType, strQuery;
	global JabberBatchUpdateScheduler(string strObject)
	{
		strObjectType = strObject;
		if(strObjectType == 'Account')
		{
			strQuery = 'Select Id from Account where Phone != \'\' and (Jabber_Phone_Number__c = null or Jabber_Phone_Number__c = \'\') Order By LastModifiedDate DESC limit 10000 ';
		}
		else
		{
			strQuery = 'Select Id from Contact where Phone != \'\' and (Jabber_Phone_Number__c = null or Jabber_Phone_Number__c = \'\') Order By LastModifiedDate DESC limit 10000';
		}
	}
	global JabberBatchUpdateScheduler()
	{
		strObjectType = 'Contact';
		strQuery = 'Select Id from Contact where Phone != \'\' and (Jabber_Phone_Number__c = null or Jabber_Phone_Number__c = \'\') Order By LastModifiedDate DESC limit 10000';
	}
	global void execute(SchedulableContext sc)    
    {   
    	ApexClass apexClassDetails = [Select Id, Name from ApexClass 
        	where Name = 'JabberBatchUpdate'];
        
        List<AsyncApexJob> lstJobs = [Select Id, Status, ApexClassID
    		from AsyncApexJob where 
    		(Status = 'Queued' OR Status = 'Processing' OR
    		 Status = 'Preparing' OR Status = '') and ApexClassID =: apexClassDetails.Id];
    	
    	// Execution window is 4pm-11pm 7 days/week
    	// add 30 minutes as a buffer time and verify the window period
    	Datetime nextScheduleTime = datetime.now().addMinutes(30);
    	string strScheduleTime;
    	
    	if(lstJobs.size() == 0 && datetime.now().hour() >= 16 && nextScheduleTime.hour() < 23)
    	{ 
    		try
    		{
					JabberBatchUpdate jabberBatch = new JabberBatchUpdate(strQuery,strObjectType);
					database.executeBatch(jabberBatch, 2000);
    		}
    		catch(exception e)
    		{
    			system.debug('*** unable to call a batch job:' + e.getMessage());
    		}
    	}
    	
    	// Execution window is 4pm-11pm 7 days/week
    	// Schedule the batch job, if current time is in-between the window period.
		if(datetime.now().hour() >= 16 && nextScheduleTime.hour() < 23)
		{
    		strScheduleTime = '0 ' + nextScheduleTime.minute() + ' ' + 
    			nextScheduleTime.hour() + ' ' + nextScheduleTime.day() + ' '+ 
    			nextScheduleTime.month() + ' ? '+ nextScheduleTime.year();
		}
		// if window period is not started yet, schedule the batch at 4 PM of the same day.
		else if(datetime.now().hour() < 16)
		{
			strScheduleTime = '0 0 16 ' + 
    			nextScheduleTime.day() + ' '+ nextScheduleTime.month() + ' ? '+ nextScheduleTime.year();
		}
		// if window period is closed, schedule the batch job at 4 PM of the next day.
		else if(nextScheduleTime.hour() >= 23)
		{
			DateTime dtTomorrow = datetime.now().addDays(1);
			strScheduleTime = '0 0 16 ' + 
    			dtTomorrow.day() + ' '+ dtTomorrow.month() + ' ? '+ dtTomorrow.year();
		}
		system.abortJob(sc.getTriggerID());
		try
    	{
			system.schedule('Jabber Update - ' + DateTime.Now().formatLong(), strScheduleTime, new JabberBatchUpdateScheduler(strObjectType));
    	}
    	catch (exception e)
    	{
    		system.debug('*** exception while calling scheduler: '+ e.getMessage());
    	}
	    	
    }
}