/************************************************************************************************************************************
Name    : DocumentRollUpController
Author  : C360 Dev team
Purpose : Contains logic to execute and fetch data on Pipeline Opportunity Component
Date    : 24/01/2019
Change History : none
*************************************************************************************************************************************/
public class DocumentRollUpController {
    @AuraEnabled
    public static List<CS_Documents__c> fetchDocumentList(id customerId) {        
        
        List<CS_Documents__c> PipelineData = [Select Id,Name,URL__c,LastModifiedBy.Name, LastModifieddate, LastModifiedBy.Id
                                              from CS_Documents__c 
                                              where Account__c = : customerId];
        return PipelineData;
    }
    
    @Auraenabled
    public static void delteDocById(String docId){
        CS_Documents__c delDoc=[Select Id from CS_Documents__c where id=:docId];
        delete delDoc;
    }
}