@isTest(seeAllData = True)
private class ScheduleASWorkspaceBatchApex_Test {

    public static testMethod void testDataToLoad(){
    //String CRON_EXP = '0 0 0 15 3 ? *';
    
    Test.StartTest();
     
     ScheduleASWorkspaceShareBatchApex ASworkspaceBatchSchedule = new ScheduleASWorkspaceShareBatchApex();
     system.schedule('OptWorkspaceShare JOBASD', '0 0 * * * ?', ASworkspaceBatchSchedule );
       
    
    Test.StopTest();
   
    }

    
}