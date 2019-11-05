/******************************************************************************
Name    : ASWorkspaceSharingBatch 
Author  : Bramhananda Naidu Dabbara
Purpose : Contains the logic to share Workspace contains Business Entity as 'AS-Advanced Services' or 'CSS-Security Services' to Service One
Created Date:  2/5/2018

*******************************************************************************/

global class ASWorkspaceSharingBatch implements Database.Batchable<sObject>{

        global Database.QueryLocator start(Database.BatchableContext BC){
            System.debug('Query == ');
            DateTime stDate = Apex_Batch_Job__c.getInstance('WorkspaceTimestamp').TimeStamp__c;            
            System.debug('stDate == '+stDate);
            if(Test.isRunningTest()){
              return Database.getQueryLocator([SELECT id, name, opportunity__r.accountid,Opportunity__r.dealid__c, Opportunity__c FROM AT_Workspace__c WHERE lastmodifieddate >: stDate and lastmodifieddate <=: system.now() limit 200]);
            }else{
              return Database.getQueryLocator([SELECT id, name, Opportunity__r.accountid, Opportunity__r.dealid__c, Opportunity__c FROM AT_Workspace__c WHERE lastmodifieddate >: stDate and lastmodifieddate <=: system.now()]);
            }    
        }
        global void execute(Database.BatchableContext BC, List<AT_workspace__c> wrkList){
            List<PartnerNetworkRecordConnection> insertRecordList = new List<PartnerNetworkRecordConnection>();
            Map<Id,AT_workspace__c> workspaceMap = new Map<Id,AT_workspace__c>();
            Map<id,AT_workspace__c> mapWorkspace = new Map<Id,AT_workspace__c>();
            Set<Id> optyIdList = new Set<Id>();
            Set<Id> accIdList  = new Set<Id>();
            Set<Id> workspaceIds  =  new Set<Id>();
            Set<Id> normalWorkspaceIds  =  new Set<Id>();
            Set<Id> asWorkspaceIds  =  new Set<Id>();
            Set<Id> sharedAccOptySet  = new set<id>();
            Set<String> ParentId = new Set<String>();
            Set<Id> sharedWrokspace = new Set<Id>();
            Set<ID> setAcct = new Set<ID>();
            String validASBusinessEntityList = AS_Workspace_List__c.getInstance().Business_Entity_List__c;
            
            for(AT_workspace__c atWrk:wrkList){
                workspaceMap.put(atWrk.id,atWrk);
                workspaceIds.add(atWrk.id);
                normalWorkspaceIds.add(atWrk.id);
                optyIdList.add(atWrk.Opportunity__c);
                accIdList.add(atWrk.Opportunity__r.accountid);
            }
            
            //Get Connections
            string networkId = Utilities.getConstant_CS('ServiceOneConnectionID');  
            system.debug('optyIdList ==>'+optyIdList);  
            system.debug('accIdList ==>'+accIdList);    
            List<Workspace_Technology__c> lstAsTech = [SELECT id, name,Workspace__c,business_Entity__c FROM Workspace_Technology__c WHERE workspace__c in:workspaceIds];
            for(Workspace_Technology__c wrTech:lstAsTech){
                if(validASBusinessEntityList.contains(wrTech.business_Entity__c))
                {
                    asWorkspaceIds.add(wrTech.Workspace__c);
                }   
            }
            if(workspaceMap.size()>0){  
            // Get the Workspace, opportunity and account's partner network record connections           
                if(!optyIdList.isEmpty()){           
                    for (PartnerNetworkRecordConnection optySharingRecord :  
                                              [SELECT p.Status, p.LocalRecordId, p.ConnectionId 
                                               FROM PartnerNetworkRecordConnection p              
                                               WHERE p.LocalRecordId IN :accIdList OR p.LocalRecordId IN: optyIdList OR p.LocalRecordId IN:normalWorkspaceIds]){  
                    // for each partner connection record for contact's account, check if it is active    
                        if ((optySharingRecord.status.equalsignorecase('Sent')) 
                          && (optySharingRecord.ConnectionId == networkId)) { 
                            sharedAccOptySet.add(optySharingRecord.LocalRecordId); 
                        }               
                    }
                }
            }
            system.debug('sharedAccOptySet == >'+sharedAccOptySet); 
            for(AT_Workspace__c ws:workspaceMap.values())
            {   //execute when workspace is already shared
                if(sharedAccOptySet.contains(ws.id)){    

                    sharedWrokspace.add(ws.id);                                           
                    
                    system.debug('results === 11>');          
                }
                //execute when Opportunity is already shared
                else if(sharedAccOptySet.contains(ws.Opportunity__c))
                {   
                    PartnerNetworkRecordConnection networkConnRecord =new PartnerNetworkRecordConnection();
                  //validating Create & Update conditions for ConnectionId from PartnerNetworkRecordConnection 
                if(flsCreateGet(PartnerNetworkRecordConnection.ConnectionId)|| flsUpdateGet(PartnerNetworkRecordConnection.ConnectionId))
                {
                   networkConnRecord.ConnectionId = networkId;                          
                }
                //validating Create & Update conditions for LocalRecordId from PartnerNetworkRecordConnection
                if(flsCreateGet(PartnerNetworkRecordConnection.LocalRecordId)|| flsUpdateGet(PartnerNetworkRecordConnection.LocalRecordId))
                {
                    
                   networkConnRecord.LocalRecordId = ws.id;                                
                }
                //validating Create & Update conditions for ParentRecordId from PartnerNetworkRecordConnection
                 if(flsCreateGet(PartnerNetworkRecordConnection.ParentRecordId)|| flsUpdateGet(PartnerNetworkRecordConnection.ParentRecordId))
                {    
                networkConnRecord.ParentRecordId = ws.Opportunity__c;                              
                }
                 //validating Create & Update conditions for RelatedRecords from PartnerNetworkRecordConnection 
                if(flsCreateGet(PartnerNetworkRecordConnection.RelatedRecords)|| flsUpdateGet(PartnerNetworkRecordConnection.RelatedRecords))
                {    
                networkConnRecord.RelatedRecords ='Workspace_Technology__c';                   
                }
                   insertRecordList.add(networkConnRecord);
                    system.debug('results ===22 >');          
                }  
                //execute when Account is already shared             
                else if(sharedAccOptySet.contains(ws.Opportunity__r.AccountId)){
                    if(asWorkspaceIds.contains(ws.id)){ 
                        if(ws.Opportunity__r.dealid__c != null && ws.Opportunity__r.dealid__c != ''){                
                            PartnerNetworkRecordConnection networkConnRecord =new PartnerNetworkRecordConnection();
                            networkConnRecord.ConnectionId = networkId;
                            networkConnRecord.LocalRecordId = ws.Opportunity__c;
                            networkConnRecord.ParentRecordId = ws.Opportunity__r.AccountId;
                            networkConnRecord.RelatedRecords ='OpportunityLineItem';
                            insertRecordList.add(networkConnRecord);                            
                            ParentId.add(ws.Opportunity__r.dealid__c);
                            setAcct.add(ws.Opportunity__r.AccountId);
                            system.debug('results ===33 >');          
                        }
                    }
                }
               //execute when None of A/c , Opty and Workspace are shared
                else{
                    if(asWorkspaceIds.contains(ws.id)){
                        PartnerNetworkRecordConnection networkConnRecord =new PartnerNetworkRecordConnection();
                        networkConnRecord.ConnectionId = networkId;
                        networkConnRecord.LocalRecordId = ws.Opportunity__r.AccountId;
                        insertRecordList.add(networkConnRecord);
                        system.debug('results ===44 >');          
                    }
                    
                }
            }   
            //Share Record to Service One
            if(insertRecordList.size()>0)
            {
                try
                {
                    Database.UpsertResult[] results = Database.upsert(insertRecordList);  
                    system.debug('results === >'+results);          
                }
                catch(Exception e)
                {
                        System.debug('-----ERROR-----'+e.getMessage());
                }
                //Call method to share Opportunity and related phases of it
                if(!ParentId.isEmpty()){                    
                    shareRelatedOpty(ParentId,networkId,setAcct);
                }
            } 
                //Call Method To Update Workspace which are already shred
                if(sharedWrokspace.size()>0){
                                
                    shareWorkspaceTechForSharedWorkspace(sharedWrokspace,networkId);
                                
                }
        }
        
        //Method to update Workspace which are already shared to S1                        
        public void shareWorkspaceTechForSharedWorkspace(Set<ID> wrkspcesharedList, String networkId){  
        
        List<PartnerNetworkRecordConnection> insertWsptRecordList = new List<PartnerNetworkRecordConnection>();
        
        List<Workspace_Technology__c> wstListToShare = [SELECT id, name,Workspace__c,business_Entity__c FROM Workspace_Technology__c WHERE workspace__c in:wrkspcesharedList];
        if(wstListToShare.size()>0){
                        
            for(Workspace_Technology__c wst:wstListToShare){
                    PartnerNetworkRecordConnection networkConnectionRecord =new PartnerNetworkRecordConnection();
                    //validating Create & Update conditions for ConnectionId from PartnerNetworkRecordConnection
                    if(flsCreateGet(PartnerNetworkRecordConnection.ConnectionId)|| flsUpdateGet(PartnerNetworkRecordConnection.ConnectionId))
                    {
                    networkConnectionRecord.ConnectionId = networkId;                       
                    }
                    //validating Create & Update conditions for LocalRecordId from PartnerNetworkRecordConnection
                    if(flsCreateGet(PartnerNetworkRecordConnection.LocalRecordId)|| flsUpdateGet(PartnerNetworkRecordConnection.LocalRecordId))
                    {
                    networkConnectionRecord.LocalRecordId = wst.Id;                           
                    }
                    //validating Create & Update conditions for ParentRecordId from PartnerNetworkRecordConnection
                    if(flsCreateGet(PartnerNetworkRecordConnection.ParentRecordId)|| flsUpdateGet(PartnerNetworkRecordConnection.ParentRecordId))
                    {
                    networkConnectionRecord.ParentRecordId = wst.Workspace__c;                  
                    }
                    insertWsptRecordList.add(networkConnectionRecord);                                                
             }
                                                
       }
                                
       if(insertWsptRecordList.size()>0)
       {
            try
            {
                Database.UpsertResult[] results = Database.upsert(insertWsptRecordList);  
                system.debug('results === >'+results);          
            }
            catch(Exception e)
            {
                    System.debug('-----ERROR-----'+e.getMessage());
            }                
        } 

                                
      }
                                
      //Method to share Opportunity and it's related phases or parent Opty  
      public void shareRelatedOpty(Set<String> dealIdSet, String networkId,Set<ID> accIdList){        
        
        Map<Id,String> insertRecordMap = new Map<Id,String>();
        List<PartnerNetworkRecordConnection> insertRecordList = new List<PartnerNetworkRecordConnection>();
        List<Opportunity> Parent_Opty_IdList = [select id,AccountId from opportunity where dealid__c in :dealIdSet];
    
        //query list of opty id and parent opty id with id in WSParent
        Set<ID> optyIdList = new Set<ID>();
        Set<ID> accountIdSet = new Set<ID>();
        Set<ID> sharedAccOptySet = new Set<ID>();
            if(!Parent_Opty_IdList.isEmpty()){
                for(Opportunity optylistParser:Parent_Opty_IdList){                    
                    optyIdList.add(optylistParser.Id);
                }
                
                
            }
        
        for (PartnerNetworkRecordConnection optySharingRecord :  
                                              [SELECT p.Status, p.LocalRecordId, p.ConnectionId 
                                               FROM PartnerNetworkRecordConnection p              
                                               WHERE p.LocalRecordId IN :accIdList]){  
                        if ((optySharingRecord.status.equalsignorecase('Sent')) 
                          && (optySharingRecord.ConnectionId == networkId)) { 
                            sharedAccOptySet.add(optySharingRecord.LocalRecordId); 
                        }               
                    }
        
        for(Opportunity opt : Parent_Opty_IdList)
        {
            //check opty is shared or not 
            
            if(sharedAccOptySet.contains(opt.AccountId))
            {  
                PartnerNetworkRecordConnection networkConnRecord =new PartnerNetworkRecordConnection();
                //validating Create & Update conditions for ConnectionId  from PartnerNetworkRecordConnection
                if(flsCreateGet(PartnerNetworkRecordConnection.ConnectionId)|| flsUpdateGet(PartnerNetworkRecordConnection.ConnectionId))
                {
                networkConnRecord.ConnectionId = networkId;                    
                }
                //validating Create & Update conditions for LocalRecordId from PartnerNetworkRecordConnection
                if(flsCreateGet(PartnerNetworkRecordConnection.LocalRecordId)|| flsUpdateGet(PartnerNetworkRecordConnection.LocalRecordId))
                {
                networkConnRecord.LocalRecordId = opt.Id;                          
                }
                //validating Create & Update conditions for ParentRecordId from PartnerNetworkRecordConnection
                if(flsCreateGet(PartnerNetworkRecordConnection.ParentRecordId)|| flsUpdateGet(PartnerNetworkRecordConnection.ParentRecordId))
                {
                networkConnRecord.ParentRecordId = opt.AccountId;                         
                }
                //validating Create & Update conditions for RelatedRecords from PartnerNetworkRecordConnection
                if(flsCreateGet(PartnerNetworkRecordConnection.RelatedRecords)|| flsUpdateGet(PartnerNetworkRecordConnection.RelatedRecords))
                {
                networkConnRecord.RelatedRecords ='OpportunityLineItem';                         
                }
                
                insertRecordList.add(networkConnRecord);
            }       
            
        }
    
        //Share Record
        if(insertRecordList.size()>0)
        {
            try
            {
                Database.UpsertResult[] results = Database.upsert(insertRecordList);  
                system.debug('results === >'+results);          
            }
            catch(Exception e)
            {
                System.debug('-----ERROR-----'+e.getMessage());
            }
        }
        
   
    }
        global void finish(Database.BatchableContext BC){
            try{
                // Update the custom setting date value with next day.
                Apex_Batch_Job__c.getInstance('WorkspaceTimestamp').TimeStamp__c= system.now().addMinutes(-30);               
                update Apex_Batch_Job__c.getInstance('WorkspaceTimestamp');
            }catch(exception e) {
                system.debug('Job OptyInsertToCustomObjectJob Finished at :' + system.now()+'=='+e);
            }
        }
        
   // SCAVA Helper Method to validate Create Access at field level
     public static Boolean flsCreateGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }
    
     
       // SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdateGet(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }
          
     }