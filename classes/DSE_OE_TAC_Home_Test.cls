@isTest (seeAllData = false)
private class DSE_OE_TAC_Home_Test
{
    @testSetup static void setupTestData() {
        List < sObject > osCS = Test.loadData(Org_Constant_CS__c.sObjectType,'GlobalTestOrgConstantCS');
        List < sObject > objRecCS = Test.loadData(ObjectRecordTypeIds__c.sObjectType,'GlobalTestObjectRecordTypeIds');
        List < sObject > tzcode = Test.loadData(DSE_TimeZone_Code__c.sObjectType, 'DSETimeZoneData'); //Custom Setting for Field Mapping
        List < sObject > localeformat = Test.loadData(DSE_Locale_Date_Time_Format__c.sObjectType, 'DSEDateFormatData'); //Custom Setting for Field Mapping
        List < sObject > accountsList= Test.loadData(Account.sObjectType, 'GlobalTestAccounts'); 
        List< Account> updateList = new List<Account>();
        
        for (Integer i = 0; i < accountsList.size(); i++) 
          { 
              Account acct = (Account) accountsList[i]; 
              acct.DSE_Time_Stamp__c = Date.today().addDays(-1);
              acct.OE_Id__c = '2423123523';
              updateList.add(acct);
          } 
        update updateList;
    }
    private static testmethod void TestHomepageTACCase()
    {
        Test.startTest();
        Test.setCurrentPageReference(New PageReference('Page.DSE_Home'));
        DSE_Home_Page_CTL dsehome= new DSE_Home_Page_CTL(); 
        dsehome.init();    
        Set<String> oeIDs = dsehome.getSetOEIDs();
        System.assertEquals(1,oeIDs.size());
        Test.stopTest();           
    }
    
    private static testmethod void TestAccountTACCase()
    {
        List<Account> acclst = [Select Id from Account Limit 2];
        Test.startTest();
        String json = '{"access_token":"bar","token_type":"abc","expires_in":"5352"}';
        //DSE_APIOAuthTokenParser dseapi = new DSE_APIOAuthTokenParser();
        DSE_APIOAuthTokenParser.parse(json);
        
        Test.setCurrentPageReference(New PageReference('Page.EloquaProspectProfilerLead'));
        System.currentPageReference().getParameters().put('Id',acclst[0].id );
        System.currentPageReference().getParameters().put('childAccId',acclst[1].id );
        
        ApexPages.Standardcontroller stdCtlAcc = New ApexPages.StandardController(acclst[0]);
        DSE_Main_CTE dsehome= new DSE_Main_CTE(stdCtlAcc); 
        dsehome.OEAccount();
        dsehome.getValidateUser();  
        Test.stopTest();              
    }
    
}