/**************************************
Author          : Hari Krishna
Release         : Mar Release version 1
Created         : Feb 07,2019
Functionality   : test class for lxSpecializedViewSummaryController

**********************************************/
@isTest
public class lxSpecializedViewSummaryControllerTest {
    static String defaultPricebookId;
     @isTest
    static void TestOptyLinesSSV() {
        //bypass validation rules
        Utilities.setIsTestMethod(true);
        Utilities.setValidationSkip(true);
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Cisco_ADMIN' Limit 1];
        User usr = lxTestDataFactory.createSingleUser(p.Id);
        insert usr;
        
        Account acct1 = null;
        
        system.runAs(usr){
            
            lxTestDataFactory.createCustomSettings();
            acct1 = lxTestDataFactory.createChannelAccount(usr.Id);
            insert acct1;
        }
        
       
        //Retrieveing Current Date
        Date vCloseDate = System.today();
        
        //Get users default currency
        User currentUser = [select defaultCurrencyIsoCode from User where Id = :UserInfo.getUserId()];
        
        //Query for Pricebook2
        String defaultPricebookId;
        Pricebook2 createDefaultPB = new Pricebook2(name='Standard Price Book', isActive=true);
        insert createDefaultPB;
        defaultPricebookId = createDefaultPB.Id;
        //Create Opportunity 
        Opportunity oppty1 = new Opportunity(name='Test1',Accountid=acct1.id, StageName='3 - Proposal',
                                             CloseDate= vCloseDate-1,Competitors__c = 'A10 Networks',Expected_Product__c=2,
                                              Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode);
        oppty1.Expected_Service__c = 0;
        oppty1.Expected_Product__c = 10;        
        insert oppty1;
        
        //Summary View logic
        lxSpecializedViewSummaryController.getSummaryViewList(oppty1.Id);

        //Create new Technology and Service                                
        Product2 pr2 = new Product2(ProductCode='Technology',
                                    Name = 'COMPUTING SYSTEMS',
                                    Business_Entity__c = 'COMPUTING SYSTEMS',
                                    Product_Family_1__c='pf1',
                                    Product_Family_2__c='pf2',
                                    Product_Family_3__c='pf3', 
                                    Product_Family_4__c='pf4',
                                    isactive=true);
        insert pr2;
        
        PricebookEntry pbeTech = lxTestDataFactory.createPriceBookEntry(createDefaultPB.Id,pr2.Id);
        insert pbeTech;
        
        Product2 pr21 = new Product2(ProductCode='Technology',
                                     Name = 'COMPUTING SYSTEMS',
                                     Business_Entity__c = 'COMPUTING SYSTEMS',
                                     Product_Family_1__c='pf1',
                                     Product_Family_2__c='pf2',
                                     Product_Family_3__c='pf3', 
                                     Product_Family_4__c='pf4',
                                     isactive=true);
        insert pr21;
        
        
        //Creating Technology Line 
        OpportunityLineItem oli1 = new OpportunityLineItem();
        oli1.Mix__c= 100;
        oli1.Business_Entity__c = 'COMPUTING SYSTEMS';
        oli1.Product2Id = pr2.id;
        oli1.OpportunityId=oppty1.Id;
        oli1.PricebookEntryId=pbeTech.id;
        oli1.Quantity=1;
        oli1.Product_Family__c='pf1';
        oli1.Opportunity_Line_Value__c = 100;
        insert oli1;
        
        
        OpportunityLinesSV__c oppLineSSV = new OpportunityLinesSV__c();
                oppLineSSV.Technology_Service__c = oli1.Product2Id;
                oppLineSSV.Opportunity__c = oppty1.Id;
                oppLineSSV.Incubation_Specialist__c = userInfo.getUserId();
                oppLineSSV.Opportunity_Stage__c = '2 - Qualification';    
                oppLineSSV.Expected_Book_Date__c = system.today();  
                oppLineSSV.Expected_000_Value__c = 100;
                oppLineSSV.Product_Family__c = oli1.Product_Family__c;
                oppLineSSV.Product_Code__c = 'Technology';//oli1.PriceBookEntry.ProductCode;
        		oppLineSSV.recordtypeId = ObjectRecordTypeIds__c.getInstance().Architecture_Specialist_Record_Type__c;
                 insert oppLineSSV;
        
        lxSpecializedViewSummaryController.getSummaryViewList(oppty1.Id);
    }
    
    @isTest
    static void TestOptyLinesSSV1() {
        //bypass validation rules
        Utilities.setIsTestMethod(true);
        Utilities.setValidationSkip(true);
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Cisco_ADMIN' Limit 1];
        User usr = lxTestDataFactory.createSingleUser(p.Id);
        insert usr;
        
        Account acct1 = null;
        
        system.runAs(usr){
            
            lxTestDataFactory.createCustomSettings();
            acct1 = lxTestDataFactory.createChannelAccount(usr.Id);
            insert acct1;
        }
        //Retrieveing Current Date
        Date vCloseDate = System.today();
        
        //Get users default currency
        User currentUser = [select defaultCurrencyIsoCode from User where Id = :UserInfo.getUserId()];
        
        //Query for Pricebook2
        Pricebook2 createDefaultPB = new Pricebook2(name='Standard Price Book', isActive=true);
        insert createDefaultPB;
        defaultPricebookId = createDefaultPB.Id;
        //Create Opportunity 
        Opportunity oppty1 = new Opportunity(name='Test1',Accountid=acct1.id, StageName='2 - Qualification',
                                             CloseDate= vCloseDate-1,Competitors__c = 'A10 Networks',Expected_Product__c=2,
                                             Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode);
        oppty1.Expected_Service__c = 0;
        oppty1.Expected_Product__c = 10;        
        insert oppty1;
        
        //Summary View logic
        lxSpecializedViewSummaryController.getSummaryViewList(oppty1.Id);
     
        //Create new Technology and Service                                
        Product2 pr2 = new Product2(ProductCode='Technology',
                                    Name = 'COMPUTING SYSTEMS',
                                    Business_Entity__c = 'COMPUTING SYSTEMS',
                                    //Product_Family_1__c='pf1',
                                    //Product_Family_2__c='pf2',
                                    //Product_Family_3__c='pf3', 
                                    //Product_Family_4__c='pf4',
                                    isactive=true);
        insert pr2;
        PricebookEntry pbeTech = lxTestDataFactory.createPriceBookEntry(createDefaultPB.Id,pr2.Id);
        insert pbeTech;
        
        Product2 pr21 = new Product2(ProductCode='Technology',
                                     Name = 'COMPUTING SYSTEMS',
                                     Business_Entity__c = 'COMPUTING SYSTEMS',
                                     //Product_Family_1__c='pf1',
                                     //Product_Family_2__c='pf2',
                                     //Product_Family_3__c='pf3', 
                                     //Product_Family_4__c='pf4',
                                     isactive=true);
        insert pr21;
        
        
        //Creating Technology Line 
        OpportunityLineItem oli1 = new OpportunityLineItem();
        oli1.Mix__c= 100;
        oli1.Business_Entity__c = 'COMPUTING SYSTEMS';
        oli1.Product2Id = pr2.id;
        oli1.OpportunityId=oppty1.Id;
        oli1.PricebookEntryId=pbeTech.id;
        oli1.Quantity=1;
        oli1.Product_Family__c='pf1';
        oli1.Opportunity_Line_Value__c = 100;
        insert oli1;
        
        
        OpportunityLinesSV__c oppLineSSV = new OpportunityLinesSV__c();
                oppLineSSV.Technology_Service__c = oli1.Product2Id;
                oppLineSSV.Opportunity__c = oppty1.Id;
                oppLineSSV.Incubation_Specialist__c = userInfo.getUserId();
                oppLineSSV.Opportunity_Stage__c = '2 - Qualification';    
                oppLineSSV.Expected_Book_Date__c = system.today();  
                oppLineSSV.Expected_000_Value__c = 100;
                oppLineSSV.Product_Family__c = oli1.Product_Family__c;
                oppLineSSV.Product_Code__c = 'Technology';//oli1.PriceBookEntry.ProductCode;
        		oppLineSSV.recordtypeId = ObjectRecordTypeIds__c.getInstance().Architecture_Specialist_Record_Type__c;
                 insert oppLineSSV;
            Test.startTest();
        lxSpecializedViewSummaryController.getSummaryViewList(oppty1.Id);
        lxSpecializedViewSummaryController.checkEAOppty(oppty1.Id);
        lxSpecializedViewSummaryController.deleteRecords();
        Test.stopTest();
    }
    
