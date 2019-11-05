@isTest
public class RenewalsProductsServicesController_Test {
    
    static testMethod Void RenewalsProductsServicesControllerMethodTest(){
        ObjectRecordTypeIds__c ob=new ObjectRecordTypeIds__c();
        ob.Opportunity_Renewal_RecordTypeId__c='01234000000Boc4 ';
        insert ob;
        Renewals_Portfolio__c renewalPortfoloi = new Renewals_Portfolio__c();
        renewalPortfoloi.products__c = 'product1';
        renewalPortfoloi.services__c = 'service1';
        renewalPortfoloi.Default_Timeline__c = 'default';
        renewalPortfoloi.Stages__c = 'stage1';
        renewalPortfoloi.Timelines__c = 'timeline';
        insert renewalPortfoloi;
        List<OpportunityLineItem> lstlineitem = new List<OpportunityLineItem>();
        RenewalsProductsServicesController.getProductandServices(ob.id,'Technology');
        RenewalsProductsServicesController.ProductServiceResponse ProductServiceResponseOb=new RenewalsProductsServicesController.ProductServiceResponse();
        RenewalsProductsServicesController.prdservAggregation(lstlineitem, ProductServiceResponseOb,'Test');
        RenewalsProductsServicesController.getCounts(ob.id,'SampleproductCode');
        RenewalsProductsServicesController.getProductServiceATRGraphData(ob.id);        
    }
    @isTest static void Method1(){
        ObjectRecordTypeIds__c ob=new ObjectRecordTypeIds__c();
        ob.Opportunity_Renewal_RecordTypeId__c='01234000000Boc4 ';
        insert ob;
        Renewals_Portfolio__c renewalPortfoloi = new Renewals_Portfolio__c();
        renewalPortfoloi.products__c = 'product1';
        renewalPortfoloi.services__c = 'service1';
        renewalPortfoloi.Default_Timeline__c = 'default';
        renewalPortfoloi.Stages__c = 'stage1';
        renewalPortfoloi.Timelines__c = 'timeline';
        insert renewalPortfoloi;
        List<OpportunityLineItem> lstlineitem = new List<OpportunityLineItem>(); 
        RenewalsProductsServicesController.getProductandServices(ob.id,'Service');
        RenewalsProductsServicesController.ProductServiceResponse ProductServiceResponseOb=new RenewalsProductsServicesController.ProductServiceResponse();
        RenewalsProductsServicesController.prdservAggregation(lstlineitem, ProductServiceResponseOb,'Test');
        RenewalsProductsServicesController.getCounts(ob.id,'SampleproductCode');
        RenewalsProductsServicesController.getProductServiceATRGraphData(ob.id);    
    }
    @isTest static void method2(){
        RenewalsProductsServicesController.ProductServiceResponse ProductServiceResponseOb=new RenewalsProductsServicesController.ProductServiceResponse();
        List<OpportunityLineItem> lstlineitem = new List<OpportunityLineItem>();
        OpportunityLineItem OpportunityLineItemOb=new OpportunityLineItem(Expected_TCV_000s__c=200,Prior_TCV__c=200,Prior_ATR__c=200,Term_in_Months__c=7,Prior_Term__c=20);
        lstlineitem.add(OpportunityLineItemOb);
        RenewalsProductsServicesController.prdservAggregation(lstlineitem, ProductServiceResponseOb,'Product');
        
    }
    
}