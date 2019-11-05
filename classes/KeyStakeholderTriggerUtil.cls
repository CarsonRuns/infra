/*
  Name        : KeyStakeholderTriggerUtil
  Author      : Serge Borysov (sborysov)
  Release     : 1.0
  Functionality   : Utility class containing the primary logic for determening whether primary contact is already set
  Created      : June 13 2019
  
  Modification History:
  Date    Author      Change 
*/

public class KeyStakeholderTriggerUtil {
    
    public static void primaryContactExists(List<Key_Stakeholders__c> stakeholderList){
        
        List<Key_Stakeholders__c> newPrimaryCandidates = new List<Key_Stakeholders__c> ();
        Set<Id> newPrimaryCandidateIds = new set<Id>(); 
        //subset to minimize query
        for(Key_Stakeholders__c ks : stakeholderList){
            // BU's only
            if(ks.Primary_Contact__c == true && ks.Business_Unit_Account__c != null){
                newPrimaryCandidates.add(ks);
                newPrimaryCandidateIds.add(ks.Business_Unit_Account__c);
            }
        }
        
        if (newPrimaryCandidates.size() > 0){
            // get list of BU Accounts that already have a primary stakeholder
            List<Key_Stakeholders__c> currentPrimaries = new List<Key_Stakeholders__c> ();
            currentPrimaries = [SELECT Id, Business_Unit_Account__c 
                                FROM Key_Stakeholders__c 
                                WHERE Business_Unit_Account__c =: newPrimaryCandidateIds 
                                AND Primary_Contact__c = true 
                                AND Id NOT in :newPrimaryCandidates];

            // check that every candidate's account does not already have a primary stakeholder
            for (Key_Stakeholders__c candidate: stakeholderList){
                for (Key_Stakeholders__c primary: currentPrimaries){
                    if (primary.Business_Unit_Account__c == candidate.Business_Unit_Account__c){
                       candidate.addError('To mark this key stakeholder as the primary contact, please remove your current primary contact first');
                    }
                }
            }
        }
    }
}