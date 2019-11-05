@isTest(SeeAllData=true)
public class PSS_Clone_CTE_Test {

    public static testMethod void test_PSS_Clone_CTE(){
        
        Opportunity o = new Opportunity(Name='test', StageName='stage', closeDate=system.today());
        Database.SaveResult  result = Database.Insert(o);
        AT_Workspace__c ws = new AT_Workspace__c(Name='test', Opportunity__c = result.id, Is_Multi_Tech__c = true);       
        Database.SaveResult  result2 = Database.Insert(ws);
        Test.setCurrentPageReference(new PageReference('PSS_Clone?id=' + result2.id));
        ApexPages.StandardController ssc = new ApexPages.StandardController(ws);
        PSS_Clone_CTE controller = new PSS_Clone_CTE(ssc);
        controller.clonethis();
        
        AT_Workspace__c ws2 = new AT_Workspace__c(Name='test',Opportunity__c = result.id);       
        Database.SaveResult result3 = Database.Insert(ws2);
        Workspace_Technology__c wt = new Workspace_Technology__c(Workspace__c = ws2.id, Expected_000__c=50, Business_Entity__c='SECURITY');
        Database.SaveResult result4 = Database.Insert(wt);
        Test.setCurrentPageReference(new PageReference('PSS_Clone?id=' + result3.id));
        ApexPages.StandardController ssc2 = new ApexPages.StandardController(ws2);
        PSS_Clone_CTE controller2 = new PSS_Clone_CTE(ssc2);
        controller2.clonethis();
       
    }

}