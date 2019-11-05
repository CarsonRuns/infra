/************************************************************************************************************************************
@Name    : NGCC_LiveAgentTool_Cls
@Author  : Fazurulla Ganganapalli
@Purpose : This class is responsible for the management of LiveAgent Business Rules
@Created Date: 1/19/2017
@Modification History: 

*************************************************************************************************************************************/

public class NGCC_LiveAgentTool_Cls{
    //Variable declaration
    public Lead    leads {get;set;}
    public String  leadId {get;set;}
    public String  leadStatus {get;set;}
    public string leadStatusChoice {get;set;}
    public boolean showSingleChoice{get;set;}  
    public list<LiveChatUserConfigUser> chatCapacityList {get;set;}   
    public string choiseOption{get;set;}
    public boolean showConfigurationValues {get;set;}
    public List<LiveChatUserConfig> configValues {get;set;}
    public boolean showMultipleChoice{get;set;}
    public boolean showMessage {get;set;}
    public string multiLeadList {get;set;}
    public boolean showPageBlockTable {get;set;}
    public string userName {get;set;}
    public User userId {get;set;}
    public Id userStringId {get;set;}
    public string msgString {get;set;}
    public string tempmultiLeadList {get;set;}
    public List<string> conditions = new List<string>();
    public string strQuery {get;set;}
    public list<skilluser> lis {get;set;}
    public boolean showSkillTable {get;set;}
    public string liveAgentUserChatCapacityQuery {get;set;}
    public boolean showTable {get;set;}
    public string userNameWithCondition;
    public string teststring {get;set;}
    public List<User> skilUserDetails {get;set;}
    public string tempConcatenate {get;set;}
    public String liveAgentUserQuery {get;set;}
    public boolean isSkillSearchButtonDisabled {get;set;}
    public List<Skill> AllContacts = new List<Skill>();
    public List<Skill> ContactsToShow{get;set;}
    public Integer counter = 0;
    public Integer limitSize = 10;
    public integer setCon {get;set;}
    public Integer totalSize =0; 
    Public Integer noOfRecords{get; set;} 
    public List<SelectOption> paginationSizeOptions{get;set;}
    public integer skillSize {get;set;}
    public list<skill> allContactsList {get;set;}
    
    
    public NGCC_LiveAgentTool_Cls(){   
        showTable = false;  
        showSkillTable = false;
        userId = new User();
        isSkillSearchButtonDisabled = true;
        getConfigOptions();
        showConfigurationValues = false;        
        leads = new lead();
        showSingleChoice  = false;
        showMultipleChoice = false;
        showMessage = true;
        showPageBlockTable = false;
        if(choiseOption == '-None-'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.confirm,'Please select correct value'));
        }
        try{    
        ContactsToShow = new List<Skill>();
        setCon = limitSize;
        allContacts = [SELECT Id,DeveloperName,Language,MasterLabel from SKILL order by MasterLabel ];
        totalSize = AllContacts.size();
        noOfRecords = AllContacts.size();
        if((counter+limitSize) <= totalSize){
        for(Integer i=0;i<limitSize;i++){
        ContactsToShow.add(AllContacts.get(i));
        }
        }else{
        for(Integer i=0;i<totalSize;i++){
        ContactsToShow.add(AllContacts.get(i));
        }
        }         
        paginationSizeOptions = new List<SelectOption>();
        paginationSizeOptions.add(new SelectOption('10','10'));
        paginationSizeOptions.add(new SelectOption('20','20'));
        paginationSizeOptions.add(new SelectOption('30','30'));
        paginationSizeOptions.add(new SelectOption('40','40'));
        paginationSizeOptions.add(new SelectOption('50','50'));
        paginationSizeOptions.add(new SelectOption('60','60'));
        paginationSizeOptions.add(new SelectOption('70','70'));
        paginationSizeOptions.add(new SelectOption('80','80'));
        paginationSizeOptions.add(new SelectOption('90','90'));
        paginationSizeOptions.add(new SelectOption('100','100')); 
        paginationSizeOptions.add(new SelectOption('500','500'));
        }catch(exception e){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,'Something went wrong '));
        }
    }
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
            //liveAgentUserQuery  += ' WHERE username LIKE \''+userName+'@cisco.com'+ '%\' ';
            //SCAVA
            liveAgentUserQuery  += ' WHERE username LIKE \''+String.escapesinglequotes(userName)+'@cisco.com'+ '%\' ';
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
    public string getQuery() {
        strQuery = 'SELECT Id,skillid,USERID,USER.name,USER.username,USER.Marketing_Call_Center__c,user.userroleid FROM SKILLUSER ';
        liveAgentUserChatCapacityQuery = 'select id,UserId,LiveChatUserConfig.MasterLabel,user.name,user.username,LiveChatUserConfigId,LiveChatUserConfig.Language,LiveChatUserConfig.Capacity from LiveChatUserConfigUser';
        
        if(String.isNotBlank(userName)){
            //strQuery += 'WHERE USER.username LIKE \''+userName+'@cisco.com'+ '%\' ';
            //SCAVA
            strQuery += 'WHERE USER.username LIKE \''+String.escapesinglequotes(userName)+'@cisco.com'+ '%\' ';
            liveAgentUserChatCapacityQuery +=' WHERE user.username LIKE \''+String.escapesinglequotes(userName)+'@cisco.com'+ '%\' ';//SCAVA
            
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
            //strQuery += 'WHERE USER.username = \'' +userName+ '\' OR USERID = \'' +userStringId+ '\' ';
            //liveAgentUserChatCapacityQuery += ' WHERE USER.username = \'' +username+ '\' OR USERID = \'' +userStringId+ '\' ';
            //SCAVA
            strQuery += 'WHERE USER.username = \'' +String.escapesinglequotes(username)+ '\' OR USERID = \'' +userStringId+ '\' ';
            liveAgentUserChatCapacityQuery += ' WHERE USER.username = \'' +String.escapesinglequotes(username)+ '\' OR USERID = \'' +userStringId+ '\' ';//SCAVA
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info,'Please Select CEC ID or User ID'));
            showSkillTable = false;
            showTable = true;
        }
        strQuery += ' ORDER BY skillid ASC';
        liveAgentUserChatCapacityQuery += ' ORDER BY user.username ASC';
        return strQuery;
    }
    public list<SelectOption> getConfigOptions(){
        list<SelectOption> options = new list<SelectOption>();
        options.add(new selectoption('-None-','-None-'));  
        AggregateResult[] groupedResults = [SELECT capacity,count(id) FROM LiveChatUserConfig GROUP BY capacity HAVING count(id)>1];
        for(AggregateResult ar : groupedResults){
            options.add(new SelectOption(String.valueof(ar.get('Capacity')),String.valueof(ar.get('Capacity'))));
        }
        return options;
    }
    public void cmdChoiceConfigBtn(){
        if(choiseOption != '-None-'){
            showConfigurationValues = true;
            configValues = [select id,MasterLabel,Language,Capacity from LiveChatUserConfig where capacity=:Integer.valueof(choiseOption)];
        }else{
            showConfigurationValues = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.confirm,'Please select correct value'));
        }
    }
    public void beginning(){
        try{
        ContactsToShow.clear();
        counter=0;
        if((counter + limitSize) <= totalSize){
            for(Integer i=0;i<limitSize;i++){
                ContactsToShow.add(AllContacts.get(i));
            }
        }else{
            for(Integer i=0;i<totalSize;i++){
                ContactsToShow.add(AllContacts.get(i));
            } 
        }
        }catch(exception e){}
    }
    public void next(){
        try{
        ContactsToShow.clear();
        counter=counter+limitSize;
        if((counter+limitSize) <= totalSize){
            for(Integer i=counter-1;i<(counter+limitSize);i++){
                ContactsToShow.add(AllContacts.get(i));
            }
        } else{
            for(Integer i=counter;i<totalSize;i++){
                ContactsToShow.add(AllContacts.get(i));
            }
        }
        }catch(exception e){}
    }
    public void previous(){
        try{
        ContactsToShow.clear();
        counter=counter-limitSize;  
        for(Integer i=counter;i<(counter+limitSize); i++){
            ContactsToShow.add(AllContacts.get(i));
        }
        }catch(exception e){}
    }
    public void last (){
        try{
        ContactsToShow.clear();
        if(math.mod(totalSize , limitSize) == 0){
            counter = limitSize * ((totalSize/limitSize)-1);
        }else if (math.mod(totalSize , limitSize) != 0){
            counter = limitSize * ((totalSize/limitSize));
        }
        for(Integer i=counter-1;i<totalSize-1;i++){
            ContactsToShow.add(AllContacts.get(i));
        }
        }catch(exception e){}
    }
    public Boolean getDisableNext(){
        if((counter + limitSize) >= totalSize )
            return true ;
        else
            return false ;
    }
    public Boolean getDisablePrevious(){
        if(counter == 0)
            return true ;
        else
            return false ;
    } 
    public void refreshPageSize(){
        try{  
            ContactsToShow = new List<Skill>();      
            allContacts = [SELECT Id,DeveloperName,Language,MasterLabel from SKILL order by MasterLabel limit :skillSize];
            for(Integer i=0;i<skillSize;i++){
                ContactsToShow.add(allContacts.get(i));
            }
        }catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,'Something went wrong '));
        }
    }
}