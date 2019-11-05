public class lxQuoteNewOverride {
	@AuraEnabled
	public static String getQueryString(String sObjectId) {
        String queryString = '';
        String fieldSfId = 'CF';
        String recordName = '';
        
        if(String.isNotBlank(sObjectId) && String.isNotEmpty(sObjectId) && sObjectId != null) {
            system.debug('sobjectId: '+ sObjectId);
            Opportunity oOppty = [SELECT Name FROM Opportunity WHERE Id = :sObjectId];
            recordName = EncodingUtil.urlEncode(oOppty.Name, 'UTF-8');
        }
        
        String durableId = [ SELECT DurableId FROM FieldDefinition WHERE EntityDefinition.QualifiedApiName = 'Quote__c' AND QualifiedApiName = 'Opportunity_Name__c'].DurableId.substringAfter('.');            
        fieldSfId += durableId;
        //Added mode=lgt to send to CCW for navigation back and forth
        queryString = '?' + fieldSfId + '=' + recordName + '&' + fieldSfId + '_lkid=' + sObjectId + '&scontrolCaching=1&retURL=%2F' + sObjectId + '&sfdc.override=1&mode=lgt'; 
        
        return queryString;
    }
}