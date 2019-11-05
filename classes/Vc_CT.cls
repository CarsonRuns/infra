public class Vc_CT {

        //documentation
        //process sfdc log info for contacts
        //async update of partner info?
        //move logger out of VC. 
        
        //checked view state    
        //VF page and Apex Class security
        //ws timeout? 10-60seconds?
        //Remote site settings
        //http://tools-dev.cisco.com/GPSS/pvc/services/VCSFDCService/getVCEligible
        //http://tools-dev.cisco.com/GPSS/pvc/services/VCSFDCService/updateVCEligible
        //add external id on Partner_Id__c & CCO_Id__c & Site Id:CSCSiteId__c
        
        // SCAVA Helper Method to validate Create Access at field level
         public static Boolean flsGet(SObjectField field)
        {
            return field.getDescribe().isCreateable() ? true : false;
        }

        
        public string CCO_ID {get;set;}
        public string CCOSearchStatus {get;set;}
        public string CCOSearchStatusDescription {get;set;}
        public string CCOSearchPartnerId {get;set;}     
        public string ContactFirstName {get;set;}
        public string ContactLastName {get;set;}
        public string ContactPhoneNumber {get;set;}
        public string TelephoneNumberDelimiter = ' ';
        public string TelephoneNumberTag = 'TelephoneNumber';
        public string VCIneligibleResponseString = 'N';
        public string VCEligibleResponseString = 'Y';
        public string emailAddress {get;set;}
        public string PGTMVSiteId {get;set;}
        public string CCOPartnerCountry {get;set;}
        public string sfdc_country_desc {get;set;}
        public string country_cd {get;set;}
        public string sfdcPartnerId {get;set;}
        public string location {get;set;}

//      public string PartnerIdTest {get;set;}
//      public string PartnerCountryTest {get;set;}
        
        public boolean ex;
        public string message;
 
        /////////
        public integer groupCount;
        public integer getHasPermission(){
                location = 'getHasPermission';
                if (groupCount == null){
                        queryPermission qp = new queryPermission();
                        groupCount = qp.runquery();                     
                }                                       
                return groupCount;              
        }
        
        public class queryPermission {
                public integer runquery(){
                        return [Select count() from GroupMember g  where (Group.Name = :Utilities.GetPAGroupName() or Group.Name = :Utilities.getPHGroupName() or Group.Name = :Utilities.getPDIGroupName()) and UserOrGroupId = :UserInfo.getUserId() limit 1];
                }
        }       

        /////////
        boolean CCOServiceUp;
        private Blob CCOHeaderValue = Blob.valueOf( Utilities.getConstant_CS('CCOSearch user:pass') );
        private String CCOAuthorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(CCOHeaderValue);   
        public boolean doVCSearch;
        public string emailAddressTemp;
        public string ContactPhoneNumberTemp;
        String FAILUREString = 'FAILURE';
        Public String notTest ='notTest';  
        
        public void callCCOSearchService(String isTest){
                location = 'callCCOSearchService';
                CCOServiceUp = false;
                doVCSearch=true;
                CCOSearchStatus=null;
                CCOSearchStatusDescription=null;
                ContactFirstName=null;
                ContactLastName=null;
                ContactPhoneNumber=null;
                ContactPhoneNumberTemp=null;
                emailAddress=null;
                emailAddressTemp=null;
                PGTMVSiteId=null;
                CCOPartnerCountry=null;
                VCEligibleResponse = 'N';
                VCIneligibilityReason=null;
                VCServiceUp = false;
                SFDCChannelAccountFound=false;
                CCOSearchPartnerId=null;
                SFDCChannelAccount=null;                
                
                CCO_ID = CCO_ID.trim();
                System.debug('Searching for CCO_ID=>'+CCO_ID);
                message = 'CCO Id:' + CCO_ID;

                String request = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:oag="http://www.cisco.com/cixs2.0/oagis" xmlns:ns="http://www.openapplications.org/oagis/9">'+
                                                           '<soapenv:Header/>'+
                                                           '<soapenv:Body>'+
                                                        '<GetParty releaseID="CIXS-2.0" xmlns="http://www.cisco.com/cixs2.0/oagis" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
                                                                 '<ns:ApplicationArea>'+
                                                                    '<ns:Sender>'+
                                                                       '<ns:ComponentID>Party</ns:ComponentID>'+
                                                                       '<ns:TaskID>PersonProfile</ns:TaskID>'+
                                                                       '<ns:ReferenceID>CHANNELS</ns:ReferenceID>'+
                                                                       '<ns:AuthorizationID>xxccr_pgtmv</ns:AuthorizationID>'+
                                                                    '</ns:Sender>'+
                                                                    '<ns:CreationDateTime>1999-05-31T13:20:00-05:00</ns:CreationDateTime>'+
                                                                    '<ns:BODID>1000091121</ns:BODID>'+
                                                                 '</ns:ApplicationArea>'+
                                                                 '<DataArea>'+
                                                                    '<Get>'+
                                                                       '<ns:Expression expressionLanguage="String">CATEGORY_ALL</ns:Expression>'+
                                                                       '<ns:Expression expressionLanguage="String">HIERARCHY_LEVEL_PARENT_CHILD_ALL</ns:Expression>'+
                                                                       '<ns:Expression id="3" expressionLanguage="String">HIERARCHY_LEVEL_PARENT_CHILD_ALL</ns:Expression>'+
                                                                       '<ns:Expression expressionLanguage="String">APV_Attr_Inherit_All</ns:Expression>'+
                                                                       '<ns:Expression expressionLanguage="String">APV_ATTRIBUTE_ALL</ns:Expression>'+
                                                                       '<SearchCondition predecessorId="2" id="3" expressionLanguage="String" expressionType="ChainedRetrieve">ULTIMATE</SearchCondition>'+
                                                                       '<SearchCondition expressionLanguage="String" expressionType="CCO_ID">'+CCO_ID+'</SearchCondition>'+
                                                                       '<SearchCondition expressionLanguage="String" expressionType="FunctionalRole">PDB_CONTACT</SearchCondition>'+
                                                                       '<SearchCriteria>'+
                                                                          '<SearchType>Person_search</SearchType>'+
                                                                          '<SearchSource space="PERSONREGISTRY"/>'+
                                                                          '<SearchSource space="UNIVERSE" usageCode="RETRIEVE">CHANNELS/PGTMV</SearchSource>'+
                                                                       '</SearchCriteria>'+
                                                                    '</Get>'+
                                                                 '</DataArea>'+
                                                              '</GetParty>'+
                                                           '</soapenv:Body>'+
                                                        '</soapenv:Envelope>';
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setTimeout(20000);
        String url = Utilities.getConstant_CS('CCO Search Svc Url');
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setHeader('Authorization', CCOAuthorizationHeader);        
        req.setHeader('content-type', 'text/xml; charset=utf-8'); 
        req.setHeader('SOAPAction', 'handleRequest');
        req.setBody(request);
        String response = '';
        // Send the request, and return a response
        if (isTest == notTest){
                HttpResponse res = h.send(req);
                response = res.getBody();
                system.debug('response');
                System.debug(response);
        }
        else{
                response = isTest;
                System.debug('isTest response\n'+response.trim());
        }               
        
        txl.log(tid, 'CCO Response', response.trim(), false);
        
        String firstChar = response.substring(0,1);
        if (firstChar != '<'){
                throw new vcException('CCO Search Service not accessible.');    
        }
        
                
        XmlStreamReader reader = new XmlStreamReader(response.trim());
        while(reader.hasNext()) {
                        if (reader.getLocalName()=='ResponseExpression' && reader.getEventType() == XmlTag.START_ELEMENT){
                                CCOSearchStatus = reader.getAttributeValue(null,'actionCode');
                                System.debug('CCO Success/Failure Attribute=> '+ CCOSearchStatus );
                                CCOServiceUp = true;
                        }

                        if (reader.getLocalName()=='Description' && reader.getEventType() == XmlTag.START_ELEMENT){//no match [failure or success]
                                reader.next();
                                CCOSearchStatusDescription = reader.getText();
                                System.debug('Description=> '+CCOSearchStatusDescription );
                        }
                        
                        if ( CCOSearchStatus == FAILUREString || CCOSearchStatusDescription == 'NO HIERARCHY EXISTS FOR THE INPUT'){
//                        if ( CCOSearchStatus == FAILUREString ){
                                doVcSearch=false;
                        }
                        
                        if (reader.getLocalName()=='PersonProfile' && reader.getEventType() == XmlTag.START_ELEMENT){
                                ContactFirstName = parseToTag( reader, 'GivenName');
                                ContactLastName = parseToTag( reader, 'FamilyName');
                        }
                        if (reader.getLocalName()=='Email' && reader.getEventType() == XmlTag.START_ELEMENT){
                                reader.next();
                                emailAddressTemp = reader.getText();
                                if ( parseToTag(reader,'PrimaryFlag') == 'Yes'){
                                        emailAddress=emailAddressTemp;
                                }                                       
                        }
                        if (reader.getLocalName()=='Address'                            
                                && reader.getEventType() == XmlTag.START_ELEMENT 
                                && reader.getAttributeValue(null,'type') == 'TELEPHONE'){
                                        ContactPhoneNumberTemp = parseToTag( reader, TelephoneNumberTag);
                                        
                                if ( parseToTag(reader,'PrimaryFlag') == 'Yes'){
                                        ContactPhoneNumber = ContactPhoneNumberTemp;
                                }
                                                                                        
                        }
                        if (reader.getLocalName()=='Party'                              
                                && reader.getEventType() == XmlTag.START_ELEMENT 
                                && reader.getAttributeValue(null,'type') == 'Organization'
                                && reader.getAttributeValue(null,'Active') == 'true' ){
                                        PGTMVSiteId = parseToTag(reader,'Id');
                                        
                                        while(reader.hasNext()) {
                                                if(reader.getLocalName()=='Country' 
                                                        && reader.getEventType() == XmlTag.START_ELEMENT){
                                                        CCOPartnerCountry = parseToTag(reader,'Name');
                                                        break;                                                  
                                                }
                                                reader.next();
                                        }//end 'Party'                                          
                        }
//                      <cixs:GroupType>BE</cixs:GroupType>
                        if (reader.getLocalName()=='GroupType' && reader.getEventType() == XmlTag.START_ELEMENT){
                                reader.next();
                                if (reader.getText() == 'BE'){
                                        while(reader.hasNext()) {
                                                if (reader.getLocalName()=='CrossReferenceIds' && reader.getEventType() == XmlTag.START_ELEMENT){
                                                                while(reader.hasNext()) {
                                                                        if (reader.getLocalName() == 'CrossReferenceIds' && reader.getEventType() == XmlTag.END_ELEMENT){break;}
                                                                        if (reader.getLocalName()=='SourceSystem' && reader.getEventType() == XmlTag.START_ELEMENT){
                                                                                location = location + 'SS';
                                                                                while(reader.hasNext()) {
                                                                                        if(reader.getEventType() == XmlTag.CHARACTERS && reader.getText() == 'CHANNELS'){
                                                                                                location = location + 'Ch';
                                                                                                reader.next();reader.next();reader.next();reader.next();reader.next();reader.next();
                                                                                                CCOSearchPartnerId = reader.getText();
                                                                                                break;                                          
                                                                                        }//end CHANNELS
                                                                                reader.next();
                                                                                }
                                                                        }//end SourceSystem
                                                                        reader.next();
                                                                }
                                                }//end CrossReferenceIds
                                                reader.next();
                                        }
                                }//end BE
                        }//end GroupType
                        
                        reader.next(); 
                }//end parse

                if(CCOPartnerCountry <> null){
                        PDBCountryLookup__c  CountryDetail_cs = PDBCountryLookup__c.getInstance(CCOPartnerCountry);
                        sfdc_country_desc = CountryDetail_cs.sfdc_country_desc__c;
                        country_cd = CountryDetail_cs.country_cd__c;
                }               

                message +=  '\nCCOSearchStatus='+CCOSearchStatus +
                                        '\nCCOSearchStatusDescription='+CCOSearchStatusDescription +
                                        '\nContactFirstName=' + ContactFirstName + 
                                        '\nContactLastName=' + ContactLastName  +
                                        '\nContactPhoneNumber=' + ContactPhoneNumber + 
                                        '\nEmailAddress=' + EmailAddress +
                                        '\nPGTMVSiteId=' + PGTMVSiteId +
                                        '\nCCOSearchPartnerId=' + CCOSearchPartnerId +
                                        '\nCCOPartnerCountry=' + CCOPartnerCountry +
                                        '\nsfdc_country_desc=' + sfdc_country_desc +
                                        '\ncountry_cd=' + country_cd;
                                        
                if (!CCOServiceUp){
                        throw new vcException('CCO Search Service not accessible..' );                  
                }
        }
        
        /////////
        public String parseToTag(XmlStreamReader reader, String parseTag){
                location = 'parseToTag';        
                String returnValue;
                while(reader.hasNext()) {
                        if (reader.getLocalName()==parseTag && reader.getEventType() == XmlTag.START_ELEMENT){
                                if ( parseTag == TelephoneNumberTag){
                                        String ccTemp = reader.getAttributeValue(null,'countryCode');
                                        String acTemp = reader.getAttributeValue(null,'areaCode');
                                        if (ccTemp<>null){
                                                returnValue = ccTemp;
                                        } 
                                        if (acTemp<>null){
                                                returnValue = (returnValue==null ? acTemp : returnValue + TelephoneNumberDelimiter + acTemp );
                                        }
                                }
                                reader.next();
                                
                                if ( parseTag == TelephoneNumberTag){
                                        returnValue=returnValue + TelephoneNumberDelimiter + reader.getText();                          
                                }
                                else{ returnValue = reader.getText();}
                                break;
                        }
                        reader.next();
                }
                return returnValue;
}
                
        /////////       
        public String findSFDCPartnerId(){
                location = 'findPartnerId';
                Account tmpAccount;
                String returnValue;
                try{
                        tmpAccount = [Select Partner_Id__c from Account 
                                                                where recordtype.name = 'Channel' and 
                                                                isdeleted=false and             
                                                                CSCSiteId__c <> null and  
                                                                Country__c=:sfdc_country_desc and //                                    
                                                                CSCSiteId__c = :PGTMVSiteId and 
                                                                Owner.Name != 'Integration User 1' limit 1];
                        returnValue = tmpAccount.Partner_Id__c;                                                 
                }
                catch(Exception e){
                        System.debug('findPartnerId: '+ e);
                        //processException(e);
                }
                return returnValue;
        }               
        
        /////////       
        private Blob VcHeaderValue = Blob.valueOf( Utilities.getConstant_CS('VC user:pass') );
        private String VcAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(VcHeaderValue);
        public Boolean VCServiceUp {get;set;}   
        public String VCEligibleResponse {get;set;}
        public String VCIneligibilityReason {get;set;}
        public String VCNoServiceTest {get;set;}        
        
    public void callVcEligibleService(){    
                location = 'callVcEligibleService';
        //      throw new tstException('**** dameyer testing ' + credentials);              
                
                String url = Utilities.getConstant_CS('VC Eligible Svc Url');
                String responseBody;
        
                Http h = new Http();
        
                HttpRequest req = new HttpRequest();
                req.setEndpoint(url);
                req.setMethod('POST');
                req.setHeader('Authorization', VcAuthorizationHeader);
                //cathy.quick cisco123
                //'<partnerId>'+PartnerId+'</partnerId>'+//1211     
                //USA
                String reqBody =  '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'+
                                                                '<VCSFDCEligibleRequest xmlns="urn:cisco:names:message:vc">'+
                                                                '<vcsfdceligiblerequest>'+
                                                                        '<requestorApp>SFDC</requestorApp>'+
                                                                        '<partnerId>'+CCOSearchPartnerId+'</partnerId>'+                                            
                                                                        '<country>'+country_cd+'</country>'+
                                                                        '<vcRequestTimeStamp>09-10-2010 13:30:03 PDT</vcRequestTimeStamp>'+
                                                                '</vcsfdceligiblerequest>'+
                                                                '</VCSFDCEligibleRequest>';
        
                req.setBody(reqBody);
        
                // req.setTimeout(60000);       
                
                HttpResponse res = h.send(req);
                responseBody = res.getBody().trim();

                txl.log(tid, 'VC Response', responseBody.trim(), false);
                
                String firstChar = responseBody.substring(0,1);
                if (firstChar != '<'){
                        throw new vcException('VC Service  not accessible.');   
                }


/*
        responseBody = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><VCSFDCEligibleResponse xmlns="urn:cisco:names:message:vc"><vcsfdceligibleresponse><partnerId>1211</partnerId><country>USA</country><eligibilityFlag>Y</eligibilityFlag><region>NEWNESS</region><vcResponseTimeStamp>09-15-2010 12:44:49 CDT</vcResponseTimeStamp><vcResponseCode>SUCCESS</vcResponseCode></vcsfdceligibleresponse></VCSFDCEligibleResponse>';
        //SUCCESS       

        if(VCNoServiceTest == 'NOTELIGIBLE')
                responseBody = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><VCSFDCEligibleResponse xmlns="urn:cisco:names:message:vc"><vcsfdceligibleresponse><partnerId>1211</partnerId><country>USA</country><eligibilityFlag>N</eligibilityFlag><reasonDesc>Requirements not yet met.</reasonDesc><vcResponseTimeStamp>10-12-2010 12:03:33 CDT</vcResponseTimeStamp><vcResponseCode>SUCCESS</vcResponseCode></vcsfdceligibleresponse></VCSFDCEligibleResponse>';
                //Not Eligibile
        else if (VCNoServiceTest == 'FAILURE'){
                responseBody = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><VCSFDCEligibleResponse xmlns="urn:cisco:names:message:vc"><vcsfdceligibleresponse><partnerId>12141</partnerId><country>USA</country><vcResponseTimeStamp>09-15-2010 12:55:59 CDT</vcResponseTimeStamp><vcResponseCode>FAILURE</vcResponseCode></vcsfdceligibleresponse></VCSFDCEligibleResponse>';
                //FAILURE
        }
        else if(VCNoServiceTest =='NOSVC'){     
                responseBody = '<junk></junk>';//NOT Accesible
        }       
*/      
        

                XmlStreamReader reader = new XmlStreamReader(responseBody);

                while(reader.hasNext()) {
                        if (reader.getLocalName()=='vcsfdceligibleresponse'){
                         VCServiceUp = true;
                        }
                        
                        if ( reader.getLocalName()=='vcResponseCode' ){
                                reader.next();
                                if (reader.getText() == FAILUREString){
                                        VCServiceUp = false;
                                        throw new vcException('VC Service error.');
                                }
                        }                                                

                        if (reader.getLocalName()=='eligibilityFlag'){
//                              System.debug('----------------------  '+reader.getLocalName());
                                reader.next();
                                VCEligibleResponse = reader.getText();
//                              System.debug('----------------------  '+reader.getText()) ;
                                VCIneligibilityReason = parseToTag(reader,'reasonDesc');
                                break;
                        }
                                reader.next();
                }
                message = 'Eligible='+VCEligibleResponse +
                          '\nReason='+VCIneligibilityReason +
                                        '\nServiceUp='+VCServiceUp +
                                        '\nPGTMVSiteId=' + PGTMVSiteId +
                                        '\nCCOPartnerCountry=' + CCOPartnerCountry;
                if (!VCServiceUp){
                        System.debug('VC ex '+ url );
                        throw new vcException('VC Service  not accessible..' );
                }
//      throw new tstE('test error');

        }       

        /////////       
        public class vcException extends Exception {}
        
        /////////
        String Vc_CT = 'Vc_CT'; 
        public class Tx_Logger{         
                public String origin{get;set;}
                datetime t1;
                Tx_Log__c[] wscs = new  Tx_Log__c[]{};
                
                public void initTime(){
                        t1 = datetime.now();
                }
                
                public void endLog(){
                        insert wscs;
                        wscs.clear();
                }
                
                public void log(string tid, string typ, String message, boolean ex ){

                        if (message <> null && message.length() > 32000){message=message.substring(0,32000);}

                        Tx_Log__c l = new Tx_Log__c();
                                        //SCAVA FIX
                                        if(flsGet(Tx_Log__c.name))
                                        {
                                        l.name=tid;
                                        }
                                        if(flsGet(Tx_Log__c.type__c))
                                        {
                                        l.type__c=typ;
                                        }
                                        if(flsGet(Tx_Log__c.originated__c))
                                        {
                                        l.originated__c=origin;
                                        }
                                        if(flsGet(Tx_Log__c.message__c))
                                        {
                                        l.message__c=message;
                                        }
                                        if(flsGet(Tx_Log__c.exception__c))
                                        {
                                        l.exception__c=ex;
                                        }
                                        if(flsGet(Tx_Log__c.duration__c))
                                        {
                                        l.duration__c=(datetime.now().getTime()-t1.getTime());
                                        }
                                        
                                wscs.add(l);  
                }
                
        }
        
        
        /////////       
        public void processException(Exception e,String which){
                ex=true;
                message = which + '\n' + String.valueOf(e) + '\n' +  message;
                try
                    {
                        System.debug('++++++++++++++++++++++ '+ ApexPages.currentPage().getHeaders().get('Host') );
                        ApexPages.addMessages(e);
                    }
                catch (System.NullPointerException npe)
                   {
                      System.debug('++++++++++++++++++++++ '+ npe);
                      throw e;
                   }       
        }       
        
        public void logStart(String w){
                message=null;
                txl.initTime();
        }

        
        /////////       
        String tid;
        String VCCCOSearch='VC CCO Search';
        String VCEligibleString='VC Eligible';
        String ProcessSFDCString = 'Process SFDC';
        Tx_Logger txl = new Tx_Logger();   
        public void search(){
                
                txl.origin = Vc_CT;
                location='search';
                ex=false;
//              PageReference pageRef = null;
                try{
                        tid=UserInfo.getUserName()+':'+datetime.now()+':'+CCO_Id;
        
                        //CCO Search            
                                logStart(VCCCOSearch);                          
                        try{
                                callCCOSearchService(notTest);
                                sfdcPartnerId = findSFDCPartnerId();
                        }
                        catch (Exception e) {
                                processException(e,location+'CCO');
                        }       
                        txl.log(tid, VCCCOSearch, message, ex);         
                                
                        //VC Eligible
                        if ( ex==false && doVcSearch ){
                                logStart(VCEligibleString);                                     
                        try{                    
                                callVcEligibleService();
                                        //throw new tstException('**** dameyer testing ');              
                        }
                        catch (Exception e) {
                                        ex=true;
                                        processException(e, location + 'VC');                                   
                        }
                        txl.log(tid, VCEligibleString, message, ex);
                        }
                        //SFDC process
                        if ( ex==false && doVcSearch && PGTMVSiteId <> null && sfdcPartnerId <> null ){
                                logStart(ProcessSFDCString);
                                try{                            
                                        //pageRef = processSFDC();
                                        processSFDC();
                                }
                                catch (Exception e) {
                                        processException(e, location + 'SFDC');
                                }
                                txl.log(tid, ProcessSFDCString, message, ex);                                                                           
                        }
                }
                catch (Exception e) {
                        logStart('ute');
                        processException(e,location+'Ute');
                        txl.log(tid, 'ute', message, ex);
                }
                txl.endLog();
        
/*              if (ex){pageRef=null;}
                return pageRef;*/
        }

        /////////
        public boolean SFDCChannelAccountFound {get;set;}
        public Account SFDCChannelAccount;      
                
        public void processSFDC(){
                location = 'processSFDC';
                Account[] partnerAccounts; 
                Set<Id> PartnerAcctIds = new Set<Id>(); 
                String PartnerAcctIdsString;
                //PageReference p = null;
                //Search for matches
                try {
                                SFDCChannelAccount = [Select Id,Name,(Select CCO_Id__c, Email,Id From Contacts) from Account 
                                                where 
                                                        CSCSiteId__c =:PGTMVSiteId and 
                                                        Country__c=:sfdc_country_desc and 
                                                        recordtype.name = 'Channel' and  
                                                        isdeleted=false and
                                                        Owner.Name != 'Integration User 1' limit 1];
                                SFDCChannelAccountFound = true;                                                 
                        //      p =  new PageReference('/'+SFDCChannelAccount.Id);
                }
                catch (QueryException e) {
                        System.debug('processsSFDC: '+ e);//no rows
                }
                if (SFDCChannelAccount <> null){
                //Update Account with latest VC info
                        try {
                                partnerAccounts = [Select Id, VC_Eligibility_Flag__c, VC_Ineligibility_Reason__c from Account 
                                                                                        where 
                                                                                        Partner_Id__c =:sfdcPartnerId and 
                                                                                        Country__c=:sfdc_country_desc and
                                                                                        isdeleted=false and 
                                                                                        recordtype.name = 'Channel' and
                                                                                        Owner.Name != 'Integration User 1'];   
                                                                                        
                                if ( VCIneligibilityReason <> null && VCIneligibilityReason.length() > 255 ){ 
                                        VCIneligibilityReason = VCIneligibilityReason.substring(0,255);
                                }
                                for(Account a: partnerAccounts){
                                        a.VC_Eligibility_Flag__c = getVCEligibleResponseWord();
                                        a.VC_Ineligibility_Reason__c = VCIneligibilityReason;
                                        PartnerAcctIds.add(a.Id);
                                }
                                
                                Utilities.setSkip(true);//skips certain trigger functionality
                                Utilities.setValidationSkip(true);      
                                update partnerAccounts;
                                String tmpString;
                                for(Id paId: PartnerAcctIds){
                                        tmpString = String.valueOf( paId );
                                        PartnerAcctIdsString = ( PartnerAcctIdsString==null ) ? tmpString : PartnerAcctIdsString +', '+ tmpString ;
                                }                                       

                        }
                        catch(Exception e){
                                System.debug('updateSFDC: '+ e);
                                processException(e, location+'UpdateAccounts');
                        }
                        
                        Boolean emailMatchContact =false;
                        Boolean ccoIdMatchContact =false;
                        Contact[] matchContacts =new  Contact[]{};
                        Contact tmpContact;
                        if (SFDCChannelAccount.contacts.size() > 0){
                                try {
                                        for(integer i=0; i< SFDCChannelAccount.contacts.size();i++){
                                                emailMatchContact = false;
                                                ccoIdMatchContact = false;
                                                System.debug('Searching contacts...');
                                                System.debug(SFDCChannelAccount.contacts[i].email);
                                                System.debug(SFDCChannelAccount.contacts[i].CCO_Id__c);
                                                if (EmailAddress <> null && SFDCChannelAccount.contacts[i].email == EmailAddress ){
                                                        System.debug('matched contact email address');
                                                        emailMatchContact = true;
                                                }
                                                if (SFDCChannelAccount.contacts[i].CCO_id__c == CCO_Id ){
                                                        ccoIdMatchContact = true;
                                                        System.debug('matched contact CCO Id');
                                                }
                                                if(emailMatchContact || ccoIdMatchContact){
                                                        tmpContact = new Contact(Id=SFDCChannelAccount.contacts[i].Id, 
                                                                CCO_Id__c=CCO_id,
                                                                email=EmailAddress,
                                                                phone=ContactPhoneNumber
                                                        );
                                                        matchContacts.add(tmpContact);
                                                }
                                        }
                                       //if (emailMatchContact || ccoIdMatchContact ){
                                       if (matchContacts.size() > 0 ){
                                                try{
                                                        update matchContacts;
                                                }                                                       
                                                catch(Exception e){
                                                        System.debug('updateContact: '+ e);
                                                        processException(e, location+'UpdateContact');                                                  
                                                }                                                       
                                        }
                                }
                                catch(Exception e){
                                        System.debug('SFDCContactSearch: '+ e);
                                        processException(e, location);
                                }
                        }
                        //if( !emailMatchContact && !ccoIdMatchContact){
                        if (matchContacts.size() == 0 ){                                                                        
                                System.debug('Create Contact');
                                try{
                                        Contact newContact = new Contact();
                                        //SCAVA FIX
                                        if(flsGet(Contact.AccountId))
                                        {
                                        newContact.AccountId=SFDCChannelAccount.Id;
                                        }
                                        //SCAVA FIX
                                        if(flsGet(Contact.CCO_Id__c))
                                        {
                                        newContact.CCO_Id__c=CCO_Id;
                                        }
                                        if(flsGet(Contact.phone))
                                        {
                                        newContact.phone=ContactPhoneNumber;
                                        }
                                        if(flsGet(Contact.email))
                                        {
                                        newContact.email=emailAddress;
                                        }
                                        if(flsGet(Contact.lastname))
                                        {
                                        newContact.lastname=ContactLastName;
                                        }
                                        if(flsGet(Contact.firstname))
                                        {
                                        newContact.firstname=ContactFirstName;
                                        }

                                        Insert newContact;
                                }
                                catch(Exception e){
                                        System.debug('insertContact: '+ e);
                                        processException(e,location+'InsertContact');
                                }
                        }
                }
                
                String tmpMessage =     /*'\nPGTMVSiteId=' + PGTMVSiteId +*/
                                        '\nsfdc_country_desc=' + sfdc_country_desc +
                                        '\nsfdcPartnerId=' + sfdcPartnerId +                                    
//                                      '\nPartnerIdTest=' + PartnerIdTest +
//                                      ' PartnerCountryTest=' + PartnerCountryTest +                                   
                                        '\nAccount=' + SFDCChannelAccount +
                                        /*'\nVCEligibleResponse=' + VCEligibleResponse +
                                        '\nIneligibilityReason=' + IneligibilityReason +*/
                                        '\nPartnerAccountIds=' + PartnerAcctIdsString +
                                        '\nContactStuff=?';
                message = ( message==null ) ? tmpMessage : message + tmpMessage;                                        

                //return p;                                     
        }   
        
        /////////       
        public String getSFDCChannelAccount() {
                return '<a href="/'+ SFDCChannelAccount.Id +'">'+SFDCChannelAccount.Name+'</a>';
        }
        
        /////////
        public String getSBCLink() {
                String returnValue= '     <a href="/001/e?RecordType=0123000000004aV" title="Click to Search/Create a Partner Account">Search/Create a Partner Account</a>';
                returnValue += getVCEligibleMessage();
                return returnValue; 
        }
        

        public String getVCEligibleResponseWord(){
            return ((VCEligibleResponse == VCEligibleResponseString) ? 'Yes' : 'No');
        }
        
 /*       public String getVCEligibleMessage(){
                String returnValue = '<br/><b>PA Eligible: '+ getVCEligibleResponseWord() +'</b>.';
                if (VCIneligibilityReason<>null){
                        returnValue += ' ' + VCIneligibilityReason;
                }
                return returnValue;
        }
        
*/
        public String getVCEligibleMessage(){
                String returnValue = '<br/><b>PA Eligible : </b>'+ getVCEligibleResponseWord() +'.';
                if (VCIneligibilityReason<>null){
                        returnValue += '<br/><b>PA Eligibility/Ineligibility Reason : </b>' + VCIneligibilityReason + '.';
                }
                return returnValue;
        }


        /////////
        public String getNoMatchesMsg() {
        return 'Sorry, there are no matching partner contacts based on the search criteria.<br/>';
}
        
        /////////       
        public String getLineBreak() { return '<br/>';}

/*
                        Tx_Log__c[] wscls = [Select Id from Tx_Log__c where OwnerId = '00530000000zW3iAAE'];            
                        delete wscls;
*/

}