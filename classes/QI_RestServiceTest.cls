/************************************************************************************************************************************
Name    : QI_RestServiceTest 
Author  : Eric Pesch (epesch)
Purpose : Test for Quote Integration REST endpoint
Created Date: 12/09/2017 
Modification History: 
* Modified By - bodurais on 03.16.2018
* Description - Added logic to update Opportunity with BOM Integrated Quote id, Date, EA flag. 
***
*************************************************************************************************************************************/

@isTest
public class QI_RestServiceTest {
        
    @testSetup static void setup(){
        User admin = CEE_TestUtility.getUser('admin', true);
        system.Runas(admin) {
            String currencyIsoCode = 'USD';
            String service = 'Service';
            String technology = 'Technology'; 
            Product2[] p2 = new Product2[]{};
            //Create new product2                                 
            Product2 p2Tmp = new Product2(ProductCode=Technology,
                                                Name = 'TechName',
                                                Product_Family_1__c='pf1',
                                                Product_Family_2__c='pf2',
                                                Product_Family_3__c='pf3', 
                                                Product_Family_4__c='pf4',
                                                isactive=true);
            p2.add(p2Tmp);      
            insert p2;    
            //Create default pricebook    
            Pricebook2 createDefaultPB = new Pricebook2(name='default pricebook', isActive=true);
            insert createDefaultPB;
            
            //Create pricebook entry
            PricebookEntry pbeTech = new PricebookEntry();
            pbeTech.Pricebook2Id = createDefaultPB.id;
            pbeTech.Product2Id = p2[0].id;
            pbeTech.IsActive = true;
            pbeTech.UnitPrice = 100;
            insert pbeTech;  
            
            //Create Org constant required for opportunity creation
            Org_Constants__c  orgC = new Org_Constants__c();
            orgC.Key__c = 'Oppty: ProfileIds to skip Triggers';
            orgC.prod_value__c = 'For testing';
            orgC.Type__c = 'URL';
            insert orgC;
            
            //Fetch Opportunity record type id
            Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
            Map<String,Schema.RecordTypeInfo> OppRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();     
            Id rtId = OppRecordTypeInfo.get('Global Deal/Opportunity').getRecordTypeId();
                
            //Insert record in Object Record type custom setting for Account creation
            ObjectRecordTypeIds__c objR = new ObjectRecordTypeIds__c();
            objR.Opportunity_Parent_Mobile_RecordTypeId__c = '01234000000GGKw';
            insert objR;
            
            ProfileID__c profileIds = new ProfileID__c();
            profileIds.Cisco_Renewals__c = '00e34000001CQnp';
            profileIds.Cisco_PSS__c = '00e30000000rrZw';
            insert profileIds;
            
            //Insert records in Org Constants custom setting for Account creation
            List<Org_Constant_CS__c> OrgCSlist = new List<Org_Constant_CS__c>();
            
            Org_Constant_CS__c orgCS = new Org_Constant_CS__c();
            orgCS.Name = 'P360 Marketing Play Name';
            orgCS.Production_Value__c = 'Customer Intelligence';
            orgCS.Non_Production_Value__c = 'Customer Intelligence';
            
            Org_Constant_CS__c orgCS1 = new Org_Constant_CS__c();
            orgCS1.Name = 'P360 Target Architecture';
            orgCS1.Production_Value__c = 'Any/All Technologies';
            orgCS1.Non_Production_Value__c = 'Any/All Technologies';
            
            Org_Constant_CS__c orgCS2 = new Org_Constant_CS__c();
            orgCS2.Name = 'P360 Target Prospects Source';
            orgCS2.Production_Value__c = 'Cisco';
            orgCS2.Non_Production_Value__c = 'Cisco';
    
            OrgCSlist.add(orgCS);
            orgCSlist.add(orgCS1);
            orgCSlist.add(orgCS2);
            insert orgCSlist;
    
            //Create new Accounts
            Account acc = GenericStaticTestData.getTestEndUserAccountRecordRed();
            Account acc1 = GenericStaticTestData.gettestChannelAccountRecord1();
            
            //Create new opportunity
            Opportunity oppty = new Opportunity(name='Test', accountId = acc.id, StageName='2 - Qualified', CloseDate=System.today() + 50, Expected_Product__c=10.0,
                                                error_description__c='error', DealID__c='1', Opportunity_Status__c='Active', recordtypeId=rtId, 
                                                Primary_Partner__c = acc1.id, Competitors__c = 'A10 Networks'); 
            insert oppty;
        }

    } 
    
