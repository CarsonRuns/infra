/* 
 * NGCC_CRAddressValidationCallout is called by the NGCC_LeadUtilities visualforce page and call scripts.
 * @description: When called from the visualforce page or call script, the makeRequestNow populates the input XML
 *    with the appropriate fields from the lead object passed to the method and returns an HTTPResponse. The processXML 
 *    method then takes the HTTPResponse and parses the XML to determine if the process was successful or not. If not,
 *    a JSON string is returned to the user with the appropriate errors listed. If it was successful, a lead object with 
 *    the updated fields is serialized into a JSON string and passed back by the calling method.
 * @author: Daniel Pisciottano
 * @created date: April 11, 2014
 * @updated: May 12, 2014 - Daniel Pisciottano - modified the parseXML method to utilize the XmlStreamReader class rather than Dom class
 *            Added 4 helper methods as part of that: parseAddressInformation, parseErrorMessages, getElementText, and createJSONErrorString
 *           June 11, 2014 - Daniel Pisciottano - corrected an XML parsing issue that was causing the state and country fields to return back as blanks
 *           June 12, 2014 - Daniel Pisciottano - corrected the error parsing to not gather blank description messages that caused a JSON parsing issue
 *           July 1, 2014 - Daniel Pisciottano - created addressValidation function so that there is a singular call to this apex class 
*/
public class NGCC_CRAddressValidationCallout {
    public static String addressValidation(Lead lead){
        HttpResponse response = makeRequestNow(lead);
        return processXML(response, lead);
    }

    /* Method that makes the SOAP call to the CR service that returns an HttpResponse */
    public static HttpResponse makeRequestNow(Lead lead){
        // temporary fix that prevents an error with the returned XML
//        if(lead.CustomCountry__c == 'UNITED STATES') lead.CustomCountry__c = 'US';
        
        // input XML with appropriate lead address fields populated
        String xml = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:oag="http://www.cisco.com/cixs2.0/oagis" xmlns:ns="http://www.openapplications.org/oagis/9">';
        xml += '<soapenv:Header/><soapenv:Body><ns0:ProcessParty languageCode="en-US" releaseID="CIXS2-" systemEnvironmentCode="Development" versionID="1.0" xmlns:ns0="http://www.cisco.com/cixs2.0/oagis">';
        xml += '<ns1:ApplicationArea xmlns:ns1="http://www.openapplications.org/oagis/9"><ns1:Sender><ns1:LogicalID>null</ns1:LogicalID>';
        xml += '<ns1:ComponentID>Cleansing-CRES-GUI</ns1:ComponentID><ns1:ReferenceID>crrts</ns1:ReferenceID>';
        xml += '<ns1:AuthorizationID>xxcrrts</ns1:AuthorizationID></ns1:Sender>';
        xml += '<ns1:CreationDateTime>'+datetime.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSS')+'</ns1:CreationDateTime><ns1:BODID>33331</ns1:BODID></ns1:ApplicationArea>';
        xml += '<ns0:DataArea><ns1:Process xmlns:ns1="http://www.openapplications.org/oagis/9"><ns0:ActionCriteria>';
        xml += '<ns1:ActionExpression actionCode="Cleanse" expressionLanguage="String">NameAddress</ns1:ActionExpression>';
        xml += '<ns0:ApplicationSpecific><ns0:Data name="RequestOption" type="String">ALL_DIA</ns0:Data></ns0:ApplicationSpecific></ns0:ActionCriteria></ns1:Process>';
        xml += '<ns0:Party Active="false"><ns1:Name xmlns:ns1="http://www.openapplications.org/oagis/9">'+lead.Company+'</ns1:Name><ns0:Locations><ns0:Location><ns0:Addresses><ns0:Address>';
        xml += '<ns0:AddressLine sequenceName="AddressLine1">'+lead.Address_Line_1__c+'</ns0:AddressLine>';//
        xml += '<ns0:AddressLine sequenceName="AddressLine2">'+lead.Address_Line_2__c+'</ns0:AddressLine>';//
        xml += '<ns0:City>'+lead.CustomCity__c+'</ns0:City><ns0:County/>';
        xml += '<ns0:StateOrProvince><ns0:State><ns1:Name xmlns:ns1="http://www.openapplications.org/oagis/9">'+lead.CustomState__c+'</ns1:Name></ns0:State></ns0:StateOrProvince>';
        xml += '<ns0:Country><ns1:Name xmlns:ns1="http://www.openapplications.org/oagis/9">'+lead.CustomCountry__c+'</ns1:Name><ns0:CertificationIndicator>true</ns0:CertificationIndicator></ns0:Country>';
        xml += '<ns1:PostalCode xmlns:ns1="http://www.openapplications.org/oagis/9">'+lead.CustomZip__c+'</ns1:PostalCode>';
        xml += '<ns0:Region/><ns0:CRStandardizationIndicator>true</ns0:CRStandardizationIndicator></ns0:Address></ns0:Addresses></ns0:Location></ns0:Locations></ns0:Party></ns0:DataArea></ns0:ProcessParty></soapenv:Body></soapenv:Envelope>';
        System.Debug('input XML: '+xml);
        
        // the fourth character in an OrgId is always a number in production and DE orgs
        // in sandbox orgs, it is an uppercase letter
        String fourthChar = UserInfo.getOrganizationId().substring(3, 4);
        boolean isProd = !Pattern.matches('[A-Z]', fourthChar);
        
        // custom setting referenced to pull in user credentials and the CR url based on if the org type (prod or stage)
        List<NGCC_CR_Credentials__c> credentials = NGCC_CR_Credentials__c.getAll().values();
        String username = credentials[0].Username__c;
        String password = credentials[0].Password__c;
        String url;
        if(isProd) url = credentials[0].CR_PROD_URL__c;
        else url = credentials[0].CR_STG_URL__c;
        Blob headerValue = Blob.valueOf(username+':'+password);
        //Blob headerValue = Blob.valueOf('sfdcngcc:salesforcedotcom');
        //Blob headerValue = Blob.valueOf('mdmtest.gen:mdmtestchange');
        
        // initialed HttpRequest and appropriate http header attributes
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(headerValue));
        req.setHeader('SOAPAction', 'cleanse');
        req.setHeader('Content-Type','text/xml; charset=UTF-8');
        req.setHeader('Content-Length',''+xml.length());
        req.setTimeout(20000);
        req.setBody(xml);
        
