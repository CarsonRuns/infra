public class Opty {
// This class is for Quoting
    /* Opportunity Header Information */
    /* Required Fields */
    String name;
    String sfdcAcctId;
    String currCode;
    String ownerId;
    String dealId = '';
    String fcstPostn = '';
    String errMsg = '';
    List<ProductItem> piList = new List<ProductItem>();
    List<ServiceItem> siList = new List<ServiceItem>();
    //Map<String, String> labels = new Map<String, String>{'name'=>'Opportunity Name','sfdcAcctId'=>'SFDC Account ID','currCode'=>'Currency Code','ownerId'=>'Owner ID','dealId'=>'Deal ID','crSiteId'=>'CR Site Target ID','crCompanyId'=>'CR Company Target ID','fcstPostn'=>'Forecast Position'};
    Map<String, String> labels = new Map<String, String>{'name'=>'Opportunity Name','sfdcAcctId'=>'SFDC Account ID','ownerId'=>'Owner ID','expDate'=>'Expected Book Date'};
    /* Optional Fields */
    String territoryId;
    String salesPath;
    String nstcpe = 'None'; //QC default
    String dDStatus;
    String salesProg;
    String managedSvc;
    String note;
    String discAprvl = 'None'; //QC default
    String prodEnh = 'Not Required'; //QC default
    String origProdEnh = '';
    String origDiscAprvl = '';
    String origNstcpe = '';
    String userTheater = '';
    
    //Added by jwoodfin while Miura was out siping mai tais on PTO
    String expPrdLstAmt;
    String expSvcLstAmt;
    String prdQutAmt;
    String svcQutAmt;
    
    //Added part of solution id project with release FYQ15-Apr
    String solutionId ='';
    
    //Added as part of Q1FY16 SW1003 project to populate DealType 
    Integer approvalRoute = null;
    boolean partnerRequired = false;
    String region=''; //GDM change for GlobalOpportunity update
    /* Opportunity Detail Information */
    /* Required Fields */
    //String pName;
    String expDate = '';
    String expPrdRev;
    String expSvcRev;
    String pullFwdDate = '';
    String stageName = '2 - Qualification';
    String defaultStageName = '2 - Qualification'; //QC default, changed from 3 to 2 by ISP DEC 08
    String origStageName = '';
    string crpFlag = '';
//    boolean inputStageNameFlag = true; //Assume input Stage Name is null
    Set<String>validFcstStatus = new Set<String>{'Commit','Upside','Not Forecastable'};  //
    Set<String>validOptyStatus = new Set<String>{'Active','Booked','Cancelled','List','Error'};
    String status = 'Active'; //QC default
    String ptnrStatus = '';
    String fcstStatus = 'Upside'; //QC default, modified by ISP DEC 08
    /* Optional Fields */
    String ssrEmailId = '';
    String svcSource;
    String contractNo;
    String startDate = '';
    String expireDate = '';
    String dealCreateDate = '';
    String endDate = '';
    List<String> competitor = new List<String>{};
    List<String> salesPgm = new List<String>{};
    String camUserId = '';
    String promoId = '';
    String promoCode = '';
    String promoName = '';
    String progName = '';
    String discType = '';
    String eligibleNS = '';
    String descrip = '';
    String futureTechReqd = '';
    String omfNotes = '';
    String reasonCode = '';
    String discApproval = '';
    String ptnrDealType = '';
    String globalDealId = '';
    String quoteUpdatedBy = '';
    String quoteUpdatedDt = '';
    String dmCode = '';
    String dmDesc = '';
    String sourceSystem = 'PDR';
    String sourceKey = '';
    String quoteID = '';
    String CBNStatus = '';
    String quoteName = '';
    String IsFinalized = '';
    String IsDummyQuote = '';
    String P360Flag = '';
    String LeadID = '';
    //New flag added to check for conversion of the associated lead with the deal
    String P360LeadFlag = '';
    String DealSource = '';
    String DealStatus_Lead = '';
    String ExpectedProductListAmount_Lead = '';
    String PromotionName_Lead = '';
    String ProgramName_Lead = '';
    String DealCreateDate_Lead = '';
    String DiscountType_Lead = '';
    String ExpectedServiceListAmount_Lead = '';
    String EligibleForNS_Lead = '';
    String DealExpirationDate_Lead = '';
    String DealDeskStatus_Lead = '';
    String OptyName_Lead = '';
    String QuoteProductNetPrice = '';
    String QuoteServiceNetPrice = '';
    String QuoteProductListPrice = '';
    String QuoteServiceListPrice = '';
    String Is_FA_Flag = '';
    String Is_At_Or_Below_Flag = '';
    String Is_Collaborated = '';
    
    /* Accessor Methods for Opportunity Header */
    /* Mandatory Fields */
    public void setName(String iName) {
        name = iName;
        reqCheck(iName, 'name');
    }
    /* Validation check to ensure opportunity name is unique */
    public String getName() {
        // Skip the Opty name validation rule check for P360 leads
        if(getP360Flag() == 'N' && getP360LeadFlag() == 'N'){
        try {
            Opportunity o = [select Id from Opportunity where Name = :name and AccountId = :sfdcAcctId limit 1];
            throw new Opty.OptyException('SFDC-10: Opportunity Name: '+name+' for Account ID: '+sfdcAcctId+' already exists in SFDC');
            }
        catch (QueryException qe) {
            return name;
            }
        }
        else{
        return name;
            }
        }
            
    /* Get the Partner Opportunity record type */
    public String getRecordType(String recType) {
        try {
            RecordType rt = [select Id from RecordType where Name = :recType];
            return rt.Id;
        }
        catch (QueryException qe) {
            throw new Opty.OptyException('SFDC-12: '+recType+' Record Type does not exist in SFDC');
        }
    }
    public ProductItem getProductItem(Integer i) {
        return piList.get(i);
    }
    public Integer getProductItemSize() {
        return piList.size();
    }
    public void setProductItem(ProductItem pi) {
        piList.add(pi);
    }
    public Integer getServiceItemSize() {
        return siList.size();
    }
    public ServiceItem getServiceItem(Integer i) {
        return siList.get(i);
    }
    public void setServiceItem(ServiceItem si) {
        siList.add(si);
    }
    public void setSrcSys(String iSrcSys) {
        if (iSrcSys != '') {
            sourceSystem = iSrcSys;
        }
    }
    public String getSrcSys() {
        return sourceSystem;
    }
    public void setSrcKey(String iSrcKey) {
        if (iSrcKey != '') {
            sourceKey = iSrcKey;
        }
    }
    public String getSrcKey() {
        return sourceKey;
    }
    public void setFcstPostn(String iFcstPostn) {
        fcstPostn = iFcstPostn;
        reqCheck(iFcstPostn, 'fcstPostn');
    }
    public String getFcstPostn() {
        return fcstPostn;
    }
    public ProductItem getNewProductItem() {
        return new ProductItem();
    }
    public ServiceItem getNewServiceItem() {
        return new ServiceItem();
    }
    public void setErrMsg(String iErrMsg) {
        if (errMsg != '') {
            errMsg += '::';
        }
        errMsg += iErrMsg;
    }
    public String getErrMsg() {
        return 'SFDC-18: ' + errMsg;
    }
    public void setSfdcAcctId(String iSfdcAcctId) {
        sfdcAcctId = iSfdcAcctId;
        reqCheck(iSfdcAcctId, 'sfdcAcctId');
    }
    public String getSfdcAcctId() {
        return sfdcAcctId;
    }
    public void setCurrCode(String iCurrCode) {
        currCode = iCurrCode;
        reqCheck(iCurrCode, 'currCode');
    }
    public String getCurrCode() {
        return currCode;
    }
    public void setOwnerId(String iOwnerId) {
        ownerId = iOwnerId;
        reqCheck(iOwnerId, 'ownerId');
    }
    public String getOwnerId() {
        return ownerId;
    }
    public String getSFDCUserId() {
        return getSFDCUserId(ownerId);
    }
    /*
     * Fetch the ID from the User object for the owner ID passed in
     * - expected input is CEC ID
     */
    public String getSFDCUserId(String cecId) {
        try {
            String queryOwnerId = cecId+'@cisco.com%';
            User u = [Select Id, theatre__c from User where UserName like :queryOwnerId and isActive=true];
            userTheater = String.valueOf(u.theatre__c);
            return u.Id;
        }
        catch (QueryException qe) {
            throw new Opty.OptyException('SFDC-1: '+cecId+' does not exist in SFDC or is inactive');
        }
    }
    public void setDealId(String iDealId) {
        dealId = iDealId;
        reqCheck(iDealId, 'dealId');
    }
    public String getDealId() {
        return dealId;
    }
    public String getUserTheater() {
        return userTheater;
    }

    /* Optional Fields */
    public void setFutureTechReqd(String iFutureTechReqd) {
        if (iFutureTechReqd.toUpperCase().equals('TRUE')) {
            futureTechReqd = 'Required';
        }
        else {
            futureTechReqd = 'Not Required';
        }
    }
    public String getFutureTechReqd() {
        return futureTechReqd;
    }
    public void setEligibleNS(String iEligibleNS) {
        string elegableID=iEligibleNS.substring(0,1);
        eligibleNS = elegableID;
    }
    public String getEligibleNS() {
        return eligibleNS;
    }
    public void setSalesPath(String iSalesPath) {
        salesPath = iSalesPath;
    }
    public String getSalesPath() {
        return salesPath;
    }
    public void setOMFNotes(String iOMFNotes) {
        omfNotes = iOMFNotes;
    }
    public String getOMFNotes() {
        return omfNotes;
    }
    public void setReasonCode(String iReasonCode) {
        reasonCode = iReasonCode;
    }
    public String getReasonCode() {
        return reasonCode;
    }
    public void setPromoId(String iPromoId) {
        promoId = iPromoId;
    }
    public String getPromoId() {
        return promoId;
    }
    public void setPromoCode(String iPromoCode) {
        promoCode = iPromoCode;
    }
    public String getPromoCode() {
        return promoCode;
    }
    public void setPromoName(String iPromoName) {
        promoName = iPromoName;
    }
    public String getPromoName() {
        return promoName;
    }
    public void setProgName(String iProgName) {
        progName = iProgName;
    }
    public String getProgName() {
        return progName;
    }
    public void setDiscType(String iDiscType) {
        discType = iDiscType;
    }
    public String getDiscType() {
        return discType;
    }
    public void setNstcpe(String iNstcpe) {
        setOrigNstcpe(iNstcpe);
        if (iNstcpe != '') {
            nstcpe = iNstcpe;
        }
    }
    public void setOrigNstcpe(String iNstcpe) {
        origNstcpe = iNstcpe;
    }
    public String getOrigNstcpe() {
        return origNstcpe;
    }
    public String getNstcpe() {
        return nstcpe;
    }
    public void setDiscAprvl(String iDiscApproval) {
        setOrigDiscAprvl(iDiscApproval);
        if (iDiscApproval != '') {
            discAprvl = iDiscApproval;
        }
    }
    public void setOrigDiscAprvl(String iDiscApproval) {
        origDiscAprvl = iDiscApproval;
    }
    public String getOrigDiscAprvl() {
        return origDiscAprvl;
    }
    public String getDiscAprvl() {
        return discAprvl;
    }
    public void setProdEnh(String iProdEnh) {
        setOrigProdEnh(iProdEnh);
        if (iProdEnh != '') {
            if (iProdEnh.toUpperCase().equals('TRUE')) {
                prodEnh = 'Required';
            }
            else {
                prodEnh = 'Not Required';
            }
//            prodEnh = iProdEnh;
        }
    }
    public void setOrigProdEnh(String iProdEnh) {
        origProdEnh = iProdEnh;
    }
    public String getOrigProdEnh() {
        return origProdEnh;
    }
    public String getProdEnh() {
        return prodEnh;
    }
    public void setDDStatus(String iDDStatus) {
        dDStatus = iDDStatus;
    }
    public String getDDStatus() {
        return dDStatus;
    }
    public void setTerritoryId(String iTerritoryId) {
        territoryId = iTerritoryId;
    }
    public String getTerritoryId() {
        return territoryId;
    }
    public void setSalesProg(String iSalesProg) {
        salesProg = iSalesProg;
    }
    public String getSalesProg() {
        return salesProg;
    }
    public void setManagedSvc(String iManagedSvc) {
        managedSvc = iManagedSvc;
    }
    public static String processManagedSvc(String iExistigMgdSvc,String iNewMgdSvc) {
        List<String> tmpList = iExistigMgdSvc.split(';');
        Set<String> tmpSet = new Set<String>();
        tmpSet.addAll(tmpList);
        //If the existing value contains the new MS, keep what is already there
        if (tmpSet.contains(iNewMgdSvc)) {
            return iExistigMgdSvc;
        }
        //Otherwise, add the new MS to the existing list
        else {
            return iExistigMgdSvc + ';' + iNewMgdSvc;
        }
    }
    public String getManagedSvc() {
        return managedSvc;
    }
    public void setNote(String iNote) {
        note = iNote;
    }
    public String getNote() {
        return note;
    }
    public void setPtnrDealType(String iPtnrDealType) {
        ptnrDealType = iPtnrDealType;
    }
    public String getPtnrDealType() {
        return ptnrDealType;
    }
    public void setGlobalDealId(String iGlobalDealId) {
        globalDealId = iGlobalDealId;
    }
    public String getGlobalDealId() {
        return globalDealId;
    }
    public void setQuoteUpdatedBy(String iQuoteUpdatedBy) {
        quoteUpdatedBy = iQuoteUpdatedBy;
    }
    public String getQuoteUpdatedBy() {
        return quoteUpdatedBy;
    }
    public void setQuoteUpdatedDt(String iQuoteUpdatedDt) {
        quoteUpdatedDt = iQuoteUpdatedDt;
    }
    public Datetime getQuoteUpdatedDt() {
        return StrToDatetime(quoteUpdatedDt, 'Quote Updated Date');
    }
    public void setExpPrdLstAmt(String iExpPrdLstAmt) {
        expPrdLstAmt = iExpPrdLstAmt;
    }
    public String getExpPrdLstAmt() {
        return expPrdLstAmt;
    }
    public void setQuoteId(String iQuoteID) {
        quoteID = iQuoteID;
    }
    public String getQuoteId() {
        return quoteID;
    }
    public void setCBNStatus(String iCBNStatus) {
        CBNStatus = iCBNStatus;
    }
    public String getCBNStatus() {
        return CBNStatus;
    }
    public void setQuoteName(String iQuoteName){
        quoteName = iQuoteName;
    }
    public String getQuoteName(){
        return quoteName;
    }
    public void setIsFinalized(String iIsFinalized){
        IsFinalized = iIsFinalized;
    }
    public String getIsFinalized(){
        return IsFinalized;
    }
    public void setIsDummyQuote(String iIsDummyQuote){
        IsDummyQuote = iIsDummyQuote;
    }
    public String getIsDummyQuote(){
        return IsDummyQuote;
    }
    public void setP360Flag(String iP360Flag){
        P360Flag = iP360Flag;
    }
    public String getP360Flag(){
        return P360Flag;
    }
    public void setLeadID(String iLeadID){
        LeadID = iLeadID;
    }
    public String getLeadID(){
        return LeadID;
    }
    public void setP360LeadFlag(String iP360LeadFlag){
        P360LeadFlag = iP360LeadFlag;
    }
    public String getP360LeadFlag(){
        return P360LeadFlag;
    }
    public void setDealSource(String iDealSource){
        DealSource = iDealSource;
    }
    public String getDealSource(){
        return DealSource;
    }
    // Changes for Q3FY13 release i.e. fields of deals to leads object
    public void setDealStatus_Lead(String iDealStatus_Lead){
        DealStatus_Lead = iDealStatus_Lead;
    }
    public String getDealStatus_Lead(){
        return DealStatus_Lead;
    }
    public void setExpectedProductListAmount_Lead(String iExpectedProductListAmount_Lead){
        ExpectedProductListAmount_Lead = iExpectedProductListAmount_Lead;
    }
    public String getExpectedProductListAmount_Lead(){
        return ExpectedProductListAmount_Lead;
    }
    public void setPromotionName_Lead(String iPromotionName_Lead){
        PromotionName_Lead = iPromotionName_Lead;
    }
    public String getPromotionName_Lead(){
        return PromotionName_Lead;
    }
    public void setProgramName_Lead(String iProgramName_Lead){
        ProgramName_Lead = iProgramName_Lead;
    }
    public String getProgramName_Lead(){
        return ProgramName_Lead;
    }
    /*public void setDealCreateDate_Lead(String iDealCreateDate_Lead){
        DealCreateDate_Lead = iDealCreateDate_Lead;
    }
    public String getDealCreateDate_Lead(){
        return DealCreateDate_Lead;
    }*/
    public void setDealCreateDate_Lead(String iDealCreateDate_Lead) {
        dealCreateDate_Lead = iDealCreateDate_Lead;
    }
    public Date getDealCreateDate_Lead() {
        return StrToDate(DealCreateDate_Lead, 'Deal Create Date Lead');
    }
    public void setDiscountType_Lead(String iDiscountType_Lead){
        DiscountType_Lead = iDiscountType_Lead;
    }
    public String getDiscountType_Lead(){
        return DiscountType_Lead;
    }
    public void setExpectedServiceListAmount_Lead(String iExpectedServiceListAmount_Lead){
        ExpectedServiceListAmount_Lead = iExpectedServiceListAmount_Lead;
    }
    public String getExpectedServiceListAmount_Lead(){
        return ExpectedServiceListAmount_Lead;
    }
    public void setEligibleForNS_Lead(String iEligibleForNS_Lead){
        EligibleForNS_Lead = iEligibleForNS_Lead;
    }
    public String getEligibleForNS_Lead(){
        return EligibleForNS_Lead;
    }
    /*public void setDealExpirationDate_Lead(String iDealExpirationDate_Lead){
        DealExpirationDate_Lead = iDealExpirationDate_Lead;
    }
    public String getDealExpirationDate_Lead(){
        return DealExpirationDate_Lead;
    }*/
    public void setDealExpirationDate_Lead(String iDealExpirationDate_Lead) {
        dealExpirationDate_Lead = iDealExpirationDate_Lead;
    }
    public Date getDealExpirationDate_Lead() {
        return StrToDate(DealExpirationDate_Lead, 'Deal Expiration Date Lead');
    }
    public void setDealDeskStatus_Lead(String iDealDeskStatus_Lead){
        DealDeskStatus_Lead = iDealDeskStatus_Lead;
    }
    public String getDealDeskStatus_Lead(){
        return DealDeskStatus_Lead;
    }
    public void setOptyName_Lead(String iOptyName_Lead){
        OptyName_Lead = iOptyName_Lead;
    }
    public String getOptyName_Lead(){
        return OptyName_Lead;
    }
    public void setIs_FA_Flag(String iIs_FA_Flag) {
        Is_FA_Flag = iIs_FA_Flag;
    }
    public String getIs_FA_Flag() {
        return Is_FA_Flag;
    }
    public void setIs_At_Or_Below_Flag(String iIs_At_Or_Below_Flag) {
        Is_At_Or_Below_Flag = iIs_At_Or_Below_Flag;
    }
    public String getIs_At_Or_Below_Flag() {
        return Is_At_Or_Below_Flag;
    }
    public void setIs_Collaborated(String iIs_Collaborated) {
        Is_Collaborated = iIs_Collaborated;
    }
    public String getIs_Collaborated() {
        return Is_Collaborated;
    }
    public void setQuoteProductNetPrice(String iQuoteProductNetPrice){
        QuoteProductNetPrice = iQuoteProductNetPrice;
    }
    public String getQuoteProductNetPrice(){
        return QuoteProductNetPrice;
    }
    public void setQuoteServiceNetPrice(String iQuoteServiceNetPrice){
        QuoteServiceNetPrice = iQuoteServiceNetPrice;
    }
    public String getQuoteServiceNetPrice(){
        return QuoteServiceNetPrice;
    }
    public void setQuoteProductListPrice(String iQuoteProductListPrice){
        QuoteProductListPrice = iQuoteProductListPrice;
    }
    public String getQuoteProductListPrice(){
        return QuoteProductListPrice;
    }
    public void setQuoteServiceListPrice(String iQuoteServiceListPrice){
        QuoteServiceListPrice = iQuoteServiceListPrice;
    }
    public String getQuoteServiceListPrice(){
        return QuoteServiceListPrice;
    }
    /* Convert String revenue to Decimal */
    public Decimal getExpPrdLstAmtDec() {
        try {
            Decimal lstDec;
            if(expPrdLstAmt != null){ 
                lstDec = Decimal.valueOf(expPrdLstAmt);
            } 
            return lstDec;
        }
        catch (TypeException te) {
            throw new Opty.OptyException('SFDC-13: Expected Product List Amount '+expPrdLstAmt+' has '+te.getMessage());
        }
    }
    
    public void setExpSvcLstAmt(String iExpSvcLstAmt) {
        expSvcLstAmt = iExpSvcLstAmt;
    }
    public String getExpSvcLstAmt() {
        return expSvcLstAmt;
    }
    
    /* Convert String revenue to Decimal */
    public Decimal getExpSvcLstAmtDec() {
        try {
            Decimal lstDec;
            if(expSvcLstAmt != null) {
                lstDec = Decimal.valueOf(expSvcLstAmt);
            }
            return lstDec;
        }
        catch (TypeException te) {
            throw new Opty.OptyException('SFDC-14: Expected Service List Amount '+expSvcLstAmt+' has '+te.getMessage());
        }
    }
    
    
    public void setPrdQutAmt(String iPrdQutAmt) {
        prdQutAmt = iPrdQutAmt;
    }
    public String getPrdQutAmt() {
        return prdQutAmt;
    }
    
    /* Convert String revenue to Decimal */
    public Decimal getPrdQutAmtDec() {
        try {
            Decimal qutDec = 0.0;
            if(prdQutAmt != null) {
                qutDec = Decimal.valueOf(prdQutAmt);        
            }
            return qutDec;
        }
        catch (TypeException te) {
            throw new Opty.OptyException('SFDC-15: Product Quote Amount '+prdQutAmt+' has '+te.getMessage());
        }
    }
    
    public void setSvcQutAmt(String iSvcQutAmt) {
        svcQutAmt = iSvcQutAmt;
    }
    public String getSvcQutAmt() {
        return svcQutAmt;
    }
    
    //Added part of solution id project with release FYQ15-Apr
    public void setsolutionId(String solutionIdval){
            solutionId = solutionIdval;
    }
    public string getsolutionId(){
        return solutionId;
    }
    // Ends solution Id project changes
    
    //Added as part of SW1003 project with release-Q1FY16 starts here
    public void setapprovalRoute(integer dealtypevalue){
            approvalRoute = dealtypevalue;
    }
    public integer getapprovalRoute(){
        return approvalRoute;
    } 
   //GDM Q3FY17 Change for Global Opportunity Id linkage
    public void setregion(string reg){
        region = reg;
    }
    public string getregion(){
        return region;
    }
    //GDM Change ends here
    public void setpartnerRequired(boolean partnerRequiredFlag){
            partnerRequired = partnerRequiredFlag;
    }
    public boolean getpartnerRequired(){
        return partnerRequired;
    }
    //Ends of SW project changes release- Q1FY16
    
    /* Convert String revenue to Decimal */
    public Decimal getSvcQutAmtDec() {
        try {
            Decimal qutDec = 0.0; 
            if(svcQutAmt != null) {
                qutDec = Decimal.valueOf(svcQutAmt);
                //return qutDec;
            }
            return qutDec;
        }
        catch (TypeException te) {
            throw new Opty.OptyException('SFDC-16: Service Quote Amount '+svcQutAmt+' has '+te.getMessage());
        }
    }
    /*
     * The labels map contains the required fields
     * - each time a field is set and is not null, the field will be removed from the map
     */ 
    public void reqCheck(String fieldVal, String fieldName) {
        if (fieldVal != '') {
            labels.remove(fieldName);
        }
    }
    /*
     * Opportunity validity check to ensure all required fields are set
     * - if the labels map is empty, all fields were set, so return true
     * - if map is not empty, return false and set the missing fields in the error message
     */
    public boolean isValid() {
        if (labels.isEmpty()) {
            return true;
        }
        else {
            if (!labels.isEmpty()) {
                List<String> l = labels.values();
                for (Integer i=0;i<l.size();i++) {
                    setErrMsg('Required field: '+l[i]+' is missing');
                }
            }
            return false;
        }
    }
        
    public boolean dealIDDNE() {
        if (dealId == '') {
            return true;
        }
        try {
            Opportunity o = [Select Id from Opportunity where DealID__c=:dealId];
            throw new Opty.OptyException('SFDC-5: '+dealId+' already exists in SFDC');
        }
        catch (QueryException qe) {
            return true;
        }
    }

    /*
     * Accessor Methods for Opportunity Detail
     */


    /*
     * SOM changes Q1FY09 - Valid combinations
     * Selling stage            Forecast Status
     * ============             ============
     * "1"                      "Not forcastable"
     * "2", "3", "4", or "5"    "Upside" or "Commit"
     */
    public void somStageValidation(String iFcstStatus, String iStageName) {
        Integer numInt = 0;
        if (iStageName == null || iStageName == '') {
            throw new Opty.OptyException('Stage Name: '+iStageName+' is null or NaN');
        }
        if (iFcstStatus == null || iFcstStatus == '') {
            throw new Opty.OptyException('Forecast Status: '+iFcstStatus+' is null or NaN');
        }
        try {
            numInt = Integer.valueOf(iStageName.substring(0,1));
        }
        catch (TypeException te) {
            throw new Opty.OptyException('Stage Name: '+iStageName+' is invalid');
        }
        if ((numInt == 1 && iFcstStatus != 'Not Forecastable') || (numInt > 1 && iFcstStatus == 'Not Forecastable')) {
            throw new Opty.OptyException('For published opportunities the Forecast Status can only be updated within SFDC and not via SOM republish.');
        }
    }
     
    /*
     * ISP Changes - Q309
     * - If PDR Deal Status is in ('Approval In Progress', 'MIR-BOM', 'Approved') set Stage to '3 - Proposal'
     * - If PDR Deal Status is in ('Ordered') set Stage to '5 - Closing'
     * - Else - set Stage to '2 - Qualification'
     * - Caveat - if the Stage is already set, do not decrease it.
     */ 
    public void stageChangedFromPDR(String iStageName, String iPartnerStatus) {
        Integer numInt = 0;
        if (iStageName == null || iStageName == '') {
            iStageName = defaultStageName;
        }
        try {
            numInt = Integer.valueOf(iStageName.substring(0,1));
        }
        catch (TypeException te) {
            numInt = 0;
        }
        
        if ((iPartnerStatus == 'Approval In Progress' || iPartnerStatus == 'MIR-BOM' || iPartnerStatus == 'Approved') && numInt < 3) {
            stageName = '3 - Proposal';
        }
        else if ((iPartnerStatus == 'Ordered') && numInt < 5) {
            stageName = '5 - Closed Won';
        }
        else if (numInt > 2) {
            stageName = iStageName;
        }
        else {
            stageName = defaultStageName;
        }
    }


    /* Mandatory Fields */
    public void setCompetitor(String iCompetitor) {
        if (iCompetitor != '') {
            competitor.add(iCompetitor);
        }
    }
    public String getCompetitor() {
/*
        String compStr = '';
        Org_Constants__c ocs = [Select Prod_LT__c From Org_Constants__c where Key__c = 'Competitors'];
        List<String> tmpList = ocs.Prod_LT__c.split(';');
        Set<String> tmpSet = new Set<String>();
        tmpSet.addAll(tmpList);
            
        for (Integer j=0;j<competitor.size();j++) {
            if (tmpSet.contains(competitor[j])) {
                if (compStr != '') {
                    compStr += ';';
                }
                compStr += competitor[j];
            }
        }
        return compStr;
*/
        String compStr = '';
        Set<String> tmpSet = new Set<String>();
        Schema.DescribeFieldResult f = Opportunity.Competitors__c.getDescribe();
        for(Schema.PicklistEntry pe : f.getPicklistValues()) {
            tmpSet.add(pe.getValue());
        }
        for (Integer j=0;j<competitor.size();j++) {
            if (tmpSet.contains(competitor[j])) {
                if (compStr != '') {
                    compStr += ';';
                }
                compStr += competitor[j];
            }
        }
        return compStr;

    }
    public void setStatus(String iStatus) {
        status = iStatus;
    }
    public String getStatus() {
        //CM-changed this
        if (validOptyStatus.contains(status)) {
            return status;
        }
        else {
            throw new Opty.OptyException('SFDC-7: Invalid Opportunity Status '+status);
        }
    }
    public void setPtnrStatus(String iStatus) {
        ptnrStatus = iStatus;
    }
    public String getPtnrStatus() {
        return ptnrStatus;
    }
    public void setDesc(String iDesc) {
        descrip = iDesc;
    }
    public String getDesc() {
        return descrip;
    }
    public void setExpDate(String iExpDate) {
        expDate = iExpDate;
        reqCheck(iExpDate, 'expDate');
    }
    /* Convert input XML Date String to SFDC Date object */
    public Date StrToDate(String iDate,String fName) {
        try {
        if(iDate !=''){
            List<String> d = iDate.split('-');
            Integer yyyy = Integer.valueOf(d.get(0));
            Integer mm = Integer.valueOf(d.get(1));
            Integer dd = Integer.valueOf(d.get(2));
            return Date.newInstance(yyyy,mm,dd);
            }
            else 
            return null;
        }
        catch (TypeException te) {
            throw new Opty.OptyException('SFDC-2: '+fName+' value - '+iDate+' has '+te.getMessage());
        }
        catch (NullPointerException ne) {
            throw new Opty.OptyException('SFDC-2: '+fName+' value - '+iDate+' has '+ne.getMessage());
        }
    }
    /* Convert input XML Date String to SFDC Date object */
    public Datetime StrToDatetime(String iDate,String fName) {
        try {
            List<String> dt;
            if (iDate.contains('T')) {
                dt = iDate.split('T');
            }
            else {
                dt = iDate.split(' ');
            }
                
            List<String> d = dt.get(0).split('-');
            List<String> t = dt.get(1).split(':');
            Integer yyyy = Integer.valueOf(d.get(0));
            Integer mm = Integer.valueOf(d.get(1));
            Integer dd = Integer.valueOf(d.get(2));
            Integer hh24 = Integer.valueOf(t.get(0));
            Integer mi = Integer.valueOf(t.get(1));
            Integer ss = Integer.valueOf(t.get(2));
            return Datetime.newInstance(yyyy,mm,dd,hh24,mi,ss);
        }
        catch (TypeException te) {
            throw new Opty.OptyException('SFDC-2: '+fName+' value - '+iDate+' has '+te.getMessage());
        }
        catch (NullPointerException ne) {
            throw new Opty.OptyException('SFDC-2: '+fName+' value - '+iDate+' has '+ne.getMessage());
        }
        catch (Exception e) {
            throw new Opty.OptyException('SFDC-2: '+fName+' value - '+iDate+' has '+e.getMessage());
        }
    }
    public boolean isExpDateNull() {
        if (expDate == '') {
            return true;
        }
        return false;
    }
    public Date getExpDate() {
        return StrToDate(expDate, 'Expected Book Date');
    }
    public void setExpPrdRev(String iExpPrdRev) {
        expPrdRev = iExpPrdRev;
    }
    /* Convert String revenue to Decimal */
    public Decimal getExpPrdRevDec() {
        try {
            Decimal revDec = Decimal.valueOf(expPrdRev);
            return revDec;
        }
        catch (TypeException te) {
            throw new Opty.OptyException('SFDC-3: Expected Product Revenue '+expPrdRev+' has '+te.getMessage());
        }
    }
    public String getExpPrdRev() {
        return expPrdRev;
    }
    /* Convert String revenue to Decimal */
    public Decimal getExpSvcRevDec() {
        try {
            Decimal revDec = Decimal.valueOf(expSvcRev);
            return revDec;
        }
        catch (TypeException te) {
            throw new Opty.OptyException('SFDC-4: Expected Service Revenue '+expSvcRev+' has '+te.getMessage());
        }
    }
    public void setExpSvcRev(String iExpSvcRev) {
        expSvcRev = iExpSvcRev;
    }
    public String getExpSvcRev() {
        return expSvcRev;
    }
    public void setStageName(String iStageName) {
        setOrigStageName(iStageName);
        if (iStageName != '') {
            stageName = iStageName;
        }
    }
    public void setOrigStageName(String iStageName) {
        origStageName = iStageName;
    }
    public String getOrigStageName() {
        return origStageName;
    }
/*    public boolean inputStageNameNull() {
        return inputStageNameFlag;
    }
*/
    public string getCRPFlag(){
       return crpFlag; 
    }
    public void setCRPFlag(String iCRPFlag) {
        crpFlag = iCRPFlag;
    }
    public String getStageName() {
        return stageName;
    }
    public void setFcstStatus(String iFcstStatus) {
        fcstStatus = iFcstStatus;
    }
    public String getFcstStatus() {
        //CM-changed this
        if (validFcstStatus.contains(fcstStatus)) {
            return fcstStatus;
        }
        else {
            throw new Opty.OptyException('SFDC-11: Invalid Forecast Status: '+fcstStatus);
        }
    }

    /* Optional Fields */
    public boolean isDealCreateDateNull() {
        if (dealCreateDate == '') {
            return true;
        }
        return false;
    }
    public void setDealCreateDate(String iDealCreateDate) {
        dealCreateDate = iDealCreateDate;
    }
    public Date getDealCreateDate() {
        return StrToDate(dealCreateDate, 'Deal Create Date');
    }
    public boolean isPullFwdDateNull() {
        if (pullFwdDate == '') {
            return true;
        }
        return false;
    }
    public void setPullFwdDate(String iPullFwdDate) {
        pullFwdDate = iPullFwdDate;
    }
    public Date getPullFwdDate() {
        return StrToDate(pullFwdDate, 'Pull Forward Date');
    }
    public void setExpireDate(String iExpireDate) {
        expireDate = iExpireDate;
    }
    public Date getExpireDate() {
        return StrToDate(expireDate, 'Deal Expiration Date');
        //return expireDate;  //this is string...
    }
    public boolean isExpireDateNull() {
        if (expireDate == '') {
            return true;
        }
        return false;
    }
    public void setSalesPgm(String iSalesPgm) {
        if (iSalesPgm != '') {
            salesPgm.add(iSalesPgm);
        }
    }
    public String getSalesPgm() {
        String salesPgmStr = '';
        Org_Constants__c ocs = [Select Prod_LT__c From Org_Constants__c where Key__c = 'Competitors'];
        List<String> tmpList = ocs.Prod_LT__c.split(';');
        Set<String> tmpSet = new Set<String>();
        tmpSet.addAll(tmpList);     //Set<String> tmpSet = new Set<String>{'a','b'};
            
        for (Integer j=0;j<salesPgm.size();j++) {
            if (tmpSet.contains(salesPgm[j])) {
                if (salesPgmStr != '') {
                    salesPgmStr += ';';
                }
                salesPgmStr += salesPgm[j];
            }
        }
        return salesPgmStr;
    }
    public void setDMCode(String iDMCode) {
        dmCode = iDMCode;
    }
    public String getDMCode() {
        return dmCode;
    }
    public void setDMDesc(String iDMDesc) {
        dmDesc = iDMDesc;
    }
    public String getDMDesc() {
        return dmDesc;
    }
    public void setSsrEmailId(String iSsrEmailId) {
        ssrEmailId = iSsrEmailId;
    }
    public String getSsrEmailId() {
        return ssrEmailId;
    }
    public void setCAMUserId(String iCAMUserId) {
        camUserId = iCAMUserId;
    }
    public String getCAMUserId() {
        return camUserId;
    }
    public void setSvcSource(String iSvcSource) {
        svcSource = iSvcSource;
    }
    public String getSvcSource() {
        return svcSource;
    }
    public void setContractNo(String iContractNo) {
        contractNo = iContractNo;
    }
    public String getContractNo() {
        return contractNo;
    }
    public void setStartDate(String iStartDate) {
        startDate = iStartDate;
    }
    public boolean isStartDateNull() {
        if (startDate == '') {
            return true;
        }
        return false;
    }
    public Date getStartDate() {
        return StrToDate(startDate, 'Contract Start Date');
    }
    public void setEndDate(String iEndDate) {
        endDate = iEndDate;
    }
    public boolean isEndDateNull() {
        if (endDate == '') {
            return true;
        }
        return false;
    }
    public Date getEndDate() {
        return StrToDate(endDate, 'Contract End Date');
    }

    /* 
     * Inner class for Product Line Item
     * - This is a separate object in SFDC, but we put it here for organizational purposes
     */
    public class ProductItem {
        Id sfdcPBEId;
        Id sfdcP2Id;
        String prodName;
        List<String> prodFamily = new List<String>{};
        String mixPct;
        String xFamily;

        public void setProdName(String iProdName) {
            prodName = iProdName;
            //String errMsg ='';
            //errMsg += validateProduct();
        }
        public String getProdName() {
            return prodName;
        }
        public void setProdFamily(String iProdFamily) {
            if (iProdFamily != '') {
                prodFamily.add(iProdFamily);
            }
        }
        public String getProdFamily() {
            String prodFamStr = '';
            validateFamily();
            for (Integer j=0;j<prodFamily.size();j++) {
                if (prodFamStr != '') {
                    prodFamStr += ';';
                }
                prodFamStr += prodFamily[j];
            }
            return prodFamStr;
        }

        public void setMixPct(String iMixPct) {
            mixPct = iMixPct;
        }
        public String getMixPct() {
            return mixPct;
        }
        /* Convert the String value to Double */
        public Double getMixPctDouble() {
            try {
                Double mix = Double.valueOf(mixPct);
                return mix;
            }
            catch (Exception e) {
                throw new Opty.OptyException('SFDC-8: Product Mix Percent is null or NaN');
            }
        }
        public void setXFamily(String inFam) {
            if (xFamily != '') {
                xFamily += '::';
            }
            xFamily += inFam;
        }
        public String getPriceBkId() {
            return sfdcPBEId;
        }
        public String getXFamily() {
            return xFamily;
        }
        /* Verify if the Product/Technology exists in SFDC */
        public boolean validateProduct(String currCode) {
            //Product valid?
            PriceBookEntry pbe;
            try {
                pbe = [Select Id,Product2Id from PriceBookEntry where Name=:prodName and currencyIsoCode=:currCode limit 1];
            }
            catch (QueryException qe) {
                //throw new Opty.OptyException('SFDC-7: PriceBookEntry does not exist for '+prodName);
                //log this somewhere
                return false;
            }
            
            sfdcPBEId = pbe.Id;
            sfdcP2Id = pbe.Product2Id;
            return true;
        }
        /*
         * Validate the Product Family
         * - There is a 1:M relationship between Product and Family
         * - Find the corresponding Family and verify that the one(s) passed in exist
         * - If they do not exist, just drop them
         * - If there are no matching Family items, return false
         */
        public boolean validateFamily() {
            Product2 p2;
            try {
                p2 = [Select Product_Family_1__C,Product_Family_2__C,Product_Family_3__C,Product_Family_4__C from Product2 where Id=:sfdcP2Id and CurrencyIsoCode='USD'];
            }
            catch (QueryException qe) {
                return false;
            }
            String tmp = p2.Product_Family_1__C+p2.Product_Family_2__C+p2.Product_Family_3__C+p2.Product_Family_4__C;
            List<String> tmpList = tmp.split(';');
            Set<String> tmpSet = new Set<String>();
            tmpSet.addAll(tmpList);
 
            boolean remFlag = false;
            //Track failure somewhere
            for (Integer j=0;j<prodFamily.size();j++) {
                if (!tmpSet.contains(prodFamily[j])) {
                    prodFamily.remove(j);
                    remFlag= true;
                    setXFamily(prodFamily[j]+' has been removed');
                }
            }
        return true;
        }
    }

    /* 
     * Inner class for Service Line Item
     * - This is a separate object in SFDC, but we put it here for organizational purposes
     */
    public class ServiceItem {
        Id sfdcPBEId;
        Id sfdcP2Id;
        String svcName;
        String svcLevel;
        String mixPct;
        
        public void setSvcName(String iSvcName) {
            svcName = iSvcName;
        }
        public String getSvcName() {
            return svcName;
        }
        public void setSvcLevel(String iSvcLevel) {
            svcLevel = iSvcLevel;
        }
        public String getSvcLevel() {
            return svcLevel;
        }
        public void setMixPct(String iMixPct) {
            mixPct = iMixPct;
        }
        public String getMixPct() {
            return mixPct;
        }
        /* Convert the String value to Double */
        public Double getMixPctDouble() {
            try {
                Double mix = Double.valueOf(mixPct);
                return mix;
            }
            catch (Exception e) {
                throw new Opty.OptyException('SFDC-9: Service Mix Percent is null or NaN');
            }
        }
        public String getPriceBkId() {
            return sfdcPBEId;
        }
        public String getProd2Id() {
            return sfdcP2Id;
        }
        /* Verify if the Service exists in SFDC */
        public boolean validateService(String currCode) {
            //Product valid?
            PriceBookEntry pbe;
            try {
                pbe = [Select Id,Product2Id from PriceBookEntry where Name=:svcName and currencyIsoCode=:currCode limit 1];
            }
            catch (QueryException qe) {
                return false;
            }
            sfdcPBEId = pbe.Id;
            sfdcP2Id = pbe.Product2Id;
            return true;
        }
        /*
         * Validate the Service Level
         * - There is a 1:1 relationship between Service and Level
         * - Find the corresponding levels and verify that the one passed in exists
         */
        public boolean validateLevel() {
            Product2 p2; 
            try {
                p2 = [Select Service_Level_1__C,Service_Level_2__C,Service_Level_3__C,Service_Level_4__C from Product2 where Id=:sfdcP2Id and CurrencyIsoCode='USD'];
            }
            catch (QueryException qe) {
                return false;
            }
/*            String tmp = p2.Service_Level_1__C+p2.Service_Level_2__C+p2.Service_Level_3__C+p2.Service_Level_4__C;
            List<String> tmpList = tmp.split(';');
            Set<String> tmpSet = new Set<String>();
            tmpSet.addAll(tmpList);
*/
            Set<String> tmpSet = new Set<String>();
            List<String> tmpList = CSOpty.nvl(p2.Service_Level_1__C).split(';');
            tmpSet.addAll(tmpList);
            tmpList = CSOpty.nvl(p2.Service_Level_2__C).split(';');
            tmpSet.addAll(tmpList);
            tmpList = CSOpty.nvl(p2.Service_Level_3__C).split(';');
            tmpSet.addAll(tmpList);
            tmpList = CSOpty.nvl(p2.Service_Level_4__C).split(';');
            tmpSet.addAll(tmpList);


            if (!tmpSet.contains(svcLevel)) {
                return false;
            }
            return true;
        }
    }
    /*
     * Format the return XML
     * - return Deal ID, SFDC Opportunity ID, SUCCESS/FAILURE Status, and Message
     */ 
    public static String outXML(String dealID,String sfdcID,String status,String errMsg) {
        return outXML(dealID,sfdcID,status,'','','','','','',errMsg,'');
    }
    public static String outXML(String dealID,String sfdcID,String status,String errMsg,String errMsg2) {
        return outXML(dealID,sfdcID,status,'','','','','','',errMsg,'');
    }
    public static String outXML(String dealID,String sfdcID,String status,String host, String hostCam, String hostCreated, String agent, String agentCam, String agentCreated, String errMsg,String metricsNode) {
        String errXML = '<OptyResult><DealID>'+dealID+'</DealID><SFDCID>'+sfdcID+'</SFDCID><Status>'+status+'</Status><Host>'+host+'</Host><HostCam>'+hostCam+'</HostCam><HostCreated>'+hostCreated+'</HostCreated><Agent>'+agent+'</Agent><AgentCam>'+agentCam+'</AgentCam><AgentCreated>'+agentCreated+'</AgentCreated><ErrorMsg><![CDATA['+errMsg+']]></ErrorMsg>'+metricsNode+'</OptyResult>';
        return errXML;
    }
    /* Custom Exception class */
    public class OptyException extends Exception {}
    
    /* Custom Metrics class */
    public class OptyMetrics {
        //Double timestamp;
        //Map<String, Double> timingsMap = new Map<String, Double>{'ParseOpty'=>0,'InsertOpty'=>0,'UpdateOpty'=>0,'ProcessPartner'=>0,'AddPartnerToOpty'=>0,'InsertProdItem'=>0,'InsertServiceItem'=>0,'AddToSalesTeam'=>0};
        Map<String, String> tsMap = new Map<String, String>{'OptyEndToEnd'=>'','ProcessPartner'=>''};
        Map<String, String> teMap = new Map<String, String>{'OptyEndToEnd'=>'','ProcessPartner'=>''};
        //public void setTimestamp (Double ts) {
        //    timestamp = ts;
        //}
        public void addTiming(String name, Datetime endTime, Datetime startTime) {
            Double ts = endTime.getTime()-startTime.getTime();
            tsMap.put(name, formatDate(startTime));
            teMap.put(name, formatDate(endTime));
            //timestamp = ts;
        }
        public String formatDate(Datetime d) {
            // The date format is yyyy-MM-dd'T'HH:mm:ss.SSS
            String timeFormat = d.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss.SSS');
            return timeFormat;
        }
        public String outputXML() {
            Set<String> l = tsMap.keySet();
            String outVal = '<Metrics>';
            for (String keyVal : l) {
                outVal += '<Operation><Name>'+keyVal+'</Name><StartTime>'+tsMap.get(keyVal)+'</StartTime><EndTime>'+teMap.get(keyVal)+'</EndTime></Operation>';
            }
            outVal += '</Metrics>';
            return outVal;
        }
    }
}