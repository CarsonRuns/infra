/***************************************************************************************************
Name    : CEE_AttendeeController 
Author  : Eric Pesch
Purpose : Visualforce Controller for custom CEE Attendee Edit page
Created Date: Dec 1 2014
Modification History: 
Eric Pesch - Jan 5 2015: Added Comments, cleanup 
Eric Pesch - Feb 25 2015: Defect - Agenda Item not being updated for old CEE Attendees/Invites 
Sudi       - Dec 17 2015: US9237 - Added new code for adding name and title from cisco corporate directory  
Aditya S   - June 6 2017 : implemented code for shadow program
*****************************************************************************************************/

public class CEE_AttendeeController {
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
    
    //Record and controller variables
    @TestVisible private CEE_Attendee__c attendee;
    private final ApexPages.StandardController controller;
    private final String TAG = 'CEE_AttendeeController - ';
   
    
   
 
    //Briefing Lookup for display
    public CEE_Invite__c oldInvite { get; set; }
    public String pageDisplay { get; set; }
    public String pageUrl { get; set; }
    public Boolean isNew { get; set; }
    
    
    //Salesforce User variables
    public User userLookup { get; set; }
    private String oldUser { get; set; }
    public String attendeeName { get; set; }
    
    //Agenda Item variables
    public String selAgenda { get; set; }
    private String agendaField;
    
    //Exception checks
    private Boolean isUserDifferent;
    private String oldAttendeeType;
    
    //Booleans for various rendering flags
    public Boolean userAvailable { get; set; }
    public Boolean userNotAvailable { get; set; }
    public Boolean isPresenter { get; set; }
    public boolean enableShadow {get;set;}
    
    private Id shadowPresenterRecordId;
    public String calendarLink;
    
    /*@method: Save New behavior method*/
    public PageReference doSaveNew(){
        return doSave(true);
    }
    /*@method: Save behavior method*/
    public PageReference doSave(){      
        return doSave(false);
    }
    public PageReference doCancel()
    {
        
        return new PageReference(calendarLink);
         
    }
    
    
    
            /* **********************************************************
           Added By Naresh (nkalahas@cisco.com) on 31/01/2018  to redirect to previous page on cancel
       ************************************************************  */          

       public PageReference doCancel_Light() {
               CEE_Attendee__c attendeeSave = (CEE_Attendee__c)controller.getRecord();
        String url = ApexPages.currentPage().getHeaders().get('Referer');

        
        PageReference pageRef = new PageReference('/' + attendeeSave.Customer_Engagement_Events__c);
        pageRef.setRedirect(true);
        return pageRef; 


        }  
    
    /*@method: Generic Save method*/    
    public PageReference doSave(boolean isSaveNew){     
        CEE_Attendee__c attendeeSave = (CEE_Attendee__c)controller.getRecord();        
        //Exception scenarios
        if(oldInvite != null && oldUser != null){ 
            
            //Check if User changed
            if(isUserDifferent){
                //Outlook exception scenario
                if(oldInvite.Outlook_Invite_ID__c != null){
                    if(oldInvite.Outlook_Invite_ID__c.length() > 10){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, System.label.CEE_Attendee_User_Exception));
                        return null;
                    }
                }
            }
            
