/***************************************************************************************************
Name    : NGCC_Flow_Create_Callback_Task
Author  : Ghattamaneni Chaithanya
Purpose : This class is invocable from Customer Engagement Tool Flow, to create a task for Call Back outcome
Date	: 08-Apr-2019

Modification History: 

*****************************************************************************************************/
global class NGCC_Flow_Create_Callback_Task {
    @InvocableMethod(label='Create Task')
    global static void CreateTask(List<TaskFields> TaskInfo){
        try{
            TaskFields taskDetail = TaskInfo[0];
            Datetime dateGMT = taskDetail.CallbackDateTime;
            Integer offset = UserInfo.getTimezone().getOffset(dateGMT);
            Datetime localTime = dateGMT.addSeconds(offset/1000);
            
            task t = new task();
            t.WhoId = taskDetail.WhoId;
            if(flsGet(task.Subject)){
                t.Subject = 'Call'+' '+taskDetail.LeadFirstname+' '+taskDetail.LeadLastname+' '+string.valueof(dateGMT);
            }
            if(flsGet(task.Jabber_Call_Start_Date_time__c)){
                t.Jabber_Call_Start_Date_time__c = null;
            }
            if(flsGet(task.ActivityDate)){
                t.ActivityDate = dateGMT.date();
            }
            if(flsGet(task.IsReminderSet)){
                t.IsReminderSet = true;
            }            
            t.OwnerId = userinfo.getUserId();
            if(flsGet(task.ReminderDateTime)){
                t.ReminderDateTime = dateGMT.addminutes(-15);
            }
            if(flsGet(task.Status)){
                t.Status = 'Not Started';
            }
            if(flsGet(task.Category_Type__c)){
                t.Category_Type__c = 'Outbound Customer Call';
            }
            if(flsGet(task.Theater__c)){
                t.Theater__c = taskDetail.Theater;
            }
            Database.insert(t, false);
        }Catch(exception e){
            system.debug('exception=='+e+' '+e.getLineNumber());
        }
    }
    
    global class TaskFields {
        @InvocableVariable(required=true)
        global string WhoId;
        
        @InvocableVariable(required=true)
        global String LeadFirstname;
        
        @InvocableVariable(required=true)
        global String LeadLastname;
        
        @InvocableVariable(required=true)
        global DateTime CallbackDateTime;
        
        @InvocableVariable
        global string Theater;
        
    }
     // SCAVA Helper Method
     global static Boolean flsGet(SObjectField field){
        return field.getDescribe().isCreateable() ? true : false;
    }
}