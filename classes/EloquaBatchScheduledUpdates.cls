/*********************************************************************************************************************************
Name    : EloquaBatchScheduledUpdates 
Author  : Mukesh Srivastava
Purpose : The purpose of the batch class to update all Open Manual leads associated to Eloqua Leads through email            
Created Date:  2/23/2015 
Modification History: 
    01/10/2016 - US10151 - Include eLeads records type for Eloqua updates
    03/28/2016 - US10928 - Added the fix to exclude Leads without Email ID from the process.
    03/28/2016 - Additional Debug messages are added for CPU exception debug.
                      
**********************************************************************************************************************************/
global class EloquaBatchScheduledUpdates implements Database.Batchable < sObject > {
    global final Map < String, EloquaFieldUpdates__c > eloquaFieldMapping;
    global final String g_strQuery;
    
    // Constructor: Dynamically generating SOQL for defining scope
    global EloquaBatchScheduledUpdates() {
        eloquaFieldMapping = EloquaFieldUpdates__c.getAll(); // Getting all instance if mapping custom setting
        string strEloquaQuery = 'SELECT Id';
        for (String efield: eloquaFieldMapping.keySet()) {
            strEloquaQuery += ',' + efield;
        }
        g_strQuery = strEloquaQuery;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String restStrQuery ;
        If(Test.isRunningTest()){
            restStrQuery = ' FROM Lead WHERE Eloqua_Updates__c = \'Yes\' LIMIT 30';  // using dynamic SOQL setting the scope
        }else{
            restStrQuery = ' FROM Lead WHERE Eloqua_Updates__c = \'Yes\'';  // using dynamic SOQL setting the scope
        }
        
        String strQuery = g_strQuery + restStrQuery;
        system.debug('SOQL Query'+strQuery);
        return Database.getQueryLocator(strQuery);
    }

    global void execute(Database.BatchableContext BC, List < sObject > scope) {
        try {
            Map < String, Lead > mapIdLeads = new Map < String, Lead > ();
            List < Lead > lstLeadToClear = new List < Lead > ();
            
            List<Lead> scopeSize = scope;
            System.debug('DEBUG:: Scope Size = '+scopeSize.size());
            
            //Collecting all the scoped leads and setting flag to No so that in next batch same records doesnt get processed
            for (Lead l: (List < Lead > ) scope) {
            //US10928 - Added the filter to exclude Leads without Email ID which is causing more than 1000 leads from the SOQL
                if(l.Email != null && l.Email != ''){
                    mapIdLeads.put(l.Email, l);
                    l.Eloqua_Updates__c = 'No';
                    lstLeadToClear.add(l);
                }
            }
            
            //US10151  - remvoed the code for manual record type and added the Custom Setting to configure the record types.
            List<Eloqua_Lead_Record_Type__c> lstRecordType = Eloqua_Lead_Record_Type__c.getAll().values();
            set<id> rdIdSet = new set<id>();
            for(Eloqua_Lead_Record_Type__c rdT : lstRecordType){
                rdIdSet.add(rdT.Record_Type_Id__c);
            }
            Set < String > setEmails = mapIdLeads.keySet();
            System.debug('DEBUG:: setEmails - '+setEmails);
            //Building Query to get all the Leads which need update
            //US10151  - Updated the query to use all record types from the Custom Setting, instead of only Manual.
            String strUpdate = g_strQuery + ' FROM Lead WHERE Email IN : setEmails AND Eloqua_Updates__c = \'No\' AND RecordTypeId IN :rdIdSet AND Integrated_With_MCP__c = false';
            List < Lead > lstUpdateLeads = Database.query(strUpdate);
            System.debug('DEBUG:: lstUpdateLeads lead Size 1 - '+lstUpdateLeads.size());
            //Iterating over the duplicate leads where Eloqua Updates are not available and setting the Eloqua Update
            for (Lead lObj: lstUpdateLeads) {
                if (mapIdLeads.containsKey(lObj.Email)) {
                    for (String efield: eloquaFieldMapping.keySet()) {
                        lObj.put(efield, mapIdLeads.get(lObj.Email).get(efield));
                    }
                }
            }
            
            //Merging both newly updated leads and the leads which need to be set as No
            lstUpdateLeads.addAll(lstLeadToClear);
            System.debug('DEBUG:: lstUpdateLeads lead Size 2 - '+lstUpdateLeads.size());
            Database.SaveResult[] lstEloquaSaveResult = Database.update(lstUpdateLeads, false);
            
            //Iterating over the save result and validating if any error occurred
            Integer iRows = 0;
            List < Tx_Log__c > lstLog = new List < Tx_Log__c > ();
            for (Database.SaveResult dsr: lstEloquaSaveResult) {
                Tx_Log__c newErrorRecord = new Tx_Log__c(name = lstUpdateLeads[iRows].id, originated__c = 'EloquaBatchScheduledUpdates', type__c = 'Lead', exception__c = true);
                if (dsr.isSuccess() != true) {
                    if (dsr.getErrors().size() > 0) {
                        newErrorRecord.message__c = 'STATUS CODE: ' + dsr.getErrors()[0].getStatusCode() +
                            '\n ERROR: ' + dsr.getErrors()[0].getMessage() +
                            '\n AFFECTED FIELD: ' + dsr.getErrors()[0].getFields();
                    }
                    lstLog.add(newErrorRecord);
                }
                iRows++;
            }
            if (lstLog.size() > 0)
                Database.insert(lstLog, false);
        }
        Catch(Exception e) {
            //Catching any exception 
            Tx_Log__c tlObj = new Tx_Log__c();
            tlObj.exception__c = true;
            tlObj.message__c = e.getMessage();
            tlObj.originated__c = 'EloquaBatchScheduledUpdates';
            tlObj.type__c = 'Leads';
            Database.SaveResult logInsertResult = Database.insert(tlObj, false);
        }
    }
    global void finish(Database.BatchableContext BC) {
        //Notifying Admin about completion of Batch Process
        AsyncApexJob aObj = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors
            FROM AsyncApexJob WHERE ID = : BC.getJobId()
        ];

        String EmailToNotify = Apex_Batch_Job__c.getInstance('EloquaBatchJob').NotificationEmailId__c; // Using Custom setting to store Admin Email
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {
            EmailToNotify
        };
        mail.setToAddresses(toAddresses);
        mail.setSubject('Eloqua Leads Batch Processing - ' + System.Today());
        String MailBody = 'Status : ' + aObj.Status + '<br/>';
        MailBody = MailBody + 'Total Batches : ' + aObj.TotalJobItems + '<br/>';
        MailBody = MailBody + 'Total Batches Procesed : ' + aObj.JobItemsProcessed + '<br/>';
        MailBody = MailBody + 'Failed Batches : ' + aObj.NumberOfErrors + '<br/>';
        mail.setHtmlBody(MailBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
            mail
        }); 
    }
}