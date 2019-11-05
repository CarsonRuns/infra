/**
   @Author sfdc config
   @name <Test_PartnerCustomerDT>
   @CreateDate <3/28/2014>
   @Description Test class for UpdatecustomDateFields 
   @Version <1.0>
  */
@istest(seealldata=true)
private  class Test_PartnerCustomerDT {
    private static testMethod void unitTest(){
        Partner_Customer_Deployment_Tracking_SF__c  pdt =new Partner_Customer_Deployment_Tracking_SF__c();      
        pdt.Partner_PSS_Sales_Cycle__c  = '1-Qualification';       
        insert pdt;
        pdt.Partner_PSS_Sales_Cycle__c   = '2-Awareness';        
        update pdt;
                
        Partner_Customer_Deployment_Tracking_SF__c  pdt1 =new Partner_Customer_Deployment_Tracking_SF__c();        
        pdt1.Partner_PSS_Sales_Cycle__c = '4-Smart';
        insert pdt1;       
        pdt1.Partner_PSS_Sales_Cycle__c   = '6-Deployment';
        update pdt1;
        
        Partner_Customer_Deployment_Tracking_SF__c  pdt2 =new Partner_Customer_Deployment_Tracking_SF__c();        
        pdt2.Partner_PSS_Sales_Cycle__c = '1-Crawl';
        insert pdt2;       
        pdt2.Partner_PSS_Sales_Cycle__c   = '4-Sprint';
        update pdt2;
        
        Partner_Customer_Deployment_Tracking_SF__c  pdt3 =new Partner_Customer_Deployment_Tracking_SF__c();        
        pdt3.Partner_PSS_Sales_Cycle__c = '2-Awareness';
        insert pdt3;       
        pdt3.Partner_PSS_Sales_Cycle__c   = '1-Qualification';
        update pdt3;
        
        Partner_Customer_Deployment_Tracking_SF__c  pdt4 =new Partner_Customer_Deployment_Tracking_SF__c();        
        pdt4.Partner_PSS_Sales_Cycle__c = '5-Pilots';
        insert pdt4;       
        pdt4.Partner_PSS_Sales_Cycle__c   = '3-Foundation Services Readiness';
        update pdt4;
        
        Partner_Customer_Deployment_Tracking_SF__c  pdt5 =new Partner_Customer_Deployment_Tracking_SF__c();        
        pdt5.Partner_PSS_Sales_Cycle__c = '3-Run';
        insert pdt5;       
        pdt5.Partner_PSS_Sales_Cycle__c = '2-Walk';
        update pdt5;
        
        Partner_Customer_Deployment_Tracking_SF__c  pdt6 =new Partner_Customer_Deployment_Tracking_SF__c();        
        pdt6.Partner_PSS_Sales_Cycle__c = '3-Foundation Services Readiness';
        insert pdt6;       
        pdt6.Partner_PSS_Sales_Cycle__c   = '4-Smart';
        update pdt6;
        
        Partner_Customer_Deployment_Tracking_SF__c  pdt7 =new Partner_Customer_Deployment_Tracking_SF__c();        
        pdt7.Partner_PSS_Sales_Cycle__c = '4-Sprint';
        insert pdt7;       
        pdt7.Partner_PSS_Sales_Cycle__c   = '5-Pilots';
        update pdt7;
        
        Partner_Customer_Deployment_Tracking_SF__c  pdt8 =new Partner_Customer_Deployment_Tracking_SF__c();        
        pdt8.Partner_PSS_Sales_Cycle__c = '3-Run';
        insert pdt8;       
        pdt8.Partner_PSS_Sales_Cycle__c   = '4-Sprint';
        update pdt8;
        
        
       
        
    }

}