/**
* @release - Q1FY15
* @author - Mahesh Chilaka  
* @date - 05-May-2014
* @description  - This Batch Apex class is for notify to Channel Partners and PSR Users of assigned leads and TPs . 
* @param - no param
* @return - void
* Change History:
* WR-01169 - Sep2015:
    - Removed Lead.Partner_Assigned_Date__c = YESTERDAY & added Lead Qualification in last 120 days to Lead Query.
    - Removed TP.Partner_Assigned_Date__c = YESTERDAY & added TP createdDate in last 120 days to Lead Query.
* DE10499 05/05/2016 - Updated the Lead duration from 120 to 180 Days and removed Lead Qualification criteria.
*  06/13/2016 - US11655 - Updated the Lead Count to ensure the PA count includes the Leads for whom he/she is assigned as PSR.
*    - Fixed VillageChief issues
*/ 
global class EmailNotification_Batch implements Database.Batchable<sObject>,Database.Stateful {        
    //global variable   
    global Date dtEmailNotification;
    public string exceptionString = '',executiveUserRole = '';    
    public set<Id> setPALeadUserIds = new set<Id>();
    public set<Id> setPSRLeadUserIds = new set<Id>();
    public set<Id> setPATargetUserIds = new set<Id>();
    public set<Id> setPSRTargetUserIds = new set<Id>();
    public boolean successBoolean = true;    
    global EmailNotification_Batch() {        
        try {
            //Local variables
            string partnerAssigned = Org_Constant_CS__c.getValues('P360 Partner Assigned').Production_Value__c;
            string assignedtoPSR = Org_Constant_CS__c.getValues('P360 Assigned to PSR').Production_Value__c;
            executiveUserRole = Org_Constant_CS__c.getValues('P360 Executive User').Production_Value__c;
            
            //Assign current date in the current user's time zone.
            dtEmailNotification = date.today()-1;
            //Commented the code to fix the VillageChief exception - Unused local variable
            //Date dtENPlusOneDay = dtEmailNotification.addDays(1);
            
            //Fetch all leads of PA,PSR users are assigned same day.
            //WR-01169 - Update query to remove YESTERDAY check for Partner Assigned Date and added last 120 days check for Lead Qualification date.
            //@@ Updated Lead Qualified date to Partner_Assigned_Date__c/PSR_Assigned_Date__c respectively for PA/PSR Assignment
            //DE10499 - Updated the whereClause duration from 120 to 180 days and removed Lead Qualified Date from the filter.
            List<Lead> lstLead = Database.query('select id,Partner_Lead_Status__c,Channel_Partner__c,PSR_1__c,PSR_2__c,PSR_3__c,PSR_Assigned_Date__c,Partner_Assigned_Date__c from lead where (Partner_Assigned_Date__c = LAST_N_DAYS: 180 and Partner_Lead_Status__c =\'' + partnerAssigned + '\') or (PSR_Assigned_Date__c = LAST_N_DAYS: 180 and  Partner_Lead_Status__c =\'' + assignedtoPSR + '\')');
            for( Lead l:lstLead) {                
                //Check the Lead status is partner assigned.            
                if (l.Partner_Lead_Status__c.equalsIgnoreCase(partnerAssigned)) {                    
                    //Collect all Channel Partner Ids into set variable.        
                    if(l.Channel_Partner__c != Null) {
                        setPALeadUserIds.add(l.Channel_Partner__c);
                    }                                
                }else{ 
                    //Collect all PSR user Ids into set variable.                    
                    if(l.PSR_1__c != Null) {
                        setPSRLeadUserIds.add(l.PSR_1__c);
                    }
                    if(l.PSR_2__c != Null) {
                        setPSRLeadUserIds.add(l.PSR_2__c);
                    }
                    if(l.PSR_3__c != Null) {
                        setPSRLeadUserIds.add(l.PSR_3__c);
                    }
                }           
            } 
            
           //Fetch all targetprospects of PA,PSR users are assigned same day.
           //WR-01169 - Removed Partner Assigned Date = YESTERDAY check and added Created Date in last 120 days check.
           //DE10499 - Updated the whereClause duration from 120 to 180 days
           List<Assigned_Partner__c> lstTagPart = Database.query('select id,Partner_Status__c,Assigned_Partner__c,Assigned_Partner_Sales_Rep__c,Assigned_Partner_Sales_Rep_2__c,Assigned_Partner_Sales_Rep_3__c,Partner_Assigned_Date__c,PSR_Assigned_Date_Time__c  from Assigned_Partner__c where ((createdDate = LAST_N_DAYS: 180 and Partner_Status__c=\'' + partnerAssigned + '\') or (createdDate = LAST_N_DAYS: 180 and Partner_Status__c=\'' + assignedtoPSR + '\')) and Assignment_Activated__c = True');
           for(Assigned_Partner__c tp:lstTagPart) {                                                        
                //Check the Lead status is partner assigned.
                if (tp.Partner_Status__c.equalsIgnoreCase(partnerAssigned)) {                    
                    //Collect all Channel Partner Ids into set variable.        
                    if(tp.Assigned_Partner__c != Null) {
                        setPATargetUserIds.add(tp.Assigned_Partner__c);
                    }                                
                }else { 
                    //Collect all PSR user Ids into set variable.                    
                    if(tp.Assigned_Partner_Sales_Rep__c != Null) {
                        setPSRTargetUserIds.add(tp.Assigned_Partner_Sales_Rep__c);
                    }
                    if(tp.Assigned_Partner_Sales_Rep_2__c != Null) {
                        setPSRTargetUserIds.add(tp.Assigned_Partner_Sales_Rep_2__c);
                    }
                    if(tp.Assigned_Partner_Sales_Rep_3__c != Null) {
                        setPSRTargetUserIds.add(tp.Assigned_Partner_Sales_Rep_3__c);
                    }
                }                                       
             }
        }catch(exception e) {               
                exceptionString+= String.valueof('ExceptionType: '+e.getTypeName()+' \nError Message :'+e.getMessage()+'\nLine :  '+e.getLineNumber());
                successBoolean = false;
         }      
    }   
    global Database.QueryLocator start(Database.BatchableContext BC) {       
       // Fetch all the users which are having portaltype as 'Partner'
        return Database.getQueryLocator([Select id, email, firstname, lastname, 
                                         UserRole.PortalRole, UserRole.portalaccountid,
                                         UserRole.PortalType, LanguageLocaleKey 
                                         From User 
                                         where UserRole.PortalType = 'Partner' 
                                         and isActive = true 
                                         and ((Id IN: setPSRLeadUserIds OR Id IN: setPSRTargetUserIds) OR (UserRole.portalaccountId IN: setPALeadUserIds OR UserRole.portalaccountId IN: setPATargetUserIds))]);
      
    }     
    global void execute(Database.BatchableContext BC, List<User> scope) {            
        // Local variables
        Set<ID> setPartnerAccounts = new Set<ID>();
        Set<ID> setPSRUsers = new Set<ID>();
        //US11655 - added new Set setPAUsers to be used to identify the leads where PAs are acting as PSRs.
        Set<ID> setPAUsers = new Set<ID>();
        map<ID, User> mapUsers = new map<ID, User>();
        Map<ID, User> mapPartnerUser = new map<ID, User>();       
        try {            
        for(User usr: scope){                
            //Check the user is a "Executive" role.
            if (usr.UserRole.portalrole.equals(executiveUserRole)) {                    
                setPartnerAccounts.add(usr.UserRole.portalaccountid);                   
                mapUsers.put(usr.id, usr);
                mapPartnerUser.put(usr.id, usr);
                setPAUsers.add(usr.id);
            }else{ 
                //Capture non "Executive" role users    
                setPSRUsers.add(usr.id); 
                mapPartnerUser.put(usr.id, usr);               
            }
        }            
        // Invoke method to calculate record count.
         EmailNotification_Utility.getInstance(setPartnerAccounts, setPSRUsers, setPAUsers, mapUsers, mapPartnerUser, dtEmailNotification);            
        }catch(exception e)
        {
            exceptionString+= String.valueof('ExceptionType: '+e.getTypeName()+' \nError Message :'+e.getMessage()+'\nLine :  '+e.getLineNumber());         
            successBoolean = false;
        }
    }       
    global void finish(Database.BatchableContext BC) {        
        try{
            // Update the custom setting date value with next day.
            P360_Apex_Batch_Job__c.getInstance('P360 dtToday').DT_DailyEmailNotification__c = dtEmailNotification.addDays(1);               
            update P360_Apex_Batch_Job__c.getInstance('P360 dtToday');
        }catch(exception e) {
            exceptionString+= String.valueof('ExceptionType: '+e.getTypeName()+' \nError Message :'+e.getMessage()+'\nLine :  '+e.getLineNumber());
            successBoolean = false;
        }finally{            
            //check for errors                 
            if(ExceptionString.length()>1 || !successboolean)
            {    
                //prepare email
                String strMsg = '::DailyEmailNotification::' +'\n'+'\n'+ExceptionString;
                String toAddress = P360_Apex_Batch_Job__c.getInstance('P360 dtToday').JobEmailAlerts__c;                                         
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
                String[] toAddresses = new String[] {toAddress};  
                mail.setToAddresses(toAddresses);  
                mail.setSubject('ApexBatchJob Status'); 
                mail.setPlainTextBody(strMsg);
                //send email
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
    }
}