@isTest(SeeAllData=TRUE)
public class OpptyAssetViewControllerTest{
    static testMethod void assetViewControllerTest(){
        Opportunity o = new Opportunity(name='Test',StageName='2 - Qualified',CloseDate=System.today() - 50,Expected_Product__c=10.0,error_description__c='error',DealID__c='1',Opportunity_Status__c='Active',recordtypeId=utilities.getOpptyParentRecordTypeId(),source_opp_id__c='FY-AS-\\s+hjknnjkn-fds\\s+ytrhfg-tgrrfhg'); 
        insert o;
        
        Test.startTest();
    	OpptyAssetViewController.assetViewController(o.Id);
        Test.stopTest();
        
    
    }


}