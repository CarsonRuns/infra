public class lxOptyWorkspaceOverrideController {
@AuraEnabled
    //Use this for running SOQLs and setting up the redirection path.
    //Ensure it has all the params needed for redirection.
    public static String getQueryString(String sObjectId, String objType) {
        String queryString = '';
        String recordName = '';
        
        if(String.isNotBlank(objType) && objType.equalsIgnoreCase('AT_Workspace__c') ){
            
        queryString = '?sfdc.override=1'; 
            
        }
        return queryString;


}
}