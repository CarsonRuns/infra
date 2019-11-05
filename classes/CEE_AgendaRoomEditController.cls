/***************************************************************************************************
Name    : CEE_AgendaRoomEditController 
Author  : Eric Pesch
Purpose : Visualforce Page Controller for custom Agenda Room page  
Created Date: Dec 22 2014
Modification History: 
Eric Pesch - Jan 5 2015: Added Comments, cleanup      
Sourabha - June 19 2015 - Added enhancements for CCE2 June release.               
*****************************************************************************************************/

public class CEE_AgendaRoomEditController {
    
    // SCAVA Helper Method
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }
    // SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdate(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }
    
    //Record and controller variables
    private final String TAG = 'CEE_AgendaRoomEditController';
    private Agenda_Room__c room;
    private final ApexPages.StandardController controller;
    
    //Related object list variables
    public CEE__c briefing { get; set; }
    private List<Agenda_Room__c> briefingRooms;
    private List<Briefing_Site__c> sites;    
    private List<CEE_Room__c> siteRooms;
    
    //Page display variables
    public String pageUrl { get; set; }
    public String pageDisplay { get; set; }
    public Boolean isNew { get; set; }
    public String roomName { get; set; }
    
    //Room variables
    public String selRoom { get; set; }
    
    //Time variables
    public String siteStartTime { get; set; }
    public String siteEndTime { get; set; }
   
    /*@method: Save and New button click*/
    public PageReference doSaveNew(){
        return doSave(true);
    }
    /*@method: ONLY Save button click*/
    public PageReference doSave(){
        return doSave(false);
    }
    /*@method: Generic save function*/
    public PageReference doSave(boolean isSaveNew){
        
        if(String.isEmpty(selRoom)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'Invalid or no Room selected'));
            return null;
        }
        
        //Save the attendee record
        try{
            if(room.Id == null){
                // SCAVA FIX
                if(flsGet(Agenda_Room__c.Room__c)|| flsUpdate(Agenda_Room__c.Room__c))
                {
                room.Room__c = selRoom; 
                }
                insert room;
            } else {
                
                if(room.room__c!=selroom){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'Room cannot be changed'));
                    return null;
                 }
                else
                    update room;
            }
        } catch(Exception e){
            System.debug(e.getStackTraceString());
            ApexPages.addMessages(e);
            return null;
        }
        
        //Save-New behavior
        if(isSaveNew){
            //String editID = '/' + ('' + room.get('Id')).subString(0, 3) + '/e?';
            //SCAVA FIX
            String editID =  ('' + room.get('Id')).subString(0, 3) + '/e?';
            Map<String, String> parameters = ApexPages.currentPage().getParameters();
            
            //Grab lookup field prefix            
            String prefix = Utilities.getConstant_CS('CEE Field Prefix');
            
            //Relate associated page parameters
            for(String key : parameters.keySet()){
                String value = parameters.get(key);
                if(key.contains(prefix)){             
                    editId += key + '=' + value + '&';
                } else if (key.equals('retURL')) {
                    editId += key + '=' + value + '&';
                }
                System.debug(TAG + 'key/value - ' + key + ' / ' + value);
            }
            editId = editId.substring(0,editId.length()-1);         
            
            // return new PageReference(editId);
           //SCAVA FIX
            return new PageReference('/' +editId);
        }
        
        //Briefing return
        return new PageReference('/'+room.Customer_Engagements_Events__c);
    }

    /*@Constructor: Controller construction and initialization*/
    public CEE_AgendaRoomEditController(ApexPages.StandardController stdController){
        List<String> popFields = new List<String>{'Id', 'Name', 'Account_Name__c', 'Briefing_Status__c','Briefing_Type__c', 'Customer_Engagements_Events__c', 
            'End_Date_Time__c','Room__c','Room_Name__c','Start_Date_Time__c'};
        List<String> locations = new List<String>();
        
        this.controller = stdController;
        if(!Test.isRunningTest()){
            this.controller.addFields(popFields);
        }
        this.room = (Agenda_Room__c)stdController.getRecord();
        this.pageDisplay = 'New Agenda Room'; //default behavior
        this.pageUrl = ApexPages.currentPage().getUrl();
        this.isNew = true;
        
        //Populate briefing sites
        try{
            briefing = [select Id, Primary_FSO__c, Start_Date_Time__c, End_Date_Time__c, Primary_FSO__r.Site_Time_Zone__c, Timezone__c from CEE__c 
                        where Id =: room.Customer_Engagements_Events__c];
            sites = [select Id, Additional_Participant_Location__c from Briefing_Site__c where Customer_Engagements_Events__c =: room.Customer_Engagements_Events__c];
        } catch(Exception e){
            System.debug(TAG + 'Error retrieving Briefing - ' + e.getStackTraceString());
        }
        
        //Populate default variables
        if(this.room.Id != null){
            isNew = false;
            if(room.Name != null){
                roomName = room.Name;
                pageDisplay = room.Name;
            }
            selRoom = room.Room__c;
        } else {
            // SCAVA Fix
            if(flsGet(Agenda_Room__c.Start_Date_Time__c)||flsUpdate(Agenda_Room__c.Start_Date_Time__c)) {
            room.Start_Date_Time__c = briefing.Start_Date_Time__c;
            }
            if(flsGet(Agenda_Room__c.End_Date_Time__c)||flsUpdate(Agenda_Room__c.End_Date_Time__c)) {
            room.End_Date_Time__c = briefing.End_Date_Time__c;
            }
        }
        siteStartTime = CEE_Utility.calcSiteTime(briefing, briefing.Start_Date_Time__c);
        siteEndTime = CEE_Utility.calcSiteTime(briefing, briefing.End_Date_Time__c);
        
        //Get rooms - Primary Site OR Briefing Sites
        for(Briefing_Site__c site : sites){
            locations.add(site.Additional_Participant_Location__c);
        }
        if(briefing != null){
            locations.add(briefing.Primary_FSO__c);
        }
        System.debug(TAG + 'location - ' + locations);
        
        try{
            //Get briefing Rooms
            List<Id> oldBriefingRooms = new List<Id>();
            briefingRooms = [select Id, Name, Room__c from Agenda_Room__c where Customer_Engagements_Events__c =: room.Customer_Engagements_Events__c
                            and Id !=: room.Id];
            for(Agenda_Room__c briefingRoom : briefingRooms){
                oldBriefingRooms.add(briefingRoom.Room__c);
            }
            
            //Filter sites by locations and not added already
            siteRooms = [select Id, Name, CEE_Location__c, CEE_Location__r.Name from CEE_Room__c where CEE_Location__c IN : locations
                        AND Id NOT IN : oldBriefingRooms];
        } catch (Exception e){
            System.debug(TAG + 'Error retrieving Room Options - ' + e.getStackTraceString());
        }
    }
    
            /* **********************************************************
           Added By Naresh (nkalahas@cisco.com) on 31/01/2018  to redirect to previous page on cancel
       ************************************************************  */          

       public PageReference doCancel() {
        String url = ApexPages.currentPage().getHeaders().get('Referer');

        
        PageReference pageRef = new PageReference('/' + room.Customer_Engagements_Events__c );
        pageRef.setRedirect(true);
        return pageRef; 


        }
    
    /*@method: Getter for Select Room Picklist*/
    public List<SelectOption> getRoomOptions(){
        List<SelectOption> roomOptions = new List<SelectOption>();
        
        for(CEE_Room__c siteRoom : siteRooms){
            roomOptions.add(new SelectOption(siteRoom.Id, siteRoom.CEE_Location__r.Name + ' - ' + siteRoom.Name));
        }
        
        if(roomOptions.size() == 0){
            roomOptions.add(new SelectOption('','No CEE Rooms found for Briefing Sites',true));
        } else {
            roomOptions.add(new SelectOption('','--None--'));
        }
        
        roomOptions.sort();
        return roomOptions;
    }
    public void setRoomOptions(List<SelectOption> rooms){ }
}