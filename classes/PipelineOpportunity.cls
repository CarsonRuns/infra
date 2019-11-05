/************************************************************************************************************************************
Name    : PipelineOpportunity
Author  : C360 Dev team
Purpose : Contains logic to execute on fetching Pipeline opportunity on Pipeline Opportunity Component
Date    : 24/01/2019
Change History : none
*************************************************************************************************************************************/
public class PipelineOpportunity {
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
    public static List<Opportunity> fetchParentPipelineOpp(String AccId,List<Id> customerList, Boolean isCustomerRT) { 
        Id usrId = UserInfo.getUserId();
        String RecId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewals Opportunity').getRecordTypeId();
        List<Opportunity> PipelineData = new List<Opportunity>();   
        PipelineData=null;
        PipelineData = Database.query('SELECT Id,AccountId,Account.Name,Name,Amount,CloseDate,StageName,Forecast_Status__c '+
                            +' FROM Opportunity '+
                            +' WHERE CloseDate >= Today and  '
                            +' RecordTypeId != :RecId and '
                            + ((AccId !=  '' && AccId !=  null ) ?  ((isCustomerRT) ? 'Account.Parent.ParentId=:AccId' : 'Account.ParentId=:AccId') : 'Account.Parent.ParentId in :customerList' )
                            + ' Order by CloseDate asc Limit 10');
        return PipelineData;
          
    }
    
    //Loading oppty for a specific account in view all
    @AuraEnabled
    public Static List<Opportunity> getOpportunity(Integer Limits, String AccId, Boolean isCustomerRT,string customerIds){ 
        Id usrId = UserInfo.getUserId();
        List<Id> customerIdsList = new List<Id>();
        if(customerIds != null){
            customerIdsList=customerIds.split(',');
        }
       
        String RecId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewals Opportunity').getRecordTypeId();
         List<Opportunity> optyList = new List<Opportunity>();      
     
        optyList = Database.query('SELECT Id,AccountId,Account.Name,Name,Amount,CloseDate,StageName,Forecast_Status__c  '+
                            +' FROM Opportunity '+
                            +' WHERE CloseDate >= Today and ' 
                            +' RecordTypeId != :RecId and '
                            + ((AccId !=  '' && AccId !=  null) ?  ((isCustomerRT) ? 'Account.Parent.ParentId=:AccId' : 'Account.ParentId=:AccId') : 'Account.Parent.ParentId in : customerIdsList' )
                            + ' Order by CloseDate asc LIMIT ' + String.valueof(Limits));
        return optyList;
    }
    
    //Total number of opty for lazy loading
    @AuraEnabled
    public static Integer TotalOpportunity(String AccId, Boolean isCustomerRT, string customerIds){
        Id usrId = UserInfo.getUserId();
        List<Id> customerIdsList = new List<Id>();
        if(customerIds != null){
            customerIdsList=customerIds.split(',');
        }
        system.debug('customerIds total -->' +customerIds);
        String RecId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewals Opportunity').getRecordTypeId();
        AggregateResult results = Database.query('SELECT Count(Id) TotalOpportunity '+
                            +' FROM Opportunity '+
                            +' WHERE CloseDate >= Today and ' 
                             +' RecordTypeId != :RecId and '
                            + ((AccId !=  '' && AccId !=  null) ?  ((isCustomerRT) ? 'Account.Parent.ParentId=:AccId' : 'Account.ParentId=:AccId') : 'Account.Parent.ParentId in : customerIdsList' ));
        Integer totalOpportunity = (Integer)results.get('TotalOpportunity');
        return totalOpportunity;
    }    
}