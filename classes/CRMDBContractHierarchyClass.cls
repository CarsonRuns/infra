public with sharing class CRMDBContractHierarchyClass {

    @AuraEnabled
    public static List<CRMDB__c> getCrmdbList() {
        //Fetch data
        System.debug('>>Shivi');
        return [SELECT ID,Name,Account_Name_Value__c,Account_Name__c,Active_Customer__c,
                Is_CAP_caused_by_CMS__c,Is_Customer_on_CAP__c,Manager__c,
                SDM_Assigned__c,Theater__c,Account_State__c,Total_CMS_Contract_Value__c,(SELECT ID,Name,Account_Name__c,Account_Name_Value__c,
                Active_Customer__c,Is_CAP_caused_by_CMS__c,Is_Customer_on_CAP__c,Manager__c,
                SDM_Assigned__c,Theater__c,Account_State__c,Total_CMS_Contract_Value__c 
                FROM CRMDB_Customers__r ORDER BY Name ASC NULLS FIRST) 
                FROM CRMDB__c WHERE Master_Customer_Name__c = null ORDER BY Name ASC NULLS FIRST];
        
    }      
    
}