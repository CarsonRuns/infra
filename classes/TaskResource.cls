@RestResource(urlMapping='/MyTask/*')
global with sharing class TaskResource {

    public static void writeLog(String Origin, String typ, String message, datetime t1, String tid){
        //write log asynchronously in future
        try{
            if (message <> null && message.length() > 32000){message=message.substring(0,32000);}
        
            Tx_Log__c l = new Tx_Log__c(
                name=tid,
                type__c=typ,
                originated__c=Origin,
                message__c=message,                
                duration__c=(datetime.now().getTime()-t1.getTime())
            );
            insert l;    
        }
        catch (Exception e){
            System.debug('failed to write log for '+Origin+' '+typ+' '+message+' '+tid);
        }
    }

    @HttpGet
    global static Task[] doGet(RestRequest req, RestResponse res){
        DateTime t1 = datetime.now();            
        String tid=UserInfo.getUserName()+':'+t1;
        String message;
  
        Task[] result = [Select  Id, Subject, Status, ActivityDate, Priority, Description, WhatId, What.Name
                  From Task
                   where Status <> 'Completed' and ownerid = :UserInfo.getUserId() order by activitydate];

        writeLog('taskResource', 'doGet', String.ValueOf(result.size()), t1, tid);
                   
        return result;
    }
    
    @HttpPost
//    global static String doPost(RestRequest req, RestResponse res, Id TaskId, String Subject, String Status, String WhatId, String Priority, String Description){
    global static String doPost(RestRequest req, RestResponse res, Id TaskId, String Subject, String Status, String Priority, String Description){
        DateTime t1 = datetime.now();            
        String tid=UserInfo.getUserName()+':'+t1;
        String message;
        
        Task task = new Task(Id=TaskId);
        task.Subject = Subject;
        task.Status = Status;
 //     task.WhatId = WhatId;            
        task.Priority = Priority;
        task.Description = Description;
        update task;
        
        writeLog('taskResource', 'doPost', 'updated task' +String.ValueOf(Task.Id), t1, tid);
        
        return 'updated ' + TaskId;
    }
}