@isTest
public class BatchForDailyDigestOpportunityCaseTest {
    static testMethod void checkOptyBatchExecution() {
        Test.StartTest();
        BatchForDailyDigestOpportunity optyNotification = new BatchForDailyDigestOpportunity();
		String sch = '0 0 23 * * ?';
        system.schedule('Test Territory Check', sch, optyNotification); 
        Test.stopTest(); 
    }
    
    static testMethod void checkCaseBatchExecution() {
        Test.StartTest();
        BatchForDailyDigestCase caseNotification = new BatchForDailyDigestCase();
		String sch = '0 0 23 * * ?';
        system.schedule('Test Territory Check', sch, caseNotification); 
        Test.stopTest(); 
    }
}