     @isTest
    static void TestOptyLinesSSV2() {
        //bypass validation rules
        Utilities.setIsTestMethod(true);
        Utilities.setValidationSkip(true);
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Cisco_ADMIN' Limit 1];
        User usr = lxTestDataFactory.createSingleUser(p.Id);
        insert usr;
        
        Account acct1 = null;
        
        system.runAs(usr){
            
            lxTestDataFactory.createCustomSettings();
            acct1 = lxTestDataFactory.createChannelAccount(usr.Id);
            insert acct1;
        }
        //Retrieveing Current Date
        Date vCloseDate = System.today();
        
        //Get users default currency
        User currentUser = [select defaultCurrencyIsoCode from User where Id = :UserInfo.getUserId()];
        
        //Query for Pricebook2
        Pricebook2 createDefaultPB = new Pricebook2(name='Standard Price Book', isActive=true);
        insert createDefaultPB;
        defaultPricebookId = createDefaultPB.Id;
        //Create Opportunity 
        Opportunity oppty1 = new Opportunity(name='Test1',Accountid=acct1.id, StageName='3 - Proposal',
                                             CloseDate= vCloseDate-1,Competitors__c = 'A10 Networks',Expected_Product__c=2,
                                             Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode);
        oppty1.Expected_Service__c = 0;
        oppty1.Expected_Product__c = 10;        
        insert oppty1;
        
        //Summary View logic
        lxSpecializedViewSummaryController.getSummaryViewList(oppty1.Id);
      
        //Create new Technology and Service                                
        Product2 pr2 = new Product2(ProductCode='Technology',
                                    Name = 'COMPUTING SYSTEMS',
                                    Business_Entity__c = 'COMPUTING SYSTEMS',
                                    //Product_Family_1__c='pf1',
                                    //Product_Family_2__c='pf2',
                                    //Product_Family_3__c='pf3', 
                                    //Product_Family_4__c='pf4',
                                    isactive=true);
        insert pr2;
        PricebookEntry pbeTech = lxTestDataFactory.createPriceBookEntry(createDefaultPB.Id,pr2.Id);
        insert pbeTech;
        
        Product2 pr21 = new Product2(ProductCode='Technology',
                                     Name = 'COMPUTING SYSTEMS',
                                     Business_Entity__c = 'COMPUTING SYSTEMS',
                                     //Product_Family_1__c='pf1',
                                     //Product_Family_2__c='pf2',
                                     //Product_Family_3__c='pf3', 
                                     //Product_Family_4__c='pf4',
                                     isactive=true);
        insert pr21;
        
        
        //Creating Technology Line 
        OpportunityLineItem oli1 = new OpportunityLineItem();
        oli1.Mix__c= 100;
        oli1.Business_Entity__c = 'COMPUTING SYSTEMS';
        oli1.Product2Id = pr2.id;
        oli1.OpportunityId=oppty1.Id;
        oli1.PricebookEntryId=pbeTech.id;
        oli1.Quantity=1;
        oli1.Product_Family__c='';//pf1';
        oli1.Opportunity_Line_Value__c = 100;
        insert oli1;
        
        
        OpportunityLinesSV__c oppLineSSV = new OpportunityLinesSV__c();
                oppLineSSV.Technology_Service__c = oli1.Product2Id;
                oppLineSSV.Opportunity__c = oppty1.Id;
                oppLineSSV.Incubation_Specialist__c = userInfo.getUserId();
                oppLineSSV.Opportunity_Stage__c = '2 - Qualification';    
                oppLineSSV.Expected_Book_Date__c = system.today();  
                oppLineSSV.Expected_000_Value__c = 100;
                oppLineSSV.Product_Family__c = '';//oli1.Product_Family__c;
                oppLineSSV.Product_Code__c = 'Technology';//oli1.PriceBookEntry.ProductCode;
        		oppLineSSV.recordtypeId = ObjectRecordTypeIds__c.getInstance().Architecture_Specialist_Record_Type__c;
                 insert oppLineSSV;
        
        lxSpecializedViewSummaryController.getSummaryViewList(oppty1.Id);
    }
    
    
    @isTest
    static void TestOptyLinesSSV3() {
        //bypass validation rules
        Utilities.setIsTestMethod(true);
        Utilities.setValidationSkip(true);
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Cisco_ADMIN' Limit 1];
        User usr = lxTestDataFactory.createSingleUser(p.Id);
        insert usr;
        
        Account acct1 = null;
        
        system.runAs(usr){
            
            lxTestDataFactory.createCustomSettings();
            acct1 = lxTestDataFactory.createChannelAccount(usr.Id);
            insert acct1;
        }
        //Retrieveing Current Date
        Date vCloseDate = System.today();
        
        //Get users default currency
        User currentUser = [select defaultCurrencyIsoCode from User where Id = :UserInfo.getUserId()];
        
        //Query for Pricebook2
        Pricebook2 createDefaultPB = new Pricebook2(name='Standard Price Book', isActive=true);
        insert createDefaultPB;
        defaultPricebookId = createDefaultPB.Id;
        //Create Opportunity 
        Opportunity oppty1 = new Opportunity(name='Test1',Accountid=acct1.id, StageName='3 - Proposal',
                                             CloseDate= vCloseDate-1,Competitors__c = 'A10 Networks',Expected_Product__c=2,
                                             Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode);
        oppty1.Expected_Service__c = 0;
        oppty1.Expected_Product__c = 10;        
        insert oppty1;
        
        //Summary View logic
        lxSpecializedViewSummaryController.getSummaryViewList(oppty1.Id);

        //Create new Technology and Service                                
        Product2 pr2 = new Product2(ProductCode='Technology',
                                    Name = 'COMPUTING SYSTEMS',
                                    Business_Entity__c = 'COMPUTING SYSTEMS',
                                    Product_Family_1__c='pf1',
                                    Product_Family_2__c='pf2',
                                    Product_Family_3__c='pf3', 
                                    Product_Family_4__c='pf4',
                                    Service_Program__c = 'servProg',
                                     Service_Category__c = 'serCat',
                                     Service_Level_Name_1__c = 'serLevel',
                                    isactive=true);
        insert pr2;
        PricebookEntry pbeTech = lxTestDataFactory.createPriceBookEntry(createDefaultPB.Id,pr2.Id);
        insert pbeTech;
        
        Product2 pr21 = new Product2(ProductCode='Technology',
                                     Name = 'COMPUTING SYSTEMS',
                                     Business_Entity__c = 'COMPUTING SYSTEMS',
                                     Product_Family_1__c='pf1',
                                     Product_Family_2__c='pf2',
                                     Product_Family_3__c='pf3', 
                                     Product_Family_4__c='pf4',
                                     Service_Program__c = 'servProg',
                                     Service_Category__c = 'serCat',
                                     Service_Level_Name_1__c = 'serLevel',
                                     isactive=true);
        insert pr21;
        
        
        //Creating Technology Line 
        OpportunityLineItem oli1 = new OpportunityLineItem();
        oli1.Mix__c= 100;
        oli1.Business_Entity__c = 'COMPUTING SYSTEMS';
        oli1.Product2Id = pr2.id;
        oli1.OpportunityId=oppty1.Id;
        oli1.PricebookEntryId=pbeTech.id;
        oli1.Quantity=1;
        oli1.Product_Family__c='pf1';
        oli1.Opportunity_Line_Value__c = 100;
        oli1.Service_Category__c = 'sevCat';
            oli1.Service_Level__c = 'serLevel';
            oli1.Service_Type__c = 'serType';
        insert oli1;
        
        
        OpportunityLinesSV__c oppLineSSV = new OpportunityLinesSV__c();
                oppLineSSV.Technology_Service__c = oli1.Product2Id;
                oppLineSSV.Opportunity__c = oppty1.Id;
                oppLineSSV.Incubation_Specialist__c = userInfo.getUserId();
                oppLineSSV.Opportunity_Stage__c = '2 - Qualification';    
                oppLineSSV.Expected_Book_Date__c = system.today();  
                oppLineSSV.Expected_000_Value__c = 100;
                oppLineSSV.Product_Family__c = oli1.Product_Family__c;
                oppLineSSV.Product_Code__c = 'Service';//oli1.PriceBookEntry.ProductCode;
                oppLineSSV.Service_Category__c = 'ServCat';             
                oppLineSSV.Service_Level_Description__c = 'ServDescr'; 
        		oppLineSSV.recordtypeId = ObjectRecordTypeIds__c.getInstance().Software_Specialist_Record_Type__c;
                 insert oppLineSSV;
        
        lxSpecializedViewSummaryController.getSummaryViewList(oppty1.Id);
    }
    
