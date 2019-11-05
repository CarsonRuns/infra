/***************************************************************************************************
Name    : CPOC_RoomEditController 
Author  : Priyanka Jangid
Purpose : Visualforce Page Controller for custom CPOC Room page  
Created Date: Jan 25 2016    
Modified By :
        Sudi - Aug 17th 2016: Added this extra check during normalization fix.
                              To check the RoolId is empty or not to void code execution.
*****************************************************************************************************/

public class CPOC_RoomEditController {
    // SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdateGet(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }
    // SCAVA Helper Method to validate Create Access at field level
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }

    //Record and controller variables
    private static String TAG = 'CPOC_RoomEditController';
    public CPOC_Room__c room;
    public final ApexPages.StandardController controller;
    
    //Related object list variables
    public CEE__c briefing { get; set; }       
    public List<CEE_Room__c> siteRooms;
    public string sRoomStatus{get;set;}
    
    //Page display variables
    public String pageUrl { get; set; }
    public String pageDisplay { get; set; }    
    public String roomName { get; set; }
    public list<CPOC_Room__c> lstRooms{get;set;}    
    //Room variables
    public String selRoom { get; set; }
    public string selRoomName {get;set;}    
    public void returnRoomAvaibilityStatus(){  
        try{
            // Sudi - Aug 17th 2016 : Added this condition in code as part normalization fix.
            // Checking for selroom is empty or not.
            if(String.isEmpty(selRoom)){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'Invalid or no Room selected'));               
            }
            else{
                lstRooms = new list<CPOC_Room__c>();
                lstRooms = [select id, Customer_Engagements_Events__r.Primary_Account__r.Name,CPOC_Start_Date__c,CPOC_End_Date__c,room__r.Name,Customer_Engagements_Events__r.Request_Status__c from CPOC_Room__c
                                                 where Customer_Engagements_Events__r.Request_Status__c in('Submitted','Scheduled','Lab Redirect') AND Room__c =:selRoom
                                                 AND id != :room.id
                                                 AND ((CPOC_Start_Date__c >=: room.CPOC_Start_Date__c  AND CPOC_Start_Date__c <=:  room.CPOC_End_date__c)
                                                 OR (CPOC_End_Date__c >=: room.CPOC_Start_Date__c  AND CPOC_End_Date__c <=: room.CPOC_End_date__c)
                                                 OR(CPOC_Start_Date__c <=: room.CPOC_Start_Date__c  AND CPOC_End_Date__c >=: room.CPOC_End_date__c) )];
                                                       
                selRoomName = [select name from CEE_Room__c where id=:selRoom limit 1].Name;               
                sRoomStatus = ((lstRooms.isEmpty()) ? 'Not Booked' : 'Booked');   
            }
        }                  
        catch(Exception e){            
            ApexPages.addMessages(e);           
        }              
    }
    /*@method: Generic save function*/
    public PageReference doSave(){        
        if(String.isEmpty(selRoom)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'Invalid or no Room selected'));
            return null;
        }
        
        //Save the attendee record
        try{
            if(room.Id == null){
            
            if(flsUpdateGet(CPOC_Room__c.Room__c)||flsGet(CPOC_Room__c.Room__c)) //SCAVA FIX
               {
                room.Room__c = selRoom; 
               }
                insert room;
            } else {
                if(room.room__c == selroom){
                    update room;
                 }
                else{
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'Room cannot be changed'));
                    return null;
                 }
            }
        } catch(Exception e){            
            ApexPages.addMessages(e);
            return null;
        }        
        
        //Briefing return       
        return new PageReference('/'+room.Customer_Engagements_Events__c);
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
        
    /*@Constructor: Controller construction and initialization*/
    public CPOC_RoomEditController(ApexPages.StandardController stdController){
        List<String> popFields = new List<String>{'Id', 'Name', 'Customer_Engagements_Events__c', 
            'CPOC_End_date__c','Room__c', 'CPOC_Start_Date__c', 'room__r.Name','Customer_Engagements_Events__r.Primary_Account__r.Name'}; 
        List<String> locations = new List<String>();        
        this.controller = stdController;
        if(!Test.isRunningTest()){
            this.controller.addFields(popFields);
        }
        this.room = (CPOC_Room__c)stdController.getRecord();
        this.pageDisplay = 'New CPOC Room'; //default behavior
        this.pageUrl = ApexPages.currentPage().getUrl();
        
            
        //Populate briefing sites
        try{
            briefing = [select Id, CPOC_Location__c, CPOC_Start_Date__c, CPOC_End_Date__c,Requested_Customer_Arrival_Date__c, Requested_Customer_End_Date__c 
                        from CEE__c 
                        where Id =: room.Customer_Engagements_Events__c];                
        } catch(Exception e){
            System.debug(TAG + 'Error retrieving Briefing - ' + e.getStackTraceString());
        }
        
        //Populate default variables      
        if(this.room.Id == null){
            if(flsUpdateGet(CPOC_Room__c.CPOC_Start_Date__c)||flsGet(CPOC_Room__c.CPOC_Start_Date__c)) //SCAVA FIX     
            {
             room.CPOC_Start_Date__c = briefing.CPOC_Start_Date__c;
            }
            if(flsUpdateGet(CPOC_Room__c.CPOC_End_date__c)||flsGet(CPOC_Room__c.CPOC_End_date__c)) //SCAVA FIX 
            {
            room.CPOC_End_date__c = briefing.CPOC_End_Date__c;
            }           
        } else {                        
            if(room.Name != null){
                roomName = room.Name;
                pageDisplay = room.Name;
            }
            selRoom = room.Room__c;
        }             
        //Get rooms - Primary Site OR Briefing Sites
        if(briefing != null){
            locations.add(briefing.CPOC_Location__c);
        }        
        
        try{
            //Get briefing Rooms
            List<Id> oldcpocRooms = new List<Id>();
            List<CPOC_Room__c> cpocRooms = [select Id, Name, Room__c from CPOC_Room__c where Customer_Engagements_Events__c =: room.Customer_Engagements_Events__c
                            and Id !=: room.Id];
            for(CPOC_Room__c cpocRoom : cpocRooms){
                oldcpocRooms.add(cpocRoom.Room__c);
            }
            
            //Filter sites by locations and not added already
            siteRooms = [select Id, Name, CEE_Location__c, CEE_Location__r.Name, Active__c from CEE_Room__c where CEE_Location__c IN : locations
                        AND Id NOT IN : oldcpocRooms AND Active__c = TRUE ];
        } catch (Exception e){
            System.debug(TAG + 'Error retrieving Room Options - ' + e.getStackTraceString());
        }
    }
    
    /*@method: Getter for Select Room Picklist*/
    public List<SelectOption> getRoomOptions(){
        List<SelectOption> roomOptions = new List<SelectOption>();
        
        for(CEE_Room__c siteRoom : siteRooms){
            roomOptions.add(new SelectOption(siteRoom.Id, siteRoom.CEE_Location__r.Name + ' - ' + siteRoom.Name));
        }
        
        if(roomOptions.isEmpty()){
            roomOptions.add(new SelectOption('','No CPOC Rooms found for this CPOC Lab',true));
        } else {
            roomOptions.add(new SelectOption('','--None--'));
        }
        roomOptions.sort();
        return roomOptions;
    }
}