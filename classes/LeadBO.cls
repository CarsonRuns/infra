/*
  Name        : LeadBO 
  Author      : Eric Pesch (epesch)
  Release     : 1.0
  Functionality   : Trigger Business Logic for the Lead SObject.
  Created      : Sep 14 2015
  
  Modification History:
  Date        Author      Change 
  02/14/2017  majanard    Added leadUpdateFromChannelPartner and leadApiTransformation for Zift integration.
	
	Modification history:
	Date: Dec-12-2017
	Author: Zakeahme
	Change: leadProspectDeduping() , in line# 414 in query variable. Added lead_category__C field in SOQL
*/
public class LeadBO {
    private static final String TAG = '[LeadBO] - ';
    
    /*
     * @description Update Lead priority, comparing Lead, CC response and CC response details (w/CC Lead Priority Rules)
     *
     * @param newLeadsLst List of New Leads
     */
    public static void updateLeadPriority(List<Lead> newLeadsLst){
      //if(trigger.IsBefore && trigger.isUpdate){
    List<Lead> validRecords = new List<Lead>();//  Lead_Prospect_Recordtype__c
        ObjectRecordTypeIds__c o = ObjectRecordTypeIds__c.getInstance();  // Lead Record Type Ids.
        
        System.debug(TAG + '***obje **');
      for(Lead lead : newLeadsLst) {
            if(o.Lead_Prospect_Recordtype__c != null && lead.recordTypeId == Id.valueOf(o.Lead_Prospect_Recordtype__c)) {
                validRecords.add(lead);
            }
        }
  
        if (validRecords.size() > 0) {
          LeadTriggerUtil.NGCC_updateLeadPriority(validRecords);
        }
  }


    /*
     * @description Code cleaned up and migrated from LeadHandler.cls (old Trigger Factory)
     *
     * @param newLeadsLst List of New Leads
     */
    public static void addDistributorInsert(List<Lead> newLeadsLst) {
        Set<String> lfdBGOIds = new Set<String>();  
        ObjectRecordTypeIds__c o = ObjectRecordTypeIds__c.getInstance();  // Lead Record Type Ids.     
        final String LEAD_MANUAL_RecTypeId = o.Manual_Lead_RecordTypeId__c;
              
        for(Lead newLead : newLeadsLst) {
            if(newLead.RecordTypeId == LEAD_MANUAL_RecTypeId && newLead.Lead_From_Distributor_BE_GEO_ID_PDB__c != null){    
                lfdBGOIds.add(newLead.Lead_From_Distributor_BE_GEO_ID_PDB__c);
            }                  
        }
        
        addDistributor(lfdBGOIds, newLeadsLst);
    }
    
    /*
     * @description Code cleaned up and migrated from LeadHandler.cls (old Trigger Factory)
     *
     * @param newLeadsLst List of new Leads
     * @param oldLeadsMap Map of old Leads 
     */
    public static void addDistributorUpdate(List<Lead> newLeadsLst, Map<Id, SObject> oldLeadMap) {
        Set<String> lfdBGOIds = new Set<String>();  
              
        for(Lead newLead : newLeadsLst) {
            if(newLead.Lead_From_Distributor_BE_GEO_ID_PDB__c != null){
                Lead oldLead = (Lead) oldLeadMap.get(newLead.Id);
                if(newLead.Lead_From_Distributor_BE_GEO_ID_PDB__c != oldLead.Lead_From_Distributor_BE_GEO_ID_PDB__c){
                    lfdBGOIds.add(newLead.Lead_From_Distributor_BE_GEO_ID_PDB__c);
                }
            }                   
        }
        
        addDistributor(lfdBGOIds, newLeadsLst);
    }
    
