@isTest
public class MixPct_Test {
    
    
    
    static testMethod void opptyInsertTestBulk(){
        map<id,PricebookEntry> pbeIDsOb=new map<id,PricebookEntry>();
        User currentUser =  [select defaultCurrencyIsoCode from User where Id = :UserInfo.getUserId()];
        Id defaultPricebookId = null;
        Pricebook2[] pricebook2 = [select id from Pricebook2 where name = 'Standard Price Book'];
        if(pricebook2 == null || pricebook2.size() == 0){
            Pricebook2 createDefaultPB = new Pricebook2(name='default pricebook', isActive=true);
            
            insert createDefaultPB;
            defaultPricebookId = createDefaultPB.Id;     
        }
        
        Id standardPricebookId = Test.getStandardPricebookId();
        PricebookEntry[] technologyPBE = [select Id from PricebookEntry where  ProductCode='Technology' and CurrencyIsoCode= :currentUser.defaultCurrencyIsoCode and Pricebook2Id = :defaultPricebookId and PriceBookEntry.IsActive=true];
        PricebookEntry defaultTechnologyPBE;
        if(technologyPBE == null || technologyPBE.size() == 0){
            
            Product2[] products = [select id from Product2 where ProductCode = 'Technology'];
            if(products == null || products.size() == 0){
                Product2 newProduct = new Product2(ProductCode ='Technology', Name='Test Tech');
                insert newProduct;
                PricebookEntry standardPrice = new PricebookEntry(
                    Pricebook2Id = standardPricebookId, Product2Id = newProduct.Id,
                    UnitPrice = 10000, IsActive = true);
                insert standardPrice;
                defaultTechnologyPBE = new PricebookEntry(isActive=true,UnitPrice=5,product2Id = newProduct.Id,Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode);
                insert defaultTechnologyPBE;
            }
            else{     
                PricebookEntry standardPrice = new PricebookEntry(
                    Pricebook2Id = standardPricebookId, Product2Id = products[0].Id,
                    UnitPrice = 10000, IsActive = true);
                insert standardPrice;
                defaultTechnologyPBE = new PricebookEntry(isActive=true,UnitPrice=5,product2Id = products[0].Id,Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode);
                insert defaultTechnologyPBE;
                
            }
            
            
        }
        else
        {
            defaultTechnologyPBE = technologyPBE[0];
        }
        pbeIDsOb.put(defaultTechnologyPBE.Id,defaultTechnologyPBE);
        
        Double d=3.14159;
        MixPct.getProcessLineItems();
        MixPct.setProcessLineItems(true);
        
        try{
            MixPct.getProductCode(defaultTechnologyPBE.Id,pbeIDsOb,'OpptyIdTest','OpptyLineItemIdTest',d);
        }catch(Exception e){
            System.debug('exception thrown');
        }
        
    }
    
