/******************************************************************************
Name    : EngageCaseSharingBatch
Author  : Apex User
Purpose : Contains the logic to share Engage Services Resources Case to Service One
Created Date:  2/02/2018

*******************************************************************************/

global with sharing class EngageCaseSharingBatch implements Database.Batchable<sObject>{

    global Database.QueryLocator start(Database.BatchableContext BC){
        System.debug('Query == ');
        DateTime stDate = Apex_Batch_Job__c.getInstance('EngageCaseTimestamp').TimeStamp__c;
        System.debug('stDate == '+stDate);
        System.debug('enddate::::' + system.now()); 
        ObjectRecordTypeIds__c objRecordTypeSetting = ObjectRecordTypeIds__c.getOrgDefaults();
        String engageCaseRecordTypeId = objRecordTypeSetting.Engage_Services_Resources__c;           
        if(Test.isRunningTest()){
            return Database.getQueryLocator([select Id, casenumber, opportunity__c,opportunity__r.accountid, Opportunity__r.dealid__c, Opportunity__r.closedate, AccountId from Case where lastmodifieddate >: stDate and lastmodifieddate <=: system.now() and RecordTypeid=:engageCaseRecordTypeId limit 200]);
        }else{
            return Database.getQueryLocator([select Id, casenumber, opportunity__c,opportunity__r.accountid, Opportunity__r.dealid__c, Opportunity__r.closedate, AccountId from Case where  lastmodifieddate >: stDate and lastmodifieddate <=: system.now() and RecordTypeid=:engageCaseRecordTypeId]);
        }
        
    } 
     
    global void execute(Database.BatchableContext BC, List<Case> caseList){ 
        system.debug('caseList:::' + caseList);
        List<PartnerNetworkRecordConnection> insertRecordList = new List<PartnerNetworkRecordConnection>();
        Map<Id,Case> engageCaseMap = new Map<Id,Case>();
        Map<id,case> mapCase = new Map<Id,Case>();
        Set<Id> IdList = new Set<Id>();
        Set<Id> sharedAccOptySet  = new set<id>();        
        Set<Id> accSet  = new Set<id>();
        Set<Id> setOptys = new Set<Id>();
        Set<string> wrkoptyId = new Set<string>();  
        Date clsDate = Apex_Batch_Job__c.getInstance('closedate').Date_TimeStamp__c;    
        for(Case c: caseList){
            if(c.Opportunity__c != null){
                if(c.Opportunity__r.closedate >= clsDate && c.Opportunity__r.dealid__c != null && c.Opportunity__r.dealid__c != ''){
                    engageCaseMap.put(c.ID, c);
                    IdList.add(c.opportunity__r.accountid);
                    IdList.add(c.Opportunity__c);
                    IdList.add(c.id);
                }
            }
        } 
                
        System.debug('------Engage Case----'+engageCaseMap);
        System.debug('------Id List----'+IdList );
        
        //Get Connections 
        String conNetworkId = String.escapeSingleQuotes('ServiceOneConnectionID');
        string networkId = Utilities.getConstant_CS(conNetworkId );
        
        if(engageCaseMap.size()>0){          
            if(!IdList.isEmpty()){   
                // Get the Case, opportunity and account's partner network record connections           
                for (PartnerNetworkRecordConnection optySharingRecord : SO_BatchUtilityClass.updateQuery(IdList)){  
                    // for each partner connection record for contact's account, check if it is active
                    if ((optySharingRecord.status.equalsignorecase('Sent')) 
                      && (optySharingRecord.ConnectionId == networkId)) { 
                        sharedAccOptySet.add(optySharingRecord.LocalRecordId); 
                    }               
                }
            }
            
            for(Case enCase:engageCaseMap.values()){
                // Check Account, opty or case are shared or not 
                if(sharedAccOptySet.contains(enCase.id)){  
                    insertRecordList.add(SO_BatchUtilityClass.getNetworkRecord(NetWorkId, enCase.Id, enCase.Opportunity__c, ''));
                    System.debug('-----Case Entry-----');   
                }
                else if(sharedAccOptySet.contains(enCase.Opportunity__c)){
                    insertRecordList.add(SO_BatchUtilityClass.getNetworkRecord(NetWorkId, enCase.Id, enCase.Opportunity__c, ''));
                    if(enCase.Opportunity__r.dealid__c != null && enCase.Opportunity__r.dealid__c != ''){
                        wrkoptyId.add(enCase.Opportunity__r.dealid__c);
                    }
                    System.debug('-----Case Entry11-----'); 
                }
                else if(sharedAccOptySet.contains(enCase.Opportunity__r.AccountId)){
                    insertRecordList.add(SO_BatchUtilityClass.getNetworkRecord(NetWorkId, enCase.Opportunity__c, enCase.Opportunity__r.AccountId, 'OpportunityLineItem'));
                    mapCase.put(enCase.Id, enCase);
                    setOptys.add(enCase.Opportunity__c);
                    accSet.add(enCase.Opportunity__r.AccountId);                    
                    System.debug('-----Case Entry22-----'); 
                }else{
                    insertRecordList.add(SO_BatchUtilityClass.getNetworkRecord(NetWorkId, enCase.Opportunity__r.AccountId, NULL, ''));
                    mapCase.put(enCase.Id, enCase);
                    setOptys.add(enCase.Opportunity__c);
                    accSet.add(enCase.Opportunity__r.AccountId);
                    System.debug('-----Case Entry33-----'); 
                }
            }
            system.debug('optyval:::' + setOptys);
                          
            System.debug('----Case Record To be Shared-----'+insertRecordList);
           
            // Share Record to S1
            if(insertRecordList.size()>0){
                try{
                     Database.UpsertResult[] results = Database.upsert(insertRecordList);  
                     system.debug('results === >'+results);          
                }catch(Exception e){
                    System.debug('-----ERROR-----'+e.getMessage());
                }
                
                // Call method to share workspace
                if(!wrkoptyId.isEmpty()){
                    shareWorkspceTech(wrkoptyId,networkId); 
                }
                
                // Call method to share Case
                if((!mapCase.isEmpty()) || (!setOptys.isEmpty())){
                    System.debug('-----Engae Case Entry-----'); 
                    shareCaseOpty(mapCase,setOptys, accSet, NetWorkId);                 
                }
                
            }                
        }    
    }
     
    global void finish(Database.BatchableContext BC){
        try{
            // Update the custom setting date value with next day.
            
            Double Minutes = Apex_Batch_Job__c.getInstance('EngageCaseTimestamp').Minutes__c;
            Apex_Batch_Job__c.getInstance('EngageCaseTimestamp').TimeStamp__c= system.now().addMinutes(integer.valueof(Minutes) );                   
            update Apex_Batch_Job__c.getInstance('EngageCaseTimestamp');
        }catch(exception e) {
            system.debug('Job OptyInsertToCustomObjectJob Finished at :' + system.now()+'=='+e);
        }

    }
    
    // Method to Share Engage Case To S1    
    public void shareCaseOpty(map<Id,case> engCase, Set<Id> engopty, Set<Id> engAcct, string NetworkId){  
        system.debug('optylist size:::::' +engopty.size());
        system.debug('optylist :::::' +engopty);
        Map<Id,String> insertRecordMap = new Map<Id,String>();
        List<PartnerNetworkRecordConnection> insertRecordList = new List<PartnerNetworkRecordConnection>();
        set<id> sharedAccOptySet =  new set<id>();
        Set<Id> sharedCaseSet = new Set<Id>(); 
        Set<id> wrkoptyId = new Set<Id>();
        set<string> dealids = new set<string>();
        List<opportunity> lstPhaseOpty = [select id,accountid,dealid__c from opportunity where id IN : engopty];
        for(opportunity opts: lstPhaseOpty){
            dealids.add(opts.dealid__c);
        } 
        // Check For Opty       
        if(!engopty.isEmpty()){
            List<opportunity> lstOpty = [select id,accountid  from opportunity where dealid__c IN: dealids];
            // Get the account's partner network record connections 
            for (PartnerNetworkRecordConnection optySharingRecord : SO_BatchUtilityClass.updateQuery(engAcct)) { 
                              
                    // for each partner connection record for contact's account, check if it is active 
                    if ((optySharingRecord.status.equalsignorecase('Sent')) 
                      && (optySharingRecord.ConnectionId == NetworkId)) { 
                        sharedAccOptySet.add(optySharingRecord.LocalRecordId); 
                    }               
            }
            // Share Opty If Account is Shared
            for(Opportunity op:lstOpty){
               if(sharedAccOptySet.contains(op.AccountId)){
                    wrkoptyId.add(op.id);   
                    insertRecordList.add(SO_BatchUtilityClass.getNetworkRecord(NetWorkId, op.id, op.AccountId, 'OpportunityLineItem'));
                }
            }
            System.debug('-----Engae Opty-----');       
        } 
        // Check For Case
        if(!engCase.isEmpty()){
            // Get the opportunity's partner network record connections 
            for (PartnerNetworkRecordConnection caseSharingRecord : SO_BatchUtilityClass.updateQuery(engopty)) { 
                              
                    // for each partner connection record for contact's account, check if it is active 
                    if ((caseSharingRecord.status.equalsignorecase('Sent')) 
                      && (caseSharingRecord.ConnectionId == networkId)) { 
                        sharedCaseSet.add(caseSharingRecord.LocalRecordId); 
                    }               
            }
            // Share Case If Opty is Shared
            for(case cs:engCase.values()){
               if(sharedCaseSet.contains(cs.opportunity__c)){
                    insertRecordList.add(SO_BatchUtilityClass.getNetworkRecord(NetWorkId, cs.id, cs.Opportunity__c, ''));
               }
            } 
            System.debug('-----Engae Case-----');   
        }       
            
        //Share Record to S1
        if(insertRecordList.size()>0){
            try{
              Database.UpsertResult[] results = Database.upsert(insertRecordList);  
              system.debug('results === >'+results);          
            }catch(Exception e){
              System.debug('-----ERROR-----'+e.getMessage());
            }           
        }
    } 
    
    // Share Workspcae to S1
    public void shareWorkspceTech(set<string> wrkoptyDealId, string networkId){
        map<id,PartnerNetworkRecordConnection> mapConnRec = new map<id,PartnerNetworkRecordConnection>();        
        set<Id> sharedOptySet = new set<Id>();
        set<Id> wrkoptyId = new set<id>();
        List<opportunity> optyList = [select id,accountid from Opportunity  where dealid__c in:wrkoptyDealId];
        for(opportunity opts:optyList){
            wrkoptyId.add(opts.id);
        }
        if(!wrkoptyId.isEmpty()){
            if (wrkoptyId.size() > 0) { 
            // Get the opportunity account's partner network record connections 
                for (PartnerNetworkRecordConnection optySharingRecord :SO_BatchUtilityClass.updateQuery(wrkoptyId)) { 
                          
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
                    mapConnRec.put(wrkspace.Id,SO_BatchUtilityClass.getNetworkRecord(NetWorkId, wrkspace.id, wrkspace.Opportunity__c, 'Workspace_Technology__c'));
                }
            }
        }
        // WorkSpace Share To  S1
        if(!mapConnRec.isEmpty()){
            system.debug('=======44===>'+mapConnRec.values());
            database.upsert(mapConnRec.values());
        }
    } 
}