    /*
     * @description Code cleaned up and migrated from LeadHandler.cls (old Trigger Factory)
     * 
     * @param lfdBGOIds Unknown
     * @param newLeadsLst List of new Leads
     */
    private static void addDistributor(Set<String> lfdBGOIds, List<Lead> newLeadsLst) {
        if(!lfdBGOIds.isEmpty()) {    
            Map<String,Account> mpAccount = new Map<String,Account>();  
            for(Account acc: [select Id,Name,PDB_BE_GEO_ID__c from Account where PDB_BE_GEO_ID__c IN : lfdBGOIds and parentId != null]) {
                mpAccount.put(acc.PDB_BE_GEO_ID__c,acc);
            }
            
            for(Lead newLead : newLeadsLst) {
                Account acc = mpAccount.get(newLead.Lead_From_Distributor_BE_GEO_ID_PDB__c);
                if(acc != null){
                    newLead.Lead_From_Distributor_lookUp__c = acc.Id;
                    newLead.Lead_Distributor_Name__c = acc.Name;
                }
            }
        }
    }
    
    /*
     * @description Code cleaned up and migrated from LeadHandler.cls (old Trigger Factory)
     *
     * @param newLeadsLst List of New Leads
     */
    public static void addPartnerStatus(List<Lead> newLeadsLst) {
      for(Lead newLead : newLeadsLst) {        
          if(newLead.SCP_Partner_Lead_Status__c != null && newLead.Partner_Lead_Status__c == null) {
              newLead.Partner_Lead_Status__c = newLead.SCP_Partner_Lead_Status__c;
          }
          if(newLead.SCP_Partner_Lead_Status__c == null && newLead.Partner_Lead_Status__c != null) {
              newLead.SCP_Partner_Lead_Status__c = newLead.Partner_Lead_Status__c;
          }
          if(newLead.SCP_Partner_Lead_Status__c != newLead.Partner_Lead_Status__c) {
              newLead.Partner_Lead_Status__c = newLead.SCP_Partner_Lead_Status__c;
          }
      }
    }
    
    /*
     * @description Code cleaned up and migrated from LeadHandler.cls (old Trigger Factory)
     *
     * @param newLeadsLst List of New Leads
     */
    public static void addMigratedAccount(List<Lead> newLeadsLst) {
        Set<String> acctFetch = new Set<String>(); 
        for(Lead newLead : newLeadsLst) {
            if(newLead.End_Customer_Account_Migrate_Id__c != null) {
                acctFetch.add(newLead.End_Customer_Account_Migrate_Id__c);
            }
        }
        
        
        
        if(!acctFetch.isEmpty()) {
            Map<Id, Account> acctMap = new Map<Id, Account>([select Id from Account where Id in : acctFetch]);
            for(Lead newLead : newLeadsLst) {
                if(acctMap.containsKey(newLead.End_Customer_Account_Migrate_Id__c)) {
                    newLead.End_Customer_Account__c = newLead.End_Customer_Account_Migrate_Id__c;
                }
            }
        }
    }
    
    /*
     * @description Code cleaned up and migrated from LeadGeoLocBeforeUpsertBatch.trigger
     *
     * @param newLeadsLst List of new Leads
     * @param oldLeadsMap Map of old Leads 
     */
    public static void addGeoLocTag(List<Lead> newLeadsLst, Map<Id, SObject> oldLeadsMap) {
      for(Lead newLead : newLeadsLst) {
        String newAddress = newLead.Address_Line_1_English__c + newLead.Address_Line_2_English__c + newLead.City_English__c 
                + newLead.State_Province_English__c + newLead.Zip_Postal_Code_English__c + newLead.Country_English__c;
        
        if(oldLeadsMap == null && !String.isEmpty(newAddress)) {
          newLead.needs_geolocation_update__c = true;
        } else if (oldLeadsMap != null) {
          Lead oldLead = (Lead) oldLeadsMap.get(newLead.Id);
          String oldAddress = oldLead.Address_Line_1_English__c + oldLead.Address_Line_2_English__c + oldLead.City_English__c 
                  + oldLead.State_Province_English__c + oldLead.Zip_Postal_Code_English__c + oldLead.Country_English__c;
          
        if(newAddress != oldAddress) {
          newLead.needs_geolocation_update__c = true;
        }
        }
        
        System.debug(TAG + 'addGeoLocTag result - ' + newLead.needs_geolocation_update__c);
      }
    }
    
