/**
* @release - Q1FY15
* @author - Mahesh Chilaka  
* @date - 05-May-2014
* @description  - This class is utilized for building complete business logic of notifing assigned Channel Partners and PSR Users. 
* @param - no param
* @return - void
* Change History: WR-01169 - Added last 120 days check for Leads & Prospects.
* DE10499 05/05/2016 - Updated the Lead duration from 120 to 180 Days and removed Lead Qualification criteria.
* 06/13/2016 - US11655 - Updated the Lead Count to ensure the PA count includes the Leads for whom he/she is assigned as PSR.
*    - Added the new setPAUsers to get the list of PA users to calculate the total count.
*    - Fixed VillageChief issues
*/ 
public class EmailNotification_Utility {
    
    // SCAVA Helper Method to validate Create Access at field level
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }
    
    //Local variables
    public static string strPartnerAssigned = Org_Constant_CS__c.getValues('P360 Partner Assigned').Production_Value__c;
    public static string strAssignedtoPSR = Org_Constant_CS__c.getValues('P360 Assigned to PSR').Production_Value__c;
    public static map<id, integer> psrLeadsCount = new map<id, integer>();
    public static map<id, integer> psrTargetProspectsCount = new map<id, integer>();
    public static map<id, integer> paLeadsCount = new map<id, integer>();
    public static map<id, integer> paTargetProspectsCount = new map<id, integer>();
    public static map<id, integer> psrLeadsAgingCount = new map<id, integer>();
    public static map<id, integer> paLeadsAgingCount = new map<id, integer>();
    public static set<Id> isPA_AssignedTodayLeads = new set<Id>();
    public static set<Id> isPSR_AssignedTodayLeads = new set<Id>();
    public static set<Id> isPA_AssignedTodayTPs = new set<Id>();
    public static set<Id> isPSR_AssignedTodayTPs = new set<Id>();
    public static Date dtToday ;
    public static Date lastRunDate = P360_Apex_Batch_Job__c.getInstance('P360 dtToday').DT_DailyEmailNotification__c;
    // private static variable referencing the class
    private static EmailNotification_Utility instance = null;
    
    
    // Parameterized constructor
    private EmailNotification_Utility(Set<Id> setPartnerAccounts, Set<Id> setPSRUsers, Set<Id> setPAUsers, map<ID, User> mapUsers, map<ID, User> mapPartnerUser, Date dtEmailNotification){
        getAssignedLeadsandTPS(setPartnerAccounts, setPSRUsers, setPAUsers, mapUsers, mapPartnerUser, dtEmailNotification);
    }
    

    public static EmailNotification_Utility getInstance(Set<Id> setPartnerAccounts, Set<Id> setPSRUsers, Set<Id> setPAUsers, map<ID, User> mapUsers, map<ID, User> mapPartnerUser, Date dtEmailNotification){
            // initialize instance if it doesn't already exist
            if(instance == null) instance = new EmailNotification_Utility(setPartnerAccounts, setPSRUsers, setPAUsers, mapUsers, mapPartnerUser, dtEmailNotification);
            return instance;
     }
    
    
    /**
    * @author Mahesh Chilaka    
    * @date 05-May-2014
    * @description Fetch all Leads, TPs associated with Executive, Non-Executive users.        
    * @param 
            @setPartnerAccounts     -  List of Executive UserIds.  
            @setPSRUsers            -  List of Non-Executive UserIds..
            @mapUsers               -  List of all user details.
            @dtEmailNotification    -  Current date in the current user's time zone.
             
    * @return - void.
    */
    public static void getAssignedLeadsandTPS(Set<Id> setPartnerAccounts, Set<Id> setPSRUsers, Set<Id> setPAUsers, map< ID, User > mapUsers, map<ID, User> mapPartnerUser, Date dtEmailNotification) {        
       
        //Local variables.
        List<Lead> lstLeads = new List<Lead>();
        List<Lead> lstLeadsAging = new List<Lead>();
        List<Assigned_Partner__c> lstTPs = new List<Assigned_Partner__c>();
        
        integer leadAging = integer.valueOf(Org_Constant_CS__c.getValues('P360 Lead Aging').Production_Value__c);     
        //Commented the code to fix the VillageChief exception - Unused local variable  
        //integer Lead120Days = integer.valueOf(Org_Constant_CS__c.getValues('P360 Lead120Days').Production_Value__c); 

        //DE10499 - Updated the Custom Setting value to 180 days.
        //Commented the code to fix the VillageChief exception - Unused local variable
        //Datetime dtLead120DaysAgo = dtEmailNotification.addDays(-Lead120Days);
        //Datetime dtLeadAssigned4DaysAgo = dtEmailNotification.addDays( -leadAging);        
        dtToday = dtEmailNotification;
        
        //clear the MAps
        paLeadsCount.clear();
        psrLeadsCount.clear();
        paTargetProspectsCount.clear();
        psrTargetProspectsCount.clear();
        paLeadsAgingCount.clear();
        psrLeadsAgingCount.clear();
        isPSR_AssignedTodayLeads.clear();
        isPA_AssignedTodayLeads.clear();
        isPA_AssignedTodayTPs.clear();
        isPSR_AssignedTodayTPs.clear();
        //Commented the code to fix the VillageChief exception - Unused local variable
        //Date paDate = null;
        //clear the Maps
        //WR-01169 - Added Lead Qualification Date in last 120 days check to the SOQL filter.
        
        //** Calculate the leadAging days based on the Last Run date form Custom Setting against the YESTERDAY.
        // If the job has NOT ran yesterday(i.e., it skipped due to whatever the reason), get the aging value betweek the 2 dates and add that to the original aging value from Custom Setting (Org_Constant_CS__c.getValues('P360 Lead Aging'))
        if(lastRunDate != dtToday) {
            Date dueDate = date.newInstance(lastRunDate.year(), lastRunDate.month(), lastRunDate.day());
            Date startDate = date.newInstance(dtToday.year(), dtToday.month(), dtToday.day());
            Integer dateDiff = dueDate.daysBetween(startDate);
            leadAging = leadAging + dateDiff;
            lastRunDate = dtToday - leadAging;
        }
             
         //** If the jab has ran YESTERDAY and Custom Setting (Org_Constant_CS__c.getValues('P360 Lead Aging')) >1, construct the reference date to differentiate between New and Overdue Leads with validateAssignedDateCS() method.
         if(lastRunDate == dtToday && leadAging > 1){
            lastRunDate = dtToday - leadAging;
         }

        
        //** Get all the leads where Lead Qualified Date in last 120 days with respective Partner Lead Status for PA/PSR Assignment.
        //@@ Updated Lead Qualified date to Partner_Assigned_Date__c/PSR_Assigned_Date__c respectively for PA/PSR Assignment
         //DE10499 - Updated the whereClause duration from 120 to 180 days and removed Lead Qualified Date from the filter.
        lstLeads = [select id, Lead_Qualified_Date__c, Partner_Lead_Status__c, Channel_Partner__c, PSR_1__c, PSR_2__c, PSR_3__c, PSR_Assigned_Date__c, Partner_Assigned_Date__c,CreatedDate  from lead where(Partner_Lead_Status__c = : strPartnerAssigned and Channel_Partner__c IN: setPartnerAccounts and Partner_Assigned_Date__c = LAST_N_DAYS: 180) or (Partner_Lead_Status__c = : strAssignedtoPSR and(PSR_1__c IN: setPSRUsers or PSR_2__c IN: setPSRUsers or PSR_3__c IN: setPSRUsers or PSR_1__c IN: setPAUsers) and PSR_Assigned_Date__c = LAST_N_DAYS: 180)];
        
        //Fetch all Leads filter by Executive and Non-Executive user list.
        for(Lead vLead:lstLeads) {
         //Collect last 120 days leads which are in assigned status and the assigned date older than the day before Lead Aging date.
            Integer totalleadAgingDays = leadAging + 1;
            Date leadAgeDate = System.today() - totalleadAgingDays;
            //(vLead.PSR_Assigned_Date__c <  ((System.today() - 1) - leadAging) && vLead.Partner_Lead_Status__c.equalsIgnoreCase(strAssignedtoPSR))

            if((vLead.PSR_Assigned_Date__c == null && vLead.Partner_Assigned_Date__c < leadAgeDate && vLead.Partner_Lead_Status__c.equalsIgnoreCase(strPartnerAssigned))  ||
                    (vLead.PSR_Assigned_Date__c <  leadAgeDate && vLead.Partner_Lead_Status__c.equalsIgnoreCase(strAssignedtoPSR))) {
                        lstLeadsAging.add(vLead);
            }                                              
        }

        //Fetch all Targer Prospects filter by  Executive and Non-Executive user list.
        //WR-01169 - Added TP Created date in last 120 days check.
         //DE10499 - Updated the whereClause duration from 120 to 180 days and removed Lead Qualified Date from the filter.
        lstTPs = [select id, Partner_Status__c, Assigned_Partner__c, Assigned_Partner_Sales_Rep__c, Assigned_Partner_Sales_Rep_2__c, Assigned_Partner_Sales_Rep_3__c, Partner_Assigned_Date__c, PSR_Assigned_Date_Time__c from Assigned_Partner__c where((Partner_Status__c = : strPartnerAssigned and Assigned_Partner__c IN: setPartnerAccounts and createdDate = LAST_N_DAYS: 180) or(Partner_Status__c = : strAssignedtoPSR and(Assigned_Partner_Sales_Rep__c IN: setPSRUsers or Assigned_Partner_Sales_Rep_2__c IN: setPSRUsers or Assigned_Partner_Sales_Rep_3__c IN: setPSRUsers) and createdDate = LAST_N_DAYS: 180)) and Assignment_Activated__c = : True];  
        
        //** Method to calculate new Leads assigned count for PA / PSRs.
        segregatePAPSRLeads(lstLeads);
        
        //** Method to calculate the assigned TPS for PA / PSRs.
        segregatePAPSRTPs(lstTPs);
        
        //** Pass through all the Lead where the Lead Assigned Date is earler than the last Job ran date.
        calculateAgaing(lstLeadsAging);
        
        //** Method to insert the record in the P360_PA_PSR_Daily_Email_Notification object to send the email to Partners.
        insertPA_PSR_RecordCount(setPartnerAccounts, setPSRUsers, setPAUsers, mapUsers, mapPartnerUser);
    }
    
     /**
    * @author Mahesh Chilaka    
    * @date 05-May-2014
    * @description Create DailyEmailNotification using PA/PSR Assigned Leads and TPs count data.        
    * @param 
            @setPartnerAccounts     -  List of Executive UserIds.  
            @setPSRUsers            -  List of Non-Executive UserIds..
            @mapUsers               -  List of all user details.
            
             
    * @return - void.
    */
    public static void insertPA_PSR_RecordCount(Set<Id> setPartnerAccounts, Set<Id> setPSRUsers, Set<Id> setPAUsers, map<ID, User> mapUsers, map<ID, User> mapPartnerUser) {   
        // Local variables
        List<P360_PA_PSR_Daily_Email_Notification__c> lstEN = new List<P360_PA_PSR_Daily_Email_Notification__c>();
        List<Tx_Log__c> errObj = new List<Tx_Log__c>();
        Integer i = 0; 
        //Iterate PSR Userlist
        for (ID usrid: setPSRUsers) {
            //** Removed the check for YESTERDAY assignment and record would be inserted if a Channel Partner (PS/PSR) has an active assignment.
            //if (isPSR_AssignedTodayLeads.contains(usrid) || isPSR_AssignedTodayTPs.contains(usrid)) {        
            if(psrLeadsCount.containsKey(usrid) || psrLeadsAgingCount.containsKey(usrid) || paTargetProspectsCount.containsKey(usrid)) {
                P360_PA_PSR_Daily_Email_Notification__c newEN = new P360_PA_PSR_Daily_Email_Notification__c();
                //SCAVA FIX
                if(flsGet(P360_PA_PSR_Daily_Email_Notification__c.Name__c))
                {
                newEN.Name__c = mapPartnerUser.get(usrid).Firstname + ' ' + mapPartnerUser.get(usrid).Lastname;
                }
                if(flsGet(P360_PA_PSR_Daily_Email_Notification__c.emailID__c))
                {
                newEN.emailID__c = mapPartnerUser.get(usrid).email;            
                }
                if(flsGet(P360_PA_PSR_Daily_Email_Notification__c.NewLeadCount__c))
                {
                newEN.NewLeadCount__c = psrLeadsCount.get(usrid);
                }
                if(flsGet(P360_PA_PSR_Daily_Email_Notification__c.NewTargetProspectCount__c))
                {
                newEN.NewTargetProspectCount__c = psrTargetProspectsCount.get(usrid);
                }
                if(flsGet(P360_PA_PSR_Daily_Email_Notification__c.Recipient__c))
                {
                newEN.Recipient__c = usrid;
                }
                if(flsGet(P360_PA_PSR_Daily_Email_Notification__c.Recipient_Language__c))
                {
                newEN.Recipient_Language__c = mapPartnerUser.get(usrid).LanguageLocaleKey;
                }
                if(flsGet(P360_PA_PSR_Daily_Email_Notification__c.Overdue_Leads_Count__c))
                {
                newEN.Overdue_Leads_Count__c = psrLeadsAgingCount.get(usrid);         
                }
                if(flsGet(P360_PA_PSR_Daily_Email_Notification__c.tobeTriggered__c))
                {
                newEN.tobeTriggered__c = true;
                }
                lstEN.add(newEN);
            } 
        } 

        
        //Iterate PA Userlist
        for (user usr: mapUsers.values()) {    
            //** Removed the check for YESTERDAY assignment and record would be inserted if a Channel Partner (PS/PSR) has an active assignment.
        if (paLeadsAgingCount.containsKey(usr.UserRole.portalaccountid) || paLeadsCount.containsKey(usr.UserRole.portalaccountid) || paTargetProspectsCount.containsKey(usr.UserRole.portalaccountid)) {
                P360_PA_PSR_Daily_Email_Notification__c newEN = new P360_PA_PSR_Daily_Email_Notification__c();
                newEN.Name__c = usr.Firstname + ' ' + usr.Lastname;
                newEN.emailID__c = usr.email;            
                //US11655 - Calculating the total PA count including the Leads which he is PSR.
                // totalPACount = Leads in "Partner Assigned" assigned to Channel Partner + Leads in "Assigned to PSR" where he is PSR.
                Integer totalPACount = 0;
                if(paLeadsCount.get(usr.UserRole.portalaccountid) != null && psrLeadsCount.get(usr.id) != null){
                    totalPACount = Integer.valueOf(paLeadsCount.get(usr.UserRole.portalaccountid)) + Integer.valueOf(psrLeadsCount.get(usr.id));
                } else if(paLeadsCount.get(usr.UserRole.portalaccountid) == null && psrLeadsCount.get(usr.id) != null){
                    totalPACount = Integer.valueOf(psrLeadsCount.get(usr.id));
                } else if(paLeadsCount.get(usr.UserRole.portalaccountid) != null && psrLeadsCount.get(usr.id) == null){
                    totalPACount = Integer.valueOf(paLeadsCount.get(usr.UserRole.portalaccountid));
                }        
                newEN.NewLeadCount__c = totalPACount;
                newEN.NewTargetProspectCount__c = paTargetProspectsCount.get(usr.UserRole.portalaccountid);
                newEN.Recipient__c = usr.id;
                newEN.Recipient_Language__c = usr.LanguageLocaleKey;
                Integer psrOverdueCount = 0;
                Integer paOverdueCount = 0;
                 if(paLeadsAgingCount.get(usr.UserRole.portalaccountid) != null){
                    paOverdueCount = paLeadsAgingCount.get(usr.UserRole.portalaccountid);
                }
                if(psrLeadsAgingCount.get(usr.UserRole.portalaccountid) != null){
                    psrOverdueCount = psrLeadsAgingCount.get(usr.UserRole.portalaccountid);
                }
                newEN.Overdue_Leads_Count__c = paOverdueCount + psrOverdueCount;
                newEN.tobeTriggered__c = true;
                lstEN.add(newEN);
            }
        }

        //Insert records  
        List < Database.SaveResult > insertDailySummary = Database.Insert(lstEN, false);
        // Iterate saveresult and check for any failure. if any failure found, Capture it in Tx_Log__c Custom Object.        
        for (Database.SaveResult sr: insertDailySummary) {
            if (!sr.isSuccess()) {
                Database.Error[] errs = sr.getErrors();
                for (Database.Error err: errs) {
                    Tx_Log__c newErrorRecord = new Tx_Log__c();
                    if(flsGet(Tx_Log__c.name))
                    {
                    newErrorRecord.name = 'User ' + lstEN[i].Recipient__c;
                    }
                    if(flsGet(Tx_Log__c.originated__c))
                    {
                    newErrorRecord.originated__c = 'P360_DailySummary';
                    }
                    if(flsGet(Tx_Log__c.type__c))
                    {
                    newErrorRecord.type__c = 'P360_DailySummary';
                    }
                    if(flsGet(Tx_Log__c.exception__c))
                    {
                    newErrorRecord.exception__c = true;
                    }
                    if(flsGet(Tx_Log__c.message__c))
                    {
                    newErrorRecord.message__c = err.getMessage() + err.getStatusCode();
                    }
                    errObj.add(newErrorRecord);
                }
            }
            i++;
        }
        
        // Insert error logs.
        List < Database.SaveResult > intDailySummaryError = Database.Insert(errObj, false);
        
    }
    
    
     /**
    * @author Mahesh Chilaka    
    * @date 05-May-2014
    * @description Calculate PA/PSR Assigned Leads and TP record count.        
    * @param 
            @lstLeadsTPs         -  WrapperClassList of Leads/TPs 
            @paCount             -  List of Executive UserId with Records assigned count.
            @psrCount            -  List of Non-Executive UserId with Records assigned count.
            @isPA_AssignedToday  -  List of Leads/TPs Executive UserId assigned same day.
            @isPSR_AssignedToday -  List of Leads/TPs Non-Executive UserId assigned same day.
             
    * @return - void.
    */
    public static void segregatePAPSRLeads(List<Lead> lstLeads) {        
        //Iterate leads
        for (lead l: lstLeads) {           
            //check for partner and psr1,2,3 are not null.          
            //US11655 - Increment the paLeadsCount map for every leads having PA assigne as PSR_1.
            if (l.Partner_Lead_Status__c.equalsIgnoreCase(strPartnerAssigned)) {
            // If Lead Aging reference date/Last Run Date is NOT equal to YESTERDAY, calculate all Leads Assigned between the Last Ran Date and YESTERDAY and add the Channel Partner & its count to MAP.
                if(lastRunDate != dtToday) {
                     if(validateAssignedDateCS(l.Partner_Assigned_Date__c, lastRunDate)) { 
                         if (l.Channel_Partner__c != Null) {
                                if (!paLeadsCount.containsKey(l.Channel_Partner__c)) {
                                    paLeadsCount.put(l.Channel_Partner__c, 1);
                                } else {
                                    paLeadsCount.put(l.Channel_Partner__c, paLeadsCount.get(l.Channel_Partner__c) + 1);
                            }    
                        }
                    }
                } else {
                //** If Partner Assigned Date = YESTERDAY, add the Channel Partner & its count to the Map.
                        if(validateAssignedDate(l.Partner_Assigned_Date__c)) { 
                            if (l.Channel_Partner__c != Null) {
                                if (!paLeadsCount.containsKey(l.Channel_Partner__c)) {
                                    paLeadsCount.put(l.Channel_Partner__c, 1);
                                } else {
                                    paLeadsCount.put(l.Channel_Partner__c, paLeadsCount.get(l.Channel_Partner__c) + 1);
                            }    
                        }
                    }
                }
            } else {
            // If Lead Aging reference date/Last Run Date is NOT equal to YESTERDAY, calculate all Leads Assigned to PSR between the Last Ran Date and YESTERDAY and add the PSR & its count to MAP.
                if(lastRunDate != dtToday) {
                    if (l.PSR_1__c != Null) {   
                        if(validateAssignedDateCS(l.PSR_Assigned_Date__c,lastRunDate)) {
                            if (!psrLeadsCount.containsKey(l.PSR_1__c) || paLeadsCount.containsKey(l.PSR_1__c)) {
                                psrLeadsCount.put(l.PSR_1__c, 1);
                            } else {
                                psrLeadsCount.put(l.PSR_1__c, psrLeadsCount.get(l.PSR_1__c) + 1);
                            }
                        }
                    }
                    
                     if (l.PSR_2__c != Null) {
                        if (validateAssignedDateCS(l.PSR_Assigned_Date__c,lastRunDate)) {
                            if (!psrLeadsCount.containsKey(l.PSR_2__c)) {
                                psrLeadsCount.put(l.PSR_2__c, 1);
                            } else {
                                psrLeadsCount.put(l.PSR_2__c, psrLeadsCount.get(l.PSR_2__c) + 1);
                            }
                        }
                    }
                    
                    if (l.PSR_3__c != Null) {
                        if (validateAssignedDateCS(l.PSR_Assigned_Date__c,lastRunDate)) {
                            if (!psrLeadsCount.containsKey(l.PSR_3__c)) {
                                psrLeadsCount.put(l.PSR_3__c, 1);
                            } else {
                                psrLeadsCount.put(l.PSR_3__c, psrLeadsCount.get(l.PSR_3__c) + 1);
                            }
                        }
                    }
                 } else {
                 //** If Partner Assigned Date = YESTERDAY, add the PA & its count to the Map.
                    if (l.PSR_1__c != Null) {                   
                        if(validateAssignedDate(l.PSR_Assigned_Date__c)) {
                            if (!psrLeadsCount.containsKey(l.PSR_1__c) || paLeadsCount.containsKey(l.PSR_1__c)) {
                                psrLeadsCount.put(l.PSR_1__c, 1);
                            } else {
                                psrLeadsCount.put(l.PSR_1__c, psrLeadsCount.get(l.PSR_1__c) + 1);
                            }
                        }
                    }
                    
                    if (l.PSR_2__c != Null) {
                        if (validateAssignedDate(l.PSR_Assigned_Date__c)) {
                            if (!psrLeadsCount.containsKey(l.PSR_2__c)) {
                                psrLeadsCount.put(l.PSR_2__c, 1);
                            } else {
                                psrLeadsCount.put(l.PSR_2__c, psrLeadsCount.get(l.PSR_2__c) + 1);
                            }
                        }
                    }
                    
                    if (l.PSR_3__c != Null) {
                        if (validateAssignedDate(l.PSR_Assigned_Date__c)) {
                            if (!psrLeadsCount.containsKey(l.PSR_3__c)) {
                                psrLeadsCount.put(l.PSR_3__c, 1);
                            } else {
                                psrLeadsCount.put(l.PSR_3__c, psrLeadsCount.get(l.PSR_3__c) + 1);
                            }
                        }
                    }
                }   
            }
        }

    }
    
    public static void segregatePAPSRTPs(List < Assigned_Partner__c > lstTagPart) { 
        for (Assigned_Partner__c tp: lstTagPart) {
            //check for partner and psr1,2,3 are not null.
            //Iterate Target Prospects and if Partner Status = Partner Assigned, add the Channel Partner and its count to the MAP.
            if (tp.Partner_Status__c.equalsIgnoreCase(strPartnerAssigned)) {
                if (tp.Assigned_Partner__c != Null) {
                    if (!paTargetProspectsCount.containsKey(tp.Assigned_Partner__c)) {
                        paTargetProspectsCount.put(tp.Assigned_Partner__c, 1);
                    } else {
                        paTargetProspectsCount.put(tp.Assigned_Partner__c, paTargetProspectsCount.get(tp.Assigned_Partner__c) + 1);
                    }                   
                    //** if (validateAssignedDate(tp.Partner_Assigned_Date__c))
                    //    isPA_AssignedTodayTPs.add(tp.Assigned_Partner__c);
                }
            } else {
            //Iterate Target Prospects and if Partner Status = PSR Assigned, add the Channel Partner and its count to the MAP.
                if (tp.Assigned_Partner_Sales_Rep__c != Null) {
                    if (!psrTargetProspectsCount.containsKey(tp.Assigned_Partner_Sales_Rep__c)) {
                        psrTargetProspectsCount.put(tp.Assigned_Partner_Sales_Rep__c, 1);
                    } else {
                        psrTargetProspectsCount.put(tp.Assigned_Partner_Sales_Rep__c, psrTargetProspectsCount.get(tp.Assigned_Partner_Sales_Rep__c) + 1);
                    }
                    //** if (validateAssignedDate(tp.PSR_Assigned_Date_Time__c))
                    //    isPSR_AssignedTodayTPs.add(tp.Assigned_Partner_Sales_Rep__c);
                }

                if (tp.Assigned_Partner_Sales_Rep_2__c != Null) {
                    if (!psrTargetProspectsCount.containsKey(tp.Assigned_Partner_Sales_Rep_2__c)) {
                        psrTargetProspectsCount.put(tp.Assigned_Partner_Sales_Rep_2__c, 1);
                    } else {
                        psrTargetProspectsCount.put(tp.Assigned_Partner_Sales_Rep_2__c, psrTargetProspectsCount.get(tp.Assigned_Partner_Sales_Rep_2__c) + 1);
                    }
                    //** if (validateAssignedDate(tp.PSR_Assigned_Date_Time__c))
                    //    isPSR_AssignedTodayTPs.add(tp.Assigned_Partner_Sales_Rep_2__c);
                }

                if (tp.Assigned_Partner_Sales_Rep_3__c != Null) {
                    if (!psrTargetProspectsCount.containsKey(tp.Assigned_Partner_Sales_Rep_3__c)) {
                        psrTargetProspectsCount.put(tp.Assigned_Partner_Sales_Rep_3__c, 1);
                    } else {
                        psrTargetProspectsCount.put(tp.Assigned_Partner_Sales_Rep_3__c, psrTargetProspectsCount.get(tp.Assigned_Partner_Sales_Rep_3__c) + 1);
                    }
                    //** if (validateAssignedDate(tp.PSR_Assigned_Date_Time__c))
                    //    isPSR_AssignedTodayTPs.add(tp.Assigned_Partner_Sales_Rep_3__c);
                }
            }
        }
    }   
    public static void calculateAgaing(List<Lead> lstNotificationLeads){
        for (Lead ld: lstNotificationLeads) {     
        //Iterate Lead and if Partner Status = Partner Assigned, add the Channel Partner and its count to the MAP.
            if (ld.Partner_Lead_Status__c.equalsIgnoreCase(strPartnerAssigned) && ld.PSR_Assigned_Date__c == null  )       
            {
                if(!paLeadsAgingCount.containsKey(ld.Channel_Partner__c)) {
                     paLeadsAgingCount.put(ld.Channel_Partner__c,1);       
                }  
                else {
                      paLeadsAgingCount.put(ld.Channel_Partner__c, paLeadsAgingCount.get(ld.Channel_Partner__c)+1);  
                 }    
            }
            //Iterate Lead and if Partner Status = PSR Assigned, add the Channel Partner and its count to the MAP.
            if (ld.Partner_Lead_Status__c.equalsIgnoreCase(strAssignedtoPSR) ) {
                
                if(!psrLeadsAgingCount.containsKey(ld.Channel_Partner__c))
                {   
                    psrLeadsAgingCount.put(ld.Channel_Partner__c,1);
                }
                else
                {
                    psrLeadsAgingCount.put(ld.Channel_Partner__c,psrLeadsAgingCount.get(ld.Channel_Partner__c)+1);
                }                    
                if(ld.PSR_1__c != Null)
                {           
                    if(!psrLeadsAgingCount.containsKey(ld.PSR_1__c))
                    {   
                        psrLeadsAgingCount.put(ld.PSR_1__c,1);
                    }
                    else
                    {
                        psrLeadsAgingCount.put(ld.PSR_1__c,psrLeadsAgingCount.get(ld.PSR_1__c)+1);
                    }
                }            
                if(ld.PSR_2__c != Null)
                {
                    if(!psrLeadsAgingCount.containsKey(ld.PSR_2__c))
                    {   
                        psrLeadsAgingCount.put(ld.PSR_2__c,1);
                    }
                    else
                    {
                        psrLeadsAgingCount.put(ld.PSR_2__c,psrLeadsAgingCount.get(ld.PSR_2__c)+1);
                    }
                }            
                if(ld.PSR_3__c != Null)
                {
                    if(!psrLeadsAgingCount.containsKey(ld.PSR_3__c))
                    {   
                        psrLeadsAgingCount.put(ld.PSR_3__c,1);
                    }
                    else
                    {
                        psrLeadsAgingCount.put(ld.PSR_3__c,psrLeadsAgingCount.get(ld.PSR_3__c)+1);
                    }                                     
                } 
            }
        }  
    }
    
     /**
    * @author Mahesh Chilaka    
    * @date 05-May-2014
    * @description Check whether string has null or empty value.        
    * @param string
    * @return boolean.
    */
    public static boolean checkStringNotNull(string strCheckValue)   {        
        if(strCheckValue != null) {     
          if(strCheckValue.trim().length()==0)
                return false;
        }
        else
            return false;
         
        return true; 
    }
    
     /**
    * @author Mahesh Chilaka    
    * @date 05-May-2014
    * @description Check whether the assigned Lead/TP date is the same day        
    * @param Datetime value
    * @return boolean.
    */
    //** Method to verify if the Assigned Date is YESTERDAY or Not.
    public static boolean validateAssignedDate(Datetime Tpdt) {
        if (Tpdt == null) {
            return false;
        }
        date TPsDate = dtToday;
        datetime dt = Tpdt;
        date dueDate = date.newInstance(dt.year(), dt.month(), dt.day());
        return TPsDate.isSameDay(dueDate);
    }
    
    //** Method to calculate if the Assigned Date is grater than/equal to Job last run reference date and less than/= YESTERDAY.
    public static boolean validateAssignedDateCS(Datetime paDateTime, Date lastRunDT) {
        if (paDateTime == null || lastRunDT == null) {
            return false;
        }       
        Date paDate = Date.newInstance(paDateTime.year(), paDateTime.month(), paDateTime.day());
        //Date lastRunDate = Date.newInstance(lastRunDT.year(), lastRunDT.month(), lastRunDT.day());
        //Commented the code to fix the VillageChief exception - Unused local variable
        //date TPsDate = dtToday;
        if(paDate >= lastRunDT && paDate <= dtToday){
            return true;
        }
        return false;
    }
}