@isTest(SeeAllData=TRUE)
public class OpportunityAssetViewController_Test{
    static testMethod void method1(){
        /*Renewals_Portfolio__c renewalPortfoloi = new Renewals_Portfolio__c();
            renewalPortfoloi.products__c = 'product1';
            renewalPortfoloi.services__c = 'service1';
            renewalPortfoloi.Default_Timeline__c = 'default';
            renewalPortfoloi.Stages__c = 'stage1';
            renewalPortfoloi.Timelines__c = 'timeline';
            insert renewalPortfoloi;
        ProfileID__c ob= new ProfileID__c();
        ob.Cisco_Renewals__c='00e34000001CQnp';
        insert ob;
        
        Org_Constants__c Org_ConstantsOb=new Org_Constants__c();
        Org_ConstantsOb.Key__c='Oppty: ProfileIds to skip Triggers';
        Org_ConstantsOb.prod_value__c ='00e30000000dcbfAAA,00e30000000dfUEAAY,00e30000000eca0AAA,00e30000000qiJjAAI,00e30000000dcbgAAA,00e30000000rrZwAAI';
        insert Org_ConstantsOb;
        
        ObjectRecordTypeIds__c ObjectRecordTypeIdsOb=new ObjectRecordTypeIds__c();
        ObjectRecordTypeIdsOb.Opportunity_Parent_Mobile_RecordTypeId__c='01234000000GGKw';
        insert ObjectRecordTypeIdsOb;*/
        Opportunity o = new Opportunity(name='Test',StageName='2 - Qualified',CloseDate=System.today() - 50,Expected_Product__c=10.0,error_description__c='error',DealID__c='1',Opportunity_Status__c='Active',recordtypeId=utilities.getOpptyParentRecordTypeId(),source_opp_id__c='FY-AS-\\s+hjknnjkn-fds\\s+ytrhfg-tgrrfhg'); 
        insert o;
        Test.startTest();
       PageReference pageRef = Page.OpportunityAssetView;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id', String.valueOf(o.id));
        
        ApexPages.StandardController sc = new ApexPages.StandardController(o);
        //OpportunityAssetViewController.OppResp OppRespOb=new OpportunityAssetViewController.OppResp();
    	OpportunityAssetViewController OpportunityAssetViewControllerOb=new OpportunityAssetViewController(sc);
        OpportunityAssetViewControllerOb.parameterValue='Test';
        Test.stopTest();
        
    
    }


}