    /*
     * @description Code cleaned up and migrated from LeadHandler.cls (old Trigger Factory)
     *
     * @param newLeadsLst List of new Leads
     * @param oldLeadsMap Map of old Leads 
     */
    public static void processPartnerLeadBefore(List<Lead> newLeadsLst, Map<Id, SObject> oldLeadsMap) {
       Boolean isPartnerUser = PRMFilterUtility.checkPatnerUser() == 1 ? true : false;
       String profilesIdsForClosedLeadEdit = Utilities.getConstant_CS('ProfilesIds_For_Closed_Lead_Edit');
       String userIdsForClosedLeadEdit = Utilities.getConstant_CS('UserIds_For_Closed_Lead_Edit');
       Boolean canEditClosedLead = false; 
       
       //Update flag to determine if running user can edit closed lead.
       if(profilesIdsForClosedLeadEdit.contains(UserInfo.getProfileId().substring(0, 15)) 
             || userIdsForClosedLeadEdit.contains(UserInfo.getUserId())) {
           canEditClosedLead = true;
       }       
       
       for(Lead newLead : newLeadsLst) {
            Lead oldLead = (Lead) oldLeadsMap.get(newLead.Id);
      if(newLead.Partner_Lead_Status__c != oldLead.Partner_Lead_Status__c 
          && newLead.Partner_Lead_Status__c != oldLead.SCP_Partner_Lead_Status__c) {
              newLead.SCP_Partner_Lead_Status__c = newLead.Partner_Lead_Status__c;
          }
          
          if(newLead.SCP_Partner_Lead_Status__c != oldLead.SCP_Partner_Lead_Status__c 
              && newLead.SCP_Partner_Lead_Status__c != oldLead.Partner_Lead_Status__c) {
              newLead.Partner_Lead_Status__c = newLead.SCP_Partner_Lead_Status__c;    
          }
  
          if(isPartnerUser) PRMLeadService.processEdittedAssignedLeads(oldLead, newLead);
          
          //Bypass for TAC Generated Lead
          if(newLead.LeadSource != System.label.Lead_TAC_Generated_Source) {
            LeadService.preventClosedLeadUpdates(oldLead, newLead, canEditClosedLead);
          }
        }
    }
    
    /*
     * @description Code cleaned up and migrated from LeadHandler.cls (old Trigger Factory)
     *
     * @param newLeadsLst List of new Leads
     * @param oldLeadsMap Map of old Leads 
     */
    public static void processPartnerLeadAfter(List<Lead> newLeadsLst, Map<Id, SObject> oldLeadsMap) {
      set<Id> accountIds = new set<Id>();
      map<Id,string> mpUserList = null;
      
      for(Lead newLead : newLeadsLst) {
          Lead oldLead = (Lead) oldLeadsMap.get(newLead.Id);
          if(oldLead.Partner_Lead_Status__c != newLead.Partner_Lead_Status__c && newLead.Partner_Lead_Status__c == 'Partner Assigned' 
              && newLead.Channel_Partner__c != null) {
            System.debug(TAG + 'Adding Partner - ' + newLead.Channel_Partner__c);
              accountIds.add(newLead.Channel_Partner__c);
          }
      }
      
      if(!accountIds.isEmpty()){
        System.debug(TAG + 'Checking SCP list - ' + accountIds);
        mpUserList = PRMUtils.getSCPUserList(accountIds);
      }
      
    for(Lead newLead : newLeadsLst) {
            Lead oldLead = (Lead) oldLeadsMap.get(newLead.Id);
          
          if(oldLead.Partner_Lead_Status__c != newLead.Partner_Lead_Status__c && newLead.Partner_Lead_Status__c == 'Partner Assigned' 
              && newLead.Channel_Partner__c != null) {
            String userList = mpUserList.get(newLead.Channel_Partner__c);                      
            
            if(userList != '' && !Test.isRunningTest()) {
                  Boolean callStackLimitExceeded = (Limits.getFutureCalls() >= Limits.getLimitFutureCalls());
                  if(!callStackLimitExceeded) {
                      SCP_Notifications_RestCall.callWSAPI('SCP-TTL-LD', '', 'SCP-LD-ASMT', 'N', 'SCP user', 'Leads Module', 'SCP', newLead.Id, newLead.Company, newLead.LastModifiedByName__c, userList);
                  }
            }
        }
    }
    }
    
