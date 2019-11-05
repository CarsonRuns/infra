/*
 * This class serves as the unit test for the NGCC_CRAddressValidationCallout class
 * @author: Daniel Pisciottano
*/
@isTest(SeeAllData=true)
private class NGCC_CRAddressValidationCallout_Test {
    private static String leadRecordTypeId = ObjectRecordTypeIds__c.getInstance().Marketing_Lead_RecordType__c;
    private static Lead testLead = new Lead();
    /* Method that creates a test Lead object */
    static void initializeLead(){
        testLead.RecordTypeId = leadRecordTypeId;
        testLead.FirstName = 'John';
        testLead.LastName = 'Doe';
        testLead.Company = 'Cisco Systems';
        testLead.Address_Line_1__c = '1535 Caraleigh Mills Court';
        testLead.Address_Line_2__c = 'Apt 205';
        testLead.CustomCity__c = 'Raleigh';
        testLead.CustomState__c = 'NC';
        testLead.CustomCountry__c = 'US';
    }
    
    static testMethod void CRAddressValidationCalloutTest(){
        initializeLead();
        
        Test.setMock(HttpCalloutMock.class, new NGCC_CRAddressValidationCallout_Mock());
        
        // Create an http response that uses the mock callout
        HttpResponse res = NGCC_CRAddressValidationCallout.makeRequestNow(testLead);
        System.assert(res.getHeader('Content-Type') == 'text/xml');
        System.assertEquals(200, res.getStatusCode());
        
        // use the returned HttpResponse to test the processXML method where it should return a successful result
        String result = NGCC_CRAddressValidationCallout.processXML(res, testLead);
        System.Debug('CR Response: '+result);
        Lead newLead = (Lead)JSON.deserialize(result, Lead.class);
        System.assert(!result.contains('error'), 'JSON returned contains an error message when it should not. Resul:'+result);
        System.assert(newLead.CustomCity__c == 'Raleigh', 'City does not match expected result. Expected: Raleigh - Returned: '+newLead.CustomCity__c);
        System.assert(newLead.Address_Line_2__c == null, 'Address Line 2 does not match expected result. Expected: null - Returned: '+newLead.Address_Line_2__c);
        
        // Create a fake response that has an error in the XML 
        HttpResponse testRes = new HttpResponse();
        res.setHeader('Content-Type', 'text/xml');
        res.setBody('<?xml version=\'1.0\' encoding=\'UTF-8\'?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><AcknowledgeParty xmlns="http://www.cisco.com/cixs2.0/oagis" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ns="http://www.openapplications.org/oagis/9" releaseID="CIXS-2.0" versionID="3.0" systemEnvironmentCode="STAGE" languageCode="en-US"><ns:ApplicationArea><ns:Sender><ns:AuthorizationID>xxcrrts</ns:AuthorizationID></ns:Sender><ns:CreationDateTime>2014-04-07</ns:CreationDateTime><ns:BODID>33331</ns:BODID></ns:ApplicationArea><DataArea><ns:Acknowledge><ns1:OriginalApplicationArea xmlns:ns1="http://www.openapplications.org/oagis/9" xmlns:ns0="http://www.cisco.com/cixs2.0/oagis"><ns1:Sender><ns1:LogicalID>null</ns1:LogicalID><ns1:ComponentID>Cleansing-CRES-GUI</ns1:ComponentID><ns1:ReferenceID>crrts</ns1:ReferenceID><ns1:AuthorizationID>xxcrrts</ns1:AuthorizationID></ns1:Sender><ns1:CreationDateTime>2014-04-07T19:18:49.057</ns1:CreationDateTime><ns1:BODID>33331</ns1:BODID></ns1:OriginalApplicationArea><ResponseCriteria><ns:ResponseExpression actionCode="FAILURE" /><BODFailureMessage><ErrorProcessMessage><ns:Description>COMPLETE, SYSTEM_ERROR, GEO_VALID</ns:Description><ns:ReasonCode>FAILURE</ns:ReasonCode><Status>ERROR</Status></ErrorProcessMessage><NounFailureMessage><ErrorProcessMessage><ns:Description>[Cleansing internal error]ORA-01422: exact fetch returns more than requested number of rows</ns:Description><ns:ReasonCode>-99</ns:ReasonCode><Status>SYSTEM_ERROR</Status><Component>CLEANSING</Component><Category>SYSTEM</Category></ErrorProcessMessage></NounFailureMessage><NounSuccessMessage><SuccessProcessMessage><ns:Description xsi:nil="true" /><ns:ReasonCode xsi:nil="true" /><Status>COMPLETE</Status><Component>CLEANSING</Component><Category xsi:nil="true" /></SuccessProcessMessage><SuccessProcessMessage><ns:Description xsi:nil="true" /><ns:ReasonCode xsi:nil="true" /><Status>GEO_VALID</Status><Component>GEO_VALIDATION</Component><Category xsi:nil="true" /></SuccessProcessMessage></NounSuccessMessage></BODFailureMessage></ResponseCriteria></ns:Acknowledge><Party><ns:Name>CISCO SYSTEMS</ns:Name><Locations><Location><Addresses><Address><AddressLine sequenceName="AddressLine1">1535 CARALEIGH MILLS COURT</AddressLine><AddressLine sequenceName="AddressLine2">#205</AddressLine><Street><ns:Name xsi:nil="true" /></Street><City>RALEIGH</City><County>WAKE</County><StateOrProvince><State><Code>NC</Code><ns:Name>NORTH CAROLINA</ns:Name></State></StateOrProvince><Country><Code>US</Code><ns:Name>UNITED STATES</ns:Name></Country><ns:PostalCode>27603</ns:PostalCode><CertificationLevel>POST_CODE</CertificationLevel><NonPostal /><ApplicationSpecific /></Address></Addresses></Location></Locations></Party></DataArea></AcknowledgeParty></soapenv:Body></soapenv:Envelope>');
        res.setStatusCode(200);
        
        // use the created HttpResponse to verify the error in the XML
        result = NGCC_CRAddressValidationCallout.processXML(res, testLead);
        System.Debug('CR Response: '+result);
        System.assert(result.contains('error'), 'JSON returned does not contain an error message when it should. Result:'+result);
        
        result = NGCC_CRAddressValidationCallout.addressValidation(testLead);
        
        result = NGCC_CRAddressValidationCallout.processXML(null, testLead);
    }
}