    static testMethod void optyExpectedAmountChangeTrigger(){
        //processLineItems = true;
        MixPct.setProcessLineItems(true);
        Date vCloseDate = System.today();
        
        Test.startTest();
        setCustomSettings();
        Test.stopTest();
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser@cisco.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@cisco.com', Theatre__c='Americas-US Commercial');
        insert u;
        
        Account acct = null;
        
        CEE_TestUtility.loadCustomSettings();
        acct = CEE_TestUtility.getAccount('brief', true);
        
        
        String renewalsRecordTypeId = '01234000000Boc4AAC';
        
        
        
        //Get users default currency
        User currentUser =  [select defaultCurrencyIsoCode from User where Id = :UserInfo.getUserId()];
        
        Id standardPricebookId = Test.getStandardPricebookId();
        
        
        
        //Query for Pricebook2
        String defaultPricebookId;
        Pricebook2[] pricebook2 = [select id from Pricebook2 where name = 'Standard Price Book'];
        if(pricebook2 == null || pricebook2.size() == 0){
            Pricebook2 createDefaultPB = new Pricebook2(name='default pricebook', isActive=true);
            
            insert createDefaultPB;
            defaultPricebookId = createDefaultPB.Id;     
        }
        else{
            defaultPricebookId = pricebook2[0].Id;
            
        }
        
        //Build a few new Opportunity objects
        Opportunity oppty1 = new Opportunity(name='Test1',StageName='1 - Prospect1',Start_Date__c=system.today(),End_Date__c=system.today(),CloseDate= vCloseDate,Expected_Product__c=2,Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode,RecordTypeId = renewalsRecordTypeId,Primary_Partner__c=acct.id, Competitors__c = 'Abacus');
        Opportunity oppty2 = new Opportunity(name='Test2',StageName='1 - Prospect1',CloseDate= vCloseDate,Expected_Product__c=2,Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode,RecordTypeId = renewalsRecordTypeId,Primary_Partner__c=acct.id,Competitors__c = 'Abacus',Start_Date__c=system.today(),End_Date__c=system.today());
        Opportunity oppty3 = new Opportunity(name='Test3',StageName='1 - Prospect1',CloseDate= vCloseDate,Expected_Product__c=2,Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode,RecordTypeId = renewalsRecordTypeId,Primary_Partner__c=acct.id,Competitors__c = 'Abacus',Start_Date__c=system.today(),End_Date__c=system.today());
        Opportunity oppty4 = new Opportunity(name='Test4',StageName='1 - Prospect1',CloseDate= vCloseDate,Expected_Product__c=2,Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode,RecordTypeId = renewalsRecordTypeId,Primary_Partner__c=acct.id,Competitors__c = 'Abacus',Start_Date__c=system.today(),End_Date__c=system.today());
        
        Opportunity[] opptyArray = new Opportunity[]{oppty1,oppty2,oppty3,oppty4};
            //   opptyArray[0]=oppty1;
            //   opptyArray[1]=oppty2;
            //   opptyArray[2]=oppty3;
            //   opptyArray[3]=oppty4;
            
            insert opptyArray;   
        
        //Query for a sample 'Service' PricebookEntry.
        PricebookEntry[] servicePBE = [select Id from PricebookEntry where  ProductCode='Service' and CurrencyIsoCode= :currentUser.defaultCurrencyIsoCode and Pricebook2Id = :defaultPricebookId and PriceBookEntry.IsActive=true];
        PricebookEntry defaultServicePBE;
        
        if(servicePBE == null || servicePBE.size() == 0){
            
            Product2[] products = [select id from Product2 where ProductCode = 'Service'];
            if(products == null || products.size() == 0){
                Product2 newProduct = new Product2(ProductCode ='Service', Name='Test');
                insert newProduct;
                
                PricebookEntry standardPrice = new PricebookEntry(
                    Pricebook2Id = standardPricebookId, Product2Id = newProduct.Id,
                    UnitPrice = 10000, IsActive = true);
                insert standardPrice;
                defaultServicePBE = new PricebookEntry(isActive=true,UnitPrice=5,product2Id = newProduct.Id,Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode,useStandardPrice = false);
                
                insert defaultServicePBE;
            }
            else{      
                PricebookEntry standardPrice = new PricebookEntry(
                    Pricebook2Id = standardPricebookId, Product2Id = products[0].Id,
                    UnitPrice = 10000, IsActive = true);
                insert standardPrice;
                defaultServicePBE = new PricebookEntry(isActive=true,UnitPrice=5,product2Id = products[0].Id,Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode,useStandardPrice = false);
                insert defaultServicePBE;           
            }
            
            
        }
        else
            defaultServicePBE = servicePBE[0];
        
        
        
        //Query for a sample /Technology PricebookEntry.
        PricebookEntry[] technologyPBE = [select Id from PricebookEntry where  ProductCode='Technology' and CurrencyIsoCode= :currentUser.defaultCurrencyIsoCode and Pricebook2Id = :defaultPricebookId and PriceBookEntry.IsActive=true];
        PricebookEntry defaultTechnologyPBE;
        if(technologyPBE == null || technologyPBE.size() == 0){
            
            Product2[] products = [select id from Product2 where ProductCode = 'Technology'];
            if(products == null || products.size() == 0){
                Product2 newProduct = new Product2(ProductCode ='Technology', Name='Test Tech');
                insert newProduct;
                PricebookEntry standardPrice = new PricebookEntry(
                    Pricebook2Id = standardPricebookId, Product2Id = newProduct.Id,
                    UnitPrice = 10000, IsActive = true);
                insert standardPrice;
                defaultTechnologyPBE = new PricebookEntry(isActive=true,UnitPrice=5,product2Id = newProduct.Id,Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode);
                insert defaultTechnologyPBE;
            }
            else{     
                PricebookEntry standardPrice = new PricebookEntry(
                    Pricebook2Id = standardPricebookId, Product2Id = products[0].Id,
                    UnitPrice = 10000, IsActive = true);
                insert standardPrice;
                defaultTechnologyPBE = new PricebookEntry(isActive=true,UnitPrice=5,product2Id = products[0].Id,Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode);
                insert defaultTechnologyPBE;
                
            }
            
            
        }
        else
            defaultTechnologyPBE = technologyPBE[0];
        
        OpportunityLineItem[] opptyLineItemsToCreate = new OpportunityLineItem[]{};
            
            //Create a new 'Service' OpportunityLineItem. 
            OpportunityLineItem tempLineItem = new OpportunityLineItem(Expected_TCV_000s__c=100,OpportunityId=opptyArray[1].id,Mix__c=50,Quantity=1,PricebookEntryId=defaultServicePBE.id);   
        opptyLineItemsToCreate.add(tempLineItem);
        
        //Create a new 'Technology' OpportunityLineItem. 
        tempLineItem = new OpportunityLineItem(Expected_TCV_000s__c=100,OpportunityId=opptyArray[0].id,Mix__c=50,Quantity=1,PricebookEntryId=defaultTechnologyPBE.id);   
        opptyLineItemsToCreate.add(tempLineItem);
        
        tempLineItem = new OpportunityLineItem(Expected_TCV_000s__c=100,OpportunityId=opptyArray[0].id,Mix__c=0,Quantity=1,PricebookEntryId=defaultTechnologyPBE.id);   
        opptyLineItemsToCreate.add(tempLineItem);
        insert opptyLineItemsToCreate;
        
        
        //Now update the Opportunity 
        opptyArray[0].Expected_Service__c = 0;
        opptyArray[0].Expected_Product__c = 0;
        opptyArray[1].Expected_Service__c = 75;
        opptyArray[1].Expected_Product__c = 75;
        opptyArray[2].Expected_Service__c = 75;
        opptyArray[3].Expected_Service__c = 100;
        opptyArray[3].Expected_Product__c = 100;
        update opptyArray;
    }
    
    @future
    static void setCustomSettings(){
        ObjectRecordTypeIds__c ob=new ObjectRecordTypeIds__c();
        ob.Opportunity_Renewal_RecordTypeId__c='01234000000Boc4 ';
        ob.Oppty_Renewal_RecordTypeId_18__c = '01234000000Boc4AAC';
        insert ob;
        
        ProfileID__c profileIds = new ProfileID__c();
        string renewalProfileId= profileIds.Cisco_Renewals__c;
        profileIds.Cisco_Renewals__c = '00e34000001CQnp';
        insert profileIds;
        
        Org_Constants__c oc = new Org_Constants__c();
        oc.prod_value__c = 'abcd';
        oc.Key__c = 'Oppty: ProfileIds to skip Triggers';
        insert oc;   
        
        Deal_ID_Queue__c mc = new Deal_ID_Queue__c();
        
        mc.Name = 'Deal ID Queue 1';
        mc.Deal_ID_Queue_Stop__c=70000000;
        mc.Deal_ID_Queue_Start__c=61000000;
        
        insert mc;
        
        
    }
    
}