/*
 * This class serves as a mock HttpCallout for the unit testing of the NGCC_CRAddressValidationCallout class
 * @author: Daniel Pisciottano
*/
@isTest
global class NGCC_CRAddressValidationCallout_Mock implements HttpCalloutMock {
    // Implement this interface method
    global HttpResponse respond(HttpRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals('https://wsgx.cisco.com/mdm/party/ws/cleanse', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'text/xml');
        res.setBody('<?xml version=\'1.0\' encoding=\'UTF-8\'?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><AcknowledgeParty xmlns="http://www.cisco.com/cixs2.0/oagis" xmlns:ns="http://www.openapplications.org/oagis/9" releaseID="CIXS-2.0" versionID="3.0" systemEnvironmentCode="STAGE" languageCode="en-US"><ns:ApplicationArea><ns:Sender><ns:AuthorizationID>xxcrrts</ns:AuthorizationID></ns:Sender><ns:CreationDateTime>2014-04-07</ns:CreationDateTime><ns:BODID>33331</ns:BODID></ns:ApplicationArea><DataArea><ns:Acknowledge><ns1:OriginalApplicationArea xmlns:ns1="http://www.openapplications.org/oagis/9" xmlns:ns0="http://www.cisco.com/cixs2.0/oagis"><ns1:Sender><ns1:LogicalID>null</ns1:LogicalID><ns1:ComponentID>Cleansing-CRES-GUI</ns1:ComponentID><ns1:ReferenceID>crrts</ns1:ReferenceID><ns1:AuthorizationID>xxcrrts</ns1:AuthorizationID></ns1:Sender><ns1:CreationDateTime>2014-04-07T16:28:08.641</ns1:CreationDateTime><ns1:BODID>33331</ns1:BODID></ns1:OriginalApplicationArea><ResponseCriteria><ns:ResponseExpression actionCode="SUCCESS" /><BODSuccessMessage><SuccessProcessMessage><ns:Description>COMPLETE, CLEANSED, GEO_VALID</ns:Description><ns:ReasonCode>SUCCESS</ns:ReasonCode><Status>SUCCESS</Status></SuccessProcessMessage><NounSuccessMessage><SuccessProcessMessage><ns:Description /><ns:ReasonCode /><Status>CLEANSED</Status><Component>CLEANSING</Component><Category /></SuccessProcessMessage><SuccessProcessMessage><ns:Description /><ns:ReasonCode /><Status>COMPLETE</Status><Component>COMPLETENESS</Component><Category /></SuccessProcessMessage><SuccessProcessMessage><ns:Description /><ns:ReasonCode /><Status>GEO_VALID</Status><Component>GEO_VALIDATION</Component><Category /></SuccessProcessMessage></NounSuccessMessage></BODSuccessMessage></ResponseCriteria></ns:Acknowledge><Party><ns:Name>CISCO SYSTEMS</ns:Name><Locations><Location><Addresses><Address><AddressLine sequenceName="AddressLine1">1535 CARALEIGH MILLS CT 205</AddressLine><AddressLine sequenceName="PrimaryAddress">1535 Caraleigh Mills Ct 205</AddressLine><Street><ns:Name>CARALEIGH MILLS</ns:Name><Number>1535</Number><SuffixText>CT</SuffixText></Street><City>RALEIGH</City><County>WAKE</County><StateOrProvince><State><Code>NC</Code><ns:Name>NORTH CAROLINA</ns:Name></State></StateOrProvince><Country><Code>US</Code><ns:Name>UNITED STATES</ns:Name></Country><ns:PostalCode>27603</ns:PostalCode><CertificationLevel>POST_CODE</CertificationLevel><NonPostal /><ApplicationSpecific><Data name="Extra4" type="String">Wake</Data><Data name="Extra5" type="String">L5-P4S5A0T4R4Z4C4-100</Data><Data name="Extraneous" type="String">nxtgen-stg-02</Data></ApplicationSpecific></Address></Addresses></Location></Locations></Party></DataArea></AcknowledgeParty></soapenv:Body></soapenv:Envelope>');
        res.setStatusCode(200);
        return res;
    }
}