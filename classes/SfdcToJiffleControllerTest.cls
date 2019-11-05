@isTest(SeeAllData=true)
private class SfdcToJiffleControllerTest {

   static testMethod void testGet1() {

        Account act = new Account(name='TestVC');
        insert act;
        
        User currentUser = [select defaultCurrencyIsoCode from User where Id = :UserInfo.getUserId()];
    
        //Query for Pricebook2
        String defaultPricebookId;
        Pricebook2[] pricebook2 = [select id from Pricebook2 where name = 'Standard Price Book'];
        
            
        PricebookEntry[] priceEntry = [Select Id from PricebookEntry where pricebook2Id =: pricebook2[0].Id and IsActive = true and CurrencyIsoCode =: currentUser.defaultCurrencyIsoCode limit 10] ;
        
        Date vCloseDate = System.today() + 15 ;
        Opportunity oppty1 = new Opportunity(name='Test1',StageName='1 - Identify',CloseDate = vCloseDate,Expected_Product__c=2,
                                         Pricebook2Id=pricebook2[0].Id,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode,
                                         Cloud_Demand_Model__c='IaaS',Cloud_Demand_Term_Months__c=13,Cloud_Demand_Units__c='CPU',
                                          Cloud_Number_of_Units__c=2500,Cloud_Demand_Proxy__c='12',AccountId = act.Id);
        insert  oppty1;
        
        ApexPages.currentPage().getParameters().put('Id',act.Id);       
        SfdcToJiffleController redir = new SfdcToJiffleController();
                        
  }
  
  static testMethod void testGet2() {

        Account act = new Account(name='TestVC');
        insert act;
        
        User currentUser = [select defaultCurrencyIsoCode from User where Id = :UserInfo.getUserId()];
    
        //Query for Pricebook2
        String defaultPricebookId;
        Pricebook2[] pricebook2 = [select id from Pricebook2 where name = 'Standard Price Book'];
        
            
        PricebookEntry[] priceEntry = [Select Id from PricebookEntry where pricebook2Id =: pricebook2[0].Id and IsActive = true and CurrencyIsoCode =: currentUser.defaultCurrencyIsoCode limit 10] ;
        
        Date vCloseDate = System.today() + 15 ;
        Opportunity oppty1 = new Opportunity(name='Test1',StageName='1 - Identify',CloseDate = vCloseDate,Expected_Product__c=2,
                                         Pricebook2Id=pricebook2[0].Id,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode,
                                         Cloud_Demand_Model__c='IaaS',Cloud_Demand_Term_Months__c=13,Cloud_Demand_Units__c='CPU',
                                          Cloud_Number_of_Units__c=2500,Cloud_Demand_Proxy__c='12',AccountId = act.Id);
        insert  oppty1;
        
        ApexPages.currentPage().getParameters().put('Id',oppty1.Id);        
        SfdcToJiffleController redir = new SfdcToJiffleController();
                        
  }
  
  static testMethod void testGet3() {

        Account act = new Account(name='TestVC');
        insert act;
        
        User currentUser = [select defaultCurrencyIsoCode from User where Id = :UserInfo.getUserId()];
    
        //Query for Pricebook2
        String defaultPricebookId;
        Pricebook2[] pricebook2 = [select id from Pricebook2 where name = 'Standard Price Book'];
        
            
        PricebookEntry[] priceEntry = [Select Id from PricebookEntry where pricebook2Id =: pricebook2[0].Id and IsActive = true and CurrencyIsoCode =: currentUser.defaultCurrencyIsoCode limit 10] ;
        
        Date vCloseDate = System.today() + 15 ;
        Opportunity oppty1 = new Opportunity(name='Test1',StageName='1 - Identify',CloseDate = vCloseDate,Expected_Product__c=2,
                                         Pricebook2Id=pricebook2[0].Id,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode,
                                         Cloud_Demand_Model__c='IaaS',Cloud_Demand_Term_Months__c=13,Cloud_Demand_Units__c='CPU',
                                          Cloud_Number_of_Units__c=2500,Cloud_Demand_Proxy__c='12',AccountId = act.Id);
        insert  oppty1;
        
        ApexPages.currentPage().getParameters().put('Id','123456456');      
        SfdcToJiffleController redir = new SfdcToJiffleController();
                        
  }
   
    
}