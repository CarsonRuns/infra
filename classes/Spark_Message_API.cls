/*  This Class is a mimic of the Message API reference at https://developer.ciscospark.com/resource-messages.html
*   The calls are converted into APEX so that they can be used the same as it would in the in the ciscospark developer site
*/
public with sharing class Spark_Message_API {
    

    static final String MESSAGEBASEURL = 'https://api.ciscospark.com/v1/messages/';
    static final String AUTH           = 'Authorization';
    static final String CONTENTTYPE    = 'Content-Type';
    static final string APPJSON        = 'application/json';
    
    /* private constructor to silence VC warnings */
    private Spark_Message_API() {}
    
    /*This the the List Membership Call. https://developer.ciscospark.com/endpoint-messages-get.html
     -roomId        : **REQUIRED** The room of the messages you are asking for
     -beforeDate    : Retrieve all messages before this time. ISO8601 format. ex. 2016-01-11T17:31:10+00:00 Salesforce stores date time in the same format
     -beforeMessage : a messageId. returns all messages before this message
     -maxNumber     : the number of messages returned
    */
    
    public static HTTPResponse listMessages(final string roomId, final map<String,String> Options, final String token){
            String accessToken;
            /* token may be passed from a function, to avoid repeated soql
            * queries during looped API requests 
            */
            if (token == NULL){
                accessToken = Spark_System_Config.getBearerToken();

            } else {
                accessToken = token;
            }
            
            /* Constructs Paramter String from Options Map & roomId */
            String messageBody = 'roomId='+roomId;        
 
            if(Options.keyset().contains('before') )   { messageBody += '&beforeDate='+ Options.get('beforeDate'); }
            if(Options.keyset().contains('beforeMessage') )   { messageBody += '&beforeMessage='+ Options.get('beforeMessage'); }
            if(Options.keyset().contains('max') ) { messageBody += '&max='+ Options.get('max'); }                
            
            HttpRequest req = new HttpRequest();
            req.setMethod('GET');  
            req.setHeader(AUTH, accessToken); 
            req.setHeader(CONTENTTYPE, APPJSON);
            
            req.setEndpoint(MESSAGEBASEURL + '?' + messageBody);
            
            Http http = new Http();
            HTTPResponse res = http.send(req);
            
            /* Checking to see if the access token was accepted */
            if ( res.getStatusCode() == 401){
                String newToken   = Spark_System_Config.generateBearerToken();
                req.setHeader(AUTH, newToken);
                res            = http.send(req);
                Spark_System_Config.setBearerToken(newToken);
            }
        return res;    
    } 
    
    /*This the the Create a Message Call. https://developer.ciscospark.com/endpoint-messages-post.html
        - roomId        : The Id of the room you are sending the message to
        - text          : The text that will be sent in the message
        - files         : The public URL the file can be accessed at
        - toPersonId    : For 1:1 messaging.  The message will be sent to this individual
        - toPersonEmail : For 1:1 messaging.  The message will be sent to this individual 
    */
    public static HTTPResponse createMessage(final map<String,String> Options){     
        String accessToken = Spark_System_Config.getBearerToken();
        
        /* Constructs Json String from Options Map */
        JSONGenerator generator = JSON.createGenerator(true); 
        generator.writeStartObject(); 
        if(Options.keyset().contains('roomId') ) { generator.writeStringField('roomId', Options.get('roomId')); }
        if(Options.keyset().contains('text') )   { generator.writeStringField('text', Options.get('text')); }
        if(Options.keyset().contains('files') )   { generator.writeStringField('files', Options.get('files')); }
        if(Options.keyset().contains('toPersonId') ) { generator.writeStringField('toPersonId', Options.get('toPersonId')); }
        if(Options.keyset().contains('toPersonEmail') ) { generator.writeStringField('toPersonEmail', Options.get('toPersonEmail')); }
        generator.writeEndObject(); 
        
        String messageJson = generator.getAsString();

        HttpRequest req = new HttpRequest();
        req.setMethod('POST');  
        req.setHeader(AUTH, accessToken); 
        req.setHeader(CONTENTTYPE, APPJSON);
        req.setBody(messageJson);
        req.setEndpoint(MESSAGEBASEURL);
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        
        /* Checking to see if the access token was accepted */
        if ( res.getStatusCode() == 401){
            String newToken   = Spark_System_Config.generateBearerToken();
            req.setHeader(AUTH, newToken);
            res            = http.send(req);
            Spark_System_Config.setBearerToken(newToken);
        }
        return res;    
    }
    
    /*This the the Create a Message Call. https://developer.ciscospark.com/endpoint-messages-messageId-get.html
        - messageId : The Id of the message you what the contents of
    */
    public static HTTPResponse getMessageDetail(final string messageId){
        String accessToken = Spark_System_Config.getBearerToken();
       
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');  
        req.setHeader(AUTH, accessToken); 
        req.setHeader(CONTENTTYPE, APPJSON);
        req.setEndpoint(MESSAGEBASEURL + messageId);
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        
        /* Checking to see if the access token was accepted */
        if ( res.getStatusCode() == 401){
            String newToken   = Spark_System_Config.generateBearerToken();
            req.setHeader(AUTH, newToken);
            res            = http.send(req);
            Spark_System_Config.setBearerToken(newToken);
        }
        return res;    
    } 
    
    /*This is the Delete a Message Call. https://developer.ciscospark.com/endpoint-messages-messageId-delete.html
        - messageId : The Id of the message you what to delete
    */
    public static HTTPResponse deleteMessage(final string messageId, final string token){       
        String accessToken;
        /* token may be passed from a function, to avoid repeated soql
         * queries during looped API requests */
        if (token == NULL){
         accessToken = Spark_System_Config.getBearerToken();
        } else {
         accessToken = token;
        }
       
        HttpRequest req = new HttpRequest();
        req.setMethod('DELETE');  
        req.setHeader(AUTH, accessToken); 
        req.setHeader(CONTENTTYPE, APPJSON);
        req.setEndpoint(MESSAGEBASEURL + messageId);
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        
        /* Checking to see if the access token was accepted */
        if ( res.getStatusCode() == 401){
            String newToken   = Spark_System_Config.generateBearerToken();
            req.setHeader(AUTH, newToken);
            res            = http.send(req);
            Spark_System_Config.setBearerToken(newToken);
        }
        return res;    
    } 
    

}