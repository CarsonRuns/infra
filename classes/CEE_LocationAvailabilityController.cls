/***************************************************************************************************
Name    : CEE_LocationAvailabilityController 
Author  : Eric Pesch
Purpose : Controller for the CEE Location 'Room Availability' Button/VF Page  
Created Date: Nov 15 2014
Modification History: 
Eric Pesch - Nov 15 2014: Initial Creation
Eric Pesch - Jan 5 2015: Added Comments, cleanup                      
*****************************************************************************************************/ 

public with sharing class CEE_LocationAvailabilityController {
    //Static default variables
    private static final String TAG = 'CEE_LocationAvailabilityController - ';
    private final String COMMAND = 'agenda_item_availability';
    
    //Constructor variables
    private final ApexPages.StandardController controller;
    private final CEE_Location__c location; 
    public String envRoot { get; set; }
    public String sfdcEnv { get; set; }
    
    //Json parameters
    public String jsonParams { get; set; } 
    public String ifrUrl { get; set; }        
    
    /*@Constructor: standard intialization of availability location variables*/
    public CEE_LocationAvailabilityController(ApexPages.StandardController stdController){
        List<String> popFields = new List<String>{'Id', 'Name','Location_Type__c','Site_Time_Zone__c'};   
        Map<String, Object> passedParams = new Map<String, Object>(); 
        passedParams.put('command',this.COMMAND);
         
        //Standard Constructors
        this.controller = stdController;
        if(!Test.isRunningTest()){
        	this.controller.addFields(popFields);
        }
        this.location = (CEE_Location__c)stdController.getRecord(); 
        
        //Switch on the url based on development environment
        this.envRoot = Utilities.getConstant_CS('CEE Outlook URL');
		this.sfdcEnv = Utilities.getConstant_CS('CEE Environment'); 
        this.ifrUrl = this.envRoot + CEE_Utility.ROOT_URL_REDIRECT;
        
        //Agenda Item - Availability Form
        passedParams.putAll(CEE_IframeUtility.addLocationSearchKeys(location));
        passedParams.putAll(CEE_IframeUtility.addPermissions());
        
        System.debug(passedParams);
        
        // Now, replace the parameters
        jsonParams = JSON.serialize(passedParams);
        jsonParams = EncodingUtil.base64encode(Blob.valueof(jsonParams));
    }
    
    /*@method: change url to redirect the iframe */
    public void changeUrl(){
        this.ifrUrl = envRoot + CEE_Utility.ROOT_URL_LOGIN + '?userID=' + UserInfo.getUserId() + '&userCecID=' + UserInfo.getUserEmail() +'&sessionID=' 
            + UserInfo.getSessionId() + '&command=' + this.COMMAND + '&env=' + this.sfdcEnv + '&jsonParams=' + jsonParams;
    }
}