@istest(seeAlldata=true)
public class customerWinJSON_test{
    public static testmethod void getJsonStringmethod1(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Cisco_ADMIN']; 
        User u = new User(Alias = 'standt', Email='standarduser1@cisco.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles',Theatre__c='APJC-APAC', UserName='standarduser1@cisco.com');
        System.runAs(u){
            CustomerWinJSON.reqPay r = new CustomerWinJSON.reqPay();
            CustomerWinJSON.should s = new CustomerWinJSON.should();      
            CustomerWinJSON.childOptyLine2 c = new CustomerWinJSON.childOptyLine2();
            
            
            String json = '{'+
                '                    \"title\": \"Collab Spotlight\",'+
                '                    \"url\": \"https://salesconnect.cisco.com/open.html?h=PAGE-501\",'+
                '                    \"date\": \"2009-11-15T14:12:12\",'+
                '                    \"lastmodified\": ['+
                '                        \"2018-12-05T00:00:00.000-0600\"'+
                '                    ],'+
                '                    \"bizent\": ['+
                '                        \"Collaboration\"'+
                '                    ],'+
                '                    \"category\": \"saleshub\"'+
                '                }';
            List<String> jsonLst = new List<String>();
            jsonLst.add(json);
            
            Account acc = new Account();
            acc.name = 'Test Acc';
            acc.VMTOP__c='test';
            acc.LineofBusiness__c='enterprise';
            acc.Theatre__c='americas';
            acc.partner_locations_number__c = 10;
            insert acc;
            
            opportunity opp = new opportunity();
            
            opp.name = 'Test Opp';
            opp.stagename = 'Prospecting';
            opp.CloseDate = system.today()+2;
            opp.Competitors__c='arista';
            insert opp;
            
            
            Product2 prod = new Product2(Name = 'Laptop X200', Business_Entity__c = 'meraki',Sub_Business_Entity__c='test',
                                         Family = 'Hardware');
            insert prod;
            Id pricebookId = Test.getStandardPricebookId();
            
            PricebookEntry standardPrice = new PricebookEntry(
                Pricebook2Id = pricebookId, Product2Id = prod.Id,
                UnitPrice = 10000, IsActive = true);
            insert standardPrice;
            
            // Create a custom price book
            Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
            insert customPB;
            
            // 2. Insert a price book entry with a custom price.
            PricebookEntry customPrice = new PricebookEntry(
                Pricebook2Id = customPB.Id, Product2Id = prod.Id,
                UnitPrice = 12000, IsActive = true);
            insert customPrice;
            
            //OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, Product2Id,PriceBookEntry.Product2.Business_Entity__c,PriceBookEntry.
            //Product2.Sub_Business_Entity__c,opportunity.Competitors__c,opportunity.Account.VMTOP__c,opportunity.
            // Account.LineofBusiness__c,opportunity.Account.Theatre__c from OpportunityLineItem where OpportunityId=:recordId and Mix__c!=0);
            List<OpportunityLineItem> oplitem=[Select Product2Id,PriceBookEntry.Product2.Business_Entity__c,PriceBookEntry.Product2.Sub_Business_Entity__c,
                                               opportunity.Competitors__c,opportunity.Account.VMTOP__c,opportunity.Account.LineofBusiness__c,opportunity.Account.Theatre__c,product_Family__C,Product_Family_Ref__r.name from 
                                               OpportunityLineItem where Mix__c!=0 and PriceBookEntry.Product2.Sub_Business_Entity__c!='' and Product_Family_Ref__c!=null limit 1];
            // List<OpportunityLineItem> oplitem = new List<OpportunityLineItem>();
            
            // oplitem .add(OPplineitem2);
            
            // insert oplitem;
            
            CustomerWinJSON.getJsonString(oplitem);
            CustomerWinJSON.getJsonString2(oplitem);
            CustomerWinJSON.getJsonString3(oplitem);
            CustomerWinJSON.getJsonString4(oplitem);
            CustomerWinJSON.getJsonString5(oplitem);
            CustomerWinJSON.getJsonString6(oplitem);
            CustomerWinJSON.getJsonString7(oplitem);
            CustomerWinJSON.getSalesPresentationJson(oplitem);
            
        }    
    }
}