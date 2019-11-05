/* Trigger that updates the lead record based on the response object
 * @author: Daniel Pisciottano
 * @created date: March 28, 2014
 *
 * @updated: April 8, 2014 Ramzil Cleopas
 *            Added the condition so that the trigger doesnt fire every time
 * @updated: April 8, 2014 Daniel Pisciottano 
 *            fixed code to build list of CC_Responses__c in for loop to then send the list to the NGCC_UpdateLeadAttributes method
*/
trigger NGCC_UpdateLeadAttributes on CC_Response__c (after update,after insert) { 
    List<CC_Response__c> responseList = new List<CC_Response__c>();
    
    for(CC_Response__c response : Trigger.new){
        if(response.Call_Status__c != null && response.Call_Status__c != ' '){ 
            responseList.add(response);
        }
    }
    if(!responseList.isEmpty()){
        NGCC_Update_Lead_Attributes.UpdateLeadAttributes(responseList);
    }
}