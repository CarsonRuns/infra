/*********************************************************************************************************************************
Name    : JiffleNowReportingBatchable_CLS
Author  : Mukesh Srivastava
Purpose : The purpose of the batch class to capture Jiffle Reporting Metrics  
            1) This process will run first to make sure to capture Opportunities newly created for all associated Jiffle CEE within 30days
            2) Perform Roll up summary for Events for 30 Days         
Created Date:  4/30/2015 
Modification History: For PBI000000054443 changed querylocator to pull meeting count value and added logic to check the same
while calculating new Opportunity related CEE records -- Added by Mohammed for october release.
                      
**********************************************************************************************************************************/
global class JiffleNowReporting_Batchable implements Database.Batchable < sObject > {
    global final Id g_idOfJiffleRec; // Global Variable to store JiffleRecordType Id

    global JiffleNowReporting_Batchable() {
        // Getting JiffleRecordType Id
        g_idOfJiffleRec = Schema.SObjectType.CEE__c.getRecordTypeInfosByName().get('Jifflenow (Event, Tradeshow, Conference)').getRecordTypeId();
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        // Building Query for collecting Accounts associated to CEE which has not crossed 15 day of Events
        String strCEEQuery = 'SELECT Primary_Account__c,Jiffle_Reporting_Tracker__c, Jiffle_Event__c,Jiffle_Event__r.Event_Start_Date__c,Jiffle_Event__r.Event_End_Date__c,Count_of_Meetings__c from CEE__c WHERE RecordTypeId =\'' + g_idOfJiffleRec + '\'';
        strCEEQuery = strCEEQuery + ' AND (Jiffle_Event__r.Event_End_Date__c = LAST_N_DAYS:180 OR Jiffle_Event__r.Event_Start_Date__c >= TODAY)';
        return database.getQueryLocator(strCEEQuery);
    }

    global void execute(Database.BatchableContext BC, List < sObject > scope) {
        List < CEE__c > lstCEEs = scope; // Converting scope to list for processing and updates
        Set < Id > setAccountId = new Set < Id > (); // Set of Account Id for which we need to look for new Opportunit
        List < CEE__c > newOpptyCEE = new List < CEE__c > (); // List of New CEE which need to be created
        Map < Id, List < CEE__c >> mapAccountCEEs = new Map < Id, List < CEE__c >> ();
        Date todayDate = date.today();
        List < CEE__c > lstForReporting = new List < CEE__c > ();

        // Process all the CEEs to get the accounts and map of Account with multiple events(CEE Object)
        for (CEE__c ceeObj: lstCEEs) {
            Integer daysAfterEvent = ceeObj.Jiffle_Event__r.Event_End_Date__c.daysBetween(todayDate);
            Integer daysBeforeEvent = ceeObj.Jiffle_Event__r.Event_Start_Date__c.daysBetween(todayDate);
            Integer MeetingCount = Integer.valueof(ceeObj.Count_of_Meetings__c);

            // Checking if Event has reached 30,90 or 180 or starting next day
            system.debug('daysBeforeEvent' + daysBeforeEvent);
            system.debug('daysAfterEvent ' + daysAfterEvent);
            
        
             
            if (daysBeforeEvent == -1 || daysAfterEvent == 30 || daysAfterEvent == 90 || daysAfterEvent == 180) {
                ceeObj.Jiffle_Reporting_Tracker__c = ceeObj.Jiffle_Reporting_Tracker__c + 1;
                lstForReporting.add(ceeObj);
            }
            if (MeetingCount > 0){
            if (daysAfterEvent > 0) {
                if (daysAfterEvent <= 31) {
                    // Adding AccountId to be Queried for new Oppty
                    setAccountId.add(ceeObj.Primary_Account__c);

                    // Preparing map for which we would need to create new CEE if new Opportunity found
                    if (!mapAccountCEEs.isEmpty()) {
                        if (mapAccountCEEs.containsKey(ceeObj.Primary_Account__c)) {
                            mapAccountCEEs.get(ceeObj.Primary_Account__c).add(ceeObj);
                        } else {
                            mapAccountCEEs.put(ceeObj.Primary_Account__c, new List < CEE__c > {
                                ceeObj
                            });
                        }
                    } else {
                        mapAccountCEEs.put(ceeObj.Primary_Account__c, new List < CEE__c > {
                            ceeObj
                        });
                    }
                }
            }
            } // end of MeetingCount check
        }

        // Validate if any Account of CEE need to look for Opporty as this will run everyday
        if (!setAccountId.isEmpty()) {
            for (Opportunity OppObj: [SELECT Id, AccountId,Name from Opportunity WHERE AccountId IN: setAccountId AND CREATEDDATE = TODAY]) {
                if (mapAccountCEEs.containsKey(OppObj.AccountId)) {
                    // Creating new CEE for each Opportunity created for an Account
                    for (CEE__c ceObj: mapAccountCEEs.get(OppObj.AccountId)) {
                        CEE__c cObj = new CEE__c();
                        cObj.Primary_Account__c = ceObj.Primary_Account__c;
                        cObj.Opportunity__c = OppObj.Id;
                        cObj.Jiffle_Event__c = ceObj.Jiffle_Event__c;
                        cObj.RecordTypeId = g_idOfJiffleRec;
                        cObj.Jiffle_Opportunity_Type__c = 'New';
                        cObj.Unique_Association__c = ceObj.Jiffle_Event__c+''+ceObj.Primary_Account__c+''+OppObj.Name;
                        newOpptyCEE.add(cObj);
                    }
                }
            }
        }
        // If new Opportunities are created for scoped CEE Accounts then Submit to database
        if (!newOpptyCEE.isEmpty()) {
            Schema.SObjectField extId = CEE__c.Fields.Unique_Association__c;
            Database.UpsertResult[] lstJiffleSaveResult = Database.upsert(newOpptyCEE,extId, false);
            system.debug('testing....'+lstJiffleSaveResult);
        }

        // if CEE has match specifed reporting period then update.
        if (!lstForReporting.isEmpty()) {
            Database.SaveResult[] lstJiffleReportingSaveResult = Database.update(lstForReporting, false);
            
        }

        // If new CEEs are Created then calculate # of Unique Accounts and Opportunities for event
        List < CEE__c > lstNewCEEsEvent = [Select Id from CEE__c WHERE CreatedDate = TODAY];
        if (lstNewCEEsEvent.size() > 0) {
            setJiffleEventsMetrics();
        }
    }

    global void finish(Database.BatchableContext BC) {
        // Logging the status of Job in Tx Log Object
        AsyncApexJob aObj = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors FROM AsyncApexJob WHERE ID = : BC.getJobId()];
        String MessageBody = 'Status : ' + aObj.Status + '\r\n ';
        MessageBody = MessageBody + 'Total Batches : ' + aObj.TotalJobItems + '\r\n ';
        MessageBody = MessageBody + 'Total Batches Procesed : ' + aObj.JobItemsProcessed + '\r\n ';
        MessageBody = MessageBody + 'Failed Batches : ' + aObj.NumberOfErrors + '\r\n ';

        Boolean bStatus = false;
        if (aObj.NumberOfErrors > 0) {
            bStatus = true;
        }

        Tx_Log__c tlObj = new Tx_Log__c();
        tlObj.Name = 'JiffleReportingBatchUpdates' + System.Now();
        tlObj.exception__c = bStatus;
        tlObj.message__c = MessageBody;
        tlObj.originated__c = 'JiffleReportingBatchUpdates';
        tlObj.type__c = 'Jiffle Reporting';
        Database.SaveResult logInsertResult = Database.insert(tlObj, false);
    }

    /**********************************************************Jiffle Event Metrics***************************************************/
    //@Method: To calculate Event metrics when new CEE record created for Event havent passed 30 days or event is starting
    public void setJiffleEventsMetrics() {
        List < Jiffle_Event__c > lstEventMetrics = new List < Jiffle_Event__c > ();
        Map < Id, Jiffle_Event__c > mapIdJiffleEvent = new Map < Id, Jiffle_Event__c > ();
        Set < String > setEventAccountId = new Set < String > ();

        for (AggregateResult eObj: [Select Jiffle_Event__c, Primary_Account__c, Opportunity__c, Count(Id) from CEE__c
                WHERE(Jiffle_Event__r.Event_End_Date__c = LAST_N_DAYS: 30 OR Jiffle_Event__r.Event_Start_Date__c >= TODAY) AND RecordTypeId = : g_idOfJiffleRec
                AND Jiffle_Opportunity_Type__c = 'Existing' AND Count_of_Meetings__c > 0    
                GROUP BY Jiffle_Event__c, Primary_Account__c, Opportunity__c
            ]) {

            String strEventAccount = String.valueOf(eObj.get('Jiffle_Event__c')) + '' + String.valueOf(eObj.get('Primary_Account__c'));
            String strId = String.valueOf(eObj.get('Jiffle_Event__c'));

            // Check if any Records are aleady processed or not, 
            //        if No then add new Event Id on Sobject with Values as 1
            //        if Yes then validate of that contain same account and event combination so that we dont double count the account
            if (!setEventAccountId.isEmpty()) {
                if (setEventAccountId.contains(strEventAccount)) {
                    Jiffle_Event__c jObj = mapIdJiffleEvent.get(strId);
                    //system.debug('!!!!!!!' + jObj);
                    if (String.valueOf(eObj.get('Opportunity__c')) != NULL && jObj.Total_Unique_Opportunities__c != NULL) {
                        integer i = jObj.Total_Unique_Opportunities__c.intValue() + 1;
                        jObj.put('Total_Unique_Opportunities__c', i);
                    }
                    jObj.put('Total_Engagements__c', jObj.Total_Engagements__c + Integer.valueOf(eObj.get('expr0')));
                    mapIdJiffleEvent.put(strId, jObj);
                    // if its different account then validate whether current is already added or not
                    // if added then increment account count and opportunity as in one event one opportunity will be added once only 
                    // if not added then  add new Event Id on Sobject with Values as 1
                } else if (mapIdJiffleEvent.containsKey(strId)) {
                    Jiffle_Event__c jObj = mapIdJiffleEvent.get(strId);
                    //system.debug('!!!!!!!' + jObj);
                    if (String.valueOf(eObj.get('Opportunity__c')) != NULL && jObj.Total_Unique_Opportunities__c != NULL) {
                        integer i = jObj.Total_Unique_Opportunities__c.intValue() + 1;
                        jObj.put('Total_Unique_Opportunities__c', i);
                    }

                    jObj.Total_Unique_Accounts__c = jObj.Total_Unique_Accounts__c + 1;
                    jObj.put('Total_Engagements__c', jObj.Total_Engagements__c + Integer.valueOf(eObj.get('expr0')));
                    mapIdJiffleEvent.put(strId, jObj);
                    setEventAccountId.add(strEventAccount);
                } else {
                    // if not added then  add new Event Id on Sobject with Values as 1
                    Jiffle_Event__c jEvt = new Jiffle_Event__c();
                    jEvt.Id = strId;
                    jEvt.Total_Unique_Accounts__c = 1;

                    if (String.valueOf(eObj.get('Opportunity__c')) != NULL) {
                        jEvt.Total_Unique_Opportunities__c = 1;
                    } else {
                        jEvt.Total_Unique_Opportunities__c = 0;
                    }
                    jEvt.Total_Engagements__c = Integer.valueOf(eObj.get('expr0'));

                    mapIdJiffleEvent.put(strId, jEvt);
                    setEventAccountId.add(strEventAccount);
                }
            } else {
                Jiffle_Event__c jEvt = new Jiffle_Event__c();
                jEvt.Id = strId;
                jEvt.Total_Unique_Accounts__c = 1;

                if (String.valueOf(eObj.get('Opportunity__c')) != NULL) {
                    jEvt.Total_Unique_Opportunities__c = 1;
                } else {
                    jEvt.Total_Unique_Opportunities__c = 0;
                }
                jEvt.Total_Engagements__c = Integer.valueOf(eObj.get('expr0'));
                mapIdJiffleEvent.put(strId, jEvt);
                setEventAccountId.add(strEventAccount);
            }
        }
        // Collect all the Events which need to updated in List
        List < Jiffle_Event__c > lstJNEvents = new List < Jiffle_Event__c > ();
        for (Jiffle_Event__c jnObj: mapIdJiffleEvent.values()) {
            lstJNEvents.add(jnObj);
        }
        // if Event list is not empty then update the event records
        if (!lstJNEvents.isEmpty()) {
            Database.SaveResult[] lstJiffleEventSaveResult = Database.update(lstJNEvents, false);
        }
    }
}