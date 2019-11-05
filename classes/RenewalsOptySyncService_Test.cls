@IsTest
private class RenewalsOptySyncService_Test {
    @isTest
    public static void syncOptyTest()
    {
        
        User newUser = Renewals_TestUtility.getUser('opssuser', true);
        
        Account newAccount = null;
        List<Opportunity> oppList = null;
        Map<String, List<OpportunityLineItem>> mapOppList = null;
        system.runAs(newUser){
            ObjectRecordTypeIds__c orIds = new ObjectRecordTypeIds__c(AccountChannelRecordTypeId__c = '0123000000004aV');
            insert orIds;
            
            Org_Constants__c oc = new Org_Constants__c(prod_value__c = '00e30000000dcbfAAA,00e30000000dfUEAAY,00e30000000eca0AAA,00e30000000qiJjAAI,00e30000000dcbgAAA,00e30000000rrZwAAI',
                                                       Key__c = 'Oppty: ProfileIds to skip Triggers');
            insert oc;
            
            ProfileID__c profileIds = new ProfileID__c(Cisco_Renewals__c = '00e34000001CQnp');
            insert profileIds;
            
            Deal_ID_Queue__c mc = new Deal_ID_Queue__c(Name = 'Deal ID Queue 1', Deal_ID_Queue_Start__c  = 61000000, Deal_ID_Queue_Stop__c = 70000000);
            insert mc;
            
            newAccount = Renewals_TestUtility.getAccount('acc',false);
            newAccount.recordtypeid = '0123000000004aUAAQ';
            newAccount.Type = 'End-User';
            insert newAccount;
            
            mapOppList = new Map<String, List<OpportunityLineItem>>();
            oppList = new List<Opportunity>();
            for(Integer i = 1; i<4; i++){
                oppList.add(createOpportunity(System.Today(),string.valueof(i),newUser.Id,newAccount.Id));
            }
            insert oppList;
            
            Product2 prod = new Product2(Name = 'Test Prouct', Family = 'Hardware',ProductCode ='Service');
            insert prod;
            Product2 prod1 = new Product2(Name = 'Test Prouct1', Family = 'Hardware',ProductCode ='Technology');
            insert prod1;
            ID pricebookId = Test.getStandardPricebookId();
            PricebookEntry standardPrice = new PricebookEntry(Pricebook2ID = pricebookId, Product2Id = prod1.Id, UnitPrice = 1000.0, IsActive = true);
            insert standardPrice; 
            PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2ID = pricebookId, Product2Id = prod.Id, UnitPrice = 1000.0, IsActive = true);
            insert standardPrice1; 
            
            List<OpportunityLineItem> oppLineItemList = null;
            
            for(Integer i = 1; i< 4; i++){
                oppLineItemList = new List<OpportunityLineItem>();
                for(Integer j = 0; j<2; j++){
                    if(j == 0){
                        oppLineItemList.add(createOppItem('Technology', standardPrice.Id, oppList[i-1].Id));
                    }else{
                        oppLineItemList.add(createOppItem('Service', standardPrice.Id, oppList[i-1].Id));
                    }
                }
                mapOppList.put(String.valueof(i), oppLineItemList);    
            }
            insert oppLineItemList;
        }
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/renewals/optysync/';
        request.httpMethod = 'POST';
        
        RestContext.request = request;
        
        RenewalsOptySyncService.syncOpty(oppList, mapOppList);
        
    }
    
    public static Opportunity createOpportunity(Date dToday, String sourceOppId, Id userId, Id accountId){
        Opportunity Opp = new Opportunity();
        Opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewals Opportunity').getRecordTypeId();
        Opp.Name='Oppty_'+String.valueof((Math.random() * 10))+String.valueof((Math.random() * 100));
        Opp.StageName='1 - Prospect';
        Opp.Start_Date__c=dToday;
        Opp.End_Date__c=dToday.addDays(30);
        Opp.CloseDate=dToday.addYears(2);
        Opp.Position__c='Renewal Forecast Position';
        Opp.Opportunity_Status__c='Active';
        Opp.Forecast_Status__c='Forecastable';
        Opp.Opportunity_Owner_AM__c=userId;
        Opp.OwnerId=userId;
        Opp.Description='This renewal opportunity is part of Oppty Sync Impl';
        Opp.AccountId=accountId;
        Opp.Partner_Required__c=true;
        Opp.Installed_Base__c='Software and Services Renewal';
        Opp.Service_Source__c='Renewal';
        Opp.Source_Opp_ID__c=sourceOppId;
        Opp.Data_Source_Name__c='CX';
        Opp.CurrencyIsoCode='USD';
        opp.skipValidations__c = true;
        return opp;
    }
    
    public static OpportunityLineItem createOppItem(String prodCode, Id priceBookId, Id OppId){
        OpportunityLineItem oppItem = new OpportunityLineItem();
        oppItem.Service_Category__c='';
        oppItem.Service_Level__c='';
        oppItem.Product_Family__c = '';
        oppItem.Product_Code__c=prodCode;
        oppItem.Prior_ATR__c=Math.random() * 100;
        oppItem.Prior_TCV__c=0;
        oppItem.Prior_Term__c=Math.random() * 100;
        oppItem.Data_Source_Name__c='CX';
        oppItem.PricebookEntryId = priceBookId;
        oppItem.OpportunityId = oppId;
        oppItem.Source_Opp_Line_Item_ID__c='';
        return oppItem;
    }
}