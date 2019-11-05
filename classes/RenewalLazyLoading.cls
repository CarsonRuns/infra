/************************************************************************************************************************************
Name    : RenewalLazyLoading
Author  : C360 Dev team
Purpose : Contains logic to execute on fetching Renewal opportunity on Renewal Opportunity Component
Date    : 24/01/2019
Change History : none
*************************************************************************************************************************************/
public class RenewalLazyLoading {
    // Get recordType and update isCustomerRT, if account is a Customer or BU
    @AuraEnabled
    public static Boolean getRecordtype(Id AccId) {
        Boolean isCustomerRT = false;
        Id accountRecordtypeId = [SELECT Id, RecordtypeId FROM Account where Id = :AccId].RecordtypeId;
        ObjectRecordTypeIds__c accRTId = ObjectRecordTypeIds__c.getOrgDefaults();
        if(accountRecordtypeId == accRTId.Account_Customer_RecordTypeId__c){
            isCustomerRT = true;
        }
        return isCustomerRT;
    }
    
    //Loading oppty for a specific account
    @AuraEnabled
    public static List<Opportunity> fetchParentRenewalOpp(String AccId,List<id> customerList, Boolean isCustomerRT) { 
        Id usrId = UserInfo.getUserId();
        System.debug('Renewal AccID->'+AccId);
        String RecId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewals Opportunity').getRecordTypeId();
        String Qry = 'SELECT Id,AccountId,Account.Name,Name,Amount,CloseDate,Total_Prior_ATR__c,Expected_Service__c,Expected_Product__c,Prior_Contract_Expiration_Date__c '+
            +' FROM Opportunity '+
            + ' WHERE ' + 
            + ((AccId !=  '' && AccId !=  null ) ?  ((isCustomerRT) ? 'Account.Parent.ParentId=:AccId' : 'Account.ParentId=:AccId') : 'Account.Parent.ParentId in :customerList' )
            + ' and RecordTypeId=:RecId and (NOT StageName  like \'%Closed%\' )'
            + ' Order by Prior_Contract_Expiration_Date__c asc LIMIT 10 ';
        List<Opportunity> RenewalData = Database.query(Qry);
        return RenewalData;
    }
    
    //Loading oppty for a specific account in view all
    @AuraEnabled
    public Static List<Opportunity> getOpportunity(Integer Limits, String AccId, Boolean isCustomerRT,string customerIds){
        List<id> custids = new List<id>();
        if(customerIds != null){
            custids = customerIds.split(',');
        }
        system.debug('custids==>'+custids);
        Id usrId = UserInfo.getUserId();
        String RecId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewals Opportunity').getRecordTypeId();
        system.debug('getopportunity Entered');
        String Qry = 'SELECT Id,AccountId,Account.Name,Name,Amount,CloseDate,Total_Prior_ATR__c,Expected_Service__c,Expected_Product__c,Prior_Contract_Expiration_Date__c'+
            + ' FROM Opportunity '+
            + ' WHERE ' +
            + ((AccId !=  '' && AccId !=  null) ?  ((isCustomerRT) ? 'Account.Parent.ParentId=:AccId' : 'Account.ParentId=:AccId') : 'Account.Parent.ParentId in : custids' )
            + ' and RecordTypeId=:RecId and (NOT StageName  like \'%Closed%\' )'
            + ' Order by Prior_Contract_Expiration_Date__c asc LIMIT ' + Integer.valueof(Limits);
        system.debug('QueryResultRenewals'+Qry);
        List<Opportunity> optyList = Database.query(Qry);
        return optyList;
    }
    
    //Total number of opty for lazy loading
    @AuraEnabled
    public static Integer TotalOpportunity(String AccId, Boolean isCustomerRT,string customerIds){
        List<id> custids = new List<id>();
        if(customerIds != null){
            custids = customerIds.split(',');
        }
        system.debug('customerIds total -->' +customerIds);
       String RecId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewals Opportunity').getRecordTypeId();
        AggregateResult results = Database.query('SELECT Count(Id) TotalOpportunity '+
                                                 +' FROM Opportunity '
                                                 +' WHERE '
                                                 +' RecordTypeId=:RecId and '
                                                 + ((AccId !=  '' && AccId !=  null) ?  ((isCustomerRT) ? 'Account.Parent.ParentId=:AccId' : 'Account.ParentId=:AccId') : 'Account.Parent.ParentId in : custids' )
                                                 + ' and RecordTypeId=:RecId and (NOT StageName  like \'%Closed%\' )');
        
        Integer totalOpportunity = (Integer)results.get('TotalOpportunity');
        return totalOpportunity;
    } 
    
    
    
}