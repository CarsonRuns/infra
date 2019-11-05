@isTest(SeeAllData=true)
public class OpptyCloudIaaSTest{
    
    static testMethod void opptyInsertTestBulk(){
    //processLineItems = true;
    //setProcessLineItems(true);
    Date vCloseDate = System.today();
    
    //Get users default currency
    //String currentUser = 'USD';
    
    //Query for Pricebook2
    String defaultPricebookId;
//    Pricebook2[] pricebook2 = [select id from Pricebook2];

    Pricebook2 createDefaultPB = new Pricebook2(name='default pricebook', isActive=true);
    insert createDefaultPB;
    
    Cloud_Demand_Partner_Service_Offer__c cd = new Cloud_Demand_Partner_Service_Offer__c();
    cd.Cloud_Demand_Partner__c = 'Accenture';    
    cd.Cloud_Demand_Model__c = 'IaaS';
    cd.Cloud_Demand_Offer__c = 'Foundation';
    cd.Cloud_Demand_Proxy__c = 4.67;
    cd.Cloud_Demand_Units__c = 'Users';
    
    Database.SaveResult sr = Database.insert(cd, false);

    test.startTest();

    Opportunity oppty1 = new Opportunity(name='Test1',StageName='1 - Identify',CloseDate= vCloseDate,Expected_Product__c=2,
                                         Pricebook2Id=defaultPricebookId,CurrencyIsoCode='USD',
                                         Cloud_Demand_Model__c='IaaS',Cloud_Demand_Partner_Service_OfferLookup__c =sr.id,Cloud_Demand_Term_Months__c=13,Cloud_Demand_Units__c='CPU',
                                         Cloud_Number_of_Units__c=2500,Cloud_Demand_Proxy__c='12',Forecast_Discount__c=0);
     Utilities.setValidationSkip(true);
     insert  oppty1;
     
     oppty1.Cloud_Demand_Partner_Service_OfferLookup__c = null;
     update oppty1;
     
     
     Opportunity opptys1 = new Opportunity(name='Test1',StageName='1 - Identify',CloseDate= vCloseDate,Expected_Product__c=2,
                                         Pricebook2Id=defaultPricebookId,CurrencyIsoCode='USD',
                                         Cloud_Demand_Model__c='IaaS',Cloud_Demand_Term_Months__c=13,Cloud_Demand_Units__c='VPU',
                                         Cloud_Number_of_Units__c=3500,Cloud_Demand_Proxy__c='12',Forecast_Discount__c=0);

     insert  opptys1; 
     Opportunity oppty2 = new Opportunity(name='Test1',StageName='1 - Identify',CloseDate= vCloseDate,Expected_Product__c=2,
                                         Pricebook2Id=defaultPricebookId,CurrencyIsoCode='USD',
                                         Cloud_Demand_Model__c='IaaS',Cloud_Demand_Term_Months__c=11,Cloud_Demand_Units__c='CPU',
                                         Cloud_Number_of_Units__c=2500,Cloud_Demand_Proxy__c='12',Forecast_Discount__c=0);                                         

     insert  oppty2;
     Opportunity oppty3 = new Opportunity(name='Test1',StageName='1 - Identify',CloseDate= vCloseDate,Expected_Product__c=2,
                                         Pricebook2Id=defaultPricebookId,CurrencyIsoCode='USD',
                                         Cloud_Demand_Model__c='ABC',Cloud_Demand_Term_Months__c=11,Cloud_Demand_Units__c='CPU',
                                         Cloud_Number_of_Units__c=2500,Cloud_Demand_Proxy__c='12',Forecast_Discount__c=0);                                         

     insert  oppty3;                                 

    test.stopTest();

    }
    
    
}