/***************************************************************************************************
Name    : CEE_Add_Multi_Attendees 
Author  : Sudi
Purpose : Visualforce Controller for custom Add multi attendees
Created Date: Jan 10 2016
Modification History: 

*****************************************************************************************************/

public class CEE_Add_Multi_Attendees {  

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
    
    public string CEEId;
    public List<WrapperpaAttendeeList> waAccList {get;set;}
    public Integer rowToRemove {get;set;}
    public CEE_Add_Multi_Attendees(){
      CEEid = ApexPages.currentPage().getParameters().get('CEEId');
      if(waAccList == null){
          waAccList = new List<WrapperpaAttendeeList>();
          //Adding default row in initial page load
          waAccList = addNewRowToAttListdata(waAccList,CEEid);
      }
     }
     
    /*@method: Delete the row from UI*/ 
    public void removeRowFromAttList(){  
        waAccList = removeRowToAttList(rowToRemove, waAccList);     
    } 
    /*@method: Used to add the extra rows to list variable*/
    public static List<CEE_Add_Multi_Attendees.WrapperpaAttendeeList> addNewRowToAttListdata(List<CEE_Add_Multi_Attendees.WrapperpaAttendeeList> waAccObjList, string CEEID){       
        CEE_Add_Multi_Attendees.WrapperpaAttendeeList newRecord = new CEE_Add_Multi_Attendees.WrapperpaAttendeeList();              
        CEE_Attendee__c newAttRecord = new CEE_Attendee__c(); 
        // SCAVA Fix
        if(flsGet(CEE_Attendee__c.Customer_Engagement_Events__c)||flsUpdateGet(CEE_Attendee__c.Customer_Engagement_Events__c)){
        newAttRecord.Customer_Engagement_Events__c =CEEID;      
        }
        newRecord.record = newAttRecord;
        newRecord.agendaItemId = null;
        newRecord.index = waAccObjList.size();
        waAccObjList.add(newRecord);       
        return waAccObjList;
    }      
    /*@method: this method is used to delete the row from list variable*/
    public static List<CEE_Add_Multi_Attendees.WrapperpaAttendeeList> removeRowToAttList(Integer rowToRemove, List<CEE_Add_Multi_Attendees.WrapperpaAttendeeList> waAttList){       
        waAttList.remove(rowToRemove);
        return waAttList;
    }    
    /*@method: Cancel button to redirect back original place*/
    public PageReference cancelBtn() {
        return new PageReference('/'+CEEId); 
    } 
    /*@method: Save the data to database*/
    public PageReference SaveMultipleAttendes() {     
        List<CEE_Attendee__c> attRecordsToBeInserted = new List<CEE_Attendee__c>();
        map<Id,User> mpUser = new map<Id,User>();
        list<Id> lstInsertIds = new list<Id>();     
        if(waAccList !=null && !waAccList.isEmpty()){
            list<id> lstUserId = new list<Id>();
            for(CEE_Add_Multi_Attendees.WrapperpaAttendeeList eachRecord : waAccList ){                
                if(eachRecord.record.Salesforce_User__c != null){
                    lstUserId.add(eachRecord.record.Salesforce_User__c);
                }                       
            }   
            // getting all users information to put into map.
            if(!lstUserId.isEmpty()){
                mpUser = new map<Id,User>([select Id, Name, Email, Title from User where Id =: lstUserId]);
            }
            for(CEE_Add_Multi_Attendees.WrapperpaAttendeeList eachRecord : waAccList ){
                // populate the Name title information from User objects if it is sales force User
                if(eachRecord.record.Salesforce_User__c != null){
                    User usr = mpUser.get(eachRecord.record.Salesforce_User__c);
                    // SCAVA Fix
                    if(flsGet(CEE_Attendee__c.Name)||flsUpdateGet(CEE_Attendee__c.Name)){
                    eachRecord.record.Name = usr.Name;
                    }
                    if(flsGet(CEE_Attendee__c.Email__c )||flsUpdateGet(CEE_Attendee__c.Email__c )){
                    eachRecord.record.Email__c = usr.email;
                    }
                    if(flsGet(CEE_Attendee__c.Title__c )||flsUpdateGet(CEE_Attendee__c.Title__c )) {
                    eachRecord.record.Title__c = usr.Title;
                    }
                }
                if(flsGet(CEE_Attendee__c.Salesforce_User__c)||flsUpdateGet(CEE_Attendee__c.Salesforce_User__c)){                
                eachRecord.record.Salesforce_User__c = (eachRecord.record.Salesforce_User_Not_Available__c) ? null : eachRecord.record.Salesforce_User__c;
                }
                // SCAVA Fix
                if(flsGet(CEE_Invite__c.Agenda_Item__c)||flsUpdateGet(CEE_Invite__c.Agenda_Item__c)){
                eachRecord.record.Agenda_Item__c = eachRecord.agendaItemId;
                }
                CEE_Attendee__c attTemp;
                if(flsGet(CEE_Invite__c.CEE_Attendee__c)) {
                attTemp = eachRecord.record;
                }
                attRecordsToBeInserted.add(attTemp);
            }             
            try{                                
                Database.SaveResult[] srList = Database.insert(attRecordsToBeInserted, true);               
                for (Database.SaveResult sr : srList) {
                    if (sr.isSuccess()){
                        lstInsertIds.add(sr.getId());                               
                    }                    
                }               
            }
            catch(Exception e){
                 ApexPages.addMessages(e);
                 return null;
            }
            // After insert the CEE Attendees we are checking for non SFDC users and if cisco CEC email is correct then 
            // we are populating the name and title from cisco corporate directory.
            // CEE attendee has agenda item we are populating the presenter info on Agenda Item object.
            if(!lstInsertIds.isEmpty()){
                list<CEE_Invite__c> lstInsert = new list<CEE_Invite__c>();
                list<CEE_Attendee__c> lstAttendess = [select Id,Email__c,Type__c,Agenda_Item__c,Agenda_Item__r.Start_Date_Time__c,Agenda_Item__r.End_Date_Time__c  from CEE_Attendee__c  where id =: lstInsertIds];                
                for(CEE_Attendee__c cAtt : lstAttendess){
                    if(cAtt.Type__c == 'Presenter' && cAtt.Agenda_Item__c != null){
                        CEE_Invite__c Invite = new CEE_Invite__c();
                        // SCAVA Fix
                        if(flsGet(CEE_Invite__c.CEE_Attendee__c)) {
                        Invite.CEE_Attendee__c = cAtt.Id;
                        }
                        if(flsGet(CEE_Invite__c.Outlook_Status__c)) {
                        Invite.Outlook_Status__c = 'Not Invited';
                        }
                        if(flsGet(CEE_Invite__c.Outlook_Invite_ID__c)) {
                        Invite.Outlook_Invite_ID__c = 'null';
                        }
                        if(flsGet(CEE_Invite__c.Start_Date_Time__c)) {
                        Invite.Start_Date_Time__c = cAtt.Agenda_Item__r.Start_Date_Time__c;
                        }
                        if(flsGet(CEE_Invite__c.End_Date_Time__c)) {
                        Invite.End_Date_Time__c = cAtt.Agenda_Item__r.End_Date_Time__c;
                        }
                        if(flsGet(CEE_Invite__c.Agenda_Item__c)) {
                        Invite.Agenda_Item__c = cAtt.Agenda_Item__c;
                        }
                        lstInsert.add(Invite);
                    }
                }                
                if(!lstInsert.isEmpty()){
                    insert lstInsert;
                }
                // we are calling future method to populate the cisco corporate directory.
                CEE_Utility.updateTitleName(lstInsertIds);
            }
        }               
        return new PageReference('/'+CEEId);       
    }
    // This method is used to add extra row to UI.
    public void addNewRowToAttList(){       
        waAccList = addNewRowToAttListdata(waAccList,CEEid);   
    }
    // This method is used to get all Agenda items releated to that CEE Request and populated into agenda item drop down
    public List<SelectOption> getAgendaOptions(){
        List<SelectOption> options = new List<SelectOption>();
        try{
            List<Agenda_Item__c> agendas = [select Id, Name from Agenda_Item__c where Customer_Engagements_Events__c =:CEEid];
            for(Agenda_Item__c agenda : agendas){                
                options.add(new SelectOption(((String)agenda.Id).substring(0,15), agenda.Name));
            }
        } catch (Exception e){
            System.debug('Error retrieving Agenda Options - ' + e.getStackTraceString());
        }        
        if(options.size() == 0){
            options.add(new SelectOption('', 'No related Agenda Items', true));
        } else {
            options.add(new SelectOption('','--None--', false));
        }        
        options.sort();        
        return options;
    }
    // This wrapper class used to load the UI records to manage delete and add rows.
    public class WrapperpaAttendeeList{
        public Integer index {get;set;}
        public CEE_Attendee__c record {get;set;}
        public string agendaItemId {get;set;}
    }  
   
}