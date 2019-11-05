/************************************************************************************************************************************
Name    : batchUpdateOpptLine_Test 
Author  : shasheik
Purpose : Test class for batchUpdateOpptLine class
Created Date: 11/04/2019
Modification History: 

*************************************************************************************************************************************/
@isTest
global class batchUpdateOpptLine_Test {

    public static testMethod void updateOpptyLine(){
     
        User admin = CEE_TestUtility.getUser('admin', true);
        system.Runas(admin) {
        
            List<Org_Constant_CS__c> OrgCSlist = new List<Org_Constant_CS__c>();
            
              //Insert record in Object Record type custom setting for Account creation
            ObjectRecordTypeIds__c objR = new ObjectRecordTypeIds__c();
            objR.Opportunity_Parent_Mobile_RecordTypeId__c = '01234000000GGKw';
            insert objR;
            
            ProfileID__c pf = new ProfileID__c();
            pf.Cisco_Renewals__c = '00ec0000000QmlF';
            pf.Cisco_PSS__c = '00e30000000rrZw';       
            insert pf;
            
            //Create Org constant required for opportunity creation
            Org_Constants__c  orgC = new Org_Constants__c();
            orgC.Key__c = 'Oppty: ProfileIds to skip Triggers';
            orgC.prod_value__c = 'For testing';
            orgC.Type__c = 'URL';
            insert orgC;
                              
            Org_Constant_Custom_Settings__c orgCS = new Org_Constant_Custom_Settings__c();
            orgCS.enddate__c =  DateTime.ValueofGmt('2018-02-01 02:38:00Z') ;
            orgCS.recordTypeId__c = '0123000000003yk';
            orgCS.daysCount__c = 30;
            orgCS.startDate__c = DateTime.ValueofGmt('2018-01-01 02:38:00Z') ;
            insert orgCS;   
   /*   
            Org_Constant_Custom_Settings__c orgCS1 = new Org_Constant_Custom_Settings__c();
            orgCS1.enddate__c =  DateTime.ValueofGmt('2018-02-01 02:38:00Z') ;
            orgCS1.recordTypeId__c = '0123000000003yk';
            orgCS1.startDate__c = DateTime.ValueofGmt('2018-01-01 02:38:00Z') ;
            insert orgCS1; 
   */         
            String ParentRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Parent Opportunity').getRecordTypeId();
            
            Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
            insert customPB;
             
            Product2 prod = new Product2(Name = 'Enterprise Switching-Ent. Switching - Core', Business_Entity__c = 'Enterprise Switching',CurrencyIsoCode='USD',isActive=true,ProductCode='Technology',Product_Family_1__c='Education Series for Stargazer;Adelphi Education;C9500;Cat9K AGG Version;C6800 Modular PF;EBBU Cetus PF;C6000;c5000;4KToR 4900 series;C4500FIXED;C3000;Backbone ELA PF;Cat 3K fiber',Sub_Business_Entity_Name__c='Enterprise Switching - Core',Sub_Business_Entity__c='Ent. Switching - Core', Unique_BE_SubBE__c ='Enterprise Switching-Ent. Switching - Core-Technology');
            insert prod;
            
            Product_Family__c prodfamly = new Product_Family__c(Name='C9500', Product_Family_Description__c='C9500', Product__c=prod.Id, Enterprise_Agreement_Opportunity__c='Mixed', IsActive__c=true, Product_Family_Status__c='ACTIVE',Product_with_Product_Family__c='Enterprise Networking-Enterprise Switching - Core-C9500', Searchable__c='Yes');
            insert prodfamly;
            
            PricebookEntry pbID = new PricebookEntry(
            Pricebook2Id = customPB.Id, Product2Id = prod.Id,
            UnitPrice = 12000, IsActive = true,
            BE_Sub_BE_Currency_ProductCode__c='AS-S-ANALYTICS SVCS-USD-Service');
            insert pbID;
            
            //Create new Accounts
            Account acc = GenericStaticTestData.getTestEndUserAccountRecordRed();
            Account acc1 = GenericStaticTestData.gettestChannelAccountRecord1();
            
            //Create new opportunity
            Opportunity oppty1 = new Opportunity(name='Test', accountId = acc.id, StageName='2 - Qualified', CloseDate=System.today() + 50, Expected_Product__c=10.0,
                                                error_description__c='error', DealID__c='1', Opportunity_Status__c='Active', recordtypeId=orgCS.recordTypeId__c , Opportunity_Owner_AM__c =userinfo.getUserId(),
                                                Primary_Partner__c = acc1.id, Competitors__c = 'A10 Networks', Is_Product_Quote_Integrated__c = null, Is_Service_Quote_Integrated__c = null ); 
            insert oppty1;   
            
           List<OpportunityLineItem> optyLineitemslist = new List<OpportunityLineItem>();
            
           OpportunityLineItem optylneItm = new OpportunityLineItem(
                OpportunityId = oppty1.id,
                Business_Entity__c ='Enterprise Switching',
                //ProductCode ='Technology',
                Product_Family__c ='C9500',
                PricebookEntryId  = pbID.Id,
                Product2Id = prod.Id,
                product_family_ref__c = null,
                Mix__c=100.0,
                Opportunity_Line_Value__c = 100                       
          ); 
           optyLineitemslist.add(optylneItm); 

           insert optyLineitemslist;            
        }

       //Fetch Opportunity id from test setup
       Opportunity oppty = [select id from Opportunity where name = 'Test' limit 1];
        
       List<OpportunityLineItem> opLineitemslist = [select id, PricebookEntry.Product2Id,Product_Family__c,PriceBookEntry.ProductCode,product_family_ref__c from OpportunityLineItem where OpportunityId =:oppty.Id ];       
       
       Test.StartTest();
       
       batchUpdateOpptLine opptylineBatch = new batchUpdateOpptLine(); 
       Database.executeBatch(opptylineBatch);
        
       system.schedule('Optylineitemsupdate JOB', '0 0 * * * ?', opptylineBatch );
           
       Test.StopTest();           
    
    }
}