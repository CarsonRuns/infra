public class lxAccntLeadContactController {
    @AuraEnabled
    public static String getQueryString(String sObjectId, String objType) {
        String queryString = '';
        String recordName = '';
        
        if(String.isNotBlank(objType) && objType.equalsIgnoreCase('Account') ){
            
        queryString = '?sfdc.override=1'; 
            
        }
        return queryString;


}
}