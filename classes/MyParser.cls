public class MyParser {
    
     // SCAVA Helper Method to validate Create Access at field level
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }
    
// This class is for Quoting
    public Opty parseXML(String inStr){
        Opty op = new Opty();
        //Opty.Phase ph = new Opty.Phase();
        Opty.ProductItem pi;
        Opty.ServiceItem si;
        //Map<String, String> map;
        String retXML = '';
        String xmlString = inStr;
        String key='';
        String val='';
        List<String> node = new List<String>();
        //xmlString = '<books><book author="Manoj">Foo bar</book>' + '<book author="Mysti">Baz</book></books>';
        XmlStreamReader reader = new XmlStreamReader(xmlString);
        
        reader.setCoalescing(true);
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                //map.put(key,val);
                //retXML += key+'='+val+',';
                //op.setErrMsg('key:'+key+'-val:'+val);
                //key = '';
                //op.setErrMsg('node SIZE:'+node.size()+'');
                if (node.size()>0){
                node.remove(node.size()-1);}
                //DEBUG op.setErrMsg(' E-'+reader.getLocalName()+':'+node.size());
                //op.setErrMsg('node SIZE:'+node.size()+'');
                //reader.next();
                if (reader.getLocalName() == 'OpportunityDetail') {
                //  op.setPhase(ph); //need to figure this out for multiple phases
                }
                else if (reader.getLocalName() == 'OpportunityTechnology') {
                    op.setProductItem(pi); //need to figure this out for multiple phases
                }
                else if (reader.getLocalName() == 'OpportunityService') {
                    op.setServiceItem(si); //need to figure this out for multiple phases
                }
            }
            else if (reader.getEventType() == XmlTag.START_ELEMENT) {
                val = '';
                key = reader.getLocalName();
                system.debug('key'+key);
                if (node.size() == 0 && key != 'Opportunity') {
                    throw new Opty.OptyException('SFDC-6: Invalid Opportunity XML, beginning element is '+key);
                }
                node.add(key);
                system.debug('node'+node);
                system.debug('size'+node.size());
                //DEBUG op.setErrMsg(' S-'+key+':'+node.size());
                if (key == 'OpportunityDetail') {
                //  ph = op.getNewPhase(); //need to figure this out for multiple phases
                }
                else if (key == 'OpportunityTechnology') {
                    pi = op.getNewProductItem(); //need to figure this out for multiple phases
                }
                else if (key == 'OpportunityService') {
                    si = op.getNewServiceItem(); //need to figure this out for multiple phases
                }
            }
            else if (reader.getEventType() == XmlTag.CHARACTERS) {
                val = reader.getText();
                //op.setErrMsg('node['+node.size()+']');
                if (node.size() == 1) {
                    //reader.next();
                }
                else {
                    //op.setErrMsg('node['+node.size()+']');
                    //op.setErrMsg('val:'+node.get(node.size()-1));
                }
                //Process OpportunityHeader elements
                if (node.get(1) == 'OpportunityHeader') {
                    if (node.size()== 10){
                        if (node.get(2) == 'CustomerParty' && node.get(3) == 'Contracts' && node.get(4) == 'Contract' && node.get(5) == 'ContractHeader' && node.get(6) == 'QuoteReference'&& node.get(7) == 'UserArea'&& node.get(8) == 'SFDCQuoteDetails'&& key == 'Quote_Name') {
                            op.setQuoteName(val);
                            }
                        if (node.get(2) == 'CustomerParty' && node.get(3) == 'Contracts' && node.get(4) == 'Contract' && node.get(5) == 'ContractHeader' && node.get(6) == 'QuoteReference'&& node.get(7) == 'UserArea'&& node.get(8) == 'SFDCQuoteDetails'&& key == 'Is_finalized') {
                            op.setIsFinalized(val);
                            }
                        if (node.get(2) == 'CustomerParty' && node.get(3) == 'Contracts' && node.get(4) == 'Contract' && node.get(5) == 'ContractHeader' && node.get(6) == 'QuoteReference'&& node.get(7) == 'UserArea'&& node.get(8) == 'SFDCQuoteDetails'&& key == 'Dummy_Quote') {
                            op.setIsDummyQuote(val);
                            }
                    }
                    else if (node.size() == 9) {
                        if (node.get(2) == 'CustomerParty' && node.get(3) == 'Contracts' && node.get(4) == 'Contract' && node.get(5) == 'ContractHeader' && node.get(6) == 'QuoteReference' && node.get(7) == 'DocumentID' && key == 'ID') {
                            op.setQuoteId(val);
                        }         
                    }                
                        else if (node.size() == 8) {
                        if (node.get(2) == 'CustomerParty' && node.get(3) == 'Contracts' && node.get(4) == 'Contract' && node.get(5) == 'ContractHeader' && node.get(6) == 'QuoteReference' && key == 'StatusCode') {
                            op.setCBNStatus(val);
                        }                        
                    }
                    else if (node.size() == 6) {
                        if (node.get(2) == 'SalesLeadReference' && node.get(3) == 'UserArea' && node.get(4) == 'SFDCLeadDetails' && key == 'DealStatus') {
                            op.setDealStatus_Lead(val);
                        }                        
                        if (node.get(2) == 'SalesLeadReference' && node.get(3) == 'UserArea' && node.get(4) == 'SFDCLeadDetails' && key == 'ExpectedProductListAmount') {
                            op.setExpectedProductListAmount_Lead(val);
                        }                        
                    
                        if (node.get(2) == 'SalesLeadReference' && node.get(3) == 'UserArea' && node.get(4) == 'SFDCLeadDetails' && key == 'PromotionName') {
                            op.setPromotionName_Lead(val);
                        }
                        if (node.get(2) == 'SalesLeadReference' && node.get(3) == 'UserArea' && node.get(4) == 'SFDCLeadDetails' && key == 'ProgramName') {
                            op.setProgramName_Lead(val);
                        }                        
                    
                        if (node.get(2) == 'SalesLeadReference' && node.get(3) == 'UserArea' && node.get(4) == 'SFDCLeadDetails' && key == 'DealCreatedDate') {
                            op.setDealCreateDate_Lead(val);
                        }                        
                    
                        if (node.get(2) == 'SalesLeadReference' && node.get(3) == 'UserArea' && node.get(4) == 'SFDCLeadDetails' && key == 'DiscountType') {
                            op.setDiscountType_Lead(val);
                        }                        
                    
                        if (node.get(2) == 'SalesLeadReference' && node.get(3) == 'UserArea' && node.get(4) == 'SFDCLeadDetails' && key == 'ExpectedServiceListAmount') {
                            op.setExpectedServiceListAmount_Lead(val);
                        }
                                               
                        if (node.get(2) == 'SalesLeadReference' && node.get(3) == 'UserArea' && node.get(4) == 'SFDCLeadDetails' && key == 'EligibleForNS') {
                            op.setEligibleForNS_Lead(val);
                        }
                        if (node.get(2) == 'SalesLeadReference' && node.get(3) == 'UserArea' && node.get(4) == 'SFDCLeadDetails' && key == 'DealExpirationDate') {
                            op.setDealExpirationDate_Lead(val);
                        } 
                        if (node.get(2) == 'SalesLeadReference' && node.get(3) == 'UserArea' && node.get(4) == 'SFDCLeadDetails' && key == 'QuoteProductNetPrice') {
                            op.setQuoteProductNetPrice(val);
                        }
                        if (node.get(2) == 'SalesLeadReference' && node.get(3) == 'UserArea' && node.get(4) == 'SFDCLeadDetails' && key == 'QuoteServiceNetPrice') {
                            op.setQuoteServiceNetPrice(val);
                        } 
                         if (node.get(2) == 'SalesLeadReference' && node.get(3) == 'UserArea' && node.get(4) == 'SFDCLeadDetails' && key == 'DealDeskStatus') {
                            op.setDealDeskStatus_Lead(val);
                        }
                        if (node.get(2) == 'SalesLeadReference' && node.get(3) == 'UserArea' && node.get(4) == 'SFDCLeadDetails' && key == 'OptyName') {
                            op.setOptyName_Lead(val);
                        }
                        if (node.get(2) == 'SalesLeadReference' && node.get(3) == 'UserArea' && node.get(4) == 'SFDCLeadDetails' && key == 'QuoteProductListPrice') {
                            op.setQuoteProductListPrice(val);
                        }
                        if (node.get(2) == 'SalesLeadReference' && node.get(3) == 'UserArea' && node.get(4) == 'SFDCLeadDetails' && key == 'QuoteServiceListPrice') {
                            op.setQuoteServiceListPrice(val);
                        }                              
                    }
                    else if (node.size() == 5) {
                        if (node.get(2) == 'Deal') {
                            if (node.get(3) == 'DocumentID' && key == 'ID') {
                                op.setDealId(val);
                            }
                            else if (node.get(3) == 'AlternateDocumentID' && key == 'ID') {
                                op.setSrcKey(val);
                            }
                            else if (node.get(3) == 'DeskStatus' && key == 'Code') {
                                op.setDDStatus(val);
                            }
                            else if (node.get(3) == 'Status') {
                                if (key == 'Code') {
                                    op.setEligibleNS(val);
                                }
                                else if (key == 'EffectiveDateTime') {
                                    op.setDealCreateDate(val);
                                }
                            }
                        }
                        else if (node.get(2) == 'CustomerParty') {
                            if (node.get(3) == 'PartyId' && key == 'ID') {
                                op.setSfdcAcctId(val);
                            }
                        }
                        else if (node.get(2) == 'SalesTask') {
                            if (node.get(3) == 'Status' && key == 'Code') {
                                op.setPtnrDealType(val);
                            }
                        }
                        else if (node.get(2) == 'SalesLeadReference') {
                            if (node.get(3) == 'DocumentID' && key == 'ID') {
                                op.setLeadID(val);
                            }
                        }
                        else if (node.get(2) == 'UserArea') {
                            if (node.get(3) == 'SFDCOpty' && key == 'IS_FA_FLAG') {
                                op.setIs_FA_Flag(val);
                            }
                            if (node.get(3) == 'SFDCOpty' && key == 'IS_AT_OR_BELOW_FLAG') {
                                op.setIs_At_Or_Below_Flag(val);
                            }
                            if (node.get(3) == 'SFDCOpty' && key == 'IS_COLLABORATED') {
                                op.setIs_Collaborated(val);
                            }
                        }
                    }
                    else if (node.size() == 4) {
                        if (node.get(2) == 'DocumentID' && key == 'ID') {
                            //set Siebel Opty ID
                        }
                        else if (node.get(2) == 'WorkforceReference' && key == 'UserID') {
                            op.setOwnerId(val);
                        }
                        else if (node.get(2) == 'SalesTask' && key == 'ParentTaskID') {
                            op.setGlobalDealId(val);
                        }
                        else if (node.get(2) == 'DocumentReference' && key == 'Description') {
                            op.setP360Flag(val);
                        }
                        else if(node.get(2) == 'SalesLeadReference' && key == 'StatusCode') {
                                op.setP360LeadFlag(val);
                        }
                        else if (node.get(2) == 'WhoWhenData') {
                            if(key == 'UpdatedBy'){
                                op.setQuoteUpdatedBy(val);
                            }
                            else if(key == 'UpdatedOn') {
                                op.setQuoteUpdatedDt(val);
                            }    
                        }
                        //GDM Q3FY17 Global Opportunity tag
                        else if(node.get(2) == 'OpportunityGeography' && key == 'Area'){
                               op.setregion(val);
                        }
                        //GDM change ends here
                        else if (node.get(2) == 'Discount') {
                            if (key == 'Name') {
                                op.setDiscType(val);
                            }
                            else if (key == 'ApprovalCode') {
                                op.setDiscAprvl(val);
                            }
                        }
                        else if (node.get(2) == 'Status') {
                            if (key == 'Code') {
                                op.setDMCode(val);
                            }
                            else if (key == 'Description') {
                                op.setDMDesc(val);
                            }
                        }
                        else if (node.get(2) == 'Deal') {
                            if (key == 'ShareNode') {
                                op.setTerritoryId(val);
                            }
                            else if (key == 'ExpiryDateTime') {
                                op.setExpireDate(val);
                            }
                            //SW1003 project Q1FY16 added approvalRoute tag for Dealtype value
                            else if(key == 'ApprovalRoute'){  
                                op.setapprovalRoute(integer.valueof(val));                          
                            }
                        }
                    }
                    else if (node.size() == 3) {
                        if (key == 'Name') {
                          op.setName(val);
                        }
                        //Commented in Q109 - not used
                        //else if (key == 'Note') {
                        //    op.setNote(val);
                        //}
                        else if (key == 'SalesPath') {
                            op.setSalesPath(val);
                        }
                        //Changed in Q109 for SOM
                        else if (key == 'Note') {
                            op.setOMFNotes(val);
                        }
                        else if (key == 'SalesPosition') {
                            op.setFcstPostn(val);
                        }
                        else if (key == 'NonStandardTermsCode') {
                            op.setNstcpe(val);
                            //QC - set to default
                        }
                        //SW1003 project change for Q1FY16-Aug
                        else if (key == 'NetPriceIndicator'){
                            op.setpartnerRequired(boolean.valueof(val));
                        }
                        else if (key == 'CurrencyCode') {
                            op.setCurrCode(val);
                        }
                        else if (key == 'FutureTechnologyRequiredIndicator') {
                            op.setProdEnh(val);
                        }
                        else if (key == 'TotalAmount'){
                            op.setExpPrdLstAmt(val);
                        }
                        else if (key == 'SourceID'){
                            op.setSrcSys(val);
                        }
                        else if (key == 'ReceivedCode'){
                            op.setDealSource(val);
                        }
                        else if (key == 'BudgetedAmount'){
                            op.setExpSvcLstAmt(val);
                        }
                        else if (key == 'TotalProductAmount'){
                            op.setPrdQutAmt(val);
                        }
                        else if (key == 'TotalServiceAmount'){
                            op.setSvcQutAmt(val);
                        }
//                        else if (key == 'SalesTask'){
//                            op.setGlobalDealId('xx'+val);
//                        }
                        //Added part of solution id project with release FYQ15-Apr
                        else if(key == 'IntendedUseOfOpportunity'){ // SolutionId is passing to SFDC in IntendedUseOfOpportunity tag by CCW
                            op.setsolutionId(val);
                        }
                        // Ends solution id changes here
                        
                    }
                }
                else if (node.get(1) == 'OpportunityDetail') {
                    if (node.size() == 7) {
                        if (node.get(2) == 'PartnerParty' && node.get(3) == 'OrganizationProfile' && node.get(4) == 'SystemsInventory' && node.get(5) == 'SystemsInfo' && key == 'Name') {
                            op.setManagedSvc(val);
                        }
                    }
                    else if (node.size() == 6) {
                        if (node.get(2) == 'OpportunityService' && node.get(3) == 'ServiceProgram' && node.get(4) == 'ServiceLevel' && key == 'Name') {
                            si.setSvcLevel(val);
                        }
                    }
                    else if (node.size() == 5) {
                        /* Not used for QC, moving for SOM
                        if (node.get(2) == 'Forecast' && node.get(3) == 'Period') {
                            if (key == 'StartDateTime') {
                                op.setStartDate(val);
                            }
                            else if (key == 'EndDateTime') {
                                op.setEndDate(val);
                            }
                        }
                        else */
                        if (node.get(2) == 'ContractReference') {
                            if (node.get(3) == 'DocumentID') {
                                if (key == 'ID') {
                                    op.setContractNo(val);
                                }
//                                else if (key == 'StatusCode') {
//                                  op.setSvcSource(val);
//                                }
                            }
                            else if (node.get(3) == 'Period') {
                                if (key == 'StartDateTime') {
                                    op.setStartDate(val);
                                }
                                else if (key == 'EndDateTime') {
                                    op.setEndDate(val);
                                }
                            }
                        }
                        else if (node.get(2) == 'OpportunityService' && node.get(3) == 'ServiceProgram') {
                            if (key == 'Name') {
                                si.setSvcName(val);
                            }
/*                            else if (key == 'ServiceLevel') {
                                si.setSvcLevel(val);
                            }
*/                            else if (key == 'ServiceMixPercentage') {
                                si.setMixPct(val);
                            }
                        }
                        else if (node.get(2) == 'OpportunityTechnology' && node.get(3) == 'Technology') {
                            if (key == 'Name') {
                                pi.setProdName(val);
                            }
                        }
                    }
                    else if (node.size() == 4) {
                        if (node.get(2) == 'Status' && key == 'Code') {
                            op.setPtnrStatus(val);
                        }
                        else if (node.get(2) == 'Forecast' && key == 'Code') {
                            op.setFcstStatus(val);
                        }
                        else if (node.get(2) == 'WorkforceReference') {
                            if(key == 'UserID'){
                                //op.setSsrEmailId(val);
                                /* This is mapped to SSR Login for OMF.
                                 * When more clients come on, we will need to differentiate by 
                                 * //cixs:OpportunityDetail/cixs:WorkforceReference/Name = SSR
                                 * //cixs:OpportunityDetail/cixs:WorkforceReference/Name = CAM
                                 */
                                op.setCAMUserId(val);
                            }
                            else if(key == 'Name') {
                                op.setSsrEmailId(val);
                            }    
                        }
                        else if (node.get(2) == 'ContractReference' && key == 'StatusCode') {
                            op.setSvcSource(val);
                        }
                        else if (node.get(2) == 'OpportunityService' && key == 'RenewalReasonCode') {
                            op.setReasonCode(val);
                        }
                        else if (node.get(2) == 'CompetitorParty' && key == 'Name') {
                            op.setCompetitor(val);
                        }
                        else if (node.get(2) == 'MarketingProgram') {
                            if (key == 'ID') {
                                op.setPromoId(val);
                            }
                            else if (key == 'Description') {
                                op.setPromoCode(val);
                            }
                            else if (key == 'OfferDescription') {
                                op.setPromoName(val);
                            }
                            else if (key == 'OpportunityType') {
                                op.setProgName(val);
                            }
                            else if (key == 'OpportunityMethodCode') {
                                op.setSalesPgm(val);
                            }
                        }
                        else if (node.get(2) == 'OpportunityTechnology' && key == 'TechnologyMixPercentage') {
                            pi.setMixPct(val);
                        }
                        else if (node.get(2) == 'Item' && key == 'Name') {
                          pi.setProdFamily(val);
                        }
                    }
                    else if (node.size() == 3) {
                        if (key == 'PhaseName') {
                            //op.setName(val);
                        }
                        else if (key == 'Description') {
                            op.setDesc(val);
                        }
                        else if (key == 'ExpectedBookingDateTime') {
                            op.setExpDate(val);
                        }
                        else if (key == 'ExpectedProductBookingAmount') {
                            op.setExpPrdRev(val);
                        }
                        else if (key == 'ExpectedServiceBookingAmount') {
                            op.setExpSvcRev(val);
                        }
                        else if (key == 'PullForwardDateTime') {
                            op.setPullFwdDate(val);
                        }
                        else if (key == 'SalesStageCode') {
                            op.setStageName(val);
                            //QC - use default
                        }
                        else if (key == 'CRP_Flag__c') {
                            op.setCRPFlag(val);
                            //QC - use default
                        }
                    }
                }
            }
            reader.next();
        }
        return op;
    }
    //Process Patners
    public Map<String,String> processPartner(String xmlString, Boolean useChnlMaster) {
        String key='';
        String val='';
        String addrLine1='';
        String addrLine2='';
        String companyID='';
        String siteID='';
        String HQSite='';
        String city='';
        String state='';
        String country='';
        String name='';
        String token='';
        String postalCode='';
        String pType='';
        String ptnrId='';
        Integer ptnrCnt = 0;
        String camID = '';
        String pdbSiteID = '';
        String pgtmvBecID = '';
        String pgtmvFlag = '';
        String partnerContact = '';
        String partner360Flag = '';
        String created = 'FALSE';
        String p1key='';
        String p1val='';
        String p1addrLine1='';
        String p1addrLine2='';
        String p1companyID='';
        String p1siteID='';
        String p1HQSite='';
        String p1city='';
        String p1state='';
        String p1country='';
        String p1name='';
        String p1token='';
        String p1postalCode='';
        String p1Type='';
        String p1ptnrId='';
        Integer p1ptnrCnt = 0;
        String p1camID = '';
        String p1pdbSiteID = '';
        String p1pgtmvBecID = '';
        String p1pgtmvFlag = '';
        String p1partnerContact = '';
        String p1partner360Flag = '';
        String p1created = 'FALSE';
        Map<String, String> m = new Map<String, String>();

        /* HQ site ID changes included*/ 
        Map<String, String> labels = new Map<String, String>{'name'=>'Partner Name','addrLine1'=>'Address Line 1','companyID'=>'Company Target ID','siteID'=>'CSC/PDB Site Target ID','city'=>'City','country'=>'Country','HQSite'=>'HQ Site'};
        Map<String, String> p1Labels = new Map<String, String>{'p1name'=>'Partner Name','p1addrLine1'=>'Address Line 1','p1companyID'=>'Company Target ID','p1siteID'=>'CSC/PDB Site Target ID','p1city'=>'City','p1country'=>'Country','p1HQSite'=>'HQ Site'};
        XmlStreamReader reader = new XmlStreamReader(xmlString);
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                /* Only process the Host and Agent
                 * - need to add more code if we have more partners sent
                 */
                if (reader.getLocalName() == 'Partner1' && p1ptnrCnt < 3 ) {
                    p1ptnrCnt++;
                    String p1outMsg = '';
                    if (!p1Labels.isEmpty()) {
                        p1outMsg = 'FALSE';
                    }
                    else {
                        // Look up Channel Record Type              
                         RecordType rt = [select Id from RecordType where Name = 'Channel'];
                         String recType = String.valueOf(rt.Id);                         
                         User u;
                         /*
                          * Look up the Country CAM
                          * - Replace whitespace in country name with "_"
                          * - logic is cam_<lower case country>@cisco.com<.domain>
                          * - using like makes it domain independent
                          */
                         try {
                             Pattern myPattern = Pattern.compile('[\\s]');
                             String cntry = myPattern.matcher(country).replaceAll('_');                             
                             String cam = 'cam_'+cntry.toLowerCase()+'@cisco.com%';
                             u = [select Id, username, isActive from User where username like :cam and isActive=true];
                         }
                         catch (Exception e) {
                             // If unable to find the country CAM, assign to Unallocated CAM
                             u = [select Id, username, isActive from User where username like 'cam_unallocated@cisco.com%'];
                         }
                         // Look up the Partner Account based on CSC Site ID
                         try {
                             //Added constraint - no dummy owned account - Q3FY10
                             Account[] prt1;
                             String q = '';
                             Boolean p1createPartner = false;
                             Boolean isHQ = false;
                             //Boolean p = true;  
                             // If pgtmvFlag id N then look for the account on the basis of HqSiteId in SFDC, if no account found then Create account
                             if(p1pgtmvFlag == 'N'){                                 
                                //If HQ Site is not null, lookup partner based on it
                                if(p1HQSite != '' && p1HQSite != '0') {
                                     Double p1HQSiteIDDouble = Double.valueOf(p1HQSite);
                                     q = 'select Id, channel_master_account_id__c,Owner.Dummy_User__c from Account where PDB_Site_ID__c=:p1HQSiteIDDouble and HQSiteID__c = true and Recordtypeid=:recType order by LastmodifiedDate desc Limit 1';
                                     prt1 = (List<Account>)Database.query(q);
                                } 
                                  // If HQ site is not null but no matches found in SFDC, set the create flag 
                                if(p1HQSite != '' && p1HQSite != '0' && (prt1 == null || (prt1 != null && prt1.size()<1))){                                
                                    p1createPartner = true;
                                    isHQ = true;
                                }                               
                                 //If CSC Site is not null, look up partner based on it
                                 if ((prt1 == null || p1HQSite=='' || (prt1 != null && prt1.size()<1)) && p1siteID != '') {
                                    q = 'select Id, channel_master_account_id__c,Owner.Dummy_User__c from Account where CSCSiteID__c=:p1siteID and Recordtypeid=:recType order by LastmodifiedDate desc Limit 1';
                                    prt1 = (List<Account>)Database.query(q);
                                }
                                //If no results from CSC Site ID lookup or CSC Site ID was null
                                //check based on PDB Site ID
                                if ((prt1 == null || p1siteID=='' || (prt1 != null && prt1.size()<1)) && p1pdbSiteID != '') {
                                    Double p1pdbSiteIDDouble = Double.valueOf(p1pdbSiteID);
                                    q = 'select Id, channel_master_account_id__c,Owner.Dummy_User__c from Account where PDB_Site_ID__c=:p1pdbSiteIDDouble and Recordtypeid=:recType order by LastmodifiedDate desc Limit 1';
                                    prt1 = (List<Account>)Database.query(q);
                                }
                             }                             
                             //If pgtmvFlag is Y then look for Account on the basis of pgtmvBecID in SFDC, if no account found then Create it
                            if(p1pgtmvFlag == 'Y'){
                                 //If PGTMV Site ID is not null, lookup partner based on it
                                try{
                                 if(p1pgtmvBecID != '') {
                                      q = 'select Id, channel_master_account_id__c,Owner.Dummy_User__c from Account where BEC_ID__c=:p1pgtmvBecID and Recordtypeid=:recType order by LastmodifiedDate desc Limit 1';
                                      prt1 = (List<Account>)Database.query(q);
                                } 
                                }
                                catch (Exception e) {
                                    p1outMsg = 'Can not Process- p1pgtmvBecID is NULL:'+e.getMessage();
                                }
                                 // If PGTMV BEC ID is not null but no matches found in SFDC, create channel account on the basis on HQ site 
                                if(p1pgtmvBecID != '' && (prt1 == null || (prt1 != null && prt1.size()<1))    ){                                 
                                    p1createPartner = true;
                                    //isHQ = true;
                                } 
                            }                             
                             //If no results, create the partner
                             if (prt1 != null && prt1.size()<1) {
                                p1createPartner = true;
                             }
                             else if (prt1 != null && prt1.size()>0) {
                                 if (prt1[0].channel_master_account_id__c == null || useChnlMaster == false) {
                                     p1outMsg = String.valueOf(prt1[0].Id);
                                 }
                                 else {
                                     p1outMsg = String.valueOf(prt1[0].channel_master_account_id__c);
                                 }
                             }
                             else {
                                p1createPartner = true;
                             }
                             if (p1createPartner) {
                                 //if unable to locate based on CSC Site ID, create it
                                 if (u.isActive) {
                                     Account ac = new Account();
                                     // SCAVA FIX
                                     if(flsGet(Account.Name))
                                     {
                                     ac.Name = name;
                                     }
                                     if(flsGet(Account.AccountNameEnglish__c))
                                     {
                                     ac.AccountNameEnglish__c = p1name;
                                     }
                                     if(flsGet(Account.AddressLine1__c))
                                     {
                                     ac.AddressLine1__c = p1addrLine1;
                                     }
                                     if(flsGet(Account.AddressLine1_English__c))
                                     {
                                     ac.AddressLine1_English__c = p1addrLine1;
                                     }
                                     if(flsGet(Account.AddressLine2__c))
                                     {
                                     ac.AddressLine2__c = p1addrLine2;
                                     }
                                     if(flsGet(Account.AddressLine2_English__c))
                                     {
                                     ac.AddressLine2_English__c = p1addrLine2;
                                     }
                                     if(flsGet(Account.CSCID__c))
                                     {
                                     ac.CSCID__c = p1companyID;
                                     }
                                     if (siteID !='') {
                                         if(flsGet(Account.CSCSiteID__c))
                                        {
                                         ac.CSCSiteID__c = p1siteID;
                                        }
                                     }

                                     if(isHQ){
                                         // SCAVA FIX
                                         if(flsGet(Account.HQSiteID__c))
                                         {
                                          ac.HQSiteID__c = true;
                                        }
                                     }
                                     
                                     if(flsGet(Account.City__c))
                                     {
                                     ac.City__c = p1city;
                                     }
                                     if(flsGet(Account.City_English__c))
                                     {
                                     ac.City_English__c = p1city;
                                     }
                                     if(flsGet(Account.State__c))
                                     {
                                     ac.State__c = p1state;
                                     }
                                     if(flsGet(Account.State_Province_English__c))
                                     {
                                     ac.State_Province_English__c = p1state;
                                     }
                                     if(flsGet(Account.Country__c))
                                     {
                                     ac.Country__c = p1country;
                                     }
                                     if(flsGet(Account.Country_English__c))
                                     {
                                     ac.Country_English__c = p1country;
                                     }
                                     if(flsGet(Account.Partner_ID__c))
                                     {
                                     ac.Partner_ID__c = p1ptnrId;
                                     }
                                     if(flsGet(Account.TOKENID__c))
                                    {
                                     ac.TOKENID__c = p1token;
                                    }
                                     if(flsGet(Account.ZipPostalCode__c))
                                     {
                                     ac.ZipPostalCode__c = p1postalCode;
                                     }
                                     if(flsGet(Account.Zip_Postal_Code_English__c))
                                     {
                                     ac.Zip_Postal_Code_English__c = p1postalCode;
                                     }
                                     if(flsGet(Account.Recordtypeid))
                                     {
                                     ac.Recordtypeid=rt.Id;
                                     }
                                     if(flsGet(Account.ownerId))
                                     {
                                     ac.ownerId = u.Id;
                                     }
                                     if (pdbSiteID!='') { 
                                          if(flsGet(Account.PDB_Site_ID__c))
                                        {
                                         ac.PDB_Site_ID__c = Double.valueOf(p1pdbSiteID);
                                        }
                                     }
                                     if (pgtmvBecID!= ''){
                                         if(flsGet(Account.BEC_ID__c))
                                         {
                                         ac.BEC_ID__c = p1pgtmvBecID;
                                         }
                                     } 
                                     Insert ac;
                                     p1outMsg = String.valueOf(ac.Id);
                                     List<String> uname = String.valueOf(u.username).split('@');
                                     p1camID = String.valueOf(uname.get(0));
                                     created = 'TRUE';
                                 }
                                 else {
                                     p1outMsg = 'CAM_INACTIVE';
                                 }
                             }
                         }
                         catch (Exception ex) {
                            p1outMsg = 'Error processing partner:'+ex.getMessage();
                         }
                    }                    
                    if (p1Type == 'Agent') {
                        m.put('AGENT',p1outMsg);
                        m.put('AGENT_CREATED',created);
                        m.put('AGENT_CAM', p1camID);  //Return the CAM_ID
                    }
                }
                if (reader.getLocalName() == 'Account' && ptnrCnt < 3) {
                    ptnrCnt++;
                    String outMsg = '';
                    if (!labels.isEmpty()) {
                        outMsg = 'FALSE';
                    }
                    else {
                        // Look up Channel Record Type              
                         RecordType rt = [select Id from RecordType where Name = 'Channel'];
                         String recType = String.valueOf(rt.Id);
                         
                         User u;
                         /*
                          * Look up the Country CAM
                          * - Replace whitespace in country name with "_"
                          * - logic is cam_<lower case country>@cisco.com<.domain>
                          * - using like makes it domain independent
                          */
                         try {
                             Pattern myPattern = Pattern.compile('[\\s]');
                             String cntry = myPattern.matcher(country).replaceAll('_');
                             
                             String cam = 'cam_'+cntry.toLowerCase()+'@cisco.com%';
                             u = [select Id, username, isActive from User where username like :cam and isActive=true];
                         }
                         catch (Exception e) {
                             // If unable to find the country CAM, assign to Unallocated CAM
                             u = [select Id, username, isActive from User where username like 'cam_unallocated@cisco.com%'];
                         }
                         // Look up the Partner Account based on CSC Site ID
                         try {
                             //Added constraint - no dummy owned account - Q3FY10
                             Account[] acct;
                             String q = '';
                             Boolean createPartner = false;
                             Boolean isHQ = false;
                             //Boolean p = true;

                             // If pgtmvFlag id N then look for the account on the basis of HqSiteId in SFDC, if no account found then Create account
                             if(pgtmvFlag == 'N'){
                             
                             //If HQ Site is not null, lookup partner based on it

                             if(HQSite != '' && HQSite != '0') {
                                 Double HQSiteIDDouble = Double.valueOf(HQSite);
                                 q = 'select Id, channel_master_account_id__c,Owner.Dummy_User__c from Account where PDB_Site_ID__c=:HQSiteIDDouble and HQSiteID__c = true and Recordtypeid=:recType order by LastmodifiedDate desc Limit 1';
                                  acct = (List<Account>)Database.query(q);
                             } 
                              // If HQ site is not null but no matches found in SFDC, set the create flag 
                             if(HQSite != '' && HQSite != '0' && (acct == null || (acct != null && acct.size()<1))    ){
                                 
                                createPartner = true;
                                isHQ = true;
                             }
                            
                             //If CSC Site is not null, look up partner based on it
                             if ((acct == null || HQSite=='' || (acct != null && acct.size()<1)) &&siteID != '') {
                                 q = 'select Id, channel_master_account_id__c,Owner.Dummy_User__c from Account where CSCSiteID__c=:siteID and Recordtypeid=:recType order by LastmodifiedDate desc Limit 1';
                                 acct = (List<Account>)Database.query(q);
                             }
                             //If no results from CSC Site ID lookup or CSC Site ID was null
                             //check based on PDB Site ID
                             if ((acct == null || siteID=='' || (acct != null && acct.size()<1)) && pdbSiteID != '') {
                                 Double pdbSiteIDDouble = Double.valueOf(pdbSiteID);
                                 q = 'select Id, channel_master_account_id__c,Owner.Dummy_User__c from Account where PDB_Site_ID__c=:pdbSiteIDDouble and Recordtypeid=:recType order by LastmodifiedDate desc Limit 1';
                                 acct = (List<Account>)Database.query(q);
                             }
                             //if (acct == null) {
                             //}
                             //else {
                             //}
                             }
                             
                             //If pgtmvFlag is Y then look for Account on the basis of pgtmvBecID in SFDC, if no account found then Create it
                             
                             if(pgtmvFlag == 'Y'){
                             //If PGTMV Site ID is not null, lookup partner based on it
                             try{
                             if(pgtmvBecID != '') {
                                  q = 'select Id, channel_master_account_id__c,Owner.Dummy_User__c from Account where BEC_ID__c=:pgtmvBecID and Recordtypeid=:recType order by LastmodifiedDate desc Limit 1';
                                  acct = (List<Account>)Database.query(q);
                             } 
                             }
                             catch (Exception e) {
                                outMsg = 'Can not Process- pgtmvBecID is NULL:'+e.getMessage();
                                }
                              // If PGTMV BEC ID is not null but no matches found in SFDC, create channel account on the basis on HQ site 
                             if(pgtmvBecID != '' && (acct == null || (acct != null && acct.size()<1))    ){
                                 
                                createPartner = true;
                                //isHQ = true;
                             }
 
                             }
                             
                             //If no results, create the partner
                             if (acct != null && acct.size()<1) {
                                createPartner = true;
                             }
                             else if (acct != null && acct.size()>0) {
                                 if (acct[0].channel_master_account_id__c == null || useChnlMaster == false) {
                                     outMsg = String.valueOf(acct[0].Id);
                                 }
                                 else {
                                     outMsg = String.valueOf(acct[0].channel_master_account_id__c);
                                 }
                             }
                             else {
                                createPartner = true;
                             }
                             if (createPartner) {
                                 //if unable to locate based on CSC Site ID, create it
                                 if (u.isActive) {
                                     Account ac = new Account();
                                     // SCAVA FIX
                                     if(flsGet(Account.Name))
                                     {
                                     ac.Name = name;
                                     }
                                     if(flsGet(Account.AccountNameEnglish__c))
                                     {
                                     ac.AccountNameEnglish__c = name;
                                     }
                                     if(flsGet(Account.AddressLine1__c))
                                     {
                                     ac.AddressLine1__c = addrLine1;
                                     }
                                     if(flsGet(Account.AddressLine1_English__c))
                                     {
                                     ac.AddressLine1_English__c = addrLine1;
                                     }
                                     if(flsGet(Account.AddressLine2__c))
                                     {
                                     ac.AddressLine2__c = addrLine2;
                                     }
                                     if(flsGet(Account.AddressLine2_English__c))
                                     {
                                     ac.AddressLine2_English__c = addrLine2;
                                     }
                                     if(flsGet(Account.CSCID__c))
                                     {
                                     ac.CSCID__c = companyID;
                                     }
                                     if (siteID !='') {
                                        if(flsGet(Account.CSCSiteID__c))
                                        {
                                         ac.CSCSiteID__c = siteID;
                                        }
                                     }

                                     if(isHQ){
                                         if(flsGet(Account.HQSiteID__c))
                                        {
                                          ac.HQSiteID__c = true;
                                        }
                                     }
                                     //  SCAVA FIX
                                     if(flsGet(Account.City__c))
                                     {
                                     ac.City__c = city;
                                     }
                                     if(flsGet(Account.City_English__c))
                                     {
                                     ac.City_English__c = city;
                                     }
                                     if(flsGet(Account.State__c))
                                     {
                                     ac.State__c = state;
                                     }
                                     if(flsGet(Account.State_Province_English__c))
                                     {
                                     ac.State_Province_English__c = state;
                                     }
                                     if(flsGet(Account.Country__c))
                                     {
                                     ac.Country__c = country;
                                     }
                                     if(flsGet(Account.Country_English__c))
                                     {
                                     ac.Country_English__c = country;
                                     }
                                     if(flsGet(Account.Partner_ID__c))
                                     {
                                     ac.Partner_ID__c = ptnrId;
                                     }
                                     if(flsGet(Account.TOKENID__c))
                                     {
                                     ac.TOKENID__c = token;
                                     }
                                     if(flsGet(Account.ZipPostalCode__c))
                                     {
                                     ac.ZipPostalCode__c = postalCode;
                                     }
                                     if(flsGet(Account.Zip_Postal_Code_English__c))
                                     {
                                     ac.Zip_Postal_Code_English__c = postalCode;
                                     }
                                     if(flsGet(Account.Recordtypeid))
                                     {
                                     ac.Recordtypeid=rt.Id;
                                     }
                                     if(flsGet(Account.ownerId))
                                     {
                                     ac.ownerId = u.Id;
                                     }
                                     if (pdbSiteID!='') { 
                                        if(flsGet(Account.PDB_Site_ID__c))
                                        {
                                         ac.PDB_Site_ID__c = Double.valueOf(pdbSiteID);
                                        }
                                     }
                                     if (pgtmvBecID!= ''){
                                         if(flsGet(Account.BEC_ID__c))
                                        {
                                         ac.BEC_ID__c = pgtmvBecID;
                                        }
                                     }
                                     Insert ac;
                                     outMsg = String.valueOf(ac.Id);
                                     List<String> uname = String.valueOf(u.username).split('@');
                                     camID = String.valueOf(uname.get(0));
                                     created = 'TRUE';
                                 }
                                 else {
                                     outMsg = 'CAM_INACTIVE';
                                 }
                             }
                         }
                         catch (Exception ex) {
                            outMsg = 'Error processing partner:'+ex.getMessage();
                         }
                    }
    
                    if (pType == 'Host' || pType == '') {
                        m.put('HOST_OTHER',outMsg);
                        m.put('HOST_CREATED',created);
                        m.put('HOST_CAM', camID);  //Return the CAM_ID
                    }
                    else if (pType == 'Agent') {
                        m.put('AGENT',outMsg);
                        m.put('AGENT_CREATED',created);
                        m.put('AGENT_CAM', camID);  //Return the CAM_ID
                    }
                }
            }
            else if (reader.getEventType() == XmlTag.START_ELEMENT) {
                val = '';
                key = reader.getLocalName();
                if (key == 'Account') {
                    //NEED TO RESET VALUES...
                    addrLine1='';
                    addrLine2='';
                    companyID='';
                    siteID='';
                    partnerContact='';
                    partner360Flag = '';
                    HQSite='';
                    city='';
                    state='';
                    country='';
                    name='';
                    token='';
                    postalCode='';
                    pType='';
                    ptnrId='';
                    camID = '';
                    pdbSiteID = '';
                    created = 'FALSE';
                }
                //Added for Partner2
                if (key == 'Partner1') {
                    //NEED TO RESET VALUES...
                    p1addrLine1='';
                    p1addrLine2='';
                    p1companyID='';
                    p1siteID='';
                    p1partnerContact='';
                    p1partner360Flag = '';
                    p1HQSite='';
                    p1city='';
                    p1state='';
                    p1country='';
                    p1name='';
                    p1token='';
                    p1postalCode='';
                    p1Type='';
                    p1ptnrId='';
                    p1camID = '';
                    p1pdbSiteID = '';
                    p1created = 'FALSE';
                }
            }
            else if (reader.getEventType() == XmlTag.CHARACTERS) {
                val = reader.getText();
                if (key == 'Name' && val != '') {
                    name = val;
                    labels.remove('name');
                }
                else if (key == 'AddressLine1__c' && val != '') {
                    addrLine1 = val;
                    labels.remove('addrLine1');
                }
                else if (key == 'AddressLine2__c' && val != '') {
                    addrLine2 = val;
                    labels.remove('addrLine2');
                }
                else if (key == 'CSCID__c' && val != '') {
                    companyID = val;
                    labels.remove('companyID');
                }             

                else if (key == 'CSCSiteID__c' && val != '') {
                    siteID = val;
                    labels.remove('siteID');
                }
                else if (key == 'Partner_Contact__c' && val != '') {
                    partnerContact = val;
                    labels.remove('partnerContact');
                }
                else if (key == 'Partner360_Flag__c' && val != '') {
                    partner360Flag = val;
                    labels.remove('partner360Flag');
                }
                

                 /* HQ Change */

                else if (key == 'HQSiteID__c' && val != '') {
                    HQSite = val;
                    labels.remove('HQSite');
                }

                else if (key == 'City__c' && val != '') {
                    city = val;
                    labels.remove('city');
                }
                else if (key == 'State__c' && val != '') {
                    state = val;
                    labels.remove('state');
                }
                else if (key == 'Country__c' && val != '') {
                    country = val;
                    labels.remove('country');
                }
                else if (key == 'TOKENID__c' && val != '') {
                    token = val;
                    labels.remove('token');
                }
                else if (key == 'Type' && val != '') {
                    pType = val;
                }
                else if (key == 'Partner_ID__c' && val != '') {
                    ptnrId = val;
                }
                else if (key == 'PDB_Site_ID__c' && val != '') {
                    pdbSiteID = val;
                    labels.remove('siteID'); //Either CSC or PDB Site ID must be present
                    labels.remove('companyID');
                }
                else if (key == 'ZipPostalCode__c' && val != '') {
                    postalCode = val;
                    //labels.remove('token');
                }
                else if (key == 'PGTMV_FLAG' && val != '') {
                    pgtmvFlag = val;
                }
                else if (key == 'PGTMV_BEC_ID' && val != '') {
                    pgtmvBecID = val;
                }
                
                //Added for Patner2 
                if (key == 'P1_Name' && val != '') {
                    p1name = val;
                    p1Labels.remove('p1name');
                }
                else if (key == 'P1_AddressLine1__c' && val != '') {
                    p1addrLine1 = val;
                    p1Labels.remove('p1addrLine1');
                }
                else if (key == 'P1_AddressLine2__c' && val != '') {
                    p1addrLine2 = val;
                    p1Labels.remove('p1addrLine2');
                }
                else if (key == 'P1_CSCID__c' && val != '') {
                    p1companyID = val;
                    p1Labels.remove('p1companyID');
                }
                else if (key == 'P1_CSCSiteID__c' && val != '') {
                    p1siteID = val;
                    p1Labels.remove('p1siteID');
                }
                else if (key == 'P1_Partner_Contact__c' && val != '') {
                    p1partnerContact = val;
                    p1Labels.remove('p1partnerContact');
                }
                else if (key == 'P1_Partner360_Flag__c' && val != '') {
                    p1partner360Flag = val;
                    p1Labels.remove('p1partner360Flag');
                }                    

                /* HQ Change */
                else if (key == 'P1_HQSiteID__c' && val != '') {
                    p1HQSite = val;
                    p1Labels.remove('p1HQSite');
                }
                else if (key == 'P1_City__c' && val != '') {
                    p1city = val;
                    p1Labels.remove('p1city');
                }
                else if (key == 'P1_State__c' && val != '') {
                    p1state = val;
                    p1Labels.remove('p1state');
                }
                else if (key == 'P1_Country__c' && val != '') {
                    p1country = val;
                    p1Labels.remove('p1country');
                }
                else if (key == 'P1_TOKENID__c' && val != '') {
                    p1token = val;
                    p1Labels.remove('p1token');
                }
                else if (key == 'P1_Type' && val != '') {
                    p1Type = val;
                    p1Labels.remove('p1Type');
                }
                else if (key == 'P1_Partner_ID__c' && val != '') {
                    p1ptnrId = val;
                }
                else if (key == 'P1_PDB_Site_ID__c' && val != '') {
                    p1pdbSiteID = val;
                    p1Labels.remove('p1siteID'); //Either CSC or PDB Site ID must be present
                    p1Labels.remove('p1companyID');
                }
                else if (key == 'P1_ZipPostalCode__c' && val != '') {
                    p1postalCode = val;
                    //labels.remove('token');
                }
                else if (key == 'P1_PGTMV_FLAG' && val != '') {
                    p1pgtmvFlag = val;
                }
                else if (key == 'P1_PGTMV_BEC_ID' && val != '') {
                    p1pgtmvBecID = val;
                }
            }
            reader.next();
        }
        return m;
    }
}