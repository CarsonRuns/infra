trigger P360_TargetProspect_AfterUpdateInsert on Assigned_Partner__c(after update,after insert) 
{
    /*  Description 
       1. Manage Target Prospect Sharing to PA and PSRs upon Activation/Deactivation , PSR assignment/removal.
       2. Manage End-User Account Sharing to PA and PSRs upon Activation/Deactivation , PSR assignment/removal.
       3. Send Emails to PAs on Target Prospect Activation. 
       4. Create Records in Prospect Exetension object as per the change in Extension Reason.      
    */     
//if(!Partner360Utils.skip_P360_TargetProspect_AfterUpdateInsert) // Execute the trigger code only once. Variable defined in Partner360Utils class.
//{
    Map<Id,Assigned_Partner__c> TPsToProcess = new Map<Id,Assigned_Partner__c>();  // TargetProspect records to be processed.
    Set<Id> AllCustomerIds = new Set<Id>();       // New + Old CustomerIds.
    Set<Id> TPIdsForChannelAssignmentEmails = new Set<Id>();  // TP Ids for PA Assignment emails.
    Set<Id> PartnerGeneratedTPIds = new Set<Id>();  // Partner Generated Leads.
                                                    // Need to give Lead access to Primary Cisco Conatct of Partner.
    
    String PartnerUser = Partner360Utils.PARTNER_USER;  //Partner User identifier.
    
    List<Prospect_Extension__c> ProspectExtentionsToInsert = new List<Prospect_Extension__c>();
    String NoExpiration = 'No Expiration';
    
    for(Assigned_Partner__c TP : Trigger.new)  // Find Out TPs and All CustomerIds to be Processed.
    {
     if((Trigger.isInsert && TP.Assigned_Partner__c != null && TP.Assignment_Activated__c ) ||
                (Trigger.isUpdate &&
                    (
                     (TP.Assignment_Activated__c != Trigger.OldMap.get(TP.Id).Assignment_Activated__c) ||
                     (TP.Assigned_Partner__c != Trigger.OldMap.get(TP.Id).Assigned_Partner__c) ||
                     (TP.Customer_Account__c != Trigger.OldMap.get(TP.Id).Customer_Account__c) ||
                     (TP.Assigned_Partner_Sales_Rep__c != Trigger.OldMap.get(TP.Id).Assigned_Partner_Sales_Rep__c) ||
                     (TP.Assigned_Partner_Sales_Rep_2__c != Trigger.OldMap.get(TP.Id).Assigned_Partner_Sales_Rep_2__c) ||
                     (TP.Assigned_Partner_Sales_Rep_3__c != Trigger.OldMap.get(TP.Id).Assigned_Partner_Sales_Rep_3__c)                      
                    )
                )                
        )
       {
            TPsToProcess.put(TP.id,TP); 
            if((Trigger.isInsert && TP.Assignment_Activated__c) ||
               (Trigger.isUpdate && TP.Assignment_Activated__c && 
                TP.Assignment_Activated__c != Trigger.OldMap.get(TP.Id).Assignment_Activated__c))
            {
                TPIdsForChannelAssignmentEmails.add(TP.Id); // Find out TPs where Partner Assignment emails need to be be sent.
                System.debug('Email Notification'+TPIdsForChannelAssignmentEmails);
                if(Trigger.isInsert && UserInfo.getUserType()== PartnerUser)
                PartnerGeneratedTPIds.add(TP.Id);
            }
            if(TP.Customer_Account__c !=null)AllCustomerIds.add(TP.Customer_Account__c);
            if(Trigger.isUpdate && Trigger.OldMap.get(TP.Id).Customer_Account__c != null)
                AllCustomerIds.add(Trigger.OldMap.get(TP.Id).Customer_Account__c);
       }
       
       if(Trigger.isInsert && TP.Expiration_Date__c != null)
       {
            System.debug('TP.Extension_Reason__c');
            System.debug(TP.Extension_Reason__c);
            Prospect_Extension__c PE = new Prospect_Extension__c();
            PE.Target_Prospect__c =  TP.Id;
            PE.New_Expiration_Date__c = TP.Expiration_Date__c;
            PE.Extension_Reason__c =  TP.Extension_Reason__c;
            Integer ExtPeriod = System.Today().daysBetween(TP.Expiration_Date__c);
            PE.Extension_Period__c = String.ValueOf(ExtPeriod) + ' days';
            ProspectExtentionsToInsert.add(PE);
       }
       else if(Trigger.isUpdate && TP.Expiration_Date__c != Trigger.OldMap.get(TP.Id).Expiration_Date__c && TP.Extension_Reason__c != null)
       {    
            System.debug('TP.Extension_Reason__c');
            System.debug(TP.Extension_Reason__c);
            Prospect_Extension__c PE = new Prospect_Extension__c();
            PE.Target_Prospect__c =  TP.Id;
            PE.Old_Expiration_Date__c = Trigger.OldMap.get(TP.Id).Expiration_Date__c;
            PE.New_Expiration_Date__c = TP.Expiration_Date__c;
            PE.Extension_Reason__c = TP.Extension_Reason__c; 
            if(TP.Expiration_Date__c != NULL)
            {
            Integer ExtPeriod = System.Today().daysBetween(TP.Expiration_Date__c);
            PE.Extension_Period__c = String.ValueOf(ExtPeriod) + ' days';
            }
            else
            PE.Extension_Period__c = NoExpiration;
            ProspectExtentionsToInsert.add(PE);
       }
       
       
    }
 
    System.debug('TPsToProcess');
    System.debug(TPsToProcess); 
    if(TPsToProcess.size() >0)
    {
        P360_PartnerSharingHelper PSH = new P360_PartnerSharingHelper(TPsToProcess);
        PSH.AllCustomerIds = AllCustomerIds;
        PSH.TPIdsForChannelAssignmentEmails = TPIdsForChannelAssignmentEmails;
        PSH.PartnerGeneratedTPIds = PartnerGeneratedTPIds;
        
         // Get UserIds\GroupIds who should have access to perticular TP and account with new values.
        PSH.getUserOrGroupIdsForLeadsOrTPsAndAccounts();
        
        // Take all sharing records from share tables of TP and account and find out which needs to deleted.
        PSH.findTPShareToDelete();
        PSH.findPossibleAccountShareToDelete() ;
        
        // find records needed to inserted as per new values on TP
        PSH.findTPShareToInsert();
        PSH.findAccountShareToInsert();
                
        System.debug('PSH.TPSharetoinsert');
        System.debug(PSH.TPSharetoinsert);
        
        System.debug('PSH.TPSharetoDelete');
        System.debug(PSH.TPSharetoDelete);

        System.debug('PSH.TPSharetoinsert');
        System.debug(PSH.TPSharetoinsert);
        
        System.debug('PSH.PossibleAccountShareToDelete');
        System.debug(PSH.PossibleAccountShareToDelete);
                
        PSH.TPShareDelete(); // Delete records from TP share which are not needed.(Calculated in findTPShareToDelete method)
        PSH.leadOrTPShareInsert(); //Insert all required records(calculated in findTPShareToInsert method) in TP share table.         
        PSH.accountShareInsert(); // Insert all required records(calculated in findAccountShareToInsert method) in account share table.
   
         // Delete records from account share which are not needed.(Calculated in findPossibleAccountShareToDelete method), 
         // filter deletion for records which should be present due to other lead/TP records in the table.
        if(PSH.PossibleAccountShareToDelete.size()> 0) 
        {
            PSH.accountShareDelete();
        }
        
        //Send notification about partner generated TPs to primary cisco contact of partner.
        if(PSH.PartnerGeneratedTPIds.size() > 0)
        {
            PSH.sendPartnerGeneratedTPNotifications();      
        }       
    
    }
    
    if(ProspectExtentionsToInsert.size() >0)
    {
            insert ProspectExtentionsToInsert;
    }
//      if(!Test.isRunningTest() && trigger.isUpdate)
//   Partner360Utils.skip_P360_TargetProspect_AfterUpdateInsert = true; // Mark static variable true to skip execution of trigger twice.
// }
    
}