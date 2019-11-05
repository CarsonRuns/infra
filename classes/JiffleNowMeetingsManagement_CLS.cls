/************************************************************************************************************************************
Name    : JiffleMeetingsManagement_CLS
Author  : Mukesh Srivastava
Purpose : This Class is to handle all Jiffle Releated processing required scoped by Trigger
Created Date: 4/15/2015
Modification History: 

*************************************************************************************************************************************/
public class JiffleNowMeetingsManagement_CLS {

    //Collecting all the CEE which need to be updated as per need
    List < CEE__c > lstCEEUpdate = new List < CEE__c > ();

    //@ Method: To Accept all newly created CEE and process as per needed
    // Collecting all Accounts and populating lstCEEUpdate for processing if criteria met
    public void JiffleManagement(List < CEE__c > lstCEE) {

        // Getting Jiffle Record Type
        Id idOfJiffleRec = Schema.SObjectType.CEE__c.getRecordTypeInfosByName().get('Jifflenow (Event, Tradeshow, Conference)').getRecordTypeId();
        Set < Id > setOfAccount = new Set < Id > (); // Set of Account assign to Jiffle Meetings.

        // Looping to validate only Jiffle Records are pulled for processing
        for (CEE__c ceeObj: lstCEE) {
            if (ceeObj.RecordTypeId == idOfJiffleRec) {
                setOfAccount.add(ceeObj.Primary_Account__c);
                lstCEEUpdate.add(ceeObj);
            }
        }
        // Validate if the Set of Account is not empty else stop the processing
        if (!setOfAccount.isEmpty()) {
            JiffleManagementAccountManagement(setOfAccount);
        }
    }

    //@ Method: Process All Jiffle CEE to populate Theater based on Account country
    public void JiffleManagementAccountManagement(Set < Id > setOfAccount) {
        // Query all he accounts which associated with Jiffle Event
        Map < Id, Account > mapAccount = new Map < Id, Account > ();
        Set <String> strCountry = new Set<String>();
        for(Account acc: [Select Id, Country__c from Account where Id IN: setOfAccount]){
            strCountry.add(acc.Country__c);
            mapAccount.put(acc.Id,acc);
        }

        // Map to hold all the country and theater mapping 
        Map < String, NGCC_Mapping_Object__c > mapOfCountryTheater = new Map < String, NGCC_Mapping_Object__c > ();

        // Collecting all Country and theater mapping
        for (NGCC_Mapping_Object__c mpObj: [Select Name, Id, Theater__c from NGCC_Mapping_Object__c WHERE Name IN : strCountry]) {
            mapOfCountryTheater.put(mpObj.Name, mpObj);
        }
        
        // Looping through all the list of CEE and updating Theater
        for (CEE__c ceeObj: lstCEEUpdate) {
            if(mapAccount.get(ceeObj.Primary_Account__c).Country__c != NULL){
                if(mapOfCountryTheater.containsKey(mapAccount.get(ceeObj.Primary_Account__c).Country__c)){
                    ceeObj.Region__c = mapOfCountryTheater.get(mapAccount.get(ceeObj.Primary_Account__c).Country__c).Theater__c;
                }
            }            
        }
    }
}