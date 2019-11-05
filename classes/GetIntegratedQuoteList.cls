/**
* @author       Shahrukh Sheikh
* @version      Intial version (1.0)
* @since        2019-01-23 (YYYY-MM-DD)
* @description  Manually Quote Integration from framework controller class
* @modification log
* iTrack#         Date           Author               Change
                2019-04-12     Sampoorna Bacha      Coverting vf page to lightning
**/
public class GetIntegratedQuoteList {
    private static String kHexChars = '0123456789876543' ;
    public class QuotesWrapper {
        @AuraEnabled public Quote__c qt {get; set;}
        @AuraEnabled public Boolean selected {get; set;}
        @AuraEnabled public String ischeckbox {get;set;}
            
        //This is the contructor method
        public QuotesWrapper(Quote__c q) {
            qt = q;
            selected = false;
            ischeckbox = 'true';
        }
    }
    
    public class pageValidationWrapper {
        @AuraEnabled public Boolean oppOwner {get; set;}
        @AuraEnabled public String oppOwnerError{get;set;}
        @AuraEnabled public Integer spinnerTimout {get;set;}
        @AuraEnabled public Boolean disableButton {get; set;}
        @AuraEnabled public Boolean autoReload{get; set;}
        @AuraEnabled public Boolean pageBlock {get; set;}
        @AuraEnabled public Boolean approvedFlag {get;set;}
        @AuraEnabled public String warningMsg{get; set;} 
        @AuraEnabled public long timeStamp{get; set;}
        @AuraEnabled public string inProgressFlag{get; set;}
        @AuraEnabled public QuotesWrapper selectedQuote{get; set;} 
        @AuraEnabled public String ccwStatus{get; set;} 
        @AuraEnabled public String failedFlag{get; set;}
        @AuraEnabled public String passedFlag{get; set;}
        @AuraEnabled public List<QuotesWrapper> wrappedQuotesList{get; set;}
        @AuraEnabled public String spinnerFlag{get; set;}
        @AuraEnabled public String failedQuoteID{get; set;}
        @AuraEnabled public String webServiceError{get; set;}
        @AuraEnabled public String inProgressWarning{get; set;}
        @AuraEnabled public String successMessage{get; set;}
        @AuraEnabled public String multipleSelectionError{get; set;}
        @AuraEnabled public String checkboxUncheckError{get; set;}
        
        //Quote Field labels
        @AuraEnabled public String quoteName{get; set;}
        @AuraEnabled public String quoteId{get; set;}
        @AuraEnabled public String quotePartner{get; set;}
        @AuraEnabled public String quoteCCWDeal{get; set;}
        @AuraEnabled public String quoteSummary{get; set;}
        @AuraEnabled public String quoteCBN{get; set;}
        @AuraEnabled public String quoteCollaborated{get; set;}
        @AuraEnabled public String quoteInitiated{get; set;}
        @AuraEnabled public String quoteIntegrated{get; set;}
        @AuraEnabled public String quoteProductAmount{get; set;}
        @AuraEnabled public String quoteServiceAmount{get; set;}
        
