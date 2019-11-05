/**
  @ Author       : Raj,Mukesh and Simon
  @ Name         : JabberPhoneController
  @ Created Date : 10/3/2013
  @ Description  : This is the controller class for JabberMainPage and SelfDiagnosticTool pages. 
                   It contains methods and wrapper class to capture call logs and 
                   display all exisitng call logs in jabber phone UI
  */

/**
  *---------------Revision------------------
  * Version 1.0  : Pilot Release
  * BY           : Arif,Raj,Mukesh and Simon
  * Version 1.1  : Handled multi line call logs 
  * BY           : Raj,Mukesh and Simon
  * Version 1.2  : Handled redial and 'search to call' features
  * BY           : Raj,Mukesh and Simon
  */
global class JabberPhoneController
{
    public Task l1Task = new Task();
    public Task l2Task  = new Task();
    public Task oldTask  = new Task();
    public list<jabberCallWrapper> lstLastCall{get;set;}
    public map<string,Task> mapExisitngTasks = new map<string,Task>();
    User currentRunningUser = new User();

    public boolean isClickToCall {get;set;}
    public string strObject {get;set;}
    public string strRecordId {get;set;}
    public string strParentRecordId {get;set;}
    public string strL1StartTimeInMS {get;set;}
    public string strL2StartTimeInMS {get;set;}
    public string strCurrentTimeInMS {get;set;}
    
   
    public string strCallLine {get; set;}
    public string strCallType {get;set;}
    public string strPhoneNumber {get;set;}
    public string strCallerId {get;set;}
    
    public string strTaskId {get; set;}
    public string strMode {get; set;}
    public string strL1TaskId {get; set;}
    public string strL2TaskId {get; set;}
    public string strDuration {get; set;}
    public string strStatusMessage {get; set;}
    public boolean showExistingLog {get; set;}
    public string strServerAddr {get; set;}
    
    public string strHostName {get; set;}
    
    /**
      * get theater from running user profile to populate task theater when call log is captured
      * @name : JabberPhoneController
      */
    public JabberPhoneController()
    {
    	currentRunningUser = [Select Theatre__c from user where id = :UserInfo.getUserId()];
    	strHostName = System.URL.getSalesforceBaseURL().toExternalForm();
        showExistingLog = false;
        isClickToCall = false;
        lstLastCall = new list<jabberCallWrapper>();
        strCurrentTimeInMS = string.valueOf(DateTime.Now().getTime());
        // get all exisitng call logs associated for the current running user
        queryLogList();
    }
    
    /**
      * Search customer details in both account and contact object and maintain query result in jason string 
      * @name                : lookupCustomerInfo
      * @param strSearchText : search string to lokup customer details
      * @param strSearchType : type of search. Values are 'By Phone' or 'By Name'
      * @return              : search results contains Id,Name,Phone and Jabber Phone Number in json format.
      */
    @RemoteAction
    webservice static string lookupCustomerInfo(string strSearchText, string strSearchType)
    {
        if(strSearchType == 'By Name') 
        {
            strSearchText += '%';
        }
        else if(strSearchType == 'By Phone' && strSearchText.startsWith('+'))
        {
            strSearchText = strSearchText.replaceAll('\\+','');
            strSearchText = strSearchText + '%';
        }
        else if(strSearchType == 'By Phone')
        {
            strSearchText = strSearchText.replaceAll('\\+','');
            strSearchText = '%' + strSearchText + '%';
        }
        return JabberPhoneUtils.searchCustomerInfo(strSearchText, strSearchType);
    }
    /** 
      * Update CUCM server details based on the user request from self diagnostic tool. 
      * @name : updateCUCMServer
      */
    public void updateCUCMServer()
    {
        strStatusMessage = 'true'; // response of the update operation will be used in VF page.
        try
        {
            User runningUser = new User( id=userinfo.getUserId(), CUCMServer__c=strServerAddr);
            update runningUser;
        }
        catch (exception e)
        {
            strStatusMessage = 'false' ;
        }
    }
    
    /** 
      * Getter method to bind task fields in line 1  section
      * @name : getTask1
      */
    public Task getTask1()
    {
        return l1Task;
    }
    /** 
      * Getter method to bind task fields in line 2 section
      * @name : getTask2
      */
    public Task getTask2()
    {
        return l2Task;
    }
    /**
      * Set click to call information to the call log
      * @name  : poplateTaskFields
      * @param taskRec : object reference of the call log.
      */
    public  void poplateTaskFields(Task taskRec)
    {
        taskRec.WhatId = null;
        taskRec.WhoId = null;
        if(isClickToCall && (strObject == 'Contact' || strObject == 'Lead'))
        {
            taskRec.WhoId = strRecordId;
            if(strParentRecordId != null && strParentRecordId != '' && strParentRecordId != 'null' && strParentRecordId != strRecordId)
            {
                taskRec.WhatId = strParentRecordId;
            }
        }
        else if (isClickToCall && (strObject == 'Account' || strObject == 'Opportunity'))
        {
            taskRec.WhatId = strRecordId;
        }
        else if(isClickToCall && strObject == 'Case')
        {
            taskRec.WhatId = strRecordId;
            case caseRec = [select Id, CaseNumber,ContactId, Contact.Account.CRCountry__c from case where Id =: strRecordId];
            if(caseRec.ContactId != null)
            {
                taskRec.WhoId = caseRec.ContactId;
            }
        }
        else if(isClickToCall && strObject == 'Jabber')
        {
            if(strRecordId != null && strRecordId != '' && strRecordId != 'null')
            {
                taskRec.WhatId = strRecordId;
            }
            if(strParentRecordId != null && strParentRecordId != '' && strParentRecordId != 'null')
            {
                taskRec.WhoId = strParentRecordId; 
            }
        }
    }
    /**
      * create new call log whenever call get initiated from jabber phone
      * @name  : createNewTask
      */
    public  void createNewTask ()
    {
        Task newTask = new Task();
        newTask.Jabber_Call_End_Date_Time__c = null;
        newTask.Jabber_Call_Start_Date_Time__c = DateTime.Now();
        newTask.ActivityDate = date.today();
        newTask.Subject = 'Call '+ DateTime.Now().formatLong();
        newTask.Status = 'In Progress';
        newTask.Type = 'Call';
        newTask.CallObject = 'Jabber Call';
        newTask.Call_Results__c = 'Unsaved';
        newTask.Jabber_Call_Duration_ms__c = 0;
        newTask.CallDurationInSeconds = 0;
        newTask.CallType = convertCallType(strCallType);
        
        newTask.Theater__c = currentRunningUser.Theatre__c;
        newTask.Category_Type__c = newTask.CallType + ' Calls';
        
        newTask.Call_Type__c = strCallType;
        newTask.Caller__c = UserInfo.getName();
        newTask.Phone_Number__c = strPhoneNumber;
        poplateTaskFields(newTask);

        insert newTask;
        strCurrentTimeInMS = string.valueOf(DateTime.Now().getTime());

        if(strCallLine == 'L1')
        {
            strL1StartTimeInMS = string.valueOf(newTask.Jabber_Call_Start_Date_Time__c.getTime());
            l1Task = new Task();
            l1Task = newTask.clone(true,true,true,true);
            
        }
        else
        {
            strL2StartTimeInMS = string.valueOf(newTask.Jabber_Call_Start_Date_Time__c.getTime());
            // reset exisitng Task records
            l2Task = new Task();
            l2Task = newTask.clone(true,true,true,true);
        }
        queryLogList();
    }
    /**
      * find the equalent call type of jabber phone to set the salesforce standard field
      * @name  : convertCallType
      * @param strJabberCallType : Jabber Phone call type
      * @return : equalent value of salesforce call type
      */
    public string convertCallType(string strJabberCallType)
    {
        if(strJabberCallType == 'Incoming')
        {
            return 'Inbound';
        }
        else if(strJabberCallType == 'Outgoing')
        {
            return 'Outbound';
        }
        else
        {
            return null;
        } 
    }
    /**
      * update/save the call log details whenever user ends the call or clicks save/cancel button.
      * @name  : updateTask
      */
    public void updateTask()
    {
        Task existingTask;
    	// identify the task object based call line info
        if(strTaskId != '' && strTaskId != null && strTaskId != 'null' && string.valueof(l1Task.Id) == strTaskId)
        {
            existingTask = l1Task;
        }
        else if(strTaskId != '' && strTaskId != null && strTaskId != 'null' && string.valueof(l2Task.Id) == strTaskId)
        {
            existingTask = l2Task;
        }
        else if(strCallLine == 'L1')
        {
            existingTask = l1Task;
        }
        else if(strCallLine == 'L2')
        {
            existingTask = l2Task;
        }
        
        if(existingTask == null || existingTask.id == null)
        {
            system.debug('*** Task not found');
            return;
        }
        else if(existingTask.Jabber_Call_Start_Date_Time__c == null)
        {
        	existingTask.Jabber_Call_Start_Date_Time__c = DateTime.Now();
        }
        existingTask.Status = 'Completed';

        if(strMode == 'Save')
        {
        	// If jabber phone is failed to calculate duration, set the timestamp to jabber phone fields
            if(existingTask.Jabber_Call_End_Date_Time__c == null || existingTask.Duration__c == null || existingTask.Duration__c == '')
            {
                existingTask.Jabber_Call_End_Date_Time__c  = DateTime.Now();
                long durationInMilliSecs = DateTime.Now().getTime() - existingTask.Jabber_Call_Start_Date_Time__c.getTime();
                existingTask.CallDurationInSeconds  = Integer.valueOf(durationInMilliSecs/1000);
                existingTask.Jabber_Call_Duration_ms__c = durationInMilliSecs;
                // if vf page failed to set the duration, calculate duration once again and set back to the field.
                existingTask.Duration__c = getCallDuration(durationInMilliSecs);
            }
            existingTask.Call_Results__c = 'Saved';
        }
        else if(strMode == 'Refresh')
        {
            
        }
        // disposition the call log when user clicks cancel button
        else if(strMode == 'Cancel')
        {
            existingTask.Cancel__c = true;
            existingTask.Call_Results__c = 'Discarded';
            existingTask.WhatId = null;
            existingTask.WhoId = null;
        }
        else if(strMode == 'End Call')
        {
            JabberPhoneUtils.log('ending the call');
            existingTask.Jabber_Call_End_Date_Time__c  = DateTime.Now();

            long durationInMilliSecs = DateTime.Now().getTime() - existingTask.Jabber_Call_Start_Date_Time__c.getTime();
            existingTask.Jabber_Call_Duration_ms__c = durationInMilliSecs;
            existingTask.CallDurationInSeconds  = Integer.valueOf(durationInMilliSecs/1000);
            
            // if vf page failed to set the duration, calculate duration once again and set back to the field.
            if(existingTask.Duration__c == null || existingTask.Duration__c == '')
            {
                existingTask.Duration__c = getCallDuration(durationInMilliSecs);
            }
        }
        else if(strMode == 'Search Result Update')
        {
            poplateTaskFields(existingTask);
            
            // refer defect #4684, capture the duration and end time when call is ended while page is refreshing
            existingTask.Jabber_Call_End_Date_Time__c  = DateTime.Now();
            try
            {
                long durationInMilliSecs = DateTime.Now().getTime() - existingTask.Jabber_Call_Start_Date_Time__c.getTime();
                existingTask.Jabber_Call_Duration_ms__c = durationInMilliSecs;
                existingTask.CallDurationInSeconds  = Integer.valueOf(durationInMilliSecs/1000);
                
                // if vf page failed to set the duration, calculate duration once again and set back to the field.
                if(existingTask.Duration__c == null || existingTask.Duration__c == '')
                {
                    existingTask.Duration__c = getCallDuration(durationInMilliSecs);
                }
            }
            catch (exception e)
            {
                system.debug('exception while updating search result, '+ e);
            }
        }
        try
        {
            if(strMode == 'Delete')
            {
                JabberPhoneUtils.log('delete Task in '+ strCallLine);
                delete existingTask;
            }
            else
            {
                update existingTask;
            }
        }
        catch(exception e)
        {
            system.debug(e);
        }
        queryLogList();
    }
    /**
      * whenever page get refreshed, query the active call logs and display it in UI.
      * @name  : getActiveCallLog
      */
    public  void getActiveCallLog()
    {
        strCurrentTimeInMS = string.valueOf(DateTime.Now().getTime());
        set<String> setTaskIds = new set<String>();
        
        if(strL1TaskId != null && strL1TaskId != '')
        {
            setTaskIds.add(strL1TaskId);
        }
        if(strL2TaskId != null && strL2TaskId != '')
        {
            setTaskIds.add(strL2TaskId);
        }
        map<String, Task> mapTasks = new map<String, Task>([Select Id,Cancel__c,Status,LastModifiedDate,
            Call_Start_Time_Hidden__c,Caller__c,Caller_Id__c,Call_Results__c,CallType, Call_Type__c,Subject,
            Jabber_Call_End_Date_Time__c,Phone_Number__c,Jabber_Call_Start_Date_Time__c,Description,WhatId,CreatedById,
            WhoId,Duration__c,Marketing_Campaign__c,Theater__c 
            from Task where CreatedById =: UserInfo.getUserId() and Id IN: setTaskIds and Id != null]);
        system.debug('*** map size = '+ mapTasks.size());
        if(mapTasks.containsKey(strL1TaskId))
        {
            system.debug('*** ctrl in 1st if '+ strL1TaskId);
            l1Task = mapTasks.get(strL1TaskId);
            l1Task.Jabber_Call_End_Date_Time__c = null;
            strL1StartTimeInMS = string.valueOf(l1Task.Jabber_Call_Start_Date_Time__c.getTime());
            
        }
        if(mapTasks.containsKey(strL2TaskId))
        {
            system.debug('*** ctrl in 2st if '+ strL2TaskId);
            l2Task = mapTasks.get(strL2TaskId);
            l2Task.Jabber_Call_End_Date_Time__c = null;
            strL2StartTimeInMS = string.valueOf(l2Task.Jabber_Call_Start_Date_Time__c.getTime());
        }
    }
    /**
      * getter method to display all existing call logs in jabber phone UI
      * @name  : getRecentCallList
      * @return : list of exisitng call logs
      */
    public list<jabberCallWrapper> getRecentCallList()
    {
        return lstLastCall;
    }
    /**
      * generic method to query all exisitng call logs for the current running user.
      * @name  : queryLogList
      */
    public void queryLogList()
    {
        mapExisitngTasks.clear();
        lstLastCall = new list<jabberCallWrapper>();
        for(List<Task> lstBlueTasks : [Select Id,Phone_Number__c,WhatId,WhoId,LastModifiedDate,Duration__c,
            CreatedById,Status,CreatedDate,Jabber_Call_Start_Date_Time__c,Cancel__c,Description,Subject,
            Jabber_Call_End_Date_Time__c,Call_Results__c,CallType, Call_Type__c,Marketing_Campaign__c,Theater__c 
            from Task where CreatedById =: UserInfo.getUserId() and Cancel__c = false and Phone_Number__c != '' 
            and CallObject = 'Jabber Call' and (WhoId != null or WhatId != null)  Order By LastModifiedDate desc limit 3])
        {
            createLogList(lstBlueTasks, false);
            
        }
        for(List<Task> lstRedTasks : [Select Id,Phone_Number__c,WhatId,WhoId,LastModifiedDate,Duration__c,
            CreatedById,Status,CreatedDate,Jabber_Call_Start_Date_Time__c,Cancel__c,Description,Subject,
            Jabber_Call_End_Date_Time__c,Call_Results__c,CallType, Call_Type__c,Marketing_Campaign__c,Theater__c   
            from Task where CreatedById =: UserInfo.getUserId() and Cancel__c = false and Phone_Number__c != '' 
            and CallObject = 'Jabber Call' and WhatId = null and WhoId = null  Order By LastModifiedDate desc])
        {
            createLogList(lstRedTasks, true);
        }
    }
    /**
      * Prepare wrapper class object for each exisitng call logs to display it in recent call log section
      * @name  : createLogList
      * @param lstRecentTasks : list of existing call logs
      * @param isRed : call log link color to categorize the calls
      */
    public void createLogList(List<Task> lstRecentTasks, boolean isRed)
    {
        String hour,minute,second;
        for(Task callTask: lstRecentTasks)
        {
            mapExisitngTasks.put(callTask.Id, callTask);
            jabberCallWrapper jcWrapper = new jabberCallWrapper();
            jcWrapper.wrapperTask = callTask;
            if(callTask.Jabber_Call_Start_Date_Time__c.hour() < 10){
                hour = '0'+string.valueOf(callTask.Jabber_Call_Start_Date_Time__c.hour());
            }else{
                hour = string.valueOf(callTask.Jabber_Call_Start_Date_Time__c.hour());
            }
            if(callTask.Jabber_Call_Start_Date_Time__c.minute() < 10){
                minute = '0'+string.valueOf(callTask.Jabber_Call_Start_Date_Time__c.minute());
            }else{
                minute = string.valueOf(callTask.Jabber_Call_Start_Date_Time__c.minute());
            }
            if(callTask.Jabber_Call_Start_Date_Time__c.second() < 10){
                second = '0'+string.valueOf(callTask.Jabber_Call_Start_Date_Time__c.second());
            }else{
                second = string.valueOf(callTask.Jabber_Call_Start_Date_Time__c.second());
            }
            
            // set color to link
            if(isRed == true)
            {
                jcWrapper.strLinkColor = 'color:#FF0000;fontWeight=bolder';
                jcWrapper.strlinkText = callTask.Phone_Number__c;
            }
            else
            {
                jcWrapper.strLinkColor = 'color:#1797C0;fontWeight=bolder';
                jcWrapper.strlinkText = callTask.Phone_Number__c;
            }
            if(jcWrapper.strlinkText != null)
            {
                jcWrapper.strlinkText = jcWrapper.strlinkText.length() > 14? jcWrapper.strlinkText.substring(0,13):jcWrapper.strlinkText;
            }
            jcWrapper.strTimeStamp = string.valueOf(callTask.Jabber_Call_Start_Date_Time__c.month())+'/'+string.valueOf(callTask.Jabber_Call_Start_Date_Time__c.day())+
                '  '+hour+':'+minute+':'+second;
            
            jcWrapper.strPhoneNumber = callTask.CallType == 'Outbound'?callTask.Phone_Number__c: '+'+callTask.Phone_Number__c;
            jcWrapper.strRelatedTo = callTask.WhatId;
            jcWrapper.strName = callTask.WhoId;
            jcWrapper.strCallType = callTask.CallType;
            lstLastCall.add(jcWrapper);
         }
         // create blank row on recent call list
         if(isRed == false)
         {
            jabberCallWrapper jcWrapper = new jabberCallWrapper();
            lstLastCall.add(jcWrapper);
         }
    }
    /**
      * convert call log time to custom format
      * @name  : getCallDuration
      * @param elapsedTimeInMS : log time in milli seconds
      * @retrun : call log time in HH:MM:SS format
      */
    public string getCallDuration(long elapsedTimeInMS)
    {
            string strHr = getTimeFormat(elapsedTimeInMS, 'Hour');
            string strMin = getTimeFormat(elapsedTimeInMS, 'Minute');
            string strSec = getTimeFormat(elapsedTimeInMS, 'Sec');
            return strHr + ':' + strMin + ':' + strSec;
    }
    /**
      * extract hours, minutes and seconds from milliseconds
      * @name  : getTimeFormat
      * @param milliSecs : log time in milli seconds
      * @param formatType : specify the time section
      * @retrun : retrun the extracted part in string format
      */
    public string getTimeFormat(long milliSecs, string formatType)
    {
        long timeInSecs = milliSecs /1000;
        if(formatType == 'Hour')
        {
            long hour = ((timeInSecs / 60) / 60);
            return hour >= 10? string.valueof(hour) : '0'+ string.valueof(hour);
        }
        else if(formatType == 'Minute')
        {
            long minutes = math.mod((timeInSecs / 60),60);
            return minutes >= 10? string.valueof(minutes) : '0'+ string.valueof(minutes);
        }
        else if(formatType == 'Sec')
        {
            long secs = math.mod(timeInSecs, 60);
            return secs >= 10? string.valueof(secs) : '0'+ string.valueof(secs);
        }
        return '00';
    }
    /**
      * getter method to bind existing call log details in recent call log section
      * @name  : getExistingTask
      */
    public Task getExistingTask()
    {
        return oldTask;
    }
    /**
      * fetch user requested task
      * @name  : showOldTask
      */
    public void showOldTask()
    {
        showExistingLog = false;
        strStatusMessage = null;
        oldTask = new Task();
        string strExistingTaskId = apexpages.currentpage().getparameters().get('existingEventId');
        if(mapExisitngTasks.containsKey(strExistingTaskId))
        {
            oldTask = mapExisitngTasks.get(strExistingTaskId);
            showExistingLog = true;
        }
        else
        {
            strStatusMessage = 'no records found for Task id: '+ strExistingTaskId;
        }
    }
    /**
      * update recent changes to the database
      * @name  : updateExisitingTask
      */
    public void updateExisitingTask()
    {
        try
        {
            oldTask.Call_Results__c = 'Saved';
            update oldTask;
        }
        catch (Exception e)
        {
            strStatusMessage = e.getMessage();
        }
        showExistingLog = false;
        queryLogList();
    }
    /**
      * disposition the recent call log per user request
      * @name  : cancelExisitingTask
      */
    public void cancelExisitingTask()
    {
        try
        {
            oldTask.WhatId = null;
            oldTask.WhoId = null;
            oldTask.Cancel__c = true;
            oldTask.Call_Results__c = 'Discarded';
            update oldTask;
        }
        catch (Exception e)
        {
            strStatusMessage = e.getMessage();
        }
        showExistingLog = false;
        queryLogList();
    }
    /**
	  @ Author       : Raj,Mukesh and Simon
	  @ Name         : jabberCallWrapper
	  @ Created Date : 10/3/2013
	  @ Description  : This is the wrapper class for JabberPhoneController. 
	                   It contains custom variables or instances to store call logs informations 
	  */
    public class jabberCallWrapper{
        public Task wrapperTask{get;set;}
        public string strlinkText {get;set;}
        public string strTimeStamp{get;set;}
        public string strLinkColor {get;set;}
        // variables reserved for redial feature
        public string strPhoneNumber {get;set;}
        public string strRelatedTo {get;set;}
        public string strName {get;set;}
        public string strCallType {get;set;}
    }
    
    
}