    static testMethod void testQIRestDoPost(){
        //Fetch pricebookEntry id from test setup
        PricebookEntry pbeTech = [select id, PriceBook2.Id from pricebookentry where pricebook2.Name = 'default pricebook' limit 1];                                
        //Fetch Opportunity id from test setup
        Opportunity oppty = [select id from Opportunity where name = 'Test' limit 1];                               
            
        //Create new opportunity line item required for deleting
        OpportunityLineItem oli1 = new OpportunityLineItem();
        oli1.Mix__c= 50;
        oli1.Business_Entity__c = 'COMPUTING SYSTEMS';
        oli1.OpportunityId=oppty.Id;
        oli1.PricebookEntryId=pbeTech.id;
        oli1.Quantity=1;              
        insert oli1;
        
        //Create new opportunity line item required for deleting            
        OpportunityLineItem oli2 = new OpportunityLineItem();
        oli2.Mix__c= 50;
        oli2.Business_Entity__c = 'COLLABORATION';
        oli2.OpportunityId=oppty.Id;
        oli2.PricebookEntryId=pbeTech.id;
        oli2.Quantity=1;              
        insert oli2; 
        
        //modify existing opportunity line item records for creation
        OpportunityLineItem oli3 = new OpportunityLineItem();
        oli3.Mix__c= 25;
        oli3.Business_Entity__c = 'COMPUTING SYSTEMS';
        oli3.OpportunityId=oppty.Id;
        oli3.PricebookEntryId=pbeTech.id;
        oli3.Quantity=1;              

        //modify existing opportunity line item records for creation            
        OpportunityLineItem oli4 = new OpportunityLineItem();
        oli4.Mix__c= 75;
        oli4.Business_Entity__c = 'COLLABORATION';
        oli4.OpportunityId=oppty.Id;
        oli4.PricebookEntryId=pbeTech.id;
        oli4.Quantity=1;              

    
        list<string> listOfDeleteIds = new list<string>();
        listOfDeleteIds.add(oli1.id);
        listOfDeleteIds.add(oli2.id);
            
        list<Opportunitylineitem> listOfOppLineItem = new list<Opportunitylineitem>();
        listOfOppLineItem.add(oli3);
        listOfOppLineItem.add(oli4);
        
        list<Opportunity> listOfOppty = new list<Opportunity>();
        listOfOppty.add(oppty);

       
        Blob reqBody = Blob.valueOf('{"Hello": "World"}');
        
        //Setup request
        RestRequest req = new RestRequest();
        req.requestURI = '/QI/Opportunities/bulk/';
        req.httpMethod = 'POST';
        
        //Setup Response
        RestResponse res = new RestResponse();
        
        //Assign to context
        RestContext.request = req;
        RestContext.response = res; 
        
        Test.startTest();
            
        QI_RestService.doPost(listOfDeleteIds, listOfOppLineItem, listOfOppty); 
                       
        Test.stopTest();
        
        System.assertEquals(201, res.statusCode);

    }   
    
    static testMethod void testQIRestDoPostWithError(){
        //Fetch pricebookEntry id from test setup
        PricebookEntry pbeTech = [select id, PriceBook2.Id from pricebookentry where pricebook2.Name = 'default pricebook' limit 1];                                
        //Fetch Opportunity id from test setup
        Opportunity oppty = [select id from Opportunity where name = 'Test' limit 1];                                   
            
        //Create new opportunity line item required for deleting
        OpportunityLineItem oli1 = new OpportunityLineItem();
        oli1.Mix__c= 50;
        oli1.Business_Entity__c = 'COMPUTING SYSTEMS';
        oli1.OpportunityId=oppty.Id;
        oli1.PricebookEntryId=pbeTech.id;
        oli1.Quantity=1;              
        insert oli1;   
        
        //Create new opportunity line item required for deleting            
        OpportunityLineItem oli2 = new OpportunityLineItem();
        oli2.Mix__c= 50;
        oli2.Business_Entity__c = 'COLLABORATION';
        oli2.OpportunityId=oppty.Id;
        oli2.PricebookEntryId=pbeTech.id;
        oli2.Quantity=1;              
        insert oli2; 
        
        //modify existing opportunity line item records for creation
        OpportunityLineItem oli3 = new OpportunityLineItem();
        oli3.Mix__c= 25;
        oli3.Business_Entity__c = 'COMPUTING SYSTEMS';
        oli3.OpportunityId=oppty.Id;
        oli3.PricebookEntryId=pbeTech.id;
        oli3.Quantity=1;              

        //modify existing opportunity line item records for creation            
        OpportunityLineItem oli4 = new OpportunityLineItem();
        oli4.Mix__c= 75;
        oli4.Business_Entity__c = 'COLLABORATION';
        oli4.OpportunityId=oppty.Id;
        oli4.PricebookEntryId=pbeTech.id;
        oli4.Quantity=1;              

        list<string> listOfDeleteIds = new list<string>();
        listOfDeleteIds.add(oli1.id);
        listOfDeleteIds.add(oli2.id);
           
        list<Opportunitylineitem> listOfOppLineItem = new list<Opportunitylineitem>();
        listOfOppLineItem.add(oli3);
        listOfOppLineItem.add(oli4);

        list<Opportunity> listOfOppty = new list<Opportunity>();
        listOfOppty.add(oppty);
        
        list<Opportunitylineitem> emptyListOfOppLineItem = new list<Opportunitylineitem>();
        
        Blob reqBody = Blob.valueOf('{"Hello": "World"}');
        
        //Setup request
        RestRequest req = new RestRequest();
        req.requestURI = '/QI/Opportunities/bulk/';
        req.httpMethod = 'POST';
        
        //Setup Response
        RestResponse res = new RestResponse();
        
        //Assign to context
        RestContext.request = req;
        RestContext.response = res; 
        
        Test.startTest();
        
        id invalidId = '00634000019dumm';
        
        //Pass empty list for Oppty lines
        QI_RestService.doPost(listOfDeleteIds, emptyListOfOppLineItem, listOfOppty);    
               
        //Pass invalid id to opportunity id field
        listOfOppLineItem[0].OpportunityId = invalidId;            
        QI_RestService.doPost(listOfDeleteIds, listOfOppLineItem, listOfOppty); 
        
        //Pass invalid id in delete id's list
        listOfDeleteIds.add(invalidId);        
        QI_RestService.doPost(listOfDeleteIds, listOfOppLineItem, listOfOppty);        
                           
        Test.stopTest();
        
        System.assertEquals(500, res.statusCode);

    }   
}