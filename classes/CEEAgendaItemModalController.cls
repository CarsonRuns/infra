/**************************************************************************************************
   @Author :Jay Dash
   @name :CEEAgendaItemModalController
   @CreateDate : 07/28/2015
   @Description : This controller manages to edit Agenda item,Attendee and Invitee from popup 
   @Version :1.0
   Modification History:
        Sudi - 12/12/2015(US9236) : Added new fields Architecture,Sub-architecture,Sales Objectives to the Agend item popup page.
        Sudi - 06/25/2016(US10715) : Adding NON SFDC user as a presenter ,Line 230 added if condition to check for non SFDC user 
  *************************************************************************************************/

public class CEEAgendaItemModalController{
// SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdateGet(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }
    public String aid = System.currentPageReference().getParameters().get('id');
    public Agenda_Item__c agnd = new Agenda_Item__c();
    public List<CEE_Invite__c> invt {get; set;}
    public CEE_Attendee__c atnde = new CEE_Attendee__c();
    // Sudi - US9236 : added the below veraible 
    public Boolean editName { get; set; }    
    public List<CEE_Attendee__c> attendee {get; set;}
    public CEE__c briefing;
    public String selSolution { get; set; }
    public String selArchitecture { get; set;}
    public String selSubArchitecture { get; set;}
    public Map<String, Map<String, Topic__c>> solutions;
    public Boolean showFullSolutions { get; set; }
    public Set<String> architectures;
    public Map<String, Set<String>> subArchitectures;
    public String[] selectedRooms { get; set; }
    public Set<Topic__c> suggestSolutions;
    public List<Topic__c> topicList;
    public boolean isExcep { get; set; }
    private Map<String, Agenda_Room__c> roomMap;
    private Map<String, CEE_Invite__c> oldInvites;

