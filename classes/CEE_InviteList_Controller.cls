/***************************************************************************************************
Name    : CEE_InviteList_Controller 
Author  : Eric Pesch
Purpose : Visualforce Page component for handling Briefing invitations on a Briefing or an Agenda Item 
Created Date: Dec 1 2014
Modification History: 
Eric Pesch - Jan 5 2015: Added Comments, cleanup      
Sudi - June 14 2016, US10715 : Allow non SFDC user to send outlook invite. Commented the code for setting the  isSalesforceAttendee flag.
*****************************************************************************************************/
public with sharing class CEE_InviteList_Controller{

// SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdateGet(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }
    
    /*@Class: Struct for holding invitation variables*/
    public class InviteStruct{
        public CEE_Invite__c invite { get; set; }
        public String agendaItem { get; set; }
        public String agendaItemName { get; set; }
        //public string rooms{get; set;}
        public Boolean updateStatus{ get; set; }
        public String style { get; set; }
        public String styleCol { get; set; }
        public Boolean editVisible { get; set; }
        public Boolean isUpdate { get; set; }
        public Boolean isSalesforceAttendee { get; set; }
        public DateTime startTime { get; set; }
        public DateTime endTime { get; set; }       
        
        public InviteStruct(){
            invite = null;
            agendaItem = null;
            agendaItemName = null;
            updateStatus = null;
            style = null;
            styleCol = null;
            editVisible = false;
            isSalesforceAttendee = false;
            startTime = null;
            endTime = null;
        }      
    }

    //Generic variables
    private static final String TAG = 'CEE_AgendaItemViewController - ';
    
    //Invitation container
    public List<InviteStruct> invites;
    
    //Controller standard vars
    public Agenda_Item__c agendaItem { get; set; }
    public CEE__c briefing { get; set; } 
    public String objectName { get; set; }
    public Id recordId { get; set; }
    public boolean showbutton{get;set;}
    //Visibility variables
    public Boolean inviteVisible { get; set; }
    public Boolean loadVisible { get; set; }
    public Boolean buttonsEnabled { get; set; } 
    
    //Button specific
    public Boolean sendEnabled { get; set; }
    public Boolean sendTPenabled { get; set; }
    public Boolean cancelEnabled { get; set; }
    
    //Visualforce embded redirect fix
    public String redirectUrl { get; set; }
    public Boolean isRedirect { get; set; }

    //Checkbox criteria variables
    public String selectCriteria { get; set; }
    
    /*@Constructor: Default initialization variables*/
    public CEE_InviteList_Controller(){
        //Constructors
        this.isRedirect = false;
        this.selectCriteria = 'None';
        this.sendEnabled = false;
        this.sendTPenabled = false;
        this.cancelEnabled = false;
        this.loadVisible = true;
        this.showbutton = false;
    }
    
    /*@method: default save functionality*/
    public PageReference doSave(){
        saveInvites();
        
        isRedirect = true;
        return null;
    }
    
    /*@method: TP invitation save functionality*/
    public void saveTPInvites(){
        List<CEE_Invite__c> resources = new List<CEE_Invite__c>();
    
        if(invites!= null){
            for(InviteStruct currInvite : invites){
             if(flsUpdateGet(CEE_Invite__c.Update_Selected__c)) { //SCAVA FIX
                 currInvite.invite.Update_Selected__c = currInvite.isUpdate;   
             }
                if(currInvite.isUpdate){  
                if(flsUpdateGet(CEE_Invite__c.Telepresence_Enabled__c)) { //SCAVA FIX
                    currInvite.invite.Telepresence_Enabled__c = true;
                }
                }     
                resources.add(currInvite.invite);              
            } 
            
            try{
                update resources;
            } catch (Exception e){
                System.debug(TAG + e.getStackTraceString());
            }
        }       
    }
    
    /*@method: non-TP invitation save functionality*/
    public void saveInvites(){
        List<CEE_Invite__c> resources = new List<CEE_Invite__c>();
    
        if(invites!= null){
            for(InviteStruct currInvite : invites){
            if(flsUpdateGet(CEE_Invite__c.Update_Selected__c)){  //SCAVA FIX
                currInvite.invite.Update_Selected__c = currInvite.isUpdate; 
            }
                resources.add(currInvite.invite);              
            } 
            
            try{
                update resources;
            } catch (Exception e){
                System.debug(TAG + e.getStackTraceString());
            }
        }       
    }
    
    /*@method: initialize invitation list*/
    public void initInvites(){
        getInvites();
        loadVisible = false;
    }
    
    /*@method: getter for invitation default values based on Briefing or Agenda Item*/
    public List<InviteStruct> getInvites(){ 
        List<CEE_Invite__c> currInvites;
        System.debug(TAG + 'AgendaItem - ' + agendaItem);
        System.debug(TAG + 'Briefing - ' + briefing);
        
        //Switch based on object type
        if(this.briefing != null){
            recordId = this.briefing.Id;
        } else {
            recordId = this.agendaItem.Id;
        }
        
        //Fill out invitation information
        if(invites == null){
            List<Id> agendaIDs = new List<Id>();
            List<Id> roomIDs = new List<Id>();
            buttonsEnabled = false;
            
            //Add briefing invites
            if(briefing != null){
                //Agenda Item invites
                try{
                    List<Agenda_Item__c> briefingAgendas = [select id from Agenda_Item__c where Customer_Engagements_Events__c =: briefing.Id];
                    
                    if(briefingAgendas != null){
                        for(Agenda_Item__c agenda : briefingAgendas){
                            agendaIDs.add(agenda.Id);
                        }
                    }
                } catch(Exception e){
                    System.debug(TAG + 'briefing Agenda Items - ' + e.getStackTraceString());
                }
                
                //Room invites
                try{
                    List<Agenda_Room__c> briefingRooms = [select id from Agenda_Room__c where Customer_Engagements_Events__c =: briefing.Id];
                    
                    if(briefingRooms != null){
                        for(Agenda_Room__c room : briefingRooms){
                            roomIDs.add(room.Id);
                        }
                    }
                } catch(Exception e){
                    System.debug(TAG + 'briefing Rooms - ' + e.getStackTraceString());
                }
            }
            
            //Add just the agenda item
            if(agendaItem != null){
                agendaIDs.add(agendaItem.Id);
            }
            
            try{
                currInvites = [select id, name, Outlook_Status__c, Start_Date_Time__c, End_Date_Time__c, Location__c, Telepresence_Enabled__c,
                            Room__c, Room__r.Room__c, Room__r.Customer_Engagements_Events__r.Start_Date_Time__c, Room__r.Customer_Engagements_Events__r.End_Date_Time__c, 
                            Room__r.Room__r.Is_Telepresence__c, Room__r.Room__r.Name, CEE_Attendee__c, CEE_Attendee__r.Salesforce_User__c,  
                            Agenda_Item__c, Agenda_Item__r.Name, Agenda_Item__r.Start_Date_Time__c, Agenda_Item__r.End_Date_Time__c, Agenda_Item__r.Selected_Rooms_Display__c,CreatedDate 
                            from CEE_Invite__c where (Agenda_Item__c  in : (agendaIDs) OR Room__c in : (roomIDs))];
            } catch (Exception e){
                System.debug(TAG + e.getStackTraceString());
            }
            
            //If invitations available
            if(currInvites != null){
                invites = new List<InviteStruct>();
                 
                for(CEE_Invite__c currInvite : currInvites ){
                    InviteStruct localInvite = new InviteStruct();
                    localInvite.agendaItem = currInvite.Agenda_Item__c;
                    localInvite.agendaItemName = currInvite.Agenda_Item__r.Name;
                    localInvite.invite = currInvite;
                    localInvite.style='badText';
                    localInvite.isUpdate = false;
                    localInvite.isSalesforceAttendee = true;
                    localInvite.startTime = currInvite.Start_Date_Time__c;
                    localInvite.startTime = currInvite.End_Date_Time__c;
                    
                    // Sudi - 06/14/2016 : commented the code to allow non sfdc user to send outlook invite.
                   /* if(currInvite.CEE_Attendee__c != null && currInvite.CEE_Attendee__r.Salesforce_User__c == null){
                        localInvite.isSalesforceAttendee = false;
                    } else if(currInvite.CEE_Attendee__c != null && currInvite.CEE_Attendee__r.Salesforce_User__c == null){
                        localInvite.isSalesforceAttendee = false;
                    }*/
                    
                    //Problem scenarios
                    //Location has changed
                    if(currInvite.Agenda_Item__c != null){
                        if(!String.isEmpty(currInvite.Location__c) && ((currInvite.Location__c != System.label.CEE_Email_Empty_Location && String.isEmpty(currInvite.Agenda_Item__r.Selected_Rooms_Display__c)) || 
                                (!String.isEmpty(currInvite.Agenda_Item__r.Selected_Rooms_Display__c) && currInvite.Location__c != currInvite.Agenda_Item__r.Selected_Rooms_Display__c))){
                            localInvite.updateStatus = true;
                            localInvite.styleCol += '4';
                        } 
                    } else if(currInvite.Room__c != null){
                        if(!String.isEmpty(currInvite.Location__c) && currInvite.Location__c != System.label.CEE_Email_Empty_Location && !currInvite.Location__c.contains(currInvite.Room__r.Room__r.Name)){
                            localInvite.updateStatus = true;
                            localInvite.styleCol += '4';
                        }
                    }
                    
                    //Start time has changed
                    if(currInvite.Agenda_Item__c != null){
                        if(currInvite.Start_Date_Time__c != currInvite.Agenda_Item__r.Start_Date_Time__c){
                            localInvite.updateStatus = true;
                            localInvite.styleCol += '5';
                        } 
                        
                        //End time has changed
                        if (currInvite.End_Date_Time__c != currInvite.Agenda_Item__r.End_Date_Time__c ){
                            localInvite.updateStatus = true;
                            localInvite.styleCol += '6';
                        }
                    } else {
                        if(currInvite.Start_Date_Time__c < currInvite.Room__r.Customer_Engagements_Events__r.Start_Date_Time__c
                                ||currInvite.Start_Date_Time__c >= currInvite.Room__r.Customer_Engagements_Events__r.End_Date_Time__c){
                            localInvite.updateStatus = true;
                            localInvite.styleCol += '5';
                        }
                        
                        if(currInvite.End_Date_Time__c > currInvite.Room__r.Customer_Engagements_Events__r.End_Date_Time__c 
                                || currInvite.End_Date_Time__c <= currInvite.Room__r.Customer_Engagements_Events__r.Start_Date_Time__c){
                            localInvite.updateStatus = true;
                            localInvite.styleCol += '6';
                        }
                    }
                    
                    //Default behavior
                    if(localInvite.styleCol == null){
                        localInvite.updateStatus = false;
                    }
                    
                    //Attendee edit ability - ONLY ON ATTENDEES, NOT ROOMS
                    if(currInvite.CEE_Attendee__c != null){
                        localInvite.editVisible = true;
                    } else {
                        localInvite.editVisible = false;
                    }
                    
                    //Invitations default visibility
                    inviteVisible = true;
                    invites.add(localInvite);
                } 
            }
        } else {
            //Determine buttons enabled (>=1 check){
            buttonsEnabled = false;
            for(Integer i = 0; i < invites.size(); i++){
                if(invites[i].isUpdate){
                    buttonsEnabled = true;
                    i = invites.size();
                }
            }
        }
        return invites;
    }
    public void setInvites() {}
    
    /*@method: Find invite list checkbox display properties*/
    public void validateCheckbox() {
        //Activate button booleans
        Boolean selPerson = false;
        Boolean selRoom = false;
        Boolean selRoomTP = false;
        Boolean selRoomTPActive = false;
        
        //Date validation
        DateTime inviteStartTime = null;
        DateTime inviteEndTime = null;
        
        //Custom validation checks
        this.sendEnabled = false;
        this.sendTPenabled = false;
        this.cancelEnabled = false;
        
        for(Integer i = 0; i < invites.size() ;i++){
            if(invites[i].isUpdate){
                //Invalidate if people chosen
                if(invites[i].invite.CEE_Attendee__c != null){
                    selPerson = true;
                }
                //Invalidate if room chosen isn't TP room
                else if(invites[i].invite.Room__r.Room__r.Is_Telepresence__c){
                    if(invites[i].invite.Telepresence_Enabled__c){
                        selRoomTPActive = true;
                    } else {
                        //Populate first time
                        if(inviteStartTime == null){
                            inviteStartTime = invites[i].startTime;
                            inviteEndTime = invites[i].endTime;
                            
                            selRoomTP = true;
                        } else if((inviteStartTime != invites[i].startTime) || (inviteEndTime != invites[i].endTime)){
                            selRoomTP = false;
                            selRoom = true;
                        }
                    }
                //Else, it's a room
                } else {
                    selRoom = true;
                }
            }
        }
        
        //If "checked", give ability to cancel invite
        if(selPerson || selRoom || selRoomTP || selRoomTPActive){
            cancelEnabled = true;
        }
        
        //Scenarios to allow "sending" button availabile/if you can send different invitations together
        if(selPerson && !selRoom && !selRoomTP && !selRoomTPActive){
            sendEnabled = true;
        } else if(!selPerson && selRoom && !selRoomTP && !selRoomTPActive){
            sendEnabled = true;
        } else if(!selPerson && !selRoom && selRoomTP && !selRoomTPActive){
            sendEnabled = true;
            sendTPEnabled = true; //TP ONLY BEHAVIOR
        } else if(!selPerson && !selRoom && !selRoomTP && selRoomTPActive){
            sendTPEnabled = true; //TP ONLY BEHAVIOR
        } else if(selPerson && selRoom && !selRoomTP && !selRoomTPActive){
            sendEnabled = true;
        } else if(selPerson && !selRoom && selRoomTP && !selRoomTPActive){
            sendEnabled = true;
        } else if(!selPerson && selRoom && selRoomTP && !selRoomTPActive){
            sendEnabled = true;
        } else if(selPerson && selRoom && selRoomTP && !selRoomTPActive){
            sendEnabled = true;
        } 
        
       // Newly Added
        Set<String> agendaItems = new Set<String>();
        List<String> rooms = new List<String>();
        for(InviteStruct i : invites)
        {
            if(i.isUpdate && i.invite.Room__r.Room__c==Null)
            {
                agendaItems.add(i.agendaItemName);
            }
            if(i.isUpdate && i.invite.Room__r.Room__c!=Null)
            {
                rooms.add(i.invite.Room__r.Room__c);
            }
        }
            system.debug('-------->>>>>>>> Agenda'+agendaItems);
            if(!agendaItems.isEmpty() && agendaItems.Size()==1)
                {
            system.debug('-------->>>>>>>> Agenda Size'+agendaItems.Size());
            showbutton = true;
                }
             else if(!agendaItems.isEmpty() && agendaItems.Size()==1 && !rooms.isEmpty()||agendaItems.isEmpty()==true && !rooms.isEmpty())
            {
            showbutton = true;
            }
           /* else if(agendaItems.isEmpty()==true && !rooms.isEmpty())
            {
            showbutton = true;
            }*/
            else
            {
            showbutton = false;
            }
    }
    /*@method: Toggle invitation update selection*/
    public void toggleIsUpdate() {
        for(InviteStruct invite : invites){
            //Block if checkbox is able to work
            if(selectCriteria == 'All'){
                if(invite.invite.CEE_Attendee__c != null){
                    if(invite.isSalesforceAttendee){
                        invite.isUpdate = true;
                    }   
                } else {
                    invite.isUpdate = true;
                }
            } else if(selectCriteria == 'None'){
                if(invite.invite.CEE_Attendee__c != null){
                    if(invite.isSalesforceAttendee){
                        invite.isUpdate = false;
                    }   
                } else {
                    invite.isUpdate = false;
                }
            } else if(selectCriteria == 'Rooms'){
                if(invite.invite.Room__c != null){
                    invite.isUpdate = true;
                } else {
                    invite.isUpdate = false;
                }
            } else if(selectCriteria == 'People'){
                if(invite.invite.CEE_Attendee__c != null){
                    if(invite.isSalesforceAttendee){
                        invite.isUpdate = true;
                    }   
                } else {
                    invite.isUpdate = false;
                }
            }
        }
        
        //Validate invitation button availability
        validateCheckbox();
    }
}