@isTest
private class MassUpdateTasks_CT_Test {

    @testSetup static void setupUser() {
        // Get Cisco_ADMIN Profile user
        User user1 = [Select firstName, LastName ,  USERNAME,   email, ALIAS,  COMMUNITYNICKNAME,  ISACTIVE,   TIMEZONESIDKEY, PROFILEID , LANGUAGELOCALEKEY , THEATRE__C, LOCALESIDKEY ,  EMAILENCODINGKEY 
                        From USER 
                        Where ProfileId = '00e30000000dcbgAAA' AND isActive = true 
                        LIMIT 1];
        User user2 = (user)user1.clone(false,true,false,true);
        user2.FirstName = 'TestFirstName';
        user2.LastName = 'TestLastName';
        user2.Username = 'Test'+DateTime.now().getTime()+'@cisco.com';
        user2.email = 'TestUser1@cisco.com';
        user2.CommunityNickname = 'testu1';
        user2.IsActive = true;
        user2.Alias = 'testu1';
        
        insert user2;
        System.assert(user1 != null);
        System.assertEquals(1, [Select COUNT() FROM USER WHERE email = 'TestUser1@cisco.com']);
        
        List<Task> taskList = new List<Task>();
        Task t;
        
        for(integer i= 0; i<10; i++) {
            t = new Task();
            t.OwnerId = user2.Id;
            t.Status='Not Started';
            t.ActivityDate = Date.today().addDays(-1 * i);
            t.Priority='Normal';
            taskList.add(t);
        }
        
        insert (taskList);
        System.assertEquals(10, [Select COUNT() From Task Where OwnerId = :user2.Id], 'Tasks creation faild!');
    }
    @isTest static void testQueryTask() {
        User u1 = [Select Id,UserName, Email From User Where email = 'TestUser1@cisco.com' LIMIT 1];
        System.assertNotEquals(null, u1);
        System.debug(' >>> u1.username : '+u1.Username);
        System.assertEquals(10, [Select COUNT() From Task Where OwnerId = :u1.Id], 'Tasks creation faild!');
        
        System.runAs(u1) {
            Pagereference pageRef = Page.MassUpdateTasks;
            Test.setCurrentPage(pageRef);
            MassUpdateTasks_CT con = new MassUpdateTasks_CT();
            
            Test.startTest();
            
            con.queryTasks();
            System.assert(con.taskList != null);
            
            // Set Start date
            con.taskObj.ActivityDate = Date.today().addDays(-10);            
            con.queryTasks();
            System.assert(con.taskList != null);
            
            // Set End date
            con.taskObj2.ActivityDate = Date.today().addDays(1);
            con.queryTasks();
            System.assert(con.taskList != null);
            
            // Clear Start date
            con.taskObj.ActivityDate = null;
            con.queryTasks();
            System.assert(con.taskList != null);
            
            Test.stopTest();
            
        }        
    }
    @isTest static void testUpdateDueDate() {        
        User u1 = [Select Id,UserName, Email From User Where email = 'TestUser1@cisco.com' LIMIT 1];
        System.assertNotEquals(null, u1);
        System.debug(' >>> u1.username : '+u1.Username);
        System.assertEquals(10, [Select COUNT() From Task Where OwnerId = :u1.Id], 'Tasks creation faild!');
        
        System.runAs(u1) {
            Pagereference pageRef = Page.MassUpdateTasks;
            Test.setCurrentPage(pageRef);
            MassUpdateTasks_CT con = new MassUpdateTasks_CT();
            
            Test.startTest();
            
            system.assert(con.taskList == null);
            
            // update with out new due date and taskList is empty
            con.updateTasks();
            System.assert(ApexPages.hasMessages());
            System.assert(checkForMessage('No Tasks to update.'));            
            
            // Populate taskList
            con.queryTasks();
            System.assert(con.taskList != null);
            con.updateTasks();
            System.assert(ApexPages.hasMessages());
            System.assert(checkForMessage('Please select new Task due date'));
            
            // Set task new due date
            con.taskObj3.ActivityDate = Date.today().addDays(2);
            con.updateTasks();
            System.assert(ApexPages.hasMessages());
            System.assert(checkForMessage('Please select atleast one task to update.'));
            
            // Set tasks to update
            for(integer i=0; i< con.taskList.size(); i++) {
                con.taskList[i].isSelected = true;
            }
            con.updateTasks();
            System.assert(checkForMessage('Tasks are updated successfully.'));
            
            Test.stopTest();
        }
        
    }
    static Boolean checkForMessage(String msgStr) {
        
        for(ApexPages.Message msg :ApexPages.getMessages()) {
            if(msg.getDetail().contains(msgStr)) {
                return true;
            }
        }
        
        return false;
    }
    
    
}