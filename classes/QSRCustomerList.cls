public class QSRCustomerList {
    // Get recordType and update isCustomerRT, if account is a Customer or BU
   // @AuraEnabled
   /* public static string getRecordtype(Id AccId) {
        string  recordType;
        Id accountRecordtypeId = [SELECT Id, RecordtypeId FROM Account where Id = :AccId].RecordtypeId;
        ObjectRecordTypeIds__c accRTId = ObjectRecordTypeIds__c.getOrgDefaults();
        if(accountRecordtypeId == accRTId.Account_Customer_RecordType_18__c){
            recordType= accRTId.Account_Customer_RecordType_18__c;
        }else if(accountRecordtypeId == accRTId.Account_BU_RecordType_18__c){
            recordType = accRTId.Account_BU_RecordType_18__c;
        }
        return recordType;
    } */
    
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
    public static List<QSR__c> fetchParentQSRList(Id AccId,boolean isCustomerRT) {      
        List<QSR__c> QSRData = new List<QSR__c>();   
        QSRData = null;
        QSRData = Database.query('SELECT Id,Name,Meeting_Status__c,Meeting_Date__c,Success_Plan__r.Customer_BU_Name__c,Success_Plan__r.Customer_BU_Name__r.Name '+
                                 +' FROM QSR__c '+
                                 +' WHERE '+
                                 + ((isCustomerRT) ? 'Success_Plan__r.Customer_BU_Name__r.ParentId =:AccId or Success_Plan__r.Customer_Name__r.Id =:AccId' : 'Success_Plan__r.Customer_BU_Name__r.Id =:AccId') +
                                 +' Order by Meeting_Date__c asc Limit 10');
        return QSRData;
        
    }
    
    //Loading oppty for a specific account in view all
    @AuraEnabled
    public Static List<QSR__c> getQSR(Integer Limits,String AccId,boolean isCustomerRT){ 
       
        List<QSR__c> QSRList = new List<QSR__c>();      
        
        QSRList = Database.query('SELECT Id,Name,Meeting_Status__c,Meeting_Date__c,Success_Plan__r.Customer_BU_Name__c,Success_Plan__r.Customer_BU_Name__r.Name '+
                                 +' FROM QSR__c '+
                                 +' WHERE '+
                                 + ((isCustomerRT) ? 'Success_Plan__r.Customer_BU_Name__r.ParentId =:AccId or Success_Plan__r.Customer_Name__r.Id =:AccId' : 'Success_Plan__r.Customer_BU_Name__r.Id =:AccId') +
                                 +' Order by Meeting_Date__c asc Limit ' + String.valueof(Limits));
        return QSRList;
    }
    
    //Total number of opty for lazy loading
    @AuraEnabled
    public static Integer TotalQSR(String AccId,boolean isCustomerRT){       
        AggregateResult results = Database.query('SELECT Count(Id) TotalQSR'+
                                 +' FROM QSR__c '+
                                 +' WHERE '+
                                 + ((isCustomerRT) ? 'Success_Plan__r.Customer_BU_Name__r.ParentId =:AccId or Success_Plan__r.Customer_Name__r.Id =:AccId' : 'Success_Plan__r.Customer_BU_Name__r.Id =:AccId') );
                                 
        
        Integer totalQSRList = (Integer)results.get('TotalQSR');
        return totalQSRList ;
    }  
    
    @Auraenabled
    public static void delteDocById(String docId){
        QSR__c delDoc=[Select Id from QSR__c where id=:docId];
        delete delDoc;
    }
}