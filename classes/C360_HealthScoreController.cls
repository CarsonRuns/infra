/************************************************************************************************************************************
Name    : C360_HealthScoreController
Author  : C360 Dev team
Purpose : Getting data from C360HealthScore__c object to display in customer/BU view
Date    : 28/06/2019
Change History : NA
*************************************************************************************************************************************/
public class C360_HealthScoreController {
    
    @AuraEnabled
    public static String gethealthScores(Id customerId){
        Map<String,String> resultMap = new Map<String,String>();
        String custAccNumber ='';
        Boolean isCustomerRT = false;
        ObjectRecordTypeIds__c accRTId = ObjectRecordTypeIds__c.getOrgDefaults();
        Account accRec = new Account();
        accRec  = [SELECT Id,Name,AccountNumber,RecordTypeId FROM Account WHERE Id =:customerId and RecordType.Name IN ('Customer','Business Unit') limit 1];
        if(accRec!= null && accRec.AccountNumber != null ){
            custAccNumber = accRec.AccountNumber;
        }
        
        C360HealthScore__c healthScore =  new C360HealthScore__c();
        healthScore  = [SELECT Id,Account_Number__c,Index__c,Utilization__c,Quality_Score__c,Sentiment_Score__c,Finance_Score__c,Wow_Status__c,Customer_hi__c FROM C360HealthScore__c WHERE Account_Number__c =: custAccNumber limit 1];        
        if(healthScore !=null){
            return JSON.serialize(healthScore);
        }else{
            return 'error';          
        } 
        
    }
    
}