    @isTest
    static void TestOptyLinesSSV4() {
        //bypass validation rules
        Utilities.setIsTestMethod(true);
        Utilities.setValidationSkip(true);
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Cisco_ADMIN' Limit 1];
        User usr = lxTestDataFactory.createSingleUser(p.Id);
        insert usr;
        
        Account acct1 = null;
        
        system.runAs(usr){
            
            lxTestDataFactory.createCustomSettings();
            acct1 = lxTestDataFactory.createChannelAccount(usr.Id);
            insert acct1;
        }
        //Retrieveing Current Date
        Date vCloseDate = System.today();
        
        //Get users default currency
        User currentUser = [select defaultCurrencyIsoCode from User where Id = :UserInfo.getUserId()];
        
        //Query for Pricebook2
        Pricebook2 createDefaultPB = new Pricebook2(name='Standard Price Book', isActive=true);
        insert createDefaultPB;
        defaultPricebookId = createDefaultPB.Id;
        //Create Opportunity 
        Opportunity oppty1 = new Opportunity(name='Test1',Accountid=acct1.id, StageName='3 - Proposal',
                                             CloseDate= vCloseDate-1,Competitors__c = 'A10 Networks',Expected_Product__c=2,
                                             Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode);
        oppty1.Expected_Service__c = 0;
        oppty1.Expected_Product__c = 10;        
        insert oppty1;
        
                
        
        //Create new Technology and Service                                
        Product2 pr2 = new Product2(ProductCode='Technology',
                                    Name = 'COMPUTING SYSTEMS',
                                    Business_Entity__c = 'COMPUTING SYSTEMS',
                                    Product_Family_1__c='pf1',
                                    Product_Family_2__c='pf2',
                                    Product_Family_3__c='pf3', 
                                    Product_Family_4__c='pf4',
                                    Service_Program__c = 'servProg',
                                     Service_Category__c = 'serCat',
                                     Service_Level_Name_1__c = 'serLevel',
                                    isactive=true);
        insert pr2;
        PricebookEntry pbeTech = lxTestDataFactory.createPriceBookEntry(createDefaultPB.Id,pr2.Id);
        insert pbeTech;
        
        Product2 pr21 = new Product2(ProductCode='Technology',
                                     Name = 'COMPUTING SYSTEMS',
                                     Business_Entity__c = 'COMPUTING SYSTEMS',
                                     Product_Family_1__c='pf1',
                                     Product_Family_2__c='pf2',
                                     Product_Family_3__c='pf3', 
                                     Product_Family_4__c='pf4',
                                     Service_Program__c = 'servProg',
                                     Service_Category__c = 'serCat',
                                     Service_Level_Name_1__c = 'serLevel',
                                     isactive=true);
        insert pr21;
        
        
        //Creating Technology Line 
        OpportunityLineItem oli1 = new OpportunityLineItem();
        oli1.Mix__c= 100;
        oli1.Business_Entity__c = 'COMPUTING SYSTEMS';
        oli1.Product2Id = pr2.id;
        oli1.OpportunityId=oppty1.Id;
        oli1.PricebookEntryId=pbeTech.id;
        oli1.Quantity=1;
        oli1.Product_Family__c='pf1';
        oli1.Opportunity_Line_Value__c = 100;
        oli1.Service_Category__c = 'sevCat';
            oli1.Service_Level__c = 'serLevel';
            oli1.Service_Type__c = 'serType';
        insert oli1;
        
        
        OpportunityLinesSV__c oppLineSSV = new OpportunityLinesSV__c();
                oppLineSSV.Technology_Service__c = oli1.Product2Id;
                oppLineSSV.Opportunity__c = oppty1.Id;
                oppLineSSV.Incubation_Specialist__c = userInfo.getUserId();
                oppLineSSV.Opportunity_Stage__c = '';//'2 - Qualification';    
                oppLineSSV.Expected_Book_Date__c = system.today();  
                oppLineSSV.Expected_000_Value__c = 100;
                oppLineSSV.Product_Family__c = oli1.Product_Family__c;
                oppLineSSV.Product_Code__c = 'Service';//oli1.PriceBookEntry.ProductCode;
                oppLineSSV.Service_Category__c = 'ServCat';             
                oppLineSSV.Service_Level_Description__c = 'ServDescr';  
        		oppLineSSV.recordtypeId = ObjectRecordTypeIds__c.getInstance().Architecture_Specialist_Record_Type__c;
                 insert oppLineSSV;
        
        lxSpecializedViewSummaryController.getSummaryViewList(oppty1.Id);
    }
    
    
    @isTest
    static void TestOptyLinesSSV5() {
        //bypass validation rules
        Utilities.setIsTestMethod(true);
        Utilities.setValidationSkip(true);
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Cisco_ADMIN' Limit 1];
        User usr = lxTestDataFactory.createSingleUser(p.Id);
        insert usr;
        
        Account acct1 = null;
        
        system.runAs(usr){
            
            lxTestDataFactory.createCustomSettings();
            acct1 = lxTestDataFactory.createChannelAccount(usr.Id);
            insert acct1;
        } 
        //Retrieveing Current Date
        Date vCloseDate = System.today();
        
        //Get users default currency
        User currentUser = [select defaultCurrencyIsoCode from User where Id = :UserInfo.getUserId()];
        
        //Query for Pricebook2
        Pricebook2 createDefaultPB = new Pricebook2(name='Standard Price Book', isActive=true);
        insert createDefaultPB;
        defaultPricebookId = createDefaultPB.Id;
        //Create Opportunity 
        Opportunity oppty1 = new Opportunity(name='Test1',Accountid=acct1.id, StageName='3 - Proposal',
                                             CloseDate= vCloseDate-1,Competitors__c = 'A10 Networks',Expected_Product__c=2,
                                             Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode);
        oppty1.Expected_Service__c = 0;
        oppty1.Expected_Product__c = 10;        
        insert oppty1;
        
        //Summary View logic
        lxSpecializedViewSummaryController.getSummaryViewList(oppty1.Id);
       
        //Create new Technology and Service                                
        Product2 pr2 = new Product2(ProductCode='Technology',
                                    Name = 'COMPUTING SYSTEMS',
                                    Business_Entity__c = 'COMPUTING SYSTEMS',
                                    Product_Family_1__c='pf1',
                                    Product_Family_2__c='pf2',
                                    Product_Family_3__c='pf3', 
                                    Product_Family_4__c='pf4',
                                    Service_Program__c = 'servProg',
                                     Service_Category__c = 'serCat',
                                     Service_Level_Name_1__c = 'serLevel',
                                    isactive=true);
        insert pr2;
        PricebookEntry pbeTech = lxTestDataFactory.createPriceBookEntry(createDefaultPB.Id,pr2.Id);
        insert pbeTech;
        
        Product2 pr21 = new Product2(ProductCode='Technology',
                                     Name = 'COMPUTING SYSTEMS',
                                     Business_Entity__c = 'COMPUTING SYSTEMS',
                                     Product_Family_1__c='pf1',
                                     Product_Family_2__c='pf2',
                                     Product_Family_3__c='pf3', 
                                     Product_Family_4__c='pf4',
                                     Service_Program__c = 'servProg',
                                     Service_Category__c = 'serCat',
                                     Service_Level_Name_1__c = 'serLevel',
                                     isactive=true);
        insert pr21;
        
        
        //Creating Technology Line 
        OpportunityLineItem oli1 = new OpportunityLineItem();
        oli1.Mix__c= 100;
        oli1.Business_Entity__c = 'COMPUTING SYSTEMS';
        oli1.Product2Id = pr2.id;
        oli1.OpportunityId=oppty1.Id;
        oli1.PricebookEntryId=pbeTech.id;
        oli1.Quantity=1;
        oli1.Product_Family__c='pf1';
        oli1.Opportunity_Line_Value__c = 100;
        oli1.Service_Category__c = 'sevCat';
            oli1.Service_Level__c = 'serLevel';
            oli1.Service_Type__c = 'serType';
        insert oli1;
        
        
        OpportunityLinesSV__c oppLineSSV = new OpportunityLinesSV__c();
                oppLineSSV.Technology_Service__c = oli1.Product2Id;
                oppLineSSV.Opportunity__c = oppty1.Id;
                oppLineSSV.Incubation_Specialist__c = userInfo.getUserId();
                oppLineSSV.Architecture_Specialist__c = userInfo.getUserId();
                oppLineSSV.Opportunity_Stage__c = oppty1.stageName;
                oppLineSSV.Expected_Book_Date__c = system.today();  
                oppLineSSV.Expected_000_Value__c = 100;
                oppLineSSV.Product_Family__c = oli1.Product_Family__c;
                oppLineSSV.Product_Code__c = 'Service';//oli1.PriceBookEntry.ProductCode;
                oppLineSSV.Service_Category__c = 'ServCat';             
                oppLineSSV.Service_Level_Description__c = 'ServDescr';   
        		oppLineSSV.recordtypeId = ObjectRecordTypeIds__c.getInstance().Architecture_Specialist_Record_Type__c;
                 insert oppLineSSV;
        
        lxSpecializedViewSummaryController.getSummaryViewList(oppty1.Id);
    }
    
    
    @isTest
    static void TestOptyLinesSSV6() {
        //bypass validation rules
        Utilities.setIsTestMethod(true);
        Utilities.setValidationSkip(true);
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Cisco_ADMIN' Limit 1];
        User usr = lxTestDataFactory.createSingleUser(p.Id);
        insert usr;
        
        Account acct1 = null;
        
        system.runAs(usr){
            
            lxTestDataFactory.createCustomSettings();
            acct1 = lxTestDataFactory.createChannelAccount(usr.Id);
            insert acct1;
        }
        //Retrieveing Current Date
        Date vCloseDate = System.today();
        
        //Get users default currency
        User currentUser = [select defaultCurrencyIsoCode from User where Id = :UserInfo.getUserId()];
        
        //Query for Pricebook2
        Pricebook2 createDefaultPB = new Pricebook2(name='Standard Price Book', isActive=true);
        insert createDefaultPB;
        defaultPricebookId = createDefaultPB.Id;
        //Create Opportunity 
        Opportunity oppty1 = new Opportunity(name='Test1',Accountid=acct1.id, StageName='3 - Proposal',
                                             CloseDate= vCloseDate-1,Competitors__c = 'A10 Networks',Expected_Product__c=2,
                                             Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode);
        oppty1.Expected_Service__c = 0;
        oppty1.Expected_Product__c = 10;        
        insert oppty1;
        
        //Summary View logic
        lxSpecializedViewSummaryController.getSummaryViewList(oppty1.Id);
       
        //Create new Technology and Service                                
        Product2 pr2 = new Product2(ProductCode='Technology',
                                    Name = 'COMPUTING SYSTEMS',
                                    //Business_Entity__c = 'COMPUTING SYSTEMS',
                                    Product_Family_1__c='pf1',
                                    Product_Family_2__c='pf2',
                                    Product_Family_3__c='pf3', 
                                    Product_Family_4__c='pf4',
                                    isactive=true);
        insert pr2;
        PricebookEntry pbeTech = lxTestDataFactory.createPriceBookEntry(createDefaultPB.Id,pr2.Id);
        insert pbeTech;
        
        Product2 pr21 = new Product2(ProductCode='Technology',
                                     Name = 'COMPUTING SYSTEMS',
                                     //Business_Entity__c = 'COMPUTING SYSTEMS',
                                     Product_Family_1__c='pf1',
                                     Product_Family_2__c='pf2',
                                     Product_Family_3__c='pf3', 
                                     Product_Family_4__c='pf4',
                                     isactive=true);
        insert pr21;
        
        
        //Creating Technology Line 
        OpportunityLineItem oli1 = new OpportunityLineItem();
        oli1.Mix__c= 100;
        oli1.Business_Entity__c = 'COMPUTING SYSTEMS';
        oli1.Product2Id = pr2.id;
        oli1.OpportunityId=oppty1.Id;
        oli1.PricebookEntryId=pbeTech.id;
        oli1.Quantity=1;
        oli1.Product_Family__c='pf1';
        oli1.Opportunity_Line_Value__c = 100;
        insert oli1;
        
        
        OpportunityLinesSV__c oppLineSSV = new OpportunityLinesSV__c();
                oppLineSSV.Technology_Service__c = oli1.Product2Id;
                oppLineSSV.Opportunity__c = oppty1.Id;
                oppLineSSV.Incubation_Specialist__c = userInfo.getUserId();
                oppLineSSV.Opportunity_Stage__c = '2 - Qualification';    
                oppLineSSV.Expected_Book_Date__c = system.today();  
                oppLineSSV.Expected_000_Value__c = 100;
                oppLineSSV.Product_Family__c = oli1.Product_Family__c;
                oppLineSSV.Product_Code__c = 'Technology';
        		oppLineSSV.recordtypeId = ObjectRecordTypeIds__c.getInstance().Architecture_Specialist_Record_Type__c;
                 insert oppLineSSV;
        
        lxSpecializedViewSummaryController.getSummaryViewList(oppty1.Id);
    }
    
