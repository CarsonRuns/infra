/***************************************************************************************************
Name    : CEE_InviteController 
Author  : Eric Pesch
Purpose : Controller for the Agenda Item or Briefing 'Send Invite' Button/VF Page  
Created Date: Nov 15 2014
Modification History: 
Eric Pesch - Nov 15 2014: Initial Creation                     
*****************************************************************************************************/ 

public with sharing class CEE_InviteController {
    private static final String TAG = 'CEE_InviteController - ';
    private final String COMMAND = 'agenda_item_invite';
    
    //Standard controller variables
    private final ApexPages.StandardController controller;
    private Agenda_Item__c agendaItem; 
    private CEE__c briefing;
         
    public String envRoot { get; set; }
    public String sfdcEnv { get; set; }
    private Map<String, String> pageParameters;
    private String butCommand;
    private String recordType;
    private String recId;
    
    //Visibility parameters
    public boolean isLoading { get; set; }
    
    //Json parameters
    public String jsonParams { get; set; } 
    public String ifrUrl { get; set; }      
    public Map<String, Object> passedParams { get; set; }  
    
    /*@Constructor to the extension controller for the vf page
    * Grab variables based on current Agenda Item record */
    public CEE_InviteController(){
        //Get any passed in parameters (DELETE and MODIFY commands)
        PageReference pageRef = ApexPages.currentPage();
        pageParameters = pageRef.getParameters();   
        
        //Get button command
        if(pageParameters != null){
            butCommand = pageParameters.get('butCommand');
            recordType = pageParameters.get('recordType');
            recId = pageParameters.get('id');
        }
         
        passedParams = new Map<String, Object>(); 
        passedParams.put('command',this.COMMAND);
        
        //Standard Constructor
        if(recordType == 'Agenda_Item__c')
        {
            this.agendaItem = [select Id, Name, Start_Date_Time__c, End_Date_Time__c, Selected_Rooms_Display__c, Customer_Engagements_Events__c, Customer_Engagements_Events__r.Name
                                from Agenda_Item__c where Id =: recId];
           //Added as per WR
            this.briefing = [select Id, Name, Program_Manager__r.email, Program_Manager__r.name, EBC_CBC_Location__c, Start_Date_Time__c, End_Date_Time__c, Primary_FSO__c, Primary_FSO__r.Site_Time_Zone__c, Timezone__c from CEE__c where Id =: agendaItem.Customer_Engagements_Events__c];
            
            //Agenda Item - Availability Form
            passedParams.putAll(CEE_IframeUtility.addPrimaryTimezone(briefing));
            passedParams.putAll(CEE_IframeUtility.addAgendaItemInviteKeys(agendaItem,(String)passedParams.get('searchPrimaryTimezone')));
            passedParams.putAll(CEE_IframeUtility.addEnvironment(ApexPages.currentPage().getHeaders().get('Host')));
        } else if (recordType == 'CEE__c'){
            //Added as per WR
            this.briefing = [select Id, Name,Program_Manager__r.email, Program_Manager__r.name, EBC_CBC_Location__c, Start_Date_Time__c, End_Date_Time__c, Primary_FSO__c, Primary_FSO__r.Site_Time_Zone__c, Timezone__c from CEE__c where Id =: recId];
            //Agenda Item - Availability Form
            passedParams.putAll(CEE_IframeUtility.addPrimaryTimezone(briefing));
            if(passedParams!=null) 
            {
                passedParams.putAll(CEE_IframeUtility.addBriefingInviteKeys(briefing, true, true,(String)passedParams.get('searchPrimaryTimezone')));
            }
            passedParams.putAll(CEE_IframeUtility.addEnvironment(ApexPages.currentPage().getHeaders().get('Host')));            
        }
        this.isLoading = true;
       
        //Switch based on instance
        this.envRoot = Utilities.getConstant_CS('CEE Outlook URL');
        this.sfdcEnv = Utilities.getConstant_CS('CEE Environment');
        this.ifrUrl = this.envRoot + CEE_Utility.ROOT_URL_REDIRECT;
        

    }
    
    /*@method: action method to add DML operations (needs to be called separately) */
    public void addInvitationEmails(){
        //Check for alternate command
        passedParams.putAll(CEE_IframeUtility.addInvitations(butCommand, 
                            (String)passedParams.get('emailID'),
                            (String)passedParams.get('searchInvitation'), 
                            (String)passedParams.get('searchType')));
        
        // Now, replace the parameters with a Json format (encoded)
        jsonParams = JSON.serialize(passedParams);
        System.debug(TAG + 'jsonParams - ' + jsonParams);
        jsonParams = EncodingUtil.base64encode(Blob.valueof(jsonParams));
        System.debug(TAG + 'jsonParams encoded - ' + jsonParams);
    }
    
    /*@method: change url to redirect the iframe */
    public void changeUrl(){
        this.ifrUrl = envRoot + CEE_Utility.ROOT_URL_LOGIN + '?userID=' + UserInfo.getUserId() + '&userCecID=' + UserInfo.getUserEmail() +'&sessionID=' 
            + UserInfo.getSessionId() + '&command=' + this.COMMAND + '&env=' + this.sfdcEnv + '&butCommand=' + butCommand + '&jsonParams=' + jsonParams;
    }
    
    /*@method: rerender iframe loaded*/ 
    public void iframeLoaded(){
        isLoading = false;
    }
    
    /*@method: create correct back button URL*/    
    public Pagereference backMethod() {
        Pagereference pg = null;
        
        if(recordType == 'CEE__c'){
            pg =  new Pagereference('/apex/CEE_Briefing_InviteList?scontrolCaching=1&id=' + briefing.Id); // Include name of page where user should be navigated after clicking on Back button
        } else if(recordType == 'Agenda_Item__c'){
            pg = new PageReference('/' + agendaItem.Id);
        }
        
        pg.setRedirect(true);
        return pg;
    }
}