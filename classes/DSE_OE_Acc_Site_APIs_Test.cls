@isTest(seeAllData = false)
private class DSE_OE_Acc_Site_APIs_Test {
    private static testmethod void TestAllAccountSite() {
        //sending the http request for account
        string strURL = System.URL.getSalesforceBaseURL().toExternalForm();
        string criteria = '%Cisco%';
        RestRequest req = new RestRequest();
        DSE_RestAPIResponseHandler res = new DSE_RestAPIResponseHandler();
        req.requestURI = strURL + '/services/apexrest/dse/allaccounts';
        req.httpMethod = 'POST';
        DSE_Utilities.DSE_Request dsereq = new DSE_Utilities.DSE_Request();
        dsereq.filter_criteria = 'UPPER(Name) LIKE UPPER(\'' + criteria + '\')';
        dsereq.locale = 'en_US';
        dsereq.oe_id = '123245';
        dsereq.page_no = 1;
        dsereq.page_size = 10;
        dsereq.sort_by = 'Name';
        dsereq.sort_order = 'asc';
        dsereq.time_zone = 'GMT-8:00';
        dsereq.user_id = 'musrivas';
        dsereq.pagination = 'Y';

        Test.startTest();
        DSE_All_Acc_Site_CTL.getAllOERelatedAccounts(dsereq);
        Test.stopTest();
    }
    private static testmethod void TestMyAccountSite() {
        //sending the http request for account
        string strURL = System.URL.getSalesforceBaseURL().toExternalForm();
        string criteria = '%Cisco%';
        RestRequest req = new RestRequest();
        DSE_RestAPIResponseHandler res = new DSE_RestAPIResponseHandler();
        req.requestURI = strURL + '/services/apexrest/dse/myaccounts';
        req.httpMethod = 'POST';
        DSE_Utilities.DSE_Request dsereq = new DSE_Utilities.DSE_Request();
        dsereq.filter_criteria = '=\'myaccounts\' AND UPPER(Name) LIKE UPPER(\'' + criteria + '\')';
        dsereq.locale = 'en_US';
        dsereq.oe_id = '123245';
        dsereq.page_no = 1;
        dsereq.page_size = 10;
        dsereq.sort_by = 'Name';
        dsereq.sort_order = 'asc';
        dsereq.time_zone = 'GMT-8:00';
        dsereq.user_id = 'musrivas';
        dsereq.pagination = 'Y';

        Test.startTest();
        DSE_My_Acc_Site_CTL.getAllOERelatedAccounts(dsereq);
        Test.stopTest();
    }
    private static testmethod void TestTokenGeneration() {
        Org_Constant_CS__c os = new Org_Constant_CS__c();
        os.name = 'DSEMuleToken';
        os.Production_Value__c = 'https://test.cisco.com';
        os.Non_Production_Value__c = 'https://test.cisco.com';
        insert os;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DSE_Http_Mule_Response_Test());
        DSE_Token_CTL.getAuthToken();
        Test.stopTest();

    }
}