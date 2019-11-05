@isTest
public class Alekhya_PSS_Clone_CTE_Test {
    public static testMethod void test_PSS_Clone_CTE(){
        Test.startTest();
        User newUser = Renewals_TestUtility.getUser('opssuser', true);
        Utilities.setIsTestMethod(true);
        Utilities.setValidationSkip(true);
        Utilities.setSkipFuture(true);
        lxTestDataFactory.createCustomSettings();
        system.runAs(newUser){
            Opportunity o = lxTestDataFactory.createSingleOppty();
            insert o;
            AT_Workspace__c ws = new AT_Workspace__c(Name='test', Opportunity__c = o.id, Is_Multi_Tech__c = true);       
            Database.SaveResult  result2 = Database.Insert(ws);
            Test.setCurrentPageReference(new PageReference('PSS_Clone_Alekhya?id=' + result2.id));
            ApexPages.StandardController ssc = new ApexPages.StandardController(ws);
            Alekhya_PSS_Clone_CTE controller = new Alekhya_PSS_Clone_CTE(ssc);
            controller.clonethis();
            
            AT_Workspace__c ws2 = new AT_Workspace__c(Name='test',Opportunity__c = o.id);       
            Database.SaveResult result3 = Database.Insert(ws2);
            Workspace_Technology__c wt = new Workspace_Technology__c(Workspace__c = ws2.id, Expected_000__c=50, Business_Entity__c='SECURITY');
            Database.SaveResult result4 = Database.Insert(wt);
            Test.setCurrentPageReference(new PageReference('PSS_Clone_Alekhya?id=' + result3.id));
            ApexPages.StandardController ssc2 = new ApexPages.StandardController(ws2);
            Alekhya_PSS_Clone_CTE controller2 = new Alekhya_PSS_Clone_CTE(ssc2);
            controller2.clonethis();
        }
        Test.stopTest();
       
    }

}