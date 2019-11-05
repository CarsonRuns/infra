/************************************************************************************************************************************
Name    : TestMockHttpGenerator
Author  : C360 Dev team
Purpose : This class prepares the mock response for Rest API callout in the system.
Date    : 28/06/2019
Change History : none 
*************************************************************************************************************************************/

@isTest
global class TestMockHttpGenerator implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest req) {
        System.debug('Inside TestMockHttpGenerator');
        System.debug('Request in TestMockHttpGenerator :'+req.getEndpoint());
        String endPoint = String.valueOf(req.getEndpoint());
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        if(req.getEndpoint().indexOf('/cloudsso-test.cisco.com/as/token.oauth2') > -1 ){
            system.debug('inside ef access token call');
            HttpResponse res = new HttpResponse();
            String s;
            s='{"token_type":"Bearer","expires_in":3599,"access_token":"O9ASKK2x9Qkb32jl50h8catafaod"}';
            res.setBody(s);
            res.setStatusCode(200);
            return res;
        }
        if(req.getEndpoint().indexOf('https://apx-test.cisco.com/it/sales/xrm/npsapiv/v1.0/solr/nps') > -1){
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            String s= '[{"business_unit_name": "BusinessTestAccount1", "business_unit_id": 108004, "nps_score": "100"},{"business_unit_name": "BusinessTestAccount2", "business_unit_id": 109132, "nps_score": "-100"}]';
            res.setBody(s);
            return res;
        }
        if(req.getEndpoint().indexOf('https://apx-test.cisco.com/it/sales/xrm/npsapiv/v1.0/solr/nps') > -1){
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            String s= '[{"total_count": 124,"Products": [{ "BUSINESS_UNIT_ID": 100386,"BUSINESS_UNIT_NAME": "AMP AU", "CUSTOMER_NAME": "AMP LTD","CUSTOMER_ID": 100040,  "SERVICE_TYPE": "TECHNICAL SUPPORT SERVICES", "SERVICE_GROUP": "CISCO SW SUPPORT SERVICE - SWSS", "CONTRACT_LINE_END_DATE": "2018-04-14T00:00:00","TOTAL_CONTRACT_VALUE": 181365.4806758121}, { "BUSINESS_UNIT_ID": 100386, "BUSINESS_UNIT_NAME": "AMP AU", "CUSTOMER_NAME": "AMP LTD", "CUSTOMER_ID": 100040, "SERVICE_TYPE": "TECHNICAL SUPPORT SERVICES", "SERVICE_GROUP": "CISCO SW SUPPORT SERVICE - SWSS", "CONTRACT_LINE_END_DATE": "2019-12-31T00:00:00","TOTAL_CONTRACT_VALUE": 156709.1497743765},}}';
            res.setBody(s);
            return res;
        }
        if(req.getEndpoint().indexOf('https://apx-test.cisco.com/it/sales/xrm/tacvapi/v1.0/tacsolr/tac') > -1){
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            String s= '[{"business_unit_name": "BusinessTestAccount1", "business_unit_id": 108004, "sev1": "4", "sev2": "0", "sev3": "2"},{"business_unit_name": "BusinessTestAccount2", "business_unit_id": 1234, "sev1": "1", "sev2": "1", "sev3": "1"}]';
            res.setBody(s);
            return res;
        }
        if(req.getEndpoint().indexOf('https://apx-test.cisco.com/it/sales/xrm/tacvapi/v1.0/tacsolr/tac') > -1){
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            String s= '[{"business_unit_name": "BusinessTestAccount1", "business_unit_id": 108004, "sev1": "4", "sev2": "0", "sev3": "2"},{"business_unit_name": "BusinessTestAccount2", "business_unit_id": 1234, "sev1": "1", "sev2": "1", "sev3": "1"}]';
            res.setBody(s);
            return res;
        }
        if(req.getEndpoint().indexOf(C360_Util.getConstant('CustomerInventory').EndPointURL__c) > -1){
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            String s= '{"total_count": 786,"Products": [{ "CUSTOMER_NAME": "FEDEX CORPORATION","CUSTOMER_ID": 100048,"BUSINESS_UNIT_ID": 100538,"BUSINESS_UNIT_NAME": "FEDEX US","PRODUCT_FAMILY": "DCMSAAS","PRODUCT_CLASSIFICATION": "Software","INSTALL_LOCATION": "NV,UNITED STATES","BUSINESS_ENTITY": "Computing Systems","BUSINESS_SUB_ENTITY": "Servers","INSTALLATION_DATE": "2019-05-01T00:00:00","PRODUCT_SALES_ORDER_NUMBER": "108319453","INVENTORY_QUANTITY": 108}],"ProductFamily": [{"PRODUCT_FAMILY": "PHONVOC"}],"ProductClassification": [{"PRODUCT_CLASSIFICATION": "Hardware"}],"BusinessEntity": [{"BUSINESS_ENTITY": "Enterprise Routing"}]}';
            res.setBody(s);
            return res;
            
        }
        if(req.getEndpoint().indexOf(C360_Util.getConstant('ServiceSold').EndPointURL__c) > -1){
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            String s= '{"total_count": 71,"Products": [{ "BUSINESS_UNIT_ID": 100514,"BUSINESS_UNIT_NAME": "AMP IN","CUSTOMER_NAME": "AMP LTD","CUSTOMER_ID": 100040,"SERVICE_TYPE": "TECHNICAL SUPPORT SERVICES","SERVICE_GROUP": "SMART NET TOTAL CARE","CONTRACT_LINE_END_DATE": "2019-05-31T00:00:00", "TOTAL_CONTRACT_VALUE": 46.0}], "ServiceType": [{"SERVICE_TYPE": "TECHNICAL SUPPORT SERVICES"}], "ServiceGroup" : [{"SERVICE_GROUP": "SMART NET TOTAL CARE"}] }';
            res.setBody(s);
            return res;
        }
        return null;
    }
}