public with sharing class MassUpdateTasks_CT {

// SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdateGet(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }
     // SCAVA Helper Method to validate Create Access at field level
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }
    
    //Constructor
    public MassUpdateTasks_CT() {
        
        // Get current user and assign it to account Partner_1_Cisco_Rec_PSR__c
        taskObj = new Task();
        taskObj2 = new Task();
        taskObj3 = new Task();
        
        taskObj.ownerId = userInfo.getUserId();
    }
    
    // Wrapper class to display list of tasks
    public class TaskWrapper {
        
        public Id taskId { get; set; }
        public Task taskObj { get; set; }
        public Boolean isSelected { get; set; }
        
        public TaskWrapper(Task taskRec) {
            this.taskId = taskRec.id;
            this.taskObj = taskRec;
            
            this.isSelected = false;    
        }
    }
    // End of TaskWrapper class
    
    public List<TaskWrapper> taskList { get; set; }
    
    // Account object record to get input fields for startdate and end date and user
    
    public Task taskObj { get; set; }
    
    public Task taskObj2 { get; set; }
    
    public Task taskObj3 { get; set; }
    
    
    private Date startDate { get; set; }
    
    private Date endDate { get; set; }
    
    private Date newTaskDueDate { get; set; }
    
    
    
    public static Integer qLimit  = 1000;
    
    public void queryTasks() {
        taskList = new List<TaskWrapper>();
        
        List<Task> taskResult = new List<Task>();
        
        startDate = taskObj.ActivityDate;
        endDate = taskObj2.ActivityDate;    
        
        
        if( startDate != null && endDate != null && startDate <= endDate ) {
            taskResult = [Select Id, subject, whatId, status, ActivityDate 
                          From Task 
                          Where OwnerId = :taskObj.ownerId AND (ActivityDate >= :startDate AND ActivityDate <= :endDate) 
                          Order By ActivityDate ASC 
                          Limit :qLimit
                         ];
            
        }
        else if(startDate != null && endDate == null) {
            taskResult = [Select Id, subject, whatId, status, ActivityDate 
                          From Task 
                          Where OwnerId = :taskObj.ownerId AND (ActivityDate >= :startDate) 
                          Order By ActivityDate ASC
                          LIMIT :qLimit
                         ];
        }
        else if(endDate != null && startDate == null) {
            taskResult = [Select Id, subject, whatId, status, ActivityDate 
                          From Task 
                          Where OwnerId = :taskObj.ownerId AND (ActivityDate <= :endDate) 
                          Order By ActivityDate ASC
                          LIMIT :qLimit              
                         ];
        }
        else {
            taskResult = [Select Id, subject, whatId, status, ActivityDate 
                          From Task 
                          Where OwnerId = :taskObj.ownerId 
                          Order By ActivityDate ASC
                          LIMIT :qLimit              
                         ];
        }
        
        // populating taskwrapper list
        
        if(taskResult != null && !taskResult.isEmpty()) {
            
            for(Task t : taskResult) {
                
                taskList.add(new TaskWrapper(t));        
            }
        }
        
    }
    // END of Query Task
    
    public void updateTasks() {
        
        newTaskDueDate = taskObj3.ActivityDate;
        
        // Check if there are some tasks for user to update
        if(taskList == null || taskList.isEmpty()) {
            ApexPages.addmessage(new apexpages.message(apexpages.severity.WARNING, 'No Tasks to update.'));
            return;
        }
        
        // Check if New Due date is not null
        if(newTaskDueDate == null) {
            ApexPages.addmessage(new apexpages.message(apexpages.severity.WARNING, 'Please select new Task due date'));
            return;
        }
        
        List<Task> updateTaskList = new List<Task>();
        
        for( TaskWrapper t : taskList ) {
            
            if(t.isSelected) {
            
            if(flsUpdateGet(Task.ActivityDate)||flsGet(Task.ActivityDate)) //SCAVA FIX
               {
                t.taskObj.ActivityDate = newTaskDueDate;
                }
                updateTaskList.add(t.taskObj);
            }      
        }
        
        if(updateTaskList == null || updateTaskList.isEmpty()) {
            ApexPages.addmessage(new apexpages.message(apexpages.severity.WARNING, 'Please select atleast one task to update.'));
            return;
        }
        
        // update tasks
        try {
            update(updateTaskList);
            ApexPages.addmessage(new apexpages.message(apexpages.severity.CONFIRM, 'Tasks are updated successfully.'));
            System.debug(System.LoggingLevel.INFO, ' >>> Tasks are updated successfully!');
        }
        catch(Exception ex) {
            System.debug(System.LoggingLevel.ERROR,' >>> Exception while updating tasks : '+ex.getMessage());
            ApexPages.addmessage(new apexpages.message(apexpages.severity.ERROR, ex.getMessage()));
        }
    }
    
}