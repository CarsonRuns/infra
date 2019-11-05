public class RelatedUpcomingRenewalsOppty {
    //This method is used to get the upcoming new and renewal opportunities for the specific account record
    @AuraEnabled
    public static List<Opportunity> getNewOpportunities(String opptyId){
        
        //Querying the opportunity record to get the AccountId
        Opportunity oppty = [Select id,AccountId from Opportunity where id =: opptyId];
        
        List<String> stageList = RenewalsDataService.getStageList();
        
        //To get the renewal recordtype id from the custom setting.
        ObjectRecordTypeIds__c OpptyRecTypeIds = ObjectRecordTypeIds__c.getInstance();
        
        //Querying all account related non renewal opportunities which having Expected Book Date greater than today
        List<Opportunity> opptys = [Select id,name,stageName,recordTypeId,Expected_Total_Value_000_s__c ,Prior_TCV_Product_Rollup_000s__c,Prior_TCV_Service_Rollup_000s__c,Prior_ATR_Product_Rollup_000s__c,Prior_ATR_Service_Rollup_000s__c,Expected_Product__c,CloseDate,Expected_Service__c, Prior_Contract_Expiration_Date__c from opportunity where accountId =:oppty.AccountId and CloseDate > TODAY and recordTypeId !=: OpptyRecTypeIds.Oppty_Renewal_RecordTypeId_18__c and StageName in :stageList order by Expected_Total_Value_000_s__c  desc limit 3 ];
        return opptys;
    }
    
    //This method is used to get the upcoming renewal opportunities for the specific account record
    @AuraEnabled
    public static List<Opportunity> getRenewalOpportunities(String opptyId){
        
        //Querying the opportunity record to get the AccountId
        Opportunity oppty = [Select id,AccountId from Opportunity where id =: opptyId];
        
        List<String> stageList = RenewalsDataService.getStageList();
        
        //To get the renewal recordtype id from the custom setting.
        ObjectRecordTypeIds__c OpptyRecTypeIds = ObjectRecordTypeIds__c.getInstance();
        
        //Querying all account related renewal opportunities which having Expected Book Date greater than today
        List<Opportunity> renewalOpptys = [Select id,name,stageName,recordTypeId,Expected_Total_Value_000_s__c ,Prior_TCV_Product_Rollup_000s__c,Prior_TCV_Service_Rollup_000s__c,Prior_ATR_Product_Rollup_000s__c,Prior_ATR_Service_Rollup_000s__c,Expected_Product__c,CloseDate,Expected_Service__c, Prior_Contract_Expiration_Date__c from opportunity where accountId =:oppty.AccountId and Prior_Contract_Expiration_Date__c > TODAY and recordTypeId =: OpptyRecTypeIds.Oppty_Renewal_RecordTypeId_18__c and StageName in :stageList  order by Expected_Total_Value_000_s__c  desc limit 3 ];
        return renewalOpptys;
        
    }
}