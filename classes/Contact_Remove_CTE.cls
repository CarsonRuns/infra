/************************************************************************************************************************************
Name        : Contact_Remove_CTE
Author      : Suresh
Purpose     : MassDelete Method added
Created Date: 01-2702105
Modified By : Thejaswini - US9583 - Fix the System.Limit Exception for deleting 200 Contacts
09/20 Manju WR-0725 - Updated the logic to include Admin ID to delete the Contacts.
*************************************************************************************************************************************/

global without sharing class Contact_Remove_CTE { 
String host;
String redirectURL;
String dummyEndUserAccountId;   // Id of the dummy end user account
String dummyChannelAccountId;   // Id of the dummy channel account
Contact contactToDelete;        // contact being deleted
String ContactId = ApexPages.currentPage().getParameters().get('Id');
public String ErrorContent{get;set;}
public PageReference getPageref(){
    PageReference pageref = new PageReference('/'+ContactId);
    return pageref;
}

// Constructor
public Contact_Remove_CTE(ApexPages.StandardController controller) {  
    dummyEndUserAccountId = Utilities.getConstant_CS('Contact_Delete_EndUserAccountID');
    dummyChannelAccountId = Utilities.getConstant_CS('Contact_Delete_ChannelPartnerAccountID'); 
    host  = ApexPages.currentPage().getHeaders().get('Host'); 
    redirectURL = '/003/o';



}
/************************************************************************************************************************
 * MassDelete methods for Contact_Remove_CTE .cls
 * Use case is Delete multiple contacts from listview
 * Created for WR-00899 Multi pick to delete contacts
 * Release -- FY'15 Release
 * author - Suresh
 * modified by - Thejaswini

 *************************************************************************************************************************/

WebService static string massDelete(id[] records) {
    String dummyEndUserAccountId = Utilities.getConstant_CS('Contact_Delete_EndUserAccountID');
    String dummyChannelAccountId = Utilities.getConstant_CS('Contact_Delete_ChannelPartnerAccountID'); 
    String finalString = '';
    set<Contact> ErrorIds = new set<Contact>();
    set<Contact> succesIds = new set<Contact>();    
    Set<ID> accountIDs = new Set<ID>{dummyEndUserAccountId,dummyChannelAccountId};
    List<Account> accountLst = new List<Account>();
    Map<ID, ID> accountOwnerMap = new Map<ID, ID>();
    ID currentUserID = UserInfo.getUserId();
    //US9583 - Updated to fix the System.Limit exception    
    if(!records.isEmpty()) {
    List<Contact> contactToDelete = [Select Id, c.AccountId, c.OwnerId, c.Account.RecordTypeId,c.RecordTypeId, c.Owner.ProfileId  from Contact c where Id in :records ];
    accountLst = [select OwnerId from Account where Id in :accountIDs];
    for(Account acc: accountLst){
        if(accountLst.size() > 0){
            accountOwnerMap.put(acc.ID, acc.OwnerID);
        }
    }
    if(Utilities.getConstant_CS('Contact_Delete_UserID').contains(currentUserID)){
        Database.DeleteResult[] drList = Database.delete(contactToDelete, false);
            for (Database.DeleteResult dr : drList) {
                if (!dr.isSuccess()){
                    for(Database.Error err : dr.getErrors()) {
                        finalString = 'Unable to delete the Contacts.';
                    }
                } else {
                    finalString = 'Contacts are deleted successfully.';
                }
            }
        } else {
            for(Contact cts:contactToDelete){
                if(cts.RecordTypeId == (String) Id.valueOf(Utilities.getContactPDBContactRecordTypeId())){
                ErrorIds.add(cts);
                }
                else
                {
                    if(cts.RecordTypeId == (String) Id.valueOf(Utilities.getContactManualEndUserRecordTypeId()))
                    {
                       cts.AccountId = dummyEndUserAccountId;  
                        cts.ownerid = accountOwnerMap.get(dummyEndUserAccountId);
                        succesIds.add(cts);
                    } else {     
                        cts .AccountId = dummyChannelAccountId; 
                        cts.ownerid = accountOwnerMap.get(dummyChannelAccountId);
                        succesIds.add(cts);     
                    }
                    cts.OldContactOwnerIdBeforeDeletion__c  = cts.OwnerId ;
                    cts.OldAccountIdBeforeDeletion__c   = cts.AccountId; 
                    cts.ContactStatus__c = 'Inactive';             
                }
            }   
             try
            {
                  update contactToDelete;
                  string s1 = '';
                  string s2 = '';
                  if(!succesIds.isEmpty())
                    s1 =succesIds.size() +' Contact(s) delete successfully.\n';
                  if(!ErrorIds.isEmpty())
                    s2 = ErrorIds.size()+' Contact(s) are not deleted due to the reason: \n - Partner Provided Contact cannot be deleted';

                  finalString = s1+s2;
                  //return true;
                }
                catch (exception e)
                {
                    finalString = e.getMessage();
                    //return false;
                } 
        }
    }
    return finalString;

}   
    //Single contact delete
    public PageReference start()
    {
    // get the contact record type and contact account record type
    contactToDelete = [Select Id, c.AccountId, c.OwnerId, c.Account.RecordTypeId,c.RecordTypeId, c.Owner.ProfileId from Contact c where Id = :ContactId limit 1];
    // Convert the userID to 18 Digit.                          
    ID currentUserID = UserInfo.getUserId();

    //If userID exists in Custom Setting configuration, allow Contact Delete. Else perform soft delete action based on record type.
    if(Utilities.getConstant_CS('Contact_Delete_UserID').contains(currentUserID)){
    // Database.DeleteResult dr = Database.delete(contactToDelete, false);
    //SCAVA FIX
    if(contact.sobjecttype.getDescribe().isDeletable())
    {
            Database.DeleteResult dr = Database.delete(contactToDelete, false);
            
                if (!dr.isSuccess()){
                    for(Database.Error err : dr.getErrors()) {
                        ErrorContent = 'Unable to delete the Contact. Please contact GSTS.';
                    }
                    }
                }
        PageReference ref = new PageReference(redirectURL);
        return ref;
        } else {
                    //Contact Record Type = Partner Provided Contact
                    if (contactToDelete.RecordTypeId == Utilities.getContactPDBContactRecordTypeId())   
                    {
                            ErrorContent = 'You cannot delete a Partner Provided Contact.';     
                            return null;        
                    }

                    //Contact Record Type = Partner Provided Contact
                    /*if (contactToDelete.RecordTypeId == Utilities.getConstant_CS('CX_Internal_Contact_RecordTypeID'))
                    {
                        ErrorContent = 'You cannot delete a CX Internal Contact.';
                        return null;
                    }*/
                    else
                    {
                        /* If contact RecordType other than Partner Provided Contact, then - 
                           a. Move the contact to the respective dummy enduser/channel account
                           b. Set the OldContactOwnerIdBeforeDeletion__c with the current Contact.OwnerID
                           c. Set the OldAccountIdBeforeDeletion__c with the the current Contact.AccountID
                           d. Make the contact status as Inactive
                           e. Set Contact.Contact_Delete_Date__c to current time of deletion.
                        */
                        // Contact Record Type = End Customer Contact, assign it to dummyEndUserAccountId and its Owner.
                        if(contactToDelete.RecordTypeId == Utilities.getContactManualEndUserRecordTypeId())
                        {
                            if(flsUpdateGet(Contact.AccountId)){
                            contactToDelete.AccountId = dummyEndUserAccountId; 
                            }
                            if(flsUpdateGet(Contact.ownerid)){
                            contactToDelete.ownerid = [select OwnerId from Account where Id  = :dummyEndUserAccountId].OwnerId;         
                            }
                        }
                        // Contact Record Type = Manual Partner Contact, assign it to dummyChannelAccountId and its Owner.
                        else if(contactToDelete.RecordTypeId == Utilities.getContactManualPartnerRecordTypeId())    
                        {
                            contactToDelete.AccountId = dummyChannelAccountId; 
                            contactToDelete.ownerid = [select OwnerId from Account where Id  = :dummyChannelAccountId].OwnerId; 
                        }

                        // Common updates for End Customer and Manual Partner Contacts.
                         
                        if(flsUpdateGet(Contact.OldContactOwnerIdBeforeDeletion__c)){
                        contactToDelete.OldContactOwnerIdBeforeDeletion__c  = contactToDelete.OwnerId ;
                        }
                        if(flsUpdateGet(Contact.OldAccountIdBeforeDeletion__c)){
                        contactToDelete.OldAccountIdBeforeDeletion__c   = contactToDelete.AccountId;
                        }
                        if(flsUpdateGet(Contact.ContactStatus__c)) {
                        contactToDelete.ContactStatus__c = 'Inactive';
                        }
                        if(flsUpdateGet(Contact.Contact_Delete_Date__c)){
                        contactToDelete.Contact_Delete_Date__c = Datetime.now();             
                        }
                        Database.SaveResult sr = Database.update(contactToDelete, false);
                            if (!sr.isSuccess()){
                                for(Database.Error err : sr.getErrors()) {
                                    ErrorContent = 'Unable to delete the Contact. Please contact GSTS.';
                                }
                            }
                    }

                PageReference ref = new PageReference(redirectURL);
                return ref;

                }
    }
     // SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdateGet(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }
}