    @isTest
    static void TestOptyLinesSSV7() {
        //bypass validation rules
        Utilities.setIsTestMethod(true);
        Utilities.setValidationSkip(true);
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Cisco_ADMIN' Limit 1];
        User usr = lxTestDataFactory.createSingleUser(p.Id);
        insert usr;
        
        Account acct1 = null;
        
        system.runAs(usr){
            
            lxTestDataFactory.createCustomSettings();
            acct1 = lxTestDataFactory.createChannelAccount(usr.Id);
            insert acct1;
        }
        //Retrieveing Current Date
        Date vCloseDate = System.today();
        
        //Get users default currency
        User currentUser = [select defaultCurrencyIsoCode from User where Id = :UserInfo.getUserId()];
        
        //Query for Pricebook2
        Pricebook2 createDefaultPB = new Pricebook2(name='Standard Price Book', isActive=true);
        insert createDefaultPB;
        defaultPricebookId = createDefaultPB.Id;
        //Create Opportunity 
        Opportunity oppty1 = new Opportunity(name='Test1',Accountid=acct1.id, StageName='3 - Proposal',
                                             CloseDate= vCloseDate-1,Competitors__c = 'A10 Networks',Expected_Product__c=2,
                                             Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode);
        oppty1.Expected_Service__c = 0;
        oppty1.Expected_Product__c = 10;        
        insert oppty1;
        
        //Summary View logic
        lxSpecializedViewSummaryController.getSummaryViewList(oppty1.Id);

       
        //Create new Technology and Service                                
        Product2 pr2 = new Product2(ProductCode='Technology',
                                    Name = 'COMPUTING SYSTEMS',
                                    Business_Entity__c = 'COMPUTING SYSTEMS',
                                    Sub_Business_Entity_Name__c = 'testSubBE',
                                    Product_Family_1__c='pf1',
                                    Product_Family_2__c='pf2',
                                    Product_Family_3__c='pf3', 
                                    Product_Family_4__c='pf4',                                    
                                    isactive=true);
        insert pr2;
        PricebookEntry pbeTech = lxTestDataFactory.createPriceBookEntry(createDefaultPB.Id,pr2.Id);
        insert pbeTech;
        
        Product2 pr21 = new Product2(ProductCode='Technology',
                                     Name = 'COMPUTING SYSTEMS',
                                     Business_Entity__c = 'COMPUTING SYSTEMS',
                                     Product_Family_1__c='pf1',
                                     Product_Family_2__c='pf2',
                                     Product_Family_3__c='pf3', 
                                     Product_Family_4__c='pf4',
                                     isactive=true);
        insert pr21;
        
        
        //Creating Technology Line 
        OpportunityLineItem oli1 = new OpportunityLineItem();
        oli1.Mix__c= 100;
        oli1.Business_Entity__c = 'COMPUTING SYSTEMS';
        oli1.Product2Id = pr2.id;
        oli1.OpportunityId=oppty1.Id;
        oli1.PricebookEntryId=pbeTech.id;
        oli1.Quantity=1;
        oli1.Product_Family__c='pf1';
        oli1.Opportunity_Line_Value__c = 100;
        insert oli1;
        
        
        OpportunityLinesSV__c oppLineSSV = new OpportunityLinesSV__c();
                oppLineSSV.Technology_Service__c = oli1.Product2Id;
                oppLineSSV.Opportunity__c = oppty1.Id;
                oppLineSSV.Incubation_Specialist__c = userInfo.getUserId();
                oppLineSSV.Opportunity_Stage__c = '2 - Qualification';    
                oppLineSSV.Expected_Book_Date__c = system.today();  
                oppLineSSV.Expected_000_Value__c = 100;
                oppLineSSV.Product_Family__c = oli1.Product_Family__c;
                oppLineSSV.Product_Code__c = 'Technology';
        		oppLineSSV.recordtypeId = ObjectRecordTypeIds__c.getInstance().Architecture_Specialist_Record_Type__c;
                 insert oppLineSSV;
        
        lxSpecializedViewSummaryController.getSummaryViewList(oppty1.Id);
    }
    
