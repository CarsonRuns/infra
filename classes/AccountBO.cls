/************************************************************************************************************************************
Name    : AccountBO
Author  : Bramhananda Naidu Dabbara
Purpose : Contains complete logic for all the events of Account Trigger
Created Date:  7/6/2015
Modification History: Sournaga- Code clean up, Enhancements & Optimization

*************************************************************************************************************************************/

   public  class AccountBO{

     // SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdateGet(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }
     // SCAVA Helper Method to validate Create Access at field level
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }

    /* update the GEO location update of assigned partner acounts when CR Adress is changed */
    public static void accountGeoLocBeforeUpsertBatch(List<Account> accts){
    
        Map<id,account> accMap = new Map<id,account>([select id,
                                                        (SELECT Assigned_Partner__c FROM Assigned_Partners__r)
                                                        FROM Account
                                                        WHERE id in :accts]);
        for(Account acc: accts)
        {
            list<Assigned_Partner__c> tp;
            String addressNew = '';
            String addressOld = '';
            boolean needsUpdate = false;
            if(accMap!=null && accMap.containsKey(acc.id)) {
                tp = accMap.get(acc.id).assigned_partners__r;
            }
            system.debug('CRFLAG>>>>'+acc.CRAdressFlag__c);
            if(acc.CRAdressFlag__c){
            
                addressNew = acc.CRAddressLine1__c + acc.CRAddressLine2__c + acc.CRCity__c + acc.CRState__c + acc.CRZipPostalCode__c + acc.CRCountry__c;
            }
            else{
                addressNew = acc.AddressLine1_English__c+ acc.AddressLine2_English__c + acc.City_English__c
                            + acc.State_Province_English__c + acc.Zip_Postal_Code_English__c + acc.Country_English__c;
            }


            if(trigger.isInsert) {
                needsUpdate = ((!tp.isEmpty()) && (addressNew != ''));
            }
            
            if(trigger.isUpdate) {
                Account beforeUpdate = (Account)Trigger.oldMap.get(acc.Id);

                if(beforeUpdate.CRAdressFlag__c){
                    addressOld = beforeUpdate.CRAddressLine1__c + beforeUpdate.CRAddressLine2__c + beforeUpdate.CRCity__c
                                + beforeUpdate.CRState__c + beforeUpdate.CRZipPostalCode__c + beforeUpdate.CRCountry__c;
                }
                else {
                    addressOld = beforeUpdate.AddressLine1_English__c+ beforeUpdate.AddressLine2_English__c
                                + beforeUpdate.City_English__c + beforeUpdate.State_Province_English__c + beforeUpdate.Zip_Postal_Code_English__c
                                + beforeUpdate.Country_English__c;
                }
                
                //set needUpdate boolean to true if the account has target prospect &  assigned partner's address has been changed
                needsUpdate = (!tp.isEmpty()) && ((addressNew != addressOld) || (acc.Geolocation__Latitude__s == null));
            }

            if(needsUpdate) {
                acc.needs_geolocation_update__c=true;
            }
        }
    }

    //Check if the user has permission to delete the account and display appropriate error mesage configured in Label.
    public static void accountDelete(List<Account> accList) {
        Map<string,string> mpstd=new Map<string,string>();
        String profileId = Userinfo.getProfileId();
        String profileIds  = profileId.substring(0,15);
        string accDeleteId = Utilities.getConstant_CS('ProfileIds_for_Delete');
        string[] accDeleteIds;
        
        if(accDeleteId != null) {
            accDeleteIds= accDeleteId.split(';');
            for(string stIds:accDeleteIds) {
                mpstd.put(stIds,stIds);
            }
        }

        //if the user id does not exist in the map display error msg
        if(!((mpstd.containsKey(profileIds)) || (mpstd.containsKey(profileId)))) {
            for(Account acc: accList) {
                   acc.addError(Label.Account_Delete_Error);
            }
        }
    }
    
    /*This method used to throw the Jigsaw import exception */
    
    /*
    public static void jigsawImport( List<Account> lstAcc) {
    for(Account acc : lstAcc) {
            if(acc.jigsaw_clean__Jigsaw_Id__c != null && acc.jigsaw_clean__Sync_Status__c!=null && acc.jigsaw_clean__Sync_Status__c.equals('I')) {
                throw new jiggy_CustomException(Label.Jigsaw_Exception);
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,Label.Account_Jigsaw_Import_Error);

            }
        }
    }
    */
    
    /* Update Account Potential Dollar value on Account based on the Country, Number of Employees and Industry selected on the record.
    Vertical per head for each country depending on industry is stored in rs_vertical_per_head__C object 
    public static void AccountPotentialDollar(List<Account> lstAcc) {
        // Vertical_Per_Head__c[] rsVerticalPerHead  = OrgHelper.getVerticalPerHead();
        for(Account acc:lstAcc) {
            if(acc.Country__c!=null &&  acc.NumberOfEmployees!=null && acc.Industry !=null) {
            
                for(Integer i=0;i<rsVerticalPerHead.size();i++) {
                
                    if(rsVerticalPerHead[i].Industry__c==acc.Industry) {
                    
                        if(acc.Country__c=='Austria'){ acc.Account_Potential_Dollar__c = acc.NumberOfEmployees  * rsVerticalPerHead[i].Vertical_Per_Head_Austria__c; }
                        if(acc.Country__c=='Belgium'){ acc.Account_Potential_Dollar__c = acc.NumberOfEmployees  * rsVerticalPerHead[i].Vertical_Per_Head_Belgium__c; }
                        if(acc.Country__c=='Denmark'){ acc.Account_Potential_Dollar__c = acc.NumberOfEmployees  * rsVerticalPerHead[i].Vertical_Per_Head_Denmark__c; }
                        if(acc.Country__c=='Finland'){ acc.Account_Potential_Dollar__c = acc.NumberOfEmployees  * rsVerticalPerHead[i].Vertical_Per_Head_Finland__c; }
                        if(acc.Country__c=='France'){ acc.Account_Potential_Dollar__c = acc.NumberOfEmployees  * rsVerticalPerHead[i].Vertical_Per_Head_France__c; }
                        if(acc.Country__c=='Germany'){ acc.Account_Potential_Dollar__c = acc.NumberOfEmployees  * rsVerticalPerHead[i].Vertical_Per_Head_Germany__c; }
                        if(acc.Country__c=='Greece'){ acc.Account_Potential_Dollar__c = acc.NumberOfEmployees  * rsVerticalPerHead[i].Vertical_Per_Head_Greece__c; }
                        if(acc.Country__c=='Ireland'){ acc.Account_Potential_Dollar__c = acc.NumberOfEmployees  * rsVerticalPerHead[i].Vertical_Per_Head_Ireland__c; }
                        if(acc.Country__c=='Israel'){ acc.Account_Potential_Dollar__c = acc.NumberOfEmployees  * rsVerticalPerHead[i].Vertical_Per_Head_Israel__c; }
                        if(acc.Country__c=='Italy'){ acc.Account_Potential_Dollar__c = acc.NumberOfEmployees  * rsVerticalPerHead[i].Vertical_Per_Head_Italy__c; }
                        if(acc.Country__c=='Netherlands'){ acc.Account_Potential_Dollar__c = acc.NumberOfEmployees  * rsVerticalPerHead[i].Vertical_Per_Head_Netherlands__c; }
                        if(acc.Country__c=='Norway'){ acc.Account_Potential_Dollar__c = acc.NumberOfEmployees  * rsVerticalPerHead[i].Vertical_Per_Head_Norway__c; }
                        if(acc.Country__c=='Portugal'){ acc.Account_Potential_Dollar__c = acc.NumberOfEmployees  * rsVerticalPerHead[i].Vertical_Per_Head_Portugal__c; }
                        if(acc.Country__c=='Spain'){ acc.Account_Potential_Dollar__c = acc.NumberOfEmployees  * rsVerticalPerHead[i].Vertical_Per_Head_Spain__c; }
                        if(acc.Country__c=='Sweden'){ acc.Account_Potential_Dollar__c = acc.NumberOfEmployees  * rsVerticalPerHead[i].Vertical_Per_Head_Sweden__c; }
                        if(acc.Country__c=='Switzerland'){ acc.Account_Potential_Dollar__c = acc.NumberOfEmployees  * rsVerticalPerHead[i].Vertical_Per_Head_Switzerland__c; }
                        if(acc.Country__c=='United Kingdom'){ acc.Account_Potential_Dollar__c = acc.NumberOfEmployees  * rsVerticalPerHead[i].Vertical_Per_Head_United_Kingdom__c; }
                    }
                }
            }
            else {
                acc.Account_Potential_Dollar__c = 0;
            }
        }
    }
    */
    
    /* Update Jabber phone value based on Account Phone Number */
    public static void jabberPhoneClean(Map<id,sobject> oldAccMap, List<Account> lstAcc) {
        JabberPhoneCleanUpcls jPhoneClean= new JabberPhoneCleanUpcls();
        List<Account> newAccountUpdate = new List<Account>();
        for(Account acc: lstAcc) {
            Account oldAcc = (Account)oldAccMap.get(acc.ID);
            if (acc.Phone != oldAcc.Phone || acc.CRCountry__c != oldAcc.CRCountry__c || acc.Jabber_Phone_Number__c == null || acc.Jabber_Phone_Number__c == '') {
                newAccountUpdate.add(acc);
            }
        }
        
        if(!newAccountUpdate.isEmpty()) {
            jPhoneClean.JabberAccountPhoneClean(newAccountUpdate);
        }
    }

    /* Recalculate Partner sharing on Account if the Account Owner is changed */
    public static void P360PartnerResharing(Map<id,sobject> oldAccMap, List<Account> lstAcc) {
        Map<id,Account> oldMpAccounts = new Map<id,Account>();
        if(!Partner360Utils.skip_P360_Partner_Resharing_On_OwnerChange) {
            Set<Id> AccountIds = new Set<Id>();
            ObjectRecordTypeIds__c o = ObjectRecordTypeIds__c.getInstance();
            
            String ACCOUNT_END_USER_RecTypeId = o.Account_End_User_RecordTypeId__c;
            for(Account a: lstAcc) {
            
                Account acOld = (Account)oldAccMap.get(a.id);
                if(a.RecordTypeId == ACCOUNT_END_USER_RecTypeId  && a.ownerId != acOld.ownerId) {
                    AccountIds.add(a.Id);
                }
                
                oldMpAccounts.put(a.id,acOld );
            }
            
            //Calculate partner account resharing for the accounts where owner is changed
            if(!AccountIds.isEmpty()) {
                P360_Partner_Resharing.Partner_Resharing_On_OwnerChange(AccountIds);
            }
            
            if(!Test.isRunningTest() && trigger.isUpdate) {
                // Mark static variable true to skip execution of trigger twice.
                Partner360Utils.skip_P360_Partner_Resharing_On_OwnerChange = true;  
            }
        }
        
        //if (!P360_TP_Created_Basedon_CI_Allocation.hasAlreadyUpdatedFollowUpTasks()) {
        //    P360_TP_Created_Basedon_CI_Allocation.setAlreadyUpdatedFollowUpTasks();
        //    P360_TP_Created_Basedon_CI_Allocation.onCreationAndUpdation(lstAcc, oldMpAccounts);
        //}
    }

    /* When a Channel Account record is deactivated, status associated with the Account record is updated to Inactive and the Account team is deleted.
       Similarly if a Channel Account record status is set to Active(Registered), status of the associated Contacts are updated as Active */
    public static void channelAccountandContactSync(Map<id,sobject> oldAccMap, List<Account> lstAcc) {
        Set<ID> accountsInactive = new set<ID>();
        Set<ID> accountsActive = new Set<ID>();
        AccountTeamMember[] acctTeamToDelete = new AccountTeamMember[]{};
        List<Contact> lstConToUpdate=new List<Contact>();
        Set<Id> setAccountId=new Set<Id>();
        JabberPhoneCleanUpcls jPhoneClean= new JabberPhoneCleanUpcls();
        Contact[] contactsToUpdate = new Contact[]{};
        
        for(Account a:lstAcc) {
            Account acsOld = (Account)oldAccMap.get(a.id);
            if(a.CRCountry__c != acsOld.CRCountry__c) 
            {
                setAccountId.add(a.Id);
            }
            
            //List of accounts where status is changed from active to inactive
            if(a.recordTypeId == Utilities.getAccountChannelRecordTypeId() && a.Partner_Account_Status__c != 'Active (Registered)' 
                && acsOld.Partner_Account_Status__c == 'Active (Registered)') 
            {
                //List of accounts where status is changed from inactive to active
                accountsInactive.add(a.id);
            } 
            else if(a.recordTypeId == Utilities.getAccountChannelRecordTypeId() && a.Partner_Account_Status__c == 'Active (Registered)' 
                      && acsOld.Partner_Account_Status__c != 'Active (Registered)') 
                {
                       accountsActive.add(a.id);
                }
        }
        
        if(!accountsInactive.isEmpty() || !accountsActive.isEmpty()) {
            List<Contact> con =[Select Id, ownerId, AccountId, Account.ownerId, OldContactOwnerBeforeDeletion__c, OldAccountNameBeforeDeletion__c, OldContactOwnerBeforeDeletion__r.IsActive 
                                From Contact 
                                Where AccountId IN :accountsInactive OR AccountId IN:accountsActive ];
            for(Contact c:con) {
                //change status of contacts associated with inactive accounts to inactive
                if(accountsInactive.contains(c.AccountId)) {
                    if(flsUpdateGet(Contact.OldContactOwnerBeforeDeletion__c)||flsGet(Contact.OldContactOwnerBeforeDeletion__c)) //SCAVA FIX
                    {
                    c.OldContactOwnerBeforeDeletion__c=c.ownerId;
                    }
                    if(flsUpdateGet(Contact.OldAccountNameBeforeDeletion__c)||flsGet(Contact.OldAccountNameBeforeDeletion__c)) //SCAVA FIX
                    {
                    c.OldAccountNameBeforeDeletion__c=c.AccountId;
                    }
                    c.ownerId=Utilities.getIntegrationUserId();
                    if(flsUpdateGet(Contact.ContactStatus__c)||flsGet(Contact.ContactStatus__c)) //SCAVA FIX
                    {
                    c.ContactStatus__c='Inactive';
                    }
                    contactsToUpdate.add(c);
                }

                if(accountsActive.contains(c.AccountId)) {
                    if( c.OldContactOwnerBeforeDeletion__c != null) {
                        if(c.OldContactOwnerBeforeDeletion__r.IsActive) {
                    if(flsUpdateGet(Contact.ownerId)||flsGet(Contact.ownerId)) //SCAVA FIX
                    {
                            c.ownerId=c.OldContactOwnerBeforeDeletion__c;
                    }
                        }
                    else {
                    if(flsUpdateGet(Contact.ownerId)||flsGet(Contact.ownerId)) //SCAVA FIX
                    {
                            c.ownerId=c.Account.ownerId;
                    }
                        }
                    }
                    
                    if(c.OldAccountNameBeforeDeletion__c != null) {
                    
                    if(flsUpdateGet(Contact.AccountId)||flsGet(Contact.AccountId)) //SCAVA FIX
                    {
                    c.AccountId=c.OldAccountNameBeforeDeletion__c;
                    }
                    }
                    c.ContactStatus__c='Active';
                    contactsToUpdate.add(c);
                }
            }

            //Delete account team associated with inactive accounts
            acctTeamToDelete = [Select Id From AccountTeamMember Where AccountId IN :accountsInactive];
            
        }
        
        if(!contactsToUpdate.isEmpty())
        {
            Update contactsToUpdate;
        }
        
        //Delete the Account Team when Account status is set to Inactive
        //SCAVA FIX
        
        if(!acctTeamToDelete.isEmpty())
        {
            //SCAVA FIX
            if (AccountTeamMember.sObjectType.getDescribe().isDeletable())
               {
                    Delete acctTeamToDelete;
                }
        }
        
        
        //Jabber phone clean up to remove any alphabetic values.
        if(!setAccountId.isEmpty()) {
            lstConToUpdate=[Select Id,Phone,AccountId,Jabber_Phone_Number__c  from Contact where AccountId IN : setAccountId];
            boolean accContactsUpdate=true;
            jPhoneClean.JabberContactPhoneClean(lstConToUpdate,accContactsUpdate);
        }
    }
}