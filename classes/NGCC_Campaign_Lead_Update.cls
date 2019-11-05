/**************************************************************************************************
Name    : NGCC_Campaign_Lead_Update
Author  : Fazurulla Ganganapalli
Purpose : NGCC_Campaign_Lead_Update controller code is usefull for avoiding both "Apex CPU time limit exceeded" and Too many DML rows: 10001 issue.
Created Date: 11/16/2015
Modification History: 
**************************************************************************************************/
global class NGCC_Campaign_Lead_Update implements Database.Batchable<sObject>,Database.Stateful {

     // SCAVA Helper Method
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }
    
    // SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdateGet(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }

    //set will return newly updated campaign records
    Set<Id> setCampIds = new Set<Id>();
    //Map will return newly updated campaign records
    map<Id,Campaign> mapCIdCamp = new map<Id,Campaign>();
    //@ Constructor :Constructor will get set of campaign Ids or map of campaign records
    global NGCC_Campaign_Lead_Update(Set<Id> setCampId,Map<Id,Campaign> mapIdCampaign) {
        setCampIds = setCampId;
        mapCIdCamp = mapIdCampaign;
    }
    //@ method : Trying to query lead information based on set of ids and map of records
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return DataBase.getQueryLocator([Select Id,Campaign_Name__c,Campaign_Priority__c FROM Lead Where isConverted=false and  
                                       (Campaign_Name__c IN : setCampIds OR  Campaign_Name__c IN :mapCIdCamp.keySet())]);
                                       
    }
    // @ method: To process Close all Leads when campaign is completed or cancelled
    global void execute(Database.BatchableContext BC,List<Lead> scope) {
        try{
        List<Lead> scopeLead = scope; // Converting scope to list for processing and updates
        List<Lead> lstLeadToUpdate = new List<Lead>();
        for(Lead ldObj: scopeLead){
            if(setCampIds.contains(ldObj.Campaign_Name__c )){
             //SCAVA
             if(flsGet(Lead.Call_Status__c)||flsUpdateGet(Lead.Call_Status__c)){
                ldObj.Call_Status__c = 'PE Cancelled/Completed';
                }
             if(flsGet(Lead.Status)||flsUpdateGet(Lead.Status)){   
                ldObj.Status = 'Inactive';
                }//SCAVA
            }else if(mapCIdCamp.containsKey(ldObj.Campaign_Name__c )){
            //SCAVA
             if(flsGet(Lead.Campaign_Priority__c)||flsUpdateGet(Lead.Campaign_Priority__c)){
                ldObj.Campaign_Priority__c = String.valueOf(mapCIdCamp.get(ldObj.Campaign_Name__c).Priority__c);
            }
            }
            lstLeadToUpdate.add(ldObj);
        } 
        if(!lstLeadToUpdate.isEmpty()){
            Database.SaveResult[] updateLeadStatus = Database.update(lstLeadToUpdate ,false);
        }
     }catch(Exception e){}
    }
    global void finish(Database.BatchableContext BC){
    }
}