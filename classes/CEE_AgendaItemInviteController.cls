/***************************************************************************************************
Name    : CEE_AgendaItemAvailabilityController 
Author  : Eric Pesch
Purpose : Controller for the Agenda Item 'Send Invite' Button/VF Page  
Created Date: Nov 15 2014
Modification History: 
Eric Pesch - Nov 15 2014: Initial Creation      
Eric Pesch - Jan 5 2015: Added Comments, cleanup               
*****************************************************************************************************/ 

public with sharing class CEE_AgendaItemInviteController {
    private static final String TAG = 'CEE_AgendaItemInviteController - ';
    private final String COMMAND = 'agenda_item_invite';
    
    //Standard controller variables
    private final ApexPages.StandardController controller;
    private Agenda_Item__c agendaItem; 
    private CEE__c briefing;
         
    //URL parameters, commands
    public String envRoot { get; set; }
    public String sfdcEnv { get; set; }
    private String butCommand;
    private Map<String, String> pageParameters;
    
    //Visibility parameters
    public boolean isLoading { get; set; }
    
    //Json parameters
    public String jsonParams { get; set; } 
    public String ifrUrl { get; set; }      
    public Map<String, Object> passedParams { get; set; }  
    
    /* @Constructor to the extension controller for the vf page
    * Grab variables based on current Agenda Item record */
    public CEE_AgendaItemInviteController(ApexPages.StandardController stdController){
    	
        List<String> popFields = new List<String>{'Id', 'Customer_Engagements_Events__c', 
        		'Customer_Engagements_Events__r.Name',
                'Name', 'Start_Date_Time__c', 'End_Date_Time__c','Selected_Rooms_Display__c'};   
                
        //Get any passed in parameters (DELETE and MODIFY commands)
        PageReference pageRef = ApexPages.currentPage();
		pageParameters = pageRef.getParameters();   
		
		//Get button command
		if(pageParameters != null){
			butCommand = pageParameters.get('butCommand');
		}
        passedParams = new Map<String, Object>(); 
        passedParams.put('command',this.COMMAND);
        
        //Standard Constructor
        this.controller = stdController;
        if(!Test.isRunningTest()){
        	this.controller.addFields(popFields);
        }
        this.agendaItem = (Agenda_Item__c)stdController.getRecord(); 
        this.isLoading = true;
       
        //Switch based on instance
        this.envRoot = Utilities.getConstant_CS('CEE Outlook URL');
		this.sfdcEnv = Utilities.getConstant_CS('CEE Environment');
        this.ifrUrl = this.envRoot + CEE_Utility.ROOT_URL_REDIRECT;
        
        //Agenda Item - Availability Form
        briefing = [select Id, Name, EBC_CBC_Location__c, Primary_FSO__c, Primary_FSO__r.Site_Time_Zone__c, Timezone__c from CEE__c where Id =: agendaItem.Customer_Engagements_Events__c];
  		passedParams.putAll(CEE_IframeUtility.addPrimaryTimezone(briefing));
  		passedParams.putAll(CEE_IframeUtility.addAgendaItemInviteKeys(agendaItem, (String)passedParams.get('searchPrimaryTimezone')));
        passedParams.putAll(CEE_IframeUtility.addEnvironment(ApexPages.currentPage().getHeaders().get('Host')));
    }
    
    /*@method: Action method to add DML operations (needs to be called separately) */
    public void addInvitationEmails(){
    	//Check for alternate command
    	passedParams.putAll(CEE_IframeUtility.addInvitations(butCommand, 
    						(String)passedParams.get('emailID'),
    						(String)passedParams.get('searchInvitation'), 
    						(String)passedParams.get('searchType')));
        
        // Now, replace the parameters with a Json format (encoded)
        jsonParams = JSON.serialize(passedParams);
        //System.debug(TAG + 'jsonParams - ' + jsonParams);
        jsonParams = EncodingUtil.base64encode(Blob.valueof(jsonParams));
        //System.debug(TAG + 'jsonParams encoded - ' + jsonParams);
    }
    
    /*@method: Change url to redirect the iframe */
    public void changeUrl(){
        this.ifrUrl = envRoot + CEE_Utility.ROOT_URL_LOGIN + '?userID=' + UserInfo.getUserId() + '&userCecID=' + UserInfo.getUserEmail() +'&sessionID=' 
            + UserInfo.getSessionId() + '&command=' + this.COMMAND + '&env=' + this.sfdcEnv + '&butCommand=' + butCommand + '&jsonParams=' + jsonParams;
    }
    
    /*@method: Iframe loaded visibility rerender*/
    public void iframeLoaded(){
    	isLoading = false;
    }
    
    /*@method: Back button page reference generation*/
    public pagereference backMethod() {
		Pagereference pg =  new Pagereference('/' + agendaItem.Id); // Include name of page where user should be navigated after clicking on Back button
		pg.setRedirect(true);
		return pg;
	}
}