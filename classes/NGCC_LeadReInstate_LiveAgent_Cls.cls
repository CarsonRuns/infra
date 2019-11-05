/************************************************************************************************************************************
@Name    : NGCC_LeadReInstate_LiveAgent_Cls
@Author  : Fazurulla Ganganapalli
@Purpose : This class is responsible for the management of Lead Re-Instate Lead Re-Open Process and LiveAgent Business Rules 
@Created Date: 1/19/2017
@Modification History: 
1. 	Author  : Ghattamaneni Chaithanya
	Purpose : Scava Fixes
	Changes : 
		1. Added SCAVA Helper Methods
		2. Added SCAVA Fixes in cmdSubmit(),cmdMultpleleadsBtn() methods
	date    : Oct 15,2018

*************************************************************************************************************************************/

public class NGCC_LeadReInstate_LiveAgent_Cls{
    //Variable declaration
    public Lead    leads {get;set;}
    public Id      leadId {get;set;}
    public String  leadStatus {get;set;}
    public string leadStatusChoice {get;set;}
    public boolean showSingleChoice{get;set;} 
    public boolean showMultipleChoice{get;set;}
    public boolean showMessage {get;set;}
    public string multiLeadList {get;set;}
    public list<lead> leadList {get;set;}
    public List<lead> leadListMultiple {get;set;}
    public boolean showPageBlockTable {get;set;}
    public string userName {get;set;}
    public Id userStringId {get;set;}
    public List<string> conditions = new List<string>();
    public string strQuery {get;set;}
    public list<skilluser> lis {get;set;}
    public boolean showSkillTable {get;set;}
    public boolean showTable {get;set;}
    public string userNameWithCondition;
    public List<User> skilUserDetails {get;set;}
    public string tempConcatenate {get;set;}
    public String liveAgentUserQuery {get;set;}
    public boolean isSkillSearchButtonDisabled {get;set;}
    public NGCC_LeadReInstate_LiveAgent_Cls(){   
        showTable = false;  
        showSkillTable = false;
        isSkillSearchButtonDisabled = true;
    }
    //Constructor : This will hold some pre-dified variables and display at the time of loading a page.
    public NGCC_LeadReInstate_LiveAgent_Cls(ApexPages.StandardController controller){
        leads = new lead();
        showSingleChoice  = false;
        showMultipleChoice = false;
        showMessage = true;
        showPageBlockTable = false;
    }
    //@Method : This method will be going to responsible for changing the lead record type,owner id,status fields.
    public pagereference cmdSubmit(){
        try{
            if(leadStatus == '--None--'){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,'Please select lead status'));
            }else{
                if(leadId.getSObjectType().getDescribe().getName()=='Lead'){
                    List<lead> leadList = [select id,recordtypeid,ownerid from lead where id=:leadid limit 1];
                    if(!leadList.isEmpty()){
                        Lead l  = new Lead ();
                        l.id = leadList[0].id;
                        //SCAVA Fix
                        if(flsUpdateGet(lead.recordtypeid)){
                            l.recordtypeid = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
                        }
                        if(flsUpdateGet(lead.ownerid)){
                            l.ownerid = leads.ownerid;
                        }
                        if(flsUpdateGet(lead.status)){
                            l.status = leadStatus;
                        }
                        if(flsUpdateGet(lead.Call_Status__c)){
                            l.Call_Status__c = 'Open';
                        } //SCAVA Fix
                        database.update(l,false);       
                        return new pagereference('/'+l.id);
                    }
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'You have entered invalid lead id '+leadId.getSObjectType().getDescribe().getName()));
                }
            }                     
        }catch(exception e){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Something went wrong :'+e.getMessage()));
        }
    return null;
    }
    
    //@Method : This method is responsible for hide or show page blocks based on picklist values.
    public void cmdChoiceBtn(){
        if(leadStatusChoice == 'Single Lead'){
            showSingleChoice = true;
            showMultipleChoice = false;
            showMessage = false;
            showPageBlockTable = false;
        }else if(leadStatusChoice == 'Multiple Leads'){
            showMultipleChoice = true;
            showSingleChoice = false;
            showMessage = false;
            showPageBlockTable = false;
        }else{
            showMultipleChoice = false;
            showSingleChoice = false;
            showMessage = true;
            showPageBlockTable = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Please select correct value'));
        }
    }   
    
    //@Method : This method is responsible for updating leads in a bulk format.
    public void cmdMultpleleadsBtn(){
        try{
            List<String> setLeadIds = multiLeadList.split(',');
            leadList = new list<lead>();
            leadListMultiple  = [select id,recordtypeid,ownerid from lead where Id IN :setLeadIds];
            if(leadStatus == '--None--'){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,'Please select lead status'));
            }else{
                if(!leadListMultiple.isEmpty()){
                    for(lead l1 : leadListMultiple ){
                        lead l = new lead();
                        l.id = l1.id;
                        //SCAVA Fix
                        if(flsUpdateGet(lead.recordtypeid)){
                        	l.recordtypeid = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
                        }
                        if(flsUpdateGet(lead.ownerid)){
                        	l.ownerid = leads.ownerid;
                        }
                        if(flsUpdateGet(lead.status)){
                        	l.status = leadStatus;
                        }
                        if(flsUpdateGet(lead.Call_Status__c)){
                            l.Call_Status__c = 'Open';
                        } //SCAVA Fix
                        leadList.add(l);
                    }
                    database.update(leadList,false);
                    showPageBlockTable = true;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Records Updated Successfully!'));
                }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Invalid Lead Ids'));
                }
            }
        }catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Something went wrong :'+e.getMessage()));
        }
    }
    public string teststring {get;set;}
    public void search(){
        teststring = 'test value';
    }
    public list<LiveChatUserConfigUser> chatCapacityList {get;set;}
    public void cmdSearchButton(){
        try{
            getQuery();
            lis = database.query(strQuery);
            chatCapacityList = database.query(liveAgentUserChatCapacityQuery);
            if(!lis.isEmpty()){
                showTable = true;
                showSkillTable = true;
            }  
            if(!chatCapacityList.isEmpty()){
                showTable = true;
                showSkillTable = true;
            }
        }catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,+e.getmessage()));
        }
    }
    public void cmdUserHasLiveAgentAccess(){
        liveAgentUserQuery = 'SELECT Id,isActive,name,UserPermissionsLiveAgentUser,USERPERMISSIONSSUPPORTUSER FROM User';
        if(String.isNotBlank(userName)){
            liveAgentUserQuery  += ' WHERE username LIKE \''+userName+'@cisco.com'+ '%\' ';
        }else if(String.isNotBlank(userStringId)){
            if(userStringId.getSObjectType().getDescribe().getName()=='User'){
            liveAgentUserQuery  += ' WHERE ID = \'' +userStringId+ '\' ';
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info,'Selected ID belongs to '+userStringId.getSObjectType().getDescribe().getName()+' object not belongs to User Object'));
            liveAgentUserQuery  += ' WHERE ID  = \'' +userStringId+ '\' ';
        }
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info,'Please Enter CEC ID or User 15-Digit ID <img src="/img/msg_icons/error16.png"/>'));
        }
        liveAgentUserQuery  += ' LIMIT 1';
        skilUserDetails = database.query(liveAgentUserQuery);
        if(!skilUserDetails.isEmpty()&&skilUserDetails.size()>0){
            isSkillSearchButtonDisabled = false;
            if(skilUserDetails[0].isActive){
                showSkillTable = false;
                showTable = false;
                if(skilUserDetails[0].UserPermissionsLiveAgentUser && skilUserDetails[0].USERPERMISSIONSSUPPORTUSER){                  
                if(skilUserDetails[0].isActive)
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info,'Is Active User ? <img src="/img/func_icons/util/checkmark16.gif"/>'));
                else
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info,'Is Active User ? <img src="/img/msg_icons/error16.png"/>'));

                if(skilUserDetails[0].USERPERMISSIONSSUPPORTUSER)
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info,'Service Cloud User <img src="/img/func_icons/util/checkmark16.gif"/>'));  
                else
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info,'Service Cloud User <img src="/img/msg_icons/error16.png"/>'));

                if(skilUserDetails[0].UserPermissionsLiveAgentUser) 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info,'Live Agent User <img src="/img/func_icons/util/checkmark16.gif"/>'));
                else
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info,'Live Agent User <img src="/img/msg_icons/error16.png"/>'));
                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info,'Quick Search For User Details : <a href="/'+skilUserDetails[0].id+'/e?isUserEntityOverride=1" target="_blank"   onblur="LookupHoverDetail.getHover('+skilUserDetails[0].id+').hide();" >'+skilUserDetails[0].name+'<img src="/img/func_icons/util/search16.png"/></a>'));
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info,'Quick Search For User Details : <a href="/'+skilUserDetails[0].id+'/e?isUserEntityOverride=1" target="_blank">'+skilUserDetails[0].name+'<img src="/img/func_icons/util/search16.png"/></a>'));
                }else{
                if(skilUserDetails[0].isActive)
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info,'Is Active User ? <img src="/img/func_icons/util/checkmark16.gif"/>'));
                else
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info,'Is Active User ? <img src="/img/msg_icons/error16.png"/>'));

                if(skilUserDetails[0].USERPERMISSIONSSUPPORTUSER)
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info,'Service Cloud User <img src="/img/func_icons/util/checkmark16.gif"/>'));  
                else
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info,'Service Cloud User <img src="/img/msg_icons/error16.png"/>'));

                if(skilUserDetails[0].UserPermissionsLiveAgentUser) 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info,'Live Agent User <img src="/img/func_icons/util/checkmark16.gif"/>'));
                else
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info,'Live Agent User <img src="/img/msg_icons/error16.png"/>'));

                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info,'Quick Search For User Details : <a href="/'+skilUserDetails[0].id+'/e?isUserEntityOverride=1" target="_blank">'+skilUserDetails[0].name+'<img src="/img/func_icons/util/search16.png"/></a> '));
                }  
            }else{
            showSkillTable = false;
            showTable = false;
            if(String.isNotBlank(userName))                   
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info,'Entered Details Are Valid ? <img src="/img/func_icons/util/checkmark16.gif"/>'));

            if(skilUserDetails[0].isActive)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info,'Is Active User ? <img src="/img/func_icons/util/checkmark16.gif"/>'));
            else
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info,'Is Active User ? <img src="/img/msg_icons/error16.png"/>'));

            if(skilUserDetails[0].USERPERMISSIONSSUPPORTUSER)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info,'Service Cloud User <img src="/img/func_icons/util/checkmark16.gif"/>'));  
            else
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info,'Service Cloud User <img src="/img/msg_icons/error16.png"/>'));

            if(skilUserDetails[0].UserPermissionsLiveAgentUser) 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info,'Live Agent User <img src="/img/func_icons/util/checkmark16.gif"/>'));
            else
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info,'Live Agent User <img src="/img/msg_icons/error16.png"/>'));

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info,'Searching User Was Inactive At This Moment <img src="/img/msg_icons/error16.png"/>')); 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info,'Please Active And Try Again : <a href="/'+skilUserDetails[0].id+'/e?isUserEntityOverride=1" target="_blank">'+skilUserDetails[0].Name+'<img src="/img/func_icons/util/search16.png"/></a> '));
            }    
        }else{
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info,'User Doesn\'t exist in the Database..Please Try To Create New Account'));
        showSkillTable = false;
        showTable = false;
        }
    }
    public string liveAgentUserChatCapacityQuery {get;set;}
    public string getQuery() {
        strQuery = 'SELECT Id,skillid,USERID,USER.name,USER.username,USER.Marketing_Call_Center__c,user.userroleid FROM SKILLUSER ';
        liveAgentUserChatCapacityQuery = 'select id,UserId,LiveChatUserConfig.MasterLabel,user.name,user.username,LiveChatUserConfigId,LiveChatUserConfig.Language,LiveChatUserConfig.Capacity from LiveChatUserConfigUser';
        
        if(String.isNotBlank(userName)){
            strQuery += 'WHERE USER.username LIKE \''+userName+'@cisco.com'+ '%\' ';
            liveAgentUserChatCapacityQuery +=' WHERE user.username LIKE \''+userName+'@cisco.com'+ '%\' ';
            
            showSkillTable = true;
            showTable = true;
        }else if(String.isNotBlank(userStringId)){
            if(userStringId.getSObjectType().getDescribe().getName()=='User'){
                strQuery += 'WHERE USERID = \'' +userStringId+ '\' ';
                liveAgentUserChatCapacityQuery +=' WHERE userid = \'' +userStringId+ '\' ';
                
                showSkillTable = true;
                showTable = true;
            }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info,'Selected ID belongs to '+userStringId.getSObjectType().getDescribe().getName()+' object not belongs to User Object'));
            strQuery += 'WHERE USERID = \'' +userStringId+ '\' ';
            liveAgentUserChatCapacityQuery += ' WHERE USERID  = \'' +userStringId+ '\' ';
            
            showSkillTable = false;
            showTable = true;
            }
        }else{
            strQuery += 'WHERE USER.username = \'' +userName+ '\' OR USERID = \'' +userStringId+ '\' ';
            liveAgentUserChatCapacityQuery += ' WHERE USER.username = \'' +userName+ '\' OR USERID = \'' +userStringId+ '\' ';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info,'Please Select CEC ID or User ID'));
            showSkillTable = false;
            showTable = true;
        }
        strQuery += ' ORDER BY skillid ASC';
        liveAgentUserChatCapacityQuery += ' ORDER BY user.username ASC';
        return strQuery;
    }
 //@method for drop down menu when creating a response, ghost chat/ghost call selected note dropdown menu will appear.
    public void CustomPicklistForNotes() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('- Not Specified -','- Not Specified -'));
            options.add(new SelectOption('Technical Support','Technical Support'));
            options.add(new SelectOption('Customer Service','Customer Service'));
            options.add(new SelectOption('Other - Chat','Other - Chat'));
            options.add(new SelectOption('Partner','Partner'));
            options.add(new SelectOption('System Integrator','System Integrator'));
            options.add(new SelectOption('Complaint','Complaint'));
            options.add(new SelectOption('Customer Dropped Off','Customer Dropped Off'));
            options.add(new SelectOption('Customer Followed Up','Customer Followed Up'));
            options.add(new SelectOption('Customer made bad call','Customer made bad call'));
            options.add(new SelectOption('- Not Specified -','- Not Specified -'));
            options.add(new SelectOption('Technical Support','Technical Support'));
            options.add(new SelectOption('Customer Service','Customer Service'));
            options.add(new SelectOption('Other - Chat','Other - Chat'));
            options.add(new SelectOption('Partner','Partner'));
            options.add(new SelectOption('System Integrator','System Integrator'));
            options.add(new SelectOption('Complaint','Complaint'));
            options.add(new SelectOption('Customer Dropped Off','Customer Dropped Off'));
            options.add(new SelectOption('Customer Followed Up','Customer Followed Up'));
            options.add(new SelectOption('Customer made bad call','Customer made bad call'));
            options.add(new SelectOption('- Not Specified -','- Not Specified -'));
            options.add(new SelectOption('Technical Support','Technical Support'));
            options.add(new SelectOption('Customer Service','Customer Service'));
            options.add(new SelectOption('Other - Chat','Other - Chat'));
            options.add(new SelectOption('Partner','Partner'));
            options.add(new SelectOption('System Integrator','System Integrator'));
            options.add(new SelectOption('Complaint','Complaint'));
            options.add(new SelectOption('Customer Dropped Off','Customer Dropped Off'));
            options.add(new SelectOption('Customer Followed Up','Customer Followed Up'));
            options.add(new SelectOption('Customer made bad call','Customer made bad call'));
            options.add(new SelectOption('- Not Specified -','- Not Specified -'));
            options.add(new SelectOption('Technical Support','Technical Support'));
            options.add(new SelectOption('Customer Service','Customer Service'));
            options.add(new SelectOption('Other - Chat','Other - Chat'));
            options.add(new SelectOption('Partner','Partner'));
            options.add(new SelectOption('System Integrator','System Integrator'));
            options.add(new SelectOption('Complaint','Complaint'));
            options.add(new SelectOption('Customer Dropped Off','Customer Dropped Off'));
            options.add(new SelectOption('Customer Followed Up','Customer Followed Up'));
            options.add(new SelectOption('Customer made bad call','Customer made bad call'));
            options.add(new SelectOption('- Not Specified -','- Not Specified -'));
            options.add(new SelectOption('Technical Support','Technical Support'));
            options.add(new SelectOption('Customer Service','Customer Service'));
            options.add(new SelectOption('Other - Chat','Other - Chat'));
            options.add(new SelectOption('Partner','Partner'));
            options.add(new SelectOption('System Integrator','System Integrator'));
            options.add(new SelectOption('Complaint','Complaint'));
            options.add(new SelectOption('Customer Dropped Off','Customer Dropped Off'));
            options.add(new SelectOption('Customer Followed Up','Customer Followed Up'));
            options.add(new SelectOption('Customer made bad call','Customer made bad call'));
            options.add(new SelectOption('- Not Specified -','- Not Specified -'));
            options.add(new SelectOption('Technical Support','Technical Support'));
            options.add(new SelectOption('Customer Service','Customer Service'));
            options.add(new SelectOption('Other - Chat','Other - Chat'));
            options.add(new SelectOption('Partner','Partner'));
            options.add(new SelectOption('System Integrator','System Integrator'));
            options.add(new SelectOption('Complaint','Complaint'));
            options.add(new SelectOption('Customer Dropped Off','Customer Dropped Off'));
            options.add(new SelectOption('Customer Followed Up','Customer Followed Up'));
            options.add(new SelectOption('Customer made bad call','Customer made bad call'));
            options.add(new SelectOption('- Not Specified -','- Not Specified -'));
            options.add(new SelectOption('Technical Support','Technical Support'));
            options.add(new SelectOption('Customer Service','Customer Service'));
            options.add(new SelectOption('Other - Chat','Other - Chat'));
            options.add(new SelectOption('Partner','Partner'));
            options.add(new SelectOption('System Integrator','System Integrator'));
            options.add(new SelectOption('Complaint','Complaint'));
            options.add(new SelectOption('Customer Dropped Off','Customer Dropped Off'));
            options.add(new SelectOption('Customer Followed Up','Customer Followed Up'));
            options.add(new SelectOption('Customer made bad call','Customer made bad call'));
            options.add(new SelectOption('- Not Specified -','- Not Specified -'));
            options.add(new SelectOption('Technical Support','Technical Support'));
            options.add(new SelectOption('Customer Service','Customer Service'));
            options.add(new SelectOption('Other - Chat','Other - Chat'));
            options.add(new SelectOption('Partner','Partner'));
            options.add(new SelectOption('System Integrator','System Integrator'));
            options.add(new SelectOption('Complaint','Complaint'));
            options.add(new SelectOption('Customer Dropped Off','Customer Dropped Off'));
            options.add(new SelectOption('Customer Followed Up','Customer Followed Up'));
            options.add(new SelectOption('Customer made bad call','Customer made bad call'));
            options.add(new SelectOption('- Not Specified -','- Not Specified -'));
            options.add(new SelectOption('Technical Support','Technical Support'));
            options.add(new SelectOption('Customer Service','Customer Service'));
            options.add(new SelectOption('Other - Chat','Other - Chat'));
            options.add(new SelectOption('Partner','Partner'));
            options.add(new SelectOption('System Integrator','System Integrator'));
            options.add(new SelectOption('Complaint','Complaint'));
            options.add(new SelectOption('Customer Dropped Off','Customer Dropped Off'));
            options.add(new SelectOption('Customer Followed Up','Customer Followed Up'));
            options.add(new SelectOption('Customer made bad call','Customer made bad call'));
            options.add(new SelectOption('- Not Specified -','- Not Specified -'));
            options.add(new SelectOption('Technical Support','Technical Support'));
            options.add(new SelectOption('Customer Service','Customer Service'));
            options.add(new SelectOption('Other - Chat','Other - Chat'));
            options.add(new SelectOption('Partner','Partner'));
            options.add(new SelectOption('System Integrator','System Integrator'));
            options.add(new SelectOption('Complaint','Complaint'));
            options.add(new SelectOption('Customer Dropped Off','Customer Dropped Off'));
            options.add(new SelectOption('Customer Followed Up','Customer Followed Up'));
            options.add(new SelectOption('Customer made bad call','Customer made bad call'));
            options.add(new SelectOption('- Not Specified -','- Not Specified -'));
            options.add(new SelectOption('Technical Support','Technical Support'));
            options.add(new SelectOption('Customer Service','Customer Service'));
            options.add(new SelectOption('Other - Chat','Other - Chat'));
            options.add(new SelectOption('Partner','Partner'));
            options.add(new SelectOption('System Integrator','System Integrator'));
            options.add(new SelectOption('Complaint','Complaint'));
            options.add(new SelectOption('Customer Dropped Off','Customer Dropped Off'));
            options.add(new SelectOption('Customer Followed Up','Customer Followed Up'));
            options.add(new SelectOption('Customer made bad call','Customer made bad call'));
            options.add(new SelectOption('- Not Specified -','- Not Specified -'));
            options.add(new SelectOption('Technical Support','Technical Support'));
            options.add(new SelectOption('Customer Service','Customer Service'));
            options.add(new SelectOption('Other - Chat','Other - Chat'));
            options.add(new SelectOption('Partner','Partner'));
            options.add(new SelectOption('System Integrator','System Integrator'));
            options.add(new SelectOption('Complaint','Complaint'));
            options.add(new SelectOption('Customer Dropped Off','Customer Dropped Off'));
            options.add(new SelectOption('Customer Followed Up','Customer Followed Up'));
            options.add(new SelectOption('Customer made bad call','Customer made bad call'));
            
    }
    public void CustomPicklistForNotes1() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('- Not Specified -','- Not Specified -'));
            options.add(new SelectOption('Technical Support','Technical Support'));
            options.add(new SelectOption('Customer Service','Customer Service'));
            options.add(new SelectOption('Other - Chat','Other - Chat'));
            options.add(new SelectOption('Partner','Partner'));
            options.add(new SelectOption('System Integrator','System Integrator'));
            options.add(new SelectOption('Complaint','Complaint'));
            options.add(new SelectOption('Customer Dropped Off','Customer Dropped Off'));
            options.add(new SelectOption('Customer Followed Up','Customer Followed Up'));
            options.add(new SelectOption('Customer made bad call','Customer made bad call'));
    }
    public void CustomPicklistForNotes2() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('- Not Specified -','- Not Specified -'));
            options.add(new SelectOption('Technical Support','Technical Support'));
            options.add(new SelectOption('Customer Service','Customer Service'));
            options.add(new SelectOption('Other - Chat','Other - Chat'));
            options.add(new SelectOption('Partner','Partner'));
            options.add(new SelectOption('System Integrator','System Integrator'));
            options.add(new SelectOption('Complaint','Complaint'));
            options.add(new SelectOption('Customer Dropped Off','Customer Dropped Off'));
            options.add(new SelectOption('Customer Followed Up','Customer Followed Up'));
            options.add(new SelectOption('Customer made bad call','Customer made bad call'));
    }
    public void CustomPicklistForNotes3() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('- Not Specified -','- Not Specified -'));
            options.add(new SelectOption('Technical Support','Technical Support'));
            options.add(new SelectOption('Customer Service','Customer Service'));
            options.add(new SelectOption('Other - Chat','Other - Chat'));
            options.add(new SelectOption('Partner','Partner'));
            options.add(new SelectOption('System Integrator','System Integrator'));
            options.add(new SelectOption('Complaint','Complaint'));
            options.add(new SelectOption('Customer Dropped Off','Customer Dropped Off'));
            options.add(new SelectOption('Customer Followed Up','Customer Followed Up'));
            options.add(new SelectOption('Customer made bad call','Customer made bad call'));
    }
    public void CustomPicklistForNotes4() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('- Not Specified -','- Not Specified -'));
            options.add(new SelectOption('Technical Support','Technical Support'));
            options.add(new SelectOption('Customer Service','Customer Service'));
            options.add(new SelectOption('Other - Chat','Other - Chat'));
            options.add(new SelectOption('Partner','Partner'));
            options.add(new SelectOption('System Integrator','System Integrator'));
            options.add(new SelectOption('Complaint','Complaint'));
            options.add(new SelectOption('Customer Dropped Off','Customer Dropped Off'));
            options.add(new SelectOption('Customer Followed Up','Customer Followed Up'));
            options.add(new SelectOption('Customer made bad call','Customer made bad call'));
            options.add(new SelectOption('- Not Specified -','- Not Specified -'));
            options.add(new SelectOption('Technical Support','Technical Support'));
            options.add(new SelectOption('Customer Service','Customer Service'));
            options.add(new SelectOption('Other - Chat','Other - Chat'));
            options.add(new SelectOption('Partner','Partner'));
            options.add(new SelectOption('System Integrator','System Integrator'));
            options.add(new SelectOption('Complaint','Complaint'));
            options.add(new SelectOption('Customer Dropped Off','Customer Dropped Off'));
            options.add(new SelectOption('Customer Followed Up','Customer Followed Up'));
            options.add(new SelectOption('Customer made bad call','Customer made bad call'));
            options.add(new SelectOption('- Not Specified -','- Not Specified -'));
            options.add(new SelectOption('Technical Support','Technical Support'));
            options.add(new SelectOption('Customer Service','Customer Service'));
            options.add(new SelectOption('Other - Chat','Other - Chat'));
            options.add(new SelectOption('Partner','Partner'));
            options.add(new SelectOption('System Integrator','System Integrator'));
            options.add(new SelectOption('Complaint','Complaint'));
            options.add(new SelectOption('Customer Dropped Off','Customer Dropped Off'));
            options.add(new SelectOption('Customer Followed Up','Customer Followed Up'));
            options.add(new SelectOption('Customer made bad call','Customer made bad call'));
            options.add(new SelectOption('- Not Specified -','- Not Specified -'));
            options.add(new SelectOption('Technical Support','Technical Support'));
            options.add(new SelectOption('Customer Service','Customer Service'));
            options.add(new SelectOption('Other - Chat','Other - Chat'));
            options.add(new SelectOption('Partner','Partner'));
            options.add(new SelectOption('System Integrator','System Integrator'));
            options.add(new SelectOption('Complaint','Complaint'));
            options.add(new SelectOption('Customer Dropped Off','Customer Dropped Off'));
            options.add(new SelectOption('Customer Followed Up','Customer Followed Up'));
            options.add(new SelectOption('Customer made bad call','Customer made bad call'));
            options.add(new SelectOption('- Not Specified -','- Not Specified -'));
            options.add(new SelectOption('Technical Support','Technical Support'));
            options.add(new SelectOption('Customer Service','Customer Service'));
            options.add(new SelectOption('Other - Chat','Other - Chat'));
            options.add(new SelectOption('Partner','Partner'));
            options.add(new SelectOption('System Integrator','System Integrator'));
            options.add(new SelectOption('Complaint','Complaint'));
            options.add(new SelectOption('Customer Dropped Off','Customer Dropped Off'));
            options.add(new SelectOption('Customer Followed Up','Customer Followed Up'));
            options.add(new SelectOption('Customer made bad call','Customer made bad call'));
    }
    public string msgString {get;set;}
    public string tempmultiLeadList {get;set;}
    public void cmdConcatinateStringIds(){
        try{
        if(multiLeadList != '' && multiLeadList != NULL){
            tempmultiLeadList = multiLeadList.trim();
            tempmultiLeadList = tempmultiLeadList.replaceAll('(\\s+)', ',');
            tempmultiLeadList = tempmultiLeadList.replaceAll('\n', ',');
            List<string> strList = tempmultiLeadList.split(',');
            isIdvalidated(strList);
        }
        }catch(exception e){
        
        }
    }
    public void isIdvalidated(List<string> strList){
        Integer successCount= 0;
        String successRecords= '' ;
        Integer failureCount= 0;
        String failureRecords = '' ;
        for(String leadId :strList){
            if((String.escapeSingleQuotes(leadId).length() == 15 || String.escapeSingleQuotes(leadId).length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', String.escapeSingleQuotes(leadId)) && Id.valueOf(String.escapeSingleQuotes(leadId)).getSObjectType().getDescribe().getName()=='Lead'){
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Validation has been completed!'));
                successCount++;
                successRecords = successRecords + leadId + ',';
            }else{
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'You have entered wrong lead '));
                failureCount++;                
                failureRecords = failureRecords + leadId + ',';
            }
        }
        if(successRecords.length()>0){
            multiLeadList = successRecords;
        }
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.confirm,'Success Count : '+successCount));
        if(failureCount<=0)
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.confirm,'Failure Count : '+failureCount));
        else
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.confirm,'Failure Count : '+failureCount+'---'+failureRecords));
    }
    
     // SCAVA Helper Method
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }
    
    // SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdateGet(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }
}