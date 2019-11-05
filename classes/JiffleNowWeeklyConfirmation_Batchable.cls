/*********************************************************************************************************************************
Name    : JiffleNowWeeklyConfirmation_Batchable
Author  : Mukesh Srivastava
Purpose : The purpose of the batch class to reminder requestor for Confirmation            
Created Date:  4/30/2015 
Modification History: 
                Awnish - Added logic to filter out the Attendees with status as Deleted/Declined and Email containing '@cisco.com' # INC000033332286 
                Awnish - Moved CEE & Attendee related query to Custom Labels               
**********************************************************************************************************************************/
global class JiffleNowWeeklyConfirmation_Batchable implements Database.Batchable < sObject >, Database.Stateful  {
    
    Map < String, SendEmail__c > mapOfEmailReminders = new Map < String, SendEmail__c >();
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // Getting Jiffle Record Type Id for filter
        Id idOfJiffleRec = Schema.SObjectType.CEE__c.getRecordTypeInfosByName().get('Jifflenow (Event, Tradeshow, Conference)').getRecordTypeId();
        // Building query to pull all CEE which has been tagged with Events ending within 15 days       
        String strCEEQuery = System.Label.JiifleNowConfirmationEmailCEEQuery;
        strCEEQuery = strCEEQuery + idOfJiffleRec + '\'';
        return database.getQueryLocator(strCEEQuery); // Defining list of records to be Processed
    }

    global void execute(Database.BatchableContext BC, List < sObject > scope) {
        try {
            List < CEE__c > lstCEE = scope; // Assigning Scope to List for iteration
            Set < Id > setConfCEE = new Set < Id > (); // Set of CEE Ids which need just confirmation
            Set < Id > setConfOverDueCEE = new Set < Id > (); // Set of CEE Ids which are overdue after 10 days
            Date todayDate = date.today(); // Getting current date
            List < SendEmail__c > lstNewProcessedReminders = new List < SendEmail__c > ();

            // Setting Overdue and Confirmation Sets
            for (CEE__c cObj: lstCEE) {
                Integer daysAfterEvent = cObj.Jiffle_Event__r.Event_End_Date__c.daysBetween(todayDate); // Getting difference of Today with Event end date
                if (daysAfterEvent < 10) {
                    setConfCEE.add(cObj.Id);
                } else {
                    setConfOverDueCEE.add(cObj.Id);
                }
            }
            
            // if Confirmation count is not empty then start calculating # for each Requestorr
            if (!setConfCEE.isEmpty() || !setConfOverDueCEE.isEmpty()) {
                mapOfEmailReminders.putAll(getRequestorEmail(setConfCEE, setConfOverDueCEE,mapOfEmailReminders));
            }
        }
        Catch(Exception e) {
            Tx_Log__c tlObj = new Tx_Log__c();
            tlObj.exception__c = true;
            tlObj.message__c = e.getMessage();
            tlObj.originated__c = 'JiffleReportingBatchProcessing';
            tlObj.type__c = 'CEE__c';
            Database.SaveResult logInsertResult = Database.insert(tlObj, false);
        }
    }

    global void finish(Database.BatchableContext BC) {
    
         // Inserting New Send Email Record so that emails can be trigger
            if (!mapOfEmailReminders.isEmpty()) {
                Database.SaveResult[] lstJiffleReminderSaveResult = Database.Insert(mapOfEmailReminders.values(), false);
            }
            
            
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
        tlObj.Name = 'JiffleWeeklyConfirmationReminder' + System.Now();
        tlObj.exception__c = bStatus;
        tlObj.message__c = MessageBody;
        tlObj.originated__c = 'JiffleWeeklyConfirmationReminder';
        tlObj.type__c = 'Jiffle Email Reminder';
        Database.SaveResult logInsertResult = Database.insert(tlObj, false);

    }

    //@ Method: Prepare Send Emails record for reminder data
    public Map < String, SendEmail__c > getRequestorEmail(Set < Id > setConCEEAI, Set < Id > setConODCEEAI,Map < String, SendEmail__c > mapProcessEmailReminder) {
        //List < SendEmail__c > lstNewReminders = new List < SendEmail__c > ();
        Map < String, SendEmail__c > mapEmailSendEmail = mapProcessEmailReminder;
        Set < String > setEmail = new Set < String > ();
        String aggObjSOQL = System.Label.JiifleNowConfirmationEmailAttendeeQuery;
        List<AggregateResult> aggObjs = Database.Query(aggObjSOQL);
        for (AggregateResult aggObj: aggObjs) {
            String strCEE = String.valueOf(aggObj.get('Customer_Engagements_Events__c'));
            String strRequestorName = String.valueOf(aggObj.get('Requestor__c'));
            String strRequestorEmail = String.valueOf(aggObj.get('Requestor_Email__c'));
            Integer intCount = Integer.valueOf(aggObj.get('expr0'));
            setEmail.add(strRequestorEmail);
            // Validate if Map is Null if Null then create new Send Email
            // Else if Map contain Requestor email then Update the Send Email record
            if (!mapEmailSendEmail.isEmpty()) {
                if (mapEmailSendEmail.containsKey(strRequestorEmail)) {
                    SendEmail__c sEObj = mapEmailSendEmail.get(strRequestorEmail);
                    sEObj.toBeTriggered__c = True;
                    if (setConCEEAI.contains(strCEE)) {
                        sEObj.Confirmation_Count__c = sEObj.Confirmation_Count__c + intCount;
                    } else {
                        sEObj.Confirmation_Count__c = sEObj.Confirmation_Count__c + intCount;
                        sEObj.Confirmation_Over_Due_Count__c = sEObj.Confirmation_Over_Due_Count__c + intCount;
                    }
                    mapEmailSendEmail.put(sEObj.EmailID__c, sEObj);
                } else {
                    SendEmail__c sEObj = new SendEmail__c();
                    sEObj.toBeTriggered__c = True;
                    if (setConCEEAI.contains(strCEE)) {
                        sEObj.Confirmation_Count__c = intCount;
                        sEObj.Confirmation_Over_Due_Count__c = 0;
                    } else {
                        sEObj.Confirmation_Count__c = intCount;
                        sEObj.Confirmation_Over_Due_Count__c = intCount;
                    }
                    sEObj.Name__c = strRequestorName;
                    sEObj.EmailID__c = strRequestorEmail;
                    mapEmailSendEmail.put(sEObj.EmailID__c, sEObj);
                }
            } else {
                SendEmail__c sEObj = new SendEmail__c();
                sEObj.toBeTriggered__c = True;
                if (setConCEEAI.contains(strCEE)) {
                    sEObj.Confirmation_Count__c = intCount;
                    sEObj.Confirmation_Over_Due_Count__c = 0;
                } else {
                    sEObj.Confirmation_Count__c = intCount;
                    sEObj.Confirmation_Over_Due_Count__c = intCount;
                }
                sEObj.Name__c = strRequestorName;
                sEObj.EmailID__c = strRequestorEmail;
                mapEmailSendEmail.put(sEObj.EmailID__c, sEObj);
            }
        }
        if (!mapEmailSendEmail.isEmpty()) {
            mapEmailSendEmail.putAll(getSendRequestorEmailManager(mapEmailSendEmail, setEmail));
        }
        return mapEmailSendEmail;
    }

    //@Method: Fill the Manager detail when overdue count is greater than 0
    public Map < String, SendEmail__c > getSendRequestorEmailManager(Map < String, SendEmail__c > mapNewEmails, Set < String > setEmailId) {
        for (User usrObj: [Select Id, Email, Reporting_Manager_Name__c, Manager_s_Email_Address__c FROM User WHERE Email IN: setEmailId]) {
            if (mapNewEmails.containsKey(usrObj.Email)) {
                SendEmail__c sendEObj = mapNewEmails.get(usrObj.Email);
                sendEObj.User__c = usrObj.Id;
                if (sendEObj.Confirmation_Over_Due_Count__c > 0) {
                    sendEObj.Requestor_Manager_Email__c = usrObj.Manager_s_Email_Address__c;
                    sendEObj.Requestor_Manager_Name__c = usrObj.Reporting_Manager_Name__c;
                }
                mapNewEmails.put(usrObj.Email, sendEObj);
            }
        }

        return mapNewEmails;
    }
}