    @isTest
    static void TestOptySoftwareLines() {
        //bypass validation rules
        Utilities.setIsTestMethod(true);
        Utilities.setValidationSkip(true);
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Cisco_ADMIN' Limit 1];
        User usr = lxTestDataFactory.createSingleUser(p.Id);
        insert usr;
        
        Account acct1 = null;
        
        system.runAs(usr){
            
            lxTestDataFactory.createCustomSettings();
            acct1 = lxTestDataFactory.createChannelAccount(usr.Id);
            insert acct1;
        }
        //Retrieveing Current Date
        Date vCloseDate = System.today();
        
        //Get users default currency
        User currentUser = [select defaultCurrencyIsoCode from User where Id = :UserInfo.getUserId()];
        
        //Query for Pricebook2
        Pricebook2 createDefaultPB = new Pricebook2(name='Standard Price Book', isActive=true);
        insert createDefaultPB;
        defaultPricebookId = createDefaultPB.Id;
        //Create Opportunity 
        Opportunity oppty1 = new Opportunity(name='Test1',Accountid=acct1.id, StageName='3 - Proposal',
                                             CloseDate= vCloseDate-1,Competitors__c = 'A10 Networks',Expected_Product__c=2,
                                             Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode);
        oppty1.Expected_Service__c = 0;
        oppty1.Expected_Product__c = 10;
        oppty1.Enterprise_Agreement_Opportunity__c = 'Yes';        
        insert oppty1;
        
        //Summary View logic
        lxSpecializedViewSummaryController.getSummaryViewList(oppty1.Id);
        
         //Create new Technology and Service                                
        Product2 pr2 = new Product2(ProductCode='Technology',
                                    Name = 'COMPUTING SYSTEMS',
                                    Business_Entity__c = 'COMPUTING SYSTEMS',
                                    Product_Family_1__c='pf1',
                                    Product_Family_2__c='pf2',
                                    Product_Family_3__c='pf3', 
                                    Product_Family_4__c='pf4',
                                    isactive=true);
        insert pr2;
        
        
        // Create Opportunity Line Items 
        PricebookEntry pbeTech = lxTestDataFactory.createPriceBookEntry(createDefaultPB.Id,pr2.Id);
        insert pbeTech;

        Product2 pr21 = new Product2(ProductCode='Technology',
                                     Name = 'COMPUTING SYSTEMS',
                                     Business_Entity__c = 'COMPUTING SYSTEMS',
                                     Product_Family_1__c='pf1',
                                     Product_Family_2__c='pf2',
                                     Product_Family_3__c='pf3', 
                                     Product_Family_4__c='pf4',
                                     isactive=true);
        insert pr21;
        
        
        //Creating Technology Line 
        OpportunityLineItem oli1 = new OpportunityLineItem();
        oli1.Mix__c= 100;
        oli1.Business_Entity__c = 'COMPUTING SYSTEMS';
        oli1.Product2Id = pr2.id;
        oli1.OpportunityId=oppty1.Id;
        oli1.PricebookEntryId=pbeTech.id;
        oli1.Quantity=1;
        oli1.Product_Family__c='pf1';
        oli1.Opportunity_Line_Value__c = 100;
        insert oli1;
        
        
        OpportunityLinesSV__c oppLineSSV = new OpportunityLinesSV__c();
                oppLineSSV.Technology_Service__c = oli1.Product2Id;
                oppLineSSV.Opportunity__c = oppty1.Id;
                oppLineSSV.Software_Specialist__c = userInfo.getUserId();
                oppLineSSV.Opportunity_Stage__c = '2 - Qualification';    
                oppLineSSV.Expected_Book_Date__c = system.today();  
                oppLineSSV.Expected_000_Value__c = 0;
                oppLineSSV.Product_Family__c = oli1.Product_Family__c;
                oppLineSSV.Product_Code__c = 'Technology';//oli1.PriceBookEntry.ProductCode;
        		oppLineSSV.recordtypeId = ObjectRecordTypeIds__c.getInstance().Software_Specialist_Record_Type__c;
                 insert oppLineSSV;
        
        lxSpecializedViewSummaryController.getSummaryViewList(oppty1.Id);
    }
    
