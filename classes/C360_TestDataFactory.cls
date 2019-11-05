/************************************************************************************************************************************
Name    : C360_TestDataFactory
Author  : C360 Dev team
Purpose : Test Data factory to prepare data set necessary for C360 project test class 
Date    : 28/06/2019
Change History : none 
*************************************************************************************************************************************/

public class C360_TestDataFactory {
    
    // Used in Customer Inventory and Services Sold
    public static  List<C360_API_Settings__c> prepareAPISettings(){
        List<C360_API_Settings__c> apiSettings = new List<C360_API_Settings__c>();
        C360_API_Settings__c  nonProdcustomInvApi = new C360_API_Settings__c();
        nonProdcustomInvApi.Name='NonProductionCustomerInventory';
        nonProdcustomInvApi.EndPointURL__c='https://apx-test.cisco.com/it/sales/xrm/c360consoledata/1.0/purchasetab/customerInventory';
        nonProdcustomInvApi.Grant_Type__c='client_credentials';
        nonProdcustomInvApi.Client_Id__c='45f45460fb814b338680c5caa591c8ce';
        nonProdcustomInvApi.Client_Secret__c='45daaB4b98F84aCBA75e27C81702502e';
        nonProdcustomInvApi.Auth_EndPointURL__c ='https://cloudsso-test.cisco.com/as/token.oauth2';
        nonProdcustomInvApi.Timeout__c=60000;
        apiSettings.add(nonProdcustomInvApi);
        
        C360_API_Settings__c  prodcustomInvApi = new C360_API_Settings__c();
        prodcustomInvApi.Name='CustomerInventory';
        prodcustomInvApi.EndPointURL__c='https://apx-test.cisco.com/it/sales/xrm/c360consoledata/1.0/purchasetab/customerInventory';
        prodcustomInvApi.Grant_Type__c='client_credentials';
        prodcustomInvApi.Client_Id__c='45f45460fb814b338680c5caa591c8ce';
        prodcustomInvApi.Client_Secret__c='45daaB4b98F84aCBA75e27C81702502e';
        prodcustomInvApi.Auth_EndPointURL__c ='https://cloudsso-test.cisco.com/as/token.oauth2';
        prodcustomInvApi.Timeout__c=60000;
        apiSettings.add(prodcustomInvApi);
        
        
        C360_API_Settings__c  nonProdServiceApi = new C360_API_Settings__c();
        nonProdServiceApi.Name='NonProductionServiceSold';
        nonProdServiceApi.EndPointURL__c='https://apx-test.cisco.com/it/sales/xrm/c360consoledata/1.0/purchasetab/serviceSold';
        nonProdServiceApi.Grant_Type__c='client_credentials';
        nonProdServiceApi.Client_Id__c='45f45460fb814b338680c5caa591c8ce';
        nonProdServiceApi.Client_Secret__c='45daaB4b98F84aCBA75e27C81702502e';
        nonProdServiceApi.Timeout__c=60000;
        nonProdServiceAPi.Auth_EndPointURL__c ='https://cloudsso-test.cisco.com/as/token.oauth2';
        apiSettings.add(nonProdServiceApi);
        
        C360_API_Settings__c  prodServiceApi = new C360_API_Settings__c();
        prodServiceApi.Name='ServiceSold';
        prodServiceApi.EndPointURL__c='https://apx-test.cisco.com/it/sales/xrm/c360consoledata/1.0/purchasetab/serviceSold';
        prodServiceApi.Grant_Type__c='client_credentials';
        prodServiceApi.Client_Id__c='45f45460fb814b338680c5caa591c8ce';
        prodServiceApi.Client_Secret__c='45daaB4b98F84aCBA75e27C81702502e';
        prodServiceApi.Timeout__c=60000;
        prodServiceApi.Auth_EndPointURL__c ='https://cloudsso-test.cisco.com/as/token.oauth2';
        apiSettings.add(prodServiceApi);
        return apiSettings;
    }
    
