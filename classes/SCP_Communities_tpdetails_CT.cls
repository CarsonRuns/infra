public with sharing class SCP_Communities_tpdetails_CT {

    public Assigned_Partner__c tp { get; set; }
    public Integer daysLeft{get;set;}
    public boolean isExtendButtonRendered{get;set;}
    public boolean isExtendButtonDisabled{get;set;}
    
    public boolean isPA {
    	get {
    		return (prmFilterUtility.isPA);
    	}
    }
    public String extendMessage{
        get{
            if(this.tp.Expiration_Date__c != null){
                extendMessage = Label.PRM_extendmsg;
                String daysBetween = String.valueOf(Date.today().daysBetween(this.tp.Expiration_Date__c));
                extendMessage = this.extendMessage.replaceFirst('\\{0\\}', daysBetween);
            }else{
                extendMessage = null;
            }
            return extendMessage;
        }
        set;
    }

    public SCP_Communities_tpdetails_CT(ApexPages.StandardController stdCon) {
    	System.debug('SCP_Communities_tpdetails_CT: Start Constructor');
        	this.tp = (Assigned_Partner__c) stdCon.getRecord();
         this.initTpExtension();
        System.debug('SCP_Communities_tpdetails_CT: End Constructor');
   }

    /**
     * @description Controller contructor helper method to determine visibility of 'Extend' button to partner user
     *              Set the extend buttons render and disable boolean variable and adds warning info message to user
     */
    public void initTpExtension(){
        System.debug('SCP_Communities_tpdetails_CT.initTpExtension(): Start initTpExtension');
        this.daysLeft = 0;
        this.isExtendButtonRendered = false;
        //only apply for TP records whose expiration dates is not null
        if(this.tp.Expiration_Date__c != null){
            Integer extendCount = 0;
            //Get TP count of extension
            List<AggregateResult> extendCountAggResult = [Select count(a.Id) ExtendCount from Prospect_Extension__c a 
                            where a.Target_Prospect__c= :this.tp.Id AND a.Extension_Reason__c = 'Explicit Extension by Partner' 
                            AND CreatedDate > :this.tp.CreatedDate];
            if(extendCountAggResult.size()>0){
                extendCount = (Integer) extendCountAggResult[0].get('ExtendCount');
            }
            
            daysLeft = Date.today().daysBetween(this.tp.Expiration_Date__c);
            if(extendCount == 0 && daysLeft <= 14 && daysLeft > 0 ){
                String extendMessage = Label.PRM_extendmsg;
                String daysBetween = String.valueOf(daysLeft);
                extendMessage = this.extendMessage.replaceFirst('\\{0\\}', daysBetween);
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'' + extendMessage));
                this.isExtendButtonRendered = true;
                this.isExtendButtonDisabled = false;
            }else{
                this.isExtendButtonRendered = true;
                this.isExtendButtonDisabled = true;
            }
        }
        System.debug('SCP_Communities_tpdetails_CT.initTpExtension(): End initTpExtension');
    }
    /**
     * @description Default action method called for the TP Detail VF page.  Determines the page redirect based on
     *              user profiles.  The redirects apply as follows
     *              Standard TP View: Apply for all 
     *              TP Detail VF Page: Only users with partner profiles and admin
     */
    public PageReference redirect() {
        System.debug('SCP_Communities_tpdetails_CT.initTpExtension(): Start redirect');
        PageReference viewPage = null;
        Profile p = [select name from Profile where id = 
                :UserInfo.getProfileId()];
        if (!'POC - Partner Community'.equals(p.name) && !'Partner360_Portal_Profile'.equals(p.name)){
            viewPage =  New PageReference('/'+tp.Id + '/d?nooverride=1');
            viewPage.setRedirect(true);
        }
        
        System.debug('SCP_Communities_tpdetails_CT.initTpExtension(): End redirect');
        return viewPage;
    }
    
    public PageReference extend(){
        System.debug('extend(): Start extend');
        Boolean isTpExtensionFailed = false;
        if(this.tp.Expiration_Date__c != null) {
            this.tp.Extend_By__c = '30 Days';
            this.tp.Extension_Reason__c = 'Explicit Extension by Partner';

            try{
                System.debug('extend(): Update TP Rec');
                update this.tp;
            }catch(DmlException dmlEx){
                System.debug('extend(): DmlException');
                System.debug(dmlEx);
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'' + dmlEx));
                isTpExtensionFailed = true;
            }catch(Exception ex){
                System.debug('extend(): Exception');
                System.debug(ex);
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'' + ex));
                isTpExtensionFailed = true;
            }
        }
        
        System.debug('extend(): Update Fail?'+isTpExtensionFailed);
        PageReference extendRedirect = null;
        if(!isTpExtensionFailed){
            //getting error when redirecting page back to tp record, will return null and rerender extend button and details
            this.isExtendButtonDisabled = true;
            //extendRedirect = new PageReference('/'+this.tp.Id + '/d');
            //extendRedirect.setRedirect(true);
        }
        System.debug('extend(): Redirect PageReference');
        System.debug(extendRedirect);
        return null;
    }
    
    public PageReference initiateDeal(){
        System.debug('initiateDeal(): Start initiateDeal');
        Boolean isTpExtensionFailed = false;
        if(this.tp.Expiration_Date__c != null) {
            this.tp.Extend_By__c = '60 Days';
            this.tp.Extension_Reason__c = 'New Deal Extensions';

            try{
                System.debug('initiateDeal(): Update TP Rec');
                System.debug(this.tp);
                update this.tp;
            }catch(DmlException dmlEx){
                System.debug('initiateDeal(): DmlException');
                System.debug(dmlEx);
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'' + dmlEx));
                isTpExtensionFailed = true;
            }catch(Exception ex){
                System.debug('initiateDeal(): Exception');
                System.debug(ex);
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'' + ex));
                isTpExtensionFailed = true;
            }
        }
        
        System.debug('initiateDeal(): Update Successfull?'+isTpExtensionFailed);
        PageReference initiateDealCCW = null;
        if(!isTpExtensionFailed){
            String amCCOId=''; 
            String sfdcAccountId = this.tp.Customer_Account__c; 
            String targetprospectId= this.tp.Id; 
            String prefLang = prmFilterUtility.loggedInUserGadgetLanguage;
    
            if(this.tp.TBM_TAM_Username__c!=null){ 
                amCCOId = this.tp.TBM_TAM_Username__c.substringBefore('@'); 
            }
            
            
            String createAccDealURL = CCW_Urls__c.getInstance().createDealUrl__c + 
            '?amCcoId=' + amCCOId + 
            '&sfdcAccountId=' + sfdcAccountId + 
            '&sfdcLeadFlag=TP' + 
            '&targetProspectLeadId=' + targetprospectId + 
            '&localeChanged=' + prefLang; 
            
            initiateDealCCW = new PageReference(createAccDealURL);
            System.debug(createAccDealURL);
            initiateDealCCW.setRedirect(true);
        }
        
        System.debug('initiateDeal(): End initiateDeal');
        return initiateDealCCW;
    }
    
    public PageReference viewAllDeals(){
        String role = '';
        String prefLang = prmFilterUtility.loggedInUserGadgetLanguage;
        String remoteUser = prmFilterUtility.logUser.Contact.CCO_ID__c;

        String customerId = tp.Customer_Account__c;
        if(prmFilterUtility.isPA){
            role = 'PA';
        } else if (prmFilterUtility.isPSR) {
            role = 'PSR';
        }
        String viewAccDealURL = CCW_Urls__c.getInstance().viewDealUrl__c+'?actionType=showP360Deals&partnerCCOID='
            + remoteUser
            + '&sfdcAccountId='
            + customerId
            + '&partnerRole=' + role + '&localeChanged=' + prefLang;
        
        PageReference viewAllDeals = new PageReference(viewAccDealURL);
        viewAllDeals.setRedirect(true);
        return viewAllDeals;
    }
    
    public PageReference addEditPSR() {
    	String url = '/apex/SCP_Communities_psrFilterLookup';
    	PageReference psrLookup = new PageReference(url);
    	psrLookup.getParameters().put('Id',tp.Id);
    	psrLookup.setRedirect(true);
    	System.debug(System.LoggingLevel.INFO, '$$$$ psrLookup : '+psrLookup+' Page.SCP_Communities_psrFilterLookup : '+Page.SCP_Communities_psrFilterLookup);
    	return psrLookup;
    	
    }
}