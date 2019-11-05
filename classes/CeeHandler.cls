/****************************************************************************************************************************
Name    : CeeHandler 
Author  : Jay Dash
Purpose : This is a Trigger Handler for all the required processing on the CEE_c SObject. This class implements the ITrigger
          interface to help ensure the trigger code is bulkified and all in one place.
Created Date: 7/10/2015
Modification History:
    Sudi (09/18/2015) : Code modified for Userstory - US8848 , Adding 5 days to End site date exluding week ends and public holidays to the FSo location.
    Prasanna    CPOC    03-Feb-2016     Populating customer arrival end date based on service type, populating primary scheduler and secondary scheduler 
                                        for CPOC record type, calling CPOC_TriggerImpl if the record type is CPOC
*****************************************************************************************************************************/

public without sharing class CeeHandler implements ITrigger
{
    private String TAG = 'CEEHandler - ';
    public Set<Id> CEELocationIDSet ;
    public Set<Id> accountFetch ;
    public Set<Id> locationFetch ;
    public List<Id> CEEaccountFetch ;
    public List<CEE__c> CEEresources ;
    public List<Id> resourceUpdate;
    public List<Id> UpdateRoom; 
    public List<CEE__c> lstCee ;
    public List<CEE__c> CEEresourceUpdate ;
    public List<Messaging.SingleEmailMessage> mails ;
    public Map<Id, List<CEE_Attendee__c>> presenterMap ;
    public Map<Id, Account> accountMap = null;
    public Map<String, Account_Executive_Sponsor__c> accounts ;
    public Map<Id, CEE_Location__c> CEELocationMap;
    Public TimeZone userZone ;
    public CEE__c[] resources ; 
    public string jiffleTypeId;
    public string itceRecordTypeId;
    public string GTECompliance;
    public string RequestStatus;
    public string obxRecordTypeId;
    public string SanjoseLocation;
    public string CPOCRecordTypeId;
    private string strsun = 'Sun';
    private string strsat = 'Sat';
    
    //Added for primarysite autopopulate
    public List<String> CEEprimarySite ;
    public List<CEE_location__c> location ;
    public MAP<String ,String > maplocation ;
    
    // Constructor
    public CeeHandler()
    {
        resources = Trigger.new;
        userZone = UserInfo.getTimeZone();
        GTECompliance = System.Label.GTE_Compliance_Msg;
        RequestStatus = System.Label.CEE_Request_Status;
        jiffleTypeId = ObjectRecordTypeIds__c.getorgdefaults().CEE_Jiffle_Now_Record_Type_Id__c;
        obxRecordTypeId = objectRecordTypeIds__c.getOrgDefaults().CEE_OBX_Record_Type_ID__c.substring(0,15);
        itceRecordTypeId = ObjectRecordTypeIds__c.getorgdefaults().CEE_ITCE_Record_Type_Id__c;
        SanjoseLocation = System.Label.CEE_SanJoseExperienceCenter; 
        CPOCRecordTypeId = ObjectRecordTypeIds__c.getorgdefaults().CEE_CPOC_Record_Type_ID__c;
    }
    //Method to call all before insert/update process request
    public void bulkBefore()
    {
    System.debug('BEFORE');
        CEELocationIDSet = new Set<Id>();
        accountFetch = new Set<Id>();
        locationFetch = new Set<Id>();
        CEEresourceUpdate = new List<CEE__c>();
        lstCee = new List<CEE__c>();
        CEEaccountFetch = new List<Id>();
        CEEresources = new List<CEE__c>();
        
        CEEprimarySite =new List<String>();
        location =new List<CEE_location__c>();
        maplocation = new MAP<String , String>();
        
        if(!Trigger.isDelete){           
            // We are using CPOC_TriggerImpl class method to calculate visit End date and customer arrival endDate 
            // Based on the number of days selected and removing week ends
            for(sobject s: trigger.new){
            CEE__c cee = (CEE__c) s;
                if(cee.RecordTypeId == ObjectRecordTypeIds__c.getorgdefaults().CEE_CPOC_Record_Type_ID__c){
                    CPOC_TriggerImpl ch = new CPOC_TriggerImpl();
                    ch.calculateEndDate();   
                }
            }                             
            for (CEE__c rec: resources){
                if( rec.RecordTypeId == obxRecordTypeId && rec.EBC_CBC_Location__c != null && rec.Primary_FSO__c == null){
                    CEEprimarySite.add(rec.EBC_CBC_Location__c);
                }
                //Prasanna CPOC  Adding CPOC Location
                if(rec.RecordTypeId == CPOCRecordTypeId){
                    CEEprimarySite.add(rec.preferred_lab__c);
                  
                }    
            }
            location = [select id,name from CEE_location__c where name in :CEEprimarySite and Is_Location_Active__c= 'Yes'];
            
            if(!location.isEmpty()){
                for (CEE_location__c psite: location){
                    maplocation.put(psite.name,psite.id);
                }                
            }
            for (CEE__c rec: resources){
                if(rec.Request_Status__c == RequestStatus && rec.RecordTypeId != jiffleTypeId){
                    lstCee.add(rec);
                }                           
                //Record type separation
                if(rec.RecordTypeId != jiffleTypeId){
                    //Add resource to update fields
                    CEEresourceUpdate.add(rec);                    
                    //Approval process validation
                    if(Trigger.isUpdate){
                        //VALIDATION 1 - Approval Process validations
                            //Check 1 - GTE ID
                            if(rec.Final_Approval_Flag__c && rec.Legal__c == 'Yes' && String.isEmpty(rec.Legal_GTE_ID__c)){
                                rec.addError(GTECompliance);
                            }
                    }                  
                    //Check for ESP updates
                    accountFetch.add(rec.Primary_Account__c);                    
                    if(rec.RecordTypeId == obxRecordTypeId && rec.EBC_CBC_Location__c == SanjoseLocation && rec.Event_Type__c == 'Good Will Visit' && rec.Service_Charge_1K_USD_to_Engagement__c != null){
                        rec.Service_Charge_1K_USD_to_Engagement__c ='';
                    }
                    //Prasanna  CPOC Adding Location
                    if(rec.RecordTypeId == CPOCRecordTypeId){
                        rec.CPOC_Location__c = maplocation.get(rec.Preferred_Lab__c);
                        
                        CEELocationIDSet.add(rec.CPOC_Location__c);
                    }
                    //Check for locations
                    if(rec.RecordTypeId != obxRecordTypeId && rec.Primary_FSO__c == null){
                        try{
                            rec.Start_Time_Site__c = CEE_Utility.convertUserTimeToUTC(rec.Start_Date_Time__c, userZone, 
                                rec.Timezone__c).format(CEE_Utility.TIME_FORMAT_ITCE);
                            rec.End_Time_Site__c = CEE_Utility.convertUserTimeToUTC(rec.End_Date_Time__c, userZone, 
                                rec.Timezone__c).format(CEE_Utility.TIME_FORMAT_ITCE);
                            
                        } catch (Exception e){
                            System.debug(TAG + 'ITCE TimeZone Exception - ' + e.getStackTraceString());
                        }
                        
                    } else if(rec.RecordTypeId == obxRecordTypeId && rec.EBC_CBC_Location__c !=null && rec.Primary_FSO__c == null && !maplocation.isEmpty()){
                        rec.Primary_FSO__c = maplocation.get(rec.EBC_CBC_Location__c);
                        CEELocationIDSet.add(rec.Primary_FSO__c);
                        
                    } 
                    else {
                        CEELocationIDSet.add(rec.Primary_FSO__c);
                    }
                   
                } else {
                    System.debug(TAG + 'Jiffle record, skipping trigger');
                }
                
                // if the flag has been set to true by the time-based workflow:
                if ((rec.Post_Engagement_Message_Sent__c) && (rec.emailHasNotBeenSent__c) && ((rec.Request_Status__c == 'Confirmed') || (rec.Request_Status__c == 'Assigned to PM')) 
                        && rec.RecordTypeId != jiffleTypeId) {
                    System.debug(TAG + 'valid resource found - ' + rec.Name);
                    CEEresources.add(rec);
                    CEEaccountFetch.add(rec.Primary_Account__c);                    
                    //Set default behavior          
                    rec.emailHasNotBeenSent__c = false;
                }
            }
            
           //Fetch context resources
            try{
                if(!accountFetch.isEmpty()){
                    //Fetch overlay          
                    List<Overlay_Acct_SuperGroup_Rel__c> accountSuperGroupJunction = [select Account_ID__c, Super_Group__c, Super_Group__r.FDEV_Super_Group_ID__c 
                            from Overlay_Acct_SuperGroup_Rel__c where Account_ID__c in : accountFetch ];
                    
                    //Create FDEV list
                    List<String> fdevFetch = new List<String>();
                    for(Overlay_Acct_SuperGroup_Rel__c overlay : accountSuperGroupJunction){
                        System.debug(TAG + 'overlay fdev - ' + overlay.Super_Group__r.FDEV_Super_Group_ID__c);
                        fdevFetch.add(overlay.Super_Group__r.FDEV_Super_Group_ID__c);                
                    }          
                    
                    //Fetch executive sponsors
                    List<Account_Executive_Sponsor__c> espList = [select id, ID__c from Account_Executive_Sponsor__c 
                            where ID__c in : fdevFetch ];
                    Map<String, Account_Executive_Sponsor__c> espMap = new Map<String, Account_Executive_Sponsor__c>();
                    for(Account_Executive_Sponsor__c esp : espList){
                        System.debug(TAG + 'esp id - ' + esp.ID__c);
                        espMap.put(esp.ID__c, esp);                
                    }
                            
                    //Map executive sponsors
                    accounts = new Map<String, Account_Executive_Sponsor__c>();
                    for(Overlay_Acct_SuperGroup_Rel__c overlay : accountSuperGroupJunction){
                        System.debug(TAG + 'overlay account_id - ' + overlay.Account_ID__c);
                        System.debug(TAG + 'overlay fdev_super_group - ' + overlay.Super_Group__r.FDEV_Super_Group_ID__c);
                        accounts.put(overlay.Account_ID__c, espMap.get(overlay.Super_Group__r.FDEV_Super_Group_ID__c));
                    }
                }
                string currentYear = string.valueOf(System.Today().year());
                // Sudi Added Userstory - US8848 
                // Added sub query to below SOQL to get the CEE location holidays based on current year
                // Used these holidays in Calculating the survey end date.
                // Sudi Added User Story - US10300
                // We added new field for Additional Secondary scheduler. 
                CEELocationMap = new Map<Id, CEE_Location__c>([SELECT Id, Primary_Scheduler__c,Additional_Secondary_Scheduler__c,Additional_Secondary_Scheduler2__c,Additional_Secondary_Scheduler_3__c,(Select Name,Id, Year__c, Holiday_Date__c From CEE_Location_Holidays__r where Year__c =:currentYear order by Holiday_Date__c asc)
                                                              ,Secondary_Scheduler__c,Site_Time_Zone__c,Scheduler_Mailer_Alias__c FROM CEE_Location__c WHERE Id IN: CEELocationIDSet]);
            } catch (Exception e){
                System.debug(TAG + 'Error retrieving related locations or accounts - ' + e.getStackTraceString());
            }
            System.debug('BEFORE LOADING...');
            //Update primary and secondary schedular              
            for (CEE__c rec: resources) {
                try{
                    // Sudi Added User Story - US10300
                    // we are populating the additional secondary scheduler.
                    if (CEELocationMap.containsKey(rec.Primary_FSO__c)  && rec.recordTypeId != jiffleTypeId){
                        rec.Primary_Scheduler__c = CEELocationMap.get(rec.Primary_FSO__c).Primary_Scheduler__c;
                        rec.Secondary_Scheduler__c = CEELocationMap.get(rec.Primary_FSO__c).Secondary_Scheduler__c;  
                        rec.Additional_Secondary_Scheduler__c = CEELocationMap.get(rec.Primary_FSO__c).Additional_Secondary_Scheduler__c;
                    
                    }
                    //Prasanna CPOC Assigning primary,secondary scheduler and Lab mailer alias for CPOC record type
                    else if(CEELocationMap.containsKey(rec.CPOC_Location__c) && rec.RecordTypeId == CPOCRecordTypeId){                       
                        rec.Primary_Scheduler__c = CEELocationMap.get(rec.CPOC_Location__c).Primary_Scheduler__c;
                        rec.Secondary_Scheduler__c = CEELocationMap.get(rec.CPOC_Location__c).Secondary_Scheduler__c; 
                       System.debug('PS## '+rec.Primary_Scheduler__c+' SC##'+rec.Secondary_Scheduler__c);
                        if(CEELocationMap.get(rec.CPOC_Location__c).Scheduler_Mailer_Alias__c != null)
                            rec.CPOC_Lab_Mailer__c = CEELocationMap.get(rec.CPOC_Location__c).Scheduler_Mailer_Alias__c;
                        if(CEELocationMap.get(rec.CPOC_Location__c).Additional_Secondary_Scheduler__c != null)
                            rec.Additional_Secondary_Scheduler__c = CEELocationMap.get(rec.CPOC_Location__c).Additional_Secondary_Scheduler__c;
                        if(CEELocationMap.get(rec.CPOC_Location__c).Additional_Secondary_Scheduler2__c != null)
                            rec.Additional_Secondary_Scheduler2__c = CEELocationMap.get(rec.CPOC_Location__c).Additional_Secondary_Scheduler2__c;
                        if(CEELocationMap.get(rec.CPOC_Location__c).Additional_Secondary_Scheduler_3__c != null)
                            rec.Additional_Secondary_Scheduler_3__c = CEELocationMap.get(rec.CPOC_Location__c).Additional_Secondary_Scheduler_3__c;
                    }
                } catch (Exception e){
                    System.debug(TAG + 'Error Updating primary and secondary schedular - '+e.getStackTraceString());
                }    
            }
             //Prasanna  CPOC call CPOC_TriggerImpl functionality only for update and for CPOC record type            
            if(trigger.isUpdate){
                for(sobject s: trigger.new){
                CEE__c cee = (CEE__c) s;
                    if(cee.RecordTypeId == ObjectRecordTypeIds__c.getorgdefaults().CEE_CPOC_Record_Type_ID__c){
                        CPOC_TriggerImpl ch = new CPOC_TriggerImpl();  
                        ch.sendEmailUponSubmission(Trigger.oldMap,Trigger.newMap);
                    }                             
                }
            } 
            
            for(CEE__c resource : CEEresourceUpdate){
                try{
                    if(!accounts.isEmpty()){
                        resource.Executive_Sponsors__c = accounts.get(resource.Primary_Account__c).Id;
                    }
                } catch (Exception e){
                    System.debug(TAG + e.getStackTraceString());
                    if(resource.Executive_Sponsors__c != null){
                        resource.Executive_Sponsors__c = null;
                    }
                }
                
                //Add time fields in Primary Site's timezone 
                if(resource.Primary_FSO__c != null){
                    // EBC use case
                    // Sudi Added Userstory - US8848 
                    // Local variable to used in Survey End date calculation.          
                     String[] endDateArry,dtsArry;
                     date StartDate,EndDate;
                     datetime newStartDate,newEndDate,dt;
                     integer i = 0; 
                    try{
                        CEE_Location__c site = CEELocationMap.get(resource.Primary_FSO__c);
                        resource.Start_Time_Site__c = resource.Start_Date_Time__c.format(CEE_Utility.TIME_FORMAT_EBC, site.Site_Time_Zone__c);
                        resource.End_Time_Site__c = resource.End_Date_Time__c.format(CEE_Utility.TIME_FORMAT_EBC, site.Site_Time_Zone__c); 
                        // Below code is adding 5 days to End Time site and populate same in Survey End date new  field, 
                        // excluding week ends and public holidays 
                        endDateArry = resource.End_Time_Site__c.split(' ');
                        dtsArry = endDateArry[0].split('/');                                                                       
                        StartDate = date.newinstance(Integer.valueOf(dtsArry[2]), Integer.valueOf(dtsArry[0]), Integer.valueOf(dtsArry[1]));
                        // ByDefalut added 5 days to the Edn site date
                        EndDate = StartDate + 5;                                                                       
                        newStartDate = (datetime) StartDate;
                        newEndDate = (datetime) EndDate;                                                                      
                        // Below loop we are checking any Sat, Sun in between End site date and 5 days added end site date.                                         
                        while (newStartDate <= newEndDate) {                                                                                
                            if (newStartDate.format('E',site.Site_Time_Zone__c) == strsat){
                                i++;
                            }
                            if(newStartDate.format('E',site.Site_Time_Zone__c) == strsun) {
                                i++;
                            }                                                       
                            newStartDate = newStartDate.addDays(1);                                                   
                        }                                          
                        EndDate = EndDate + i;
                        dt = (Datetime) EndDate;    
                        // after adding days just checking the end with sunday. if end with sunday adding 1 more day.                                               
                        EndDate = (dt.format('E',site.Site_Time_Zone__c) == 'strsun') ? EndDate + 1 : EndDate;  
                        // we are looping throw the location holidays between enddate and after adding 5 days date  
                        // if any holiday between these 2 dates then we are adding 1 day                                                                                                                                                                
                        for(CEE_Location_Holiday__c CEELoc : site.CEE_Location_Holidays__r){                                                                                       
                            datetime holidayDate = (Datetime)CEELoc.Holiday_Date__c;                                                                                                                   
                            if(CEELoc.Holiday_Date__c >= StartDate && CEELoc.Holiday_Date__c <= EndDate 
                              && holidayDate.format('E',site.Site_Time_Zone__c) != strsat 
                              && holidayDate.format('E',site.Site_Time_Zone__c) != strsun){                                                          
                                EndDate = EndDate + 1;                                
                            }
                        }                                                                                                            
                        dt = (Datetime) EndDate;  
                        // After adding holidays date agine checking for saterday and sunday
                        // if enddate is saterday we are adding 2 days, sunday then adding 1 day.                                                                                                                                          
                        if(dt.format('E',site.Site_Time_Zone__c) == strsat){
                            resource.Survey_End_Date__c = EndDate + 2;
                        }
                        else if(dt.format('E',site.Site_Time_Zone__c) == strsun) {
                            resource.Survey_End_Date__c = EndDate + 1;
                        }
                        else{
                            resource.Survey_End_Date__c = EndDate;                            
                        }
                    } catch (Exception e){                        
                        System.debug(TAG + 'EBC Time Exception - ' + e.getStackTraceString());
                    }
                } 
            }  
            //For WR-01094.
            if(!lstCee.isEmpty()){
                for(CEE__c ceeRd : lstCee){
                    if(ceeRd.Primary_FSO__c != null){
                        system.debug('++'+CEELocationMap+'++ceeRd.Primary_FSO__c:'+ceeRd.Primary_FSO__c);
                       ceeRd.Program_Manager__c = CEELocationMap.get(ceeRd.Primary_FSO__c).Primary_Scheduler__c ;               
                       ceeRd.Backup_PM__c= CEELocationMap.get(ceeRd.Primary_FSO__c).Secondary_Scheduler__c;
                    }   
                }       
            }     
            if(!CEEresources.isEmpty() ){
                try{
                    //Fetch presenters and make a map
                    presenterMap = new Map<Id, List<CEE_Attendee__c>>();
                    List<CEE_Attendee__c> presUsers = [SELECT Name, Email__c, Customer_Engagement_Events__c FROM CEE_Attendee__c WHERE Customer_Engagement_Events__c IN : CEEresources AND Type__c = 'Presenter'];
                    for(CEE_Attendee__c pres : presUsers){
                        if(presenterMap.containsKey(pres.Customer_Engagement_Events__c)){
                            presenterMap.get(pres.Customer_Engagement_Events__c).add(pres);
                        } else {
                            List<CEE_Attendee__c> newPresList = new List<CEE_Attendee__c>{pres};
                            presenterMap.put(pres.Customer_Engagement_Events__c, newPresList);
                        }
                    }
                    
                    //Fetch related accounts
                    accountMap = new Map<Id, Account>([SELECT Name, id from Account WHERE id IN : CEEaccountFetch]);
                } catch (Exception e){
                    System.debug(TAG + 'Error retrieving related objects - '  + e.getStackTraceString());
                }
                mails = new List<Messaging.SingleEmailMessage>();
                for(CEE__c resource : CEEresources){
                    if(presenterMap.get(resource.Id) != null){
                        System.debug(TAG + 'Presenter related to briefing found');
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        
                        //Form sendTo list
                        List<String> sendTo = new List<String>();
                        for (CEE_Attendee__c att : presenterMap.get(resource.Id)) {
                            sendTo.add(att.Email__c);
                        }
                        
                        mail.setToAddresses(sendTo);
                        mail.setReplyTo('do_not_reply@cisco.com');
                        mail.setSenderDisplayName('do_not_reply@cisco.com');
                        
                        // ITCE upcoming 
                        if (resource.RecordTypeid == itceRecordTypeId && resource.ITCE_Request_Type__c == Utilities.getConstant_CS('ITCE_Engagement_Type')) { 
                            //System.debug(TAG + '3.0');
                            mail.setSubject('Please fill in Presenter Post-Engagement Information');
                            String body = 'Dear Cisco Presenter,<p>';
                            body += 'Thank you for your presentation on Briefing ';
                            body += resource.Name;
                            body += '. Please access the record using the following link (';
                            body += URL.getSalesforceBaseUrl().toExternalForm() + '/' + resource.ID;
                            body += ') and fill in the "Presenter Post-Engagement Notes" section, addressing the following questions:<p>';
                            body += '- What info can be useful for the next presentation?<br>';
                            body += '- What topic resonated most with the customer?<p>';
                            body += 'Note: if this briefing had multiple presenters, there may already be content in the section on the record. If this is the case, please append to the existing information, do not remove it.<p>';
                            body += 'Thank you!';
                            mail.setHtmlBody(body);
                        } else {
                            mail.setSubject('CEE Presenter follow-up');
                            String body = 'Hello,<p>';
                            String acctName = accountMap.get(resource.Primary_Account__c).Name;
                            
                            body += 'Thank you for your time presenting at the ' + acctName + ' EBC meeting.<p>';
                            body += 'Please take the time to fill out the Notes and Attachments section of the record or Salesforce Chatter with any useful information you got out of the meeting by clicking the link below:<br>';
                            body += URL.getSalesforceBaseUrl().toExternalForm() + '/' + resource.id + '<p>'; 
                            body += 'Sample feedback:<p>';
                            body += '- Upload content shared with Customer and/or Account Team<br>';
                            body += '- What information can be useful at the next Customer visit?<br>';
                            body += '- What "outcomes" resonated the most with the Customer?<br>';
                            body += '- Have there been recent leadership changes with this Customer? If so, describe. <p>';
                            body += 'Thank you!';
                            mail.setHtmlBody(body);
                        }
                        
                        mails.add(mail);
                    }
                }
                
                //Send emails
                if(!mails.isEmpty() ){
                    System.debug(TAG + 'sending emails');
                    Messaging.sendEmail(mails);
                }
            }
            //Jiffle code start
            if(Trigger.isInsert){
                GlobalTriggerManagement__c csActive = GlobalTriggerManagement__c.getValues('JiffleR1_CEE');
                Boolean bTrigger;    
                if(csActive == Null){
                    bTrigger = true;
                }else{
                    bTrigger = false;
                }
                    
                if (!bTrigger){
                    JiffleNowMeetingsManagement_cls jMM = new JiffleNowMeetingsManagement_cls();
                    jMM.JiffleManagement(resources);
                }
            }
            //Jiffle code end
        }    
    }
 
    public void bulkAfter()
    {
    
        UpdateRoom = new List<Id>();
         /* Calling Method to delete Rooms and Personnel once lab is redirected for CPOC request*/
        if(Trigger.isupdate){
            for(sobject s: trigger.new){
                CEE__c cee = (CEE__c) s;
                if(cee.RecordTypeId == ObjectRecordTypeIds__c.getorgdefaults().CEE_CPOC_Record_Type_ID__c){
                    CPOC_TriggerImpl.deleteOnLabRedirect();
                    CPOC_TriggerImpl.recallonLabRedirect(Trigger.oldMap,Trigger.newMap);
                }
            }        
        }
         /* Calling method for directly submmiting the request to Scheduler for CPOC Request */
        if(Trigger.isinsert){
             for(sobject s: trigger.new){
                CEE__c cee = (CEE__c) s;
                if(cee.RecordTypeId == ObjectRecordTypeIds__c.getorgdefaults().CEE_CPOC_Record_Type_ID__c
                && CPOC_Lab_Request__c.getorgdefaults().CPOC_Data_Migration_Flag__c == 'TRUE'){
                    CPOC_TriggerImpl.SaveAndSubmmit();
                }
            }
        }
        if(!Trigger.isDelete){
            for(CEE__c resource : resources){
                if(Trigger.isInsert){
                    if(resource.RecordTypeId != jiffleTypeId){
                        UpdateRoom.add(resource.Id);
                    }
                }else if(Trigger.isUpdate){
                    // CEE2 - Added additional logic to filter Room name changes from triggering Force Workflow (line# 56)
                    CEE__c oldCEE = (CEE__c)Trigger.oldMap.get(resource.id);            
                    if(resource.RecordTypeId != jiffleTypeId && resource.Room_Name__c == oldCEE.Room_Name__c){
                        UpdateRoom.add(resource.Id);
                    }
                }
            }        
    
            //Force workflows to re-run on related objects
            try{
                if(!UpdateRoom.isEmpty()){
                    List<Agenda_Room__c> rooms = [select Id, Name from Agenda_Room__c where Customer_Engagements_Events__c IN : UpdateRoom];
                    List<Agenda_Item__c> items = [select Id, Name from Agenda_Item__c where Customer_Engagements_Events__c IN : UpdateRoom];
                    
                    update rooms;
                    update items;
                }
            } catch (Exception e){
                System.debug(TAG + 'Error in refreshing the workflows for Agenda Rooms or Agenda Items');
                System.debug(TAG + e.getStackTraceString());
            }
        }
        
    }
    /* @Method: empty method */
    public void beforeUpdate(SObject oldSo, SObject so)
    {

    }
    /* @Method: empty method */
    public void beforeDelete(SObject so)
    {
    }
    /* @Method: empty method */
    public void beforeInsert(SObject so)
    {
            Set<Id> userIds = new Set<Id>();
            CEE__c cee = (CEE__c) so;
            String eMailErrorMessage='';
            if(cee.Primary_Scheduler__c!=null || cee.Additional_Secondary_Scheduler__c!=null || cee.Secondary_Scheduler__c!=null || cee.Program_Manager__c!=null || cee.Backup_PM__c!=null)
            {
                userIds = new Set<Id>{cee.Primary_Scheduler__c,cee.Additional_Secondary_Scheduler__c,cee.Secondary_Scheduler__c,cee.Program_Manager__c,cee.Backup_PM__c};
            }
            
            Map<Id,User> uMap = new Map<Id,user>([Select Id,IsActive,Name From User where Id IN:userIds]);

            //Fetching Error Message from the Custom label
            List<String> errorMessage = System.Label.Cee_Approval_Error_Message.split('"');
            if(errorMessage!=null)
            {
                //Validating the Primary Scheduler
                if(cee.Primary_Scheduler__c!=null && uMap.get(cee.Primary_Scheduler__c)!=null && uMap.get(cee.Primary_Scheduler__c).IsActive==false)
                {
                    if(cee.RecordTypeId == obxRecordTypeId && cee.EBC_CBC_Location__c != null){
                        eMailErrorMessage = errorMessage[0]+' "'+uMap.get(cee.Primary_Scheduler__c).Name +'" '+errorMessage[1]+' "'+ cee.EBC_CBC_Location__c +'" '+errorMessage[2];
                        cee.addError(eMailErrorMessage);                        
                    }
                    if(cee.RecordTypeId == CPOCRecordTypeId){
                        eMailErrorMessage =errorMessage[0]+' "'+uMap.get(cee.Primary_Scheduler__c).Name +'" '+errorMessage[1]+' "'+ cee.preferred_lab__c+'" '+errorMessage[2];
                        cee.addError(eMailErrorMessage);
                    }                
                } 
                
                //Validating the Additional Secondary Scheduler
                if(cee.Additional_Secondary_Scheduler__c!=null && uMap.get(cee.Additional_Secondary_Scheduler__c)!=null && uMap.get(cee.Additional_Secondary_Scheduler__c).IsActive==false)
                {
                    if(cee.RecordTypeId == obxRecordTypeId && cee.EBC_CBC_Location__c != null){
                        eMailErrorMessage =errorMessage[0]+' "'+uMap.get(cee.Additional_Secondary_Scheduler__c).Name +'" '+errorMessage[1]+' "'+ cee.EBC_CBC_Location__c +'" '+errorMessage[2];
                        cee.addError(eMailErrorMessage);                        
                    }
                    if(cee.RecordTypeId == CPOCRecordTypeId){
                        eMailErrorMessage = errorMessage[0]+' "'+uMap.get(cee.Additional_Secondary_Scheduler__c).Name +'" '+errorMessage[1]+' "'+ cee.preferred_lab__c+'" '+errorMessage[2];
                        cee.addError(eMailErrorMessage);
                    }                
                }
                
                //Validating the Secondary Scheduler
                if(cee.Secondary_Scheduler__c!=null && uMap.get(cee.Secondary_Scheduler__c)!=null && uMap.get(cee.Secondary_Scheduler__c).IsActive==false)
                {
                    if(cee.RecordTypeId == obxRecordTypeId && cee.EBC_CBC_Location__c != null){
                        eMailErrorMessage = errorMessage[0]+' "'+uMap.get(cee.Secondary_Scheduler__c).Name +'" '+errorMessage[1]+' "'+ cee.EBC_CBC_Location__c +'" '+errorMessage[2];
                        cee.addError(eMailErrorMessage);
                    }
                    if(cee.RecordTypeId == CPOCRecordTypeId){
                        eMailErrorMessage = errorMessage[0]+' "'+uMap.get(cee.Secondary_Scheduler__c).Name +'" '+errorMessage[1]+' "'+ cee.preferred_lab__c+'" '+errorMessage[2];
                        cee.addError(eMailErrorMessage);
                    }                
                } 
                //Validating the Program Manager
                if(cee.Program_Manager__c!=null && uMap.get(cee.Program_Manager__c)!=null && uMap.get(cee.Program_Manager__c).IsActive==false)
                {
                    if(cee.RecordTypeId == obxRecordTypeId && cee.EBC_CBC_Location__c != null){
                        eMailErrorMessage = errorMessage[0]+' "'+uMap.get(cee.Program_Manager__c).Name +'" '+errorMessage[1]+' "'+ cee.EBC_CBC_Location__c +'" '+errorMessage[2];
                        cee.addError(eMailErrorMessage);
                    }
                    if(cee.RecordTypeId == CPOCRecordTypeId){
                        eMailErrorMessage = errorMessage[0]+' "'+uMap.get(cee.Program_Manager__c).Name +'" '+errorMessage[1]+' "'+ cee.preferred_lab__c+'" '+errorMessage[2];
                        cee.addError(eMailErrorMessage);
                    }                
                } 
                //Validating the Backup PM
                if(cee.Backup_PM__c!=null && uMap.get(cee.Backup_PM__c)!=null && uMap.get(cee.Backup_PM__c).IsActive==false)
                {
                    if(cee.RecordTypeId == obxRecordTypeId && cee.EBC_CBC_Location__c != null){
                       eMailErrorMessage = errorMessage[0]+' "'+uMap.get(cee.Backup_PM__c).Name +'" '+errorMessage[1]+' "'+ cee.EBC_CBC_Location__c +'" '+errorMessage[2];
                        cee.addError(eMailErrorMessage);
                    }
                    if(cee.RecordTypeId == CPOCRecordTypeId){
                        eMailErrorMessage = errorMessage[0]+' "'+uMap.get(cee.Backup_PM__c).Name +'" '+errorMessage[1]+' "'+ cee.preferred_lab__c+'" '+errorMessage[2];
                        cee.addError(eMailErrorMessage);
                    }                
                } 
            if(eMailErrorMessage!=''){
             List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();                                             
                mail.setToAddresses(new List<String>{'rpragall@cisco.com','srchakal@cisco.com','praschan@cisco.com'});
                mail.setReplyTo('do_not_reply@cisco.com');
                mail.setSenderDisplayName('do_not_reply@cisco.com');
                mail.setSubject('Error on processing CEE');
                    String body = 'There was an error in Cisco Systems, Inc. ';     
                    body += URL.getSalesforceBaseUrl().toExternalForm()+'<br>';
                    body +='caused by: '+eMailErrorMessage;  
                mail.setHtmlBody(body);
                mails.add(mail);
            
                //Send emails   
                if(!mails.isEmpty() ){
                    System.debug(TAG + 'sending emails');
                    Messaging.sendEmail(mails);
                }
             }
         }            
     }
 
    public void afterInsert(SObject so)
    {
       CEE__c cee = (CEE__c) so;
       string ApprovalName = (cee.EBC_CBC_Location__c == SanjoseLocation) ? 'Customer_Engagement_AM_Submission_SanJos' : 'Customer_Engagement_AM_Submission_New_v3';
       if(cee.RecordTypeId == obxRecordTypeId){
           Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
           req1.setProcessDefinitionNameOrId(ApprovalName);
           req1.setObjectId(cee.id);
           if(!test.isrunningtest()){
            Approval.ProcessResult result = Approval.process(req1);
            system.debug(System.LoggingLevel.INFO, 'Approval Result ::' + result);
           }                 
       } 
                
   }
    /* @Method: empty method */
    public void afterUpdate(SObject oldSo, SObject so)
    {
       
    }
    /* @Method: empty method */
    public void afterDelete(SObject so)
    {
    }
    /* @Method: empty method */
    public void andFinally()
    {

    }      
}