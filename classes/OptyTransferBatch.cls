/************************************************************************************************************************************
Name    : OptyTransferBatch
Author  : Bramha
Purpose : Contains logic for sending pending opportunity to service one
*************************************************************************************************************************************/
global class OptyTransferBatch implements Database.Batchable<sObject>{

    global Database.QueryLocator start(Database.BatchableContext BC){
          Date clsDate = Apex_Batch_Job__c.getInstance('closedate').Date_TimeStamp__c;
          string OpptyStatus=Utilities.getConstant_CS('OpptyStatus');
          string[] strOpptyStatus = new string[]{};
          strOpptyStatus = OpptyStatus.split(',');
         if(Test.isRunningTest()){
            return Database.getQueryLocator([select Id, DealID__c, RecordTypeId, IsDeleted,AccountId,Name,CloseDate,Territory2Id,LastModifiedDate,Theater__c,Expected_Service__c,Expected_Product__c,Territory_Level_01__c,Territory_Level_02__c,Total_AS_S__c,Total_AS_T__c from Opportunity where Opportunity_Status__c IN :strOpptyStatus AND CLOSEDATE >=:clsDate limit 10]);
        }else{
            return Database.getQueryLocator([select Id, DealID__c, RecordTypeId, IsDeleted,AccountId,Name,CloseDate,Territory2Id,LastModifiedDate,Theater__c,Expected_Service__c,Expected_Product__c,Territory_Level_01__c,Territory_Level_02__c,Total_AS_S__c,Total_AS_T__c from Opportunity where Opportunity_Status__c IN :strOpptyStatus AND CLOSEDATE >=:clsDate]);
        }   
    } 
     
    global void execute(Database.BatchableContext BC, List<Opportunity> oppLst){ 
        Set<String> dealIds = new Set<String>(); 
        List<PartnerNetworkRecordConnection> insertnetConnRecList = new List<PartnerNetworkRecordConnection>();
        Set<Id> accset = new Set<Id>();
        Map<Id, Opportunity> oppList = new Map<Id, Opportunity>();
        for(Opportunity opt:oppLst){        
            if(!String.isBlank(opt.DealID__c)){   
                oppList.put(opt.id,opt);
                accset.add(opt.AccountId);
                dealIds.add(opt.DealID__c);
            }
        }
       
        //get connection Id
        PartnerNetworkConnection networkConn =[select Id from PartnerNetworkConnection where ConnectionName = 'Services One' and ConnectionStatus = 'Accepted'];
        if(networkConn != null) {
            if(oppList.size() > 0) {
            // Querying opportunity line items to share opportunities by comparing with Business_Entity__c in LineItem
                List<OpportunityLineItem> productList= [select  Business_Entity__c,ConnectionReceivedId,ConnectionSentId,CreatedById,CreatedDate,CurrencyIsoCode,Data_Source_Name__c,Description,Extended_Net_Price__c,Id,IsDeleted,IsLocked,LastModifiedById,LastModifiedDate,Line_Item_ID_Copy__c,ListPrice,MayEdit,Mix__c,Name,OpportunityId,Opportunity_Expected_Book_Date__c,Opportunity_Line_Value_Dollars__c,Opportunity_Line_Value__c,Opportunity_Status__c,PricebookEntryId,Product2Id,ProductCode,Product_Family_Ref__c,Product_Family_US__c,Product_Family__c,Quantity,QuoteId__c,SalesForce1_Created_Updated__c,ServiceDate,Service_Category__c,Service_Level__c,Service_Type__c,SortOrder,SystemModstamp,Technology_Competitor__c,TotalPrice,UnitPrice from OpportunityLineItem where OpportunityId in: oppList.keySet()];                                
                Map<Id,String> insertnetConnRecMap = new Map<Id,String>();
                List<PartnerNetworkRecordConnection> netConnRecList = [select Id, LocalRecordId, Status from PartnerNetworkRecordConnection where LocalRecordId IN: accset]; 
                for(PartnerNetworkRecordConnection accnetRec:netConnRecList) {
                    insertnetConnRecMap.put(accnetRec.LocalRecordId, accnetRec.Status);
                }
                
                //This Map holds the Opportunity and associated LineItems
                Map<Id,List<OpportunityLineItem>> oppLineItemMap = new Map<Id,List<OpportunityLineItem>>();                
                for(OpportunityLineItem optylneItm : productList){
                    if(oppLineItemMap.containsKey(optylneItm.OpportunityId)){
                        List<OpportunityLineItem> optyLineItemsList = oppLineItemMap.get(optylneItm.OpportunityId); 
                        optyLineItemsList.add(optylneItm);
                        oppLineItemMap.put(optylneItm.OpportunityId,optyLineItemsList);   
                    }else{
                        oppLineItemMap.put(optylneItm.OpportunityId,new list<OpportunityLineItem>{optylneItm});
                    }
                }
                
                Set<Id> parentOpptyIds = new Set<Id>();
                Map<String,Boolean> phaseOptyValues = new Map<String,Boolean>();
                String phaseRecordTypeId =  Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Phase Opportunity').getRecordTypeId();
                for(Opportunity opp: oppList.values()) {                    
                    //Validating parent connection shared to the serviceone or not
                    if(insertnetConnRecMap.get(opp.AccountId) == 'Sent' && oppLineItemMap.get(opp.Id)!=null){                     
                        Boolean isSharable=false;
                        for(OpportunityLineItem oppItem:oppLineItemMap.get(opp.Id)){
                             if(oppItem.business_Entity__c!=null && (oppItem.business_Entity__c=='AS-S' || oppItem.business_Entity__c=='AS-T')) {
                                isSharable=true;                                
                             }else{
                             //This loop will run for Phase Opportunities                                  
                                System.debug('#Oppty RecordTypeId# '+opp.recordtypeId+' PhaseO##'+phaseRecordTypeId);
                                List<opportunity> optys = [select id, dealid__c,Total_AS_S__c, Total_AS_T__c, accountid from opportunity where dealid__c =: opp.DealID__c] ;
                                for(opportunity opt : optys){
                                    if(((opt.Total_AS_S__c) > 0 || (opt.Total_AS_T__c) > 0) && (opt.DealID__c != null && opt.DealID__c != '')) { 
                                        phaseOptyValues.put(opt.DealID__c,isSharable); 
                                    }
                                }                               
                             }   
                         }
                         // Sharing the Opportunities with the connection(Service One)
                         if(isSharable){
                            insertnetConnRecList.add(addReecordToList(networkConn.Id,opp.Id,opp.AccountId));
                            if(opp.DealID__c != null && opp.DealID__c != ''){
                                phaseOptyValues.put(opp.DealID__c,isSharable);
                            }   
                            parentOpptyIds.add(opp.Id);
                         }
                     } else if(insertnetConnRecMap.get(opp.AccountId) == 'Invite'&& oppLineItemMap.get(opp.Id)!=null) {
                       // If parent not shared with the connection than we will create a connection for only opportunity.
                        Boolean isSharable=false;
                        for(OpportunityLineItem oppItem:oppLineItemMap.get(opp.Id)){
                            if(oppItem.business_Entity__c!=null && (oppItem.business_Entity__c=='AS-S' || oppItem.business_Entity__c=='AS-T')) {
                                isSharable=true;
                            }else{                                 
                                List<opportunity> optys = [select id, dealid__c,Total_AS_S__c, Total_AS_T__c, accountid from opportunity where dealid__c =: opp.DealID__c] ;
                                for(opportunity opt : optys){
                                    if(((opt.Total_AS_S__c) > 0 || (opt.Total_AS_T__c )> 0) && (opt.DealID__c != null && opt.DealID__c != '')){ 
                                        phaseOptyValues.put(opt.DealID__c,isSharable); 
                                    }
                                }                                   
                            }
                        }
                        if(isSharable){                            
                            insertnetConnRecList.add(addsareReecordToList(networkConn.Id,opp.Id));  
                            if(opp.DealID__c != null && opp.DealID__c != ''){
                                phaseOptyValues.put(opp.DealID__c,isSharable);
                            }
                            parentOpptyIds.add(opp.Id);
                        }       
                    }
                }
                
                // push Opportunities and its related objects like OpportunityLineItem,AT_Workspace__c to connection
                if(!insertnetConnRecList.isEmpty()) {
                    system.debug('insertnetConnRecList === >'+insertnetConnRecList);        
                    Database.UpsertResult[] results;
                    try{
                    results = Database.upsert(insertnetConnRecList);
                    }catch(Exception e){
                        system.debug('An Exception occured'+e); 
                    }
                }
                System.debug('#Opptys# '+phaseOptyValues.keyset());
                if(!phaseOptyValues.isEmpty() && !dealIds.isEmpty()){
                    shareOpportunities(phaseOptyValues.keyset(),parentOpptyIds,networkConn.Id);
                }
            }
        }
    }
     
    global void finish(Database.BatchableContext BC){

    }
    //Sharing the Phase Opportunities with Connection ServiceOne
    public void shareOpportunities(Set<String> phaseOptyIds, Set<Id> parentIds, ID ConnectionId){
        Set<Id> accIds = new Set<Id>();
        for(Opportunity phOpty:[Select Id,AccountId from Opportunity where DealID__c IN:phaseOptyIds]){
            accIds.add(phOpty.AccountId);
        }
        Map<Id,String> phaseNetMap = new Map<Id,String>();
        if(!accIds.isEmpty()){
            List<PartnerNetworkRecordConnection> phaseNetConnRecList = [Select Id, LocalRecordId, Status From PartnerNetworkRecordConnection Where LocalRecordId IN: accIds]; 
            for(PartnerNetworkRecordConnection pcr:phaseNetConnRecList){
                phaseNetMap.put(pcr.LocalRecordId,pcr.Status);
            }
            List<PartnerNetworkRecordConnection> insertnetConnRecList = new List<PartnerNetworkRecordConnection>();
            for(Opportunity phOpty:[Select id, DealID__c, AccountId,(select id, name, opportunityid, business_Entity__c from opportunitylineitems) From Opportunity Where DealID__c IN:phaseOptyIds and Id NOT IN:parentIds]){
                if(phaseNetMap!=null && phaseNetMap.get(phOpty.AccountId)!=null && phaseNetMap.get(phOpty.AccountId) == 'Sent'){
                    if(phOpty.DealID__c != null && phOpty.DealID__c != ''){                        
                        insertnetConnRecList.add(addReecordToList(ConnectionId,phOpty.Id,phOpty.AccountId));
                    }
                }else if(phaseNetMap!=null && phaseNetMap.get(phOpty.AccountId)!=null && phaseNetMap.get(phOpty.AccountId) == 'Invite'){
                    if(phOpty.DealID__c != null && phOpty.DealID__c != ''){                        
                        insertnetConnRecList.add(addReecordToList(ConnectionId,phOpty.Id,phOpty.AccountId));
                    }
                }   
            }
            if(!insertnetConnRecList.isEmpty()){
                    system.debug('insertnetConnRecList === >'+insertnetConnRecList);        
                    Database.UpsertResult[] results;
                    try{
                    results = Database.upsert(insertnetConnRecList);
                    }catch(Exception e){
                        system.debug('An Exception occured'+e); 
                    }
                }
            }
        }
        public PartnerNetworkRecordConnection addReecordToList(string ConnectionId, string optyId, string acountId){
            PartnerNetworkRecordConnection networkConnRecord =new PartnerNetworkRecordConnection();
            //validating Create & Update conditions for ConnectionId from PartnerNetworkRecordConnection
            if(flsCreateGet(PartnerNetworkRecordConnection.ConnectionId) || flsUpdateGet(PartnerNetworkRecordConnection.ConnectionId))         
            {
              networkConnRecord.ConnectionId = ConnectionId;
            }
            //validating Create & Update conditions for LocalRecordId from PartnerNetworkRecordConnection
            if(flsCreateGet(PartnerNetworkRecordConnection.LocalRecordId ) || flsUpdateGet(PartnerNetworkRecordConnection.LocalRecordId ))          
           {
              networkConnRecord.LocalRecordId = optyId;
            }
            //validating Create & Update conditions for ParentRecordId from PartnerNetworkRecordConnection
            if(flsCreateGet(PartnerNetworkRecordConnection.ParentRecordId ) || flsUpdateGet(PartnerNetworkRecordConnection.ParentRecordId ))          
           {
              networkConnRecord.ParentRecordId = acountId;
           }
           //validating Create & Update conditions for RelatedRecords from PartnerNetworkRecordConnection
           if(flsCreateGet(PartnerNetworkRecordConnection.RelatedRecords ) || flsUpdateGet(PartnerNetworkRecordConnection.RelatedRecords ))           
          {
             networkConnRecord.RelatedRecords ='OpportunityLineItem';
          }
            return networkConnRecord;
        }
        public PartnerNetworkRecordConnection addsareReecordToList(string ConnectionId, string optyId){
            PartnerNetworkRecordConnection networkConnRecord =new PartnerNetworkRecordConnection();
            networkConnRecord.ConnectionId = ConnectionId;
            networkConnRecord.LocalRecordId = optyId;            
            networkConnRecord.RelatedRecords ='OpportunityLineItem';
            return networkConnRecord;
        }  
        
        
        
          // SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdateGet(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }
    
    
    // SCAVA Helper Method to validate Create Access at field level
     public static Boolean flsCreateGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    } 
}