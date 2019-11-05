/**
 * Class to check user access to an object
 * Expectation is the actual user will be SFDC authenticated and
 *   will make the WS call.
 * Created for Quote Collaboration Q2FY10
 * author - cmiura
 */
global class RecordAccess {
    /**
     * Returns the access that a user has to a record
     * param obj - the SFDC object name (e.g. Opportunity)
     * param recId - The Id for the record (case-sensitive)
     * output - Error|None|Read|Edit
     */
    WebService static String check(String obj, String recId) {
        List<String> recIds = new List<String>();
        recIds.add(recId);
        AccessTest a = new AccessTest();
        Map<String, String> m = a.checkAccess(obj, recIds);
        return m.get(recId);
    }

    /**
     * Returns the access that a user has to a list of records
     * param obj - the SFDC object name (e.g. Opportunity)
     * param recIds - a List/Array(Java) of record Ids to check (case-sensitive)
     * output - XML string containing elements of Id and Access.
     * Access values are Error|None|Read|Edit
     */
    WebService static String checkMultiple(String obj, List<String> recIds) {
        AccessTest a = new AccessTest();
        return xmlOut(a.checkAccess(obj, recIds));
    }

    /**
     * Helper method to format the output in and XML string
     */
       private static String xmlOut(Map<String,String> m) {
           String outVal='<AccessResults>';
           for (String key : m.keySet()) {
               outVal += '<Id>'+key+'</Id><Access>'+m.get(key)+'</Access>';
           }
           outVal+='</AccessResults>';
           return outVal;
       }
    /**
     * Inner class with 'with sharing' applied
     * Sharing rules will be applied when executing the SOQL
     * Same visibility/access rules should apply as through the native UI
     */
    public with sharing class AccessTest {
        Map<String, String> objMap = new Map<String, String>();

        //Update Map with String List items
        private void updateMapStr(List<String> l, String newAccess) {
            for (String item : l) {
                objMap.put(item, newAccess);
            }
        }
        //Update Map with sObject List items 
        private void updateMapSObj(List<sObject> l, String newAccess) {
            for (sObject item : l) {
                updateMapStrId(String.valueOf(item.Id),newAccess);
            }
        }
        /**
         * Helper method to update the Map
         * Handles both short and long Ids
         * e.g. if user sends 15-character, SOQL lookup returns 18-character
         * but we don't want both in the Map only the original
         */ 
        private void updateMapStrId(String idStr, String newAccess) {
            String idStrShort = idStr.substring(0,15);
            if (objMap.containsKey(idStr)) {
                objMap.put(idStr, newAccess);
            }
            else if (objMap.containsKey(idStrShort)) {
                objMap.put(idStrShort, newAccess);
            }
        }
        //Method to perform the access check
        public Map<String,String> checkAccess (String obj, List<String> recIds) {
            //Define variables
            sObject[] o;
            
            //Check to see if obj is valid
            Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
            if (!gd.containsKey(obj)) {
                updateMapStr(recIds, 'Error');
                return objMap;
            }
            else {
                updateMapStr(recIds, 'None');                
            }

            //Try to fetch the object record - test Read access
            try {
                String q = 'Select Id from '+obj+' where Id in :recIds';
                o = Database.query(String.escapeSingleQuotes(q));
                updateMapSObj(o, 'Read');
            }
            //If there is an exception, return the access
            catch (Exception e){
                return objMap;
            }
            //If fetch was successful, try to update the object record - test Write access
            try {
                //Set Savepoint so transaction can be rolled back
                Savepoint sp= Database.setSavepoint();
                
                //Skip business rule validations
                //Don't want expections to be triggered if missing data.
                Utilities.setSkip(true);
                Utilities.setValidationSkip(true);
                Utilities.setSkipFuture(true);
                
                List<Database.SaveResult> srs = Database.update(o);
                for (Database.SaveResult sr : srs) {
                    if(sr.isSuccess()) {
                    	//id id1 = userinfo.getProfileId();
                    	//Profile p = [select Name from profile where id = :id1];
                    	//Schema.DescribeSObjectResult r = Opportunity.sObjectType.getDescribe();
                    	
                        //updateMapStrId(String.valueOf(sr.getId()), 'Edit:'+r.isUpdateable());
                        updateMapStrId(String.valueOf(sr.getId()), 'Edit');
                    }
                }
                
                //If update was successful, rollback transaction
                Database.rollback(sp);
            }
            //Exception is thrown if no Write access
            //But processing will not stop.
            catch (System.Dmlexception e){
                for (Integer i = 0; i < e.getNumDml(); i++) {
                    //If the DML Exception was due to lack of access, update the Map
                    //Schema.DescribeSObjectResult r = Opportunity.sObjectType.getDescribe();
                    Schema.DescribeSObjectResult r = Schema.getGlobalDescribe().get(obj).getDescribe();
                    
                    if (e.getDmlStatuscode(i) == 'INSUFFICIENT_ACCESS_OR_READONLY') {
                    // || e.getDmlStatuscode(i) == 'CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY') {
                        //updateMapStrId(e.getDmlId(i), objMap.get(e.getDmlId(i))+'-Read-'+e.getDmlStatuscode(i));
                        updateMapStrId(e.getDmlId(i), 'Read');
                    }
                    else if (!r.isUpdateable()) {
                    	//updateMapStrId(e.getDmlId(i), objMap.get(e.getDmlId(i))+'-Read*-'+e.getDmlStatuscode(i));
                    	updateMapStrId(e.getDmlId(i), 'Read');
                    }
                    //Any other exception - assume the user has Edit access, but some other validation failed
                    else {
                        updateMapStrId(e.getDmlId(i), 'Edit');
                    }
                }
            }
            //If there is an exception, return the access
            catch (Exception e){
                //Need to uncomment this if any additional logic is added after
                //this try/catch block
                //return objMap;
            }
               return objMap;
        }
    }
}