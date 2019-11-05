/***************************************************************************************************
Name    : CEE_AgendaItemController 
Author  : Eric Pesch
Purpose : Agenda Item Edit Page Visualforce Controller 
Created Date: Dec 1 2014
Modification History: 
May'2015 WR-01089 - bdabbara : Added doSaveNew() method for new "Save & New" button action
Eric Pesch - Jan 5 2015: Added Comments, cleanup     
Eric Pesch - Feb 13 2015: New Site-specific times stored on Agenda Item  
Sourabha - June 19 2015 CEE2: Added error message if Topic is null.              
*****************************************************************************************************/ 

public class CEE_AgendaItemController { 

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
    private final static String TAG = 'CEE_AgendaItemController - ';
    private Agenda_Item__c agenda; 
    private CEE__c briefing;
    private final ApexPages.StandardController controller; 
        
    //Page Name variables
    public Boolean editName { get; set; }    
        
    //Site variables
    private Map<String, Agenda_Room__c> roomMap;
    private Map<String, CEE_Invite__c> oldInvites;
    public String[] selectedRooms { get; set; }
    public Set<String> selectedSites { get; set; }
    
    //Topic variables
    public String selArchitecture { get; set;}
    public String selSubArchitecture { get; set;}
    public String selSolution { get; set; }
    public Boolean showFullSolutions { get; set; }
    
    //Variables holding maps of Topic tiers
    public Set<String> architectures;
    public Map<String, Set<String>> subArchitectures;
    public Map<String, Map<String, Topic__c>> solutions;
    private Set<Topic__c> suggestSolutions;
    
    //Time variables
    public String siteStartTime { get; set; }
    public String siteEndTime { get; set; }
    private Timezone currSiteTimezone;
    
    //Catering variables
    public Boolean displayCatering { get; set; }
    
    
    
    /*@method: Initial validation checks for the Agenda Item record*/
    public String inputValidation(Agenda_Item__c inputAgenda){
        String inputError = null;
        String siteDisplayStr = '';
        List<String> sites = new List<String>(selectedSites);
        
        //Input Validation 1 - Demos given in correct site
        //Commented Out until Production Data Given from Business - epesch 11-4-2014
        //Demo record types
        //Topic -> Location
        //Topic - Delivery Type = In-Person and Delivery Type = Telepresence
        try{
            /*Topic__c chosenTopic = [select id, name, organizing_principle__c from Topic__c where Id =: selSolution and IsActive__c = true];
            if(chosenTopic.organizing_principle__c == 'Demo'){
                //Add sites to query
                System.debug(TAG + 'sites - ' + sites);
                for(Integer i = 0; i < sites.size(); i++){
                    siteDisplayStr = siteDisplayStr + sites[i];
                    if(i != (selectedSites.size()-1)){
                        siteDisplayStr = '\'' +  siteDisplayStr + '\',';
                    }
                }
                System.debug(TAG + 'siteDisplayStr - ' + siteDisplayStr);
                
                //Query for demos
                Boolean isValid = false;
                if(!String.isEmpty(siteDisplayStr)){
                    List<CEE_Demo__c> activeDemos = [Select Id, Name, Delivery_Type__c From CEE_Demo__c Where Topic__c =: selSolution and CEE_Location__r.Name in (:siteDisplayStr)];
                   
                    for(CEE_Demo__c demo : activeDemos){
                        //Demo is valid if delivery types are the same or demo is in-person and delivery is telepresence
                        if((inputAgenda.Delivery_Method__c == demo.Delivery_Type__c) ||((inputAgenda.Delivery_Method__c == 'Telepresence' && demo.Delivery_Type__c == 'In-Person'))){
                            System.debug(TAG + 'found demo record - ' + demo.Id + ' ' + demo.Name);
                            isValid = true;
                            break;
                        }
                    }
                }
                
                //Check validity
                if (!isValid){
                    inputError = System.label.CEE_Demo_Availability_Exception;
                }
            }*/
        } catch (Exception e){
            System.debug(e.getStackTraceString());
        }
        
        return inputError;
    }
    
    /*@method: Save New behavior method*/
    public PageReference doSaveNew(){
        return doSave(true);
    }
    
    /*@method: Save behavior method*/
    public PageReference doSave(){
        return doSave(false);
    }
    
