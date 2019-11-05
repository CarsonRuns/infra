/******************************************************************************
Name    : OpptyInsertToCustomObjectBatchApex
Author  : Narasimharao Muppalla
Purpose : 
Created Date:  27/01/2018

*******************************************************************************/
global class OpptyShareSOneBatchApex implements Database.Batchable<sObject>{
      
    global Database.QueryLocator start(Database.BatchableContext BC){
        System.debug('Query == ');
        DateTime stDate = Apex_Batch_Job__c.getInstance('StoS1OptyQuery').TimeStamp__c;
        Date clsDate = Apex_Batch_Job__c.getInstance('closedate').Date_TimeStamp__c;
        //DateTime CreatedOn = system.now().addHours(-3);
        System.debug('stDate == '+stDate);
        system.debug('Query values=====>'+[SELECT Id,Total_AS_S__c,recordTypeId,Parent_Id__c,Total_AS_T__c,AccountId,DealID__c FROM Opportunity WHERE  lastmodifieddate >: stDate AND lastmodifieddate <=: system.now() AND closedate >=:clsDate AND Total_AS_S__c>0 limit 200]);
        if(Test.isRunningTest()){
            return Database.getQueryLocator([SELECT Id,Total_AS_S__c,recordTypeId,Total_AS_T__c,AccountId,DealID__c FROM Opportunity WHERE  lastmodifieddate >: stDate AND lastmodifieddate <=: system.now() AND closedate >=:clsDate AND Total_AS_S__c>0 limit 200]);
        }else{
            return Database.getQueryLocator([SELECT Id,Total_AS_S__c,recordTypeId,Total_AS_T__c,AccountId,DealID__c FROM Opportunity WHERE  lastmodifieddate >: stDate AND lastmodifieddate <=: system.now() AND closedate >=:clsDate]);
        }
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> scope){
        Map<Id, Opportunity> oppMapforASt = new Map<Id, Opportunity>();
        List<PartnerNetworkRecordConnection> insertnetConnRecList = new List<PartnerNetworkRecordConnection>();
        map<id,PartnerNetworkRecordConnection> mapConnRec = new map<id,PartnerNetworkRecordConnection>();        
        set<String> dealId = new set<String>();        
        Set<Id> accset = new Set<Id>();
        set<string> phaseDealid = new set<string>();
        set<id> phaseAcc = new set<id>(); 
        set<Id> lineoptyId = new set<Id>();
        set<Id> wrkoptyId = new set<Id>();
        set<Id> setCheckid = new set<Id>();
        set<Id> actOpty = new set<Id>();
        set<Id> actSet = new set<Id>();
        set<Id> sharedAccOptySet = new set<id>();
        set<Id> opptySet = new Set<Id>();
        String optyPartnerPhaseRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Partner Phase Opportunity').getRecordTypeId();
        String optyPhaseRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Phase Opportunity').getRecordTypeId();
        
        //Get Connection Id
        string networkId = Utilities.getConstant_CS('ServiceOneConnectionID');
        for(Opportunity opptysin:scope){ 
            if(!String.isBlank(opptysin.DealID__c) && (opptysin.recordTypeId==optyPartnerPhaseRecordTypeId || opptysin.recordTypeId==optyPhaseRecordTypeId)){                    
                dealId.add(opptysin.DealID__c);                
            }
        }
        
        Set<ID> sharedPhaseList = getRelatedOptyStatus(dealId, networkId);
        
        for(Opportunity opp:scope){ 
            if(!String.isBlank(opp.DealID__c)){
                   if((opp.Total_AS_S__c > 0 || opp.Total_AS_T__c > 0) || (sharedPhaseList.contains(opp.Id))){
                       oppMapforASt.put(opp.Id,opp);
                       dealId.add(opp.DealID__c);
                       accset.add(opp.AccountID);
                       opptySet.add(opp.Id);
                }
            }
        }
        
        if((!accset.isEmpty()) || (!oppMapforASt.isEmpty())){           
            // Get the opportunity account's partner network record connections 
            for (PartnerNetworkRecordConnection optySharingRecord :  
                                      [SELECT p.Status, p.LocalRecordId, p.ConnectionId 
                                       FROM PartnerNetworkRecordConnection p              
                                       WHERE p.LocalRecordId IN :opptySet OR p.LocalRecordId IN: accset]) { 
                      
                // for each partner connection record for contact's account, check if it is active 
                if ((optySharingRecord.status.equalsignorecase('Sent')) 
                  && (optySharingRecord.ConnectionId == networkId)) { 
                    sharedAccOptySet.add(optySharingRecord.LocalRecordId); 
                }               
            }
        }
        
        System.debug('sharedAccOptySet===>'+sharedAccOptySet); 
        
        if(!oppMapforASt.isEmpty()){
            for(Opportunity oppList:oppMapforASt.values()){
                if(sharedAccOptySet.contains(oppList.Id)){
                //check whether opportuinity is shared
                    PartnerNetworkRecordConnection networkConnRecord =new PartnerNetworkRecordConnection();
                    networkConnRecord.ConnectionId = networkId;
                    networkConnRecord.LocalRecordId = oppList.Id;
                    networkConnRecord.ParentRecordId = oppList.AccountId; 
                    mapConnRec.put(oppList.Id,networkConnRecord);
                    lineoptyId.add(oppList.Id);
                    wrkoptyId.add(oppList.Id);
                    if(oppList.dealid__c != null && oppList.dealid__c != ''){
                        phaseDealid.add(oppList.dealid__c);
                        phaseAcc.add(oppList.AccountId);
                    }
                    System.debug('sharedAccOptySet11===>'+sharedAccOptySet); 
                 } 
                 //check whether account is shared 
                 else if(sharedAccOptySet.contains(oppList.AccountId)){
                    PartnerNetworkRecordConnection networkConnRecord =new PartnerNetworkRecordConnection();
                    networkConnRecord.ConnectionId = networkId;
                    networkConnRecord.LocalRecordId = oppList.Id;
                    networkConnRecord.ParentRecordId = oppList.AccountId;
                    networkConnRecord.RelatedRecords ='OpportunityLineItem';                    
                    mapConnRec.put(oppList.Id,networkConnRecord);
                    wrkoptyId.add(oppList.Id);
                    if(oppList.dealid__c != null && oppList.dealid__c != ''){
                        phaseDealid.add(oppList.dealid__c);
                        phaseAcc.add(oppList.AccountId);
                    }
                    setCheckid.add(oppList.id); 
                    System.debug('sharedAccOptySet22===>'+sharedAccOptySet);                     
                 }
                 else {
                 //share account if nothing is shared
                    PartnerNetworkRecordConnection networkConnRecord =new PartnerNetworkRecordConnection();
                    networkConnRecord.ConnectionId = networkId;
                    networkConnRecord.LocalRecordId = oppList.AccountId;                    
                    mapConnRec.put(oppList.AccountId,networkConnRecord);
                    actOpty.add(oppList.id);
                    actSet.add(oppList.AccountId);
                    System.debug('sharedAccOptySet 33===>'); 
                 }
            }   
        }
        
        if(!mapConnRec.isEmpty()){
            Database.UpsertResult[] results;
            try{
                system.debug('=======11===>'+mapConnRec.values());
                results = Database.upsert(mapConnRec.values());
            }catch(Exception e){
                system.debug('An Exception occured'+e); 
            } 
            if(!lineoptyId.isEmpty()){
                shareLinitems(lineoptyId);
            }
            if(!wrkoptyId.isEmpty()){
                shareWorkspceTech(wrkoptyId,networkId); 
            }
            if((!phaseDealid.isEmpty()) || (!actOpty.isEmpty())){
                shareRelatedRecordShare(phaseDealid,phaseAcc,setCheckid,actOpty,actSet); 
            }        
        }
    }    
    
    global void finish(Database.BatchableContext BC){
       try{
            //Update the custom setting date value with next day.
            Apex_Batch_Job__c.getInstance('StoS1OptyQuery').TimeStamp__c= system.now().addMinutes(-30);               
            update Apex_Batch_Job__c.getInstance('StoS1OptyQuery');
        }catch(exception e) {
            system.debug('Job OptyInsertToCustomObjectJob Finished at :' + system.now()+'=='+e);
        }
        
    }
    
    //Line Item share to S1
    public void shareLinitems(set<Id> setIds){
        map<id,PartnerNetworkRecordConnection> mapConnRec = new map<id,PartnerNetworkRecordConnection>();
        List<PartnerNetworkRecordConnection> insertnetConnRecList = new List<PartnerNetworkRecordConnection>();
        string networkId = Utilities.getConstant_CS('ServiceOneConnectionID');
        set<Id> lstWork = new set<id>();
        if(!setIds.isEmpty()){
            List<OpportunityLineitem> lstLine = [select id,opportunityid from OpportunityLineitem where opportunityid IN:setIds];
            for(OpportunityLineitem oli:lstLine){
                PartnerNetworkRecordConnection networkConnRecord =new PartnerNetworkRecordConnection();
                networkConnRecord.ConnectionId = networkId;
                networkConnRecord.LocalRecordId = oli.Id;
                networkConnRecord.ParentRecordId = oli.opportunityid;
                mapConnRec.put(oli.Id,networkConnRecord);   
            }
        }
        if(!mapConnRec.isEmpty()){
            system.debug('=======22===>'+mapConnRec.values());
        try{
            upsert mapConnRec.values();
         }
         catch(Exception e){
                     system.debug('Errror=>'+e.getMessage());

         }
        }
    } 
    
    //related opty Share to S1
    public void shareRelatedRecordShare(set<string> phaseDealid, set<id> phaseAcc, set<Id> setCheckid,set<Id> actOpty, set<id> actSet){
        map<id,PartnerNetworkRecordConnection> mapConnRec = new map<id,PartnerNetworkRecordConnection>();
        List<PartnerNetworkRecordConnection> insertnetConnRecList = new List<PartnerNetworkRecordConnection>();
        string networkId = Utilities.getConstant_CS('ServiceOneConnectionID');      
        set<Id> lstWork = new set<id>();
        set<id> sharedActSet =  new set<id>();  
        set<id> sharedPhaseActSet =  new set<id>();  
        if(!phaseDealid.isEmpty()){          
            // Get the opportunity account's partner network record connections 
            for (PartnerNetworkRecordConnection actSharingRecords :  
                                      [SELECT p.Status, p.LocalRecordId, p.ConnectionId 
                                       FROM PartnerNetworkRecordConnection p              
                                       WHERE p.LocalRecordId IN :phaseAcc]) { 
                      
                // for each partner connection record for contact's account, check if it is active 
                if ((actSharingRecords.status.equalsignorecase('Sent')) 
                  && (actSharingRecords.ConnectionId == networkId)) { 
                    sharedPhaseActSet.add(actSharingRecords.LocalRecordId); 
                }               
            }            
            List<Opportunity> lstOpty = [select id,AccountID from Opportunity where dealid__c IN:phaseDealid];
            for(Opportunity relatdOpt: lstOpty){
                if(!setCheckid.contains(relatdOpt.id) && sharedPhaseActSet.contains(relatdOpt.AccountId)){
                    PartnerNetworkRecordConnection networkConnRecord =new PartnerNetworkRecordConnection();
                    networkConnRecord.ConnectionId = networkId;
                    networkConnRecord.LocalRecordId = relatdOpt.Id;
                    networkConnRecord.ParentRecordId = relatdOpt.AccountId;
                    networkConnRecord.RelatedRecords ='OpportunityLineItem';
                    lstWork.add(relatdOpt.id); 
                    mapConnRec.put(relatdOpt.Id,networkConnRecord);     
                }
            }
            system.debug('Inside Phase share');
        }        
        if(!actOpty.isEmpty()){
            if (actSet.size() > 0) { 
            // Get the opportunity account's partner network record connections 
                for (PartnerNetworkRecordConnection actSharingRecord :  
                                          [SELECT p.Status, p.LocalRecordId, p.ConnectionId 
                                           FROM PartnerNetworkRecordConnection p              
                                           WHERE p.LocalRecordId IN :actSet]) { 
                          
                    // for each partner connection record for contact's account, check if it is active 
                    if ((actSharingRecord.status.equalsignorecase('Sent')) 
                      && (actSharingRecord.ConnectionId == networkId)) { 
                        sharedActSet.add(actSharingRecord.LocalRecordId); 
                    }               
                }
            }
            List<Opportunity> lstOptys = [select id,AccountID from Opportunity where Id IN:actOpty OR parent_id__c IN :actOpty];
            for(Opportunity relatdOpts: lstOptys){
                if(sharedActSet.contains(relatdOpts.AccountId)){ 
                    PartnerNetworkRecordConnection networkConnRecord =new PartnerNetworkRecordConnection();
                    networkConnRecord.ConnectionId = networkId;
                    networkConnRecord.LocalRecordId = relatdOpts.Id;
                    networkConnRecord.ParentRecordId = relatdOpts.AccountId;
                    networkConnRecord.RelatedRecords ='OpportunityLineItem';
                    mapConnRec.put(relatdOpts.Id,networkConnRecord); 
                    lstWork.add(relatdOpts.id);
                }
            }
            system.debug('Inside Account Not share');
        }
        if(!mapConnRec.isEmpty()){
            system.debug('=======33===>'+mapConnRec.values());
            try{
            upsert mapConnRec.values();
            }
         catch(Exception e){
                     system.debug('Errror=>'+e.getMessage());

         }
            if(!lstWork.isEmpty()){
                shareWorkspceTech(lstWork, networkId);
            }
        }
    }
    
    //Workspcae Share to S1
    public void shareWorkspceTech(set<Id> wrkoptyId, string networkId){
        map<id,PartnerNetworkRecordConnection> mapConnRec = new map<id,PartnerNetworkRecordConnection>();        
        set<Id> sharedOptySet = new set<Id>();
        if(!wrkoptyId.isEmpty()){
            if (wrkoptyId.size() > 0) { 
            // Get the opportunity account's partner network record connections 
                for (PartnerNetworkRecordConnection optySharingRecord :  
                                          [SELECT p.Status, p.LocalRecordId, p.ConnectionId 
                                           FROM PartnerNetworkRecordConnection p              
                                           WHERE p.LocalRecordId IN :wrkoptyId]) { 
                          
                    // for each partner connection record for contact's account, check if it is active 
                    if ((optySharingRecord.status.equalsignorecase('Sent')) 
                      && (optySharingRecord.ConnectionId == networkId)) { 
                        sharedOptySet.add(optySharingRecord.LocalRecordId); 
                    }               
                }
            }
            List<AT_Workspace__c> lstWrk = [select id,opportunity__c from AT_Workspace__c where opportunity__c IN:wrkoptyId];   
            for(AT_Workspace__c wrkspace: lstWrk){  
                if(sharedOptySet.contains(wrkspace.opportunity__c)){
                    PartnerNetworkRecordConnection networkConnRecord =new PartnerNetworkRecordConnection();
                    networkConnRecord.ConnectionId = networkId;
                    networkConnRecord.LocalRecordId = wrkspace.Id;
                    networkConnRecord.ParentRecordId = wrkspace.opportunity__c;
                    networkConnRecord.RelatedRecords ='Workspace_Technology__c';
                    mapConnRec.put(wrkspace.Id,networkConnRecord);
                }
            }
        }
        
        if(!mapConnRec.isEmpty()){
            system.debug('=======44===>'+mapConnRec.values());
            try{
            upsert mapConnRec.values();
            }
         catch(Exception e){
                     system.debug('Errror=>'+e.getMessage());

         }
        }
    } 
                
       //Check if parent or related phase is shared
                
       public Set<ID> getRelatedOptyStatus(Set<String> dealIdSet, String networkId){        
        Map<Id,String> insertRecordMap = new Map<Id,String>();
        List<PartnerNetworkRecordConnection> insertRecordList = new List<PartnerNetworkRecordConnection>();
        List<Opportunity> Parent_Opty_IdList = [select id,AccountId,dealid__c from opportunity where dealid__c in :dealIdSet];
    
        //query list of opty id and parent opty id with id in WSParent
        Set<ID> optyIdList = new Set<ID>();
        Set<ID> accountIdSet = new Set<ID>();
        Set<ID> sharedAccOptySet = new Set<ID>();
                                Map<String,Set<ID>> relatedIdMap = new Map<String,Set<ID>>();
                                Set<Id> realtedIdSet = new Set<Id>();
                                
        if(!Parent_Opty_IdList.isEmpty()){
                for(Opportunity optylistParser:Parent_Opty_IdList){                    
                    optyIdList.add(optylistParser.Id);
                     if(relatedIdMap.containsKey(optylistParser.dealid__c)){
                         relatedIdMap.get(optylistParser.dealid__c).add(optylistParser.Id);
                                                                                                
                     }else{
                        Set<ID> newSet = new Set<ID>();
                        newSet.add(optylistParser.Id);
                        relatedIdMap.put(optylistParser.dealid__c,newSet);
                    }
                                                                                
                }
                
                
            }
        
        for (PartnerNetworkRecordConnection optySharingRecord :  
                                              [SELECT p.Status, p.LocalRecordId, p.ConnectionId 
                                               FROM PartnerNetworkRecordConnection p              
                                               WHERE  p.LocalRecordId IN: optyIdList]){  
                        if ((optySharingRecord.status.equalsignorecase('Sent')) 
                          && (optySharingRecord.ConnectionId == networkId)) { 
                            sharedAccOptySet.add(optySharingRecord.LocalRecordId); 
                        }               
                    } 
                                                                                
                                for(String dealKey:relatedIdMap.keySet()){
                                                
                                    for(ID opti:sharedAccOptySet){
                                        if(relatedIdMap.get(dealKey).contains(opti)){
                                            realtedIdSet.addAll(relatedIdMap.get(dealKey));
                                        }
                                    }
                                                
                                }                                              
                                
                                                                                
                   return realtedIdSet;
        
        
    }
                
    
}