/**
 * Class to check user access to an object
 * Expectation is the actual user will be SFDC authenticated and
 * will make the WS call.
 * Created for Quote Collaboration Q2FY10
 * author - cmiura
 * updated - Alekhya for optimization
 */
global class Alekhya_RecordAccess {
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
    public class AccessTest {
        Map<String, String> objMap = new Map<String, String>();

        
        //Method to perform the access check
        public Map<String,String> checkAccess (String obj, List<String> recIds) {
			
            //Check to see if obj is valid
            Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
            if (!gd.containsKey(obj)) {
				for (String item : recIds) {
					objMap.put(item,'Error');
				}
            }
            else {
                List<UserRecordAccess> userAccess = [SELECT RecordId, HasReadAccess, HasEditAccess, MaxAccessLevel	FROM UserRecordAccess 
													where UserId = :UserInfo.getUserId() and RecordId in : recIds];  

				if(userAccess.size()>0){
					for(UserRecordAccess uRA: userAccess){
						if(uRA.HasEditAccess){
							objMap.put(String.valueOf(uRA.RecordId),'Edit');
						}else{
							objMap.put(String.valueOf(uRA.RecordId),uRA.MaxAccessLevel);
						}
					} 
				}else{
					for (String item : recIds) {
						objMap.put(item,'Error');
					}
				}
				
            }

            
		   return objMap;
        }
    }
}