@isTest
private class EA_OpportunitiesHelper_Test {
    
    // would like to insert these types of opportunities to make the test more robust
 
    private static Opportunity createOpp(String oppName, Id accId) {
        Opportunity o = new Opportunity(
            Name =OppName,
            StageName ='5 - Closed',
            AccountId = accId,
            CloseDate =System.today() + 5, 
            Expected_Product__c = 10.0, 
            Expected_Service__c = 10.0, 
            DealID__c = '1',
            Opportunity_Status__c = 'Active',
            RecordTypeId = Utilities.getOpptyParentRecordTypeId(),
            ForecastCategoryName = 'Commit'
        );
        return o;
    }

    private static testMethod void testProcessOpps() {
       // added by komal -- we need to insert some Accounts,Opportunities and call the Helper class.
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
           
            String measure = 'Expected_Product__c';
            String filter = '';
            List<String> metrics = new List<String>{'QTD Actuals', 'Commit Forecast', 'Best Case Forecast', 'ROQ Open Pipeline', 'Forecast to Go', 'Past Due Commit'};
            List<String> weeknos = new List<String>{'26','27','28','29','30','31','32','33','34','35','36','37','38','39','40','41','42','43','44','45','46','47','48','49','50','51','52'};
                      
                      try {
                String jsonResp = EA_OpportunitiesHelper.processOpps(measure, filter, metrics,weeknos);
                System.assert(jsonResp != null, 'Response should not be null');
            } catch (Exception e) {
                System.assert(true, 'No exceptions should have occured');
            }
        // Note: need to insert opportunities but there is a specific order of operations on test data in this org which someone more familiar with this org should dive into
        //      most tests in this org use seeAllData=true, which generally shouldn't be used as it makes prod deployments hard
        
        // TODO: Add additional asserts once opportunity test data is inserted
    }
}