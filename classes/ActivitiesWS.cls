global class ActivitiesWS { 
    
    static String locale = UserInfo.getLocale();
       
    global class MyTask {
        webservice String userLocale = locale;
        webservice String name;
        webservice String dealID;
        webservice String subject;
        webservice String dueDate;
        webservice String status;
        webservice String priority;
        webservice String taskID;
        webservice String opptyID;
    }
   
    WebService static MyTask[] getActivities(){
        
        Map<ID,String[]> m = new Map<ID, String[]>();
        Map<ID,String[]> opptyInfo = new Map<ID, String[]>();
        Set<ID> opptys = new Set<ID>();
        MyTask[] OpptyTasks = new MyTask[]{};
        
        for(Task t: [Select Id,WhatId,Subject,Status,Priority,ActivityDate From Task Where OwnerId= :UserInfo.getUserId() and Status!='Completed' and (ActivityDate <= NEXT_N_DAYS:8 OR ActivityDate = null) and object__c = 'Opportunity']){
            String[] cols = new String[]{};
            cols.add(t.Subject);
            cols.add(String.valueOf(t.ActivityDate));
            cols.add(t.Status);
            cols.add(t.Priority);
            cols.add(t.Id);
            cols.add(t.WhatId);
            m.put(t.Id, cols);
            opptys.add(t.WhatId);
        }
        
        for(Opportunity o: [Select Id, Name, DealID__c From Opportunity Where Id IN :opptys and Opportunity_Status__c = 'Active']){
            String[] OpptyCols = new String[]{};
            OpptyCols.add(o.Name);
            OpptyCols.add(o.DealID__c);
            OpptyCols.add(o.Id);
            opptyInfo.put(o.Id,OpptyCols);
        }    
        
        for(ID tID: m.keySet()){    
            String[] s = m.get(tID);
            if(opptyInfo.containsKey(s[5])){
                MyTask t = new MyTask();         
                t.Name = opptyInfo.get(s[5])[0];
                t.dealID = opptyInfo.get(s[5])[1];
                t.opptyID = opptyInfo.get(s[5])[2];
                t.subject = s[0];
                t.dueDate = s[1];
                t.status = s[2];
                t.priority = s[3];
                t.taskID = s[4];
                OpptyTasks.add(t);
            }
        } 
        
        return OpptyTasks;
    }
    
    public static testMethod void test_ActivitiesWS(){
        Date vCloseDate = System.today();
        Opportunity oppty1 = new Opportunity(name='Test1',StageName='1 - Identify',CloseDate= vCloseDate,Expected_Product__c=2);
        insert oppty1;
        Task t = new Task(ownerId=UserInfo.getUserId(), WhatId = oppty1.Id);
        insert t;
        getActivities();
    }
    
    
}