    /*
     * @description Process LeadSource = 'TAC Generated Lead' Leads
     *
     * @param newLeadsLst List of new Leads     
     */
    public static void processTACLead(List<Lead> newLeadsLst) {
      //Duplicate containers
      Set<String> customerEmails = new Set<String>();
      Set<String> mainTechs = new Set<String>();
      List<String> statusFilter = System.label.Lead_TAC_Duplicate_Statuses.split(',');
      for(Integer i = 0; i < statusFilter.size(); i++) {
        statusFilter[i] = statusFilter[i].trim();
        System.debug(TAg + 'Status Filter - ' + statusFilter[i]);
      }
      List<Lead> oldLeads = null;

      //Setup date filter
      DateTime dateLimit = DateTime.now();
      dateLimit = dateLimit.addDays(-30);
      
      //Record Types
      ObjectRecordTypeIds__c recordTypes = ObjectRecordTypeIds__c.getInstance();
      Id closeRecId = recordTypes.Closed_Lead_RecordTypeId__c;
       
      for(Lead newLead : newLeadsLst) {
        if(newLead.LeadSource == System.label.Lead_TAC_Generated_Source) {
          System.debug(TAG + 'Adding TAC Generated Lead - ' + newLead);
          //Collect emails and technology
          customerEmails.add(newLead.Email);
          mainTechs.add(newLead.Main_Technology__c);
          
          //Set duplicate fields on new Leads
          //Can't use workflow - populating picklist
          newLead.CustomCountry__c = newLead.Country_English__c;
        }
      }
      
    //Fetch the potential duplicate leads
    if(!customerEmails.isEmpty() && !mainTechs.isEmpty()) {
      try {
        oldLeads = [select Id, Email, Main_Technology__c from Lead
          //Same Customer Email, TAC Main Technology
          where Email in : customerEmails and Main_Technology__c in : mainTechs
          //Lead Status - 1 Waiting, 2 Accepted-Mine/Channels
          and Status in : statusFilter
          //Lead Qualified Date within 30 days
          and Lead_Qualified_Date__c = LAST_N_DAYS:30 ];
      } catch (Exception e) {
        System.debug(TAG + 'Error retrieving old leads - ' + e.getStackTraceString());
      }
    }
    
      //For duplicate leads, change fields and set for deletion
      if(oldLeads != null && !oldLeads.isEmpty()) {
        System.debug(TAG + 'Found old leads, checking against insert');
        for(Lead oldLead : oldLeads) {
          for(Lead newLead : newLeadsLst) {
            System.debug(TAG + 'oldLead - ' + oldLead.Email + ' - ' + oldLead.Main_Technology__c);
            System.debug(TAG + 'newLead - ' + newLead.Email + ' - ' + newLead.Main_Technology__c);
            if(newLead.Email == oldLead.Email && newLead.Main_Technology__c == oldLead.Main_Technology__c) {
              newLead.Status = System.label.Lead_TAC_Reject_Status;
              newLead.System_Duplicate_Id__c = oldLead.Id; 
              newLead.RecordTypeId = closeRecId;
            }
          }
        }
      } else {
        System.debug(TAG + 'No old leads found');
      }
    } 
    
