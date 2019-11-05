/************************************************************************************************************************************
Name    : MyPartnerContactController
Author  : C360 Dev team
Purpose : Contains logic to execute on fetching contacts to display on Partner Contacts Component
Date    : 24/01/2019
Change History : none
*************************************************************************************************************************************/
public class MyPartnerContactController {
@AuraEnabled
    public static List<Contact> getContactList(List<Id> offerIds) {
        // Getting the list of contacts from where Id is in accountIds
        List<Id> accountIds = new List<Id>();   
        for(Offer__c offerlist:[Select Id,Customer_Name__c from Offer__c where Id in:offerIds]){
            accountIds.add(offerlist.Customer_Name__c);
        }
        List<Contact> contactList = [SELECT Id, Name,FirstName,LastName, Email, Phone, AccountId,Account.Name,Partner_Role__c FROM Contact WHERE AccountId in :accountIds and RecordType.Name like '%Manual Partner%' limit 3];
            // Returning the contact list
            return contactList;
    }
}