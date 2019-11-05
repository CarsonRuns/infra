/***************************************************************************************************
Name    : CEE_AgendaItemAvailabilityController 
Author  : Eric Pesch
Purpose : Controller for the Agenda Item 'Show Availability' Button/VF Page  
Created Date: Nov 15 2014
Modification History: 
Eric Pesch - Nov 15 2014: Initial Creation
Eric Pesch - Jan 5 2015: Added Comments, cleanup                     
*****************************************************************************************************/ 

public with sharing class CEE_AgendaItemAvailabilityController {
    private static final String TAG = 'CEE_AgendaItemAvailabilityController - ';
    private final String COMMAND = 'agenda_item_availability';
    
    //Controller standard vars
    private final ApexPages.StandardController controller;
    private Agenda_Item__c agendaItem; 
    public String envRoot { get; set; }
    public String sfdcEnv { get; set; }
    
    //Json parameters
    public String jsonParams { get; set; } 
    public String ifrUrl { get; set; }        
    
    //Iframe visibility
    public Boolean isFrameVisible { get; set; }
    
    /* @Constructor to the extension controller for the vf page
    * Grab variables based on current Agenda Item record */
    public CEE_AgendaItemAvailabilityController(ApexPages.StandardController stdController){
        List<String> popFields = new List<String>{'Id', 'Customer_Engagements_Events__c', 
                'Name', 'Start_Date_Time__c', 'End_Date_Time__c'};       
        Map<String, Object> passedParams = new Map<String, Object>();
        passedParams.put('command',this.COMMAND);
        
        //Constructors
        this.controller = stdController;
        if(!Test.isRunningTest()){
        	this.controller.addFields(popFields);
        }
        this.agendaItem = (Agenda_Item__c)stdController.getRecord(); 
        this.isFrameVisible = true;
        
        //Switch based on instance
        this.envRoot = Utilities.getConstant_CS('CEE Outlook URL');
		this.sfdcEnv = Utilities.getConstant_CS('CEE Environment');
        this.ifrUrl = this.envRoot + CEE_Utility.ROOT_URL_REDIRECT;
        
        //Agenda Item - Availability Form
        CEE__c briefing = [select Id, EBC_CBC_Location__c, Primary_FSO__c, Primary_FSO__r.Site_Time_Zone__c, Timezone__c from CEE__c where Id =: agendaItem.Customer_Engagements_Events__c];
        
        //Add parameters required by JVM  
        passedParams.putAll(CEE_IframeUtility.addAgendaSearchKeys(agendaItem));
        passedParams.putAll(CEE_IframeUtility.addPrimaryTimezone(briefing));
        passedParams.putAll(CEE_IframeUtility.addAgendaDates(agendaItem, (String)passedParams.get('searchPrimaryTimezone')));
        passedParams.putAll(CEE_IframeUtility.addAgendaTimes(agendaItem, (String)passedParams.get('searchPrimaryTimezone')));
        passedParams.putAll(CEE_IframeUtility.addPermissions());
        
        //Check if any resources actually added as part of Briefing
        if(String.isEmpty((String)passedParams.get('searchKey'))){
        	isFrameVisible = false;
        	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, System.Label.CEE_Availability_Empty_Exception));
        }
        
        // Now, replace the parameters with a Json format (encoded)
        jsonParams = JSON.serialize(passedParams);
        jsonParams = EncodingUtil.base64encode(Blob.valueof(jsonParams));
    }
    
    //Method change url to redirect the iframe 
    public void changeUrl(){
        this.ifrUrl = envRoot + CEE_Utility.ROOT_URL_LOGIN + '?userID=' + UserInfo.getUserId() + '&userCecID=' + UserInfo.getUserEmail() +'&sessionID=' 
            + UserInfo.getSessionId() + '&command='+ COMMAND + '&env=' + this.sfdcEnv + '&jsonParams=' + jsonParams;
    }
}