    /*
     * @description Remove potentially mistakenly added Channel Partner from TAC Generated Leads 
     *
     * @param newLeadsLst List of new Leads
     * @param oldLeadsMap Map of old Leads 
    */
    public static void removeTACPartner(List<Lead> newLeadsLst, Map<Id, SObject> oldLeadsMap) {
      Set<Id> userIdList = new Set<Id>();

      for(Lead newLead : newLeadsLst) {
        Lead oldLead = (Lead) oldLeadsMap.get(newLead.Id);

        //If Channel Partner assigned systematically, revert back to old value
        if(oldLead != null && newLead.LeadSource == System.label.Lead_TAC_Generated_Source 
            && newLead.Channel_Partner__c != oldLead.Channel_Partner__c
            && newLead.lastModifiedById == Utilities.getConstant_CS('Connection User 1 Id')) {
          System.debug(TAG + 'removeTACPartner - found connection User, removing Channel Partern - ' + newLead.Channel_Partner__c);
          newLead.Channel_Partner__c = oldLead.Channel_Partner__c;
        }
      }
    }
    
    /*
     * @description Fake an update on Leads to write-back data over Salesforce-to-Salesforce connection (afterInsert)
     *
     * @param newLeadsLst Trigger.new Leads
     */
    public static void touchTACLead(List<Lead> newLeadsLst) {
      //Connection Helper check
      Id connectionId = ConnectionUtilities.getConnectionId(Utilities.getConstant_CS('Lead TAC Connection Name'));
      Set<Id> leadTouchList = new Set<Id>();
      
    //Force update after DML run
    for(Lead newLead : newLeadsLst) {
      if(newLead.ConnectionReceivedId != null && newLead.ConnectionReceivedId == connectionId) {
        leadTouchList.add(newLead.Id);
      }
    }
     
    if(!leadTouchList.isEmpty()) {
      LeadTACSharingHelper.touchLeads(leadTouchList);
    }     
    }
    
    /*** 
    */
    
    //update Lead Category when the following Lead Source condition matches
    public Static void leadCategoryUpdate(List<Lead> newLead){
        ObjectRecordTypeIds__c o = ObjectRecordTypeIds__c.getInstance();
        for(Lead l: newLead){
            if( o.eLeadsRecordTypeId__c != null && l.RecordTypeId == id.valueOf(o.eLeadsRecordTypeId__c) && (l.LeadSource == 'Global Eloqua Scored Lead' || l.LeadSource == 'Global Eloqua Hand Raiser' )){
                if(l.LeadSource == 'Global Eloqua Scored Lead'){
                    l.Lead_Category__c = 'Scored Lead';
                }
                else{
                    l.Lead_Category__c = 'Hand Raiser';
                }
            }
        }
        
    }
    
    public static String flattenIdList(List<Lead> input){
        String result = '';
        
        for (Lead l: input){
            result = result + '\'' + l.Id + '\',';
        }
        result = result.substring(0, result.length()-1);
        return result;
    }
    
    public static void leadProspectDeduping(List<Lead> newLeadsLst) {
        Boolean executeFlag = false;
        List<Lead> dedupedLeads = new List<Lead>();
        
        //add all the leads to the list only if it matches the following rule
        for(Lead l: newLeadsLst){
             if((l.DedupeRecord__c =='Dedupe') && (l.Status == 'Pre-Prospect' ||( l.Status == '1 Waiting' && l.Source_System__c =='Eloqua'))){
                 dedupedLeads.add(l);
             }

         }
        if(dedupedLeads.size() >0){
            String ids = flattenIdList(dedupedLeads);
            String query = 'Select Id, Status,Description, CreatedDate, CustomCountry__c, Theater__c,RecordTypeId,Campaign_Name__c,Source_Event_Number__c,MODS_Contact__c,ProgramEvent__c,Partner_Owned_Contact_Flag__c,Medium_Type__c,Call_Status__c, Call_Back_Date_Time__c, Outcome__c,Lead_Category__c FROM Lead WHERE ID in ('+ ids +')';
            Database.executeBatch(new NGCC_Lead_Deduper(query));
        }
    }
    