        //This is the contructor method
        public pageValidationWrapper() {
            oppOwner = false;
            approvedFlag = false;
            oppOwnerError = System.Label.QI_Integration_InvalidUser_e;
            quoteProductAmount = Quote__c.Quote_Product_Net_Amount__c.getDescribe().getLabel();
            quoteServiceAmount = Quote__c.Quote_Service_Net_Amount__c.getDescribe().getLabel();
            quoteName = Quote__c.Name.getDescribe().getLabel();
            quoteId = Quote__c.DM_Quote_ID__c.getDescribe().getLabel();
            quotePartner = Quote__c.PartnerAcctId__c.getDescribe().getLabel();
            quoteCCWDeal = Quote__c.CCW_Deal_Status_MQ__c.getDescribe().getLabel();
            quoteSummary = Quote__c.Quote_Summary__c.getDescribe().getLabel();
            quoteCBN = Quote__c.CBN_Status__c.getDescribe().getLabel();
            quoteCollaborated = Quote__c.Is_Collaborated__c.getDescribe().getLabel();
            quoteInitiated = Quote__c.Initiated_By__c.getDescribe().getLabel();
            quoteIntegrated = Quote__c.Integrated_Quote__c.getDescribe().getLabel();
            spinnerTimout =  1000 * Integer.valueOf(Utilities.getConstant_CS('QI_spinner_time_period'));
            checkboxUncheckError =  System.Label.QI_checkbox_is_not_selected_Error;
            multipleSelectionError = System.Label.QI_Trigger_checkbox_selection_Error;
            passedFlag = 'Passed';
            autoReload = false;
            timeStamp = 0;
            inProgressFlag = 'Inprogress';
            selectedQuote = new QuotesWrapper(new Quote__c());
            failedFlag= 'Failed' ;
            wrappedQuotesList = new List<QuotesWrapper>();
            webServiceError = System.Label.QI_Integration_failed_Error;
            inProgressWarning   = System.Label.QI_InProgress_Warning_Message;
            successMessage    = System.Label.QI_Integration_Success_Message;
        }
    }
    
    
    @AuraEnabled
    public static pageValidationWrapper findQuoteDetails(Id oppId) {
        
        String validQuoteStatuses = Utilities.getConstant_CS('QI_Valid_Status');
        String invalidQuoteStatuses = Utilities.getConstant_CS('QI_Invalid_Status');
        String integrationDuration = Utilities.getConstant_CS('QI_Timer_for_Payload_Method');
        Set<String> validStatusList = new Set<String>(validQuoteStatuses.split(','));
        Set<String> invalidStatusSet = new Set<String>(invalidQuoteStatuses.split(','));
        List<Quote__c> quotesSelected = new List<Quote__c>();
        List<Quote__c> inValidQuotes = new List<Quote__c>();
        if(validStatusList != null &&  !validStatusList.isEmpty()){
            quotesSelected = [Select Id, Name,Integrate_Status__c, CCW_Deal_Status_MQ__c , 
                              CBN_Status__c, CCW_Deal_Status__c ,Quote_Service_Net_Amount__c, Quote_Product_Net_Amount__c,
                              Deal_ID__c , Initiated_By__c , Integrated_Quote__c,
                              PartnerAcctId__r.Name, Is_Collaborated__c , DM_Quote_ID__c ,
                              Quote_Summary__c,LastModifiedDate,Opportunity_Name__c  from Quote__c where Opportunity_Name__c = :oppId and 
                              CCW_Deal_Status_MQ__c IN :validStatusList];        
        }

        if(invalidStatusSet != null && !invalidStatusSet.isEmpty()){            
            inValidQuotes = [Select Id, Name, Integrate_Status__c , CCW_Deal_Status_MQ__c , 
                             CBN_Status__c, CCW_Deal_Status__c , Quote_Service_Net_Amount__c, Quote_Product_Net_Amount__c,
                             Deal_ID__c , Initiated_By__c , Integrated_Quote__c,
                             PartnerAcctId__r.Name, Is_Collaborated__c , DM_Quote_ID__c ,
                             Quote_Summary__c,LastModifiedDate,Opportunity_Name__c  from Quote__c where Opportunity_Name__c = :oppId and
                             CCW_Deal_Status_MQ__c IN :invalidStatusSet ];
        }
        
   
        pageValidationWrapper pageValidate = new pageValidationWrapper();
        for(Quote__c inQt : inValidQuotes ){
            QuotesWrapper inWrap = new QuotesWrapper(inQt);
            inWrap.ischeckbox = 'false';
            if((inQt.CCW_Deal_Status_MQ__c == 'Approved'  ||inQt.CCW_Deal_Status_MQ__c == 'Ordered')){
                pageValidate.disableButton = true;  
                pageValidate.pageBlock=true;
                pageValidate.approvedFlag = true;
                pageValidate.warningMsg = System.Label.QI_status_warning_message;
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, statusWarning));
            }
            if( pageValidate.timeStamp <= inQt.LastModifiedDate.getTime() ){
                pageValidate.timeStamp = inQt.LastModifiedDate.getTime() ; 
            }           
          pageValidate.wrappedQuotesList.add(inWrap);           
        }
        
        //Page block when Single quote is available on Opty
        //Code changes for enabling QI Trigger Framework for Single Quote
        if(quotesSelected.isEmpty() ){
            pageValidate.disableButton = true;  
        }else{
            
            for(Quote__c quote : quotesSelected)
            {
                if( quote.Integrate_Status__c == pageValidate.inProgressFlag  && (System.now().getTime() - quote.LastModifiedDate.getTime())<=Integer.valueOf(integrationDuration)){                 
                    pageValidate.pageBlock = true ;
                }
                if( pageValidate.timeStamp <= quote.LastModifiedDate.getTime() ){
                    pageValidate.timeStamp = quote.LastModifiedDate.getTime() ; 
                }
            }               
        }
        Boolean changeFlag = true;
        for(Quote__c quote : quotesSelected){
            QuotesWrapper wrap = new QuotesWrapper(quote);  
            // When quote is Inprogress state       
            if( quote.Integrate_Status__c == pageValidate.inProgressFlag  ){
            	pageValidate.selectedQuote  = wrap;
                wrap.selected = true;
                
                if( (System.now().getTime() - quote.LastModifiedDate.getTime())<=Integer.valueOf(integrationDuration) ){                 
                    pageValidate.ccwStatus = pageValidate.inProgressFlag  ;
                    changeFlag = false;
                }
                else if( (System.now().getTime() - quote.LastModifiedDate.getTime()) > Integer.valueOf(integrationDuration) ){
                    pageValidate.ccwStatus = pageValidate.failedFlag;
                }     
            }
            
            // When quote Integration passed state
            if( quote.Integrate_Status__c == pageValidate.passedFlag && quote.Integrated_Quote__c == 'Yes' && (System.now().getTime() - quote.LastModifiedDate.getTime())<=Integer.valueOf(integrationDuration) && !pageValidate.approvedFlag  ){
                pageValidate.selectedQuote  = wrap;
                wrap.selected = false;
                wrap.ischeckbox = 'false';
               // if(changeFlag) 
                    pageValidate.ccwStatus = pageValidate.passedFlag ;
                
            }
            
            //For displaying Error banner on PUI Page when Quote gets failed
            if( quote.Integrate_Status__c == pageValidate.failedFlag  && quote.LastModifiedDate.getTime()>=pageValidate.timeStamp  ){
                pageValidate.selectedQuote  = wrap;
                wrap.selected = false;
                pageValidate.ccwStatus = pageValidate.failedFlag ;                  
            }   
            //  enabling/disabling Checkbox for valid Quotes
            if(pageValidate.pageBlock==true || pageValidate.disableButton ==true || quote.Integrated_Quote__c == 'Yes'){
                wrap.ischeckbox = 'false';
            }else{
                wrap.ischeckbox = 'true';
            }           
            pageValidate.wrappedQuotesList.add(wrap);
        }
        if(pageValidate.ccwStatus == pageValidate.failedFlag  || pageValidate.ccwStatus == pageValidate.passedFlag || pageValidate.ccwStatus == pageValidate.inProgressFlag ){
            pageValidate = updatedQuoteValues(pageValidate.selectedQuote.qt, pageValidate.ccwStatus, pageValidate);
        }
        
        pageValidate.disableButton = true;
        for(QuotesWrapper QuotesWrapperElement : pageValidate.wrappedQuotesList) {
            if(QuotesWrapperElement.selected) {
                if(QuotesWrapperElement.qt.Integrate_Status__c == pageValidate.inProgressFlag) {
                    pageValidate.ccwStatus = pageValidate.inProgressFlag;
                }
            }
        }
       //return [select id, name from account limit 10 ];
       if([select ownerId from opportunity where id = :oppId].ownerId == UserInfo.getUserId()) {
            pageValidate.oppOwner = true;
            
        }
       return pageValidate;       
    }  
    
    
    public static pageValidationWrapper updatedQuoteValues(Quote__c selectedQuotesValues, String IntStatus, pageValidationWrapper pageValidate ){     
        if(selectedQuotesValues.Integrate_Status__c!=IntStatus ){   
        //Scava Fix 
         //if(flsUpdateGet(Quote__c.Integrate_Status__c )) {     
            selectedQuotesValues.Integrate_Status__c = IntStatus ;
        // }                    
            try{
                Update selectedQuotesValues;
            }catch(Exception e){
                 System.debug('Database Error==: '+ e);
            }           
      }  
        if(selectedQuotesValues.Integrate_Status__c==pageValidate.failedFlag){                   
                     pageValidate.pageBlock = false ;
                     pageValidate.disableButton = false; 
                     pageValidate.spinnerFlag = 'hidden' ;
                     pageValidate.selectedQuote = null;
                     pageValidate.failedQuoteID = selectedQuotesValues.DM_Quote_ID__c ;
                     pageValidate.webServiceError  = pageValidate.webServiceError.replace('####', selectedQuotesValues.DM_Quote_ID__c);
                     //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, webServiceError ));
         }else if(selectedQuotesValues.Integrate_Status__c == pageValidate.inProgressFlag  ){
                      pageValidate.disableButton = true;
                      pageValidate.pageBlock = true ; 
                      pageValidate.spinnerFlag = 'visible' ;
                      pageValidate.autoReload =true;
                      for(QuotesWrapper qw : pageValidate.wrappedQuotesList){
                          qw.ischeckbox = 'false';
                      }
                      
                      pageValidate.inProgressWarning   = pageValidate.inProgressWarning.replace('####', selectedQuotesValues.DM_Quote_ID__c);
                      //CheckReload();   
                       //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, inProgressWarning ));                        
          }else if(selectedQuotesValues.Integrate_Status__c == pageValidate.passedFlag ){
                  pageValidate.disableButton = false;
                  pageValidate.pageBlock = false ;  
                  pageValidate.spinnerFlag = 'hidden' ;  
                  pageValidate.selectedQuote = null;
                  pageValidate.successMessage = pageValidate.successMessage.replace('####', selectedQuotesValues.DM_Quote_ID__c);
                  //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, successMessage));         
          }
        return pageValidate;            
    } 

    @AuraEnabled
    public static pageValidationWrapper integrateQuoteProcess(String pageValidationWrapperDataS) {
       pageValidationWrapper pageValidationWrapperData = new pageValidationWrapper();
       pageValidationWrapperData = (pageValidationWrapper)JSON.deserialize(pageValidationWrapperDataS, pageValidationWrapper.class);
       
        String result = new GetIntegratedQuoteList().callPayloadService(pageValidationWrapperData.selectedQuote.qt.DM_Quote_Id__c);
        if(result=='SUCCESS'){
            pageValidationWrapperData.ccwStatus = pageValidationWrapperData.inProgressFlag  ;
        }else{
            if(result == 'webServiceError'){
                pageValidationWrapperData.webServiceError  = pageValidationWrapperData.webServiceError.replace('####', pageValidationWrapperData.selectedQuote.qt.DM_Quote_Id__c);
            }
            pageValidationWrapperData.ccwStatus = pageValidationWrapperData.failedFlag ;
        }
        pageValidationWrapperData = updatedQuoteValues(pageValidationWrapperData.selectedQuote.qt, pageValidationWrapperData.ccwStatus, pageValidationWrapperData);
return pageValidationWrapperData;
    }   


    public String callPayloadService(String quoteId){     
        JSONGenerator gen = JSON.createGenerator(true);
        List<long> intlist = new List<long>();
        intlist.add(long.valueOf(quoteId)); 
        String uuid = newGuid();
        String uuidrep = uuid.replace('-', '');
        Long l1 = Long.valueOf(uuidrep);       
        User currentuser=new User();
        currentuser=[Select Id,Name,Email from User where Id=:userinfo.getuserId()];
        string Cecid = currentuser.Email;
        String CecUId ='';
        
        if( Cecid != null && (Cecid.contains('@cisco.com') == true ||Cecid.contains('@CISCO.COM') == true ))
        {               
            CecUId = Cecid.substring(0,Cecid.indexOf('@')).trim().toLowerCase();
        }
        
        CcwIntegrationPayloadAppArea appAr = new CcwIntegrationPayloadAppArea();
        appAr.internalTransactionId =   l1   ;        
        appAr.consumerName  = 'QUOTING';
        appAr.transactionInput = '1058139976';
        
        CcwIntegrationPayloadDataArea datAr = new CcwIntegrationPayloadDataArea();
        datAr.userId = CecUId;
        datAr.jobId  = 'JOB'+CecUId+DateTime.now().getTime();                        //'JOB123458945' ;                      
        datAr.requestType = 'QI' ;                                
    //    datAr.topicName =  'SFDC';
        datAr.quoteObjectIds = intlist.clone();
        
        
        // Write data to the JSON string for body.
        gen.writeStartObject();        
        gen.writeFieldName('applicationArea');     
        gen.writeObject(appAr);   
        gen.writeFieldName('dataArea');
        gen.writeObject(datAr);
        gen.writeEndObject();       
        String xml = gen.getAsString();           
        String username = Utilities.getConstant_CS('QI_CCW_Webservice_Username');
        String password = Utilities.getConstant_CS('QI_CCW_Webservice_Password');       
        String url = Utilities.getConstant_CS('QI_CCW_RestAPI_URL');
        Blob headerValue = Blob.valueOf(username+':'+password);
        
        System.debug('check request body: ' + xml);
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(headerValue));
        req.setHeader('SOAPAction', 'cleanse');
        req.setHeader('Content-Type','application/json; charset=UTF-8');
        String reqBody = xml;    
        req.setHeader('Content-Length',''+reqBody.length());
        req.setTimeout(20000);
        req.setBody(reqBody);
        
        // attempt to connect to the CR service with populated input XML
        HttpResponse res;
        Map<String, Object> responseMap;
        try {
            res = h.send(req);
            String bodyRes = res.getBody();
           // Dom.Document doc = new Dom.Document();
            responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            
            if(res.getStatusCode() != 200)
            {                 
                 //webServiceError  = webServiceError.replace('####', this.selectedQuote.qt.DM_Quote_Id__c);
                 //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, webServiceError ));
                 return 'webServiceError';
            }
             
        //    return res.toString();
               return String.valueOf(responseMap.get('responseStatus')) ;
        } catch(System.CalloutException e){
               return String.valueOf('Callout error: '+ e) ;           
        }   
    }
    
    public static String newGuid() {
        String returnValue = '';
        Integer nextByte = 0;
        for (Integer i=0; i<16; i++) {
            if (i==4 || i==6 || i==8 || i==10) 
                returnValue += '-';
            nextByte = (Math.round(Math.random() * 255)-128) & 255;
            if (i==6) {
                nextByte = nextByte & 15;
                nextByte = nextByte | (4 << 4);
            }
            if (i==8) {
                nextByte = nextByte & 63;
                nextByte = nextByte | 128;
            }
            returnValue += getCharAtIndex(kHexChars, nextByte >> 4);
            returnValue += getCharAtIndex(kHexChars, nextByte & 15);
        }
        return returnValue.substring(0, 17);
    }
    
    public static String getCharAtIndex(String str, Integer index) {
        if (str == null) return null;
        if (str.length() <= 0) return str;    
        if (index == str.length()) return null;    
        return str.substring(index, index+1);
    }
    
    //Wrapper Class for Payload Input for App Area
    class CcwIntegrationPayloadAppArea {        
        Long internalTransactionId;
        String consumerName;
        String transactionInput;
        
    }
    
    //Wrapper Class for Payload Input for Data Area
    class CcwIntegrationPayloadDataArea {        
        String userId {get; set;}
        String jobId {get; set;}
        String requestType {get; set;}
    //String topicName {get; set;}
        List<Long> quoteObjectIds {get; set;}        
    }
    
    //SCAVA Helper Method to Update validate Access at field level
    Public static Boolean flsUpdateGet(SObjectField field) {
     return field.getDescribe().isUpdateable() ? true : false;
    }
        
}