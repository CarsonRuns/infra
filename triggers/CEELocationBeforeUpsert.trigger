/***************************************************************************************************
Name    : CEELocationBeforeUpsert 
Author  : Eric Pesch
Purpose : Trigger for pre-work for inserting a CEE_Location__c
Created Date: Dec 1 2014
Modification History: 
Eric Pesch - Jan 5 2015: Added Comments, cleanup
Sudi 01 June 2016 : Added new condition for CPOC                      
*****************************************************************************************************/

trigger CEELocationBeforeUpsert on CEE_Location__c (before insert, before update) {
    private static String TAG = 'CEELocationBeforeUpsert - ';
    CEE_Location__c[] resources = Trigger.new;
    Map<String, User> userMap = new Map<String, User>();
    Set<String> userEmails = new Set<String>();    
    
    for(CEE_Location__c resource : resources){
        //Record type assignment
        if(resource.Name.trim().toUpperCase().contains('EXPERIENCE CENTER')
                || resource.Name.trim().toUpperCase().contains('EXECUTIVE')){
            resource.Location_Type__c = 'EBC/EC';
        }
        // Added below code for CPOC location type assign.
        else if(resource.Name.trim().toUpperCase().contains('CPOC')){
                resource.Location_Type__c = 'CPOC';
        }
         else {
            resource.Location_Type__c = 'Non EBC/EC';
        }
    
        //Map User for batch lookup
        if(resource.Primary_Scheduler_Email__c != null){
            userEmails.add(resource.Primary_Scheduler_Email__c);
        }
        
        if(resource.Secondary_Scheduler_Email__c != null){
            userEmails.add(resource.Secondary_Scheduler_Email__c);
        }      
    }
    
    //Lookup Users for schedulers
    List<User> users = [select Id, Email from User where Email in : userEmails];
    for(User currUser : users){
        userMap.put(currUser.Email, currUser);
    }
    
    //Add Users to CEE Location record  
    for(CEE_Location__c resource : resources){
        if(resource.Primary_Scheduler_Email__c != null){
            if(userMap.get(resource.Primary_Scheduler_Email__c) != null){
                resource.Primary_Scheduler__c = userMap.get(resource.Primary_Scheduler_Email__c).Id;
            }
        }
        
        if(resource.Secondary_Scheduler_Email__c != null){
            if(userMap.get(resource.Secondary_Scheduler_Email__c) != null){
                resource.Secondary_Scheduler__c = userMap.get(resource.Secondary_Scheduler_Email__c).Id;
            }
        }
    }
}