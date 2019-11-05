public class lxOpptyWorkspaceNewEditController {
@AuraEnabled
    public static String getQueryString(String sObjectId) {
        String queryString = '';
        String fieldSfId = 'CF';
        String recordName = '';
        
        if(String.isNotBlank(sObjectId)) {
            Opportunity oOppty = [SELECT Name FROM Opportunity WHERE Id = :sObjectId];
            recordName = EncodingUtil.urlEncode(oOppty.Name, 'UTF-8');
        }
        
        String durableId = [ SELECT DurableId FROM FieldDefinition WHERE EntityDefinition.QualifiedApiName = 'AT_Workspace__c' AND QualifiedApiName = 'Opportunity__c'].DurableId.substringAfter('.');            
        fieldSfId += durableId;
        
        queryString = '?' + fieldSfId + '=' + recordName + '&' + fieldSfId + '_lkid=' + sObjectId + '&scontrolCaching=1&retURL=%2F' + sObjectId + '&sfdc.override=1'; 
        
        return queryString;
    }
}