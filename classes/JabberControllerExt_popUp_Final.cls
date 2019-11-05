/*********************************************************************************************************
   HISTORY
   Date                   Name                          Description
   --------            ----------                     -----------------
   2 Dec 2012         Brijesh/Arif                Controller for Jabber Integrated Page
***********************************************************************************************************/
public without sharing class JabberControllerExt_popUp_Final{
    public Event CallEvent;
    public Event Event{get;set;}
    public string phoneNumber{get;set;}
    public string phoneNumberExt{get;set;}
    public list<Event> eventOfCurrentCall{get;set;}
    public string duration{get;set;}
    public string statehidden{get;set;}
    public string startTimeHidden{get;set;}
    public string userName{get;set;}
    public string Password{get;set;}
    public string cucmServer{get;set;}
    public string Id{get;set;}
    public boolean callORnotcall{get;set;}
    public boolean saved{get;set;}
    public boolean discard{get;set;}
    public boolean isShowCurrentCallOPPanel{get;set;}
    public boolean saved1{get;set;}
    public boolean discard1{get;set;}
    public boolean input{get;set;}
    public boolean isSaveVisible{get;set;}
    public list<eventWrapper> lstLastCall{get;set;}
    public list<Event> lstEvent = new list<Event>();
    public Event EventToEdit{get;set;}
    public boolean isShowEdit{get;set;} 
    // boolean fields to controll the vaisibility of both 'Related To' and 'Name' lookups on even section
    public boolean isRelatedToVisible {get;set;}
    public boolean isNameLookupVisible {get;set;}
    public boolean isClickToCall {get;set;}
    public string strObject {get;set;}
    public string strRecordId {get;set;}
    public string strParentRecordId {get;set;}
    public string strStartTimeInMS {get;set;}
    public string strCurrentTimeInMS {get;set;}
    
    /* @Method <1.constructor of the controller
                2.used to assign default values to property
                3.also return latest three call made to the page>.
       @param <NA>
       @return <NA> - <NA>
       @throws exception - <NA>
    */
    public JabberControllerExt_popUp_Final(){
        system.debug('*** ctrl in constructor');
        // set defaule values to event section
        isRelatedToVisible = true; 
        isNameLookupVisible = true;
        isClickToCall = false;
        list<event> lstNonDispositionEvent = new list<event>();
        saved = false;
        isShowCurrentCallOPPanel = false;
        
        Event = new Event();
        discard = false;
        lstLastCall = new list<eventWrapper>();
        input = false;
        isSaveVisible = false;
        lstNonDispositionEvent = [Select Id,Phone_Number__c,WhatId,WhoId,LastModifiedDate,CreatedById,Status__c,
                    CreatedDate,StartDateTime,Cancel__c 
                    from event where CreatedById =: UserInfo.getUserId() and Cancel__c = false and Phone_Number__c != '' 
                    and WhatId = null and WhoId = null  and Caller_Id__c != '' Order By LastModifiedDate desc];
        lstEvent = [Select Id,Phone_Number__c,LastModifiedDate,CreatedById,Status__c,CreatedDate,StartDateTime,Cancel__c 
                    from event where CreatedById =: UserInfo.getUserId() and Cancel__c = false and Phone_Number__c != '' 
                    and (WhoId != null or WhatId != null)  and Caller_Id__c != '' Order By LastModifiedDate desc limit 3];
                    
        if(lstEvent.size()>0){
            createLogList(lstEvent, false);
        }
        if(lstNonDispositionEvent.size()>0){
            createLogList(lstNonDispositionEvent, true);
        }
        
        isShowEdit= false;
    }
    public  boolean hasErrorMessage{get;set;}
    public void getMessageStatus()
    {
        hasErrorMessage =  ApexPages.hasMessages();
    }
    public void createLogList(List<Event> lstEve, boolean isRed)
    {
        String hour,minute,second;
        for(Event event: lstEve)
        {
            eventWrapper eventWrapperVariable = new eventWrapper();
            eventWrapperVariable.eventWrapperVar = event;
            if(event.StartDateTime.hour() < 10){
                hour = '0'+string.valueOf(event.StartDateTime.hour());
            }else{
                hour = string.valueOf(event.StartDateTime.hour());
            }
            if(event.StartDateTime.minute() < 10){
                minute = '0'+string.valueOf(event.StartDateTime.minute());
            }else{
                minute = string.valueOf(event.StartDateTime.minute());
            }
            if(event.StartDateTime.second() < 10){
                second = '0'+string.valueOf(event.StartDateTime.second());
            }else{
                second = string.valueOf(event.StartDateTime.second());
            }
            
            // set color to link
            if(isRed == true)
            {
                eventWrapperVariable.strLinkColor = 'color:#FF0000;fontWeight=bolder';
            }
            else
            {
                eventWrapperVariable.strLinkColor = 'color:#1797C0;fontWeight=bolder';
            }
            eventWrapperVariable.phoneNoAndCallTime = string.valueOf(event.StartDateTime.month())+'/'+string.valueOf(event.StartDateTime.day())+
                                                          '  '+hour+':'+minute+':'+second;
            lstLastCall.add(eventWrapperVariable);
         }
    }
    /* @Method <1.method used to populate 'Related To' & 'Name' field
                when click to call is happening from contact or lead page.>
       @param <NA>
       @return <PageReference> - <null>
       @throws exception - <NA>
    */
    public void poplateEventFields()
    {
        system.debug('*** ctrl in poplateEventFields');
        system.debug('*** is Click 2 Call = '+ isClickToCall);
        Event.WhatId = null;
        Event.WhoId = null;
        if(isClickToCall && (strObject == 'Contact' || strObject == 'Lead'))
        {
            Event.WhoId = strRecordId;
            if(strParentRecordId != null && strParentRecordId != '' && strParentRecordId != 'null' && strParentRecordId != strRecordId)
            {
                Event.WhatId = strParentRecordId;
            }
        }
        else if (isClickToCall && (strObject == 'Account' || strObject == 'Opportunity'))
        {
            Event.WhatId = strRecordId;
        }
        system.debug('*** who id = '+ Event.WhoId);
        system.debug('*** what id = '+ Event.WhatId);
    }
    /* @Method <1.action method gets called when user will click on 'Call' button.
                2.create a event record>
       @param <NA>
       @return <PageReference> - <null>
       @throws exception - <NA>
    */
    public PageReference insertEvent(){
        CallEvent = new event();
        isSaveVisible = true;
        isShowCurrentCallOPPanel = true;
        saved = true;
        discard = true;
        input = false;
        Event.EndDateTime = null;
        Event.StartDateTime = System.Now();
        // populate lookups on event object based on local storage
        poplateEventFields();
        CallEvent.StartDateTime = System.Now();
        
        // Raj Apr/16 - Refactored Call Duration Calculations
        CallEvent.Call_Start_Time_Hidden__c = string.valueOf(CallEvent.StartDateTime.getTime());
        strStartTimeInMS = string.valueOf(CallEvent.StartDateTime.getTime());
        strCurrentTimeInMS = strStartTimeInMS;
        
        CallEvent.Subject = 'Call '+ System.Now().formatLong();
        CallEvent.Caller_Id__c = Event.Caller_Id__c;
        system.debug('Event Phone Number--->'+Event.Phone_Number__c);
        CallEvent.Phone_Number__c = Event.Phone_Number__c;
        CallEvent.WhatId = Event.WhatId;
        CallEvent.WhoId = Event.WhoId;
        CallEvent.DurationInMinutes = 0;
        CallEvent.ActivityDateTime = CallEvent.StartDateTime;
        Event.Call_Results__c = 'Unsaved';
        CallEvent.Call_Results__c = 'Unsaved';
        CallEvent.Call_Type__c = 'Outbound';
        CallEvent.Caller__c = UserInfo.getName();
        insert CallEvent;
        Event = CallEvent;
        Id = CallEvent.Id; 
        system.debug('Insert Event Id--->'+ CallEvent.Id);
        system.debug('Insert phone Number--->'+ CallEvent.Phone_Number__c);
        return null;
    }
    
    /* @Method <1.action method gets called when user clicks on 'Save' button of 'Current Call' section.
                2.update the event record with values of comments,related to etc, which has been created by 'insertEvent' action method.
                3.update the latest 3 calls by querying the value from event object.>
       @param <NA>
       @return <PageReference> - <null>
       @throws exception - <NA>
    */
    public PageReference updateEvent(){
        system.debug('*** ctrl in update event mtd');
        Event eventUpdate = new Event();
        isShowCurrentCallOPPanel = false;
        string hour,minute,second;
        list<event> lstNonDispositionEvent = new list<event>();
        lstEvent = new list<Event>();
        lstLastCall.clear();
        try
        {
        eventUpdate = [Select Id,EndDateTime,Caller__c,Caller_Id__c,Call_Results__c,Call_Type__c,Subject,
                       Phone_Number__c,StartDateTime,Comments__c,WhatId,WhoId,Duration__c 
                       from Event where Id =:Id];
        }
        catch(exception e)
        {
        	system.debug('*** trying to update duplicate event'+ e.getMessage());
        }
        eventUpdate.EndDateTime = Event.EndDateTime;
        eventUpdate.Subject = Event.Subject;
        eventUpdate.Comments__c = Event.Comments__c;
        //eventUpdate.Phone_Number__c = Event.Phone_Number__c;
        eventUpdate.Duration__c = Event.Duration__c;
        eventUpdate.WhatId = Event.WhatId;
        //eventUpdate.Status__c = 'Completed'; 
        eventUpdate.Call_Results__c = 'Saved';
        eventUpdate.WhoId = Event.WhoId;
        try
        {
        	update eventUpdate;
        }
        catch(exception e)
        {
        	system.debug('*** exception while updating an event: '+ e.getMessage());
        }
        Event = eventUpdate;
        lstNonDispositionEvent = [Select Id,Phone_Number__c,WhatId,WhoId,LastModifiedDate,CreatedById,Status__c,CreatedDate,StartDateTime,Cancel__c 
                    from event where CreatedById =: UserInfo.getUserId() and Cancel__c = false and Phone_Number__c != '' 
                    and WhatId = null and WhoId = null  and Caller_Id__c != '' Order By LastModifiedDate desc];
        lstEvent = [Select Id,Phone_Number__c,LastModifiedDate,CreatedById,Status__c,CreatedDate,StartDateTime,Cancel__c 
                    from event where CreatedById =: UserInfo.getUserId() and Cancel__c = false and Phone_Number__c != '' 
                    and (WhoId != null or WhatId != null)  and Caller_Id__c != '' Order By LastModifiedDate desc limit 3];
        if(lstEvent.size()>0){
            createLogList(lstEvent, false);
        }
        if(lstNonDispositionEvent.size()>0){
            createLogList(lstNonDispositionEvent, true);
        }
        // delete all duplicate events
        try{
            deleteDublicateEvents();
        }catch(exception e){
        }
        Event.Phone_Number__c = '';
        Event.EndDateTime = null;
        Event.Comments__c ='';
        Event.Duration__c='';
        Event.WhatId=null;
        Event.StartDateTime=null;
        Event.WhoId=null;
        Event.Subject = '';
        Event.Caller__c='';
        Event.Caller_Id__c='';
        Event.Call_Results__c='';
        Event.Call_Type__c='';
        duration = '';
        phoneNumber='';
        saved=true;
        discard=true;
        return null;
    }
    
    /* @Method <1.action method gets called when user clicks on 'End' button.
                2.update the event record with values of duration,phone number,call end time etc, which has been created by 'insertEvent' action method.
                3.update the latest 3 calls by querying the value from event object.>
       @param <NA>
       @return <PageReference> - <null>
       @throws exception - <NA>
    */
     public PageReference endButton(){
        Event eventUpdate = new Event();
        string hour,minute,second;
        list<event> lstNonDispositionEvent = new list<event>();
        lstEvent = new list<Event>();
        lstLastCall.clear();
        
        saved = false;
        discard = false;
        input = true;
        isSaveVisible = true;
        Event.EndDateTime = System.Now();
        
        try{
            eventUpdate = [Select Id,Cancel__c,Status__c,EndDateTime,Phone_Number__c,StartDateTime,Comments__c,WhatId,
                           Caller__c,Caller_Id__c,Call_Results__c,Call_Type__c,Subject,WhoId,Duration__c from Event where Id =:Id];
        }catch(exception e){
            system.debug('*** exception at end call method: '+ e.getMessage());
        }    
        
        eventUpdate.EndDateTime = Event.EndDateTime;
        //eventUpdate.Phone_Number__c= Event.Phone_Number__c;
        eventUpdate.WhoId= Event.WhoId;
        eventUpdate.WhatId= Event.WhatId;
        eventUpdate.Duration__c = Event.Duration__c;
        eventUpdate.Status__c = 'Completed';
        eventUpdate.Subject = Event.Subject;
        if(eventUpdate.id != null)
        {
        	try
        	{
            	update eventUpdate;
        	}
        	catch (exception e)
        	{
        		system.debug('*** exception while updating an event during end call: '+ e.getMessage());
        	}
            Event = eventUpdate;
        }
        else 
        {
            // user has ended a call before creating an event log OR
            // User has ended a call befor phone get ringing in other end
            system.debug('*** unable to update event as no id available');
        }
        
        system.debug('Update Event Id--->'+ eventUpdate.Id);
        system.debug('Update Event Phone Number--->'+eventUpdate.EndDateTime);
        lstNonDispositionEvent = [Select Id,Phone_Number__c,Caller__c,Caller_Id__c,Call_Results__c,Call_Type__c,Subject,
                    WhatId,WhoId,LastModifiedDate,CreatedById,Status__c,CreatedDate,StartDateTime,Cancel__c 
                    from event where CreatedById =: UserInfo.getUserId() and Cancel__c = false and Phone_Number__c != '' 
                    and WhatId = null and WhoId = null  and Caller_Id__c != '' Order By LastModifiedDate desc];
        lstEvent = [Select Id,Phone_Number__c,LastModifiedDate,CreatedById,Caller__c,Caller_Id__c,Call_Results__c,Call_Type__c,Subject,
                    Status__c,CreatedDate,StartDateTime,Cancel__c 
                    from event where CreatedById =: UserInfo.getUserId() and Cancel__c = false and Phone_Number__c != '' 
                    and (WhoId != null or WhatId != null) and Caller_Id__c != '' Order By LastModifiedDate desc limit 3];
        if(lstEvent.size()>0){
            createLogList(lstEvent, false);
        }
        if(lstNonDispositionEvent.size()>0){
            createLogList(lstNonDispositionEvent, true);
        }
        return null;
    }
    
    /* @Method <1.action method gets called when user clicks on 'Cancel' button of 'Current Call' section.
                2.update the event record such that values of related to,name field will became null,which has been created by 'insertEvent' action method.
                3.update the latest 3 calls by querying the value from event object.>
       @param <NA>
       @return <PageReference> - <null>
       @throws exception - <NA>
    */
    public PageReference delEvent(){
        system.debug('*** ctrl in del event mtd');
        lstEvent = new list<Event>();
        list<event> lstNonDispositionEvent = new list<event>();
        string hour,minute,second;
        lstLastCall.clear();
        input = true;
        isShowCurrentCallOPPanel = false;
        Event.StartDateTime = null;
        duration = '';
        phoneNumber = '';
        Event.EndDateTime = null;
        Event.Description  = '';
        Event.WhatId= null;
        Event.WhoId= null;
        Event.Phone_Number__c = '';
        Event.Duration__c ='';
        Event.Comments__c ='';
        Event.Caller__c='';
        Event.Caller_Id__c='';
        Event.Call_Results__c='';
        Event.Call_Type__c='';
        Event.Subject='';
        phoneNumber = '';
        Event eventDel = new Event();
        try
        {
        	eventDel = [Select Id,WhatId,Cancel__c from Event where Id =:Id];
        }
        catch(exception e)
        {
        	system.debug('*** trying to update duplicate event'+ e.getMessage());
        }
        eventDel.Cancel__c = true;
        eventDel.Call_Results__c = 'Discarded';
        eventDel.WhatId = null;
        eventDel.WhoId = null;
        try
        {
        	update eventDel;
        }
        catch (exception e)
        {
        	system.debug('*** exception while updating an event during cancel: '+ e.getMessage());
        }
        lstNonDispositionEvent = [Select Id,Phone_Number__c,WhatId,WhoId,LastModifiedDate,CreatedById,Status__c,CreatedDate,StartDateTime,Cancel__c 
                    from event where CreatedById =: UserInfo.getUserId() and Cancel__c = false and Phone_Number__c != '' 
                    and WhatId = null and WhoId = null  and Caller_Id__c != '' Order By LastModifiedDate desc];
        lstEvent = [Select Id,Phone_Number__c,LastModifiedDate,CreatedById,Status__c,CreatedDate,StartDateTime,Cancel__c 
                    from event where CreatedById =: UserInfo.getUserId() and Cancel__c = false and Phone_Number__c != '' 
                    and (WhoId != null or WhatId != null)  and Caller_Id__c != '' Order By LastModifiedDate desc limit 3];
        if(lstEvent.size()>0){
            createLogList(lstEvent, false);
        }
        if(lstNonDispositionEvent.size()>0){
            createLogList(lstNonDispositionEvent, true);
        }
        try{
            deleteDublicateEvents();
        }catch(exception e){
        }
        saved=true;
        discard=true;
        return null;
    }
    
    /* @Class <wrapper Class which contains -
               1. event Record.
               2. string which is combination of 'Phone Number' and 'Last Modified By'.
               3. used for displaying last 3 calls.
    */
    public class eventWrapper{
        public Event eventWrapperVar{get;set;}
        public string phoneNoAndCallTime{get;set;}
        public string strLinkColor {get;set;}
    }
    
    /* @Method <1.action method gets called when user clicks on any link of phone number+Last Modified by in 'Last 3 Call' section.>
       @param <NA>
       @return <PageReference> - <null>
       @throws exception - <NA>
    */
    public PageReference openEvent(){
       EventToEdit = new Event();
       system.debug('EventToEdit --------->'+EventToEdit );
       EventToEdit = [Select Id,Phone_Number__c,WhatId,WhoId,StartDateTime,EndDateTime,Comments__c,
                      Caller__c,Caller_Id__c,Call_Results__c,Call_Type__c,Subject,
                      Duration__c from event where Id =: apexpages.currentpage().getparameters().get('eventId')];
       system.debug('EventToEdit --------->'+EventToEdit );                
       isShowEdit = true;
       saved1 = false;
       discard1 = false;
       return null;
    }
    
    /* @Method <1.action method gets called when user clicks on 'Save' button of 'Last 3 Calls' section.
                2.update the event record with changes in the values of any field, which has been opened by 'openEvent' action method.>
       @param <NA>
       @return <PageReference> - <null>
       @throws exception - <NA>
    */
    public PageReference updateOpenedEvent(){
        Event eventOpened = new Event();
        lstEvent = new list<Event>();
        list<event> lstNonDispositionEvent = new list<event>();
         
        eventOpened = [Select Id,EndDateTime,StartDateTime,Description,WhatId,WhoId,Duration__c,
                        Caller__c,Caller_Id__c,Call_Results__c,Call_Type__c,Subject
                       from Event where Id =:EventToEdit.Id];
        eventOpened.Comments__c = EventToEdit.Comments__c;
        eventOpened.Subject = EventToEdit.Subject;
        eventOpened.WhatId = EventToEdit.WhatId;
        eventOpened.WhoId = EventToEdit.WhoId;
        eventOpened.Call_Results__c = 'Saved';
        try
        {
        	update eventOpened;
        }
        catch (exception e)
        {
        	system.debug('*** exception while updating an existing event: '+ e.getMessage());
        }
        
        lstLastCall.clear();
        lstNonDispositionEvent = [Select Id,Phone_Number__c,WhatId,WhoId,LastModifiedDate,CreatedById,Status__c,CreatedDate,StartDateTime,Cancel__c 
                    from event where CreatedById =: UserInfo.getUserId() and Cancel__c = false and Phone_Number__c != '' 
                    and WhatId = null and WhoId = null  and Caller_Id__c != '' Order By LastModifiedDate desc];
        lstEvent = [Select Id,Phone_Number__c,LastModifiedDate,CreatedById,Status__c,CreatedDate,StartDateTime,Cancel__c 
                    from event where CreatedById =: UserInfo.getUserId() and Cancel__c = false and Phone_Number__c != '' 
                    and (WhoId != null or WhatId != null)  and Caller_Id__c != '' Order By LastModifiedDate desc limit 3];
                    
        if(lstEvent.size()>0){
            createLogList(lstEvent, false);
        }
        if(lstNonDispositionEvent.size()>0){
            createLogList(lstNonDispositionEvent, true);
        }
        isShowEdit = false;
        saved1 = true;
        discard1 = true;
        return null;
    }
    
    /* @Method <1.action method gets called when user clicks on 'Cancel' button of 'Last 3 Calls' section.
                2.update the event record such that values of related to,name field will became null,which has been opened by 'openEvent' action method.
                3.update the latest 3 calls by querying the value from event object.>
       @param <NA>
       @return <PageReference> - <null>
       @throws exception - <NA>
    */
    public PageReference delOpenedEvent(){
        Event eventOpenedDel = new Event();
        list<event> lstNonDispositionEvent = new list<event>();
        string hour,minute,second;
        lstEvent = new list<Event>();
        eventOpenedDel = [Select Id,WhatId,Cancel__c,Caller__c,Caller_Id__c,Call_Results__c,Call_Type__c,Subject,WhoId from Event where Id =:EventToEdit.Id];
        eventOpenedDel.WhatId = null;
        eventOpenedDel.WhoId = null;
        eventOpenedDel.Cancel__c = true;
        eventOpenedDel.Call_Results__c = 'Discarded';
        //delete eventOpenedDel;
        try
        {
        	update eventOpenedDel;
        }
        catch (exception e)
        {
        	system.debug('*** exception while canceling an exisitng event: '+ e.getMessage());
        }
        lstLastCall.clear();
        lstNonDispositionEvent = [Select Id,Phone_Number__c,WhatId,WhoId,LastModifiedDate,CreatedById,Status__c,CreatedDate,StartDateTime,Cancel__c 
                    from event where CreatedById =: UserInfo.getUserId() and Cancel__c = false and Phone_Number__c != '' 
                    and WhatId = null and WhoId = null  and Caller_Id__c != '' Order By LastModifiedDate desc];
        lstEvent = [Select Id,Phone_Number__c,LastModifiedDate,CreatedById,Status__c,CreatedDate,StartDateTime,Cancel__c 
                    from event where CreatedById =: UserInfo.getUserId() and Cancel__c = false and Phone_Number__c != '' 
                    and (WhoId != null or WhatId != null)  and Caller_Id__c != '' Order By LastModifiedDate desc limit 3];
        if(lstEvent.size()>0){
            createLogList(lstEvent, false);
        }
        if(lstNonDispositionEvent.size()>0){
            createLogList(lstNonDispositionEvent, true);
        }

        EventToEdit.WhatId = null;
        EventToEdit.WhoId = null;
        isShowEdit = false;
        saved1 = true;
        discard1 = true;
        return null;
    }
    
    /* @Method <1.action method used to get called if there is any
                current call inprogress.>
       @param <NA>
       @return <PageReference> - <null>
       @throws exception - <NA>
    */
     public PageReference getCurrentCall(){
         //isShowCurrentCallOPPanel = true;
        eventOfCurrentCall = new list<Event>();
       /* eventOfCurrentCall = [Select Id,Cancel__c,Status__c,Call_Start_Time_Hidden__c,Caller__c,Caller_Id__c,Call_Results__c,Call_Type__c,Subject,
                              EndDateTime,Phone_Number__c,StartDateTime,Comments__c,WhatId,
                              WhoId,Duration__c from Event where Id=:Id and Status__c = 'In progress'];*/
        
        eventOfCurrentCall = [Select Id,Cancel__c,Status__c,LastModifiedDate,Call_Start_Time_Hidden__c,Caller__c,Caller_Id__c,Call_Results__c,Call_Type__c,Subject,
                              EndDateTime,Phone_Number__c,StartDateTime,Comments__c,WhatId,CreatedById,
                              WhoId,Duration__c from Event where CreatedById =: UserInfo.getUserId() and Phone_Number__c != '' 
                              and Status__c = 'In progress' and Caller__c != '' and Caller_Id__c != '' Order By LastModifiedDate desc limit 1];
        if(eventOfCurrentCall.size()>0){
            system.debug('****'+ eventOfCurrentCall.size());
            isShowCurrentCallOPPanel = true;
            Event = eventOfCurrentCall[0];
            Event.Phone_Number__c = eventOfCurrentCall[0].Phone_Number__c;
            Event.WhatId = eventOfCurrentCall[0].WhatId;
            Event.WhoId = eventOfCurrentCall[0].WhoId;
            Event.StartDateTime = eventOfCurrentCall[0].StartDateTime;
            
            // Raj Apr/16 Refactored Call Duration Calculations
            Event.Call_Start_Time_Hidden__c = eventOfCurrentCall[0].Call_Start_Time_Hidden__c;
            strStartTimeInMS = string.valueOf(Event.StartDateTime.getTime());
            strCurrentTimeInMS = string.valueOf(DateTime.Now().getTime());
            
            Event.EndDateTime = null;
            Event.Comments__c = eventOfCurrentCall[0].Comments__c;
            
            // populate lookups on envent object based on local storage 
            poplateEventFields();
            
            isSaveVisible = true;
            saved = true;
            discard = true;
            Id = eventOfCurrentCall[0].Id;
        }
        return null;
    }
    public void deleteDublicateEvents(){
        list<Event> lstEventToBeDeleted = new list<Event>();
        lstEventToBeDeleted = [Select Id,Cancel__c,Status__c,LastModifiedDate,Call_Start_Time_Hidden__c,Caller__c,Caller_Id__c,Call_Results__c,Call_Type__c,Subject,
                              EndDateTime,Phone_Number__c,StartDateTime,Comments__c,WhatId,CreatedById,
                              WhoId,Duration__c from Event where CreatedById =: UserInfo.getUserId() and Phone_Number__c = '' 
                              and Caller__c != '' and Caller_Id__c != '']; 
        if(lstEventToBeDeleted.size()>0){
            delete lstEventToBeDeleted;
        }
    }   
}