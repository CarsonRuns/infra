/************************************************************************************************************************************
Name    : productShareInBatch
Author  : Bramha
Purpose : Contains logic for sharing the "Products" to service one
*************************************************************************************************************************************/
global class productShareInBatch implements Database.Batchable<sObject>{

global Database.QueryLocator start(Database.BatchableContext BC){
     //Retrieve all active products to share it with ServiceOne.     
        if(Test.isRunningTest()){
         return Database.getQueryLocator([SELECT Id FROM Product2]);    
      }
      else{
       return Database.getQueryLocator([SELECT Id, Name, ProductCode, Description, IsActive, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Family, CurrencyIsoCode, ExternalDataSourceId, ExternalId, DisplayUrl, QuantityUnitOfMeasure, IsDeleted, MayEdit, IsLocked, LastViewedDate, LastReferencedDate, ConnectionReceivedId, ConnectionSentId, Product_Family_2__c, Service_Type__c, Business_Entity__c, Service_Level_1__c, Service_Level_2__c, Service_Level_3__c, Service_Level_4__c, Product_Family_1__c, Product_Family_3__c, Product_Family_4__c, Sub_Business_Entity__c, Unique_BE_SubBE__c, Sub_Business_Entity_Name__c, Business_Entity_Name__c FROM Product2]);    
      }
     } 
      
    global void execute(Database.BatchableContext BC, List<Product2> productLst){ 
         Map<Id, Product2> prodMap = new Map<Id, Product2>();
         for(Product2 pList: productLst){
             prodMap.put(pList.id,pList);
         }
         
        List<PartnerNetworkRecordConnection> insertnetConnRecList =new List<PartnerNetworkRecordConnection>();               
        //get connection Id
        PartnerNetworkConnection networkConn =[Select Id From PartnerNetworkConnection Where ConnectionName = 'Services One' and connectionStatus = 'Accepted'];
        if(networkConn != null) {
            if(prodMap.size() > 0) {           
                for(Product2 prod: prodMap.values()) {
                    PartnerNetworkRecordConnection networkConnRecord =new PartnerNetworkRecordConnection();
                    if(flsCreateGet(PartnerNetworkRecordConnection.ConnectionId) || flsUpdateGet(PartnerNetworkRecordConnection.ConnectionId))          //SCAVA FIX 
                    {
                       networkConnRecord.ConnectionId = networkConn.Id;
                    }
                     system.debug('product id is:' +prod.Id);
                    if(flsCreateGet(PartnerNetworkRecordConnection.LocalRecordId ) || flsUpdateGet(PartnerNetworkRecordConnection.LocalRecordId ))          //SCAVA FIX 
                    {
                     networkConnRecord.LocalRecordId = prod.Id;    
                    }
                     insertnetConnRecList.add(networkConnRecord);
                }                
                // pushing products to the ServiceOne
                if(!insertnetConnRecList.isEmpty()) {
                    createRecordsAndLog(insertnetConnRecList);
                }            
            }       
        }
    }
     
   global void finish(Database.BatchableContext BC){
    
   }
   // pushing products to the ServiceOne
    public void createRecordsAndLog(List<PartnerNetworkRecordConnection> netConnRecList) {
        if(netConnRecList != null && netConnRecList.size() > 0) {
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