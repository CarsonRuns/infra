/************************************************************************************************************************************
Name    : OfferKanban
Author  : C360 Dev team
Purpose : Contains logic to execute OfferKanban Component
Date    : 24/01/2019
Change History : none
*************************************************************************************************************************************/
public class OfferKanban {
    //Get Activity Tasks
    @AuraEnabled
    public static Boolean userAccessOffer(Id recordId){
        UserRecordAccess ua = [SELECT HasEditAccess, RecordId FROM UserRecordAccess WHERE RecordId =: recordId AND UserId =: userInfo.getUserID()];
        return ua.HasEditAccess;
        
    }
    //Get Activity Tasks
    @AuraEnabled
    public static List<Task> activities(Id OfferIds,String Stage){
        List<Task> fetchofferTasks = [SELECT Id,Task_Name__c,Task_Stage__c ,Description,Task_Type__c,DateCompleted__c 
                                               FROM Task 
                                               where WhatId =:OfferIds AND Task_Stage__c=:Stage and Task_Type__c='ACTIVITIES'];
        return fetchofferTasks;
    }
    
    //Get Exit Criteria Tasks
     @AuraEnabled
     public static List<Task> exitCriteria(Id OfferIds,String Stage){
        List<Task> fetchofferTasks2 = [SELECT Id,Task_Name__c,Task_Stage__c ,Description,Task_Type__c,DateCompleted__c 
                                                FROM Task 
                                                where WhatId =:OfferIds AND Task_Stage__c=:Stage and Task_Type__c='EXIT CRITERIA'];
        return fetchofferTasks2;
     }
    //getActivity
    @AuraEnabled
    public Static String getActivity(String activityId){
        Task fetchofferTasks = [SELECT Id,Task_Name__c,Task_Stage__c,Description,Task_Type__c,DateCompleted__c 
                                         FROM Task 
                                         where id=:activityId];
        return json.serialize(fetchofferTasks);
    }
    //Save Completion Date and Additional Notes
    @AuraEnabled
    public static String saveActivity(String activityId,String completionDate,String additionalNotes){
        try{
            Task updateofferTask =new Task();
            if(!string.isEmpty(completionDate)){                   
                updateofferTask.DateCompleted__c = Date.valueOf(completionDate);}
            else{
                updateofferTask.DateCompleted__c = null;
            }
            updateofferTask.Description = additionalNotes;
            updateofferTask.Id = activityId;
            update updateofferTask;
            
            return json.serialize(updateofferTask);
        }catch(Exception e){
            throw new auraHandledException('Exception:'+e.getMessage());
        }  
    }
}