@isTest(SeeAllData=TRUE)
public class QuoteSummary_CTE_TEST{
    
    private static testMethod void QuoteSummary_CTE(){
        Test.setCurrentPageReference(new PageReference('QuoteSummary'));
        Opportunity o = new Opportunity(name='Test',StageName='2 - Qualified',CloseDate=System.today() - 50,Expected_Product__c=10.0,error_description__c='error',DealID__c='1',Opportunity_Status__c='Active'); 
        insert o;
        Quote__c qt = new Quote__c();
            qt.Opportunity_Name__c = o.ID;
            qt.DM_Quote_ID__c = o.DealID__c;
            insert qt;
        
        Quote_Summary__c qs = new Quote_Summary__c();
            qs.Partner_Quote__c = qt.id;
            insert qs;
            System.debug('QS ID --- '+qs.id);
            
        PageReference pr = Page.QuoteSummary;
        Test.setCurrentPageReference(pr);
        pr.getParameters().put('id', qs.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(qs); 
        QuoteSummary_CTE controller = new QuoteSummary_CTE(sc);
        controller.getBaseUrl();
        controller.getPdrDown();
        controller.getQuoteStatus();
         controller.getprofilecheck();
    }    
}