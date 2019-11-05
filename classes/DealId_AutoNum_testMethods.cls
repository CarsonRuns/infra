@isTest
public class DealId_AutoNum_testMethods {

  
  public static testMethod void testDealIDAutoNum(){ 
       
         Deal_ID_Queue__c ds = new Deal_ID_Queue__c();
         ds.name = 'Deal ID Queue 1';
         ds.Deal_ID_Queue_Start__c = 10000;
         ds.Deal_ID_Queue_Stop__c = 20000;
         insert ds;
         
         CEE_TestUtility.loadCustomSettings();
         Org_Constants__c org = new Org_Constants__c();         
         org.key__c='Oppty: ProfileIds to skip Triggers';
         org.non_prod_value__c='00e30000000dcbfAAA';
         org.prod_value__c='00e30000000dcbfAAA';
         org.Type__c='URL';
         org.Prod_LT__c='GSTS,Data_Migration,Integration_Echo_Suppression';
         insert org;   
         ObjectRecordTypeIds__c objrecType = new ObjectRecordTypeIds__c();
         objrecType.Opportunity_Global_RecordTypeId__c ='01234000000M5rI';
         objrecType.Oppty_Renewal_RecordTypeId_18__c= '01234000000Boc4AAC';
         insert objrecType;
         ProfileID__c profileIds = new ProfileID__c();
         profileIds.Cisco_Renewals__c = '00e34000001CQnp';
         profileIds.Cisco_PSS__c = '00e30000000rrZw';
         insert profileIds;    
        
      
       
        
         test.startTest();
          Opportunity o = new Opportunity(name='Test',StageName='1 - Prospect', Position__c = 'US COMMERCIAL Dummy Territory',CloseDate=Date.today()+7, Expected_Product__c=100.0, Expected_Service__c= 100.0, Theater__c='USA', RecordTypeId='01234000000Boc4AAC');
         insert o;
         
        //set up and insert new test price entry
        Product2 prod = new Product2(Name = 'Test Prouct', Family = 'Hardware',ProductCode ='Service');
        insert prod;
        Product2 prod1 = new Product2(Name = 'Test Prouct1', Family = 'Hardware',ProductCode ='Technology');
        insert prod1;
        ID pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2ID = pricebookId, Product2Id = prod1.Id, UnitPrice = 1000.0, IsActive = true);
        insert standardPrice; 
        PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2ID = pricebookId, Product2Id = prod.Id, UnitPrice = 1000.0, IsActive = true);
        insert standardPrice1;  
        //create a custom price book  
         
         OpportunityLineItem UCS = new OpportunityLineItem(Mix__c =100, OpportunityId = o.ID, PricebookEntryId = standardPrice1.Id, Product_Family_US__c='');
         OpportunityLineItem SACHCS = new OpportunityLineItem(Mix__c =100, OpportunityId = o.ID, PricebookEntryId = standardPrice.Id, Service_Category__c = 'CST-Consulting Services Transactional', Service_Level__c = 'SP Mobility', Service_Type__c = 'AS' );
         OpportunityLineItem[] opp = new OpportunityLineItem[]{UCS, SACHCS};
         insert(opp);
         
         test.stopTest();
         
    }
    
    public static testMethod void testDealIDAutoNum_new(){ 
        Deal_ID_Queue__c ds = new Deal_ID_Queue__c();
        ds.name = 'Deal ID Queue 1';
        ds.Deal_ID_Queue_Start__c = 16001824;
        ds.Deal_ID_Queue_Stop__c = 16001824;
        insert ds;
        CEE_TestUtility.loadCustomSettings();
        Org_Constants__c org = new Org_Constants__c();         
         org.key__c='Oppty: ProfileIds to skip Triggers';
         org.non_prod_value__c='00e30000000dcbfAAA';
         org.prod_value__c='00e30000000dcbfAAA';
         org.Type__c='URL';
         org.Prod_LT__c='GSTS,Data_Migration,Integration_Echo_Suppression';
         insert org;  
          ProfileID__c profileIds = new ProfileID__c();
         profileIds.Cisco_Renewals__c = '00e34000001CQnp';
         profileIds.Cisco_PSS__c = '00e30000000rrZw';
         insert profileIds;         
        Opportunity o = new Opportunity(name='Test',StageName='1 - Prospect', Position__c = 'US COMMERCIAL Dummy Territory',CloseDate=Date.today()+7, Expected_Product__c=100.0, Expected_Service__c= 100.0, Theater__c='USA', Deal_ID_Stack_Has_Error__c= false, RecordTypeId='0123000000003ykAAA');
        test.startTest();
        insert o;

        //set up and insert new test price entry
        Product2 prod = new Product2(Name = 'Test Prouct', Family = 'Hardware',ProductCode ='Service');
        insert prod;
        Product2 prod1 = new Product2(Name = 'Test Prouct1', Family = 'Hardware',ProductCode ='Technology');
        insert prod1;
        ID pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2ID = pricebookId, Product2Id = prod1.Id, UnitPrice = 1000.0, IsActive = true);
        insert standardPrice; 
        PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2ID = pricebookId, Product2Id = prod.Id, UnitPrice = 1000.0, IsActive = true);
        insert standardPrice1;  
        //create a custom price book 

        OpportunityLineItem UCS = new OpportunityLineItem(Mix__c =100, OpportunityId = o.ID, PricebookEntryId = standardPrice1.Id, Product_Family_US__c='');
        OpportunityLineItem SACHCS = new OpportunityLineItem(Mix__c =100, OpportunityId = o.ID, PricebookEntryId = standardPrice.Id, Service_Category__c = 'CST-Consulting Services Transactional', Service_Level__c = 'SP Mobility', Service_Type__c = 'AS' );
        OpportunityLineItem[] opp = new OpportunityLineItem[]{UCS, SACHCS};
        insert(opp);
        test.stopTest();
    }
    public static testMethod void testDealIDAutoNum_update(){ 
        Deal_ID_Queue__c ds = new Deal_ID_Queue__c();
        ds.name = 'Deal ID Queue 1';
        ds.Deal_ID_Queue_Start__c = 16001824;
        ds.Deal_ID_Queue_Stop__c = 16001824;
        insert ds;
        CEE_TestUtility.loadCustomSettings();
        Org_Constants__c org = new Org_Constants__c();         
         org.key__c='Oppty: ProfileIds to skip Triggers';
         org.non_prod_value__c='00e30000000dcbfAAA';
         org.prod_value__c='00e30000000dcbfAAA';
         org.Type__c='URL';
         org.Prod_LT__c='GSTS,Data_Migration,Integration_Echo_Suppression';
         insert org;
          ProfileID__c profileIds = new ProfileID__c();
         profileIds.Cisco_Renewals__c = '00e34000001CQnp';
         profileIds.Cisco_PSS__c = '00e30000000rrZw';
         insert profileIds;           
        Opportunity op = new Opportunity(name='Test',StageName='1 - Prospect', Position__c = 'US COMMERCIAL Dummy Territory',CloseDate=Date.today()+7, Expected_Product__c=100.0, Expected_Service__c= 100.0, Theater__c='USA', Deal_ID_Stack_Has_Error__c= false, RecordTypeId='0123000000003ykAAA');
        test.startTest();
        insert op; 
        Opportunity opt = [SELECT ID,dealID__c from Opportunity where id=:op.id];
        opt.dealID__c = '1234';
        update opt; 
        test.stopTest();
    }   
    
    public static testMethod void testBulkUpload(){        
        //Test data for bulk upload of 200 Opportunities
        Opportunity [] oToCreate = new Opportunity[]{};
        OpportunityLineItem[] opp = new OpportunityLineItem[]{};
        Deal_ID_Queue__c ds = new Deal_ID_Queue__c();
        ds.name = 'Deal ID Queue 1';
        ds.Deal_ID_Queue_Start__c = 1;
        ds.Deal_ID_Queue_Stop__c = 200;
        insert ds; 
        Deal_ID_Thresholds__c dts = new Deal_ID_Thresholds__c();
        dts.name = 'Deal ID Queue Thresholds 1';
        dts.Seventy_Percent_Email__c = false;
        dts.Eighty_Percent_Email__c = false;
        dts.Ninety_Percent_Email__c = false;
        insert dts;
        Org_Constants__c org = new Org_Constants__c();         
         org.key__c='Oppty: ProfileIds to skip Triggers';
         org.non_prod_value__c='00e30000000dcbfAAA';
         org.prod_value__c='00e30000000dcbfAAA';
         org.Type__c='URL';
         org.Prod_LT__c='GSTS,Data_Migration,Integration_Echo_Suppression';
         insert org; 
         ProfileID__c profileIds = new ProfileID__c();
         profileIds.Cisco_Renewals__c = '00e34000001CQnp';
         profileIds.Cisco_PSS__c = '00e30000000rrZw';
         insert profileIds;         
        CEE_TestUtility.loadCustomSettings();
        for(Integer x=0; x<50; x++){
            Opportunity o = new Opportunity(name='Test',StageName='1 - Prospect', Position__c = 'US COMMERCIAL Dummy Territory',CloseDate=Date.today()+7, Expected_Product__c=100.0, Expected_Service__c= 100.0, Theater__c='USA', RecordTypeId='0123000000003ykAAA');
            otoCreate.add(o);            
        } 

        Test.startTest();        
        insert otoCreate;
        Product2 prod = new Product2(Name = 'Test Prouct', Family = 'Hardware',ProductCode ='Service');
        insert prod;
        Product2 prod1 = new Product2(Name = 'Test Prouct1', Family = 'Hardware',ProductCode ='Technology');
        insert prod1;
        ID pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2ID = pricebookId, Product2Id = prod1.Id, UnitPrice = 1000.0, IsActive = true);
        insert standardPrice; 
        PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2ID = pricebookId, Product2Id = prod.Id, UnitPrice = 1000.0, IsActive = true);
        insert standardPrice1;      
        For(Opportunity o :[SELECT ID,dealID_AutoNum__c FROM Opportunity WHERE Name = 'Test' limit 50]){            
            OpportunityLineItem UCS = new OpportunityLineItem(Mix__c =100, OpportunityId = o.ID, PricebookEntryId = standardPrice1.Id, Product_Family_US__c='');
            OpportunityLineItem SACHCS = new OpportunityLineItem(Mix__c =100, OpportunityId = o.ID, PricebookEntryId = standardPrice.Id, Service_Category__c = 'CST-Consulting Services Transactional', Service_Level__c = 'SP Mobility', Service_Type__c = 'AS' );
            opp.add(UCS);
            opp.add(SACHCS);            
        }       
        insert(opp);        
        OpptyGetDealId.validateDealId('150' );    
        OpptyGetDealId.validateDealId('170' );
        OpptyGetDealId.validateDealId('190' );
        
        dts.name = 'Deal ID Queue Thresholds 1';        
        dts.Ninety_Percent_Email__c = true;
        dts.Ninety_Percent_Email_Date__c = Date.today()-1;
        update dts;
        OpptyGetDealId.validateDealId('201' );          
        Test.stopTest();        
    }
   
}