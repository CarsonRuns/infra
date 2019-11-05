public class P360_Partner_Resharing
{
/*  Description
    This recalculate all sharing required for PAs and PSRs of all leads and target prospect where the give end-user accounts are present.
*/

@future
public static void Partner_Resharing_On_OwnerChange(set<Id> AccountIds)
{
   // Find out sharing required due to partner assignment to leads.
   
    ObjectRecordTypeIds__c o = ObjectRecordTypeIds__c.getInstance();    //Lead Record Type ids to be considered.   
    String LEAD_MANUAL_RecTypeId = o.Manual_Lead_RecordTypeId__c;
    String LEAD_ELEAD_RecTypeId = o.eLeadsRecordTypeId__c;
    String LEAD_Partner_RecTypeId = o.Partner_Generated_Lead_RecordTypeId__c;
    
    Map<Id,Lead> LeadsToProcess = new Map<Id,Lead>();  // Leads to be processed.
    Set<Id> AllCustomerIds = new Set<Id>();       // All CustomerIds.

    for(Lead l : [Select OwnerId,RecordTypeId,End_Customer_Account__c,Channel_Partner__c,PSR_1__c,PSR_2__c,PSR_3__c from Lead
                  where End_Customer_Account__c IN:AccountIds and Channel_Partner__c != null] )
        {
          if(l.RecordTypeId == LEAD_MANUAL_RecTypeId || l.RecordTypeId == LEAD_ELEAD_RecTypeId || l.RecordTypeId == LEAD_Partner_RecTypeId)
                {
                    LeadsToProcess.put(l.Id,l); 
                    AllCustomerIds.add(l.End_Customer_Account__c);  
                }               
        }
        
    System.debug('LeadsToProcess'); 
    System.debug(LeadsToProcess);   
    
    System.debug('AllCustomerIds'); 
    System.debug(AllCustomerIds);
    
    if(LeadsToProcess.size() > 0)   
    {
        P360_PartnerSharingHelper PSH = new P360_PartnerSharingHelper(LeadsToProcess);
        PSH.AllCustomerIds = AllCustomerIds;
        
        // Get UserIds\GroupIds who should have access to perticular lead and account with new values.
        PSH.getUserOrGroupIdsForLeadsOrTPsAndAccounts();
        
        // Take all sharing records from share tables of lead and account and find out which needs to deleted.
        PSH.findAccountShareToInsert();       
        
        // Insert all required records(calculated in getUserOrGroupIdsForLeadsAndAccounts method) in account share table. 
        PSH.AccountShareInsert();                    
    }
  
}

}