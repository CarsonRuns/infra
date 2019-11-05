global class NGCC_Lead_SDR_Attributes_Update_Batch implements Database.Batchable<sObject>{
    global map<Id,String> queueMap ;
    global NGCC_Lead_SDR_Attributes_Update_Batch(){
        queueMap = new map<id,String>();
        for(Group queue : [select id,Name from Group where Name like '%Callback']){
            queueMap.put(queue.id,queue.Name);
        }
    }
    // SCAVA Helper Method to validate Update Access at field level
    global static Boolean flsUpdateGet(SObjectField field) {
        return field.getDescribe().isUpdateable() ? true : false;
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        datetime Last2mins = datetime.now().addMinutes(-2); 
        string EloquaAssetId = System.Label.NGCC_Eloqua_Asset_Id;
        ObjectRecordTypeIds__c recordtypeids = ObjectRecordTypeIds__c.getInstance();
        string ProspectRecordtypeid = recordtypeids.Marketing_Lead_RecordType__c;
        string MarketingProspectRecordtypeid = recordtypeids.Marketing_Qualified_Lead__c;
        string query = 'Select Id,LeadSource,Ownerid,RecordtypeId,Eloqua_Asset_Id__c,SDR_Assignment_Date__c,SDR_Assignment_DateTime__c,SDR_Lead_Owner_New__c,SDR_Lead_Owner_Email__c,SDR_Lead_Owner_Name__c,Call_Center_Vendor__c'+
            ' From Lead Where Eloqua_Asset_Id__c=:EloquaAssetId and LastModifiedDate>:Last2mins and ( RecordtypeId=:ProspectRecordtypeid OR '+
            ' RecordtypeId=:MarketingProspectRecordtypeid)';
        return Database.getQueryLocator(query);
    }    
    global void execute(Database.BatchableContext BC,List<Lead> scope){
        system.debug(scope);
        List<Lead> autoAcceptedLeads = new List<Lead>();
        map<id,id> LeadOwnerMap = new map<id,id>();
        map<id,User> Usermap = new map<id,User>();
        List<Lead> AcceptedLeads = new List<Lead>();
        List<Lead> LeadsToUpdate = new List<Lead>();
        
        for(Lead UpdatedLead : Scope){
            system.debug(string.valueOf(UpdatedLead.Ownerid).startsWith('00G'));
            system.debug(queueMap.containsKey(UpdatedLead.Ownerid));
            // https://help.salesforce.com/articleView?id=000247502&type=1
            // If an agent is available but does not manually accept a Callback Lead, the Lead Owner will be set to that agent automatically by Omni channel
            // in that situaltion making SDR fields blank.
            // Checking the Lead owner, if lead owner is Queue and SDR fields are not blank then make SDR fields as blank.
            system.debug(string.valueOf(UpdatedLead.Ownerid).startsWith('00G'));
            system.debug(queueMap.containsKey(UpdatedLead.Ownerid));
            if(string.valueOf(UpdatedLead.Ownerid).startsWith('00G') && queueMap.containsKey(UpdatedLead.Ownerid) &&
               (string.isNotBlank(UpdatedLead.Call_Center_Vendor__c) || UpdatedLead.SDR_Assignment_DateTime__c != Null ||
                UpdatedLead.SDR_Assignment_Date__c != Null || string.isNotBlank(UpdatedLead.SDR_Lead_Owner_Email__c) ||
                string.isNotBlank(UpdatedLead.SDR_Lead_Owner_New__c) || string.isNotBlank(UpdatedLead.SDR_Lead_Owner_Name__c) )
              ){
                  autoAcceptedLeads.add(UpdatedLead);
              }
            
            // If agent accepeted the Callback Lead manually, populating the SDR fields in that situation
            // Checking the Lead owner, if lead owner is actual User and SDR fields are blank then populate SDR fields
            if(string.valueOf(UpdatedLead.Ownerid).startsWith('005') && 
               (string.isBlank(UpdatedLead.Call_Center_Vendor__c) || UpdatedLead.SDR_Assignment_DateTime__c == Null ||
                UpdatedLead.SDR_Assignment_Date__c == Null || string.isBlank(UpdatedLead.SDR_Lead_Owner_Email__c) ||
                string.isBlank(UpdatedLead.SDR_Lead_Owner_New__c) || string.isBlank(UpdatedLead.SDR_Lead_Owner_Name__c) ||
                UpdatedLead.LeadSource != 'NGCC')
              ){
                  LeadOwnerMap.put(UpdatedLead.id,UpdatedLead.ownerid);
                  AcceptedLeads.add(UpdatedLead);
              }
        }
        // Process Autoaccepted Leads
        if(autoAcceptedLeads.size() > 0){
            for(Lead autoAcceptedLead : autoAcceptedLeads){
                Integer autoLeadCount = 0;
                if(string.isNotBlank(autoAcceptedLead.Call_Center_Vendor__c)){
                    if(flsUpdateGet(lead.Call_Center_Vendor__c)){
                        autoAcceptedLead.Call_Center_Vendor__c = Null;
                        autoLeadCount = 1;
                    }
                }
                if(autoAcceptedLead.SDR_Assignment_DateTime__c != Null){
                    if(flsUpdateGet(lead.SDR_Assignment_DateTime__c)){
                        autoAcceptedLead.SDR_Assignment_DateTime__c = Null;
                        autoLeadCount = 1;
                    }
                }
                if(autoAcceptedLead.SDR_Assignment_Date__c != Null){
                    if(flsUpdateGet(lead.SDR_Assignment_Date__c)){
                        autoAcceptedLead.SDR_Assignment_Date__c = Null;
                        autoLeadCount = 1;
                    }
                }
                if(string.isNotBlank(autoAcceptedLead.SDR_Lead_Owner_Email__c)){
                    if(flsUpdateGet(lead.SDR_Lead_Owner_Email__c)){
                        autoAcceptedLead.SDR_Lead_Owner_Email__c = Null;
                        autoLeadCount = 1;
                    }
                }
                if(string.isNotBlank(autoAcceptedLead.SDR_Lead_Owner_New__c)){
                    if(flsUpdateGet(lead.SDR_Lead_Owner_New__c)){
                        autoAcceptedLead.SDR_Lead_Owner_New__c = Null;
                        autoLeadCount = 1;
                    }
                }
                if(string.isNotBlank(autoAcceptedLead.SDR_Lead_Owner_Name__c)){
                    if(flsUpdateGet(lead.SDR_Lead_Owner_Name__c)){
                        autoAcceptedLead.SDR_Lead_Owner_Name__c = Null;
                        autoLeadCount = 1;
                    }
                }
                if(autoLeadCount != 0){
                    LeadsToUpdate.add(autoAcceptedLead);
                }  
            }
        }
        
        // Process Actual Leads
        if(AcceptedLeads.size() >0){
            system.debug('LeadOwnerMap=='+LeadOwnerMap);
            for(User u : [select id,name,Email,Marketing_Call_Center__c,Profile.name,UserRole.Name from user Where ID IN:LeadOwnerMap.values()]){
                system.debug(u.Profile.name);
                system.debug(u.UserRole.name);
                if(u.Profile.name == 'Cisco_NGCC' || (u.Profile.name != 'Cisco_Integration_Echo_Suppression' && 
                                                      (u.UserRole != null && ( u.UserRole.Name.Contains('SDR') ||  u.UserRole.Name.Contains('NGCC-CC Site Manager'))) 
                                                     )
                  ){
                      Usermap.put(u.id,u);
                  }
            }
            system.debug('Usermap=='+Usermap);
            for(Lead UpdatedLead : AcceptedLeads){
                if(LeadOwnerMap.ContainsKey(UpdatedLead.id) && Usermap.containsKey(LeadOwnerMap.get(UpdatedLead.id))){
                    Integer leadUpdated = 0;
                    system.debug('Marketing Call center=='+Usermap.get(LeadOwnerMap.get(UpdatedLead.id)));
                    if(string.isBlank(UpdatedLead.Call_Center_Vendor__c)){
                        if(flsUpdateGet(lead.Call_Center_Vendor__c)){
                            UpdatedLead.Call_Center_Vendor__c = Usermap.get(LeadOwnerMap.get(UpdatedLead.id)).Marketing_Call_Center__c;
                            leadUpdated = 1;
                        }
                    }
                    if(UpdatedLead.SDR_Assignment_DateTime__c == Null){
                        if(flsUpdateGet(lead.SDR_Assignment_DateTime__c)){
                            UpdatedLead.SDR_Assignment_DateTime__c = datetime.now();
                            leadUpdated = 1;
                        }
                    }
                    if(UpdatedLead.SDR_Assignment_Date__c == Null){
                        if(flsUpdateGet(lead.SDR_Assignment_Date__c)){
                            UpdatedLead.SDR_Assignment_Date__c = System.Today();
                            leadUpdated = 1;
                        }
                    }
                    if(string.isBlank(UpdatedLead.SDR_Lead_Owner_Email__c)){
                        if(flsUpdateGet(lead.SDR_Lead_Owner_Email__c)){
                            UpdatedLead.SDR_Lead_Owner_Email__c = Usermap.get(LeadOwnerMap.get(UpdatedLead.id)).Email; 
                            leadUpdated = 1;
                        }
                    }
                    if(string.isBlank(UpdatedLead.SDR_Lead_Owner_New__c)){
                        if(flsUpdateGet(lead.SDR_Lead_Owner_New__c)){
                            UpdatedLead.SDR_Lead_Owner_New__c = Usermap.get(LeadOwnerMap.get(UpdatedLead.id)).id;
                            leadUpdated = 1;
                        }
                    }
                    if(string.isBlank(UpdatedLead.SDR_Lead_Owner_Name__c)){
                        if(flsUpdateGet(lead.SDR_Lead_Owner_Name__c)){
                            UpdatedLead.SDR_Lead_Owner_Name__c = Usermap.get(LeadOwnerMap.get(UpdatedLead.id)).name;
                            leadUpdated = 1;
                        }
                    }
                    if(UpdatedLead.LeadSource != 'NGCC'){
                        if(flsUpdateGet(lead.LeadSource)){
                            UpdatedLead.LeadSource = 'NGCC';
                        }
                        leadUpdated = 1;
                    }
                    if(leadUpdated != 0){
                        LeadsToUpdate.add(UpdatedLead);
                    }
                }
            }
        }        
        Database.SaveResult[] srList = new Database.SaveResult[]{};
            if(LeadsToUpdate.size() > 0){
                srList = Database.update(LeadsToUpdate, false);
            }      
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                System.debug('Successfully Updated Lead. Lead ID: ' + sr.getId());
            }
            else {               
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Lead fields that affected this error: ' + err.getFields());
                }
            }
        }
    }
    global void finish(Database.BatchableContext BC){
        
    }
}