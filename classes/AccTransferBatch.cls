/************************************************************************************************************************************
Name    : AccTransferBatch
Author  : Bramha
Purpose : Contains logic for sharing pending Accounts to service one
*************************************************************************************************************************************/

global class AccTransferBatch implements Database.Batchable<sObject>{

    global Database.QueryLocator start(Database.BatchableContext BC){
        Date clsDate = Apex_Batch_Job__c.getInstance('closedate').Date_TimeStamp__c;
        string OpptyStatus=Utilities.getConstant_CS('OpptyStatus');
        string[] strOpptyStatus = new string[]{};
        strOpptyStatus = OpptyStatus.split(',');
        
        //Fetching the Opportunities which are in Active status and closedDate after 30thJuly'17
        if(Test.isRunningTest()){
            return Database.getQueryLocator([select Id, DealID__c, RecordTypeId, IsDeleted,AccountId,Name,CloseDate,Territory2Id,LastModifiedDate,Theater__c,Expected_Service__c,Expected_Product__c,Territory_Level_01__c,Territory_Level_02__c,Total_AS_S__c,Total_AS_T__c from Opportunity where Opportunity_Status__c IN :strOpptyStatus AND (Total_AS_S__c >0 OR Total_AS_T__c >0) AND CLOSEDATE >=:clsDate limit 10]);
        }else{
            return Database.getQueryLocator([select Id, DealID__c, RecordTypeId, IsDeleted,AccountId,Name,CloseDate,Territory2Id,LastModifiedDate,Theater__c,Expected_Service__c,Expected_Product__c,Territory_Level_01__c,Territory_Level_02__c,Total_AS_S__c,Total_AS_T__c from Opportunity where Opportunity_Status__c IN :strOpptyStatus AND (Total_AS_S__c >0 OR Total_AS_T__c >0) AND CLOSEDATE >=:clsDate]);
        }         
        
    } 
     
    global void execute(Database.BatchableContext BC, List<opportunity> optyList){ 
        Set<Id> accIds = new Set<Id>();
        for(opportunity opt:optyList){              
              accIds.add(opt.AccountId);
        }
        List<Account> accList = [select Id,IsDeleted,Name from Account where Id IN:accIds];
        Map<Id,Account> accMap = new Map<Id,Account>();
        for(Account acc:accList){
            accMap.put(acc.id,acc);
        }
         
        List<PartnerNetworkRecordConnection> insertnetConnRecList = new List<PartnerNetworkRecordConnection>();
        List<PartnerNetworkRecordConnection> accSharingRecList = new List<PartnerNetworkRecordConnection>();
        //get connection Id
        PartnerNetworkConnection networkConn =[select Id from PartnerNetworkConnection where ConnectionName = 'Services One' and ConnectionStatus = 'Accepted'];
        if(networkConn != null) {
                //Finding shared accounts to the connection.                   
                accSharingRecList = [select Id, LocalRecordId, Status from PartnerNetworkRecordConnection where LocalRecordId IN: accMap.keyset()];
                Map<Id,String> accSharingRecMap = new Map<Id,String>();
                for(PartnerNetworkRecordConnection rec: accSharingRecList){
                    accSharingRecMap.put(rec.LocalRecordId, rec.Status);
                }
                    for(Account acc:accMap.Values()){
                        //Validating whether the Account shared previously or not
                        if((accSharingRecMap.get(acc.Id) == null) || (accSharingRecMap.get(acc.Id) != null  && accSharingRecMap.get(acc.Id) != 'Sent' && accSharingRecMap.get(acc.Id) != 'Invite')){
                            PartnerNetworkRecordConnection networkConnRecord =new PartnerNetworkRecordConnection();
                            //validating Create & Update conditions for ConnectionId from PartnerNetworkRecordConnection
                            if(flsCreateGet(PartnerNetworkRecordConnection.ConnectionId) || flsUpdateGet(PartnerNetworkRecordConnection.ConnectionId))           
                           {
                            networkConnRecord.ConnectionId = networkConn.Id;
                           }
                           //validating Create & Update conditions for LocalRecordId from PartnerNetworkRecordConnection
                            if(flsCreateGet(PartnerNetworkRecordConnection.LocalRecordId ) || flsUpdateGet(PartnerNetworkRecordConnection.LocalRecordId ))          
                           {
                             networkConnRecord.LocalRecordId = acc.Id;
                           }
                            insertnetConnRecList.add(networkConnRecord);
                        }
                    }
                //pushing account records to connection(ServiceOne)
                if(insertnetConnRecList.size() > 0 ) {
                    createRecordsAndLog(insertnetConnRecList);                
                }
        }
    }   
     
    global void finish(Database.BatchableContext BC){

    }
    //pushing account records to connection(ServiceOne)
    public void createRecordsAndLog(List<PartnerNetworkRecordConnection> netConnRecList) {
        if(netConnRecList != null && netConnRecList.size() > 0) {
            system.debug('netConnRecList === >'+netConnRecList);        
            Database.UpsertResult[] results;
            try{
            results = Database.upsert(netConnRecList);
            }catch(Exception e){
                system.debug('An Exception occured'+e); 
            }
        }
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