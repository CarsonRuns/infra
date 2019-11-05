/***************************************************************************************************
Name    : CEE_AvailabilityController 
Author  : Eric Pesch
Purpose : Controller for the Agenda Item 'Show Availability' Button/VF Page  
Created Date: Nov 15 2014
Modification History: Eric Pesch Nov 15 2014 Initial Creation                     
*****************************************************************************************************/ 

public with sharing class CEE_AvailabilityController {
	//General page constants
    private static final String TAG = 'CEE_AvailabilityController - ';
    private final String COMMAND = 'agenda_item_availability';
    
    //Controller standard vars
    private final ApexPages.StandardController controller;
    private CEE__c briefing; 
    public String envRoot { get; set; }
    public String sfdcEnv { get; set; }
    
    //Json parameters
    public String jsonParams { get; set; } 
    public String ifrUrl { get; set; }       
    
    //Iframe visibility
    public Boolean isFrameVisible { get; set; } 
    
    /* @Constructor to the extension controller for the vf page
    * Grab variables based on current Agenda Item record */
    public CEE_AvailabilityController(ApexPages.StandardController stdController){
        List<String> popFields = new List<String>{'Id', 'EBC_CBC_Location__c', 'Primary_FSO__c', 'Primary_FSO__r.Site_Time_Zone__c', 'Timezone__c', 'Name', 'Start_Date_Time__c', 'End_Date_Time__c'};       
        Map<String, Object> passedParams = new Map<String, Object>();
        passedParams.put('command',this.COMMAND);
        
        //Constructors
        this.controller = stdController;
        if(!Test.isRunningTest()){
        	this.controller.addFields(popFields);
        }
        this.briefing = (CEE__c)stdController.getRecord(); 
        this.isFrameVisible = true;
        
        //Switch based on instance
        this.envRoot = Utilities.getConstant_CS('CEE Outlook URL');
		this.sfdcEnv = Utilities.getConstant_CS('CEE Environment');
        this.ifrUrl = this.envRoot + CEE_Utility.ROOT_URL_REDIRECT;
        
        //CEE - Availability Form variables
        passedParams.putAll(CEE_IframeUtility.addBriefingSearchKeys(briefing));
        passedParams.putAll(CEE_IframeUtility.addPrimaryTimezone(briefing));
        passedParams.putAll(CEE_IframeUtility.addBriefingDates(briefing, (String)passedParams.get('searchPrimaryTimezone')));
        passedParams.putAll(CEE_IframeUtility.addBriefingTimes(briefing, (String)passedParams.get('searchPrimaryTimezone')));
        passedParams.putAll(CEE_IframeUtility.addPermissions());
        
        if(String.isEmpty((String)passedParams.get('searchKey'))){
        	isFrameVisible = false;
        	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, System.Label.CEE_Availability_Empty_Exception));
        }
        
        // Now, replace the parameters with a Json format (encoded)
        jsonParams = JSON.serialize(passedParams);
        jsonParams = EncodingUtil.base64encode(Blob.valueof(jsonParams));
    }
    
    /*@method: Change url to redirect the iframe*/ 
    public void changeUrl(){
        this.ifrUrl = envRoot + CEE_Utility.ROOT_URL_LOGIN + '?userID=' + UserInfo.getUserId() + '&userCecID=' + UserInfo.getUserEmail() +'&sessionID=' 
            + UserInfo.getSessionId() + '&command='+ COMMAND + '&env=' + this.sfdcEnv + '&jsonParams=' + jsonParams;
    }
}