    @isTest
    static void testOptySoftwareLines2() {
        //bypass validation rules
        Utilities.setIsTestMethod(true);
        Utilities.setValidationSkip(true);
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Cisco_ADMIN' Limit 1];
        User usr = lxTestDataFactory.createSingleUser(p.Id);
        insert usr;
        
        Account acct1 = null;
        
        system.runAs(usr){
            
            lxTestDataFactory.createCustomSettings();
            acct1 = lxTestDataFactory.createChannelAccount(usr.Id);
            insert acct1;
        }
        //Retrieveing Current Date
        Date vCloseDate = System.today();
        
        //Get users default currency
        User currentUser = [select defaultCurrencyIsoCode from User where Id = :UserInfo.getUserId()];
        
        //Query for Pricebook2
        Pricebook2 createDefaultPB = new Pricebook2(name='Standard Price Book', isActive=true);
        insert createDefaultPB;
        defaultPricebookId = createDefaultPB.Id;
        //Create Opportunity 
        Opportunity oppty1 = new Opportunity(name='Test1',Accountid=acct1.id, StageName='3 - Proposal',
                                             CloseDate= vCloseDate+3,Competitors__c = 'A10 Networks',Expected_Product__c=2,
                                             Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode);
        oppty1.Expected_Service__c = 0;
        oppty1.Expected_Product__c = 10;
        oppty1.Enterprise_Agreement_Opportunity__c = 'NO';        
        insert oppty1;
        
        //Summary View logic
        lxSpecializedViewSummaryController.getSummaryViewList(oppty1.Id);
        
         //Create new Technology and Service                                
        Product2 pr2 = new Product2(ProductCode='Technology',
                                    Name = 'COMPUTING SYSTEMS',
                                    Business_Entity__c = 'COMPUTING SYSTEMS',
                                    Product_Family_1__c='pf1',
                                    Product_Family_2__c='pf2',
                                    Product_Family_3__c='pf3', 
                                    Product_Family_4__c='pf4',
                                    isactive=true);
        insert pr2;
        
        
        // Create Opportunity Line Items 
        PricebookEntry pbeTech = lxTestDataFactory.createPriceBookEntry(createDefaultPB.Id,pr2.Id);
        insert pbeTech;

        Product2 pr21 = new Product2(ProductCode='Technology',
                                     Name = 'COMPUTING SYSTEMS',
                                     Business_Entity__c = 'COMPUTING SYSTEMS',
                                     Product_Family_1__c='pf1',
                                     Product_Family_2__c='pf2',
                                     Product_Family_3__c='pf3', 
                                     Product_Family_4__c='pf4',
                                     isactive=true);
        insert pr21;
        
        
        //Creating Technology Line 
        OpportunityLineItem oli1 = new OpportunityLineItem();
        oli1.Mix__c= 100;
        oli1.Business_Entity__c = 'COMPUTING SYSTEMS';
        oli1.Product2Id = pr2.id;
        oli1.OpportunityId=oppty1.Id;
        oli1.PricebookEntryId=pbeTech.id;
        oli1.Quantity=1;
        oli1.Product_Family__c='pf1';
        oli1.Opportunity_Line_Value__c = 100;
        insert oli1;
        
        
        OpportunityLinesSV__c oppLineSSV = new OpportunityLinesSV__c();
                oppLineSSV.Technology_Service__c = oli1.Product2Id;
                oppLineSSV.Opportunity__c = oppty1.Id;
                oppLineSSV.Software_Specialist__c = userInfo.getUserId();
                oppLineSSV.Opportunity_Stage__c = '2 - Qualification';    
                oppLineSSV.Expected_Book_Date__c = system.today();  
                oppLineSSV.Expected_000_Value__c = 0;
                oppLineSSV.Product_Family__c = oli1.Product_Family__c;
                oppLineSSV.Product_Code__c = 'Technology';//oli1.PriceBookEntry.ProductCode;
        		oppLineSSV.recordtypeId = ObjectRecordTypeIds__c.getInstance().Software_Specialist_Record_Type__c;
                 insert oppLineSSV;
        
        lxSpecializedViewSummaryController.getSummaryViewList(oppty1.Id);
    }
    
