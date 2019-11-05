//Commented the code as per WR-2104(move all send email logic to work flow email)
public class CPOC_TriggerImpl{
    // SCAVA Helper Method to validate Create Access at field level
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }
    
    public static List<Note> listNotes = new List<Note>(); 
    private String strSunday = 'Sun';
    private String strSaterday = 'Sat';
    private String strBy = ' by ';
    private String strTo = ' to ';
    private String strRequestStatus ='Request status : ';
    private String strScheduled = 'Scheduled';
    private String strScheduleChange = 'Schedule Change';
    public  static boolean flag = true;
    public  static boolean preflag = true;
    public  static boolean recallflag = true;
    public static boolean notesFlag = true;
    public static boolean statusFlag = true;
    //This is empty Constructor.
    public CPOC_TriggerImpl(){}
         
    private sObject populateSendEmail(CEE__c rec, String type, String oldStatus){        
        SObjectType objType = Schema.getGlobalDescribe().get('SendEmail__c');
        Map<String,Schema.SObjectField> mfields = objType.getDescribe().fields.getMap();
        sObject sendEmail = new SendEmail__c();
        List<String> listFields = new List<String>();
        for(String s : mfields.keySet()){
            if(mfields.get(s).getDescribe().getType().name().toupperCase()== 'EMAIL' && s.contains('cpoc_recipient')){
               listFields.add(s); 
            }
        }
        
        if(rec.Additional_Email_IDs__c != null){
            List<String> toAdd = rec.Additional_Email_IDs__c.split(',');
            for(Integer i=1;i<=toAdd.size();i++){
                sendEmail.put(mfields.get(listFields[i-1]),toAdd[i-1]);    
            }
        }
        sendEmail.put('CPOC_Customer_Name__c',rec.Account_Name_English__c);     
        sendEmail.put('CPOC_Detail_Link__c',URL.getSalesforceBaseUrl().toExternalForm() + '/' + rec.id);
        
        sendEmail.put('CPOC_Request_Number__c',rec.Name);
        sendEmail.put('Type__c',type);
        sendEmail.put('CPOC_Visit_Type__c',rec.Service_type__c);
        sendEmail.put('CPOC_SE_Email__c',rec.SE_Email__c);
        sendEmail.put('CPOC_Sales_Objectives__c',rec.Test_Objectives__c);
        sendEmail.put('Requestor_Manager_Email__c',rec.SE_Manager_Email__c);
        sendEmail.put('CPOC_Account_Manager__c',rec.Account_Manager_s_Email__c);
        sendEmail.put('CPOC_Key_Technology__c',rec.Key_Technology__c);
        sendEmail.put('CPOC_Preferred_Lab__c',rec.preferred_lab__c);
        sendEmail.put('CPOC_Requested_Customer_Arrival_Date__c',rec.Requested_Customer_Arrival_Date__c);
        sendEmail.put('EmailID__c',rec.CPOC_Lab_Mailer__c);
        sendEmail.put('CPOC_Requestor__c',rec.Your_Email__c);
        sendEmail.put('CPOC_Visit_Start_Date__c',rec.CPOC_Start_Date__c);
        sendEmail.put('CPOC_Visit_End_Date__c',rec.CPOC_End_Date__c);
        sendEmail.put('CPOC_Reason__c',rec.Reason__c);        
        sendEmail.put('CPOC_Engineer__c',rec.Assigned_Engineer__c);
        sendEmail.put('CPOC_Primary_Scheduler__c',rec.Primary_Scheduler_Email__c);
        sendEmail.put('CPOC_Secondary_Scheduler__c',rec.Secondary_Scheduler_Email__c);
        sendEmail.put('CPOC_Additional_Secondary_Scheduler__c',rec.Additional_Secondary_Scheduler_Email__c);
        sendEmail.put('CPOC_Additional_Secondary_Scheduler2__c',rec.Additional_Secondary_Scheduler2_Email__c);
        sendEmail.put('CPOC_Additional_Secondary_scheduler_3__c',rec.Additional_Secondary_scheduler_3_Email__c);
        sendEmail.put('Name__c',oldStatus);
        //Priyanka Jangid - 26th Aug 2016 : Populating requester name instead of Username
        sendEmail.put('CPOC_Requester_User__c',rec.createdbyId);
        sendEmail.put('CPOC_Primary_Architecture__c',rec.Primary_Architecture__c);
        sendEmail.put('CPOC_Type__c',rec.Type__c);
        sendEmail.put('CPOC_Account_Team_Arrival_Date__c', rec.Account_team_arrival_date__c);         
        sendEmail.put('CPOC_Customer_Start_Date__c', rec.Customer_Start_date__c); 
        sendEmail.put('CPOC_Link_to_Equipment_Reservations__c', rec.Link_to_Equipment_Reservations__c);
        sendEmail.put('CPOC_Lab_Mailer__c', rec.CPOC_Lab_Mailer__c);
        //Priyanka Jangid - 12th Oct 2016 : Populating fields for CPOC Survey   
        if(type =='CPOC Survey'){
            if(rec.Email_IDs_of_Customer__c != null){
                List<String> toAdd = rec.Email_IDs_of_Customer__c.split(',');
                for(Integer i=1;i<=toAdd.size();i++){
                    sendEmail.put(mfields.get(listFields[i-1]),toAdd[i-1]);    
                }
            }
        if(rec.CPOC_End_Date__c!=null){                         
            sendEmail.put('CPOC_Visit_End_Date__c',Datetime.newInstance(rec.CPOC_End_Date__c.year(), rec.CPOC_End_Date__c.month(), rec.CPOC_End_Date__c.day(), 8, 0, 0));     
            sendEmail.put('CPOC_Reason__c',rec.id); 
            sendEmail.put('CPOC_Survey_End_Date__c',rec.CPOC_Survey_End_Date__c); 
            sendEmail.put('CPOC_Survey_Reminder_date__c',rec.CPOC_Survey_Reminder_date__c); 
            sendEmail.put('CPOC_Survey_URL__c',rec.Survey_URL__c);
        } 
        }        
        return sendEmail;
    }
  
   /* Method to Submmit the request directly on save clicking save button */
    static public void saveAndSubmmit()
    {
        for(sobject s: trigger.new){
            CEE__c cee = (CEE__c) s;       
            String approvalName = '';
            if(cpoc_lab_request__c.getorgdefaults().CPOC_Tokyo__c.contains(cee.Preferred_Lab__c))
            {
                approvalName = cpoc_lab_request__c.getorgdefaults().CPOC_Approval__c;               
            }else if(cpoc_lab_request__c.getorgdefaults().CPOC_RTP_Sydney__c.contains(cee.Preferred_Lab__c))
            {
                approvalName = cpoc_lab_request__c.getorgdefaults().CPOC_Approval_RTP_SYDNEY__c;
            }else 
            {
                approvalName = cpoc_lab_request__c.getorgdefaults().CPOC_Approval_Process_London__c;
            }               
            if(approvalName != ''){
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setProcessDefinitionNameOrId(approvalName);
                req1.setObjectId(cee.id);
                Approval.ProcessResult result = Approval.process(req1);  
            }           
        }
    }
    /* Method to delete Rooms and Personnel once lab is redirected */
    static public void deleteOnLabRedirect(){
    
        Set<Id> lstIds = new Set<Id>();             
        for( sObject s: trigger.New)
        {  
            CEE__C rec = (cee__c) s;
            CEE__c oldRec = (cee__c) trigger.oldMap.get(S.Id);
            if(rec.RecordTypeId == ObjectRecordTypeIds__c.getorgdefaults().CEE_CPOC_Record_Type_ID__c 
               && rec.Preferred_Lab__c  != oldrec.Preferred_Lab__c){                                
                lstIds.add(rec.id);                             
            }
        }   
        // Checking list variable has any CPOC request has location change ids 
        // Then we are deleting all CPOC Room,personal, Share resource objects  data.
        try{
            if(!lstIds.isEmpty()){
                List<CPOC_Room__c> cpocLst = [SELECT id,Customer_Engagements_Events__r.id 
                           FROM CPOC_Room__c 
                           WHERE Customer_Engagements_Events__r.id = :lstIds];
                List<CPOC_Personnel__c> perLst = [SELECT id,Customer_Engagements_Events__r.id 
                         FROM CPOC_Personnel__c 
                         WHERE Customer_Engagements_Events__r.id = :lstIds];
                List<CPOC_Shared_Resource__c> resLst = [SELECT id,Customer_Engagements_Events__r.id 
                          FROM CPOC_Shared_Resource__c 
                          WHERE Customer_Engagements_Events__r.id = :lstIds];   
               //SCAVA FIX
               if (CPOC_Room__c.sObjectType.getDescribe().isDeletable())
               {
                delete cpocLst;
               }
               if (CPOC_Personnel__c.sObjectType.getDescribe().isDeletable())
               {
                delete perLst;
               }
               if (CPOC_Shared_Resource__c.sObjectType.getDescribe().isDeletable())
               {
                delete resLst;
               }
                
            }       
        }
        catch(Exception e){
            System.debug('Exception caught: ' + e.getMessage());    
        }   
    }
    /* Method to calculate End Date */
    public void calculateEndDate(){
        Integer reqdayval = 0; 
        for(sObject s : trigger.new){
            CEE__C rec = (cee__c) s;
            //Priyanka Jangid - 21st Sep 2016 : Added condition for null check before calculating End Date
            if(rec.RecordTypeId == ObjectRecordTypeIds__c.getorgdefaults().CEE_CPOC_Record_Type_ID__c && rec.Requested_Days__c != null&&
                ((!cpoc_lab_request__c.getorgdefaults().requested_days_5_plus__c.contains(rec.Requested_Days__c))
                &&(cpoc_lab_request__c.getorgdefaults().Requested_Days_Lessthan1__c!=rec.Requested_Days__c))){ 
                String strRequestedDays = rec.Requested_Days__c;                                                    
                String calculatedays= strRequestedDays.substring(0,1);                 
                if(calculatedays != ''){
                    reqdayval = Integer.valueof(calculatedays);
                }
                if(rec.Requested_Customer_Arrival_Date__c!=null){                               
                    Datetime endate = rec.Requested_Customer_Arrival_Date__c.addDays(reqdayval-1);  
                    rec.Requested_Customer_End_Date__c = endateWithWorkingHrs(removeWeekEnds(rec.Requested_Customer_Arrival_Date__c,endate));                                                           
                }
            }            
        }
    }   
    private Datetime endateWithWorkingHrs(Datetime endate){
        Integer year = endate.year();
        Integer month = endate.month();
        Integer day = endate.day();
        return Datetime.newInstance(year, month, day, 17, 0, 0); 
    }
    
    private Datetime removeWeekEnds(Datetime sDate, Datetime eDate){
        Integer iCount = 0; 
        Datetime startDate = sDate;
        Datetime endDate = eDate;               
        while (startDate < = endDate) {
            if (startDate.format('E') == strSaterday || startDate.format('E') == strSunday){
                iCount = iCount + 1;
            }
            startDate = startDate.addDays(1);
        }
        endDate = endDate + iCount;
        if(endDate.format('E') == strSaterday){
            endDate = endDate + 2;
        }
        if(endDate.format('E') == strSunday){
            endDate = endDate + 1;
        }
        return endDate;         
    }
    //Commented the line 328 as per WR-2104
    public void sendEmailUponSubmission(Map<id,sObject> oldMap, Map<Id,sObject> newMap){
        String Type = '';
        String oldStatus = '';
        string title = '';
        string Body = '';
        list<sObject> lstSendEmailRecords = new list<sObject>();
        for(sObject eachRec : newMap.Values()){
            CEE__c rec = (CEE__c)eachRec ;
            CEE__c oldRec = (CEE__c)oldMap.get(rec.id);
            
            if(rec.RecordTypeId == ObjectRecordTypeIds__c.getorgdefaults().CEE_CPOC_Record_Type_ID__c){
            
                if(oldrec.Request_Status__c != strScheduled && rec.Request_Status__c == strScheduled && CPOC_Lab_Request__c.getorgdefaults().CPOC_Data_Migration_Flag__c == 'TRUE'){
                    if(rec.Customer_Start_date__c== null || rec.CPOC_start_Date__c == null || 
                        rec.CPOC_End_Date__c == null || rec.Assigned_Engineer__c== null || rec.Assigned_Engineer__c== ''
                        ||(rec.Customer_Start_date__c < rec.CPOC_start_Date__c || rec.Customer_Start_date__c > rec.CPOC_End_Date__c)
                    ||(rec.Account_team_arrival_date__c < rec.CPOC_start_Date__c || rec.Account_team_arrival_date__c > rec.CPOC_End_Date__c) ){
                            rec.addError('Please populate Customer Start Date, CPOC Start Date, CPOC End Date and Personnel(s) before approving the request. \n \n Account team arrival date and Customer Start date should be within the CPOC Start and End Date');
                    }                       
                    
                }
               if(oldrec.Request_Status__c == strScheduled && rec.Request_Status__c == 'Lab Redirect' && CPOC_Lab_Request__c.getorgdefaults().CPOC_Data_Migration_Flag__c == 'TRUE'){               
                   if(rec.preferred_lab__c != oldRec.preferred_lab__c){
                           rec.addError('You cannot Redirect Lab once the request is Scheduled');
                   }
               }               
               if(rec.preferred_lab__c == oldRec.preferred_lab__c && rec.Request_Status__c != oldRec.Request_Status__c && rec.Request_Status__c == 'Lab Redirect' )
               {
                    rec.addError('You cannot Redirect Lab without changing Preferred Lab');    
               }
               if(rec.CPOC_status__c == 'Rescheduled'){
                    List<ProcessInstance> pi = [Select ID, Status, TargetObject.Name,
                    (SELECT Id, ActorId, ProcessInstanceId FROM Workitems),
                    (SELECT Id, StepStatus, Comments FROM Steps) From ProcessInstance
                    Where TargetObjectID = :rec.id AND Status = 'Approved'];
                    system.debug('Process instance for approval' + pi);
                    if( pi.isempty() || oldrec.Request_status__c == 'Submitted'){
                        rec.addError('Please approve the request from Approval History if you wish to Schedule the Request');
                    }                
                }
                 if(rec.Request_Status__c != oldRec.Request_Status__c && statusFlag && (rec.Request_Status__c == 'Scheduled'  
                    || rec.Request_Status__c == 'Completed' || rec.Request_Status__c == 'Returned by Scheduler'||
                    oldrec.Request_Status__c == 'Lab Redirect')){
                    rec.CPOC_Status__c = null;
                    rec.Reason__c = null;
                    statusFlag = false;
                }
                //Priyanka Jangid - 12th Oct 2016 : Added condition for CPOC Survey
                if(rec.CPOC_End_Date__c != null && rec.Request_Status__c == 'Scheduled'&&  
                    rec.Request_Status__c != oldRec.Request_Status__c && rec.CPOC_End_Date__c.date() >= system.today()){
                    Type = 'CPOC Survey';
                    oldStatus = oldRec.Request_Status__c;
                    lstSendEmailRecords.add(populateSendEmail(rec,Type,oldStatus));                
                } 
                if(rec.Request_Status__c != oldRec.Request_Status__c &&
                    cpoc_lab_request__c.getorgdefaults().CPOC_Type__c.contains(rec.Request_Status__c)){   
                    Type = 'CPOC ' +  rec.Request_Status__c;                    
                    oldStatus = oldRec.Request_Status__c;                                                                            
                    Body = strRequestStatus + oldRec.Request_Status__c + strTo + rec.Request_Status__c+ strBy + userInfo.getUserName();
                    listNotes.add(returnNoteObject(rec.id,type,Body));
                    lstSendEmailRecords.add(populateSendEmail(rec,Type,oldStatus));                                       
                }           
                //Sudi - 5 Dec 2016 : Code fixed for scheduled email is firing for each and every survey response.          
                 if((rec.Request_Status__c != oldRec.Request_Status__c) && flag && ((rec.Request_Status__c == 'Submitted') || (rec.Request_Status__c == 'Scheduled')))
                 {                                          
                    Type = 'CPOC ' +  rec.Request_Status__c;                    
                    oldStatus = oldRec.Request_Status__c;                                                                            
                    Body = strRequestStatus + oldRec.Request_Status__c + strTo + rec.Request_Status__c+ strBy + userInfo.getUserName();
                    listNotes.add(returnNoteObject(rec.id,type,Body));
                    lstSendEmailRecords.add(populateSendEmail(rec,Type,oldStatus)); 
                    flag = false;
                }
                if(rec.Request_Status__c != oldRec.Request_Status__c && rec.Customer_Start_date__c !=null && rec.Request_Status__c == 'Scheduled'){
                    Type = 'CPOC Reminder';
                    oldStatus = oldRec.Request_Status__c;                    
                    lstSendEmailRecords.add(populateSendEmail(rec,Type,oldStatus)); 
                }   
                // Sudi - 19 Aug 2016 : When user redirected lab to other location 2 emails going. we fix this issue adding Static flag check
                if(rec.preferred_lab__c != oldRec.preferred_lab__c && preflag && (oldrec.Request_Status__c == 'Submitted' || oldrec.Request_Status__c == 'Hold')){
                    Type = 'CPOC Labredirect';  
                    Title = 'Lab Redirect/Change';
                    oldStatus = oldRec.Request_Status__c; 
                    Body = 'Preferred Lab : ' + oldRec.preferred_lab__c + strTo + rec.preferred_lab__c + strBy + userInfo.getUserName();                    
                    listNotes.add(returnNoteObject(rec.id,Title,Body));
                    lstSendEmailRecords.add(populateSendEmail(rec,Type,oldStatus)); 
                    preflag = false;
                }
                // Sudi - 19 Aug 2016 : To avoid duplicate notes created when workflow field updated is triggerd.
                if(notesFlag){
                    if(rec.service_type__c != oldRec.service_type__c){
                        title = 'Service Type Change';
                        Body =  'Service Type : ' + oldRec.service_type__c + strTo + rec.service_type__c + strBy + userInfo.getUserName();                    
                       listNotes.add(returnNoteObject(rec.id,title,Body));
                    }
                    if(rec.Request_Status__c != oldRec.Request_Status__c){
                        title = 'Status Change';
                        Body = strRequestStatus + oldRec.Request_Status__c + strTo + rec.Request_Status__c + strBy + userInfo.getUserName();                    
                        listNotes.add(returnNoteObject(rec.id,title,Body));
                    }
                    if(rec.CPOC_Start_Date__c != oldRec.CPOC_Start_Date__c){
                        title = strScheduleChange;
                        Body = 'Visit Start Date :' + oldRec.CPOC_Start_Date__c + strTo + rec.CPOC_Start_Date__c ;
                        Body += ' Visit End Date : ' + oldRec.CPOC_End_Date__c + strTo + rec.CPOC_End_Date__c + strBy + userInfo.getUserName();                    
                        listNotes.add(returnNoteObject(rec.id,title,Body));
                    }
                    if(rec.Requested_Customer_Arrival_Date__c != oldRec.Requested_Customer_Arrival_Date__c){
                        title = strScheduleChange;
                        Body = 'Requested Customer Arrival Date :' + oldRec.Requested_Customer_Arrival_Date__c + strTo + rec.Requested_Customer_Arrival_Date__c;
                        Body += ' Requested Customer End Date :' + oldRec.Requested_Customer_End_Date__c+ strTo + rec.Requested_Customer_End_Date__c;
                        Body += strBy + userInfo.getUserName();
                        listNotes.add(returnNoteObject(rec.id,title,Body));
                    }
                    if(rec.Customer_Start_date__c!= oldRec.Customer_Start_date__c){
                        title = strScheduleChange;
                        Body = 'Customer Start Date :' + oldRec.Customer_Start_date__c+ strTo + rec.Customer_Start_date__c;
                        Body += strBy + userInfo.getUserName();
                        listNotes.add(returnNoteObject(rec.id,title,Body));
                    }
                    if(rec.Account_team_arrival_date__c!= oldRec.Account_team_arrival_date__c){
                        title = strScheduleChange;
                        Body = 'Account Team Arrival Date :' + oldRec.Account_team_arrival_date__c+ strTo + rec.Account_team_arrival_date__c;
                        Body += strBy + userInfo.getUserName();
                        listNotes.add(returnNoteObject(rec.id,title,Body));
                    }     
                }
        }
        }
        try{
            if(CPOC_Lab_Request__c.getorgdefaults().CPOC_Data_Migration_Flag__c == 'TRUE')
            {
                if(!lstSendEmailRecords.isEmpty() ){
                    //Database.Insert(lstSendEmailRecords);
                }
                if(!listNotes.isEmpty())
                    Database.Insert(listNotes);
            }
        }
        catch(Exception e){
            System.debug('Exception caught: ' + e.getMessage());    
        }      
    }
    static public void recallonLabRedirect(Map<id,sObject> oldMap, Map<Id,sObject> newMap)
    { 
        if(recallflag){
         for(sObject eachRec : newMap.Values()){
                CEE__c rec = (CEE__c)eachRec ;
                CEE__c oldRec = (CEE__c)oldMap.get(rec.id);
                
                if(rec.RecordTypeId == ObjectRecordTypeIds__c.getorgdefaults().CEE_CPOC_Record_Type_ID__c){
                    if(rec.preferred_lab__c != oldRec.preferred_lab__c && rec.Request_Status__c != 'Completed'){
                     Approval.ProcessWorkitemRequest req1 = new Approval.ProcessWorkitemRequest();
                        req1.setComments('Removing request');
                        req1.setAction('Removed');
                        Id retVal;
                        //Sudi - 19 Aug 2016 : Added the try catch block to catch all the exceptions.
                        try{
                            for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p
                                where p.ProcessInstance.TargetObjectId =: oldrec.id])
                            {
                                 retVal  =  workItem.Id;
                                 system.debug('WorkItemId' + retVal + workItem.id);
                            }
                            Id workItemId1 = retVal;
                            if(workItemId1 == null)
                            {    
                                system.debug('Id is null');
                            }
                            else
                            {
                                req1.setWorkitemId(workItemId1);
                                Approval.ProcessResult result1 =  Approval.process(req1);                                
                            }
                            Approval.UnLockResult lrList = Approval.unlock(rec, false);
                            if (lrList.isSuccess()) {
                            // Operation was successful, so get the ID of the record that was processed
                            System.debug('Successfully unlocked CEE Request with ID: ' + lrList.getId());
                            } 
                        }
                        catch(Exception e){
                            System.debug('Exception caught: ' + e.getMessage());    
                        }       
                    }
                }
                }
                recallflag = false;
           }
    }
    private Note returnNoteObject(Id parentId,string title, string body){
        Note n = new Note();
        //SCAVA FIX
               if(flsGet(Note.parentId))
                {
                n.parentId = parentId;
                }
        //SCAVA FIX
                if(flsGet(Note.Title))
                {
                n.Title = title;
                }
        //SCAVA FIX
                if(flsGet(Note.Body))
                {
                n.Body = body;
                }
        return n;
    }
}