public with sharing class SCP_Notifications_RestCall {
        
    public static Integer retryCounter = 0;
    @Future(callout=true) 
    public static void callWSAPI(string titleCode, string titleParameter, string messageCode, string activityType, string initiatedBy,
                                           string sourceType,string sourceAppId, String sourceReferenceId, String CustomerName, String assignedBy, string userList){
        string respBody = invokeHttpRequest(titleCode,titleParameter,messageCode,activityType,initiatedBy,sourceType,sourceAppId,sourceReferenceId,CustomerName,assignedBy,userList);
        system.debug(respBody);
                    
    }
    public static string invokeHttpRequest(string titleCode, string titleParameter, string messageCode, string activityType, string initiatedBy,
                                           string sourceType,string sourceAppId, String sourceReferenceId, String CustomerName, String assignedBy, string userList){
                                                    
        Http h = new Http();
        HttpRequest req = buildWebServiceRequest(titleCode,titleParameter,messageCode,activityType,initiatedBy,sourceType,sourceAppId,sourceReferenceId,CustomerName,assignedBy,userList);
        HttpResponse res = null;
        String responseBody = '';       
        try{        
            res = h.send(req);
        }
        catch(Exception e)
        {
            responseBody = 'Error: Unable to process request, exception error in createActivity WS API';  
            if(e.getMessage().contains('404 Not Found') && retryCounter < 5) {
                retryCounter ++;                               
                invokeHttpRequest(titleCode,titleParameter,messageCode,activityType,initiatedBy,sourceType,sourceAppId,sourceReferenceId,CustomerName,assignedBy,userList); 
            }                                              
        } 
        if (res != null && res.getStatusCode() == 200) {
            responseBody = res.getBody().trim();
            retryCounter = 0;
        }
        else if (res != null) {                 
            if(res.getStatusCode() == 500 && retryCounter < 5){             
                retryCounter ++;                
                invokeHttpRequest(titleCode,titleParameter,messageCode,activityType,initiatedBy,sourceType,sourceAppId,sourceReferenceId,CustomerName,assignedBy,userList);               
            }
            responseBody = 'Error: Server Error Code '+res.getStatusCode(); 
        }
        else {
            responseBody = 'Error: Unable to process request, can not get response from createActivity WS API'; 
        }
        return responseBody;
    }
    
    public static HttpRequest buildWebServiceRequest(string titleCode, string titleParameter, string messageCode, string activityType, string initiatedBy,
                                           string sourceType,string sourceAppId, String sourceReferenceId, String CustomerName, String assignedBy, string userList){
        HttpRequest req = new HttpRequest();    
        SCP_Communities_ActivitStreamUrl__c ASCredentials = SCP_Communities_ActivitStreamUrl__c.getValues('Activity Stream WB Credentials');                    
        String url = ASCredentials.AS_Url__c;// 
        String basicAuthUsername = ASCredentials.AS_User_Name__c;
        String basicAuthPassword = ASCredentials.AS_Password__c;                                                
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setHeader('content-type', 'application/json; charset=utf-8');         
        
        Blob headerValue = Blob.valueOf(basicAuthUsername + ':' + basicAuthPassword);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);        
        req.setTimeOut(120000);        
        //req.setTimeOut(1);
        
        String reqBody = getRequestParameter(titleCode,titleParameter,messageCode,activityType,initiatedBy,sourceType,sourceAppId,sourceReferenceId,CustomerName,assignedBy,userList);        
        system.debug('@@@:: ' + reqBody);                          
        req.setBody(reqBody);       
        
        return req;
    }
    public static string getRequestParameter(string titleCode, string titleParameter, string messageCode, string activityType, string initiatedBy,
                                           string sourceType,string sourceAppId, String sourceReferenceId, String CustomerName, String assignedBy, string userList){
        map<string,string> mpMsgParameter = new map<string,string>(); 
        mpMsgParameter.put('customername',CustomerName);
        mpMsgParameter.put('assignedby',assignedBy);                                        
        map<string,string> mpRequest = new map<string,string>();
        mpRequest.put('titleCode',titleCode);
        mpRequest.put('titleParameter',titleParameter);
        mpRequest.put('messageCode',messageCode);
        mpRequest.put('messageParameter',JSON.serialize(mpMsgParameter));
        mpRequest.put('activityType',activityType);
        mpRequest.put('initiatedBy',initiatedBy);
        mpRequest.put('sourceType',sourceType);
        mpRequest.put('sourceAppId',sourceAppId);
        mpRequest.put('sourceReferenceId',sourceReferenceId);
        mpRequest.put('userList',userList);        
        return JSON.serialize(mpRequest);
    }
}