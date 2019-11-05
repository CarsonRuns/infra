public class lxOptyLinesOverrideCtrl {
    @AuraEnabled
    public static String getQueryString(String sObjectId, String objType) {
        String queryString = '';
        String fieldSfId = 'CF';
        String recordName = '';
        
        if(String.isNotBlank(objType) && objType.equalsIgnoreCase('Lead') ){
            
        queryString = '?' + fieldSfId + '=' + recordName + '&' + fieldSfId + '_lkid=' + sObjectId + '&scontrolCaching=1&retURL=%2F' + sObjectId + '&sfdc.override=1'; 
            
        }
        return queryString;
    }



}