    @isTest
    static void testOptySoftwareLines3() {
        //bypass validation rules
        Utilities.setIsTestMethod(true);
        Utilities.setValidationSkip(true);
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Cisco_ADMIN' Limit 1];
        User usr = lxTestDataFactory.createSingleUser(p.Id);
        insert usr;
        
        Account acct1 = null;
        
        system.runAs(usr){
            
            lxTestDataFactory.createCustomSettings();
            acct1 = lxTestDataFactory.createChannelAccount(usr.Id);
            insert acct1;
        }
        //Retrieveing Current Date
        Date vCloseDate = System.today();
        
        //Get users default currency
        User currentUser = [select defaultCurrencyIsoCode from User where Id = :UserInfo.getUserId()];
        
        //Query for Pricebook2
        Pricebook2 createDefaultPB = new Pricebook2(name='Standard Price Book', isActive=true);
        insert createDefaultPB;
        defaultPricebookId = createDefaultPB.Id;
        //Create Opportunity 
        Opportunity oppty1 = new Opportunity(name='Test1',Accountid=acct1.id, StageName='3 - Proposal',
                                             CloseDate= vCloseDate+3,Competitors__c = 'A10 Networks',Expected_Product__c=2,
                                             Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode);
        oppty1.Expected_Service__c = 0;
        oppty1.Expected_Product__c = 10;
        oppty1.Enterprise_Agreement_Opportunity__c = 'NO';        
        insert oppty1;
        
        //Summary View logic
        lxSpecializedViewSummaryController.getSummaryViewList(oppty1.Id);
        
         //Create new Technology and Service                                
        Product2 pr2 = new Product2(ProductCode='Technology',
                                    Name = 'COMPUTING SYSTEMS',
                                    Business_Entity__c = 'COMPUTING SYSTEMS',
                                    Product_Family_1__c='pf1',
                                    Product_Family_2__c='pf2',
                                    Product_Family_3__c='pf3', 
                                    Product_Family_4__c='pf4',
                                    isactive=true);
        insert pr2;
        
        
        // Create Opportunity Line Items 
        PricebookEntry pbeTech = lxTestDataFactory.createPriceBookEntry(createDefaultPB.Id,pr2.Id);
        insert pbeTech;

        Product2 pr21 = new Product2(ProductCode='Technology',
                                     Name = 'COMPUTING SYSTEMS',
                                     Business_Entity__c = 'COMPUTING SYSTEMS',
                                     Product_Family_1__c='pf1',
                                     Product_Family_2__c='pf2',
                                     Product_Family_3__c='pf3', 
                                     Product_Family_4__c='pf4',
                                     isactive=true);
        insert pr21;
        
        
        //Creating Technology Line 
        OpportunityLineItem oli1 = new OpportunityLineItem();
        oli1.Mix__c= 100;
        oli1.Business_Entity__c = 'COMPUTING SYSTEMS';
        oli1.Product2Id = pr2.id;
        oli1.OpportunityId=oppty1.Id;
        oli1.PricebookEntryId=pbeTech.id;
        oli1.Quantity=1;
        oli1.Product_Family__c='pf1';
        oli1.Opportunity_Line_Value__c = 100;
        insert oli1;
        
        
        OpportunityLinesSV__c oppLineSSV = new OpportunityLinesSV__c();
                oppLineSSV.Technology_Service__c = oli1.Product2Id;
                oppLineSSV.Opportunity__c = oppty1.Id;
                oppLineSSV.Software_Specialist__c = userInfo.getUserId();
                oppLineSSV.Opportunity_Stage__c = '2 - Qualification';    
                oppLineSSV.Expected_Book_Date__c = system.today();  
                oppLineSSV.Expected_000_Value__c = 0;
                oppLineSSV.Product_Family__c = oli1.Product_Family__c;
                oppLineSSV.Product_Code__c = 'Technology';//oli1.PriceBookEntry.ProductCode;
        		oppLineSSV.recordtypeId = ObjectRecordTypeIds__c.getInstance().Architecture_Specialist_Record_Type__c;
                 insert oppLineSSV;
        
        lxSpecializedViewSummaryController.getSummaryViewList(oppty1.Id);
    }
    
