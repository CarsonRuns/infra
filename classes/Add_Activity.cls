public class Add_Activity 
{
// this is class for partner engagement framework QW
   public static void Add_Recruit_Activity(set<Id> AccIdset )
   {
     List<Task> taskstocreate = new List<Task>();
     for(Id AccId : AccIdset )
     {
       for(Integer i = 0; i<4 ;i++)
          {
          Task task = new Task(
          WhatId = AccId, 
          OwnerId = UserInfo.getUserId(),  
          Priority = 'High', 
          ActivityDate = System.today().addDays(14), 
          Status = 'In Progress',
          Check_Task_Creation__c = '1'
          );
            if(i==0)
            {
            task.Subject = 'Recruit: Research and qualify targeted partner';
            taskstocreate.add(task);
            }    
            if(i==1)
            {
            task.Subject = 'Recruit: Identify partner\'s Cisco potential';
            taskstocreate.add(task);
            } 
            if(i==2)
            {
            task.Subject = 'Recruit: Gain certification commitment';
            taskstocreate.add(task);
            } 
            if(i==3)
            {
            task.Subject = 'Recruit: Create partner enablement plan';
            taskstocreate.add(task);
            }       
          }    
     }
     Insert taskstocreate;          
   }
 
   public static void Add_Grow_Activity(set<Id> AccIdset)
   {
   
      List<Task> taskstocreate = new List<Task>();
      for(Id AccId : AccIdset )
      {
      
        for(Integer i = 0; i<4 ;i++)
        {
          Task task = new Task(
          WhatId = AccId, 
          OwnerId = UserInfo.getUserId(),  
          Priority = 'High', 
          ActivityDate = System.today().addDays(14), 
          Status = 'In Progress',
          Check_Task_Creation__c = '2'
          );
          
            if(i==0)
            {
            task.Subject = 'Grow: Add 90 Day Action Plans to Partner First Profile';
            taskstocreate.add(task);
            }    
            if(i==1)
            {
            task.Subject = 'Grow: Articulate the resources available to the Partner, have regular meetings';
            taskstocreate.add(task);
            } 
            if(i==2)
            {
            task.Subject = 'Grow: Create sales channel program promotion roadmap';
            taskstocreate.add(task);
            } 
            if(i==3)
            {
            task.Subject = 'Grow: OIP promotion and pipeline tracking';
            taskstocreate.add(task);
            }       
          }    
      }   
      Insert taskstocreate;          
   }
   
   public static void Add_Manage_Activity(set<Id> AccIdset)
   {
   
      List<Task> taskstocreate = new List<Task>();    
      for(Id AccId : AccIdset )
      {
       
          for(Integer i = 0; i<4 ;i++)
          {
          Task task = new Task(
          WhatId = AccId, 
          OwnerId = UserInfo.getUserId(),  
          Priority = 'High', 
          ActivityDate = System.today().addDays(14), 
          Status = 'In Progress',
          Check_Task_Creation__c = '3'
          );
            if(i==0)
            {
            task.Subject = 'Manage: Create PFP, integrate Partner Enablement Plan (PEP) into PFP';
            taskstocreate.add(task);
            }    
            if(i==1)
            {
            task.Subject = 'Manage: Deliver regular marketing communications';
            taskstocreate.add(task);
            } 
            if(i==2)
            {
            task.Subject = 'Manage: Invite Partners to sales/technical trainings';
            taskstocreate.add(task);
            } 
            if(i==3)
            {
            task.Subject = 'Manage: Identify extended Cisco team engagements, set up team introductions';
            taskstocreate.add(task);
            }       
          }    
      }
      Insert taskstocreate;                    
    }
   
    public static void Add_Accelerate_Activity(set<Id> AccIdset)
    {

      List<Task> taskstocreate = new List<Task>();    
      for(Id AccId : AccIdset )
      {

         for(Integer i = 0; i<4 ;i++)
         {
          Task task = new Task(
          WhatId = AccId, 
          OwnerId = UserInfo.getUserId(),  
          Priority = 'High', 
          ActivityDate = System.today().addDays(14), 
          Status = 'In Progress',
          Check_Task_Creation__c = '4'
          );
            if(i==0)
            {
            task.Subject = 'Accelerate: Host Qrtly Business Reviews with Partner (includes execution plan)';
            taskstocreate.add(task);
            }    
            if(i==1)
            {
            task.Subject = 'Accelerate: Develop marketing and demand generation strategy';
            taskstocreate.add(task);
            } 
            if(i==2)
            {
            task.Subject = 'Accelerate: Facilitate sales technical trainings and awareness';
            taskstocreate.add(task);
            } 
            if(i==3)
            {
            task.Subject = 'Accelerate: Set Hardware/Service goals for Partner';
            taskstocreate.add(task);
            }       
          }    
      }
      Insert taskstocreate;                    
   }
   
   private static testMethod void test(){
   
       Account a2 = new account(name='MyAccount');
       Insert a2;    
       Set<Id> accountSet = new Set<Id>{a2.Id};
       Add_Recruit_Activity(accountSet);
       Add_Grow_Activity(accountSet);
       Add_Manage_Activity(accountSet);
       Add_Accelerate_Activity(accountSet);
       
   
   }
  
}