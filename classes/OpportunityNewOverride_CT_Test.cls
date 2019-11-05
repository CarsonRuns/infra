@isTest(SeeAllData=TRUE)
public class OpportunityNewOverride_CT_Test{
    
    private static testMethod void OpportunityNewOverrideTest(){
        Opportunity o = new Opportunity(name='Test',StageName='2 - Qualified',CloseDate=System.today() - 50,Expected_Product__c=10.0,error_description__c='error',DealID__c='1',Opportunity_Status__c='Active',recordtypeId=utilities.getOpptyParentRecordTypeId()); 
        insert o;
        ApexPages.StandardController sc = new ApexPages.StandardController(o); 
        OpportunityNewOverride_CT controller = new OpportunityNewOverride_CT(sc);
        PageReference pageRef = Page.Prevent_Phase_Without_Parent;
        pageRef.getParameters().put('id', String.valueOf(o.RecordTypeId));
        Test.setCurrentPage(pageRef);
        controller.getUserDefaultOpportunityRecordType();  
        string recordType = 'abc';
        controller.recordType = recordType;
        
    }    
}