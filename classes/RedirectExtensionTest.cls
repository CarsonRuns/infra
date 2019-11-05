@isTest(SeeAllData=true)
private class RedirectExtensionTest {

   static testMethod void testGet1() {
        
        PageReference pageRef = new PageReference('/apex/RedirectExtension');
        Test.setCurrentPage(pageRef);
        
        Account act = new Account(name='TestVC');
        insert act;
        
        RecordType rc = [Select Id from RecordType where DeveloperName = 'Jifflenow_Meeting'];
        
        CEE__c ce = new CEE__c(Primary_Account__c = act.Id,RecordTypeId = rc.Id);
        
        string retURLAccount = '/' + act.Id ; 
        ApexPages.currentPage().getParameters().put('RecordType',rc.Id);
        ApexPages.currentPage().getParameters().put('retURL',retURLAccount);
        
        string strId = System.Label.ACCOUNT_CESID + '_lkid' ;
        ApexPages.currentPage().getParameters().put(strId,act.Id);
        
        ApexPages.StandardController sc = new ApexPages.standardController(ce);
        RedirectExtension redir = new RedirectExtension(sc);
        redir.redirectToPage();
                
  }
  
  static testMethod void testGet2() {
  
        PageReference pageRef = new PageReference('/apex/RedirectExtension');
        Test.setCurrentPage(pageRef);

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
        
        
        RecordType rc = [Select Id from RecordType where DeveloperName = 'Jifflenow_Meeting'];
        
        
        CEE__c ce = new CEE__c(Primary_Account__c = act.Id,RecordTypeId = rc.Id);
        
        string retURLAccount = '/' + oppty1.Id ; 
        ApexPages.currentPage().getParameters().put('RecordType',rc.Id);
        ApexPages.currentPage().getParameters().put('retURL',retURLAccount);
        
        string strId = System.Label.OPPORTUNITY_CESID + '_lkid' ;
        ApexPages.currentPage().getParameters().put(strId,oppty1.Id);
        
        ApexPages.StandardController sc = new ApexPages.standardController(ce);
        RedirectExtension redir = new RedirectExtension(sc);
        redir.redirectToPage();
                
  }
  
  static testMethod void testGet3() {
  
        PageReference pageRef = new PageReference('/apex/RedirectExtension');
        Test.setCurrentPage(pageRef);

        Account act = new Account(name='TestVC');
        insert act;
        
        RecordType rc = [Select Id from RecordType where DeveloperName = 'Jifflenow_Meeting'];
        
        CEE__c ce = new CEE__c(Primary_Account__c = act.Id,RecordTypeId = rc.Id);
        
        string retURLAccount = '/a0l'  ; 
        ApexPages.currentPage().getParameters().put('RecordType',rc.Id);
        ApexPages.currentPage().getParameters().put('retURL',retURLAccount);
        
        ApexPages.StandardController sc = new ApexPages.standardController(ce);
        RedirectExtension redir = new RedirectExtension(sc);
        redir.redirectToPage();
        
        
        String rc1 = '012Q00000004ru6';
        CEE__c ce1 = new CEE__c(Primary_Account__c = act.Id,RecordTypeId = rc1);
        
        ApexPages.currentPage().getParameters().put('RecordType',rc1);
        ApexPages.currentPage().getParameters().put('retURL',retURLAccount);
        
        ApexPages.StandardController sc1 = new ApexPages.standardController(ce1);
        RedirectExtension redir1 = new RedirectExtension(sc1);
        redir1.redirectToPage();
  }
  
  static testMethod void testGet4() {
  
        PageReference pageRef = new PageReference('/apex/RedirectExtension');
        Test.setCurrentPage(pageRef);

        Account act = new Account(name='TestVC');
        insert act;
        
        string retURLAccount = '/' + act.Id ;       
        String rc1 = '012Q00000004ru6';
        
        CEE__c ce1 = new CEE__c(Primary_Account__c = act.Id,RecordTypeId = rc1);
        
        ApexPages.currentPage().getParameters().put('RecordType',rc1);
        ApexPages.currentPage().getParameters().put('retURL',retURLAccount);
        
        string strId = System.Label.ACCOUNT_CESID + '_lkid' ;
        ApexPages.currentPage().getParameters().put(strId,act.Id);
        
        
        ApexPages.StandardController sc1 = new ApexPages.standardController(ce1);
        RedirectExtension redir1 = new RedirectExtension(sc1);
        redir1.redirectToPage();
        
  }
  
  static testMethod void testGet5() {
  
        PageReference pageRef = new PageReference('/apex/RedirectExtension');
        Test.setCurrentPage(pageRef);

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
        
        
            
        string retURLAccount = '/' + oppty1.Id ; 
                
        String rc1 = '012Q00000004ru6';
        CEE__c ce1 = new CEE__c(Primary_Account__c = act.Id,RecordTypeId = rc1);
        
        ApexPages.currentPage().getParameters().put('RecordType',rc1);
        ApexPages.currentPage().getParameters().put('retURL',retURLAccount);
        
        string strId = System.Label.OPPORTUNITY_CESID + '_lkid' ;
        ApexPages.currentPage().getParameters().put(strId,oppty1.Id);
        
        ApexPages.StandardController sc1 = new ApexPages.standardController(ce1);
        RedirectExtension redir1 = new RedirectExtension(sc1);
        redir1.redirectToPage();
        
        
  }
  static testMethod void testGet6() {
  
        PageReference pageRef = new PageReference('/apex/RedirectExtension');
        Test.setCurrentPage(pageRef);

        Account act = new Account(name='TestVC');
        insert act;
            
        string retURLAccount = '/a0l'  ; 
                
        String rc1 = '012Q00000004ru6';
        CEE__c ce1 = new CEE__c(Primary_Account__c = act.Id,RecordTypeId = rc1);
        
        ApexPages.currentPage().getParameters().put('RecordType',rc1);
        ApexPages.currentPage().getParameters().put('retURL',retURLAccount);
        
        ApexPages.StandardController sc1 = new ApexPages.standardController(ce1);
        RedirectExtension redir1 = new RedirectExtension(sc1);
        redir1.redirectToPage();
  }
    
}