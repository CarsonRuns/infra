@isTest
public class lxCIC_Welcome_Page_CTL_Test {
    private static testMethod void test(){
        
        Utilities.setIsTestMethod(true);
        Utilities.setValidationSkip(true);        
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Cisco_ADMIN' Limit 1];
        User usr = lxTestDataFactory.createSingleUser(p.Id);
        insert usr;
        system.runAs(usr){
            lxTestDataFactory.createCustomSettings();
            Account a = lxTestDataFactory.createChannelAccount(usr.Id);
            insert a;
            Pricebook2 pb2 = lxTestDataFactory.createPriceBook2();
            insert pb2;
            Opportunity opp = lxTestDataFactory.createSingleOpportunity(a.id, pb2.id, usr.Id);
            insert opp;
            Test.startTest(); 
            lxCIC_Welcome_Page_CTL.getLinkUrls();
            lxCIC_Welcome_Page_CTL.getDetails(opp.id);
            Test.stopTest();
        }        
    }
}