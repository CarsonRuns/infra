public with sharing class Partner_Quote_Redirect_CTE {
    /*May 2018 Lightning Release change: start*/ 
    /*'Edit Integrated Quote' is clicked from Opportunity detail record page, opptyId is passed as parameter from url */
    String opptyId = ApexPages.currentPage().getParameters().get('opptyId');
    /*May 2018 Lightning Release change: end*/
    
    public Boolean hasMessage {get; protected set;}
    private final Quote__c Quote;
    private List<String> fieldsToRetrieve = new List<String>{'DM_Quote_ID__c', 'Id', 'Opportunity_Name__c', 'Opportunity_Name__r.RecordTypeId', 'Opportunity_Name__r.DealID__c', 'CCW_Deal_Status_MQ__c', 'Quote_Flags__c','Opportunity_Deal_Type__c'};
        private Set<Id> recordTypeList = new Set<Id>{'0123000000003yk', '012300000000CDL'};
            @TestVisible
            private Id profID = '00e30000000rUlK';
    @TestVisible
    private void setMessage(String message, Boolean isError) {
        this.hasMessage = true;
        ApexPages.addMessage(new ApexPages.Message(isError ? ApexPages.Severity.ERROR : ApexPages.Severity.INFO, message));
    }
    
    public PageReference redirect() {
        if (this.hasMessage) {
            return null;
        }
        
        User u = [SELECT Salesforce_API_Session__c FROM User WHERE Id =: UserInfo.getUserId()];
        String baseUrl = Utilities.getConstant_CS('PDR URL');
        String pdrDown = Utilities.getConstant_CS('PDR Down');
        String hostname = Url.getSalesforceBaseUrl().toExternalForm();
        String profileName = [SELECT Name FROM Profile WHERE Id =: UserInfo.getProfileId()].Name;
        String status = this.Quote.CCW_Deal_Status_MQ__c;
        String isArchived = this.Quote.Quote_Flags__c;
        String recordTypeId = this.Quote.Opportunity_Name__r.RecordTypeId;      
        String opptyType = 'partnerQuote';
        string dealTypeValue = string.valueof(this.Quote.Opportunity_Deal_Type__c); // Q1FY16 DRTM changes
        string sfdcmode = ApexPages.currentPage().getParameters().get('mode');
        //Added mode cls or lgt to send to CCW for navigation back and forth
        
        if (sfdcmode == null) 
        {
            if (UserInfo.getUiThemeDisplayed() == 'Theme3') {
                sfdcmode = 'cls'; 
            }
            else 
            {
                sfdcmode = 'lgt';
            }
        }
        
        if(dealTypeValue == '0'){
            dealTypeValue =''; 
        }
        
        if (this.recordTypeList.contains(recordTypeId) ) {
            opptyType = 'fieldQuote';
        }
        String PdrSkipUser =Utilities.getConstant_CS('PDR_Skip_Users');
        List<String> skipuser = PdrSkipUser.split(',');
        set<string> PdrSkipUsers = new set<string>(skipuser); 
        if (pdrDown == 'Yes' && (!profileName.startsWith('QA') && !pdrskipusers.contains(userinfo.getUserid().substring(0,15)))) {
            setMessage(System.Label.Quoting_unavailable+' '+System.Label.Quoting_capabilities, true);
            return null;
        } else if (status == 'DELETED') {
            setMessage('Quote on this opportunity has been deleted', true);
            return null;
        } else if (UserInfo.getProfileId() != profID) {
            if (isArchived == 'Archived') {
                return new PageReference('/apex/Quote_Archived?opptyId=' + this.Quote.Opportunity_Name__c);
            } else {
                PageReference pr = new PageReference(baseUrl + '/SFDCRequestHandler');
                Map<String, String> urlParameters = pr.getParameters();
                urlParameters.put('at',         opptyType);
                urlParameters.put('optyNumber', this.Quote.Opportunity_Name__r.DealID__c);
                urlParameters.put('quoteId',    this.Quote.DM_Quote_ID__c);
                urlParameters.put('userid',     UserInfo.getUserId());
                urlParameters.put('email',      UserInfo.getUserEmail());
                urlParameters.put('sessionid',  u.Salesforce_API_Session__c);
                urlParameters.put('url',        hostname + '/services/Soap/c/11.0/' + UserInfo.getOrganizationId().substring(0,15));
                urlParameters.put('hostname',   hostname);
                urlParameters.put('dealType',   dealTypeValue); // Q1FY16 DRTM changes
                urlParameters.put('mode',   sfdcmode); 
                return pr;
            }
        } else {
            setMessage('<b>Insufficient Privileges </b><br>You do not have the level of access necessary to Edit the record.', true);
            return null;
        }
    }
    
    public Partner_Quote_Redirect_CTE(ApexPages.StandardController stdController) {
        this.hasMessage = false;
        
        if (!Test.isRunningTest()) {
            stdController.addFields(fieldsToRetrieve);
        }
        /*May 2018 Lightning Release change: start*/
        // this.Quote = (Quote__c)stdController.getRecord(); 
        /*Edit Integrated Quote clicked from Opportunity detail record page, Integrated quoted needs to be retrieved by opptyId*/  
        if (opptyId != null){   
            Quote__c quote = [SELECT Id, CCW_Deal_Status_MQ__c, Quote_Flags__c, Opportunity_Name__c, Opportunity_Deal_Type__c, DM_Quote_ID__c, Opportunity_Name__r.DealID__c, Opportunity_Name__r.RecordTypeId FROM Quote__c WHERE Opportunity_Name__c =: opptyId and Integrated_Quote__c ='Yes'];          
            if(quote !=null  ){
                this.Quote = quote;
            }
        }
        /*Edit Quote clicked from Quote related list*/
        else{
            this.Quote = (Quote__c)stdController.getRecord();            
        }
        /*May 2018 Lightning Release change: end*/
        
        //check data and generate url
        if (this.Quote == null || this.Quote.id == null) {
            setMessage('Unexpected error occured', true);
        }
    }
}