    /*@method: Generic Save method*/    
    public PageReference doSave(boolean isSaveNew){
        System.debug(TAG + 'doSave method start');        
        Agenda_Item__c agendaSave = (Agenda_Item__c)controller.getRecord();
        String selectSiteStr = '';
        String selectSiteDisplayStr = '';
        String selectRoomStr = '';
        String selectRoomDisplayStr = '';
        String cloneFlag = ApexPages.currentPage().getParameters().get('clone');
        
        //Validate agenda item input
        String validationMsg = inputValidation(agendaSave);
        System.debug(TAG + 'validationMsg - ' + validationMsg);
        if (!String.isEmpty(validationMsg)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, validationMsg));
            return null;
        }
        if(selSolution==null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Please select a solution topic.'));
            return null;
        }
        
        System.debug(agendaSave);
        //Add selected rooms to record
        if(selectedRooms != null){
            System.debug('selRoom - ' + selectedRooms);
            for(Integer i = 0; i < selectedRooms.size(); i++){
                String newLocation = roomMap.get(selectedRooms[i]).Room__r.CEE_Location__r.Id;
                
                //Add room info
                selectRoomStr = selectRoomStr + selectedRooms[i];
                selectRoomDisplayStr = selectRoomDisplayStr + roomMap.get(selectedRooms[i]).Room__r.Name;
                
                //Add location info
                if(!selectSiteStr.contains(newLocation)){
                    if(!String.isEmpty(selectSiteStr)){
                        selectSiteStr += ';';
                        selectSiteDisplayStr += ',';
                    }
                    selectSiteStr += newLocation;
                    selectSiteDisplayStr += roomMap.get(selectedRooms[i]).Room__r.CEE_Location__r.Name;
                }
                if(i != (selectedRooms.size()-1)){
                    selectRoomStr += ';';
                    selectRoomDisplayStr += ',';
                } 
            }
        }
        
        //Non-topic selection
        if(!String.isEmpty(selSolution) && selSolution != '--None--'){
        if(flsUpdateGet(Agenda_Item__c.Topic__c)||flsGet(Agenda_Item__c.Topic__c)) //SCAVA FIX
        {
            agendaSave.Topic__c = selSolution;
        }
        } else {
            agendaSave.Topic__c = null;
        }
        
        //Site information
        if(flsUpdateGet(Agenda_Item__c.Selected_Sites__c)||flsGet(Agenda_Item__c.Selected_Sites__c)) //SCAVA FIX
        {
        agendaSave.Selected_Sites__c = selectSiteStr;
        }
        if(flsUpdateGet(Agenda_Item__c.Selected_Sites_Display__c)||flsGet(Agenda_Item__c.Selected_Sites_Display__c))  //SCAVA FIX
        {
        agendaSave.Selected_Sites_Display__c = selectSiteDisplayStr;
        }
        if(flsUpdateGet(Agenda_Item__c.Selected_Rooms__c) || flsGet(Agenda_Item__c.Selected_Rooms__c))  //SCAVA FIX
        {
        agendaSave.Selected_Rooms__c = selectRoomStr;
        }
        if(flsUpdateGet(Agenda_Item__c.Selected_Rooms_Display__c)||flsGet(Agenda_Item__c.Selected_Rooms_Display__c))   //SCAVA FIX
        {
        agendaSave.Selected_Rooms_Display__c = selectRoomDisplayStr;
        }
        
        //NEW Feb 2015 - Site Timezone information
        if(briefing.Primary_FSO__c == null){            
            try{
                TimeZone userZone = UserInfo.getTimeZone();
                agendaSave.Start_Time_Site__c = CEE_Utility.convertUserTimeToUTC(agendaSave.Start_Date_Time__c, userZone, 
                    briefing.Timezone__c).format(CEE_Utility.TIME_FORMAT_ITCE);
                agendaSave.End_Time_Site__c = CEE_Utility.convertUserTimeToUTC(agendaSave.End_Date_Time__c, userZone, 
                    briefing.Timezone__c).format(CEE_Utility.TIME_FORMAT_ITCE);
            } catch (Exception e){
                System.debug(TAG + 'ITCE TimeZone Exception - ' + e.getStackTraceString());
            }
        } else {
            //EBC use case
            try{
            
            if(flsUpdateGet(Agenda_Item__c.Start_Time_Site__c) || flsGet(Agenda_Item__c.Start_Time_Site__c))   //SCAVA FIX
               {
                agendaSave.Start_Time_Site__c = agendaSave.Start_Date_Time__c.format(CEE_Utility.TIME_FORMAT_EBC, briefing.Primary_FSO__r.Site_Time_Zone__c);
                }
                if(flsUpdateGet(Agenda_Item__c.End_Time_Site__c)||flsGet(Agenda_Item__c.End_Time_Site__c))   //SCAVA FIX
               {
                agendaSave.End_Time_Site__c = agendaSave.End_Date_Time__c.format(CEE_Utility.TIME_FORMAT_EBC, briefing.Primary_FSO__r.Site_Time_Zone__c);
               }
            } catch (Exception e){
                System.debug(TAG + 'EBC Time Exception - ' + e.getStackTraceString());
            }
        }
        
        
        //Save the agenda item record
        try{
            if(agendaSave.Id == null){
                insert agendaSave;
            } else if(cloneFlag == '1'){
                agendaSave.id = null;
                insert agendaSave;            
            } else {
                update agendaSave;
            }
        } catch (DMLException e){
            System.debug(TAG + e.getStackTraceString());
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,e.getDmlMessage(0)));
            return null;
        }
        if(isSaveNew){
            string ceefieldName = Utilities.getConstant_CS('CEEFieldName');
            string ceefieldId = Utilities.getConstant_CS('CEEFieldID');
            String  redirectURL = '/apex/CEE_AgendaItem_Edit?'+ceefieldName+'='+agendaSave.Customer_Engagements_Events__c+'&'+ceefieldId+'='+agendaSave.Customer_Engagements_Events__c+'&scontrolCaching=1&retURL=%2F'+agendaSave.Customer_Engagements_Events__c+'&sfdc.override=1';
            PageReference newPgae = new PageReference(redirectURL);
            newPgae.setRedirect(true);
            return newPgae;
        }else{
            return new PageReference('/'+agendaSave.Customer_Engagements_Events__c);
        }       
        return null;
    }    
    
    /*@Constructor: Constructor for the VF page controller*/
    public CEE_AgendaItemController(ApexPages.StandardController stdController){
        System.debug(TAG + 'Constructor method start');
        
        //Populate standard variables
        List<String> popFields = new List<String>{'Catering_Attendees__c', 'Catering_Department_Code__c', 'Selected_Sites__c', 'Selected_Rooms__c', 'Topic__c', 'Topic__r.Name', 
                                                'Start_Date_Time__c', 'End_Date_Time__c'};       
        this.controller = stdController;
        if(!Test.isRunningTest()){
            this.controller.addFields(popFields);
        }
        this.agenda = (Agenda_Item__c)stdController.getRecord();        
        this.roomMap = new Map<String, Agenda_Room__c>(); 
        this.oldInvites = new Map<String, CEE_Invite__c>();
        this.editName = false;
        this.showFullSolutions = false;
        this.displayCatering = false;
        
        //Get Briefing object
        try{
            this.briefing = [select ID, Primary_FSO__c, Primary_FSO__r.Site_Time_Zone__c, Primary_FSO__r.Department_Code__c, EBC_CBC_Location__c, Timezone__c, Total_Attendees__c, Start_Date_Time__c, 
                            End_Date_Time__c, Sub_Architecture__c from CEE__c where ID =: agenda.Customer_Engagements_Events__c];
            System.debug(TAG + 'Briefing - ' + this.briefing);
        } catch (Exception e){
            System.debug(e.getStackTraceString());
            this.agenda.addError(e.getMessage());
        }
        
        //Populate old multi-select dynamic fields
        if(agenda.Selected_Sites__c != null){
            this.selectedSites = new Set<String>(agenda.Selected_Sites__c.split(';'));
        } else {
            this.selectedSites = new Set<String>();
        }
        
        if(agenda.Selected_Rooms__c != null){
            this.selectedRooms = agenda.Selected_Rooms__c.split(';');
        } else {
            this.selectedRooms = new List<String>();
        }
        
        //Populate everything topic related
        architectures = new Set<String>();
        subArchitectures = new Map<String, Set<String>>();
        solutions = new Map<String, Map<String, Topic__c>>();
        try{
            List<Topic__c> topicList = [select Architecture__c, Sub_Architecture__c, Name 
                            From Topic__c where Architecture__c != null 
                            AND Sub_Architecture__c != null
                            AND IsActive__c =: true 
                            ORDER BY Architecture__c, Sub_Architecture__c, Name ];                             
           
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
        } catch (Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, 'We were unable to retrieve the Topics list - please contact a System Administrator'));
            System.debug(e.getStackTraceString());
        }
        
        //Get current Agenda Item's topic
        this.suggestSolutions = new Set<Topic__c>();
        if(agenda.Topic__c != null)
        {
            try{
                Topic__c selTopic = [Select Architecture__c, Sub_Architecture__c, Name 
                            From Topic__c where Id =: agenda.Topic__c]; 
                selSolution = agenda.Topic__c;
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
        
        //ENHANCEMENT 2/23/2015 - default to allow Arch/Sub-Arch selection if not suggestions
        if(suggestSolutions.size() == 0){
            this.showFullSolutions = true;
        }
        
        //Get Name value
        if(agenda.Name != null){
            if(agenda.Topic__r.Name == 'Other'){
                editName = true;
            }
        }
        if(briefing!=null){
            //Default time values
            if(agenda.Start_Date_Time__c == null)
            {
                agenda.Start_Date_Time__c = briefing.Start_Date_Time__c;
                agenda.End_Date_Time__c = briefing.End_Date_Time__c;
            }
            
        //Populate Agenda Rooms
            try{
                List<Agenda_Room__c> rooms = [select Id, Name, Room__c, Room__r.Name, Room__r.CEE_Location__c, Room__r.CEE_Location__r.Name, Room__r.CEE_Location__r.Id
                                                from Agenda_Room__c where Customer_Engagements_Events__c =: briefing.Id];
                if(rooms != null && rooms.size() > 0){
                    for(Agenda_Room__c room : rooms){
                        roomMap.put(room.Id, room);
                    }
                }
                
                List<CEE_Invite__c> invites = [select Id, Name, Room__c, Outlook_Status__c from CEE_Invite__c where Room__c in : rooms];
                if(invites != null && invites.size() > 0){
                    for(CEE_Invite__c invite : invites){
                        oldInvites.put(invite.Room__c, invite);
                    }   
                }
                
            } catch (Exception e)
            {
                System.debug(TAG + 'No Agenda Rooms found - ' + e.getStackTraceString());
            }
        }
        
        //Load Catering layout if already populated with information
        if((agenda.Catering_Type__c != null && agenda.Catering_Type__c != 'No Food') || agenda.Catering_Funding__c != null 
                    || agenda.Catering_Funding__c !=null || agenda.Catering_Cost_Per_Person__c != null){
            this.displayCatering = true;
        }
        
        refreshTimes();
    }
    
    public void refreshTimes(){
        //Populate timezone information 
        siteStartTime = CEE_Utility.calcSiteTime(briefing, agenda.Start_Date_Time__c);
        siteEndTime = CEE_Utility.calcSiteTime(briefing, agenda.End_Date_Time__c);
    }
    
    /*@method: getter for dynamic rooms list*/
    public List<SelectOption> getDynRooms(){
        List<SelectOption> options = new List<SelectOption>();
        if(roomMap.values() != null){
            for(Agenda_Room__c room : roomMap.values()){
                if(room != null){
                    options.add(new SelectOption(room.Id, 'Invite: ' + oldInvites.get(room.Id).Outlook_Status__c + ' - ' + room.Room__r.Name));
                }
            }
        }
        
        if(options.size() == 0){
            options.add(new SelectOption('', 'No Rooms added for this Briefing', true));
        }
        
        return options;
    }
    public void setDynRooms(List<SelectOption> rooms){}
    
    /*@method: Populate sites as Rooms are selected*/
    public void populateSites(){
        selectedSites.clear();
        for(Integer i = 0; i < selectedRooms.size(); i++){
            selectedSites.add(roomMap.get(selectedRooms[i]).Room__r.CEE_Location__r.Name);
        }
    }
    
    /*@method: Populate Catering data based on site*/
    public void populateCatering(){
        Set<String> values = selectedSites;
        
        //Default to briefing total attendees, if not populated already
        if(agenda.Catering_Attendees__c == null || agenda.Catering_Attendees__c == 0)
            agenda.Catering_Attendees__c = briefing.Total_Attendees__c;
        
        //Find a department code if possible
        if(values != null){
            for(String s : values){
                s = s.trim();
    
                //Populate department code
                if(briefing.Primary_FSO__r.Department_Code__c != null && (agenda.Catering_Department_Code__c == null || agenda.Catering_Department_Code__c == '' )
                        && agenda.Catering_Funding__c == 'EBC Funded'){
                    agenda.Catering_Department_Code__c = briefing.Primary_FSO__r.Department_Code__c;
                } 
            }
        } 
        
        //If still empty, default to empty code
        if(String.isEmpty(agenda.Catering_Department_Code__c)){
            agenda.Catering_Department_Code__c = 'Enter manually';
        }
    }
     
    /*@method: Check to see if Agenda_Item__c.Name is an editable*/
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
            agenda.Name = currTopic.Name;
            editName = true;
        } else {
            agenda.Name = 'Presentation Name';
            editName = true;
        }
    }   
    
    /*@method: getter to retrieve Architecture options*/
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

    /*@method: getter to retrieve SubArchitecture options*/
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

    /*@method: Retrieve solutions based on what has been chosen (full OR suggested solutions)*/
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
            
            if(solutionOptions.size() == 0) {
                solutionOptions.add(new SelectOption('Select an Architure/Sub-Architecture','Select an Architure/Sub-Architecture', true));
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
    public void setSolutionOptions(List<SelectOption> input){}
}