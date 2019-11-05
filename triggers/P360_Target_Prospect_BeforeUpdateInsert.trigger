trigger P360_Target_Prospect_BeforeUpdateInsert on Assigned_Partner__c (Before Update, Before Insert) {
System.debug('TP Before Update Insert Trigger');   
/*  Created as part of P360 Mar '12 Release.(Combined P360_UpdatePSR_APFields and P360_AssignedPartner_BeforeUpdate and P360_PartnerTargetProspectUpload  old triggers)
        1. Update Main PSR Lookup fields with the ID in the shadow PSR fields if any.
        2. Populate logged in user in PSR 1 lookup field if it is PA and he changes the Partner Status to - 'Actively Working'
        3. Make PSR_Assigned_Date_Time__c --> Now(), isPSRAssigned__c-->TRUE for case mentioned in the Point 2.
        4. When Target Prospect is activated then update Partner_Assigned_Date__c , Partner_Status__c,isPSRAssigned__c,Rejected_Reason__c accordingly.
        5. When Target Prospect is deactivated then update Partner_Status__c,Rejected_Reason__c.
        6. When Partner Generated Target Prospect is deactivated then release the Red Account back to Unallocated pool.
        7. When partner assignment has been rejected then deactivate the target prospect.
        8. Manage name of target prospect.  
        9. Manage Expiration Date.
    
        Partner Generated Target Prospect creation changes
        1. Make Primary Cisco Contact of Partner TBM_TAM__c and Owner of Target Prospect. 
        2. Remove account from Unallocated pool(Update the End Customer Account for Release_to_Unallocated_Pool__c as 'No')
        3. Validation for maximum number of Active Uncovered Propects by Partner.
        4. Activate Target Prospect and update Partner_Assigned_Date__c accordignly.
*/

// do not use static flag as this prevents logic from running in case of batch insert/update failures    
//if(!Partner360Utils.skip_P360_Target_Prospect_BeforeUpdateInsert) // Execute the trigger code only once. Variable defined in Partner360Utils class.
//{

    String usrIdPrefix = '005';
    User userObj =  [Select Id, Name,Contactid,Contact.Account.Primary_Cisco_Contact__c, UserRole.Name From User Where Id =:userinfo.getuserId()];
    Set<Id> AccountIdsToRelease = new Set<Id>();
    Set<Id> AllaccountIds = new Set<Id>();
    String PartnerUser = Partner360Utils.PARTNER_USER; //Partner User identifier.
    String ProspectUpload = 'Initial Expiration with Prospect Upload';
    String PartnerProspectDefault =  'Partner Created Target Prospect Default' ;
    
    //Dummy user created to make owner of target prospect when there is no priamry cisco contact defined for partner.
    Id UnknownTxM_UserId =  Utilities.getConstant_CS('P360_UnknownTxM_UserId'); 
    Set<Id> AccountIdsToRemove = new Set<Id>();
    String DefaultProspectExtnForPartner = Utilities.getConstant_CS('P360_DefaultProspectExtnForPartner');
        
    //Maximum number of active uncovered prospects partner can work at time.
    String MaxAllowedAccounts = Utilities.getConstant_CS('P360_AccountLimit_ForPartner');
    String ErrorMessage = 'Your company has reached the maximum number of prospects that can be active for uncovered accounts.';
    Integer i = 0; 
    
    if(UserInfo.getUserType()== PartnerUser) //If logged in user is partner user.
    {
        //find out number of unique Red/Uncoverd accounts where partner has active partner generated target prospect.
        List<AggregateResult> UncoveredAccounts = new List<AggregateResult>(
                                                 [SELECT Assigned_Partner__c, count_distinct(Customer_Account__c) FROM Assigned_Partner__c
                                                 where
                                                 Assigned_Partner__c = :userObj.Contact.AccountId and
                                                 Target_Prospect_Source__c ='Partner' and Customer_Account__r.Unallocated_Account__c ='Yes' and
                                                 Assignment_Activated__c = True GROUP BY Assigned_Partner__c]);
                                                                                        
        if(UncoveredAccounts.size() != 0 )
        i = Integer.valueof(UncoveredAccounts[0].get('expr0'));                             
    }
        
    for(Assigned_Partner__c apObj: Trigger.new)
    {
        if(Trigger.isInsert)
        {
            if(UserInfo.getUserType()== PartnerUser) //If logged in user is partner user.
                {                       
                    System.debug('apObj.Partner_Status__c');
                    System.debug(apObj.Partner_Status__c);
                    if(i == 0 || i < Integer.valueOf(MaxAllowedAccounts))  // Allow Target prospect creation if count is withiin the limit.
                    {                                                                           
                            if(apObj.Customer_Account__c != null && apObj.Target_Prospect_Source__c == 'Partner')
                            {
                               AccountIdsToRemove.add(apObj.Customer_Account__c);
                               apObj.Assignment_Activated__c = true;  // Activate target prospect.
                               apObj.extend_By__c = DefaultProspectExtnForPartner ;
                               apObj.Extension_Reason__c  = PartnerProspectDefault;
                               
                               //Make Primary Cisco Contact of Partner TBM_TAM__c and Owner of Target Prospect.
                               if(userObj.ContactId != null && userObj.Contact.Account.Primary_Cisco_Contact__c != null)
                               {
                                 apObj.OwnerId = userObj.Contact.Account.Primary_Cisco_Contact__c;
                                 apObj.TBM_TAM__c = userObj.Contact.Account.Primary_Cisco_Contact__c;                                
                               }
                               // //Make Dummy User owner of target prospect when there is no priamry cisco contact defined for partner.
                               else
                               {
                                 apObj.OwnerId = UnknownTxM_UserId;
                                 apObj.TBM_TAM__c = UnknownTxM_UserId;
                               }           
                           }    
                                                                        
                    }                       
                    else
                    {
                            apObj.addError(ErrorMessage);
                        
                    }
                }
                if(apObj.Assigned_PSR_SYS1__c != null && apObj.Assigned_PSR_SYS1__c.subString(0, 3) == usrIdPrefix)
                {
                    apObj.Assigned_Partner_Sales_Rep__c = apObj.Assigned_PSR_SYS1__c;
                }            
                if(apObj.Assigned_PSR_SYS2__c != null && apObj.Assigned_PSR_SYS2__c.subString(0, 3) == usrIdPrefix)
                {
                    apObj.Assigned_Partner_Sales_Rep_2__c = apObj.Assigned_PSR_SYS2__c;
                }            
                if(apObj.Assigned_PSR_SYS3__c != null && apObj.Assigned_PSR_SYS3__c.subString(0, 3) == usrIdPrefix)
                {
                    apObj.Assigned_Partner_Sales_Rep_3__c = apObj.Assigned_PSR_SYS3__c;
                }
                if(apObj.Assignment_Activated__c)
                {
                    apObj.Partner_Assigned_Date__c = System.now();
                    if(apObj.Partner_Status__c == null || apObj.Partner_Status__c == Partner360utils.PARTNER_STATUS_ASSIGNED_NEW)
                        apObj.Partner_Status__c = Partner360utils.PARTNER_STATUS_PARTNER_ASSIGNED;
                }           
                if(apObj.Assigned_Partner__c != null)
                {
                    AllaccountIds.add(apObj.Assigned_Partner__c);
                }
                if(apObj.Customer_Account__c !=null)
                {
                    AllaccountIds.add(apObj.Customer_Account__c);        
                } 
                if(UserInfo.getUserType()!= PartnerUser)
                {
                    apObj.Extension_Reason__c  = ProspectUpload;
                }
        }
        
        else if(Trigger.isUpdate)
        {
            Assigned_Partner__c apObjOld = System.trigger.oldMap.get(apObj.Id);            
            //sync SCP_Partner_Status__c with Partner_Status__c;
            if(apObj.SCP_Partner_Status__c != null && apObj.SCP_Partner_Status__c != apObjOld.SCP_Partner_Status__c){
	            apObj.Partner_Status__c = apObj.SCP_Partner_Status__c;
	        }
            
            //Populate PA user in PSR 1 lookup field when PA changes the Partner Status to - 'Actively Working'. 
            if(apObjOld.Partner_Status__c == 'Partner Assigned' && apObj.Partner_Status__c == 'Actively Working' && userObj.UserRole.Name.contains('Partner Executive'))
            {
                    apObj.Assigned_Partner_Sales_Rep__c = userObj.Id;
                    apObj.PSR_Assigned_Date_Time__c = system.now();
                    apObj.isPSRAssigned__c = True;
                    apObj.Assigned_PSR_SYS1__c = userObj.Name;
            }
            
            if((apObj.Assigned_PSR_SYS1__c != null && apObj.Assigned_PSR_SYS1__c.subString(0, 3) == usrIdPrefix && apObjOld.Assigned_PSR_SYS1__c != apObj.Assigned_PSR_SYS1__c)
                || (apObj.Assigned_PSR_SYS1__c == null && apObjOld.Assigned_PSR_SYS1__c != null))
            {
                apObj.Assigned_Partner_Sales_Rep__c = apObj.Assigned_PSR_SYS1__c;
            }
            
            if((apObj.Assigned_PSR_SYS2__c != null && apObj.Assigned_PSR_SYS2__c.subString(0, 3) == usrIdPrefix && apObjOld.Assigned_PSR_SYS2__c != apObj.Assigned_PSR_SYS2__c)
                || (apObj.Assigned_PSR_SYS2__c == null && apObjOld.Assigned_PSR_SYS2__c != null))
            {
                apObj.Assigned_Partner_Sales_Rep_2__c = apObj.Assigned_PSR_SYS2__c;
            }
            
            if((apObj.Assigned_PSR_SYS3__c != null && apObj.Assigned_PSR_SYS3__c.subString(0, 3) == usrIdPrefix && apObjOld.Assigned_PSR_SYS3__c != apObj.Assigned_PSR_SYS3__c)
                || (apObj.Assigned_PSR_SYS3__c == null && apObjOld.Assigned_PSR_SYS3__c != null))
            {
                apObj.Assigned_Partner_Sales_Rep_3__c = apObj.Assigned_PSR_SYS3__c;
            }
            
            //if((apObj.Assignment_Activated__c != apObjOld.Assignment_Activated__c) && apObj.Assignment_Activated__c && (apObj.Assign_Recommended_PSR__c == apObjOld.Assign_Recommended_PSR__c) && !apObj.Assign_Recommended_PSR__c)
            if((apObj.Assignment_Activated__c != apObjOld.Assignment_Activated__c) && apObj.Assignment_Activated__c)
            {
                apObj.Partner_Assigned_Date__c = System.now();
                apObj.Partner_Status__c = Partner360utils.PARTNER_STATUS_PARTNER_ASSIGNED; 
                apObj.isPSRAssigned__c = false;
                apObj.Rejected_Reason__c = null;
                 
                if(UserInfo.getUserType()!= PartnerUser)
                {
                    apObj.Assigned_Partner_Sales_Rep__c = null ;
                    apObj.Assigned_Partner_Sales_Rep_2__c = null ;
                    apObj.Assigned_Partner_Sales_Rep_3__c = null ;
                    apObj.Assigned_PSR_SYS1__c = null ;
                    apObj.Assigned_PSR_SYS2__c = null ;
                    apObj.Assigned_PSR_SYS3__c = null ;
                }
                
                //BEGIN - Q3FY14 CR53 Assign Directly to Recommended PSR
                if (apObj.Assign_Recommended_PSR__c && apObj.Cisco_Recomended_Partner_Sales_Rep__c != null)
                {
                    apObj.Assigned_Partner_Sales_Rep__c = apObj.Cisco_Recomended_Partner_Sales_Rep__c;            
                    apObj.Partner_Status__c = Partner360utils.PARTNER_STATUS_ASSIGNED_To_PSR;
                    apObj.isPSRAssigned__c = True;
                    //apObj.Assign_Recommended_PSR__c = False;
                    apObj.PSR_Assigned_Date_Time__c = system.now();
                }
                //END - Q3FY14 CR53 Assign Directly to Recommended PSR
            }                         
 
            // if the partner assignment has been rejected
            // a. Deactivate the partner assignment
            if(apObj.Assignment_Activated__c && (apObj.Partner_Status__c == Partner360Utils.PARTNER_STATUS_REJECTED || apObj.Partner_Status__c == Partner360Utils.PARTNER_STATUS_CLOSED)
                    && apObj.Partner_Status__c != apObjOld.Partner_Status__c)
            {
                 apObj.Assignment_Activated__c = false;    
            }
                                
            // if the assignment has been deactivated
            // added Addition Clause to verify if the deactivation done by non partner profile
            //FY14 Nov Release: Refined the logic to add account id if TP source is Partner for releasing to sharkpool.
           
            if(apObj.Assignment_Activated__c == false && apObj.Assignment_Activated__c != apObjOld.Assignment_Activated__c)
            {
                system.debug('apObj.Rejected_Reason__c'+apObj.Rejected_Reason__c + Partner360Utils.PARTNER_STATUS_EXPIRED);
                system.debug('+ apObj.Rejected_Reason__c != Partner360Utils.PARTNER_STATUS_EXPIRED' + apObj.Rejected_Reason__c == Partner360Utils.PARTNER_STATUS_EXPIRED);
                
                apObj.Assign_Recommended_PSR__c = False;
                if(UserInfo.getProfileId().Left(15) != Utilities.getConstant_CS('P360_Portal_Profile') && apObj.Rejected_Reason__c != Partner360Utils.PARTNER_STATUS_EXPIRED){
                    system.debug('aaaaaaa');
                    apObj.Partner_Status__c = Partner360Utils.PARTNER_STATUS_CLOSED;
                    apObj.Rejected_Reason__c = Partner360utils.PARTNER_ASSIGNMENT_DEACTIVATED_BY_TXM;
                }
                if(apObj.Customer_Account__c != null && apObj.Target_Prospect_Source__c == 'Partner')
                AccountIdsToRelease.add(apObj.Customer_Account__c);
            }  
            
            // if the partner assignment has been rejected
            // a. Deactivate the partner assignment
            if(apObj.Assignment_Activated__c && (apObj.Partner_Status__c == Partner360Utils.PARTNER_STATUS_REJECTED || apObj.Partner_Status__c == Partner360Utils.PARTNER_STATUS_CLOSED)
                    && apObj.Partner_Status__c != apObjOld.Partner_Status__c)
            {
                 apObj.Assignment_Activated__c = false;    
            }
            
            if(apObj.Assigned_Partner__c != null)
            {
                AllaccountIds.add(apObj.Assigned_Partner__c);
            }
            if(apObj.Customer_Account__c !=null)
            {
                AllaccountIds.add(apObj.Customer_Account__c);        
            }              
        }
        
        
        if(apObj.extend_By__c != Null &&  apObj.extend_By__c != '' && apObj.Assignment_Activated__c)
        {               
                        if(apObj.extend_By__c == 'No Expiration')
                            apObj.Expiration_Date__c = Null;
                        else
                        {
                            system.debug('apObj.extend_By__c'+apObj.extend_By__c);
                            Integer ExtendDuration = Integer.ValueOf(apObj.extend_By__c.substring(0,apObj.extend_By__c.indexOf(' ')));
                            if(apObj.Extension_Reason__c == 'Explicit Extension by Partner') 
                            apObj.Expiration_Date__c = apObj.Expiration_Date__c + ExtendDuration ;
                            else                    
                            apObj.Expiration_Date__c = System.today() + ExtendDuration ;
                        }
                            apObj.extend_By__c = Null;
                    
        }   
    }
    
    // if the Assignd Partner and Customer Account field is not blank then 
    // update Target Prospect Name field
    Map<Id, String> mapAccountName = new Map<Id, String>();

    // get the account names for all the account ids    
    Map<Id,Account> MappedAccounts = new Map<Id,Account>([select Id, Name from Account where id in :AllaccountIds]);
       
    if (Test.isRunningTest())
    {
        // cannot access Customer or Partner name for test data as we cannot query it from the database
        // skip name update
    }
    else
    {
        for(Assigned_Partner__c ap:Trigger.new)
        {
            // if the Assignd Partner and Customer Account field is not blank then 
            // update Target Prospect Name field
            // if(ap.Assigned_Partner__c != null && ap.Customer_Account__c !=null)
            
            // validate that the provided Customer Account is not blank and exists in the system, and
            // validate that the provided Partner Account exists in the system
            if (ap.Customer_Account__c == null || MappedAccounts.get(ap.Customer_Account__c) == null)
            {
                ap.addError('Customer account ' + ap.Customer_Account__c + ' does not exist. Please select a valid Customer Account');
            }
            else if (ap.Assigned_Partner__c != null && MappedAccounts.get(ap.Assigned_Partner__c) == null)
            {
                ap.addError('Partner account ' + ap.Assigned_Partner__c + ' does not exist. Please select a valid Partner Account');
            }
            else
            {
               String partnerName = (ap.Assigned_Partner__c == null) ? '' : MappedAccounts.get(ap.Assigned_Partner__c).name;
               String apName = MappedAccounts.get(ap.Customer_Account__c).name + '-' + partnerName;   
               if(apName.length() > 80)
                 apName = apName.substring(0,80);  
                 
               ap.Name = apName;
            }
        }  
    } 
    
    
    if(AccountIdsToRelease.size() >0 || AccountIdsToRemove.size() >0)
    {
        List<Account> AccountsToUpdate = new List<Account>();
        for(Account a : [Select Id,Release_to_Unallocated_Pool__c,Unallocated_Account__c from account where Id IN: AccountIdsToRelease or Id IN:AccountIdsToRemove])
        {
            if(AccountIdsToRemove.contains(a.id))
            {
                a.Release_to_Unallocated_Pool__c = 'No';
                AccountsToUpdate.add(a) ;
            } 
            else if(a.Unallocated_Account__c == 'Yes')
            {
                a.Release_to_Unallocated_Pool__c = 'Yes';
                AccountsToUpdate.add(a);
            }           
        }
        if(AccountsToUpdate.size()>0) Update AccountsToUpdate;
     
    }
    
 //        if(!Test.isRunningTest() && trigger.isUpdate)
 //           Partner360Utils.skip_P360_Target_Prospect_BeforeUpdateInsert = true; // Mark static variable true to skip execution of trigger twice.
 //}

}