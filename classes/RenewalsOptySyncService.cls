@RestResource(urlMapping='/renewals/optysync/*')
global class RenewalsOptySyncService{
    
    
    @HttpPost
    global static ResponseData syncOpty(List<Opportunity> opptyHeaderList,Map<String,List<OpportunityLineItem>> optyLineItemMap) {
        
        ResponseData respData = new ResponseData();
        List<OppResponse> oppRespList = upsertOpprtunity(opptyHeaderList); 
        List<Id> upsertOptyIds = new List<Id>();
        List<Id> invalidOptyIds = new List<Id>();
        for(OppResponse oppResp: oppRespList){
            if(oppResp.successFlag=='Y')
                upsertOptyIds.add(oppResp.opportunityID);
            if(oppResp.successFlag=='N' && oppResp.errorMsg.equals('Opp_Stage_Not_Valid'))
                invalidOptyIds.add(oppResp.opportunityID);
        }
        List<OppResponse> oppLineRespList = upsertOpprtunityLineItem(upsertOptyIds,optyLineItemMap,invalidOptyIds);
        
        
        respData.oppRespList.addAll(oppRespList);
        respData.oppLineRespList.addAll(oppLineRespList);
        respData.processed=true;
        
        System.debug('Opportunity Sync Completed');
        return respData;
    }
    
    // Method to upsert opportunity. This method controls the upsert flow
    public static List<OppResponse> upsertOpprtunity(List<Opportunity> opptyHeaderList){
        
        List<String> sourceOpptyIdList=new List<String>();
        List<String> invalidSourceOpptyIdList=new List<String>();        
        Map<String,Opportunity> updateOptyMap=new Map<String,Opportunity>(); 
        String renewalRecordTypeId = Utilities.getOpptyRenewalRecordTypeId();
        
        //Collect all SourceOptyId's to Pass the list for Query Input to retrieve existing Oppty
        for(Opportunity oppty: opptyHeaderList){    
            if(oppty.Source_Opp_ID__c != null)
            {
                sourceOpptyIdList.add(oppty.Source_Opp_ID__c);
            }
        }
        //System.debug('Source Oppty IDS-->:'+sourceOpptyIdList);  
        List<OppResponse> invalidOppRespList = new List<OppResponse>();
        List<OppResponse> oppRespList = new List<OppResponse>();
        
        //Iterate Over Existing Opptys to filter for Valid Update based on StageName
        for(Opportunity existingOppty: [Select id,Source_Opp_ID__c,Opportunity_Owner_AM__c,StageName from Opportunity where Source_Opp_ID__c in: sourceOpptyIdList and RecordType.Id=:renewalRecordTypeId]){
            if(existingOppty.StageName=='1 - Prospect' || existingOppty.StageName=='2 - Qualification')
                updateOptyMap.put(existingOppty.Source_Opp_ID__c,existingOppty);
            else{
                invalidSourceOpptyIdList.add(existingOppty.Source_Opp_ID__c);
                OppResponse invalidoppresp = new OppResponse(existingOppty.id,null,existingOppty.Source_Opp_ID__c,null,
                                                                'N','Opp_Stage_Not_Valid','Opp');
                invalidOppRespList.add(invalidoppresp);
            }
            
        }
        //System.debug('UpdateOptyMap-->'+updateOptyMap);  
        //System.debug('InvalidSourceOpptyIdList-->'+invalidSourceOpptyIdList);              
        
        //Contains the Entire Opportunity List to be upserted. Existing Opptys have Id. New Opptys do not have Id
        List<Opportunity> upsertOpptyList = processOpportunity(opptyHeaderList,updateOptyMap,invalidSourceOpptyIdList);
        oppRespList = upsertOptySalesforce(upsertOpptyList);
        if(invalidOppRespList.size()>0)        //to check
            oppRespList.addAll(invalidOppRespList);
        return oppRespList;
    }
    
    //Method to process Opportunities
    public static List<Opportunity> processOpportunity(List<Opportunity> opptyHeaderList,Map<String,Opportunity> updateOptyMap,List<String> invalidSourceOpptyIdList){
        
        List<Opportunity> upsertOpptyList=new List<Opportunity>();
        for(Opportunity oppty: opptyHeaderList){
            Opportunity opp; 
            if(invalidSourceOpptyIdList.contains(oppty.Source_Opp_ID__c)){
                continue;
            }
            if(updateOptyMap.get(oppty.Source_Opp_ID__c) != null)
                opp =updateOptyMap.get(oppty.Source_Opp_ID__c);
            else{
                opp=new Opportunity();
                opp.Source_Opp_ID__c=oppty.Source_Opp_ID__c;
                //System.debug('New validSourceOpptyIdList-->'+oppty.Source_Opp_ID__c);  
            }
            
            //DF
            opp.Name = oppty.Name;
            opp.Prior_Contract_Expiration_Date__c = oppty.Prior_Contract_Expiration_Date__c;
            opp.CloseDate=oppty.CloseDate;
            opp.AccountId=oppty.AccountId;
            opp.Business_Entity__c = oppty.Business_Entity__c;
            opp.Renewal_Offer_Type__c = oppty.Renewal_Offer_Type__c;
            opp.Renewal_Partner_Info__c = oppty.Renewal_Partner_Info__c;
            
            //Hardcoded
            opp.StageName=oppty.StageName;
            opp.Opportunity_Status__c=oppty.Opportunity_Status__c;
            opp.Forecast_Status__c=oppty.Forecast_Status__c;
            opp.Installed_Base__c=oppty.Installed_Base__c;
            opp.Data_Source_Name__c=oppty.Data_Source_Name__c;   
            opp.Last_IB_refresh__c = System.today();
            
            //Oracle
            opp.Position__c=oppty.Position__c;
            opp.OwnerId=oppty.OwnerId;
            opp.CurrencyIsoCode=oppty.CurrencyIsoCode;
            opp.Prior_Contract_Notes__c=oppty.Prior_Contract_Notes__c;
            opp.Prior_Sales_Order_Number_s__c=oppty.Prior_Sales_Order_Number_s__c;

            if(opp.Opportunity_Owner_AM__c==null)
            {
                opp.Opportunity_Owner_AM__c=oppty.OwnerId;
            }
           
            opp.RecordTypeId=Utilities.getOpptyRenewalRecordTypeId();
            if(!upsertOpptyList.contains(opp))
                upsertOpptyList.add(opp);
            
        }
        return upsertOpptyList;
    }
    
// Method to upsert valid  opportunity into Salesforce
    public static List<OppResponse> upsertOptySalesforce(List<Opportunity> upsertOpptyList){
        
        List<Id> upsertOptyIds=new List<Id>();
        List<DATABASE.UpsertResult> upsertOpptys = new List<DATABASE.UpsertResult>();
        List<OppResponse> oppRespList = new List<OppResponse>();
        
        if(upsertOpptyList.size() > 0){
            //upsert upsertOpptyList;
            upsertOpptys = Database.upsert(upsertOpptyList,false);
            //System.debug('DB Opty Upsert Result----->'+upsertOpptys);
            for(Integer i=0; i< upsertOpptyList.size();i++){
                OppResponse oppresp = new OppResponse();

                oppresp.sourceOppID = upsertOpptyList[i].Source_Opp_Id__c;
                if(upsertOpptys[i].isSuccess()){
                    upsertOptyIds.add(upsertOpptys[i].getId());

                    oppresp.opportunityID = upsertOpptys[i].getId();
                    oppresp.successFlag='Y';
                }
                else{
                    oppresp.successFlag='N'; //opptyLog.Error__c=JSON.serialize(upsertOpptys[i].getErrors());
                    String errM = JSON.serialize(upsertOpptys[i].getErrors());
                    oppresp.errorMsg=errM.substring(0,Math.min(200,errM.length()-1));
                }
                oppresp.resultType='Opp';
                oppRespList.add(oppresp);
            }
        }
        
        //insert opptyLogList;
        return oppRespList;//return upsertOptyIds;
    }
    
    // Method to control upsert opportunity line item flow
    public static List<OppResponse> upsertOpprtunityLineItem(List<Id> upsertOptyIds,Map<String,List<OpportunityLineItem>> optyLineItemMap, List<Id> invalidOptyIds){
        List<Opportunity> oppList =new List<Opportunity>();
        List<OpportunityLineItem> upsertOptyLineList = new List<OpportunityLineItem>();
        Map<id,List<OpportunityLineItem>> existingOpptyLineItemsMap=new Map<id,List<OpportunityLineItem>>();

        /*List<OppResponse> invalidOppLineRespList = new List<OppResponse>();
        for (OpportunityLineItem oli : [select Id,OpportunityId,Source_Opp_Line_Item_ID__c, Service_Level__c, Service_Category__c, 
                                                                Prior_Term__c, Product_Code__c, Product_Family_Ref__c,Service_Level_Ref__c,Product_Family__c,Opportunity.Source_Opp_ID__c,
                                                                PricebookEntryId, Prior_ATR__c, Prior_TCV__c, Data_Source_Name__c
                                                                FROM OpportunityLineItem WHERE OpportunityId =: invalidOptyIds])
        {
            OppResponse invalidopplineresp = new OppResponse(oli.OpportunityId,oli.Id,oli.Opportunity.Source_Opp_ID__c,oli.Source_Opp_Line_Item_ID__c,
                                                                'N','Opp_Stage_Not_Valid','OppLine');
            invalidOppLineRespList.add(invalidopplineresp);
        }*/
        

        //Get existing oppty lineitems for the upserted opptys
        for (Opportunity oppty : [SELECT Id, Source_Opp_ID__c, (select OpportunityId,Source_Opp_Line_Item_ID__c, Service_Level__c, Service_Category__c, 
                                                                Prior_Term__c, Product_Code__c, Product_Family_Ref__c,Service_Level_Ref__c,Product_Family__c,Opportunity.Source_Opp_ID__c,
                                                                PricebookEntryId, Prior_ATR__c, Prior_TCV__c, Data_Source_Name__c from OpportunityLineItems) 
                                  FROM Opportunity WHERE Id =: upsertOptyIds])
        {
            existingOpptyLineItemsMap.put(oppty.Id, oppty.OpportunityLineItems);
            oppList.add(oppty);
        }
        
        //Iterate Over Upserted Oppotunities
        for(Opportunity oppty : oppList){       
            List<OpportunityLineItem> opptyLineItemsList= optyLineItemMap.get(oppty.Source_Opp_ID__c); 
            if(opptyLineItemsList == null){
                continue;
            }
            
            //Iterate over the List of oppty Lineitems for this Opportunity from the Request
            for(OpportunityLineItem opptyLineItem:opptyLineItemsList){
                //System.debug('Request opptyLineItem----->'+opptyLineItem);
                if(opptyLineItem.Source_Opp_Line_Item_ID__c == null){
                    continue;
                }
                List<OpportunityLineItem> existingOpptyLineItemList = existingOpptyLineItemsMap.get(oppty.id);
                OpportunityLineItem optyLine=processOptyLineItem(opptyLineItem,existingOpptyLineItemList);
                
                if(optyLine==null){
                    //System.debug('Inserting a New Opportunity LineItem');
                    optyLine = new OpportunityLineItem();
                    optyLine.OpportunityId= oppty.id;
                    optyLine.Source_Opp_ID__c = opptyLineItem.Source_Opp_ID__c;
                    optyLine.Source_Opp_Line_Item_ID__c = opptyLineItem.Source_Opp_Line_Item_ID__c;
                    optyLine.Product_Code__c = opptyLineItem.Product_Code__c;
                    optyLine.PricebookEntryId =opptyLineItem.PricebookEntryId;//not updatable field

                   
                }
                //if (optyLine.Product_Code__c=='Service')
                   // optyLine.Service_Category__c = opptyLineItem.Service_Category__c;
                 if(optyLine.Product_Code__c=='Technology')
                 {
                        optyLine.Product_Family_Ref__c = opptyLineItem.Product_Family_Ref__c;
                    	
                        optyLine.Product_Family__c = opptyLineItem.Product_Family__c;
                 }
                    if (optyLine.Product_Code__c=='Service'){
                        optyLine.Service_Level_Ref__c = opptyLineItem.Service_Level_Ref__c;
                        optyLine.Service_Level__c = opptyLineItem.Service_Level__c;
                        optyLine.Service_Category__c = opptyLineItem.Service_Category__c;
                    }
                optyLine.Prior_ATR__c = opptyLineItem.Prior_ATR__c;
                optyLine.Prior_TCV__c = opptyLineItem.Prior_TCV__c;
                optyLine.Prior_Term__c = opptyLineItem.Prior_Term__c;
                optyLine.Data_Source_Name__c = opptyLineItem.Data_Source_Name__c;
                optyLine.Mix__c = opptyLineItem.Mix__c;
                optyLine.Business_Entity__c = opptyLineItem.Business_Entity__c;
                if(opptyLineItem.Attrition_Reason_Code__c !=null && !opptyLineItem.Attrition_Reason_Code__c.equals('N/A'))
                {
                    optyLine.Attrition_Reason_Code__c = opptyLineItem.Attrition_Reason_Code__c;
                }
                if(!upsertOptyLineList.contains(optyLine))
                    upsertOptyLineList.add(optyLine);
               
            }
        }
        //upsert lineitems into salesforce
        List<OppResponse> oppLineRespList = new List<OppResponse>();
        oppLineRespList = upsertOptyLineItemSalesforce(upsertOptyLineList);
        
        
        //return upsertOptyLineItemIds;
        return oppLineRespList;
    }
    
    // Method to Process Existing Opportunity LineItems
    public static OpportunityLineItem  processOptyLineItem(OpportunityLineItem opptyLineItem,List<OpportunityLineItem> existingOpptyLineItemList){
        OpportunityLineItem optyLine;
        
        if(existingOpptyLineItemList.size() > 0){
            //Iterate over the lineitems of all existing opptys to identify the matching lineitem if exists
            for(OpportunityLineItem existingOpptyLineItem:existingOpptyLineItemList){
                if(existingOpptyLineItem.Data_Source_Name__c!='CX')
                    continue;
                if (opptyLineItem.Product_Code__c != existingOpptyLineItem.Product_Code__c)
                    continue;

                if(!opptyLineItem.Source_Opp_Line_Item_ID__c.equals(existingOpptyLineItem.Source_Opp_Line_Item_ID__c))
                    continue;
                else
                    optyLine=existingOpptyLineItem;
            }
        }
        return optyLine;
    }
    
    // Method to upsert valid  opportunity into Salesforce
    public static List<OppResponse> upsertOptyLineItemSalesforce(List<OpportunityLineItem> upsertOptyLineList){
      
        List<Id> upsertOptyLineItemIds=new List<Id>();
        List<DATABASE.UpsertResult> upsertOpptyLines = new List<DATABASE.UpsertResult>();

        List<OppResponse> oppLineRespList = new List<OppResponse>();
        
        if(upsertOptyLineList.size() > 0){
            upsertOpptyLines = Database.upsert(upsertOptyLineList,false);
            //System.debug('DB Opty lineitems Upsert Result----->'+upsertOpptyLines);
            for(Integer i=0; i< upsertOptyLineList.size();i++){
                OppResponse oppLineResp = new OppResponse();

                oppLineResp.sourceOppLineID=upsertOptyLineList[i].Source_Opp_Line_Item_ID__c;

                if(upsertOpptyLines[i].isSuccess()){
                    upsertOptyLineItemIds.add(upsertOpptyLines[i].getId());
                    
                    oppLineResp.opportunityLineID = upsertOpptyLines[i].getId();
                    oppLineResp.successFlag = 'Y';
                }
                else{
                    oppLineResp.successFlag='N'; //opptyLog.Error__c=JSON.serialize(upsertOpptys[i].getErrors());
                    String errM = JSON.serialize(upsertOpptyLines[i].getErrors());
                    oppLineResp.errorMsg=errM.substring(0,Math.min(200,errM.length()-1));
                }
                oppLineResp.resultType='OppLine';
                oppLineRespList.add(oppLineResp);
            }
        }
        //return upsertOptyLineItemIds;
        return oppLineRespList;
    }
    
     global class ResponseData {
        public Boolean processed;
        public List<OppResponse> oppRespList;
        public List<OppResponse> oppLineRespList;
        public ResponseData()
        {
            this.oppRespList=new List<OppResponse>(); 
            this.oppLineRespList=new List<OppResponse>(); 
        }
    }
    
    global class OppResponse{
        
        public String opportunityID;
        public String opportunityLineID;
        public String sourceOppID;
        public String sourceOppLineID;
        public String successFlag;
        public String errorMsg;
        public String resultType;
        
        public OppResponse(){
            opportunityID='';
            opportunityLineID='';
            sourceOppID='';
            sourceOppLineID='';
            successFlag='';
            errorMsg='';
            resultType='';
        }
        public OppResponse(String opportunityID, String opportunityLineID, String sourceOppID, String sourceOppLineID,
                              String successFlag, String errorMsg, String resultType){
            this.opportunityID = opportunityID;
            this.opportunityLineID = opportunityLineID;
            this.sourceOppID = sourceOppID;
            this.sourceOppLineID = sourceOppLineID;
            this.successFlag = successFlag;
            this.errorMsg = errorMsg;
            this.resultType = resultType;                      
        }

    }

}