    @isTest
    static void testOptyLinesSSV8() {
        //bypass validation rules
        Utilities.setIsTestMethod(true);
        Utilities.setValidationSkip(true);
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Cisco_ADMIN' Limit 1];
        User usr = lxTestDataFactory.createSingleUser(p.Id);
        insert usr;
        
        Account acct1 = null;
        
        system.runAs(usr){
            
            lxTestDataFactory.createCustomSettings();
            acct1 = lxTestDataFactory.createChannelAccount(usr.Id);
            insert acct1;
        }
        
       
        //Retrieveing Current Date
        Date vCloseDate = System.today();
        
        //Get users default currency
        User currentUser = [select defaultCurrencyIsoCode from User where Id = :UserInfo.getUserId()];
        
        //Query for Pricebook2
        String defaultPricebookId;
        Pricebook2 createDefaultPB = new Pricebook2(name='Standard Price Book', isActive=true);
        insert createDefaultPB;
        defaultPricebookId = createDefaultPB.Id;
        //Create Opportunity 
        Opportunity oppty1 = new Opportunity(name='Test1',Accountid=acct1.id, StageName='1 - Prospect',
                                             CloseDate= vCloseDate-1,Competitors__c = 'A10 Networks',Expected_Product__c=2,
                                              Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode);
        oppty1.Expected_Service__c = 0;
        oppty1.Enterprise_Agreement_Opportunity__c= 'YES';
        oppty1.Expected_Product__c = 10;        
        insert oppty1;
        
        //Summary View logic
        lxSpecializedViewSummaryController.getSummaryViewList(oppty1.Id);

        //Create new Technology and Service                                
        Product2 pr2 = new Product2(ProductCode='Technology',
                                    Name = 'COMPUTING SYSTEMS',
                                    Business_Entity__c = 'COMPUTING SYSTEMS',
                                    Product_Family_1__c='pf1',
                                    Product_Family_2__c='pf2',
                                    Product_Family_3__c='pf3', 
                                    Product_Family_4__c='pf4',
                                    isactive=true);
        insert pr2;
        
        PricebookEntry pbeTech = lxTestDataFactory.createPriceBookEntry(createDefaultPB.Id,pr2.Id);
        insert pbeTech;
        
        Product2 pr21 = new Product2(ProductCode='Technology',
                                     Name = 'COMPUTING SYSTEMS',
                                     Business_Entity__c = 'COMPUTING SYSTEMS',
                                     Product_Family_1__c='pf1',
                                     Product_Family_2__c='pf2',
                                     Product_Family_3__c='pf3', 
                                     Product_Family_4__c='pf4',
                                     isactive=true);
        insert pr21;
        
        
        //Creating Technology Line 
        OpportunityLineItem oli1 = new OpportunityLineItem();
        oli1.Mix__c= 100;
        oli1.Business_Entity__c = 'COMPUTING SYSTEMS';
        oli1.Product2Id = pr2.id;
        oli1.OpportunityId=oppty1.Id;
        oli1.PricebookEntryId=pbeTech.id;
        oli1.Quantity=1;
        oli1.Product_Family__c='pf1';
        oli1.Opportunity_Line_Value__c = 100;
        insert oli1;
        
        
        OpportunityLinesSV__c oppLineSSV = new OpportunityLinesSV__c();
                oppLineSSV.Technology_Service__c = oli1.Product2Id;
                oppLineSSV.Opportunity__c = oppty1.Id;
                oppLineSSV.Incubation_Specialist__c = userInfo.getUserId();
                oppLineSSV.Opportunity_Stage__c = '2 - Qualification';    
                oppLineSSV.Expected_Book_Date__c = system.today();  
                oppLineSSV.Expected_000_Value__c = 100;
                oppLineSSV.Product_Family__c = oli1.Product_Family__c;
                oppLineSSV.Product_Code__c = 'Technology';//oli1.PriceBookEntry.ProductCode;
        		oppLineSSV.recordtypeId = ObjectRecordTypeIds__c.getInstance().Architecture_Specialist_Record_Type__c;
                 insert oppLineSSV;
        
        lxSpecializedViewSummaryController.getSummaryViewList(oppty1.Id);
    }
    /*
    @isTest
    static void testOptyLinesSSV9() {
        //bypass validation rules
        Utilities.setIsTestMethod(true);
        Utilities.setValidationSkip(true);
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Cisco_ADMIN' Limit 1];
        User usr = lxTestDataFactory.createSingleUser(p.Id);
        insert usr;
        
        Account acct1 = null;
        
        system.runAs(usr){
            
            lxTestDataFactory.createCustomSettings();
            acct1 = lxTestDataFactory.createChannelAccount(usr.Id);
            insert acct1;
        }
        
       
        //Retrieveing Current Date
        Date vCloseDate = System.today();
        
        //Get users default currency
        User currentUser = [select defaultCurrencyIsoCode from User where Id = :UserInfo.getUserId()];
        
        //Query for Pricebook2
        String defaultPricebookId;
        Pricebook2 createDefaultPB = new Pricebook2(name='Standard Price Book', isActive=true);
        insert createDefaultPB;
        defaultPricebookId = createDefaultPB.Id;
        //Create Opportunity 
        Opportunity oppty1 = new Opportunity(name='Test1',Accountid=acct1.id, StageName='1 - Prospect',
                                             CloseDate= vCloseDate-1,Competitors__c = 'A10 Networks',Expected_Product__c=2,
                                              Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode);
        oppty1.Expected_Service__c = 0;
        oppty1.Enterprise_Agreement_Opportunity__c= 'NO';
        oppty1.Expected_Product__c = 10;        
        insert oppty1;
        
        //Summary View logic
        lxSpecializedViewSummaryController.getSummaryViewList(oppty1.Id);

        //Create new Technology and Service                                
        Product2 pr2 = new Product2(ProductCode='Technology',
                                    Name = 'COMPUTING SYSTEMS',
                                    Business_Entity__c = 'COMPUTING SYSTEMS',
                                    Product_Family_1__c='pf1',
                                    Product_Family_2__c='pf2',
                                    Product_Family_3__c='pf3', 
                                    Product_Family_4__c='pf4',
                                    isactive=true);
        insert pr2;
        
        PricebookEntry pbeTech = lxTestDataFactory.createPriceBookEntry(createDefaultPB.Id,pr2.Id);
        insert pbeTech;
        
        Product2 pr21 = new Product2(ProductCode='Technology',
                                     Name = 'COMPUTING SYSTEMS',
                                     Business_Entity__c = 'COMPUTING SYSTEMS',
                                     Product_Family_1__c='pf1',
                                     Product_Family_2__c='pf2',
                                     Product_Family_3__c='pf3', 
                                     Product_Family_4__c='pf4',
                                     isactive=true);
        insert pr21;
        
        
        //Creating Technology Line 
        OpportunityLineItem oli1 = new OpportunityLineItem();
        oli1.Mix__c= 100;
        oli1.Business_Entity__c = 'COMPUTING SYSTEMS';
        oli1.Product2Id = pr2.id;
        oli1.OpportunityId=oppty1.Id;
        oli1.PricebookEntryId=pbeTech.id;
        oli1.Quantity=1;
        oli1.Product_Family__c=NULL;
        oli1.Opportunity_Line_Value__c = 100;
        insert oli1;
        
        
        OpportunityLinesSV__c oppLineSSV = new OpportunityLinesSV__c();
                oppLineSSV.Technology_Service__c = oli1.Product2Id;
                oppLineSSV.Opportunity__c = oppty1.Id;
                oppLineSSV.Incubation_Specialist__c = userInfo.getUserId();
                oppLineSSV.Opportunity_Stage__c = '2 - Qualification';    
                oppLineSSV.Expected_Book_Date__c = system.today();  
                oppLineSSV.Expected_000_Value__c = 100;
                oppLineSSV.Product_Family__c = oli1.Product_Family__c;
                oppLineSSV.Product_Code__c = 'Technology';//oli1.PriceBookEntry.ProductCode;
        		oppLineSSV.recordtypeId = ObjectRecordTypeIds__c.getInstance().Architecture_Specialist_Record_Type__c;
                 insert oppLineSSV;
        
        lxSpecializedViewSummaryController.getSummaryViewList(oppty1.Id);
    }*/
    
 }