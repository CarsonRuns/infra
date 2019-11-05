/***************************************************************************************************
Name    : CEEBriefingPMBeforeUpsert 
Author  : Ameet Singh
Purpose : Trigger for adding a Briefing PM to an object  
Created Date: Dec 1 2014
Modification History: 
Eric Pesch - Jan 5 2015: Added Comments, cleanup                     
*****************************************************************************************************/

trigger CEEBriefingPMBeforeUpsert on Briefing_PM__c(before insert, before update) {
	private final String TAG = 'CEEBriefingPMBeforeUpsert - ';
	Briefing_PM__c[] resources = Trigger.new;
	Map<String, User> userMap = new Map<String, User>();
	Set<String> userEmails = new Set<String>();    

	for(Briefing_PM__c resource : resources){

		//Map User for batch lookup
		if(resource.Primary_Scheduler_Email__c != null){
			userEmails.add(resource.Primary_Scheduler_Email__c);
		}

		if(resource.Primary_PM_Email__c != null){
			userEmails.add(resource.Primary_PM_Email__c);
		}

		if(resource.Secondary_PM_Email__c != null){
			userEmails.add(resource.Secondary_PM_Email__c);
		}      
	}

	//Lookup Users for schedulers and PMs
	List<User> users = [select Id, Email from User where Email in : userEmails];
	for(User currUser : users){
		userMap.put(currUser.Email, currUser);
	}

	//Add Users to CEE Location record  
	for(Briefing_PM__c resource : resources){
		if(resource.Primary_Scheduler_Email__c != null){
			if(userMap.get(resource.Primary_Scheduler_Email__c) != null){
				resource.Primary_Scheduler__c = userMap.get(resource.Primary_Scheduler_Email__c).Id;
			}
		}

		if(resource.Primary_PM_Email__c != null){
			if(userMap.get(resource.Primary_PM_Email__c) != null){
				resource.Primary_PM__c = userMap.get(resource.Primary_PM_Email__c).Id;
			}
		}

		if(resource.Secondary_PM_Email__c != null){
			if(userMap.get(resource.Secondary_PM_Email__c) != null){
				resource.Secondary_PM__c = userMap.get(resource.Secondary_PM_Email__c).Id;
			}
		}
	}
}