        // attempt to connect to the CR service with populated input XML
        HttpResponse res;
        try {
            res = h.send(req);
            System.Debug('response: '+res.getBody());
            return res;
            /*bodyRes = res.getBody();
            statusCode = res.getStatusCode();
            if(statusCode == 200) doc = res.getBodyDocument();*/
        } catch(System.CalloutException e){
            //System.debug('Callout error: '+ e);
            return res;
        }
    }
    
    /* Method that takes the HttpResponse returned by the makeRequestNow method and returns the parsed XML as a JSON string */
    public static String processXML(HttpResponse res, Lead lead){
        if(res != null){
            XmlStreamReader reader;
            Integer statusCode = res.getStatusCode();
            // verify an http status code of 200 was returned
            if(statusCode == 200){
                // initialize namespace strings for easy reference when parsing the XML
                try {
                    reader = res.getXmlStreamReader();
                } catch(System.Exception e){
                    System.Debug('output XML read error: '+e);
                    return createJSONErrorString('The address validation service is currently down, please try again later.');
                }
                boolean isSafeToReadNext = true;
                String validationOutcome = '';
                String response = '';
                
                // iterate over the XML 
                while(isSafeToReadNext){
                    // only interested in start elements since that dictates what branch the code needs to take
                    if(reader.getEventType() == XmlTag.START_ELEMENT){
                        // the first element that needs to be found is the ResponseExpression to determine cleansing outcome
                        if(reader.getLocalName() == 'ResponseExpression'){
                            validationOutcome = reader.getAttributeValue(null, 'actionCode');
                        }
                        // if successful and the stream is at the address element, send the reader to the parseAddressInformation helper method with the lead
                        // otherwise, failure is assumed and the parseErrorMessages helper method is used to return the errors with the address
                        // in either case, once the helper method is finished, the while loop can be broken out of
                        if(validationOutcome == 'SUCCESS'){
                            if(reader.getLocalName() == 'Address'){
                                response = parseAddressInformation(reader, lead);
                                isSafeToReadNext = false;
                                break;
                            }
                        } else {
                            if(reader.getLocalName() == 'NounFailureMessage'){
                                response = parseErrorMessages(reader);
                                isSafeToReadNext = false;
                                break;
                            }
                        }
                    }
                    // get next element in the stream
                    if(reader.hasNext()){
                        reader.next();
                    } else {
                        isSafeToReadNext = false;
                        break;
                    }
                }
                return response;
            }
        }
        return createJSONErrorString('The address validation service is currently unavailable, please try again later.');
    }
    
    /* Helper method that parses the XML stream for the cleansed address information and returns it as a JSON string */
    private static String parseAddressInformation(XmlStreamReader reader, Lead lead){
        boolean isSafeToReadNext = true;
        String cleansedAddress1;
        String cleansedAddress2;
        String cleansedCity;
        String cleansedState;
        String cleansedCountry;
        String cleansedZip;
        
        // iterate over the XML as long as there is a next element to parse
        while(isSafeToReadNext){
            // if the element being read is the end of the address block in the XML, break out of the while loop
            if(reader.getEventType() == XmlTag.END_ELEMENT && reader.getLocalName() == 'Address') break;
            
            // only interested in looking at the start elements of the XML
            // for each start element, specific elements are sought after for their corresponding lead address fields
            // for each element sought after, call the getElementText helper method to pull out the text of the cleansed field
            if(reader.getEventType() == XmlTag.START_ELEMENT){
                if(reader.getLocalName() == 'AddressLine'){
                    if(reader.getAttributeValue(null,'sequenceName') == 'AddressLine1')
                        cleansedAddress1 = getElementText(reader);
                    else if(reader.getAttributeValue(null,'sequenceName') == 'AddressLine2')
                        cleansedAddress2 = getElementText(reader);
                } else if(reader.getLocalName() == 'City')
                    cleansedCity = getElementText(reader);
                else if(reader.getLocalName() == 'State'){
                    do {
                        reader.next();
                        if(reader.getLocalName() == 'Code'){
                            cleansedState = getElementText(reader);
                            break;
                        }
                    } while(reader.hasNext());
                } else if(reader.getLocalName() == 'Country'){
                    do {
                        reader.next();
                        if(reader.getLocalName() == 'Name'){
                            cleansedCountry = getElementText(reader);
                            break;
                        }
                    } while(reader.hasNext());
                } else if(reader.getLocalName() == 'PostalCode')
                    cleansedZip = getElementText(reader);
            }
            
            // get next element in the stream
            if(reader.hasNext()){
                reader.next();
            } else {
                isSafeToReadNext = false;
                break;
            }
        }
        
        // overwrite the previous values in the lead address fields and verify no 'NULL' text is found
        // then return the lead object serialized as JSON string
        lead.Address_Line_1__c = cleansedAddress1 != 'NULL' ? cleansedAddress1: '';
        lead.Address_Line_2__c = cleansedAddress2 != 'NULL' ? cleansedAddress2: '';
        lead.CustomCity__c = cleansedCity;
        lead.CustomState__c = cleansedState;
        lead.CustomCountry__c = cleansedCountry;
        lead.CustomZip__c = cleansedZip;
        return JSON.serialize(lead);
    }
    
    /* Helper method that parses the error message(s) associated to the input address */
    private static String parseErrorMessages(XmlStreamReader reader){
        boolean isSafeToReadNext = true;
        String response = 'Company address is invalid.  Please correct the following: ';
        
        // iterate over the XML as long as there is a next element to parse
        while(isSafeToReadNext){
            // if the element being read is the end of the NounFailureMessage block in the XML, break out of the while loop
            if(reader.getEventType() == XmlTag.END_ELEMENT && reader.getLocalName() == 'NounFailureMessage') break;
            
            // if the element being read is the start of a description for an error, concatenate that to the response
            // this is repeated for as many errors that are returned
            if(reader.getEventType() == XmlTag.START_ELEMENT && reader.getLocalName() == 'Description' && reader.getAttributeValue(null,'nil') != 'true'){
                //catches an error that is only generated when the validation service is down, otherwise appends the errors to a string
                if(getElementText(reader) == 'com.cisco.cr.eav.localization.services.LocalizationCustomException')
                    return createJSONErrorString('The address validation service is currently unavailable, please try again later.');
                else 
                    response += getElementText(reader)+' & ';
            }

            // get next element in the stream
            if(reader.hasNext()){
                reader.next();
            } else {
                isSafeToReadNext = false;
                break;
            }
        }
        
        // call the createJSONErrorString helper method and send it the concatenated string of error descriptions
        Integer length = response.length();
        return createJSONErrorString(response.substring(0,length-3));
    }
    
    /* Helper method that gets the first string of text between XML elements associated to a specific element in the XML as determined by where this method is called from */
    private static String getElementText(XmlStreamReader reader){
        boolean isSafeToReadNext = true;
        String text = '';
        
        // iterate over the XML stream as long as there is a next element until an event type of CHARACTERS is found
        while(isSafeToReadNext){
            if(reader.getEventType() == XmlTag.CHARACTERS){
                text = reader.getText();
                break;
            }
            
            if(reader.hasNext()){
                reader.next();
            } else {
                isSafeToReadNext = false;
                break;
            }
        }
        
        // return the found text
        return text;
    }
    
    /* Helper method that just returns the sent error message in an appropriate JSON format */
    private static String createJSONErrorString(String error){
        return '{"error":"'+error+'"}';
    }
}