    // 02/14/2017 Zift Integration - Update Zift leads i.e., Source System = PMC/Zift.
    public static void leadUpdateFromChannelPartner(List<Lead> newLeadsList, Map<Id, SObject> oldLeadsMap){
        List<Lead> leadsToUpdateFromDistiPartner = new List<Lead>();
        List<Lead> leadsToUpdateFromNonDistiPartner = new List<Lead>();
        Map<ID, Account> accountMap = new Map<ID, Account>();
        List<ID> accountIds = new List<ID>();
        List<String> psrIDs = new List<String>();
        for(Lead lNew :newLeadsList) {
            Lead lOld = (Lead) oldLeadsMap.get(lNew.ID);              
            if(lNew.Source_System__c == System.Label.Zift_SourceSystem || lNew.RecordTypeId == ObjectRecordTypeIds__c.getInstance().Partner_Generated_Lead_RecordTypeId__c && lNew.Channel_Partner__c != null && lNew.Channel_Partner__c != lOld.Channel_Partner__c){
                leadsToUpdateFromDistiPartner.add(lNew);
                accountIds.add(lNew.Channel_Partner__c);
            }
        }
        if(!accountIds.isEmpty()){
            accountMap = new Map<Id, Account>([select Id, Geographic_Region__c, Type from Account where Id in : accountIds]);
        }
        
        List<ID> leadIds = new List<ID>();
        for(Lead ld :leadsToUpdateFromDistiPartner) {
            Account acc = accountMap.get(ld.Channel_Partner__c);
            if(acc != null && acc.Type == 'Distributor'){
                ld.Funding_Source__c = System.Label.Cisco_FundingSource;
                ld.Theater__c = acc.Geographic_Region__c;
            } else if(acc != null && acc.Type != 'Distributor') {
                ld.Funding_Source__c = System.Label.Joint_FundingSource;
                ld.Theater__c = acc.Geographic_Region__c;
            }
        }
    }    
    
    // 02/14/2017 Zift Integration - Set the initial transformation value for the Zift leads i.e., Lead Source is AQL, MQL or Partner.
    public static void leadApiTransformation(List<Lead> newLeadsList){
        for(Lead ld :newLeadsList){
            if(ld.Source_System__c == System.Label.Zift_SourceSystem && ld.LeadSource == System.Label.Zift_AQL_LeadSource){
                ld.Campaign_Description__c = System.Label.Zift_AQL_CampaignDescription;
                ld.Data_Source_Name__c = System.Label.Zift_DataSourceName;
                ld.Funding_ID__c = System.Label.Zift_AQL_FundingId;
                ld.Lead_Category__c = System.Label.LeadCategory_ReasonToCall;
                ld.Program_Event_Name__c = System.Label.Zift_AQL_ProgramEventName;
                ld.QABudget__c = System.Label.Zift_AQL_Budget;
                ld.RecordTypeId = ObjectRecordTypeIds__c.getorgdefaults().Partner_Generated_Lead_RecordTypeId__c;
            } else if (ld.Source_System__c == System.Label.Zift_SourceSystem && ld.LeadSource == System.Label.Zift_MQL_LeadSource){
                ld.Data_Source_Name__c = System.Label.Zift_DataSourceName;
                ld.Lead_Category__c = System.Label.LeadCategory_Bant;
                ld.RecordTypeId = ObjectRecordTypeIds__c.getorgdefaults().Partner_Generated_Lead_RecordTypeId__c;
                if(ld.Funding_ID__c == null || ld.Funding_ID__c == ''){
                    ld.Funding_ID__c = System.Label.Zift_TQ_FundingId;
                }
            } else if(ld.Source_System__c == System.Label.Zift_SourceSystem && ld.LeadSource == System.Label.Zift_Partner_LeadSource){
                ld.Data_Source_Name__c = System.Label.Zift_DataSourceName;
                ld.Lead_Category__c = System.Label.LeadCategory_Bant;
                ld.RecordTypeId = ObjectRecordTypeIds__c.getorgdefaults().Partner_Generated_Lead_RecordTypeId__c;
            }
        }
    }
}