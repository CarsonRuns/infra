@isTest(SeeAllData=TRUE)
public class DealConsumptionQuote_Test{
    
    private static testMethod void dealConsumption(){
        Opportunity o = new Opportunity(name='Test',StageName='2 - Qualified',CloseDate=System.today() - 50,Expected_Product__c=10.0,error_description__c='error',DealID__c='1',Opportunity_Status__c='Active'); 
        insert o;
        Quote__c qt = new Quote__c();
        qt.Opportunity_Name__c = o.ID;
        qt.DM_Quote_ID__c = o.DealID__c;
        insert qt;
        Test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(qt); 
        DealConsumptionQuote controller = new DealConsumptionQuote(sc);
        PageReference pageRef = Page.DealConsumptionatQuote;
        pageRef.getParameters().put('id', String.valueOf(o.Id));
        Test.setCurrentPage(pageRef);
        controller.init();    
        controller.dealConsumptionURL='test';
        Test.StopTest();
    }    
}