    public static List<C360TACCasesAPI__c> prepareTACNPSSettings(){
        List<C360TACCasesAPI__c> apiSettings = new List<C360TACCasesAPI__c>();
        C360TACCasesAPI__c caseAPICustomSetting = new C360TACCasesAPI__c();
        caseAPICustomSetting.Name = 'SandboxAPITAC';
        caseAPICustomSetting.BodyEndPointURL__c ='https://cloudsso-test.cisco.com/as/token.oauth2';
        caseAPICustomSetting.Client_Id__c='1d15552e316841a38a9385381be8522c';
        caseAPICustomSetting.TACendPointURL__c='https://apx-test.cisco.com/it/sales/xrm/tacvapi/v1.0/tacsolr/tac';
        caseAPICustomSetting.TAC_NPS__c = 'TAC';
        caseAPICustomSetting.Client_Secret__c   ='6ac2B694bCbB48978Ef0d118f67fA0bD';
        caseAPICustomSetting.Grant_Type__c  ='client_credentials';
        apiSettings.add(caseAPICustomSetting);
        C360TACCasesAPI__c caseAPICustomSetting1 = new C360TACCasesAPI__c();
        caseAPICustomSetting1.Name = 'ProductionAPITAC';
        caseAPICustomSetting1.BodyEndPointURL__c ='https://cloudsso-test.cisco.com/as/token.oauth2';
        caseAPICustomSetting1.Client_Id__c='1d15552e316841a38a9385381be8522c';
        caseAPICustomSetting1.TACendPointURL__c='https://apx-test.cisco.com/it/sales/xrm/tacvapi/v1.0/tacsolr/tac';
        caseAPICustomSetting1.TAC_NPS__c    = 'TAC';
        caseAPICustomSetting1.Client_Secret__c  ='6ac2B694bCbB48978Ef0d118f67fA0bD';
        caseAPICustomSetting1.Grant_Type__c ='client_credentials';
        apiSettings.add(caseAPICustomSetting1);
        
        C360TACCasesAPI__c caseAPICustomSetting2 = new C360TACCasesAPI__c();
        caseAPICustomSetting2.Name = 'SandboxAPINPS';
        caseAPICustomSetting2.BodyEndPointURL__c ='https://cloudsso-test.cisco.com/as/token.oauth2';
        caseAPICustomSetting2.Client_Id__c='08f093e9202244d198afbbc83e832f7d';
        caseAPICustomSetting2.TACendPointURL__c='https://apx-test.cisco.com/it/sales/xrm/npsapiv/v1.0/solr/nps';
        caseAPICustomSetting2.TAC_NPS__c    = 'NPS';
        caseAPICustomSetting2.Client_Secret__c  ='Ae694699E83549AF95352331446661fb';
        caseAPICustomSetting2.Grant_Type__c ='client_credentials';
        apiSettings.add(caseAPICustomSetting2);
        C360TACCasesAPI__c caseAPICustomSetting3 = new C360TACCasesAPI__c();
        caseAPICustomSetting3.Name = 'ProductionAPINPS';
        caseAPICustomSetting3.BodyEndPointURL__c ='https://cloudsso-test.cisco.com/as/token.oauth2';
        caseAPICustomSetting3.Client_Id__c='08f093e9202244d198afbbc83e832f7d';
        caseAPICustomSetting3.TACendPointURL__c='https://apx-test.cisco.com/it/sales/xrm/npsapiv/v1.0/solr/nps';
        caseAPICustomSetting3.TAC_NPS__c    = 'NPS';
        caseAPICustomSetting3.Client_Secret__c  ='Ae694699E83549AF95352331446661fb';
        caseAPICustomSetting3.Grant_Type__c ='client_credentials';
        apiSettings.add(caseAPICustomSetting3);
        return apiSettings;
    }
    // Used in MyAssignedCustomersApexControllerTest
    public static  List<C360ListViewIds__c> prepareListViewSettings(){
        List<C360ListViewIds__c> apiSettings = new List<C360ListViewIds__c>();
        C360ListViewIds__c  listviewsetting = new C360ListViewIds__c();
        listviewsetting.Name ='MyAssignCustomersListViews';
        listviewsetting.AllCustomers__c='00BM0000001L7t6';
        listviewsetting.Customer_Business_Units__c='00BM0000001L7sw';
        listviewsetting.Customers__c='00BM0000001L7sN';
        apiSettings.add(listviewsetting);
        return apiSettings;
        
    }
}