    public CEEAgendaItemModalController(ApexPages.StandardController controller) {
     
    }
    public CEEAgendaItemModalController(){
        string aaid = aid.substring(0,15);  
        architectures = new Set<String>();
        subArchitectures = new Map<String, Set<String>>();
        solutions = new Map<String, Map<String, Topic__c>>();
        roomMap = new Map<String, Agenda_Room__c>();
        isExcep = false;
        oldInvites = new Map<String, CEE_Invite__c>();
        this.showFullSolutions = false;
        topicList = new List<Topic__c>();
        
        try{
            agnd = [SELECT id, name,Start_Date_Time__c , Sales_Objectives__c, Start_Time_Site__c,End_Date_Time__c,End_Time_Site__c,Topic__c,Topic_Name__c,Customer_Engagements_Events__c,Selected_Rooms__c,
                    Selected_Rooms_Display__c,Demo_Delivery_Location_s__c  FROM Agenda_Item__c WHERE Id = :aaid];
        
            this.briefing = [SELECT ID, Primary_FSO__c, Primary_FSO__r.Site_Time_Zone__c, Primary_FSO__r.Department_Code__c, EBC_CBC_Location__c,
                            Timezone__c, Total_Attendees__c, Start_Date_Time__c,End_Date_Time__c, Sub_Architecture__c 
                            FROM CEE__c WHERE ID =: agnd.Customer_Engagements_Events__c];   
        
            invt = [SELECT id,name,CEE_Attendee__r.name,Outlook_Status__c,Agenda_Item__c,Outlook_Invite_ID__c 
                    FROM CEE_Invite__c WHERE Agenda_Item__c=:agnd.id];
        
            attendee = [SELECT id,name,Salesforce_User__c,Agenda_Item__c,Customer_Engagement_Events__c,Type__c,Email__c,Title__c 
                       FROM CEE_Attendee__c WHERE Agenda_Item__c=:agnd.id and type__c='presenter'];
        
            topicList = [SELECT Architecture__c, Sub_Architecture__c, Name 
                            FROM Topic__c WHERE Architecture__c != null 
                            AND Sub_Architecture__c != null
                            AND IsActive__c =: true 
                            ORDER BY Architecture__c, Sub_Architecture__c, Name ];
                                                     
        }catch (Exception e){
            System.debug(e.getStackTraceString());
        }   
        for (Topic__c topic : topicList) {                
            // add each architecture to architectures: this is set, so duplicates will be ignored
             architectures.add(topic.Architecture__c);
                         
            // if we've already entered this architcture already, we appened the subarch to that key:
            if (subArchitectures.keySet().contains(topic.Architecture__c)) {
                subArchitectures.get(topic.Architecture__c).add(topic.Sub_Architecture__c);
            }
            // otherwise, we create the new key/value pair
            else {                    
                subArchitectures.put(topic.Architecture__c, new Set<String>{topic.Sub_Architecture__c});
            }
            
            //Store by pair <arch, sub_arch>
            String solutionKey = topic.Architecture__c + topic.Sub_Architecture__c;                               
            if (solutions.keySet().contains(solutionKey)) {
                solutions.get(solutionKey).put(topic.Id, topic);
            } else {
                Map<String, Topic__c> newSolMap = new Map<String, Topic__c>();
                newSolMap.put(topic.Id, topic);
                solutions.put(solutionKey, newSolMap);               
            }
        }
       
        //Get current Agenda Item's topic
        this.suggestSolutions = new Set<Topic__c>();
        
        if(agnd.Topic__c != null){
            try{
                Topic__c selTopic = [SELECT Architecture__c, Sub_Architecture__c, Name 
                                    FROM Topic__c WHERE Id =: agnd.Topic__c]; 
                selSolution = agnd.Topic__c;
                this.suggestSolutions.add(selTopic);
            } catch (Exception e){
                System.debug(e.getStackTraceString());
            }
        }
        
        //Populate "suggested solutions" list, incl. chosen topic
        String[] selSubArchitecture = null;
        if(briefing != null  && !String.isEmpty(briefing.Sub_Architecture__c)){
            selSubArchitecture = briefing.Sub_Architecture__c.split(';');
            
            for(String subarch : selSubArchitecture){
                for(String subarchKey : solutions.keySet()){
                    if(subarchKey.contains(subarch)){
                        this.suggestSolutions.addAll(solutions.get(subarchKey).values());
                    }
                }
            }
        }
         
        if(suggestSolutions.isEmpty()){
            this.showFullSolutions = true;
        }
         //Populate old multi-select dynamic fields
        if(agnd.Selected_Rooms__c == null){
            this.selectedRooms  = new List<String>();
        } else {
            this.selectedRooms = agnd.Selected_Rooms__c.split(';');
        }
        
        //Populate Agenda Rooms
        try{
            List<Agenda_Room__c> rooms = [SELECT Id, Name, Room__c, Room__r.Name, Room__r.CEE_Location__c, Room__r.CEE_Location__r.Name,
                                         Room__r.CEE_Location__r.Id FROM Agenda_Room__c WHERE Customer_Engagements_Events__c =: briefing.Id];
            if(!rooms.isEmpty() && rooms.size() > 0){
                for(Agenda_Room__c room : rooms){
                    roomMap.put(room.Id, room);
                }
            }
            
            List<CEE_Invite__c> invites = [SELECT Id, Name, Room__c, Outlook_Status__c FROM CEE_Invite__c WHERE Room__c in : rooms];
            if(!invites.isEmpty() && invites.size() > 0){
                for(CEE_Invite__c invite : invites){
                    oldInvites.put(invite.Room__c, invite);
                }   
            }
            
        } catch (Exception e){
            System.debug('No Agenda Rooms found - ' + e.getStackTraceString());
        }
    }
    
    public Agenda_Item__c getAgendaItem() {    
              
        return agnd;
    }
    public List<SelectOption> getSolutionOptions () {
        List<SelectOption> solutionOptions = new List <SelectOption>();
        
        if(showFullSolutions){
            if (selArchitecture != null && selSubArchitecture != null) {
                String key = selArchitecture + selSubArchitecture;
                
                if (solutions != null && solutions.get(key) != null) {
                    for (Topic__c solution : solutions.get(key).values()) {
                        solutionOptions.add(new SelectOption(solution.Id, solution.Name));
                    }
                }
            } 
            
            if(solutionOptions.isEmpty()) {
                solutionOptions.add(new SelectOption('','Select an Architure/Sub-Architecture', true));
            } else {
                solutionOptions.add(new SelectOption(solutions.get('OtherOther').values()[0].Id, 'Other'));
            }
        } else {
            if(suggestSolutions != null){
                for(Topic__c currTopic : suggestSolutions){
                    solutionOptions.add(new SelectOption(currTopic.Id, currTopic.Name));
                }
                solutionOptions.add(new SelectOption(solutions.get('OtherOther').values()[0].Id, 'Other'));
            }
        }
        
        solutionOptions.sort();
        
        return solutionOptions;
    }
    