            //Check if Type changed
            if(attendeeSave.Type__c != oldAttendeeType){
                if(attendeeSave.Type__c != 'Presenter'){
                    if(oldInvite.Outlook_Invite_ID__c != null){
                        if(oldInvite.Outlook_Invite_ID__c.length() > 10){
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, System.label.CEE_Attendee_Type_Exception));
                            return null;
                        }
                    }
                }
            }
        }
        
        //Manual variable grabs
        if(!userNotAvailable && attendee.Salesforce_User__c != null){
            if(userLookup == null){
                popUser();
            }
            if(flsGet(CEE_Attendee__c.Name)) {
            attendeeSave.Name = userLookup.Name;
            }
            if(flsGet(CEE_Attendee__c.Email__c)) {
            attendeeSave.Email__c = userLookup.Email;
            }
            if(flsGet(CEE_Attendee__c.Title__c)||(flsUpdateGet(CEE_Attendee__c.Title__c))) {
            attendeeSave.Title__c = userLookup.Title;
            }
        } else if (!userNotAvailable){
            if(flsGet(CEE_Attendee__c.Name)||(flsUpdateGet(CEE_Attendee__c.Name))) {
            attendeeSave.Name = null;
            }
            if(flsGet(CEE_Attendee__c.Email__c)||(flsUpdateGet(CEE_Attendee__c.Email__c))) {
            attendeeSave.Email__c = null;
            }
            if(flsGet(CEE_Attendee__c.Title__c)||(flsUpdateGet(CEE_Attendee__c.Title__c))){
            attendeeSave.Title__c = null;
            }
        }             
        if(!String.isEmpty(selAgenda)){
            if(flsGet(CEE_Attendee__c.Agenda_Item__c)||(flsUpdateGet(CEE_Attendee__c.Salesforce_User__c))){
            attendeeSave.Agenda_Item__c = selAgenda;
            }
        }
        if(flsGet(CEE_Attendee__c.Salesforce_User__c)||(flsUpdateGet(CEE_Attendee__c.Salesforce_User__c))) {
        attendeeSave.Salesforce_User__c = (userNotAvailable) ? null : attendeeSave.Salesforce_User__c;
        }
               
        //Save the attendee record
        try{
            
            //do not insert record if a presenter already has 'shadowLimit' number of shadowers
            if(attendeeSave.Type__c == 'Shadow')
            {
                if(isShadowLimitExceeded(attendeeSave))
                {
                    return null;
                }
                    
            }
            
            list<id> lstUpdateTitle = new list<Id>();
            if(attendeeSave.Id == null){        
                insert attendeeSave;            
                lstUpdateTitle.add(attendeeSave.id);                
                CEE_Utility.updateTitleName(lstUpdateTitle);
            } else {
                lstUpdateTitle.add(attendeeSave.id);                                
                CEE_Utility.updateTitleName(lstUpdateTitle);
                update attendeeSave;               
            }
            
        } catch(Exception e){
            System.debug(e.getStackTraceString());
            ApexPages.addMessages(e);
            return null;
        }
        
        //Save the CEE Invite record (if related to an Agenda_Item)
        //ONLY add invite if it's a Presenter, can't invite non-presenters
        if(attendeeSave.Agenda_Item__c != null && attendeeSave.Type__c == 'Presenter'){
            Agenda_Item__c agendaDetail = null;
            try{
                agendaDetail = [select Id, Customer_Engagements_Events__c, Start_Date_Time__c, End_Date_Time__c from Agenda_Item__c where
                                    Id =: attendeeSave.Agenda_Item__c];
            } catch (Exception e){
                System.debug(TAG + e.getStackTraceString());
            }
            
            //FIX epesch 2/25/2015 - old invites not handling correctly
            if(oldInvite == null){
                oldInvite = new CEE_Invite__c();
                // SCAVA Fix
                if(flsGet(CEE_Invite__c.CEE_Attendee__c)||(flsUpdateGet(CEE_Invite__c.CEE_Attendee__c))){
                oldInvite.CEE_Attendee__c = attendeeSave.Id;
                }
                if(flsGet(CEE_Invite__c.Outlook_Status__c)||(flsUpdateGet(CEE_Invite__c.Outlook_Status__c))) {
                oldInvite.Outlook_Status__c = 'Not Invited';
                }
                if(flsGet(CEE_Invite__c.Outlook_Invite_ID__c)||(flsUpdateGet(CEE_Invite__c.Outlook_Invite_ID__c))) {
                oldInvite.Outlook_Invite_ID__c = 'null';
                }
                if(flsGet(CEE_Invite__c.Start_Date_Time__c)||(flsUpdateGet(CEE_Invite__c.Start_Date_Time__c))){
                oldInvite.Start_Date_Time__c = agendaDetail.Start_Date_Time__c;
                }
                if(flsGet(CEE_Invite__c.End_Date_Time__c)||(flsUpdateGet(CEE_Invite__c.End_Date_Time__c))){
                oldInvite.End_Date_Time__c = agendaDetail.End_Date_Time__c;
                }
            } else {
                if(flsGet(CEE_Invite__c.Outlook_Status__c)) {
                oldInvite.Outlook_Status__c = 'Invite Changed, Send/Resend';
                }
            }
            if(flsGet(CEE_Invite__c.Agenda_Item__c)||(flsUpdateGet(CEE_Invite__c.Agenda_Item__c))){
            oldInvite.Agenda_Item__c = attendeeSave.Agenda_Item__c;
            }
            
            try{
                if(oldInvite.Id == null){
                    insert oldInvite;
                } else {
                    update oldInvite;
                }
            } catch(Exception e){
                System.debug(e.getStackTraceSTring());
                attendeeSave.addError(e.getMessage());
            }
        //Delete old Invites if changing Presenter Types
        } else if(oldInvite != null && attendeeSave.Type__c != 'Presenter'){
            try{
            //SCAVA FIX
            if (CEE_Invite__c.sObjectType.getDescribe().isDeletable())
               {
                delete oldInvite;
               }
                
            } catch(Exception e){
                System.debug(e.getStackTraceSTring());
                attendeeSave.addError(e.getMessage());
            }
        }
        
        //Save-New behavior
        if(isSaveNew){
          //  String editID = '/' + ('' + attendeeSave.get('Id')).subString(0, 3) + '/e?';
          // SCAVA FIX
            String editID =  ('' + attendeeSave.get('Id')).subString(0, 3) + '/e?';
            
            //Grab lookup field prefix            
            String prefix = Utilities.getConstant_CS('CEE Field Prefix');
            
            Map<String, String> parameters = ApexPages.currentPage().getParameters();
            for(String key : parameters.keySet()){
                String value = parameters.get(key);
                if(key.contains(prefix)){             
                    editId += key + '=' + EncodingUtil.urlEncode(value,'UTF-8') + '&';
                } else if (key.equals('retURL')) {
                    editId += key + '=' + EncodingUtil.urlEncode(value,'UTF-8') + '&';
                }
                System.debug(TAG + 'key/value - ' + key + ' / ' + value);
            }
            editId = editId.substring(0,editId.length()-1);       
            System.debug(TAG + 'final URL - ' + editId);  
             //return new PageReference(editId);
             //SCAVA FIX
            return new PageReference('/'+editId);
        }
        
        //Briefing return
        if(!String.isEmpty(ApexPages.currentPage().getParameters().get(agendaField))){
            return new PageReference('/'+ApexPages.currentPage().getParameters().get(agendaField));
        }
         if(enableShadow)
         {
            return new PageReference(calendarLink);
         }
        return new PageReference('/'+attendeeSave.Customer_Engagement_Events__c);
    }

    
    /*@Constructor: Constructor for the CEE Attendee controller*/
    public CEE_AttendeeController(ApexPages.StandardController stdController){
        List<String> popFields = new List<String>{'Id','Customer_Engagement_Events__c', 'Agenda_Item__c', 'Name', 'Email__c', 'Salesforce_User__c','Title__c', 'Type__c'};
        this.controller = stdController;
        if(!Test.isRunningTest()){
            this.controller.addFields(popFields);
        }
        this.attendee = (CEE_Attendee__c)stdController.getRecord();
        this.pageDisplay = 'New CEE Attendee';
        this.pageUrl = ApexPages.currentPage().getUrl();
      
        //Boolean initialization
        this.isUserDifferent = false;
        this.isPresenter = false;
        this.userNotAvailable = false;
        this.oldAttendeeType = attendee.Type__c;
        
        //Agenda Item value population (Agenda Item click-through)
        //Grab lookup field prefix  
        agendaField = Utilities.getConstant_CS('CEE Field Prefix') + Utilities.getConstant_CS('CEE Attendee Agenda Item');          
        System.debug(TAG + 'agenda field - ' + agendaField);
        
        if(!String.isEmpty(ApexPages.currentPage().getParameters().get(agendaField))){
            System.debug(TAG + 'agenda item creation');
            this.selAgenda = ApexPages.currentPage().getParameters().get(agendaField);
            
            //Grab briefing information
            Agenda_Item__c agenda = [select Id, Customer_Engagements_Events__c from Agenda_Item__c where Id =: this.selAgenda];
            if(agenda != null){
                this.attendee.Customer_Engagement_Events__c = agenda.Customer_Engagements_Events__c;
            }
        } else {
            System.debug(TAG + 'briefing creation');
        }
        
        //Old Attendee check
        if(this.attendee.Id == null)
            this.isNew = true;
        
        //Populate default variables
        if(this.attendee.Id != null){
            //User information
            if(attendee.Salesforce_User__c == null){
                userNotAvailable = true;
            } else {
                oldUser = attendee.Salesforce_User__c;
            }
            
            //Name information
            if(attendee.Name != null){
                attendeeName = attendee.Name;
                pageDisplay = attendee.Name;
            }
            
            //FIX epesch 2/25/2015 - Agenda Item information not populating on Editing old Attendee
            if(attendee.Agenda_Item__c != null){
                this.selAgenda = ((String)attendee.Agenda_Item__c).substring(0,15);
            }
            
            //Populate CEE Invite
            try{
                oldInvite = [select Id, Name, Outlook_Invite_ID__c, CEE_Attendee__c from CEE_Invite__c where CEE_Attendee__c =: this.attendee.Id ];
            } catch(Exception e){
                System.debug(TAG + 'No CEE Invite or error - creating new');
                System.debug(e.getStackTraceString());
            }
        }
        
        calendarLink = '/apex/ITCECalendar';
        enableShadow = checkShadowSelected();
        if(enableShadow)
        {
            shadowImplementation();
        }
    }
    
    /*@method: Check url parameters coming and determine whether to show shadow form or not*/
    public boolean checkShadowSelected()
    {
        boolean isShadower = checkIfShadower();
        boolean urlParametersPresent = ApexPages.currentPage().getParameters().get('presenter')!=null && ApexPages.currentPage().getParameters().get('type').equals('Shadow');
        if(urlParametersPresent && isShadower)
        {    
            System.debug(TAG+'Enable Shadow');
            return true;
        }
        else
        {
            return false;
        }
    }
    
    /*@method: autopopulate fields in the shadow form*/
    public void shadowImplementation()
    {
        attendee.Type__c = 'Shadow'; 
        attendee.Salesforce_User__c = UserInfo.getUserId();
        shadowPresenterRecordId = ApexPages.currentPage().getParameters().get('presenter');
        attendee.Presenter__c = shadowPresenterRecordId;
        
        try{
            CEE_Attendee__c shadowPresenterRecord = [Select Customer_Engagement_Events__c,Salesforce_User__c, Agenda_Item__c,Agenda_Item__r.Name from CEE_Attendee__c where Id = :shadowPresenterRecordId];
            this.selAgenda = ((String)shadowPresenterRecord.Agenda_Item__c).substring(0,15);
            attendee.Customer_Engagement_Events__c = shadowPresenterRecord.Customer_Engagement_Events__c;
            attendee.Agenda_Item__c =  shadowPresenterRecord.Agenda_Item__c;
            attendee.Presenter_User__c = shadowPresenterRecord.Salesforce_User__c;
        }
        catch(Exception e)
        {
            System.debug(e.getStackTraceString());
        }
    }
    
    /*@method: check if the logged in user has shadower permission*/  
    public boolean checkIfShadower()
    {
       return checkPermissions('CEE_Shadow');
       //return true;
    }
  
    /*@method: check if the logged in user has the permission mentioned in 'permission'*/  
    public boolean checkPermissions(String permission)
    {
       String userId = UserInfo.getUserId();
       boolean isPermissionAssigned = false;
       try 
       {
            List<PermissionSetAssignment> permissionSetList = [SELECT p.PermissionSet.Name FROM PermissionSetAssignment p WHERE p.PermissionSet.IsOwnedByProfile = false AND p.Assignee.Id = :userId ORDER BY  p.PermissionSetId];
            Set<String> ceePermissionSet = new Set<String>();
            ceePermissionSet.add(permission);
            for(PermissionSetAssignment r : permissionSetList)
            {
                for(String key : ceePermissionSet)
                {
                    if(key.equals(r.PermissionSet.Name))
                    {
                        isPermissionAssigned = true;
                        System.debug(TAG+'Logged In user is a Shadower');
                        break;
                    }
                }
            }
       }
       catch(Exception e)
       {
           System.debug(e.getStackTraceString());
       }
       return isPermissionAssigned;
    }

    /*@method: check if presenter has more than 'shadowLimit' number of shadowers*/ 
    public Boolean isShadowLimitExceeded(CEE_Attendee__c currentRecord)
    {
        
        //no of shadowers allowed per session
        Integer shadowLimit = 1;
        
        //no of shadowers allowed per month for a presenter
        Integer shadowMonthLimit = 5;
        
        if(currentRecord.Presenter__c==null)
        {
            System.debug(TAG+'Cannot Submit Shadow Request without adding Presenter');
            return true;
        }
        List<CEE_Attendee__c> shadowerList= [select Name,Email__c,Agenda_Item__r.Start_Date_Time__c from CEE_Attendee__c where Presenter__c=:currentRecord.Presenter__c and Shadow_Approval_Status__c!='Rejected'];
        List<CEE_Attendee__c> presenterDetails = [select Salesforce_User__r.Id from CEE_Attendee__c where Id=:currentRecord.Presenter__c];
        Id presenterId = presenterDetails[0].Salesforce_User__r.Id;
        if(isDuplicateShadowSession(shadowerList)==true)
        {
            return true;
        }
        
        AggregateResult month = [select CALENDAR_MONTH(Agenda_Item__r.Start_Date_Time__c) mnth from CEE_Attendee__c where Id=:currentRecord.Presenter__c GROUP BY CALENDAR_MONTH(Agenda_Item__r.Start_Date_Time__c)][0]; 
        Integer mnth = (Integer)(month.get('mnth'));
        Integer noOfShadowers = 0;
        List<CEE_Attendee__c> presenterSessions = [select (Select Name from CEE_Attendees__r where Shadow_Approval_Status__c!='Rejected') from CEE_Attendee__c where Salesforce_User__r.Id=:presenterId and Agenda_Item__r.Start_Date_Time__c>=TODAY and CALENDAR_MONTH(Agenda_Item__r.Start_Date_Time__c)=:mnth];
        
        //check if the presenter already has 'shadowLimit' number of shadowers in a month
        for(CEE_Attendee__c val:presenterSessions)
        {
            if(val.CEE_Attendees__r.size()>0)
            {
                noOfShadowers++;
            }
            if(noOfShadowers>=shadowMonthLimit)
            {
                System.debug(TAG+'Presenters Shadow Limit Exceeded for the month');
                ApexPages.Message shadowLimitErrMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Presenter is not available. Try Another Session');
                ApexPages.addMessage(shadowLimitErrMsg);
                return true;
            }
        }
        
        //check if the current session already has 'shadowLimit' number of shadowers
        if(shadowerList.size()>=shadowLimit)
        {
            System.debug(TAG+'Presenters Shadow Limit Exceeded for single session');
            ApexPages.Message shadowLimitErrMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Presenter is not available. Try Another Session');
            ApexPages.addMessage(shadowLimitErrMsg);
            return true;
        }
        return false;
    }
    
    /*@method: check if shadower is trying to submit a duplicate shadow session*/ 
    public Boolean isDuplicateShadowSession(List<CEE_Attendee__c> shadowerList)
    {
        String loggedInUserEmail = UserInfo.getUserEmail();
        for(CEE_Attendee__c val:shadowerList)
        {
            if(val.Email__c.equals(loggedInUserEmail))
            {
                System.debug(TAG+'Shadower trying to submit duplicate shadow session');
                ApexPages.Message shadowLimitErrMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You are already shadowing this session. Please Try Shadowing Another session');
                ApexPages.addMessage(shadowLimitErrMsg);
                return true;
            }
        }
        return false;
    }
    
    /*@method: Check type of attendee being added*/
    public void checkType(){
        isPresenter = false;
        if(attendee.Type__c == 'Presenter'){
            isPresenter = true;
            userNotAvailable = false;
        }
        if(attendee.Type__c == 'Shadow' && !enableShadow)
        {
          attendee.Type__c = null;
            
        }
    }
    
    /*@method: populate SFDC user details if possible*/
    public void popUser(){
        try{
            userLookup = [select Id, Name, Email, Title from User where Id =: attendee.Salesforce_User__c];
            attendeeName = userLookup.Name;
            
            //Validation for CEE Invite
            if(oldUser != userLookup.Id){
                isUserDifferent = true;
            }
        } catch(Exception e){
            System.debug(e.getStackTraceString());
            attendee.addError('Unable to lookup User on save');            
        }
    }
    
    /*@method: generate lists of related Agenda Items*/
    public List<SelectOption> getAgendaOptions(){
        List<SelectOption> options = new List<SelectOption>();
        try{
            List<Agenda_Item__c> agendas = [select Id, Name from Agenda_Item__c where Customer_Engagements_Events__c =: attendee.Customer_Engagement_Events__c];
            for(Agenda_Item__c agenda : agendas){
                System.debug(TAG + 'agenda item ID - ' + agenda.Id + ' - ' + ((String)agenda.Id).substring(0,15));
                options.add(new SelectOption(((String)agenda.Id).substring(0,15), agenda.Name));
            }
        } catch (Exception e){
            System.debug(TAG + 'Error retrieving Agenda Options - ' + e.getStackTraceString());
        }
        
        if(options.size() == 0){
            options.add(new SelectOption('', 'No related Agenda Items', true));
        } else {
            options.add(new SelectOption('','--None--', false));
        }
        
        options.sort();
        
        return options;
    }
    public void setAgendaOptions(){ }
    
}