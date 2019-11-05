/************************************************************************************************************************************
Name    : NGCC_SendSMSExtn
Author  : Ghattamaneni Chaithanya
Purpose : This is the main controller class for Send SMS functionality. This controller class handles Lead Updating,SMS sending features.
Created Date: 20 Dec 2017

Modification History: 
   	1.	Author: Zakeahme 
    	Purpose: added JSON Serialize to avoid special characters to make the payload invalid. line#48-50 
   	2.	Author: Ghattamaneni Chaithanya
    	Purpose: added code to get SMS_Permission__c from current lead and passing it to page for SCAVA Fix, Line No.#27-33
    	Date: July 09,2018 
	3.	Author: Ghattamaneni Chaithanya
    	Purpose: Naas Authorization changed to Basic Auth Line No.#74-78
    	Date: March 18,2019
*************************************************************************************************************************************/
global class NGCC_SendSMSExtn {
    public boolean IsN3Role {get;set;}
    public string leadsmsPermission {get;set;}
    public NGCC_SendSMSExtn(ApexPages.StandardController controller){
        IsN3Role = false;
        leadsmsPermission = 'false';
        User userRoleInfo =[SELECT Id, Name, Email, Profile.Name, UserRole.Name FROM User where Id=:userinfo.getUserId()];
        Map<String, NGCC_Naas_SMS_N3_Roles__c> N3Roles = NGCC_Naas_SMS_N3_Roles__c.getall();
        if(N3Roles != Null){
            IsN3Role = N3Roles.Containskey(userRoleInfo.UserRole.Name);
        }
        // getting SMS_Permission__c from current lead and passing it to js code, as JSENCODE is not supporting for boolean so converting it to string.
        list<lead> leadlist = [select id,SMS_Permission__c from lead where id=:apexPages.currentPage().getParameters().get('id')];
        if(leadlist.size() > 0){
            if(leadlist[0].SMS_Permission__c){
                leadsmsPermission = 'true';
            }
        }
    }
    @RemoteAction
    global static void updateLead(string cLeadid,string cPhone) {
        Lead l = [select id,MobilePhone,SMS_Permission__c from Lead where id=:cLeadid];
        if(flsUpdateGet(Lead.MobilePhone)){
            l.MobilePhone = cPhone;
        }
        if(flsUpdateGet(Lead.SMS_Permission__c)){
            l.SMS_Permission__c = true;
        }
        try{
            Update l; 
        }catch(exception e){
        }
    }
    
    @RemoteAction
    global static String Send(string phone,String msg,string leadid) {
        String escapeMsg = JSON.serializepretty(msg);
        String jsonMsg = escapeMsg.replaceall('\\r\\n','');
        jsonMsg = jsonMsg.substring(1, jsonMsg.length() - 1);
        try{            
            string ssoUrl ;
            string NassUrl ;
            Map<String, NGCC_Nass_SMS_Endpoints__c> NaasEndpoints = NGCC_Nass_SMS_Endpoints__c.getall();
            if(NaasEndpoints != Null){
                if(NaasEndpoints.Containskey('NaasURL')){
                    NGCC_Nass_SMS_Endpoints__c NGCC_NaasURL = NaasEndpoints.get('NaasURL');
                    NassUrl = NGCC_NaasURL.EndpointUrl__c;
                }
            }
            NGCC_NaaS_Credentials__c userdetails = NGCC_NaaS_Credentials__c.getinstance('NaaS Integration User');
            HttpRequest req = new HttpRequest();
            string username;
            string password;
            if(userdetails != null){
                username = userdetails.Username__c;
                password = userdetails.password__c;
            }
            /* Authorization changed to Basic auth -- by gchiatha*/
            Blob headerValue = Blob.valueOf(username + ':' + password);
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization', authorizationHeader);
            /*end*/
            req.setEndpoint(NassUrl);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json;charset=UTF-8');
            req.setBody('{"appId": "NGCC","toUsers": [{"phoneNumber":"'+phone+'"}],"transports": ["SMS"],"priority": 0,"timeoutInHours": 1,"messages": [ {"text": "'+jsonMsg+'"}]}');
            HttpResponse response = new HttpResponse();
            Http http = new Http();
            response = http.send(req);
            if(response.getStatusCode() == 200){
                createSMSHistory(leadid,phone,msg,'Sent',null);
            }
            return string.valueof(response.getStatusCode());
        }catch(exception e){
            if(e.getMessage() == 'Argument 2 cannot be null'){
                createSMSHistory(leadid,phone,msg,'Not Sent','Invalid Username or Password,please check "NGCC NaaS Credentials" Custom Settings.');
                return '\nInvalid Username or Password,please check "NGCC NaaS Credentials" Custom Settings.';
            }                
            else {
                createSMSHistory(leadid,phone,msg,'Not Sent',e.getMessage());
                return 'error '+e.getMessage();
            }   
            
        }
    }

    global static void createSMSHistory(string leadid,string phone,String msg,string status,string err){
        NGCC_SMS_History__c SMSHistory = new NGCC_SMS_History__c();
        list<NGCC_SMS_History__c> smss = [SELECT id,Name,Name__c,lead__c from NGCC_SMS_History__c where lead__c=:leadid ORDER BY Name Desc limit 1 ];
        if(smss.size() == 0){
            if(flsGet(NGCC_SMS_History__c.Name__c)){
                SMSHistory.Name__c = 'Message 1';
            }
        }
        else{
            Integer i = integer.valueOf(smss[0].Name__c.substringAfter(' '))+1;
            if(flsGet(NGCC_SMS_History__c.Name__c)){
                SMSHistory.Name__c= 'Message'+' '+i;
            }
        }
        if(flsGet(NGCC_SMS_History__c.Lead__c)){
            SMSHistory.Lead__c = leadid; 
        }
        if(flsGet(NGCC_SMS_History__c.Phone__c)){
            SMSHistory.Phone__c = phone ;
        }
        if(flsGet(NGCC_SMS_History__c.Sent_By__c)){
            SMSHistory.Sent_By__c = userinfo.getUserId();
        }
        if(flsGet(NGCC_SMS_History__c.Status__c)){
            SMSHistory.Status__c = status;
        }
        if(flsGet(NGCC_SMS_History__c.Sent_Date__c)){
            SMSHistory.Sent_Date__c = system.now();
        }
        if(flsGet(NGCC_SMS_History__c.message__c)){
            SMSHistory.message__c = msg;
        }
        if(flsGet(NGCC_SMS_History__c.Error__c)){
            SMSHistory.Error__c = err;
        }
        try{
            insert SMSHistory;
        }catch(exception e){
        }        
    }
    
    // SCAVA Helper Method
    global static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }
    
    // SCAVA Helper Method to validate Update Access at field level
    global static Boolean flsUpdateGet(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }
}