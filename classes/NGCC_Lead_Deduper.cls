/***************************************************************************************************
Name    : NGCC Lead Deduper 
Author  : Serge Borysov
Purpose : This class is responsible for the management of Lead De-Duping Process and Business Rules 
Created Date: 3/16/2016
Modification History: 
1.  Author:- Zakeer Ahmed
    Date:- Mar-06-2018
    Purpose:- CMC-Iron release sprint 19&20, added logical conditions under suppressor() and suppressLead() with lead_Category__c field.
    Changes: 
        1. In identifier():- added fields to "duplicateLeads" variable in SOQL
        2. suppressor(): added from line 163-195 & 212-217
        3. suppressLead(): from line 251-272
        4. exisLeadCBDMoreThanTodayWithin30Days() : added new method, line 337-340
        5. suppressionRule(): modified from line 343-391
        6. Created methods:
        a. exisLeadCBDMoreThanTodayWithin30Days(),exisLeadCBDPriorToYesterday() ,suppressExisLeadPriorToYest(),suppressExisNewLeadHRAndBant()
        7. added systemSuppression reason for Medium_Type: line#:281
        8. added var leadCategoryVal for future changes in lead category criteria.

2.  Author  : Ghattamaneni Chaithanya
    Purpose : Scava Fixes
    Changes : 
        1. Added SCAVA Helper Methods
        2. Added SCAVA Fixes in suppressor(),copyNotes(),suppressLead(),newLeadProcessing(),createDuplicateResponse() methods
    date    : Oct 15,2018

3. Author   :  Deepak Chamola
   Purpose  :  PRB0054045 - If there is an existing record in NGCC that has an outcome of Call back and a new record passes to NGCC
               then the new record should have a lead source of NGCC and the old record should be Eloqua.
   Changes  :  Added Code to change Lead Source at Line 172-178, 186-192, 194-200, 366-372
   Date     :  April 1,2019               
*****************************************************************************************************/
global class NGCC_Lead_Deduper implements Database.Batchable < sObject > {
    public String query;
    public static String leadCategoryVal = 'HAND RAISER';
    
    public static list < NGCC_Suppressed_Lead__c > suppressedLeads = new list < NGCC_Suppressed_Lead__c > ();
    
    public static list < CC_Response__c > duplicateResponses = new List < CC_Response__c > ();
    
    global NGCC_Lead_Deduper(String query) {
        this.query = query;
    }
    
    // select all pre-prospect leads
    global Database.QueryLocator start(Database.BatchableContext info) {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext info, List < Lead > scope) {
        
        for (Lead preProspect: scope) {
            try {
                if (preProspect.Status == 'Pre-Prospect') {
                    preProspect.Status = 'New Prospect';
                }
            } catch (Exception e) {
                System.Debug('Alert ERROR:' + e);
                System.Debug(preProspect.Status);
            }
            
            
            if (preProspect.Partner_Owned_Contact_Flag__c != true) {
                preProspect.DedupeRecord__c = null;
                preProspect.DeduperProcessing__c = true;
            }
        }
        leadDeduper(scope);
        System.Debug('Line 39');
    }
    
    public static void leadDeduper(List < Lead > scope) {
        List < Lead > preProspectLeads = new List < Lead > ();
        Database.SaveResult[] saveResult = Database.update(scope, false);
        Map < Id, Id > duplicateLeadIds = saveResultRules(scope, saveResult);
        System.Debug(duplicateLeadIds + ' duplicateRecords52');
        
        identifier(scope, duplicateLeadIds);
        
    }
    
    global void finish(Database.BatchableContext info) {
        
    }
    
    public static Map < Id,
        Id > saveResultRules(List < Lead > scope, Database.SaveResult[] saveResult) {
            
            Map < Id, Id > duplicateLeadIds = new Map < ID, ID > ();
            
            Integer i = 0;
            System.Debug(saveResult + ' line66');
            for (Database.SaveResult sr: saveResult) {
                if (sr.isSuccess()) {
                    System.debug(scope.get(i) + ' getting the I from LIne69');
                    scope.remove(i);
                } else {
                    for (Database.Error error: sr.getErrors()) {
                        // If there are duplicates, an error occurs
                        // Process only duplicates and not other errors 
                        //   (e.g., validation errors) 
                        
                        if (error instanceof Database.DuplicateError) {
                            Database.DuplicateError duplicateError = (Database.DuplicateError) error;
                            Datacloud.DuplicateResult duplicateResult = duplicateError.getDuplicateResult();
                            Datacloud.MatchResult[] matchResults = duplicateResult.getMatchResults();
                            // Just grab first match result (which contains the 
                            //   duplicate record found and other match info)
                            Datacloud.MatchResult matchResult = matchResults[0];
                            Datacloud.MatchRecord[] matchRecords = matchResult.getMatchRecords();
                            //Zak: calling the getLatestExistingLead function
                            Lead existingLead = getLatestExistingLead(matchRecords);
                            duplicateLeadIds.put(scope.get(i).Id, existingLead.Id);
                            // Add matched record to the duplicate records variable
                        } else {
                            System.debug(error);
                        }
                    }
                    i++;
                }
                
            }
            return duplicateLeadIds;
        }
    
    public static void identifier(List < Lead > scope, Map < Id, Id > duplicateLeadIds) {
        List < Id > duplicates = duplicateLeadIds.values();
        List < Lead > duplicateLeads = [select Id, Theater__c,ProgramEvent__c, Lead_Category__c, LastModifiedDate, MQL_Created_Date__c, Call_Back_Date_Time__c, Outcome__c, RecordTypeId, Source_System__c, Latest_Agent_Notes__c, Description, CustomCountry__c, Status, Call_Status__c, Latest_Lead_Acceptance_Date__c, Lead_Qualified_Date__c,
                                        Partner_Lead_Status__c, Medium_Type__c, MODS_Contact__c, Campaign_Name__r.Call_Script__c, Partner_Owned_Contact_Flag__c, Source_Event_Number__c, CreatedDate from Lead where Id IN: duplicates
                                       ];
        Map < Id, Lead > duplicateMap = new Map < Id, Lead > (duplicateLeads);
        List < Lead > updatedLeads = new List < Lead > ();
        for (Lead newLead: scope) {
            Id duplicateLeadIdentifier = duplicateLeadIds.get(newLead.Id);
            Lead existingLead = duplicateMap.get(duplicateLeadIdentifier);
            updatedLeads.addAll(suppressor(existingLead, newLead));
        }
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true;
        
        set < Lead > tmpSet = new set < Lead > ();
        if (updatedLeads.size() > 0) {
            tmpSet.addAll(updatedLeads);
            updatedLeads.clear();
            updatedLeads.addAll(tmpSet);
        }
        Database.SaveResult[] saveResult = Database.update(updatedLeads, dml);
        Database.SaveResult[] responseSave = Database.insert(duplicateResponses);
        List < Lead > inactiveQueueUpdatedLeads = new List < Lead > (inactiveQueueMapping(updatedLeads));
        tmpSet = new set < Lead > ();
        if (inactiveQueueUpdatedLeads.size() > 0) {
            tmpSet.addAll(inactiveQueueUpdatedLeads);
            inactiveQueueUpdatedLeads.clear();
            inactiveQueueUpdatedLeads.addAll(tmpSet);
        }
        Database.SaveResult[] inactiveQueueResults = Database.update(inactiveQueueUpdatedLeads, dml);
        
        if (suppressedLeads.size() > 0) {
            insert suppressedLeads;
        }
    }
    
    //Supress exisitng or new lead
    public static List < Lead > suppressor(Lead existingLead, Lead newLead) {
        List < Lead > updatedLeads = new List < Lead > ();
        if (existingLead.Partner_Owned_Contact_Flag__c != true) {
            system.debug(LoggingLevel.debug, 'Check>> 3: ' + existingLead.Status + '   >>Call Status>>' + existingLead.Call_Status__c + '  >>existingLead ID>>' + existingLead.id + '>>existingLead Call Status>>' + existingLead.Call_Status__c + '  >>>Existing Medium Type>> ' + existingLead.Medium_Type__c + '>>NewLead ID' + newLead.id + '>>NewLead Status>>' + newLead.Status + '>>NewLead Call Status >> ' + newLead.Call_Status__c + '>>NewLead Medium Type >> ' + newLead.Medium_Type__c + '>>NewLead Created Date' + newLead.CreatedDate);
            //Prioritizing Hand Raiser leads with new rules, based on 151754
            if(exisLeadCBDPriorToYesterday(existingLead)){
                newlead = newLeadProcessing(newLead);
                /* Changes by dchamola */
                if(newlead.Source_Event_Number__c.StartsWith('EQ')){
                    //SCAVA
                    if(flsUpdateGet(Lead.LeadSource)){
                        newlead.LeadSource = 'NGCC';
                    }//SCAVA
                }
                existingLead = suppressLead(existingLead, 'Inactive', newLead);
                System.Debug('FirstRule: PriorToYesterday');
                updatedLeads.add(existingLead);
                updatedLeads.add(newLead);
                suppressedLeads.add(new NGCC_Suppressed_Lead__c(Active_Lead__c = newLead.id, Suppressed_Lead__c = existingLead.id, Description__c = existingLead.Description));
            } else if (newLead.Lead_Category__c == leadCategoryVal && ((existingLead.Lead_Category__c != leadCategoryVal || existingLead.Lead_Category__c == leadCategoryVal) && exisLeadCBDMoreThanTodayWithin30Days(existingLead))) {
                newlead = newLeadProcessing(newLead);
                /* Changes by dchamola */
                if(newlead.Source_Event_Number__c.StartsWith('EQ')){
                    //SCAVA
                    if(flsUpdateGet(Lead.LeadSource)){
                        newlead.LeadSource = 'NGCC';
                    }//SCAVA
                }
                existingLead = suppressLead(existingLead, 'Inactive', newLead);
                /* Changes by dchamola */
                if(existingLead.Source_Event_Number__c.StartsWith('EQ')){
                    //SCAVA
                    if(flsUpdateGet(Lead.LeadSource)){
                        existingLead.LeadSource = 'Eloqua';
                    }//SCAVA
                }
                updatedLeads.add(existingLead);
                updatedLeads.add(newLead);
                suppressedLeads.add(new NGCC_Suppressed_Lead__c(Active_Lead__c = newLead.id, Suppressed_Lead__c = existingLead.id, Description__c = existingLead.Description));
            } else if (newLead.Lead_Category__c != leadCategoryVal && ((existingLead.Lead_Category__c == leadCategoryVal || existingLead.Lead_Category__c != leadCategoryVal) && exisLeadCBDMoreThanTodayWithin30Days(existingLead))) {
                newLead = suppressLead(newLead, 'Inactive', existingLead);
                updatedLeads.add(existingLead);
                updatedLeads.add(newLead);
                //SCAVA
                if (flsGet(Lead.Description)){
                    suppressedLeads.add(new NGCC_Suppressed_Lead__c(Active_Lead__c = existingLead.id, Suppressed_Lead__c = newLead.id, Description__c = newLead.Description));
                }//SCAVA
            } else if (suppressionRule(existingLead)) {
                newlead = suppressLead(newLead, 'Inactive', existingLead);
                existingLead = copyNotes(newLead, existingLead);
                updatedLeads.add(existingLead);
                updatedLeads.add(newLead);
                suppressedLeads.add(new NGCC_Suppressed_Lead__c(Active_Lead__c = existingLead.id, Suppressed_Lead__c = newLead.id, Description__c = newLead.Description));
            } else if (existingLead.Status == 'New Prospect' && existingLead.Call_Status__c == 'Open') {
                newlead = newLeadProcessing(newLead);
                existingLead = suppressLead(existingLead, 'Inactive', newlead);
                updatedLeads.add(existingLead);
                updatedLeads.add(newLead);
                suppressedLeads.add(new NGCC_Suppressed_Lead__c(Active_Lead__c = newLead.id, Suppressed_Lead__c = existingLead.id, Description__c = existingLead.Description));
            } else if (suppressionRule(existingLead) && (newLead.Medium_Type__c != 'Inbound Call' && newLead.Medium_Type__c != 'Inbound Chat')) {
                newlead = suppressLead(newLead, 'Inactive', existingLead);
                existingLead = copyNotes(newLead, existingLead);
                updatedLeads.add(existingLead);
                updatedLeads.add(newLead);
                suppressedLeads.add(new NGCC_Suppressed_Lead__c(Active_Lead__c = existingLead.id, Suppressed_Lead__c = newLead.id, Description__c = newLead.Description));
            } else if (existingLead.Status == 'Approval Pending' && (newLead.Medium_Type__c == 'Inbound Call' || newLead.Medium_Type__c == 'Inbound Chat')) {
                newlead = suppressLead(newLead, 'Inactive', existingLead);
                existingLead = copyNotes(newLead, existingLead);
                updatedLeads.add(existingLead);
                updatedLeads.add(newLead);
                suppressedLeads.add(new NGCC_Suppressed_Lead__c(Active_Lead__c = existingLead.id, Suppressed_Lead__c = newLead.id, Description__c = newLead.Description));
            } else {
                newlead = newLeadProcessing(newLead);
                system.debug('>>>DEdupe<<' + newLead.DedupeRecord__c + ' >>ID<<' + newLead.id);
                updatedLeads.add(newLead);
            }
        }
        return updatedLeads;
        
    }
    
    //Copy Description notes from new lead to approval pending lead (existing lead ) 
    public static Lead copyNotes(Lead newLead, Lead extLead) {
        if (extLead.status == 'Approval Pending') {
            system.debug('Approval Pending  ' + newLead.Description);
            if (newLead.Description != null) {
                if (extLead.Description != null) {
                    if(flsUpdateGet(Lead.Description)||flsGet(Lead.Description)){
                    extLead.Description = extLead.Description + '\n----------- \n Additional Notes from latest interaction (' + (System.now()).date().format() + '): \n ' + newLead.Description;
                    }
                    if(flsUpdateGet(lead.NGCC_Win_Lead__c)||flsGet(lead.NGCC_Win_Lead__c)){
                    extLead.NGCC_Win_Lead__c = true;
                    }
                } else {
                    if(flsUpdateGet(Lead.Description)||flsGet(Lead.Description)){
                    extLead.Description = ' Additional Notes from latest interaction (' + (System.now()).date().format() + '): \n  ' + newLead.Description;
                    }
                    //SCAVA
                    if(flsUpdateGet(lead.NGCC_Win_Lead__c)||flsGet(lead.NGCC_Win_Lead__c)){
                        extLead.NGCC_Win_Lead__c = true;
                    }//SCAVA
                }
            }
        }
        return extLead;
    }
    
    //updating Lead Status, and supression reason
    public static Lead suppressLead(Lead inputLead, String status, Lead wonLead) {
        suppressExisNewLeadHRAndBant(inputLead, wonLead);
        if(exisleadCBDPriorToYesterday(inputLead)){
            suppressExisLeadPriorToYest(inputLead, wonLead);
        } else if ((wonLead.Status == 'Marketing Qualified' && wonLead.MQL_Created_Date__c > (Datetime.now()-1) && wonLead.MQL_Created_Date__c <=(DateTime.Now() + 2))) {
            //SCAVA
            if(flsUpdateGet(Lead.Suppression_Reason__c)||flsGet(Lead.Suppression_Reason__c)){
                inputLead.Suppression_Reason__c = 'Record rejected due to existing record in MQL status. \n Active Lead ID: ' + wonLead.Id;
            }//SCAVA
        } else if ((wonLead.Status == 'Rejected' && wonLead.LastModifiedDate >= (Datetime.now() - 2))) {
            inputLead.Suppression_Reason__c = 'An existing lead has been found in the system that has been rejected by the CC Manager. \n Active Lead ID: ' + wonLead.Id;
        } else if ((wonLead.Status == 'Send to Sales' && wonLead.Lead_Qualified_Date__c >= (Datetime.now() - 2))) {
            inputLead.Suppression_Reason__c = 'An existing lead has been found in the system that is to be Sent to Sales. \n Active Lead ID: ' + wonLead.Id;
        } else if ((wonLead.Status == 'Picked for Routing' && wonLead.MQL_Created_Date__c >= (Datetime.now() - 2))) {
            inputLead.Suppression_Reason__c = 'An existing lead has been found in the system that has been picked for routing. \n Active Lead ID: ' + wonLead.Id;
        } else if ((wonLead.Status == 'Approval Pending' && wonLead.MQL_Created_Date__c >= (Datetime.now() - 2))) {
            inputLead.Suppression_Reason__c = 'Record rejected due to existing record is in Approval Pending  status. \n Active Lead ID: ' + wonLead.Id;
        } 
        else if (wonLead.Status == 'Marketing Qualified' || wonLead.Status == 'Rejected' || wonLead.Status == 'Send to Sales' || wonLead.Status == 'Picked for Routing') {
            inputLead.Suppression_Reason__c = 'Record rejected due to existing record in MQL status. \n Active Lead ID: ' + wonLead.Id;
        } else if (wonLead.Status == 'Approval Pending') {
            inputLead.Suppression_Reason__c = 'Record rejected due to existing record in Approval Pending  status. \n Active Lead ID: ' + wonLead.Id;
        } else {
            inputLead.Suppression_Reason__c = 'An existing lead has been found in the system. \n Active Lead ID: ' + wonLead.Id;
        }
        inputLead.Status = status;
        //SCAVA
        if(flsUpdateGet(Lead.Call_Status__c)||flsGet(Lead.Call_Status__c)){
            inputLead.Call_Status__c = 'Inactive';
        }
        if(flsUpdateGet(Lead.CustomCountry__c)||flsGet(Lead.CustomCountry__c)){
            inputlead.CustomCountry__c = inputlead.CustomCountry__c;
        }
        if (status == 'Inactive') {
            if(flsUpdateGet(Lead.Outcome__c)||flsGet(Lead.Outcome__c)){
                inputLead.Outcome__c = 'Duplicate Contact/Account';
            }//SCAVA
            if(flsUpdateGet(Lead.DedupeRecord__c)||flsGet(Lead.DedupeRecord__c)){
        inputLead.DedupeRecord__c = 'Dedupe';
        }
            inputLead.DedupeRecord__c = 'Dedupe';
            if(flsUpdateGet(Lead.Medium_Type__c)||flsGet(Lead.Medium_Type__c)){
            inputLead.Medium_Type__c = 'System Suppression';
            }
        }
        createDuplicateResponse(inputLead);
        return inputLead;
    }
    
    //Adding inactive leads to inactive queue 
    public static Set < Lead > inactiveQueueMapping(List < Lead > updatedLeads) {
        Map < Lead, String > inactiveLeads = new Map < Lead, String > ();
        Map < String, String > countryQueueMapping = new Map < String, String > ();
        Map < String, Id > inactiveNamingMapping = new Map < String, Id > ();
        List < QueueSObject > inactiveQueues = new List < QueueSObject > ();
        System.debug(updatedLeads.size());
        for (Lead updatedLead: updatedLeads) {
            if (updatedLead.Status == 'Inactive' && updatedLead.CustomCountry__c != null) {
                inactiveLeads.put(updatedLead, updatedLead.CustomCountry__c);
            }
        }
        if (inactiveLeads.size() > 0) {
            List < NGCC_Mapping_Object__c > mappings = [select id, name, Inactive_Queue_Name__c from NGCC_Mapping_Object__c where name =: inactiveLeads.values()];
            for (NGCC_Mapping_Object__c mapping: mappings) {
                countryQueueMapping.put(mapping.name, mapping.Inactive_Queue_Name__c);
            }
            inactiveQueues = [select id, Queue.Name, Queue.id from QueueSObject where queue.name =: countryQueueMapping.values()];
            for (QueueSObject inactiveQueue: inactiveQueues) {
                inactiveNamingMapping.put(string.valueOf(inactiveQueue.queue.name), inactiveQueue.Queue.Id);
            }
            for (Lead inactiveLead: inactiveLeads.keySet()) {
                if (inactiveLead.Medium_Type__c != 'Inbound Call' && inactiveLead.Medium_Type__c != 'Inbound Chat') {
                    inactiveLead.OwnerId = inactiveNamingMapping.get(countryQueueMapping.get(inactiveLead.CustomCountry__c));
                }
            }
        }
        Set < Lead > inactiveLeadsList = inactiveLeads.keySet();
        return inactiveLeadsList;
    }
    
    public static Lead newLeadProcessing(Lead inputLead) {
        if (inputLead.Status == 'Pre-Prospect') {
            //SCAVA
            if(flsUpdateGet(Lead.Status)||flsGet(Lead.Status)){
                inputLead.Status = 'New Prospect';
            }//SCAVA
        }
        system.debug('>>>DEdupe<<' + inputLead.DedupeRecord__c + ' >>ID<<' + inputLead.id);
        if(flsUpdateGet(Lead.DedupeRecord__c)||flsGet(Lead.DedupeRecord__c)){
        inputLead.DedupeRecord__c = null;
        }
        return inputLead;
    }
    
    private static Boolean exisLeadCBDMoreThanTodayWithin30Days(Lead inputLead) {
        return inputLead.Status == 'New Prospect' && inputLead.Call_Status__c == 'Call Back Later' && inputLead.Outcome__c == 'Call Back' && inputLead.Call_Back_Date_Time__c >(DateTime.Now()-1)&& inputLead.Call_Back_Date_Time__c <=(DateTime.Now() + 30);
    }
    private static Boolean exisLeadCBDPriorToYesterday(Lead inputLead) {
        return inputLead.Status == 'New Prospect' && inputLead.Call_Status__c == 'Call Back Later' && inputLead.Outcome__c == 'Call Back' && inputLead.Call_Back_Date_Time__c <=(DateTime.Now()-1);
    }
    private static void suppressExisLeadPriorToYest(Lead inputLead, Lead wonLead){
        if(wonLead.Lead_Category__c != leadCategoryVal){
            inputLead.Suppression_Reason__c = 'An Newer Record that is due to be called back has been found in the system. \n Active Lead ID: ' + wonLead.Id;
        } else {
            inputLead.Suppression_Reason__c = 'A New Handraiser Record that is due to be called back has been found in the system. \n Active Lead ID: '+wonLead.Id;
        }
        /* Changes by dchamola */
        if(inputLead.Source_Event_Number__c.StartsWith('EQ')){
            //SCAVA
            if(flsUpdateGet(Lead.LeadSource)){
                inputLead.LeadSource = 'Eloqua';
            }//SCAVA
        }
    }    
    private static void suppressExisNewLeadHRAndBant(Lead inputLead, Lead wonLead){    
        if ((wonLead.Lead_Category__c == leadCategoryVal && wonLead.Lead_Category__c == 'New Prospect') && ((inputLead.Lead_Category__c != leadCategoryVal || inputLead.Lead_Category__c == leadCategoryVal) && exisLeadCBDMoreThanTodayWithin30Days(inputLead))) {
            inputLead.Suppression_Reason__c = 'A New Handraiser Record that is due to be called back has been found in the system. \n Active Lead ID: ' + wonLead.Id;
        } else if ((inputLead.Lead_Category__c != leadCategoryVal && inputLead.Lead_Category__c == 'New Prospect') && ((wonLead.Lead_Category__c == leadCategoryVal || wonLead.Lead_Category__c != leadCategoryVal) && exisLeadCBDMoreThanTodayWithin30Days(wonLead))) {
            inputLead.Suppression_Reason__c = 'A New Handraiser Record that is due to be called back has been found in the system. \n Active Lead ID: ' + wonLead.Id;
        } 
    }
    public static Boolean suppressionRule(Lead inputLead) {
        Boolean isSuppressed = false;
        
        if (inputLead.Theater__C == 'APJ' &&
            inputLead.RecordTypeId == Schema.Sobjecttype.Lead.getRecordTypeInfosByName().get('Closed').getRecordTypeId()) {
                isSuppressed = false;
            } else if ((exisLeadCBDMoreThanTodayWithin30Days(inputLead)) || exisLeadCBDPriorToYesterday(inputLead) ||
                       (inputLead.Status == 'Marketing Qualified' && inputLead.MQL_Created_Date__c >= (Datetime.Now() - 2)) ||
                       (inputLead.Status == 'Approval Pending' && inputLead.MQL_Created_Date__c >= (Datetime.Now() - 2)) ||
                       (inputLead.Status == 'Rejected' && inputLead.LastModifiedDate >= (Datetime.Now() - 2)) ||
                       (inputLead.Status == 'Send to Sales' && inputLead.Lead_Qualified_Date__c >= (Datetime.Now() - 2)) ||
                       (inputLead.Status == 'Picked for Routing' && inputLead.MQL_Created_Date__c >= (Datetime.Now() - 2))
                      ) {
                          isSuppressed = true;
                          System.debug('<<<<Condition met,  status update 1>>>>');
                      } else if ((inputLead.Status == 'Rejected' && inputLead.Call_Status__c == 'Call Completed') ||
                                 (inputLead.Status == 'Cancel') ||
                                 (inputLead.Status == '3.1 Rejected-Invalid Contact') ||
                                 (inputLead.Status == '3.2 Rejected-Already oppty') ||
                                 (inputLead.Status == '3.4 Rejected-Enterprise/Named') ||
                                 (inputLead.Status == '3.5 Rejected-Project Canceled') ||
                                 (inputLead.Status == '3.6 Rejected-Lost to Competition') ||
                                 (inputLead.Status == '3.7 Rejected-Not My Territory/Account') ||
                                 (inputLead.Status == '3.8 Rejected-No Cisco Response(Admin Onl') ||
                                 (inputLead.Status == '3.9 Rejected-No Customer Response') ||
                                 (inputLead.Status == '3.11 Rejected-Duplicate') ||
                                 (inputLead.Status == '3.12 Rejected-No Valid Project') ||
                                 (inputLead.Status == '2 Accepted-Mine/Channel' && inputLead.Partner_Lead_Status__c == 'Deal Created') ||
                                 (inputLead.Status == '2 Accepted-Mine/Channel' && inputLead.Partner_Lead_Status__c == 'Closed-Order Through Stock') ||
                                 (inputLead.Status == '2 Accepted-Mine/Channel' && inputLead.Partner_Lead_Status__c == 'Closed-Order Through Disti')) {
                                     isSuppressed = false;
                                     system.debug('<<<<Condition met, no status update 2>>>>');
                                 }
        return isSuppressed;
    }
    
    //Creating CC Response for duplicate records.
    public static void createDuplicateResponse(Lead inputLead) {
        CC_Response__c duplicateResponse = new CC_Response__c();
        // SCAVA
        if(flsGet(CC_Response__c.Name)){
            duplicateResponse.Name = 'Duplicate ' + DateTime.Now();
        }
        if(flsGet(CC_Response__c.Lead__c)){
            duplicateResponse.Lead__c = inputLead.Id;
        }
       if(flsGet(CC_Response__c.Status__c)){
            duplicateResponse.Status__c = 'Duplicate Contact/Account';
        }
        if(flsGet(CC_Response__c.Response_Type__c)){
            duplicateResponse.Response_Type__c = 'System Suppression';
        }
        if(flsGet(CC_Response__c.Campaign__c)){
            duplicateResponse.Campaign__c = inputLead.Campaign_Name__c;
        }       
        if(flsGet(CC_Response__c.Source_Event_Number__c)){
            duplicateResponse.Source_Event_Number__c = inputLead.Source_Event_Number__c;
        }
        if (inputLead.MODS_Contact__c != null) {
            if(flsGet(CC_Response__c.MODS_Contact__c)){
                duplicateResponse.MODS_Contact__c = inputLead.MODS_Contact__c;
            }
        }
        if(flsGet(CC_Response__c.Key_Code__c)){
            duplicateResponse.Key_Code__c = inputLead.ProgramEvent__c;
        }
        if(flsGet(CC_Response__c.Response_Date_Time__c)){
            duplicateResponse.Response_Date_Time__c = dateTime.now();
        }
        if(flsGet(CC_Response__c.Call_Status__c)){
            duplicateResponse.Call_Status__c = 'Inactive';
        }
        if(inputLead.Description != null) {
            if(flsGet(CC_Response__c.Lead_Description__c)){
                duplicateResponse.Lead_Description__c = inputLead.Description;
            }//SCAVA
        }
        duplicateResponses.add(duplicateResponse);
    }
    
    public static Lead getLatestExistingLead(Datacloud.MatchRecord[] matchRecords) {
        Integer matchedRecordSize = 0;
        matchedRecordSize = matchRecords.size();
        System.Debug(matchedRecordSize + ' recordSize');
        Datetime lastModified = null;
        Lead existingLead;
        if (matchedRecordSize > 0) {
            for (Integer x = 0; x < matchedRecordSize; x++) {
                Lead currLead = (Lead) matchRecords[x].getRecord();
                String currentDate = String.ValueOf(currLead.get('LastModifiedDate'));
                
                Datetime latest = Datetime.ValueOf(currentDate);
                if (lastModified == null || existingLead == null) {
                    lastModified = latest;
                    existingLead = currLead;
                }
                if (latest > lastModified) {
                    lastModified = latest;
                    existingLead = currLead;
                }
            }
            
        }
        return existingLead;
    }
    // SCAVA Helper Method
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }
    
    // SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdateGet(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }
}