     public List<SelectOption> getDynRooms(){
        List<SelectOption> options = new List<SelectOption>();
        if(roomMap.values() != null){
            for(Agenda_Room__c room : roomMap.values()){
                if(room != null){
                    options.add(new SelectOption(room.Id, 'Invite: ' + oldInvites.get(room.Id).Outlook_Status__c + ' - ' + room.Room__r.Name));
                }
            }
        }
        
        if(options.isEmpty()){
            options.add(new SelectOption('', 'No Rooms added for this Briefing', true));
        }
        
        return options;
    }
    public void saveAgendaItem(){
        //Attendee save
        Set<Id> userid = new Set<Id>();
        List<User> Lookupuser = new List<User>();
        Map<id,user> umap = new Map<id,user>();
        List<CEE_Attendee__c> attsave = new List<CEE_Attendee__c>();
        List<CEE_Invite__c> invtsave = new List<CEE_Invite__c>();       
        if(reqFieldsValidation()){
            isExcep = true; 
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Please select a solution topic.'));               
        }else{
        try{
            if(!attendee.isEmpty()){
                for(CEE_Attendee__c att:attendee) { 
                    userid.add(att.Salesforce_User__c) ; 
                }
                
                Lookupuser = [SELECT Id, Name, Email, Title FROM User WHERE Id In :userid];
                for(User uu:Lookupuser){
                    umap.put(uu.id,uu); 
                }
                for(CEE_Attendee__c att:attendee) { 
                    // Sudi 06/25/2016 - Checking for SFDC user and adding email name from USer object else we are passing as is.
                    if(umap.get(att.Salesforce_User__c) != null){
                     if(flsUpdateGet(CEE_Attendee__c.Name))  //SCAVA FIX
                        att.Name = umap.get(att.Salesforce_User__c).name;
                        if(flsUpdateGet(CEE_Attendee__c.Email__c ))  //SCAVA FIX
                        att.Email__c = umap.get(att.Salesforce_User__c).Email;
                        if(flsUpdateGet(CEE_Attendee__c.Title__c  ))  //SCAVA FIX
                        att.Title__c = umap.get(att.Salesforce_User__c).Title ;
                    }
                    attsave.add(att);
                }
                update attsave ;
            }
        }catch (DMLException e){
            System.debug(e.getStackTraceString());
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,e.getDmlMessage(0)));            
        }
        try{
            if(!invt.isEmpty()){
                for(CEE_Invite__c inv:invt ) {  
                    invtsave.add(inv);
                }
                update invtsave;
            }
        }catch (DMLException e){
            System.debug(e.getStackTraceString());
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,e.getDmlMessage(0)));            
        }
        //Agenda item save
        string selectRoomStr = '';
        string selectRoomDisplayStr = '';
        if(selectedRooms != null){
            for(Integer i = 0; i < selectedRooms.size(); i++){
                //Add room info
                selectRoomStr = selectRoomStr + selectedRooms[i];
                selectRoomDisplayStr = selectRoomDisplayStr + roomMap.get(selectedRooms[i]).Room__r.Name;
                if(i != (selectedRooms.size()-1)){
                    selectRoomStr += ';';
                    selectRoomDisplayStr += ',';
                } 
            }
        }
        try{            
            //Non-topic selection            
            if(!String.isEmpty(selSolution) && selSolution != '--None--' && (selSolution !=null || selSolution != '')){
                agnd.Topic__c = selSolution;
            } else {
                agnd.Topic__c = null;
            }
            
            //NEW Feb 2015 - Site Timezone information
            if(briefing.Primary_FSO__c != null){            
                try{
                if(flsUpdateGet(Agenda_Item__c.Start_Time_Site__c))  //SCAVA FIX
                    agnd.Start_Time_Site__c = agnd.Start_Date_Time__c.format(CEE_Utility.TIME_FORMAT_EBC, briefing.Primary_FSO__r.Site_Time_Zone__c);
                    if(flsUpdateGet(Agenda_Item__c.End_Time_Site__c))  //SCAVA FIX
                    agnd.End_Time_Site__c = agnd.End_Date_Time__c.format(CEE_Utility.TIME_FORMAT_EBC, briefing.Primary_FSO__r.Site_Time_Zone__c);
                } catch (Exception e){
                    System.debug('EBC Time Exception - ' + e.getStackTraceString());
                }
            }
            if(flsUpdateGet(Agenda_Item__c.Topic__c))  //SCAVA FIX
            agnd.Topic__c  = selSolution;
            if(flsUpdateGet(Agenda_Item__c.Selected_Rooms__c))  //SCAVA FIX
            agnd.Selected_Rooms__c  = selectRoomStr;
            if(flsUpdateGet(Agenda_Item__c.Selected_Rooms_Display__c))  //SCAVA FIX
            agnd.Selected_Rooms_Display__c  = selectRoomDisplayStr;
            update agnd;
            isExcep = false; 
        }catch (DMLException e){
            isExcep = true;
            System.debug(e.getStackTraceString());
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,e.getDmlMessage(0)));
        }
        }
        
    }
     /* Sudi - US9236 : added the below method
     @method: Check to see if Agenda_Item__c.Name is an editable*/
    public void checkName(){
        Topic__c currTopic = null;
        
        //Check if custom-solution based or topic based
        if(showFullSolutions){
            if(!String.isEmpty(selArchitecture) && !String.isEmpty(selSubArchitecture)) {
                Map<String, Topic__c> currTopicMap = solutions.get(selArchitecture + selSubArchitecture);
                if(currTopicMap != null){
                    currTopic = currTopicMap.get(selSolution);
                }
            }
        } else {
            for(Topic__c topic : suggestSolutions){
                if(topic.Id == selSolution){
                    currTopic = topic;
                    break;
                }
            }
        }
        
        //If "Other", make Name editable
        if(currTopic != null && currTopic.Name != 'Other'){
            agnd.Name = currTopic.Name;
            editName = true;
        } else {
            agnd.Name = 'Presentation Name';
            editName = true;
        }
    }   
     /* Sudi - US9236 : added the below method
     @method: getter to retrieve Architecture options*/
    public List<SelectOption> getArchitectureOptions () {
        List <SelectOption> architectureOptions = new List<SelectOption>();
        
        System.debug('architectures size: ' + architectures.size());
        
        architectureOptions.add(new SelectOption('--None--','--None--'));
        for (String architecture : architectures) {
            architectureOptions.add(new SelectOption(architecture, architecture));
        }
        
        return architectureOptions;
    }
    public void setArchitectureOptions(List<SelectOption> input){}

    /* Sudi - US9236 : added the below method
    @method: getter to retrieve SubArchitecture options*/
    public List<SelectOption> getSubArchitectureOptions () {
        List<SelectOption> subArchitectureOptions = new List<SelectOption>();
        subArchitectureOptions.add(new SelectOption('--None--','--None--'));
                
        if (subArchitectures != null && subArchitectures.get(selArchitecture) != null) {
            for (String subArchitecture : subArchitectures.get(selArchitecture)) {
                subArchitectureOptions.add(new SelectOption(subArchitecture, subArchitecture));
            }
        } else {
            subArchitectureOptions.add(new SelectOption('Select an Architecture', 'Select an Architecture', true));
        }
        
        return subArchitectureOptions;
    }
    public void setSubArchitectureOptions(List<SelectOption> input){}
     public list<Agenda_Item__c> getAgendaItemsData(){
      return [SELECT id,name,Start_Date_Time__c,End_Date_Time__c,Topic_Name__c,Selected_Rooms_Display__c,presenters__c,
          Outlook_Status__c,CEE_Attendee__c 
          FROM Agenda_Item__c WHERE Customer_Engagements_Events__c=:aid];
    }
    /* Sudi - US9236 : added the below method
    @method: To validate the user selected Topic data or not*/
    public boolean reqFieldsValidation(){
        boolean status = false;
        if(selSolution == null || selSolution == ''){
            isExcep = true; 
            status = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Please select a solution topic.'));               
        }
        return status;
    }
}