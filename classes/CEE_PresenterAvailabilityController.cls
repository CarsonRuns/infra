/***************************************************************************************************
Name    : CEE_PresenterAvailabilityController 
Author  : Eric Pesch
Purpose : CEE Attendee availabilty view  
Created Date: Dec 1 2014
Modification History: 
Eric Pesch - Jan 5 2015: Added Comments, cleanup                     
*****************************************************************************************************/

public with sharing class CEE_PresenterAvailabilityController {
    private static final String TAG = 'CEE_PresenterAvailabilityController - ';
    private final String COMMAND = 'agenda_item_availability';
    
    //Constructor variables
    private final ApexPages.StandardController controller;
    private final CEE_Attendee__c attendee; 
    public String envRoot { get; set; }
    public String sfdcEnv { get; set; }
    
    //Json parameters
    public String jsonParams { get; set; } 
    public String ifrUrl { get; set; }    
    
    //Iframe visibility parameter
    public Boolean isFrameVisible { get; set; }     
    
    /*@Constructor: Controller default variables*/
    public CEE_PresenterAvailabilityController(ApexPages.StandardController stdController){
        List<String> popFields = new List<String>{'Id', 'Name', 'Type__c', 'Salesforce_User__r.TimeZoneSidKey', 'Salesforce_User__r.Email'};   
        Map<String, Object> passedParams = new Map<String, Object>(); 
        passedParams.put('command',this.COMMAND);
        
        //Standard Constructors
        this.controller = stdController;
        if(!Test.isRunningTest()){
        	this.controller.addFields(popFields);
        }
        this.isFrameVisible = true;
        
        this.attendee = (CEE_Attendee__c)stdController.getRecord();
        
        if(attendee.Type__c != null && attendee.Type__c == 'Presenter'){
	        //System.debug(TAG + 'timezone: ' + this.attendee.Salesforce_User__r.TimeZoneSidKey);
	        //System.debug(TAG + 'Id: ' + this.attendee.Id);
	        //System.debug(TAG + 'Name: ' + this.attendee.Name);
	        //System.debug(TAG + 'Cisco Email: ' + this.attendee.Salesforce_User__r.Email);
	        String[] emailComponents = this.attendee.Salesforce_User__r.Email.split('@');
	        String cecID = emailComponents[0];
	        //System.debug(TAG + 'CEC ID: ' + cecID);
	        
	        //Switch on the url based on development environment
	        this.envRoot = Utilities.getConstant_CS('CEE Outlook URL');
			this.sfdcEnv = Utilities.getConstant_CS('CEE Environment');
	        this.ifrUrl = this.envRoot + CEE_Utility.ROOT_URL_REDIRECT;
	         
	        //Agenda Item - Availability Form
	        passedParams.putAll(CEE_IframeUtility.addPresenterSearchKeys(attendee));
	        //passedParams.putAll(CEE_IframeUtility.addPermissions());
	        
	        // Now, replace the parameters
	        jsonParams = JSON.serialize(passedParams);
	        jsonParams = EncodingUtil.base64encode(Blob.valueof(jsonParams));
        } else {
        	isFrameVisible = false;
        	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, 'You can only check the Availability of Attendees whose type is "Presenter"'));
        }
    }
    
    /*@method: Change url to redirect the iframe */
    public void changeUrl(){
        this.ifrUrl = envRoot + CEE_Utility.ROOT_URL_LOGIN + '?userID=' + UserInfo.getUserId() + '&userCecID=' + UserInfo.getUserEmail() +'&sessionID=' 
            + UserInfo.getSessionId() + '&command=' + this.COMMAND + '&env=' + this.sfdcEnv + '&jsonParams=' + jsonParams;
    }
}