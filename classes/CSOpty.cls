global class CSOpty {
    
     // SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdate(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }
    
    // SCAVA Helper Method to validate Create Access at field level
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }

        
// This class is for Quoting
    WebService static String create(String optyXML, String ptnrXML, String dealID) {
        Opportunity op = new Opportunity();
        try {
            String outVal = ''; 
            Double timeStamp = system.now().getTime();
            //Double ts1 = system.now().getTime();
            Datetime ts1 = system.now();
            boolean isPDRDeal = false;
            String hostCamOut = '';
            String hostOut = '';
            String currCode;
            String agentCamOut = '';
            String agentOut = '';
            String hostCreated = 'FALSE';
            String agentCreated = 'FALSE';
            String isGlobal = '';
            //Added for Patner1
            String p1hostCamOut = '';
            String p1hostOut = '';            
            String p1agentCamOut = '';
            String p1agentOut = '';
            String p1hostCreated = 'FALSE';
            String p1agentCreated = 'FALSE';

            Opty.OptyMetrics om = new Opty.OptyMetrics();
            //om.setTimestamp(timeStamp);
        
            /* Parse Input and build Opty */
            MyParser parser = new MyParser();
            Opty o = new Opty();
            o = parser.parseXML(optyXML);
            o.setDealId(dealID);

            //Added by Gopal for User Currency Fix
            User us = [select DefaultCurrencyIsoCode from user where id=:o.getSFDCUserId()limit 1];      
            currCode= us.DefaultCurrencyIsoCode;
            o.setCurrCode(currCode);

            
            timeStamp = doTiming(timeStamp,'parse opty');
            //om.addTiming('ParseOpty',timeStamp);

            /* ISP Changes */
//            o.stageChangedFromPDR(o.getStageName(), o.getPtnrStatus());
            // P360 Changes
            boolean optyNameCheck = true;
            if (o.getP360Flag() == 'Y') {
            op.Recordtypeid = o.getRecordType('Partner Parent Opportunity');
                isPDRDeal = true;
                optyNameCheck = false;
                op.Next_Approver_Alias__c = o.getSsrEmailId();
                //o.stageChangedFromPDR(op.StageName, o.getPtnrStatus());
                op.StageName = '1 - Prospect';
                op.Opportunity_Flags__c = 'Partner Led';
                op.target_prospect__c = o.getLeadId();
                
                //op.Partner_Led_Opportunity__c = True;
            
            }
            //Changes for the lead conversion scenario
            if(o.getp360LeadFlag() == 'Y'){
                String optyId=convertLead(o);
                //Opportunity opty = new Opportunity();
                op = [select Recordtypeid,Next_Approver_Alias__c,StageName,
                            Opportunity_Flags__c,Data_Source_Name__c,AccountId,Name,
                            Expected_Product__c,Expected_Service__c,Forecast_status__c,
                            Position__c,Opportunity_status__c,Competitors__c,SSR_Email_Id__c,
                            Territory2Id,Source_Opp_ID__c,Start_Date__c,End_Date__c,
                            Reason_Code__c,Service_Source__c,OMF_notes__c,
                            DealId__c,Partner_Deal_Status__c,PromotionID__c,
                            PromotionCode__c,PromotionName__c,Non_Standard_Terms_and_Conditions__c,
                            Discount_Approval__c,Discount_Type__c,Product_Enhancements__c,
                            CurrencyIsoCode,Managed_Services__c,Pull_Forward_Date__c,
                            CloseDate,Deal_Create_Date__c,Description,OwnerId,theater__c,
                            Expected_Product_List_Amount__c,Expected_Service_List_Amount__c,
                            Eligible_NS__c,Partner_Deal_Type__c,Contractual_Pricing_Letter_Opportunity__c,
                            Global_Deal_ID__c,Primary_Partner__c,Primary_Partner_Role__c,
                            Partner_2__c,Role_2__c,Partner_3__c,Role_3__c,CRP_Flag__c
                            from Opportunity where id=:optyId];
                op.Recordtypeid = o.getRecordType('Partner Parent Opportunity');
                isPDRDeal = true;
                optyNameCheck = false;
                op.Next_Approver_Alias__c = o.getSsrEmailId();
                op.StageName = '1 - Prospect';
                op.Opportunity_Flags__c = 'Partner Led';
                 try {
                      outVal += upsertMultiObjectQuote(optyXML, optyId, 'Opportunity');
                    }
                    catch (Opty.OptyException oe) {
                        outVal += '::'+oe.getMessage()+'::';
                    }
            }
            
            /* Set opportunity values */
            op.Data_Source_Name__c = o.getSrcSys();
            op.AccountId = o.getSfdcAcctId();
            // Opty name check should not work for P360 Lead Conversion Process
            
            if(o.getP360LeadFlag() != 'Y')
            op.Name = o.getName();
                
            //op.StageName = o.getStageName();
            op.Expected_Product__c = o.getExpPrdRevDec();
            op.Expected_Service__c = o.getExpSvcRevDec();
            op.Forecast_status__c = o.getFcstStatus();
            op.Position__c = o.getFcstPostn();
            op.Opportunity_status__c = o.getStatus();
            op.Competitors__c = o.getCompetitor();
            op.Deal_Source__c = o.getDealSource();

            //SOM changes
            if (o.getSrcSys() == 'PDR') {
                op.Recordtypeid = o.getRecordType('Partner Parent Opportunity');
                isPDRDeal = true;
                op.Next_Approver_Alias__c = o.getSsrEmailId();
                // Skipping the stage name change for P360 conversion process
                if(o.getP360flag() == 'N' && o.getP360LeadFlag() == 'N'){
                o.stageChangedFromPDR(op.StageName, o.getPtnrStatus());
                op.StageName = o.getStageName();
                }
            }
            
            else{
              op.Recordtypeid = o.getRecordType('Parent Opportunity');
                op.SSR_Email_Id__c = o.getSsrEmailId();
              if(o.getP360flag() == 'N' && o.getP360LeadFlag() == 'N'){
              op.StageName = o.getStageName();
              }

              Id terrId = CSOptyUtils.getTerrIdByPostn(o.getFcstPostn());
              if (terrId != null) {
                op.Territory2Id = terrId;

              }
            }
            
            if (o.getSrcKey() != '') {
                op.Source_Opp_ID__c = o.getSrcKey();
            }
            op.Contract_Number__c = o.getContractNo();
            if (!o.isStartDateNull()) {
                op.Start_Date__c = o.getStartDate();
            }
            if (!o.isEndDateNull()) {
                op.End_Date__c = o.getEndDate();
            }
            op.Reason_Code__c = o.getReasonCode();
            op.Service_Source__c = o.getSvcSource();
            op.OMF_notes__c = o.getOMFNotes();
            op.DealId__c = o.getDealId();
            op.Partner_Deal_Status__c = o.getPtnrStatus();
            op.PromotionID__c = o.getPromoId();
            op.PromotionCode__c = o.getPromoCode();
            op.PromotionName__c = o.getPromoName();
            op.ProgramName__c = o.getProgName();
            op.Non_Standard_Terms_and_Conditions__c = o.getNstcpe();
            op.Discount_Approval__c = o.getDiscAprvl();
            op.Discount_Type__c = o.getDiscType();
            op.Product_Enhancements__c = o.getProdEnh();
            op.CurrencyIsoCode = o.getCurrCode();
            op.Managed_Services__c = o.getManagedSvc();
            // RNSD changes for Q1FY13 Release
            op.IS_FA_FLAG__c = o.getIs_FA_Flag();
            op.IS_AT_OR_BELOW_FLAG__c = o.getIs_At_Or_Below_Flag();
            //op.IS_COLLABORATED__c = o.getIs_Collaborated(); 
            op.CRP_Flag__c = o.getCRPFlag();
            
            //Added part of solution id project with release FYQ15-Apr
            op.Solution_Identifier__c = o.getsolutionId();
            op.Deal_Type__c = o.getapprovalRoute(); //SW1003 project changes Q1FY16 Aug
            op.Partner_Required__c = o.getpartnerRequired();//SW1003 project changes Q1FY16 Aug
            
            if (!o.isPullFwdDateNull()) {
                op.Pull_Forward_Date__c = o.getPullFwdDate();
            }
            if (!o.isExpDateNull()) {
                op.CloseDate = o.getExpDate();
            }
            if (!o.isExpireDateNull()) {
                //op.Deal_Expiration_Date__c = o.getExpireDate();
                Date QuoteExpirationDate = o.getExpireDate();
            }
            if (!o.isDealCreateDateNull()) {
                op.Deal_Create_Date__c = o.getDealCreateDate();
            }
            op.Description = o.getDesc();
            op.OwnerId = o.getSFDCUserId();
            op.Opportunity_Owner_AM__c = o.getSFDCUserId();
            op.theater__c = o.getUserTheater();
            op.Expected_Product_List_Amount__c = o.getExpPrdLstAmtDec();
            op.Expected_Service_List_Amount__c = o.getExpSvcLstAmtDec();
            //op.Product_Quote_Amount__c = o.getPrdQutAmtDec();
            Decimal PrdQutAmtDec = o.getPrdQutAmtDec();
            //op.Service_Quote_Amount__c = o.getSvcQutAmtDec();
            Decimal SvcQutAmtDec = o.getSvcQutAmtDec();
            op.Eligible_NS__c = o.getEligibleNS();
            op.Partner_Deal_Type__c = o.getPtnrDealType();
            isGlobal = o.getPtnrDealType();

              /* Checking Deal type for Global.*/
              if (isGlobal == 'Global Deal')
                  op.Contractual_Pricing_Letter_Opportunity__c = 'Yes';
                  
            op.Global_Deal_ID__c = o.getGlobalDealId();
            //op.CBN_Status__c = o.getCBNStatus();
            String CBNStatus = o.getCBNStatus();
            
            
            /* Look up Partner account */
            /* only if PDR Deal */
            String ptnrID = '';
            DRTM_Deal_Type__c dType = DRTM_Deal_Type__c.getInstance(); //Q1FY16 DRTM change
            double dealType = dType.DealType__c; //Q1FY16 DRTM change
            double nsDealType = dType.non_std_Deal__c; //Q1FY16 DRTM change
            if (isPDRDeal && (op.Deal_Type__c != dealType || op.Deal_Type__c != nsDealType)) {  //Q1FY16 SW1003 change
            //Double ts2 = system.now().getTime();
            Datetime ts2 = system.now();
            //String ptnrID = parser.processPartner(ptnrXML);
            Map<String,String> mp = parser.processPartner(ptnrXML, true);

            timeStamp = doTiming(timeStamp,'process partner');
            om.addTiming('ProcessPartner',system.now(),ts2);

            if (mp.containsKey('HOST_OTHER')) {
                ptnrID = mp.get('HOST_OTHER');
            
                if (ptnrID == 'FALSE') {
                    outVal += '::Required Partner data is missing!::';
                }
                else if (ptnrID == 'CAM_INACTIVE') {
                    outVal += '::Country and Unallocated CAM are inactive!::';
                }
                else {
                    /* Call service to add Partner to the Opportunity */
                    //Utilities.addOpptyPartner(ptnrID, String.valueOf(op.Id));
                    op.Primary_Partner__c = ptnrID;
                    op.Primary_Partner_Role__c = '';
                    hostOut = ptnrID;
                    hostCamOut = mp.get('HOST_CAM');
                    hostCreated = mp.get('HOST_CREATED');
                }
            }
            outVal += '::Partner ID: '+ptnrID+'::';

            if (mp.containsKey('AGENT')) {
                String agentPtnr = mp.get('AGENT');
                if (agentPtnr == 'FALSE') {
                    outVal += '::Agent Partner data is missing!::';
                }
                else if (agentPtnr == 'CAM_INACTIVE') {
                    outVal += '::Agent Partner Country and Unallocated CAM are inactive!::';
                }
                else {
                    /* Call service to add Partner to the Opportunity */
                    op.Partner_2__c = agentPtnr;
                    if(o.getCRPFlag()== 'Y'){
                        op.Role_2__c = 'Sell with';
                    }else{
                        op.Role_2__c = '';
                    }    
                    agentOut = ptnrID;
                    agentCamOut = mp.get('AGENT_CAM');
                    agentCreated = mp.get('AGENT_CREATED');
                }
                outVal += '::Agent Partner ID: '+agentPtnr+'::';
            }
            
            timeStamp = doTiming(timeStamp,'add partner to opty');
            //om.addTiming('AddPartnerToOpty',timeStamp);
            }

            /* If opportunity is valid, create it */
            if (o.isValid() && o.dealIDDNE()) {
            
            /* If opportunity is P360 Lead converted opty then update opty else insert new*/
            if(o.getp360LeadFlag() == 'Y')
            {
                    Update op;
            }
            else{
                    Insert op;
                }
                timeStamp = doTiming(timeStamp,'create opty');
                //om.addTiming('InsertOpty',timeStamp);

                /*
                 * If a CAM (CEC ID) was sent from the client:
                 * - look up the User record in SFDC
                 * - add to Sales Team 
                 */
                if (o.getCAMUserId() != '') {
                    try {
                        String camSFDCId = o.getSFDCUserId(o.getCAMUserId());
                        
                         /* If the CAM is not the owner, go ahead and add the CAM.
                         * If the CAM is the owner, there will be an exception when
                         * trying to set read-only access to them
                         */
                         
                        if (camSFDCId != o.getSFDCUserId()) {
                            Utilities.addStUser(String.valueOf(op.Id), camSFDCId, 'Read', 'Channel Account Manager', 'testme' );
                        }
                    }
                    catch (Opty.OptyException oe) {
                        outVal += '::CAM '+ o.getCAMUserId() + ' is not a valid SFDC user::';
                    }
                    catch (Exception e) {
                        outVal += '::Unable to add CAM '+ o.getCAMUserId() + ' to Opportunity Sales Team:' + e.getMessage() + '::';
                    }
                }
                /* Set flag to allow processing of line items.
                 * This will calculate the price on the line item
                 */
                MixPct.setProcessLineItems(true);
                
                /* Add Service Line Item */
                Integer siSize = o.getServiceItemSize();
                List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
                for (Integer i=0;i<siSize;i++) {
                    Opty.ServiceItem si = o.getServiceItem(i);
                    if (!si.validateService(o.getCurrCode())) {
                        outVal +='::Service not inserted - invalid service::';
                    }
                    else if(!si.validateLevel()) {
                        outVal +='::Service not inserted - invalid level::';
                    }
                    else { 
                        /* Opportunity Line Item */
                        try {
                            OpportunityLineItem oli = new OpportunityLineItem();
                            oli.OpportunityId = String.valueOf(op.Id);
                            oli.quantity = 1;
                            oli.PriceBookEntryId = si.getPriceBkId();
                            oli.mix__c = si.getMixPctDouble();
                            oli.service_level__c = si.getSvcLevel();
                            oliList.add(oli);
                            //Insert oli;
                        }
                        catch (Exception e){outVal+= e.getMessage()+si.getMixPct();}
                    }
                }
                try {
                  if (oliList.size() > 0) {
                        insert oliList;
                  }
                }
                catch (Exception e){outVal+= e.getMessage();}

                timeStamp = doTiming(timeStamp,'add service item');
                //om.addTiming('InsertServiceItem',timeStamp);

                /* Set flag to allow processing of line items.
                 * This will calculate the price on the line item
                 */
                MixPct.setProcessLineItems(true);

                /* Add Product Line Item */
                Integer piSize = o.getProductItemSize();
                oliList = new List<OpportunityLineItem>();
                for (Integer i=0;i<piSize;i++) {
                    Opty.ProductItem pi = o.getProductItem(i);
                    if (!pi.validateProduct(o.getCurrCode())) {
                        outVal +='::Product not inserted - invalid product::';
                    }
                    else { 
                        /* Opportunity Line Item */
                        try {
                            OpportunityLineItem oli = new OpportunityLineItem();
                            oli.OpportunityId = String.valueOf(op.Id);
                            oli.quantity = 1;
                            oli.PriceBookEntryId = pi.getPriceBkId();
                            oli.mix__c = pi.getMixPctDouble();
                            //oli.product_family_us__c = pi.getProdFamily();
                            oliList.add(oli);
                            //Insert oli;
                        }
                        catch (Exception e){outVal+= e.getMessage()+pi.getMixPct();}
                    }
                }
                try {
                  if (oliList.size() > 0) {
                        insert oliList;
                  }
                }
                catch (Exception e){outVal+= e.getMessage();}

                timeStamp = doTiming(timeStamp,'add product item');
                //om.addTiming('InsertProdItem',timeStamp);
                om.addTiming('OptyEndToEnd',system.now(),ts1);
            
                if (!isPDRDeal) {
                  if (o.getOMFNotes() != null && o.getOMFNotes() != '') {
                    if (!CSOptyUtils.createNote('Opportunity Contract Details',String.ValueOf(op.Id),o.getOMFNotes())) {
                      outVal += '::Failed to create SOM Note::';
                    }
                  }
                }
                /* Add Quote Header
                 * - Assume Quote exists if Quote Id is not  null
                */
                if (o.getQuoteID() != '' && o.getIsDummyQuote() == 'N') {
                    try {
                      outVal += addQuote(op.AccountId, op.Id, op.Name, o.getQuoteUpdatedBy(), o.getQuoteUpdatedDt(),ptnrID,o.getQuoteID(),o.getQuoteName(), o.getCBNStatus(),o.getPtnrStatus(),PrdQutAmtDec,SvcQutAmtDec,o.getExpireDate(),o.getIsFinalized(),decimal.valueOf(o.getQuoteProductNetPrice()),decimal.valueOf(o.getQuoteServiceNetPrice()),o.getIs_Collaborated());
                    }
                    catch (Opty.OptyException oe) {
                        outVal += '::'+oe.getMessage()+'::';
                    }
                }
            
                /* Return Success message with Deal ID and SFDC Opportunity ID */
                return Opty.outXML(dealID,String.valueOf(op.Id),'SUCCESS',hostOut,hostCamOut,hostCreated,agentOut,agentCamOut,agentCreated,outVal,om.outputXML());
            }
            /*
             * If the opportunity is not valid or the Deal ID already exists
             * return Deal ID and Failure message
             */
            else {
                outVal += o.getErrMsg();
                return Opty.outXML(dealID,String.valueOf(op.Id),'FAILURE',outVal);
            }
        }
        /* Catch planned Exceptions */
        catch (Opty.OptyException oe) {
            return Opty.outXML(dealID,String.valueOf(op.Id),'FAILURE',oe.getMessage());
        }
        /* Handle any unexpected Exceptions */
        catch (Exception e) {
            return Opty.outXML(dealID,String.valueOf(op.Id),'FAILURE',e.getMessage());
        }
    }
    
    /* Method to merge existing opportunities */
    WebService static String dealMerge(String optyXML, String ptnrXML, String dealID, String sfdcOptyID) {
        Opportunity origOp = new Opportunity();
        Opportunity op = new Opportunity();
        String origOpName = '';
        try {
            String outVal = '';
            Double timeStamp = system.now().getTime();
            //Double ts1 = system.now().getTime();
            Datetime ts1 = system.now();
            Opty.OptyMetrics om = new Opty.OptyMetrics();
            //om.setTimestamp(timeStamp);
            String hostCamOut = '';
            String hostOut = '';
            String agentCamOut = '';
            String agentOut = '';
            String hostCreated = 'FALSE';
            String agentCreated = 'FALSE';
                    
            /*Parse Input and build Opty*/
            MyParser parser = new MyParser();
            Opty o = new Opty();
            o = parser.parseXML(optyXML);
            o.setDealId(dealID);
            timeStamp = doTiming(timeStamp,'ParseOpty');
            //om.addTiming('ParseOpty',timeStamp);
            
            //Do the check on Deal ID existing
            o.dealIDDNE();

            /* 
             * Find SFDC Opportunity to merge to
             */
            /* START DYNAMIC APEX */
            /* Get all fields for the sObject */
            Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Opportunity.fields.getMap();
            List<String> fieldList = CSOptyUtils.getFieldList(fieldMap,true);
            
            /* Build query string
             * - All previously merged opportunities should have a Cancelled status and should not be picked up
             */
            String fieldNames = CSOptyUtils.getFieldNamesFromList(fieldList);
            
            system.debug('check oppty Id:' +sfdcOptyID );
            String q = 'select '+fieldNames+' from Opportunity where Id=\''+sfdcOptyID+'\' and Opportunity_Status__c = \'Active\' Limit 1';
            String isGlobal2 = '';
            
            
            /* Fetch object details and cast */
            sObject S;
            try {
                S = Database.query(q);
            }
            catch (QueryException qe) {
                throw new Opty.OptyException('SFDC-20: Merge failure - opportunity not available to be merged:'+sfdcOptyID);
            }               

            origOp = (Opportunity)S;
            /* END DYNAMIC APEX */
            op = origOp.clone(false);
            //op.Opportunity_Owner_AM__c = origOp.owner.id;
                        
            /* Overwrite with values from the Partner Deal*/
//            if (!o.inputStageNameNull()) {
                //op.StageName = o.getStageName();
//            }
             // Changes done for P360 when a target prospect initiated deal is getting merged with an SFDC Opty
              if (o.getP360Flag() == 'Y') {
            op.Recordtypeid = o.getRecordType('Partner Parent Opportunity');
                op.Next_Approver_Alias__c = o.getSsrEmailId();
                //o.stageChangedFromPDR(op.StageName, o.getPtnrStatus());
                op.StageName = '1 - Prospect';
                op.Opportunity_Flags__c = 'Partner Led';
                op.target_prospect__c = o.getLeadId();
                op.Deal_Source__c = o.getDealSource();
            }

             //Changes done for P360, deals created from leads can be merged with SFDC Opportunities
            if(o.getp360LeadFlag() == 'Y')
            {
                //String optyId=convertLead(o);
                Lead lead;
                String createdOpptyId = '';
        try {
            //Fetching the details of the lead that is to be converted
            lead=[select Id,Name,OwnerId,
                              IsConverted,ConvertedDate,
                              ConvertedAccountId,ConvertedContactId,ConvertedOpportunityId,
                              Email,Status, LastName from lead where Id = :o.getLeadId()];
        }
        catch(QueryException qe) {
            outVal += '::Lead data does not exist in SFDC!::';
        }
    
        //check for the status of the lead
            if(lead.Status!='2 Accepted-Mine/Channel') {
                //Lead cannot be converted as status is not as above
                outVal += '::Only the lead with status "2 Accepted-Mine/Channel" can be converted to opportunity::';
                //Stop the control here
            }
            
            // Skipping the same last name validation rule on leads
            //try{
            String dEmail = lead.Email;
            String dLastName = lead.LastName;
            String dAccountId = o.getSfdcAcctId();
            String qr = 'select Id from Contact where AccountId =: dAccountId and Email =: dEmail and LastName =: dLastName';
            
            Contact[] ct;
            ct = (List<Contact>)Database.query(qr);
          
           
            // calling the database method called as LeadConvert() to convert the lead which we get in XML 
            Database.LeadConvert lc = new database.LeadConvert();

            if(ct.size() > 0){
              lc.setContactId(ct[0].id);
            }
                        



            lc.setLeadId(lead.id);
            //End customer Account id which comes in XML need to be set
            lc.setAccountId(op.AccountId);
            lc.setConvertedStatus('2 Accepted-Mine/Channel');
            //Create an opportunity from the lead
            lc.setDoNotCreateOpportunity(false);
            lc.setOpportunityName(op.Name);
            // Making the logged user as the opty owner
            lc.setOwnerId(o.getSFDCUserId());
            
            //Fetching the ID od newly created opportunity 
            try
            {
                lead.Opportunity_Owner_AM__c = o.getSFDCUserId();
                update lead;
                Database.LeadConvertResult lcr  = Database.convertLead(lc);
                createdOpptyId=lcr.getOpportunityId();
            }
            catch (Exception e)
            {
                outVal+=e.getMessage();
                return null;
            }       
                //Opportunity opty = new Opportunity();
                op = [select Recordtypeid,Next_Approver_Alias__c,StageName,
                            Opportunity_Flags__c,Data_Source_Name__c,AccountId,Name,
                            Expected_Product__c,Expected_Service__c,Forecast_status__c,
                            Position__c,Opportunity_status__c,Competitors__c,SSR_Email_Id__c,
                            Territory2Id,Source_Opp_ID__c,Start_Date__c,End_Date__c,
                            Reason_Code__c,Service_Source__c,OMF_notes__c,
                            DealId__c,Partner_Deal_Status__c,PromotionID__c,
                            PromotionCode__c,PromotionName__c,Non_Standard_Terms_and_Conditions__c,
                            Discount_Approval__c,Discount_Type__c,Product_Enhancements__c,
                            CurrencyIsoCode,Managed_Services__c,Pull_Forward_Date__c,
                            CloseDate,Deal_Create_Date__c,Description,OwnerId,theater__c,
                            Expected_Product_List_Amount__c,Expected_Service_List_Amount__c,
                            Eligible_NS__c,Partner_Deal_Type__c,Contractual_Pricing_Letter_Opportunity__c,
                            Global_Deal_ID__c,Primary_Partner__c,Primary_Partner_Role__c,
                            Partner_2__c,Role_2__c, deal_source__c,CRP_Flag__c,Solution_Identifier__c
                            from Opportunity where id=:createdOpptyId];
                op.Recordtypeid = o.getRecordType('Partner Parent Opportunity');
                op.Next_Approver_Alias__c = o.getSsrEmailId();
                op.StageName = '1 - Prospect';
                op.Opportunity_Flags__c = 'Partner Led';
                op.Deal_Source__c = o.getDealSource();
                try {
                      outVal += upsertMultiObjectQuote(optyXML, createdOpptyId, 'Opportunity');
                    }
                    catch (Opty.OptyException oe) {
                        outVal += '::'+oe.getMessage()+'::';
                    }
            }
            op.Recordtypeid = o.getRecordType('Partner Parent Opportunity');
            op.Deal_ID_Original__c = nvl(op.DealId__c);
            op.DealId__c = o.getDealId();
            op.Deal_Source__c = o.getDealSource();
            op.Partner_Deal_Type__c = o.getPtnrDealType();
            isGlobal2 = o.getPtnrDealType();
            op.Global_Deal_ID__c = o.getGlobalDealId();
            op.error_description__c = '';
            op.dd_status__c = '';
            //op.CBN_Status__c = o.getCBNStatus();
            String CBNStatus = o.getCBNStatus();
            
            // RNSD changes for Q1FY13 Release
            op.IS_FA_FLAG__c = o.getIs_FA_Flag();
            op.IS_AT_OR_BELOW_FLAG__c = o.getIs_At_Or_Below_Flag();
            //op.IS_COLLABORATED__c = o.getIs_Collaborated();
            op.CRP_Flag__c = o.getCRPFlag();
            
            /* Checking Deal type for Global.*/

              if (isGlobal2 == 'Global Deal')
                  op.Contractual_Pricing_Letter_Opportunity__c = 'Yes';
            /* As per Frank - 11/17/08, apply forecast status value the same as for a direct conversion
             * If PDR sends a value we will use it, else it will use the default value
             */
            op.Forecast_status__c = o.getFcstStatus();
            
            /* Get conversion rate */
            Decimal currRate = getCurrConvRate(sfdcOptyID, op.CurrencyIsoCode);
            
            /* If null, overwrite opportunity values from partner deal */
            if (op.Expected_Product__c == null) {
                op.Expected_Product__c = currRate*o.getExpPrdRevDec();
            }
            if (op.Expected_Service__c == null) {
                op.Expected_Service__c = currRate*o.getExpSvcRevDec();
            }
            if (op.Position__c == null) {
                op.Position__c = o.getFcstPostn();
            }
            if (op.Opportunity_status__c == null) {
                op.Opportunity_status__c = o.getStatus();
            }
            if (nvl(op.Competitors__c) == '' || op.Competitors__c == 'Competitors') {
                op.Competitors__c = o.getCompetitor();
            }
            if (op.Partner_Deal_Status__c == null) {
                op.Partner_Deal_Status__c = o.getPtnrStatus();
            }
            if (op.PromotionID__c == null) {
                op.PromotionID__c = o.getPromoId();
            }
            if (op.PromotionCode__c == null) {
                op.PromotionCode__c = o.getPromoCode();
            }
            if (op.PromotionName__c == null) {
                op.PromotionName__c = o.getPromoName();
            }
            if (op.ProgramName__c == null) {
                op.ProgramName__c = o.getProgName();
            }
            if (op.Non_Standard_Terms_and_Conditions__c == null) {
                op.Non_Standard_Terms_and_Conditions__c = o.getNstcpe();
            }
            if (op.Discount_Approval__c == null) {
                op.Discount_Approval__c = o.getDiscAprvl();
            }
            if (op.Discount_Type__c == null) {
                op.Discount_Type__c = o.getDiscType();
            }
            if (op.Product_Enhancements__c == null) {
                op.Product_Enhancements__c = o.getProdEnh();
            }
            //if (op.CurrencyIsoCode == null) {
            //    op.CurrencyIsoCode = o.getCurrCode();
            //}
            if (op.Pull_Forward_Date__c == null && !o.isPullFwdDateNull()) {
                op.Pull_Forward_Date__c = o.getPullFwdDate();
            }
            if (op.CloseDate == null && !o.isExpDateNull()) {
                op.CloseDate = o.getExpDate();
            }
            /* Commenting as field is moved to Quote Object, will be added in AddQuote Method
            if (op.Deal_Expiration_Date__c == null && !o.isExpireDateNull()) {
                op.Deal_Expiration_Date__c = o.getExpireDate();
            }
            */
            if (op.Deal_Create_Date__c == null && !o.isDealCreateDateNull()) {
                op.Deal_Create_Date__c = o.getDealCreateDate();
            }
            if (op.Description == null) {
                op.Description = o.getDesc();
            }
            if (op.Next_Approver_Alias__c == null) {
                op.Next_Approver_Alias__c = o.getSsrEmailId();
            }
            if (op.Expected_Product_List_Amount__c == null) {
                op.Expected_Product_List_Amount__c = currRate*o.getExpPrdLstAmtDec();
            }
            if (op.Expected_Service_List_Amount__c == null) {
                op.Expected_Service_List_Amount__c = currRate*o.getExpSvcLstAmtDec();
            }
            
            if (op.Eligible_NS__c == null) {
                op.Eligible_NS__c = o.getEligibleNS();
            }
            if (op.Managed_Services__c == null) {
                op.Managed_Services__c = o.getManagedSvc();
            }
            
            //Added part of solution id project with release FYQ15-Apr
            op.Solution_Identifier__c = o.getsolutionId();
            
            /* Commented as these fields are now moved to Quote Object, Need to query on Quote Object
            if (op.Product_Quote_Amount__c == null) {
                op.Product_Quote_Amount__c = currRate*o.getPrdQutAmtDec();
            }
            if (op.Service_Quote_Amount__c == null) {
                op.Service_Quote_Amount__c = currRate*o.getSvcQutAmtDec();
            }*/       
            /*Quote__c qu = new Quote__c();
            qu = [select Id from Quote__c where Opportunity_Name__c=:op.Id and DM_Quote_ID__c =: o.getQuoteID() Limit 1];
            if (qu.Deal_Expiration_Date__c == null && !o.isExpireDateNull()) {
                qu.Deal_Expiration_Date__c = o.getExpireDate();
            }
            if (qu.Product_Quote_Amount__c == null) {
                qu.Product_Quote_Amount__c = currRate*o.getPrdQutAmtDec();
            }
            if (qu.Service_Quote_Amount__c == null) {
                qu.Service_Quote_Amount__c = currRate*o.getSvcQutAmtDec();
            }      
            update qu;
            */ 
            Decimal PrdQutAmtDec = currRate*o.getPrdQutAmtDec();
            Decimal SvcQutAmtDec  = currRate*o.getPrdQutAmtDec();    
            timeStamp = doTiming(timeStamp,'MergeOpty');
            om.addTiming('OptyEndToEnd',system.now(),ts1);

            /* Look up Partner account */
            //Double ts2 = system.now().getTime();
            Datetime ts2 = system.now();
            //String ptnrID = parser.processPartner(ptnrXML);
            String ptnrID = '';
            String agentPtnrID = '';
            boolean agentOK = false;
            Integer ptnrCnt = 0;
            Map<String,String> pmp = parser.processPartner(ptnrXML, true);
            
            /* Get either the default or Host partner */
            if (pmp.containsKey('HOST_OTHER')) {
                ptnrID = pmp.get('HOST_OTHER');
                ptnrCnt++;
            }
            /* Get the Agent partner if it exists */
            if (pmp.containsKey('AGENT')) {
                agentPtnrID = pmp.get('AGENT');
                ptnrCnt++;
            }
            timeStamp = doTiming(timeStamp,'process partner');
            om.addTiming('ProcessPartner',system.now(),ts2);

            if (agentPtnrID == '' || agentPtnrID == 'FALSE') {
                outVal += '::Agent Partner data is missing!::';
            }
            else if (agentPtnrID == 'CAM_INACTIVE') {
                outVal += '::Agent Partner country and Unallocated CAM are inactive!::';
            }
            else {
                agentOK = true;
                agentOut = ptnrID;
                agentCamOut = pmp.get('AGENT_CAM');
                agentCreated = pmp.get('AGENT_CREATED');
                outVal += '::Agent Partner ID: '+agentPtnrID+'::';
            }

            if (ptnrID == 'FALSE') {
                outVal += '::Required Partner data is missing!::';
            }
            else if (ptnrID == 'CAM_INACTIVE') {
                outVal += '::Country and Unallocated CAM are inactive!::';
            }
            else {
                /* Add Partner to the Opportunity */
                List<String> ptnrList = new List<String>();
                List<String> ptnrRole = new List<String>();
                ptnrList.add(ptnrID);
                ptnrRole.add('');
                hostOut = ptnrID;
                hostCamOut = pmp.get('HOST_CAM');
                hostCreated = pmp.get('HOST_CREATED');
                if (agentOK) {
                    ptnrList.add(agentPtnrID);
                    ptnrRole.add('');
//                  outVal += '::Agent added::';
                }

                if (op.Primary_Partner__c != null) {
                    ptnrList.add(op.Primary_Partner__c);
                    ptnrRole.add(nvl(op.Primary_Partner_Role__c));
                }
                if (op.Partner_2__c != null) {
                    ptnrList.add(op.Partner_2__c);
                    ptnrRole.add(nvl(op.Role_2__c));
                }
                if (op.Partner_3__c != null) {
                    ptnrList.add(op.Partner_3__c);
                    ptnrRole.add(nvl(op.Role_3__c));
                }
                if (op.Partner_4__c != null) {
                    ptnrList.add(op.Partner_4__c);
                    ptnrRole.add(nvl(op.Role_4__c));
                }
                if (op.Partner_5__c != null) {
                    ptnrList.add(op.Partner_5__c);
                    ptnrRole.add(nvl(op.Role_5__c));
                }
//              outVal += '::ptnrList.size(): '+ptnrList.size()+'::';
                for (Integer i=ptnrCnt;i<ptnrList.size();i++) {
                    if (ptnrList[i] == ptnrID) {
                        /* Update Primary Partner Role with what was already there */
                        ptnrRole[0] = ptnrRole[i];
                        
                        ptnrList.remove(i);
                        ptnrRole.remove(i);
                        i--;
                        
                    }
                    else if (agentOK && ptnrList[i] == agentPtnrID) {
                        /* Update Agent Partner Role with what was already there */
                        ptnrRole[1] = ptnrRole[i];
                        
                        ptnrList.remove(i);
                        ptnrRole.remove(i);
                        i--;
                    }
                }
                op.Primary_Partner__c = ptnrList.get(0);
                op.Primary_Partner_Role__c = ptnrRole.get(0);
//                  outVal += '::ptnrList[0]: '+ptnrList.get(0)+'::';

                if (ptnrList.size() > 1 && ptnrList[1] != null) {
                    op.Partner_2__c = ptnrList.get(1);
                    op.Role_2__c = ptnrRole.get(1);
//                  outVal += '::ptnrList[1]: '+ptnrList.get(1)+'::';
                }
                else {
                    op.Partner_2__c = null;
                    op.Role_2__c = null;
                }                
                if (ptnrList.size() > 2 && ptnrList[2] != null) {
                    op.Partner_3__c = ptnrList.get(2);
                    op.Role_3__c = ptnrRole.get(2);
                }
                else {
                    op.Partner_3__c = null;
                    op.Role_3__c = null;
                }                
                if (ptnrList.size() > 3 && ptnrList[3] != null) {
                    op.Partner_4__c = ptnrList.get(3);
                    op.Role_4__c = ptnrRole.get(3);
                }
                else {
                    op.Partner_4__c = null;
                    op.Role_4__c = null;
                }                
                if (ptnrList.size() > 4 && ptnrList[4] != null) {
                    op.Partner_5__c = ptnrList.get(4);
                    op.Role_5__c = ptnrRole.get(4);
                }
                else {
                    op.Partner_5__c = null;
                    op.Role_5__c = null;
                }                
            }
            outVal += '::Partner ID: '+ptnrID+'::';
            
            /* ISP Changes */
              if(o.getP360flag() == 'N' && o.getP360LeadFlag() == 'N'){
                o.stageChangedFromPDR(op.StageName, o.getPtnrStatus());
                op.StageName = o.getStageName();
                }
            /* Update original opportunity name so unique name validation won't fail */
            origOpName = origOp.Name;
            if (origOp.Name.length() > 83) {
                origOp.Name = origOp.Name.substring(0,82);
            }
            origOp.Name = origOp.Name + '-MERGED w/' +  dealID;
            //Update origOp; /* Commenting the line to avoid too many Soql queries limit */

            
            /* Create new merged opportunity */
            // If deal is lead intiated then UPDATE the opty else INSERT new one
            if(o.getp360LeadFlag() == 'Y')
            {
                    Update op;
            }
            else{
                    Insert op;
                }
            
            /* Update original opportunity */
            origOp.Description = 'This Opportunity has been merged with a Partner Opportunity and has been cancelled.  The Deal ID of the merged Opportunity which has replaced this is '+dealID+'.  '+nvl(origOp.Description);
            origOp.Opportunity_Status__c = 'Cancelled';
            origOp.Lost_Cancelled_Reason__c = 'Cancelled - Merged with Partner Opportunity';
            origOp.Recordtypeid = o.getRecordType('Void Merged Opportunity'); //Read-only record type
            origOp.Merged_Opportunity__c = op.Id;
            Update origOp;

            /* Copy SalesTeam */
            if (!Utilities.copySalesTeam(sfdcOptyID, String.valueOf(op.Id))) {
                outVal += '::Exception while copying SalesTeam::';
            }
            else {
                /*
                 * If a CAM (CEC ID) was sent from the client:
                 * - look up the User record in SFDC
                 */
                String camSFDCId = '';
                if (o.getCAMUserId() != '') {
                    try {
                        camSFDCId = o.getSFDCUserId(o.getCAMUserId());
                    }
                    catch (Opty.OptyException oe) {
                        outVal += '::CAM '+ o.getCAMUserId() + ' is not a valid SFDC user::';
                    }
                }
                /*
                 * If the CAM passed in was a valid SFDC user and not on the Sales Team
                 * - add to Sales Team 
                 */
                if (camSFDCId != '' && camSFDCId != op.OwnerId) {
                    try {
                        opportunityTeamMember ot = [Select o.UserId From OpportunityTeamMember o 
                        where o.OpportunityId=:op.Id and o.IsDeleted=false and o.UserId=:camSFDCId Limit 1];
                        outVal += '::CAM found - do nothing: '+ ot.UserId+'::';
                        }
                    catch (QueryException qe) {
                        //CAM not on the Sales Team to Add him
                        Utilities.addStUser(String.valueOf(op.Id), camSFDCId, 'Read', 'Channel Account Manager', 'testme' );
                        outVal += '::CAM NOT found - adding: '+ camSFDCId+'::';
                    }
                    catch (Exception e) {
                        outVal += '::Unable to add CAM '+ o.getCAMUserId() + ' to Opportunity Sales Team:' + e.getMessage() + '::';
                    }
                }
            }
            
            /* Set flag to allow processing of line items.
             * This will calculate the price on the line item
             */
            MixPct.setProcessLineItems(true);
            
            /* Copy Line Items
             * This copies the Line items from the original SFDC deal
             */
            Map<String, boolean> mp = copyLineItems(sfdcOptyID, String.valueOf(op.Id));
            
            if (!mp.containsKey('success') || !mp.get('success')) {
                outVal += '::Exception while copying Opportunity Line Items::';
            }

            /* Add New Line Items
             * If Product and/or Service Line Items don't exist on the original,
             * Add them from the data sent by the client
             */
            if (mp.containsKey('hasProduct') && !mp.get('hasProduct')){
                //outVal += '::Copying Product Item:'+mp.get('hasProduct')+'::';
                /* Add Product Line Item */
                Integer piSize = o.getProductItemSize();
                List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
                for (Integer i=0;i<piSize;i++) {
                    Opty.ProductItem pi = o.getProductItem(i);
                    if (!pi.validateProduct(o.getCurrCode())) {
                        outVal +='::Product not inserted - invalid product::';
                    }
                    else { 
                        /* Opportunity Line Item */
                        try {
                            OpportunityLineItem oli = new OpportunityLineItem();
                            oli.OpportunityId = String.valueOf(op.Id);
                            oli.quantity = 1;
                            oli.PriceBookEntryId = pi.getPriceBkId();
                            oli.mix__c = pi.getMixPctDouble();
                            //oli.product_family_us__c = pi.getProdFamily();
                            oliList.add(oli);
                            //Insert oli;
                        }
                        catch (Exception e){outVal+= e.getMessage()+pi.getMixPct();}
                    }
                }
                try {
                  if (oliList.size() > 0) {
                        insert oliList;
                  }
                }
                catch (Exception e){outVal+= e.getMessage();}
            }

            /* Set flag to allow processing of line items.
             * This will calculate the price on the line item
             */
            MixPct.setProcessLineItems(true);

            if (mp.containsKey('hasService') && !mp.get('hasService')){
                //outVal += '::Copying Service Item:'+mp.get('hasService')+'::';
                /* Add Service Line Item */
                Integer siSize = o.getServiceItemSize();
                List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
                for (Integer i=0;i<siSize;i++) {
                    Opty.ServiceItem si = o.getServiceItem(i);
                    if (!si.validateService(o.getCurrCode())) {
                        outVal +='::Service not inserted - invalid service::';
                    }
                    else if(!si.validateLevel()) {
                        outVal +='::Service not inserted - invalid level::';
                    }
                    else { 
                        /* Opportunity Line Item */
                        try {
                            OpportunityLineItem oli = new OpportunityLineItem();
                            oli.OpportunityId = String.valueOf(op.Id);
                            oli.quantity = 1;
                            oli.PriceBookEntryId = si.getPriceBkId();
                            oli.mix__c = si.getMixPctDouble();
                            oli.service_level__c = si.getSvcLevel();
                            oliList.add(oli);
                            //Insert oli;
                        }
                        catch (Exception e){outVal+= e.getMessage()+si.getMixPct();}
                    }
                }
                try {
                  if (oliList.size() > 0) {
                        insert oliList;
                  }
                }
                catch (Exception e){outVal+= e.getMessage();}
            }

            /* Copy Resource Request and Assignments */
            if (!CSOptyUtils.copyResourceRequestAss(sfdcOptyID, String.valueOf(op.Id))) {
                outVal += '::Exception while copying Resource Requests and Assignments::';
            }

            /* Copy Resource Case Story: US7301 */
            /*if (!CSOptyUtils.copyResourceCase(sfdcOptyID, String.valueOf(op.Id))) {
                outVal += '::Exception while copying Resource Cases::';
            }  */


            /* Copy SalesTeam */
//            if (!copySalesTeam(sfdcOptyID, String.valueOf(op.Id))) {
//              outVal += '::Exception while copying SalesTeam::';
//            }

            /* Copy Contact Role */
            if (!CSOptyUtils.copyContactRole(sfdcOptyID, String.valueOf(op.Id))) {
                outVal += '::Exception while copying Opportunity Contact Role::';
            }

            /* Copy Event */
            if (!CSOptyUtils.copyEvent(sfdcOptyID, String.valueOf(op.Id))) {
                outVal += '::Exception while copying Event::';
            }

            /* Copy Task */
            if (!CSOptyUtils.copyTask(sfdcOptyID, String.valueOf(op.Id))) {
                outVal += '::Exception while copying Tasks::';
            }

            /* Copy Note */
            if (!CSOptyUtils.copyNote(sfdcOptyID, String.valueOf(op.Id))) {
                outVal += '::Exception while copying Notes::';
            }

            /* Copy Attachment */
            if (!CSOptyUtils.copyAttachments(sfdcOptyID, String.valueOf(op.Id))) {
                outVal += '::Exception while copying Attachments::';
            }

            /* Copy AT Workspace */
            if (!CSOptyUtils.copyATWorkspace(sfdcOptyID, String.valueOf(op.Id))) {
                outVal += '::Exception while copying AT Workspaces::';
            }

            /* Add Quote Header
             * - Assume Quote exists if Product Quote Amount
             * - or Service Quote Amount is greater than 0
             */
            if (o.getQuoteID() != '' && o.getIsDummyQuote() == 'N') {
                try {
                    outVal += addQuote(op.AccountId, op.Id, op.Name, o.getQuoteUpdatedBy(), o.getQuoteUpdatedDt(),ptnrID,o.getQuoteID(),o.getQuoteName(), o.getCBNStatus(),o.getPtnrStatus(),PrdQutAmtDec,SvcQutAmtDec,o.getExpireDate(),o.getIsFinalized(),decimal.valueOf(o.getQuoteProductNetPrice()),decimal.valueOf(o.getQuoteServiceNetPrice()),o.getIs_Collaborated());
                }
                catch (Opty.OptyException oe) {
                    outVal += '::'+oe.getMessage()+'::';
                }
            }
                       
            return Opty.outXML(dealID,String.valueOf(op.Id),'SUCCESS',hostOut,hostCamOut,hostCreated,agentOut,agentCamOut,agentCreated,outVal,om.outputXML());
        }
        /* Catch planned Exceptions */
        catch(Opty.OptyException oe) {
          /* Reset original opportunity name
           * - if the original opportunity was fetched, the name was updated, but the new opportunity was not created.
           */
          if (origOp.Name != null && op.Id == null && origOp.Name != origOpName) {
              origOp.Name = origOpName;
              Update origOp;
          }
            return Opty.outXML(dealID,String.valueOf(op.Id),'FAILURE',oe.getMessage());
        }
        /* Handle any unexpected Exceptions */
        catch (Exception e) {
          /* Reset original opportunity name
           * - if the original opportunity was fetched, the name was updated, but the new opportunity was not created.
           */
          if (origOp.Name != null && op.Id == null && origOp.Name != origOpName) {
              origOp.Name = origOpName;
              Update origOp;
          }
           return Opty.outXML(dealID,String.valueOf(op.Id),'FAILURE',e.getMessage());
        }
    }
    /* Method to update existing opportunities */
    WebService static String modify(String optyXML, String dealID) {
        Opportunity op = new Opportunity();
        try {
            String outVal = '';
            Double timeStamp = system.now().getTime();
            //Double ts1 = system.now().getTime();
            Datetime ts1 = system.now();
            Opty.OptyMetrics om = new Opty.OptyMetrics();
            //om.setTimestamp(timeStamp);
                    
            /*Parse Input and build Opty*/
            MyParser parser = new MyParser();
            Opty o = new Opty();
            o = parser.parseXML(optyXML);
            o.setDealId(dealID);
            timeStamp = doTiming(timeStamp,'ParseOpty');
            //om.addTiming('ParseOpty',timeStamp);

            /* 
             * Assume Deal ID is unique
             * - If the Deal ID is not found, there will be a QueryException
             */
            String rtId = o.getRecordType('Partner Parent Opportunity');
            String rtId2 = o.getRecordType('Parent Opportunity');
            string rtId3 = ObjectRecordTypeIds__c.getInstance().Opportunity_Global_RecordTypeId__c;
            //op = [select Id, AccountId, Name, StageName, CurrencyIsoCode, Primary_Partner__r.Name, Non_Standard_Terms_and_Conditions__c, Discount_Approval__c, Product_Enhancements__c, OwnerId from Opportunity where DealId__c=:dealID and RecordTypeId=:rtId Limit 1];
            //Allow the user to update either a Partner or Field generated parent opportunity
            op = [select Id, RecordTypeId, AccountId, Name, StageName, CurrencyIsoCode, Primary_Partner__r.Name, Non_Standard_Terms_and_Conditions__c, Discount_Approval__c, Product_Enhancements__c, OwnerId,Managed_Services__c, Opportunity_flags__c, Primary_partner__c,Deal_Type__c,Partner_Required__c from Opportunity where DealId__c=:dealID and (RecordTypeId=:rtId or RecordTypeId=:rtId2 or RecordTypeId =: rtId3) Limit 1];
            //op.OwnerId = o.getSFDCUserId();
            //op.Position__c = o.getFcstPostn();
            
            if (o.getPtnrStatus() != '') {
                op.Partner_Deal_Status__c = o.getPtnrStatus();              
            }
            if (o.getDiscType() != '') {
                op.Discount_Type__c = o.getDiscType();
            }
            if (o.getSsrEmailId() != '') {
                op.Next_Approver_Alias__c = o.getSsrEmailId();
            }
            if (o.getregion() != ''){ //GDM change for Global Opty
                op.Global_Opportunity__c = o.getregion();
            }
            //QCQ3 FY10 - only update if original is null
            if (o.getManagedSvc() != '' && op.Managed_Services__c == null) {
                op.Managed_Services__c = o.getManagedSvc();
            }

            //Q2FY10 - Update NS T&C
            if (o.getOrigNstcpe() != '') {
                op.Non_Standard_Terms_and_Conditions__c = o.getNstcpe();
            }
            if (o.getOrigDiscAprvl() != '') {
                op.Discount_Approval__c = o.getDiscAprvl();
            }
            if (o.getOrigProdEnh() != '') {
                op.Product_Enhancements__c = o.getProdEnh();
            }
            //FYQ16 SW1003 project DealType updation
            op.Deal_Type__c = o.getapprovalRoute();  //SW1003 changes Q1FY16 
            //Q2FY10 - Update DM Status
            if (o.getDMCode() != '') {
                op.DM_STATUS_CODE__c = o.getDMCode();
            }
            if (o.getDMDesc() != '') {
                op.DM_STATUS_DESCRIPTION__c = o.getDMDesc();
            }
            if (o.getCBNStatus() != '') {
                //op.CBN_Status__c = o.getCBNStatus();
                String CBNStatus = o.getCBNStatus();
                
            }
            if (o.getDealSource() != ''){
                op.Deal_Source__c = o.getDealSource();
            }
            /*
             * If a CAM (CEC ID) was sent from the client:
             * - look up the User record in SFDC
             */
            String camSFDCId = '';
            if (o.getCAMUserId() != '') {
                try {
                    camSFDCId = o.getSFDCUserId(o.getCAMUserId());
                }
                catch (Opty.OptyException oe) {
                    outVal += '::CAM '+ o.getCAMUserId() + ' is not a valid SFDC user::';
                }
            }
            /*
             * If the CAM passed in was a valid SFDC user and not on the Sales Team
             * - add to Sales Team 
             */
            if (camSFDCId != '' && camSFDCId != op.OwnerId) {
                try {
                    opportunityTeamMember ot = [Select o.UserId From OpportunityTeamMember o 
                    where o.OpportunityId=:op.Id and o.IsDeleted=false and o.UserId=:camSFDCId Limit 1];
                    outVal += '::CAM found - do nothing: '+ ot.UserId+'::';
                    }
                catch (QueryException qe) {
                    //CAM not on the Sales Team to Add him
                    Utilities.addStUser(String.valueOf(op.Id), camSFDCId, 'Read', 'Channel Account Manager', 'testme' );
                    outVal += '::CAM NOT found - adding: '+ camSFDCId+'::';
                }
                catch (Exception e) {
                    outVal += '::Unable to add CAM '+ o.getCAMUserId() + ' to Opportunity Sales Team:' + e.getMessage() + '::';
                }
            }

            
            /* ISP Changes */
            //outVal += ':::'+op.StageName +':'+o.getPtnrStatus()+':::';
            //If it is a Partner generated Deal, apply the Stage logic
            //Else, set Stage to the value passed in. 
            if (o.getOrigStageName() != '') {
                if (rtId == op.RecordTypeId) {
                    o.stageChangedFromPDR(op.StageName, o.getPtnrStatus());
                    op.StageName = o.getStageName();
                }
                else {
                  op.StageName = o.getStageName();
                }
            }
            
            /* Get conversion rate */
            Decimal currRate = getCurrConvRate(op.Id, op.CurrencyIsoCode);
            /* Commenting As both fields as moved to Quote Object, so Quering on Quote 
            //New Quote Update Info
            if (o.getPrdQutAmtDec() != null) {
                op.Product_Quote_Amount__c = currRate*o.getPrdQutAmtDec();
            }
            if (o.getSvcQutAmtDec() != null) {
                op.Service_Quote_Amount__c = currRate*o.getSvcQutAmtDec();
            }
            */
            // RNSD changes for Q1FY13 Release
            op.IS_FA_FLAG__c = o.getIs_FA_Flag();
            op.IS_AT_OR_BELOW_FLAG__c = o.getIs_At_Or_Below_Flag();
            //op.IS_COLLABORATED__c = o.getIs_Collaborated();
            
            Update op;

            timeStamp = doTiming(timeStamp,'UpdateOpty');
            om.addTiming('OptyEndToEnd',system.now(),ts1);
            /* Add Quote Header
             * - Assume Quote exists if Product Quote Amount
             * - or Service Quote Amount is greater than 0
             * - Do check to verify the quote is not already present
             */
            Quote__c qt = new Quote__c();
            try {
                qt = [select Id from Quote__c where Opportunity_Name__c=:op.Id and DM_Quote_ID__c =: o.getQuoteID() Limit 1];
                if (o.getQuoteID() != '' && o.getIsDummyQuote() == 'N') {
                    try {
                        qt.Quote_Last_Modified_By__c = o.getQuoteUpdatedBy();
                        qt.Quote_Last_Updated__c = o.getQuoteUpdatedDt();
                        qt.CBN_Status__c = o.getCBNStatus();
                        qt.CCW_Deal_Status_MQ__c = o.getPtnrStatus();
                        qt.Is_Finalized__c = o.getIsFinalized(); 
                        qt.Quote_Product_List_Amount__c = currRate*o.getPrdQutAmtDec();
                        qt.Quote_Service_List_Amount__c = currRate*o.getSvcQutAmtDec();
                        qt.Quote_Product_Net_Amount__c = decimal.valueOf(o.getQuoteProductNetPrice());
                        qt.Quote_Service_Net_Amount__c = decimal.valueOf(o.getQuoteServiceNetPrice());
                        // Q1FY13 changes for RNSD 
                        qt.Is_Collaborated__c = o.getIs_Collaborated();
                        if (o.getIsFinalized() == 'Y'){
                        qt.Quote_Status__c = 'Finalized';
                        }
                        update qt;  
                  }
                      
                  catch (Exception e) {
                    outVal += '::Unable to update Quote Header!::';
                  }
                }
               // If quote is Finalized by end user then make all the quotes on that opty as 'FINALIZED' 
               if(o.getIsFinalized() == 'Y'){
               Opportunity opty= new Opportunity();
               List<Quote__c> q1 = new List<Quote__c>();
               q1 = [select Id from Quote__c where Opportunity_Name__c=:op.Id];
               for(Quote__c q : q1)
                {                 
                   q.Is_Finalized__c = 'Y';
                }
                update q1;
            }
            
            updateIsFinalized((String)op.id);
            }
            catch (QueryException qe) {
                //Quote is not present, so create it
                if (o.getQuoteID() != '' && o.getIsDummyQuote() == 'N') {
                  try { 
                        if(op.Recordtypeid == o.getRecordType('Partner Parent Opportunity') ){
                        outVal += addQuote(op.AccountId, op.Id, op.Name, o.getQuoteUpdatedBy(), o.getQuoteUpdatedDt(),op.Primary_partner__c,o.getQuoteID(),o.getQuoteName(), o.getCBNStatus(),o.getPtnrStatus(),o.getPrdQutAmtDec(),o.getSvcQutAmtDec(),o.getExpireDate(),o.getIsFinalized(),decimal.valueOf(o.getQuoteProductNetPrice()),decimal.valueOf(o.getQuoteServiceNetPrice()),o.getIs_Collaborated());
                        }
                        else
                        outVal += addQuote(op.AccountId, op.Id, op.Name, o.getQuoteUpdatedBy(), o.getQuoteUpdatedDt(),op.Primary_partner__c,o.getQuoteID(),o.getQuoteName(), o.getCBNStatus(),o.getPtnrStatus(),o.getPrdQutAmtDec(),o.getSvcQutAmtDec(),o.getExpireDate(),o.getIsFinalized(),decimal.valueOf(o.getQuoteProductNetPrice()),decimal.valueOf(o.getQuoteServiceNetPrice()),o.getIs_Collaborated());
                    
                    }
                    catch (Opty.OptyException oe) {
                        outVal += '::'+oe.getMessage()+'::';
                    }
                }
            }
                            
            return Opty.outXML(dealID,String.valueOf(op.Id),'SUCCESS',outVal,om.outputXML());
        }
        /* Catch planned Exceptions */
        catch (Opty.OptyException oe) {
            return Opty.outXML(dealID,String.valueOf(op.Id),'FAILURE',oe.getMessage());
        }
        catch (QueryException qe) {
            return Opty.outXML(dealID,String.valueOf(op.Id),'FAILURE','SFDC-17: Opportunity does not exist for Deal ID: '+dealID);
        }
        /* Handle any unexpected Exceptions */
        catch (Exception e) {
            if(StatusCode.UNABLE_TO_LOCK_ROW == e.getDmlType(0)) {
              return Opty.outXML(dealID,String.valueOf(op.Id),'FAILURE','SFDC-21: This opportunity is locked for processing by another user');
            }
            return Opty.outXML(dealID,String.valueOf(op.Id),'FAILURE',e.getMessage());
        }
    }
    // Method to delete Quote from an Opty on the basis of Quote Id and Deal Id passed by CCW
   WebService static String deleteQuote(String DealID, String QuoteId)
   {
   try{
   //Query on Quote Object to delete the expected quote
       Quote__c qt = [select Id,CreatedById,CreatedDate,Quote_Last_Updated__c,Quote_Last_Modified_By__c,Name,DM_Quote_ID__c,Account_Name__c,Opportunity_Name__c,PartnerAcctId__c,CBN_Status__c,CCW_Deal_Status_MQ__c from Quote__c where Deal_ID__c=:DealID and DM_Quote_ID__c =: QuoteID Limit 1];                                
           
           Quote__c dummyQ = new Quote__c();
           // SCAVA FIX , Oct 16 2018
           if(flsGet(Quote__c.Old_Deal_ID__c)){
           }
           dummyQ.Old_Deal_ID__c = DealID;
           // SCAVA FIX , Oct 16 2018
           if(flsGet(Quote__c.Old_Partner_Account_ID__c)){
           dummyQ.Old_Partner_Account_ID__c = qt.PartnerAcctId__c;
           }
           // SCAVA Fix
                if(flsGet(Quote__c.CBN_Status__c))
               {
                dummyQ.CBN_Status__c = qt.CBN_Status__c;
               }
               if(flsGet(Quote__c.CCW_Deal_Status_MQ__c))
               {
                dummyQ.CCW_Deal_Status_MQ__c = qt.CCW_Deal_Status_MQ__c;
               }
               if(flsGet(Quote__c.Opportunity_Name__c))
               {
                dummyQ.Opportunity_Name__c = Utilities.getConstant_CS('QuoteDeleteDummyOppty');
                }
                //SCAVA FIX , Oct16th 2018
                if(flsGet(Quote__c.DM_Quote_ID__c)){
                dummyQ.DM_Quote_ID__c = qt.DM_Quote_ID__c;
                }
                if(flsGet(Quote__c.Name))
               {
                dummyQ.Name = qt.Name;
               }
               //SCAVA FIX
               if(flsGet(Quote__c.CreatedById))
               {
                dummyQ.CreatedById = qt.CreatedById;
                }
                if(flsGet(Quote__c.CreatedDate))
               {
                dummyQ.CreatedDate = qt.CreatedDate;
               }
               if(flsGet(Quote__c.Quote_Last_Modified_By__c))
               {
                dummyQ.Quote_Last_Modified_By__c = qt.Quote_Last_Modified_By__c;
               }
               if(flsGet(Quote__c.Quote_Last_Updated__c))
               {
                dummyQ.Quote_Last_Updated__c = qt.Quote_Last_Updated__c;
               }
           Insert dummyQ;
           // SCAVA FIX
           if (Quote__c.sObjectType.getDescribe().isDeletable())
               {
                Delete qt;
               }
            
   
   //Query on Partner Contact Object to delete the expected Quote
       Partner_Contact_Oppty_Mapping__c pc = [select Id,Name,Quote_ID__c from Partner_Contact_Oppty_Mapping__c where Quote_ID__c=: QuoteID Limit 1 ];
       
            Partner_Contact_Oppty_Mapping__c dummyP = new Partner_Contact_Oppty_Mapping__c();
            if(flsGet(Partner_Contact_Oppty_Mapping__c.Name))
            {
            dummyP.Name = pc.Name;
            }
            if(flsGet(Partner_Contact_Oppty_Mapping__c.Opportunity__c))
            {
            dummyP.Opportunity__c = Utilities.getConstant_CS('QuoteDeleteDummyOppty');
            }
            // SCAVA FIX , Oct16th 2018
            if(flsGet(Partner_Contact_Oppty_Mapping__c.Quote_ID__c)){
            dummyP.Quote_ID__c = pc.Quote_ID__c;
            }
            Insert dummyP;
               // SCAVA FIX
               if (Partner_Contact_Oppty_Mapping__c.sObjectType.getDescribe().isDeletable())
                   {
                Delete pc;
               }
           return '::SUCCESS- QUOTE DELETED::';
       }
        catch (Exception e) {
           return '::Unable to Delete Quote!::'+e.getMessage();
           //return '####:'+e.getMessage();
           
       }
    }
    
    // Method for One time update on lead object when deal is created for that lead in ccw application
    WebService static String oneTimeLeadUpdate(String LeadID, String DealId)
   {
   try{
   //Query on Lead Object to update the deal id on lead record
       Lead ld = [select Id,Name,Deal_ID__c, Partner_Lead_Status__c from lead where Id =: LeadID Limit 1];
       //SCAVA FIX , Oct 16th 2018
       if(flsUpdate(Lead.Deal_ID__c)){
           ld.Deal_ID__c = DealId;
           }
           if(flsUpdate(Lead.Partner_Lead_Status__c))
           {
           ld.Partner_Lead_Status__c = 'Deal Created';
           }
           update ld;
           return '::Lead has been updated::';
     }
    catch (Exception e) {
           return '::Unable to Update the Lead!::'+e.getMessage();
           //return '####:'+e.getMessage();
           } 
    }
    
    
    
    //simon update
    
    // Method to update fields on lead on which deal is created, this will be triggerd only when deal status changes in CCW
        WebService static String upsertMultiObjectQuote(String optyXML, String sfdc_id, String sfdc_object_type)
    {
    try{
        //Query on Lead Object to update the deal id on lead record
           
        /* Parse Input and build Opty */
        MyParser parser = new MyParser();
        Opty o = new Opty();
        o = parser.parseXML(optyXML);
        
        if(o.getdealId()==null || o.getdealId() == ''){
            return '::Error, Deal ID not found:: value="'+o.getdealId()+'"';
        }

        //this query will return 1 record for quote update, multiple records for deal update, 0 records for creation
        String quote_id = o.getQuoteID().trim()+'%';
//        List<Multi_Object_Quote__c> moqs = [SELECT id, name, Deal_ID__c, DM_Quote_ID__c FROM Multi_Object_Quote__c WHERE Deal_ID__c = :o.getdealId() AND DM_Quote_ID__c like :quote_id];
        List<Multi_Object_Quote__c> moqs = [SELECT id, name, Deal_ID__c, DM_Quote_ID__c FROM Multi_Object_Quote__c WHERE Deal_ID__c = :o.getdealId()];
        
        //no moq's in list, must be a create scenario;
        if(moqs.size() == 0)
        {
            //create one multiquote for each quote in this deal
            List<Quote__c> quotes = [SELECT id, name, Deal_ID__c, DM_Quote_ID__c FROM Quote__c WHERE Deal_ID__c = :o.getdealId() AND DM_Quote_ID__c like :quote_id];
            if(quotes.size() >0){
                for(Quote__c q : quotes){
                    Multi_Object_Quote__c moq = new Multi_Object_Quote__c();
                    // SCAVA FIX
                    if(flsGet(Multi_Object_Quote__c.Quote__c)||flsUpdate(Multi_Object_Quote__c.Quote__c))
                    {
                    moq.Quote__c = q.id;
                    }
                    moqs.add(moq);
                }
            }
            else{
                Multi_Object_Quote__c moq = new Multi_Object_Quote__c();
                moqs.add(moq);
            }
        }
           
        for(Multi_Object_Quote__c moq : moqs){
            moq.Account_Name__c = o.getSfdcAcctId();            
            moq.deal_Id__c = o.getdealId();
            //moq.Name = o.getQuoteName();
            moq.Name = o.getOptyName_Lead();
            moq.DM_Quote_ID__c = o.getQuoteID();
            //Opportunity>OpportunityHeader>SalesLeadReference>UserArea>SFDCLeadDetails> OptyName
            moq.Deal_Name__c = o.getOptyName_Lead();
    
            
            moq.Promotion_Name__c = o.getPromotionName_Lead();
            moq.Program_Name__c = o.getProgramName_Lead();
            moq.Discount_Type__c = o.getDiscountType_Lead();
            
//            moq.Deal_Create_Date_Time__c = o.getDealCreateDate_Lead();
//            date d = Date.newInstance(moq.Deal_Create_Date_Time__c.year(),moq.Deal_Create_Date_Time__c.month(),moq.Deal_Create_Date_Time__c.day());
            String d2 = String.ValueOf(o.getDealCreateDate_Lead());
            date mydate;
            if(d2 != null){
                d2 = d2.left(10);
                String[] date2 = d2.split('-',3);
                mydate = date.newinstance(Integer.valueof(date2[0]),Integer.valueof(date2[1]),Integer.valueof(date2[2]));
            }
            else{
                mydate = null;
            }
            moq.Deal_Create_Date__c = mydate;
            
            moq.CBN_Status__c = o.getCBNStatus(); //not sent for lead
         
            moq.CCW_Deal_Status__c = o.getDealStatus_Lead();
            moq.Quote_Status__c = o.getDealStatus_Lead();
            moq.Deal_Status__c = o.getDealDeskStatus_Lead();
  
            moq.Deal_Expiration_Date__c = o.getDealExpirationDate_Lead();
               
            moq.Is_Finalized__c = o.getIsFinalized();
            moq.Eligible_for_NS__c = o.getEligibleForNS_Lead();            
            
/*              
            String currencyCode = (o.getCurrCode()== null? 'USD' : o.getCurrCode());    
            Decimal currRate = getCurrConvRate(moq.id, currencyCode);
*/
            //Decimal PrdQutAmtDec = currRate*o.getPrdQutAmtDec();
            //Decimal SvcQutAmtDec  = currRate* o.getSvcQutAmtDec();
                        
            try{
                moq.Quote_Product_Net_Price__c = Decimal.valueOf((o.getQuoteProductNetPrice()==null? '0.0': o.getQuoteProductNetPrice()).trim());
                moq.Quote_Service_Net_Price__c = Decimal.valueOf((o.getQuoteServiceNetPrice()==null? '0.0': o.getQuoteServiceNetPrice()).trim());
                moq.Expected_Product_List_Amount__c = Decimal.valueOf((o.getExpectedProductListAmount_Lead()==null? '0.0': o.getExpectedProductListAmount_Lead()).trim());
                moq.Expected_Service_List_Amount__c = Decimal.valueOf((o.getExpectedServiceListAmount_Lead()==null? '0.0': o.getExpectedServiceListAmount_Lead()).trim());
                moq.Quote_Product_List_Amount__c = Decimal.valueOf((o.getQuoteProductListPrice().iswhitespace()? '0.0': o.getQuoteProductListPrice()).trim());
                moq.Quote_Service_List_Amount__c = Decimal.valueOf((o.getQuoteServiceListPrice().iswhitespace()? '0.0': o.getQuoteServiceListPrice()).trim());
            }catch(TypeException te){
            }
    
            moq.Quote_Last_Modified_By__c = o.getQuoteUpdatedBy();
            /*
            moq.Quote_Last_Updated__c = o.getQuoteUpdatedDt();
            */
            
            //set the opty id to the searched deal_id: for each moq being updated or created
            List<Opportunity> optys = [SELECT id, DealID__c FROM Opportunity WHERE DealID__c =  :o.getdealId()];
            if(optys.size() == 1){
                moq.Opportunity_Name__c = optys.get(0).id;
            }
            
         
            if(sfdc_object_type != null && sfdc_object_type != ''){
                if(sfdc_object_type == 'Case')
                {
                    //set the case id to the searched sfdc_id: for each moq being updated or created
                    List<Case> cases = [SELECT id, owner.id FROM Case WHERE id = :sfdc_id];
                    if(cases.size() == 1){
                        moq.Case__c = cases.get(0).id;
                        /*
                        Multi_Object_Quote__Share moqshare = new Multi_Object_Quote__Share();
                        moqshare.AccessLevel = 'Read';
                        moqshare.ParentId = moq.id;
                        moqshare.UserOrGroupId = cases.get(0).owner.id;
                        moqshares.add(moqshare);
                        */
                    }
                    
                }
                else if(sfdc_object_type == 'Lead')
                {
                    //set the lead id to the searched sfdc_id: for each moq being updated or created
                    List<Lead> leads = [SELECT id, owner.id FROM Lead WHERE id = :sfdc_id];
                    if(leads.size() == 1){
                        Lead theLead = leads.get(0); 
                        moq.Lead__c = theLead.id;
                        if(flsUpdate(Lead.Quote_Product_Net_Price__c))
                        {
                        theLead.Quote_Product_Net_Price__c = moq.Quote_Product_Net_Price__c;
                        }
                        if(flsUpdate(Lead.Quote_Service_Net_Price__c))
                        {
                        theLead.Quote_Service_Net_Price__c = moq.Quote_Service_Net_Price__c;
                        }
                        if(flsUpdate(Lead.Partner_Deal_Status__c))
                        {
                        theLead.Partner_Deal_Status__c = moq.Quote_Status__c;
                        }
                        if(flsUpdate(Lead.Eligible_NS__c))
                        {
                        theLead.Eligible_NS__c = moq.Eligible_for_NS__c;
                        }
                        if(flsUpdate(Lead.Expected_Product_List_Amount__c))
                        {
                        theLead.Expected_Product_List_Amount__c = moq.Expected_Product_List_Amount__c;
                        }
                        if(flsUpdate(Lead.Expected_Service_List_Amount__c))
                        {
                        theLead.Expected_Service_List_Amount__c = moq.Expected_Service_List_Amount__c;
                        }
                        if(flsUpdate(Lead.Deal_Expiration_Date__c))
                        {
                        theLead.Deal_Expiration_Date__c = moq.Deal_Expiration_Date__c;
                        }
                        //theLead.Deal_Create_Date_Time__c = moq.Deal_Create_Date_Time__c;
                        //Date d = Date.newInstance(moq.Deal_Create_Date_Time__c.year(),moq.Deal_Create_Date_Time__c.month(),moq.Deal_Create_Date_Time__c.day());
                        if(flsUpdate(Lead.Deal_Create_Date__c))
                        {
                        theLead.Deal_Create_Date__c = moq.Deal_Create_Date__c;
                        }
                        if(flsUpdate(Lead.Promotion_Name__c))
                        {
                        theLead.Promotion_Name__c = moq.Promotion_Name__c;
                        }
                        if(flsUpdate(Lead.Program_Name__c))
                        {
                        theLead.Program_Name__c = moq.Program_Name__c;
                        }
                        if(flsUpdate(Lead.Discount_Type__c))
                        {
                        theLead.Discount_Type__c = moq.Discount_Type__c;
                        }
                        update theLead;
                    }
                }
                else if(sfdc_object_type == 'Assigned_Partner__c')
                {
                    //set the tp id to the searched sfdc_id: for each moq being updated or created
                    List<Assigned_Partner__c> tps = [SELECT id, owner.id FROM Assigned_Partner__c WHERE id = :sfdc_id];
                    if(tps.size() == 1){
                        Assigned_Partner__c theTP = tps.get(0); 
                        moq.Target_Prospect__c = theTP.id;
                        //theTP.Eligible_NS__c = moq.Eligible_for_NS__c;
                        //theTP.Expected_Product_List_Amount__c = moq.Expected_Product_List_Amount__c;
                        //theTP.Expected_Service_List_Amount__c = moq.Expected_Service_List_Amount__c;
                        //theTP.Deal_Expiration_Date__c = moq.Deal_Expiration_Date__c;
                        //theTP.Deal_Create_Date_Time__c = moq.Deal_Create_Date_Time__c;
                        //theTP.Promotion_Name__c = moq.Promotion_Name__c;
                        //theTP.Program_Name__c = moq.Program_Name__c;
                        //theTP.Discount_Type__c = moq.Discount_Type__c;
                        //update theTP;
                    }
                }
                //set the oppty id to the searched sfdc_id: for each moq being updated or created
                else if(sfdc_object_type == 'Opportunity')
                {
                    optys = [SELECT id, owner.id FROM Opportunity WHERE id = :sfdc_id];
                    if(optys.size() == 1){
                        moq.Opportunity_Name__c = optys.get(0).id;
                        /*
                        Multi_Object_Quote__Share moqshare = new Multi_Object_Quote__Share();
                        moqshare.AccessLevel = 'Read';
                        moqshare.ParentId = moq.id;
                        moqshare.UserOrGroupId = optys.get(0).owner.id;
                        moqshares.add(moqshare);
                        */
                    }
                }
                else
                {
                    return '::Error, did not understand sfdc_object_type. Expecting "Case", "Lead", "Assigned_Partner__c" or "Opportunity"::';
                }
            }

        }
        upsert moqs;
        updateMOQVisibility(moqs, sfdc_id, sfdc_object_type);
        return '::Multi_Object_Quote has been updated::';
     }
    catch (Exception e) {
        return '::Unable to Update the Multi_Object_Quote!::'+e.getMessage()+' '+e.getStackTraceString()+' '+e.getLineNumber();
        //return '####:'+e.getMessage();
    } 
    }

    private static void updateMOQVisibility(list<Multi_Object_Quote__c> moqs, String sfdc_id, String sfdc_object_type)
    {
        List<Multi_Object_Quote__Share> moqshares = new List<Multi_Object_Quote__Share>();
        for(Multi_Object_Quote__c moq : moqs)
        {
            if(sfdc_object_type != null && sfdc_object_type != '')
            {
                if(sfdc_object_type == 'Lead')
                {
                    //set the lead id to the searched sfdc_id: for each moq being updated or created
                    List<Lead> leads = [SELECT id, owner.id FROM Lead WHERE id = :sfdc_id];
                    if(leads.size() == 1){
                        Lead theLead = leads.get(0);
                        Multi_Object_Quote__Share moqshare = new Multi_Object_Quote__Share();
                        moqshare.AccessLevel = 'Read';
                        moqshare.ParentId = moq.id;
                        moqshare.UserOrGroupId = theLead.owner.id;
                        moqshares.add(moqshare);
                    }
                }
                else if(sfdc_object_type == 'Assigned_Partner__c')
                {
                    //set the tp id to the searched sfdc_id: for each moq being updated or created
                    List<Assigned_Partner__c> tps = [SELECT id, owner.id FROM Assigned_Partner__c WHERE id = :sfdc_id];
                    if(tps.size() == 1){
                        Assigned_Partner__c theTP = tps.get(0); 
                        Multi_Object_Quote__Share moqshare = new Multi_Object_Quote__Share();
                        moqshare.AccessLevel = 'Read';
                        moqshare.ParentId = moq.id;
                        moqshare.UserOrGroupId = theTP.owner.id;
                        moqshares.add(moqshare);
                    }
                }             
            }     
        }
        upsert moqshares;
    }
    
    // Method to update fields on lead on which deal is created, this will be triggerd only when deal status changes in CCW
    WebService static String UpdateLeadData(String optyXML)
    {
   try{
   //Query on Lead Object to update the deal id on lead record
   
        /* Parse Input and build Opty */
            MyParser parser = new MyParser();
            Opty o = new Opty();
            o = parser.parseXML(optyXML);
       Lead l = [select Id,Name,Deal_ID__c, Partner_Lead_Status__c from lead where Id =: o.getLeadId() Limit 1];
                if(flsUpdate(Lead.Partner_Deal_Status__c))
                    {
                    l.Partner_Deal_Status__c = o.getDealStatus_Lead();
                    }
                    if(flsUpdate(Lead.Promotion_Name__c))
                    {
                    l.Promotion_Name__c = o.getPromotionName_Lead();
                    }
                    if(flsUpdate(Lead.Program_Name__c))
                    {
                    l.Program_Name__c = o.getProgramName_Lead();
                    }
                    if(flsUpdate(Lead.Discount_Type__c))
                    {
                    l.Discount_Type__c = o.getDiscountType_Lead();
                    }
                    if(flsUpdate(Lead.Deal_Create_Date__c))
                    {
                    l.Deal_Create_Date__c = o.getDealCreateDate_Lead();
                    }
           if(string.isNotBlank(o.getExpectedServiceListAmount_Lead()))
                    if(flsUpdate(Lead.Expected_Service_List_Amount__c))
                    {
                    l.Expected_Service_List_Amount__c = decimal.valueOf(o.getExpectedServiceListAmount_Lead());
                    }
                    if(flsUpdate(Lead.Eligible_NS__c))
                    {
                    l.Eligible_NS__c = o.getEligibleForNS_Lead();
                    }
                    if(flsUpdate(Lead.Deal_Expiration_Date__c))
                    {
                    l.Deal_Expiration_Date__c = o.getDealExpirationDate_Lead();
                    }
           if(string.isNotBlank(o.getExpectedProductListAmount_Lead()))
                    if(flsUpdate(Lead.Expected_Product_List_Amount__c))
                    {
                    l.Expected_Product_List_Amount__c = decimal.valueOf(o.getExpectedProductListAmount_Lead());
                    }
           if(string.isNotBlank(o.getQuoteProductNetPrice()))
                    if(flsUpdate(Lead.Quote_Product_Net_Price__c))
                    {
                    l.Quote_Product_Net_Price__c = decimal.valueOf(o.getQuoteProductNetPrice());
                    }
           if(string.isNotBlank(o.getQuoteServiceNetPrice()))
                    if(flsUpdate(Lead.Quote_Service_Net_Price__c))
                    {
                    l.Quote_Service_Net_Price__c = decimal.valueOf(o.getQuoteServiceNetPrice());
                    }
           update l;
           return '::Lead has been updated::';
     }
    catch (Exception e) {
           return '::Unable to Update the Lead!::'+e.getMessage();
           //return '####:'+e.getMessage();
           } 
    }
    // Method for making IsFinalized field as Y, if all the quote on a Opportunity are in 'Not Submitted' status
   // Public static String updateIsFinalized(String dealID) {
     Public static void updateIsFinalized(String optyID) {
            Opportunity opty= new Opportunity();
               List<Quote__c> q1 = new List<Quote__c>();
               q1 = [select Id, CCW_Deal_Status_MQ__c from Quote__c where Opportunity_Name__c =:optyId];
               Boolean chkval = false;
               for(Quote__c q : q1)
                {                 
                   if(q.CCW_Deal_Status_MQ__c == 'Not Submitted') 
                   chkval = true;
                   else
                   chkval = false;
                }
                if(chkval == true)
                {
                    for(Quote__c q : q1)
                    {
                        q.is_finalized__c = 'Y';
                    }
                    update q1;
                 } 
                          
    }
    /* Method to update existing opportunities */
    WebService static String modifySOM(String optyXML, String dealID) {
        Opportunity op = new Opportunity();
        try {
            String outVal = '';
            Double timeStamp = system.now().getTime();
            Datetime ts1 = system.now();
            Opty.OptyMetrics om = new Opty.OptyMetrics();
                    
            /*Parse Input and build Opty*/
            MyParser parser = new MyParser();
            Opty o = new Opty();
            o = parser.parseXML(optyXML);
            o.setDealId(dealID);
            timeStamp = doTiming(timeStamp,'ParseOpty');

            /* 
             * Assume Deal ID is unique
             * - If the Deal ID is not found, there will be a QueryException
             */
            String rtId2 = o.getRecordType('Parent Opportunity');
            string rtId3 = ObjectRecordTypeIds__c.getInstance().Opportunity_Global_RecordTypeId__c;
            op = [select Id, RecordTypeId, AccountId, Name, Forecast_status__c, CurrencyIsoCode, OwnerId from Opportunity where DealId__c=:dealID and (RecordTypeId=:rtId2 or RecordTypeId=:rtId3) Limit 1];
            
            /* Set opportunity values */
            try {
                String oName = o.getName();
                if (oName != '') {
                    if(flsUpdate(Opportunity.Name)) // SCAVA FIX
                    {
                  op.Name = oName;
                    }
                }
             }
             catch (Exception e) {
             //do nothing - Name has not changed so exception is thrown...
           }
            if (!o.isExpDateNull()) {
                // SCAVA FIX
                if(flsUpdate(Opportunity.CloseDate)) 
                    {               
                op.CloseDate = o.getExpDate();
                    }
            }
            if (o.getContractNo() != '') {
                if(flsUpdate(Opportunity.Contract_Number__c)) // SCAVA FIX
                    {
                op.Contract_Number__c = o.getContractNo();
                    }
            }
            if (!o.isStartDateNull()) {
                if(flsUpdate(Opportunity.Start_Date__c)) // SCAVA FIX
                    {
                op.Start_Date__c = o.getStartDate();
                    }
            }
            if (!o.isEndDateNull()) {
                if(flsUpdate(Opportunity.End_Date__c)) // SCAVA FIX
                    {
                op.End_Date__c = o.getEndDate();
                    }
            }
            if (o.getReasonCode() != '') {
                
                if(flsUpdate(Opportunity.Reason_Code__c)) // SCAVA FIX
                    {
                        op.Reason_Code__c = o.getReasonCode();
                    }
            }
            if (o.getSsrEmailId() != '') {
            // SCAVA FIX , Oct16th 2018
            if(flsUpdate(Opportunity.SSR_Email_Id__c)){
                op.SSR_Email_Id__c = o.getSsrEmailId();
                }
            }
            if (o.getSvcSource() != '') {
                if(flsUpdate(Opportunity.Service_Source__c)) // SCAVA FIX
                    {
                op.Service_Source__c = o.getSvcSource();
                    }
            }
            if (o.getOrigStageName() != '') {
              //Validate Stage Name and Forecast Status combination.
              //OptyException is thrown if invalid.
              o.somStageValidation(op.Forecast_status__c, o.getStageName());
              if(flsUpdate(Opportunity.StageName)) // SCAVA FIX
                    {
              op.StageName = o.getStageName();
                    }
            }
                        
            /* Get conversion rate */
            Decimal currRate = getCurrConvRate(op.Id, op.CurrencyIsoCode);

            /* New Quote Update Info */
            if (o.getSvcQutAmtDec() != null) {
                if(flsUpdate(Opportunity.Expected_Service__c))  // SCAVA FIX
                    {
                op.Expected_Service__c = currRate*o.getExpSvcRevDec();
                    }
            }
            
            Update op;

            /* Update Note
             * If created by cisco_forecast_user@cisco.com.ENV
             */
             if (o.getOMFNotes() != null && o.getOMFNotes() != '') {
                try {
                  Note n = [Select n.Id, n.Body From Note n where n.ParentId =:op.Id and n.CreatedBy.Username like 'cisco_forecast_user%' limit 1];
                   if(flsUpdate(Note.Body)) // SCAVA FIX
                    {
                  n.Body = o.getOMFNotes();
                    }
                  Update n;
                }
                catch (QueryException qe) {
                  //No existing note, so create it.
                   if (!CSOptyUtils.createNote('Opportunity Contract Details',String.ValueOf(op.Id),o.getOMFNotes())) {
                     outVal += '::Failed to create SOM Note::';
                   }
                }
             }
             
            timeStamp = doTiming(timeStamp,'UpdateOpty');
            om.addTiming('OptyEndToEnd',system.now(),ts1);
                            
            return Opty.outXML(dealID,String.valueOf(op.Id),'SUCCESS',outVal,om.outputXML());
        }
        /* Catch planned Exceptions */
        catch (Opty.OptyException oe) {
            return Opty.outXML(dealID,String.valueOf(op.Id),'FAILURE',oe.getMessage());
        }
        catch (QueryException qe) {
            return Opty.outXML(dealID,String.valueOf(op.Id),'FAILURE','SFDC-17: Opportunity does not exist for Deal ID: '+dealID);
        }
        /* Handle any unexpected Exceptions */
        catch (Exception e) {
            if(StatusCode.UNABLE_TO_LOCK_ROW == e.getDmlType(0)) {
              return Opty.outXML(dealID,String.valueOf(op.Id),'FAILURE','SFDC-21: This opportunity is locked for processing by another user');
            }
            return Opty.outXML(dealID,String.valueOf(op.Id),'FAILURE',e.getMessage());
        }
    }
    /* Method to perform Service validations */
    WebService static String serviceCheck(String sfdcOptyID) {
        return '<output><isService>true</isService><details></details><errorMsg></errorMsg></output>';
    }

    Public static Decimal getCurrConvRate(String origSFDCId, String currCode) {
        CurrencyType ct;
        try {
            ct = [Select ConversionRate, Id, IsoCode from CurrencyType where IsoCode=:currCode limit 1];
        }
        catch (Exception e) {
            throw new Opty.OptyException('SFDC-19: Merge failure - unable to fetch Currency Conversion Rate for original opportunity:'+origSFDCId);
        }
        return ct.ConversionRate;
    }
    Public static Map<String, boolean> copyLineItems(String origOptyId, String newOptyId) {
        Map<String, boolean> m = new Map<String, boolean>();
        m.put('hasProduct',false); 
        m.put('hasService',false);
        m.put('success',false);

        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();

        /* Set flag to allow processing of line items.
         * This will calculate the price on the line item
         */
        MixPct.setProcessLineItems(true);
        try {
            OpportunityLineItem[] oliArr = [Select Id, OpportunityId, PricebookEntryId, PriceBookEntry.ProductCode,
            CurrencyIsoCode, Quantity, Mix__c, Service_Level__c, Product_Family_US__c, Service_Level_Ref__c FROM OpportunityLineItem where OpportunityId=:origOptyId];
           
            for (OpportunityLineItem oli : oliArr) {
                OpportunityLineItem oliNew = new OpportunityLineItem(); 
                oliNew = oli.clone(false);
                //SCAVA FIX, Oct16th 2018
                if(flsGet(OpportunityLineItem.OpportunityId)){
                oliNew.OpportunityId = String.valueOf(newOptyId);
                }
                //Insert oliNew;
                oliList.add(oliNew);
                if (oli.PriceBookEntry.ProductCode == 'Technology') {
                    m.put('hasProduct',true);
                }
                else if (oli.PriceBookEntry.ProductCode == 'Service') {
                    m.put('hasService',true);
                }
            }
             if (oliList.size() > 0) {
                insert oliList;
            }
        }
        catch (QueryException qe) {
           //No OLI - do nothing.
        }
        catch (Exception e) {
           m.put('success',false);
        }
        m.put('success',true);
        return m;      
    }

    /* Helper method to write debug timings */
    Public static Double doTiming(Double st, String action) {
        Double et = system.now().getTime();
        return et;      
    }
    /* Helper method */
    Public static String nvl(String strVal) {
        if (strVal == null) {
            strVal = '';
        }
        return strVal;      
    }
    /* Helper method to create Quote Header */
    Public static String addQuote(String accountID, String optyID, String optyName, String lastUpdatedBy, Datetime lastUpdatedDt, String partnerID, String quoteID, String quoteName, String CBNStatus, String CCWStatus, Decimal PrdQutAmtDec, Decimal SvcQutAmtDec, Date QuoteExpirationDate, String IsFinalized, Decimal QuoteProductNetPrice, Decimal QuoteServiceNetPrice, String IsCollaborated) {
        try {
            Quote__c qt = new Quote__c();
            // SCAVA FIX
                if(flsGet(Quote__c.Account_Name__c))
               {
                qt.Account_Name__c = accountID;
               }
               if(flsGet(Quote__c.Opportunity_Name__c))
               {
                qt.Opportunity_Name__c = optyID;
               }
               if(flsGet(Quote__c.Quote_Last_Modified_By__c))
               {
                qt.Quote_Last_Modified_By__c = lastUpdatedBy;
               }
               if(flsGet(Quote__c.Quote_Last_Updated__c))
               {
                qt.Quote_Last_Updated__c = lastUpdatedDt;
               }
            if (optyName.length() > 74) {
                optyName = optyName.substring(0,73);
            }
            if(flsGet(Quote__c.Name))
               {
                qt.Name = quoteName;
               }
              
            if (partnerID != '' && partnerID != 'FALSE' && partnerID != 'CAM_INACTIVE') {
            //SCVAA FIX ,Oct16th 2018
             if(flsGet(Quote__c.PartnerAcctId__c)){
              qt.PartnerAcctId__c = partnerID;
              }
            }
            //SCAVA FIX, Oct16th 2018
            if(flsGet(Quote__c.CBN_Status__c)){
            qt.DM_Quote_ID__c = quoteID;
            }
            // SCAVA FIX
                if(flsGet(Quote__c.CBN_Status__c))
               {
                qt.CBN_Status__c = CBNStatus;
               }
               if(flsGet(Quote__c.CCW_Deal_Status_MQ__c))
               {
                qt.CCW_Deal_Status_MQ__c = CCWStatus;
               }
               if(flsGet(Quote__c.Quote_Product_List_Amount__c))
               {
                qt.Quote_Product_List_Amount__c = PrdQutAmtDec;
               }
               if(flsGet(Quote__c.Quote_Service_List_Amount__c))
               {
                qt.Quote_Service_List_Amount__c = SvcQutAmtDec;
               }
               if(flsGet(Quote__c.Expiration_Date__c))
               {
                qt.Expiration_Date__c = QuoteExpirationDate;
               }
               if(flsGet(Quote__c.Is_Finalized__c))
               {
                qt.Is_Finalized__c = IsFinalized;
               }
               if(flsGet(Quote__c.Quote_Product_Net_Amount__c))
               {
                qt.Quote_Product_Net_Amount__c = QuoteProductNetPrice;
               }
               if(flsGet(Quote__c.Quote_Service_Net_Amount__c))
               {
                qt.Quote_Service_Net_Amount__c = QuoteServiceNetPrice;
               }
            // Q1FY13 changes for RNSD 
            // SCAVA Fix
            if(flsGet(Quote__c.Is_Collaborated__c))
               {
                qt.Is_Collaborated__c = IsCollaborated;
               }
            Insert qt;
            
            updateIsFinalized(optyID);
 
            return '';
        }
        catch (Exception e) {
            return '::Unable to create Quote Header!::';
        }
    }
    /**
     * Method to update SFDC data when the Partner on a Quote is changed in PDR.
     * Quote object must be updated and mappings to Partner Contacts must be deleted
     * if they exist.
     * param dealID - Deal ID
     * param DMQuoteID - PDR unique key for the Quote
     * param ptnrAcctID - ID for the Partner Account attached to the Quote
     */
    WebService static String addChangePartner(String dealID, String DMQuoteID, String ptnrAcctID, String managedService) {
      try {
        //Fetch the Quote to be updated with the new DM Quote ID and Partner Account ID
        Quote__c q = [Select q.Id, q.Opportunity_Name__c, q.DM_QUOTE_ID__c, q.PartnerAcctId__c from Quote__c q where Opportunity_Name__r.DealID__c =:dealID];
        
        //See if there are any Partner Contacts associated to the Opportunity
           Partner_Contact_Oppty_Mapping__c[] pcom = [Select id From Partner_Contact_Oppty_Mapping__c p where p.Opportunity__c=:q.Opportunity_Name__c];
           if (pcom.size() > 0) {
             //If Partner Contacts are associated, delete the mapping, since the Partner Account is changing
             // SCAVA FIX
           if (Partner_Contact_Oppty_Mapping__c.sObjectType.getDescribe().isDeletable())
               {
                delete pcom;
               }
           }
           //Update the Quote with the new IDs
           //q.DM_QUOTE_ID__c = DMQuoteID;
           if (ptnrAcctID == null || ptnrAcctID == '') {
               q.PartnerAcctId__c = null;
           }
           else {
           // SCAVA FIX, Oct16th 2018
           if(flsUpdate(Quote__c.PartnerAcctId__c)){
             q.PartnerAcctId__c = ptnrAcctID;
             }
           }
           update q;

          //If Partner changes, update Managed Service Field too
          Opportunity op = [Select Id, Managed_services__c from Opportunity where dealid__c = :dealID limit 1];
//          if (managedService != null || managedService != ''){
//            op.Managed_Services__c = opty.processManagedSvc(String.valueOf(op.Managed_Services__c), managedService);
//          }
          if (op.Managed_Services__c == null && (managedService != null || managedService != '')){
             if(flsUpdate(Opportunity.Managed_Services__c))  // SCAVA FIX
                    { 
                    op.Managed_Services__c = managedService;
                    }
          }
          update op;
      }
        catch (Exception e) {
            return 'FAILURE:'+e.getMessage();
        }
        return 'SUCCESS';
    }
    /*
     * Changes the Partner on the Opportunity
     * Does NOT select the Channel Master Account
     */ 
    WebService static String changePartner(String optyId, String oldPtnrId, String newPtnrXML) {
        Opportunity op = new Opportunity();
        //Account pt = new Account();
        try {
            String outVal = '';
            String ptnrID = '';
            String hostCamOut = '';
            String hostOut = '';
            String hostCreated = 'FALSE';
            Integer ptnrCnt = 0;
        
            /* Parse Input and build Opty */
            MyParser parser = new MyParser();
            Map<String,String> mp = parser.processPartner(newPtnrXML, false);

            if (mp.containsKey('HOST_OTHER')) {
                ptnrID = mp.get('HOST_OTHER');
            
                if (ptnrID == 'FALSE') {
                    outVal += '::Required Partner data is missing!::';
                    ptnrID = '';
                }
                else if (ptnrID == 'CAM_INACTIVE') {
                    outVal += '::Country and Unallocated CAM are inactive!::';
                    ptnrID = '';
                }
                else {
                    outVal += '::Partner ID: '+ptnrID+'::';
                    hostOut = ptnrID;
                    hostCamOut = mp.get('HOST_CAM');
                    hostCreated = mp.get('HOST_CREATED');
                    ptnrCnt = 1;
                }
            }
            else { 
              outVal += 'No Account Found';
            }

            
            /* Get opportunity */
            op = [select Id,DealId__c, Primary_Partner__c,Partner_2__c,Partner_3__c,Partner_4__c,Partner_5__c,Primary_Partner_Role__c,Role_2__c,Role_3__c,Role_4__c,Role_5__c  from Opportunity where Id = :optyId];
            
            /* Get old Ptnr */
            Account[] pt = Database.query('select Id from Account where Id = :oldPtnrId');
            
            List<String> ptnrList = new List<String>();
            List<String> ptnrRole = new List<String>();

                //If records are not null, add them to the lists
                // SCAVA Fix
                if (op.Primary_Partner__c != null) {
                    if(flsUpdate(Opportunity.Primary_Partner__c))
                    {
                    ptnrList.add(op.Primary_Partner__c);
                    }
                    if(flsUpdate(Opportunity.Primary_Partner_Role__c))
                    {
                    ptnrRole.add(nvl(op.Primary_Partner_Role__c));
                    }
                }
                if (op.Partner_2__c != null) {
                    if(flsUpdate(Opportunity.Partner_2__c))
                    {
                    ptnrList.add(op.Partner_2__c);
                    }
                    if(flsUpdate(Opportunity.Role_2__c))
                    {
                    ptnrRole.add(nvl(op.Role_2__c));
                    }
                }
                if (op.Partner_3__c != null) {
                    if(flsUpdate(Opportunity.Partner_3__c))
                    {
                    ptnrList.add(op.Partner_3__c);
                    }
                    if(flsUpdate(Opportunity.Role_3__c))
                    {
                    ptnrRole.add(nvl(op.Role_3__c));
                    }
                }
                if (op.Partner_4__c != null) {
                    if(flsUpdate(Opportunity.Partner_4__c))
                    {
                    ptnrList.add(op.Partner_4__c);
                    }
                    if(flsUpdate(Opportunity.Role_4__c))
                    {
                    ptnrRole.add(nvl(op.Role_4__c));
                    }
                }
                if (op.Partner_5__c != null) {
                    if(flsUpdate(Opportunity.Partner_5__c))
                    {
                    ptnrList.add(op.Partner_5__c);
                    }
                    if(flsUpdate(Opportunity.Role_5__c))
                    {
                    ptnrRole.add(nvl(op.Role_5__c));
                    }
                }

                //Figure out if the new partner is already on the opty
                boolean newPtnrExists = false;
                for (Integer i=0;i<ptnrList.size();i++) {
                  //outVal += ptnrList[i]+',';
                    if (ptnrList[i] == ptnrID) {
                        newPtnrExists = true;
                        //outVal += 'New Ptnr Exists!';
                    }
                }

                Boolean ptnrAdded = false;
                for (Integer i=0;i<ptnrList.size();i++) {
                    //If new partner is already on the opty, just remove old partner
                    //Unless new Partner is same as old partner
                    if (pt.size() > 0){
                    if ((ptnrList[i] == pt[0].Id && newPtnrExists) && (ptnrList[i] != ptnrID)) {
                        ptnrList.remove(i);
                        ptnrRole.remove(i);
                        i--;
                        //outVal += 'Removing old partner!';
                    }
                    //Else replace old partner with new
                    else if (ptnrList[i] == pt[0].Id && !newPtnrExists) {
                        ptnrList.set(i,ptnrID);
                        //If existing role is not null, keep it, else replace it
                        if (ptnrRole.get(i) == null || ptnrRole.get(i) == '') {
                            ptnrRole.set(i,'VAR/Reseller');
                        }
                        ptnrAdded = true;
                        //outVal += 'Updating old ptnr with New Ptnr';
                    }
                    }
                }
                
                //If the new partner was not added or isn't already on the opty, add it now
                if (!ptnrAdded && !newPtnrExists) {
                  //If all 5 partner slots are filled, replace the last one with the new partner
                  if (ptnrList.size() == 5) {
                      ptnrList.set(4,ptnrID);
                      ptnrRole.set(4,'VAR/Reseller');
                  }
                  //Otherwise, just add it at the end
                  else {
                      ptnrList.add(ptnrID);
                      ptnrRole.add('VAR/Reseller');
                  }
                }

                //Reset the partners on the opportunity in the new order
                if (ptnrList.size() > 0 && ptnrList[0] != null) {
                    op.Primary_Partner__c = ptnrList.get(0);
                    op.Primary_Partner_Role__c = ptnrRole.get(0);
                }
                else {
                    op.Primary_Partner__c = null;
                    op.Primary_Partner_Role__c = null;
                }                

                if (ptnrList.size() > 1 && ptnrList[1] != null) {
                    op.Partner_2__c = ptnrList.get(1);
                    op.Role_2__c = ptnrRole.get(1);
                }
                else {
                    op.Partner_2__c = null;
                    op.Role_2__c = null;
                }                
                if (ptnrList.size() > 2 && ptnrList[2] != null) {
                    op.Partner_3__c = ptnrList.get(2);
                    op.Role_3__c = ptnrRole.get(2);
                }
                else {
                    op.Partner_3__c = null;
                    op.Role_3__c = null;
                }                
                if (ptnrList.size() > 3 && ptnrList[3] != null) {
                    op.Partner_4__c = ptnrList.get(3);
                    op.Role_4__c = ptnrRole.get(3);
                }
                else {
                    op.Partner_4__c = null;
                    op.Role_4__c = null;
                }                
                if (ptnrList.size() > 4 && ptnrList[4] != null) {
                    op.Partner_5__c = ptnrList.get(4);
                    op.Role_5__c = ptnrRole.get(4);
                }
                else {
                    op.Partner_5__c = null;
                    op.Role_5__c = null;
                }                
            
            update op;

            /* Return Success message with Deal ID and SFDC Opportunity ID */
            return Opty.outXML(op.DealId__c,String.valueOf(op.Id),'SUCCESS',hostOut,hostCamOut,hostCreated,'','','',outVal,'');
        }
        /* Catch planned Exceptions */
        catch (Opty.OptyException oe) {
            return Opty.outXML(op.DealId__c,String.valueOf(op.Id),'FAILURE',oe.getMessage());
        }
        /* Handle any unexpected Exceptions */
        catch (Exception e) {
            return Opty.outXML(op.DealId__c,String.valueOf(op.Id),'FAILURE',e.getMessage());
        }
    }
    
    //Method to call lead conversion API to convert the lead initiate deal to SFDC opty
    Public static String convertLead(Opty opty)
    {
        Lead lead;
        String outVal = '';
        try {
            //Fetching the details of the lead that is to be converted
            lead=[select Id,Name,OwnerId,
                              IsConverted,ConvertedDate,
                              ConvertedAccountId,ConvertedContactId,ConvertedOpportunityId,
                              Email,Status,End_Customer_Account__c,LastName from lead where Id = :opty.getLeadId()];
        }
        catch(QueryException qe) {
            outVal += '::Lead data does not exist in SFDC!::';
        }
    
        //check for the status of the lead
            if(lead.Status!='2 Accepted-Mine/Channel') {
                //Lead cannot be converted as status is not as above
                outVal += '::Only the lead with status "2 Accepted-Mine/Channel" can be converted to opportunity::';
                //Stop the control here
            }
            // callin gthe database method called as LeadConvert() to convert the lead which we get in XML 
            Database.LeadConvert lc = new database.LeadConvert();
            lc.setLeadId(lead.id);
            //End customer Account id which comes in XML need to be set
            lc.setAccountId(opty.getSfdcAcctId());
            lc.setConvertedStatus('2 Accepted-Mine/Channel');
            //Create an opportunity from the lead
            lc.setDoNotCreateOpportunity(false);
            lc.setOpportunityName(opty.getName());
            // Making the logged user as the opty owner
            lc.setOwnerId(opty.getSFDCUserId());
            // Skipping the same last name validation rule on leads
            //try{
            String dEmail = lead.Email;
            String dLastName = lead.LastName;
            String dAccountId = opty.getSfdcAcctId();
            String q = 'select Id from Contact where AccountId =: dAccountId and Email =: dEmail and LastName =: dLastName';
            
            Contact[] ct;
            ct = (List<Contact>)Database.query(q);
            if(ct.size() > 0){
            lc.setContactId(ct[0].id);
            }

            //Fetching the ID of newly created opportunity 
            try
            {
                lead.Opportunity_Owner_AM__c = opty.getSFDCUserId();
                update lead;
                Database.LeadConvertResult lcr  = Database.convertLead(lc);
                String createdOpptyId=lcr.getOpportunityId();
                return createdOpptyId;
            }
            catch (Exception e)
            {
                //outVal+=e.getMessage();
                 outVal += '::Error while converting the Deal to Opportunity in SFDC ::';
                return null;
            }       
        }
    }