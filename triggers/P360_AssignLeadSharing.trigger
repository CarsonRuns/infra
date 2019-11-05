/* Description 
   1. Manage Lead Sharing to PAs and PSRs upon Partner assignment/removal , PSR assignment/removal.
   2. Manage End-User Account Sharing to PA and PSRs upon Partner assignment/removal , PSR assignment/removal.
   3. Send Notification Emails to PAs on Partner Assignment.
   4. Share the updated SourceFire leads to Sourcefire system.    
 */
trigger P360_AssignLeadSharing on Lead (after update,after insert) {
    final static String TAG = '[P360_AssignLeadSharing] - ';
    
    Map<Id,Lead> leadsToProcess = new Map<Id,Lead>();  // Leads to be processed.
    Set<Id> allCustomerIds = new Set<Id>();       // New + Old CustomerIds.
    Set<Id> leadIdsForChannelAssignmentEmails = new Set<Id>();  // Lead Ids for PA Assignment emails.
    Set<Id> partnerGeneratedLeadIds = new Set<Id>();  // Partner Generated Leads.

    ObjectRecordTypeIds__c o = ObjectRecordTypeIds__c.getInstance();  // Lead Record Type Ids.     
    //11/13 Manju - Added ID conversion to 18 Digit to fix the intermittend ID comparision issue
    final String LEAD_MANUAL_RECTYPE_ID = (String)Id.valueOf(o.Manual_Lead_RecordTypeId__c);
    final String LEAD_ELEAD_RECTYPE_ID = (String)Id.valueOf(o.eLeadsRecordTypeId__c);
    final String LEAD_PARTNER_RECTYPE_ID = (String)Id.valueOf(o.Partner_Generated_Lead_RecordTypeId__c);
    String partnerUser = Partner360Utils.PARTNER_USER;  //Partner User identifier.

    for(Lead l : Trigger.new) {    

        // Modified By: Sudi 17 Oct 2014 
        // Release : November Sprint 3
        // User Story : US7053
        // Added extra condition to check the lead from BE GEO Id is not null/ is changesd we are adding those lead to Sharing.
        if(l.RecordTypeId == LEAD_MANUAL_RECTYPE_ID || l.RecordTypeId == LEAD_ELEAD_RECTYPE_ID || l.RecordTypeId == LEAD_PARTNER_RECTYPE_ID) {
            if(Trigger.isInsert && (l.Channel_Partner__c != null || l.Lead_From_Distributor_BE_GEO_ID_PDB__c != null)){
                leadsToProcess.put(l.id,l);
                
                if(l.Channel_Partner__c != null) {
                    // Find out leads where Partner Assignment emails need to be sent.
                    leadIdsForChannelAssignmentEmails.add(l.Id); 
                    if(UserInfo.getUserType()== partnerUser) partnerGeneratedLeadIds.add(l.Id);
                }
                
                if(l.End_Customer_Account__c !=null) allCustomerIds.add(l.End_Customer_Account__c);
            }
            
            if(Trigger.isUpdate && (l.Channel_Partner__c != Trigger.OldMap.get(l.Id).Channel_Partner__c 
                    || l.End_Customer_Account__c != Trigger.OldMap.get(l.Id).End_Customer_Account__c 
                    || l.PSR_1__c != Trigger.OldMap.get(l.Id).PSR_1__c 
                    || l.PSR_2__c != Trigger.OldMap.get(l.Id).PSR_2__c 
                    || l.PSR_3__c != Trigger.OldMap.get(l.Id).PSR_3__c 
                    || l.OwnerId != Trigger.OldMap.get(l.Id).OwnerId 
                    || l.Lead_From_Distributor_BE_GEO_ID_PDB__c != Trigger.OldMap.get(l.Id).Lead_From_Distributor_BE_GEO_ID_PDB__c)) {
                    System.debug('===ENTER===');
                leadsToProcess.put(l.id,l);
                
                if(l.Channel_Partner__c != Trigger.OldMap.get(l.Id).Channel_Partner__c) {
                    // Find out leads where Partner Assignment emails need to be sent.
                    leadIdsForChannelAssignmentEmails.add(l.Id); 
                    if(UserInfo.getUserType()== partnerUser) partnerGeneratedLeadIds.add(l.Id);
                }
                
                if(l.End_Customer_Account__c !=null)allCustomerIds.add(l.End_Customer_Account__c);
                
                if(Trigger.OldMap.get(l.Id).End_Customer_Account__c != null) allCustomerIds.add(Trigger.OldMap.get(l.Id).End_Customer_Account__c);
            }
        }
    }

    System.debug(TAG + 'leadsToProcess');
    System.debug(TAG + leadsToProcess);
    
    if(!leadsToProcess.isEmpty()) {
        P360_PartnerSharingHelper PSH = new P360_PartnerSharingHelper(leadsToProcess); 
        PSH.allCustomerIds = allCustomerIds;
        PSH.leadsIdsForChannelAssignmentEmails = leadIdsForChannelAssignmentEmails;
        PSH.partnerGeneratedLeadIds = partnerGeneratedLeadIds;

        // Get UserIds\GroupIds who should have access to perticular lead and account with new values.
        PSH.getUserOrGroupIdsForLeadsOrTPsAndAccounts(); 
        
        // Modified By: Sudi 17 Oct 2014 
        // Release : November Sprint 3
        // User Story : US7053
        // Below method is for share the lead records to disti accounts
        PSH.getUserorGroupIDsforLeadDistributorAccounts();
        
        // Take all sharing records from share tables of lead and account and find out which needs to deleted.
        PSH.findLeadShareToDelete();
        PSH.findPossibleAccountShareToDelete() ;
        PSH.findLeadDistiShareToDelete();        
        
        // find records needed to inserted as per new values on Lead
        PSH.findLeadShareToInsert();        
        PSH.findAccountShareToInsert();
        
        // Modified By: Sudi 17 Oct 2014 
        // Release : November Sprint 3
        // User Story : US7053      
        // methods are used for delete the share records and add new lead share records 
        // Find out LeadShare records to deleted from existing records by checking them with required records          
        PSH.findLeadDistiShareToInsert(); 

        System.debug(TAG + 'PSH.leadSharetoinsert');
        System.debug(TAG + PSH.leadSharetoinsert);
        System.debug(TAG + 'PSH.leadSharetoDelete');
        System.debug(TAG + PSH.leadSharetoDelete);
        System.debug(TAG + PSH.AccountSharetoinsert);
        System.debug(TAG + PSH.PossibleAccountShareToDelete);

        // Delete records from lead share which are not needed.(Calculated in findLeadShareToDelete method)
        PSH.leadShareDelete(); 
        
        //Insert all required records(calculated in findLeadShareToInsert method) in lead share table.
        PSH.leadOrTPShareInsert();          
        
        // Insert all required records(calculated in findAccountShareToInsert method) in account share table.
        PSH.accountShareInsert(); 

        // Delete records from account share which are not needed.(Calculated in findPossibleAccountShareToDelete method),
        // filter deletion for records which should be present for other lead/Target Prospect records in the system.        
        if(!PSH.PossibleAccountShareToDelete.isEmpty()) PSH.accountShareDelete();

        //Send notification about partner generated leads to primary cisco contact of partner.
        //send only once
        if(!PSH.partnerGeneratedLeadIds.isEmpty()) PSH.sendPartnerGeneratedLeadNotifications();        
    }
}