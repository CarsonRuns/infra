/**************************************
Author          : Awnish Kumar
Release         : March Release
Created         : Feb,2019
Functionality   : This is controller class for ReUsableMultiSelectLookUp component

Modification History:
Itrack#        Date        Author              Change
****************************************************************************/
public class ReUsableMultiSelectLookup_CTL {
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName, List<sObject> ExcludeitemsList) {
        String searchKey = '%' + searchKeyWord + '%';
        List < sObject > returnList = new List < sObject > ();
 
        List<string> lstExcludeitems = new List<string>();
        System.debug('ExcludeitemsList'+lstExcludeitems);
        for(sObject item : ExcludeitemsList ){
            lstExcludeitems.add(item.id);
        }
        
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5 and exclude already selected records  
        String sQuery =  'select Id, Name, Email from ' +ObjectName + ' where (Name LIKE: searchKey OR Email LIKE: searchKey) AND Id NOT IN : lstExcludeitems order by Name DESC limit 5';
            List < sObject > lstOfRecords = Database.query(sQuery);
        List<sObject> contactLst = [SELECT Id, Name, Email FROM Contact WHERE (Name LIKE:searchKey OR Email LIKE: searchKey) AND Id NOT IN : lstExcludeitems AND Email!= null order by Name DESC limit 5];
                
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        
        for (sObject obj: contactLst) {
            returnList.add(obj);
        }
        System.debug('returnList>>'+returnList);
        return returnList;
    }
}