@isTest(SeeAllData=true)
public class BatchForDailyDigestTest {
    
    public static testMethod void checkOpportunityNotification(){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Cisco_ADMIN' Limit 1];
        User usr = lxTestDataFactory.createSingleUser(p.Id);
        System.runAs(usr){
            Test.startTest();
            BatchForDailyDigest optyBatchDailyDigest = New BatchForDailyDigest('Opportunity');   
            Database.executeBatch(optyBatchDailyDigest);
            Test.stopTest();
        }
    }
    
      public static testMethod void checkCaseNotification(){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Cisco_ADMIN' Limit 1];
        User usr = lxTestDataFactory.createSingleUser(p.Id);
        System.runAs(usr){
            Test.startTest();
            BatchForDailyDigest optyBatchDailyDigest = New BatchForDailyDigest('Case');   
            Database.executeBatch(optyBatchDailyDigest);
            Test.stopTest();
        }
    }  
}