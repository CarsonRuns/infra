@isTest
    /* Test class of code coverage test methods  
    for Add_Activity classes */
//This is test class only for partner engagement framework QW
    
 private class Activity_Create_Test 
 {
 
   private static testMethod void Test_create_activity()
   {    
        test.startTest();  
        
//        final integer x = 16 ;
        
        RecordType rt = [select Id from RecordType where Name = 'Channel'];
                
        Account a = [select owner.username from Account where cscsiteid__C != null and owner.isactive = true and owner.dummy_user__C = false and recordtypeid = :rt.id  limit 1];
  
        Account c = new account (name ='xyz1',Recordtypeid = rt.id,ownerid = a.owner.id,Accelerate_Stage__c = 'Active');
        Account d = new account (name ='xyz2',Recordtypeid = rt.id,ownerid = a.owner.id,Recruit_Stage__c = 'Active');
        Account e = new account (name ='xyz3',Recordtypeid = rt.id,ownerid = a.owner.id,Manage_Stage__c = 'Completed' );
        Account f = new account (name ='xyz4',Recordtypeid = rt.id,ownerid = a.owner.id, Grow_Stage__c = 'Active' );        

        Account g = new account (name ='xyz5',Recordtypeid = rt.id,ownerid = a.owner.id, Accelerate_Stage__c = 'Not Started' );        
        Account h = new account (name ='xyz6',Recordtypeid = rt.id,ownerid = a.owner.id, Recruit_Stage__c = 'Not Started' );        
        Account i = new account (name ='xyz7',Recordtypeid = rt.id,ownerid = a.owner.id, Manage_Stage__c = 'Not Started' );        
        Account j = new account (name ='xyz8',Recordtypeid = rt.id,ownerid = a.owner.id, Grow_Stage__c = 'Not Started' );                                                

        Account[] o = new Account[]{c,d,e,f};
        insert o ;
        
        Account[] o1 = new Account[]{g,h,i,j};
        insert o1 ;

        Account k = new account (Id = o1[0].Id, Accelerate_Stage__c = 'Active' );        
        Account l = new account (Id = o1[1].Id, Recruit_Stage__c = 'Active' );        
        Account m = new account (Id = o1[2].Id, Manage_Stage__c = 'Active' );        
        Account n = new account (Id = o1[3].Id, Grow_Stage__c = 'Active' );                                                
        
        Account[] p = new Account[]{k,l,m,n};
        update p ;
        
        Task[] task_list_c = [Select Id, Check_Task_Creation__c from Task where WhatId in :o ];
      //  system.assert(task_list_c.size()==16);
               
        Task[] task_list_d = [Select Id, Check_Task_Creation__c from Task where WhatId in :o1 ];
      //  system.assert(task_list_d.size()==16);

        test.stopTest();   
   }
}