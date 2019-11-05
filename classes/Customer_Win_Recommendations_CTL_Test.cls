//Test Class for Customer_Win_Recommendations_CTL

@isTest(SeeAllData = true)
private class Customer_Win_Recommendations_CTL_Test {
    private static testMethod void test(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Cisco_Sales']; 
        User u = new User(Alias = 'standt', Email='standarduser1@cisco.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles',Theatre__c='APJC-APAC', UserName='standarduser1@cisco.com');
        System.runAs(u){
        /*List<Opportunity> opty = [select id from Opportunity limit 3];
        Opportunity opty1 = opty[0];
        Opportunity opty2 = opty[1];
        Opportunity opty3 = opty[2];*/
        //Utilities.setIsTestMethod(true);
        //User currentUser = [select id from User where profileid=:Utilities.getTSNProfileId() and isactive=true limit 1];
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
        /* Profile p = [SELECT Id FROM Profile WHERE Name = 'Cisco_Admin' Limit 1];
        User admUser = new User(Additional_User_Permissions__c = 'Enable EndUser ACCTCreation', Alias = 'newUser', Email = 'batchJobOppty@cisco.com',
                               EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                               LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'batchJobOppty@cisco.com.testing', Theatre__c = 'Americas-US Commercial');
        insert admUser; 
          System.runAs(admUser){*/
        Id RecordTypeIdopportunity = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Parent Opportunity').getRecordTypeId();
        //Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('End-User').getRecordTypeId();
        //Account acc = new Account(Name='Acme1', BillingCity='San Francisco', RecordtypeId =Utilities.getAccountEndUserRecordTypeId());
        //RecordType recordID = [Select Id From RecordType where sObjectType = 'Opportunity' and Name = 'Parent Opportunity' and isactive = true limit 1];
        //System.runAs(currentUser){
        Test.startTest();
        //Account acc = new Account(Name = 'test',recordtypeid=devRecordTypeId ,CSCSiteID__c ='5555',CSCID__c = '5555',ownerid = admUser.id,AddressLine1__c='Test123',AddressLine1_English__c='Test231',AddressLine2__c='Testqa1',AddressLine2_English__c='Testqa123',City__c='UN',City_English__c='Test',State__c= 'AP',State_Province_English__c='ENDTESt',Country__c='INDIA',Country_English__c='INDIA',TOKENID__c='12333',ZipPostalCode__c='847733',Zip_Postal_Code_English__c='766644' );
        //insert acc;
        Utilities.setValidationSkip(true);
        Account acc= new Account(name='Test Account',BillingCity='San Francisco');
        //Account acc= new Account(name='TestAccount',Account_Status__c='Active (Registered)', recordTypeId=Utilities.getAccountChannelRecordTypeId());
        insert acc; 
        //Account acc = GenericStaticTestData.gettestChannelAccountRecord1();
        //System.debug(acc);
        opportunity opty1 = new opportunity();
        opty1.AccountId = acc.id;
        opty1.Theater__c = 'Americas-Canada';
        opty1.recordtypeid=RecordTypeIdopportunity ;
        //opty1.recordtypeid=recordID.id;
        opty1.Name= 'TestAccount';
        opty1.StageName ='2 - Qualification';
        opty1.CloseDate= System.today() + 50;
        opty1.Expected_Product__c=10.0;
        opty1.error_description__c='error';
        opty1.DealID__c='18022972';
        opty1.Opportunity_Status__c='active';
        opty1.Position__c='Americas lrpearso';
        opty1.CurrencyIsoCode = 'USD';
        opty1.Competitors__c = 'HPE';
        insert opty1;
        
        opportunity opty2 = new opportunity();
        opty2.AccountId = acc.id;
        opty2.Theater__c = 'Americas-Canada';
        opty2.recordtypeid=RecordTypeIdopportunity ;
        //opty2.recordtypeid=recordID.id;
        opty2.Name= 'TestAccount2';
        opty2.StageName ='2 - Qualification';
        opty2.CloseDate= System.today() + 50;
        opty2.Expected_Product__c=10.0;
        opty2.error_description__c='error';
        opty2.DealID__c='18022972';
        opty2.Opportunity_Status__c='active';
        opty2.Position__c='Americas lrpearso';
        opty2.CurrencyIsoCode = 'USD';
        opty2.Competitors__c = 'HPE';
        insert opty2;
        
        opportunity opty3 = new opportunity();
        opty3.AccountId = acc.id;
        opty3.Theater__c = 'Americas-Canada';
        //opty3.recordtypeid=recordID.id ;
        opty3.recordtypeid=RecordTypeIdopportunity ;
        opty3.Name= 'TestAccount3';
        opty3.StageName ='2 - Qualification';
        opty3.CloseDate= System.today() + 50;
        opty3.Expected_Product__c=10.0;
        opty3.error_description__c='error';
        opty3.DealID__c='18022972';
        opty3.Opportunity_Status__c='active';
        opty3.Position__c='Americas lrpearso';
        opty3.CurrencyIsoCode = 'USD';
        opty3.Competitors__c = 'HPE';
        insert opty3;
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        Product2 prod = new Product2(Name = 'Laptop X200', Family = 'Hardware',isActive=true,ProductCode='AS-200');
        insert prod;
        
        PricebookEntry pbID = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id,UnitPrice = 12000, IsActive = true);
        insert pbID;
        //Log_Headers__c logHeaderOpty = [Select Opportunity__c, Product2Ids__c from Log_Headers__c where Opportunity__c !=null Order by createdDate Desc limit 1];
        Product_Family__c objProductFamily=[Select Id,Name,IsActive__c,Product_Family_Description__c,Product_with_Product_Family__c,Searchable__c from Product_Family__c where IsActive__c=true and Searchable__c='Yes' and Product_with_Product_Family__c!=null limit 1];
        OpportunityLineItem olli = new OpportunityLineItem (Quantity=2, OpportunityId=opty2.id, TotalPrice=10, PriceBookEntryId =pbID.Id,Business_Entity__c='AS-S',Opportunity_Line_Value__c = 100, Mix__c = 10,Product_Family_Ref__c=objProductFamily.id); 
        insert olli ;
        Log_Headers__c logHeaderOpty = new Log_Headers__c(Opportunity__c=opty2.id,Product2Ids__c=prod.id,productFamilyids__c=objProductFamily.Name);
        Customer_Win_Recommendation__c cwRecommendation1 = new Customer_Win_Recommendation__c(Opportunity__c = opty1.id, Category__c = 'customerwins');
        insert cwRecommendation1;
        Customer_Win_Recommendation__c cwRecommendation2 = new Customer_Win_Recommendation__c(Opportunity__c = opty2.id, Category__c = 'saleshub');
        insert cwRecommendation2;
        Customer_Win_Recommendation__c cwRecommendation3 = new Customer_Win_Recommendation__c(Opportunity__c = opty3.id, Category__c = 'learningmaps');
        insert cwRecommendation3;
        Customer_Win_Recommendation__c cwRecommendation4 = new Customer_Win_Recommendation__c(Opportunity__c = opty1.id, Category__c = 'customerstories');
        insert cwRecommendation4;
        //Test.startTest();
        Customer_Win_Recommendations_CTL.getCustomerWinDetails(opty1.id, 5);
        Customer_Win_Recommendations_CTL.getCustomerWinDetailsByCategory(opty1.id);
        Customer_Win_Recommendations_CTL.preValidations(opty1.id);
        Customer_Win_Recommendations_CTL.getCustomerWinDetails(opty2.id, 5);
        Customer_Win_Recommendations_CTL.getCustomerWinDetailsByCategory(opty2.id);
        Customer_Win_Recommendations_CTL.preValidations(opty2.id);
        Customer_Win_Recommendations_CTL.getCustomerWinDetails(opty3.id, 5);
        Customer_Win_Recommendations_CTL.getCustomerWinDetailsByCategory(opty3.id);
        Customer_Win_Recommendations_CTL.preValidations(opty3.id);
        Customer_Win_Recommendations_CTL.preValidations(logHeaderOpty.Opportunity__c);
        Customer_Win_Recommendations_CTL.parseJsonResponse(opty2.id, jsonLst);
        Test.stopTest();
        }
    }
}
//}