/*  This Class is a mimic of the Room API referenced at https://developer.ciscospark.com/resource-rooms.html
*   The calls are converted into APEX so that they can be used the same as it would in the in the ciscospark developer site
*/
public with sharing class Spark_Room_API {
    

    static final String ROOMBASEURL   = 'https://api.ciscospark.com/v1/rooms/';
    static final String AUTH          = 'AUTHorization';
    static final string CONTENTTYPE   = 'Content-Type';
    static final string APPJSON       = 'application/json';
    
    /* private constructor to silence VC warnings */
    private Spark_Room_API() {}
    
    /*This the the List Room Call. https://developer.ciscospark.com/endpoint-rooms-get.html
        retrieve all rooms for specified user
        -showSipAddress : shows sip address if it is marked true
        -maxNumber      : maximum number of rooms that will be listed
    */
    
    public static HTTPResponse listRooms( final map<String,String> Options ){       
        String accessToken = Spark_System_Config.getBearerToken();

        /* Constructs Json String from Options Map */
        JSONGenerator generator = JSON.createGenerator(true); 
        generator.writeStartObject(); 
        if( Options.keyset().contains('showSipAddress')  ) { 
                Boolean sip = boolean.valueof(Options.get('showSipAddress')); 
                generator.writeBooleanField('showSipAddress', sip ); }
        if( Options.keyset().contains('max')  ) { 
                Integer max = integer.valueof(Options.get('max')); 
                generator.writeNumberField( 'max' , max ); 
        }         
        generator.writeEndObject(); 
        
        String roomJson = generator.getAsString();
       
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');  
        req.setHeader(AUTH, accessToken); 
        req.setHeader(CONTENTTYPE, APPJSON);
        req.setBody(roomJson);
        req.setEndpoint(ROOMBASEURL);
        
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
    
    /*Create A Room API.  https://developer.ciscospark.com/endpoint-rooms-post.html
        -title : The title of the room that is being created
    */
    public static HTTPResponse createRoom(final String title){
        String accessToken = Spark_System_Config.getBearerToken();
        
        JSONGenerator generator = JSON.createGenerator(true); 
        generator.writeStartObject(); 
        generator.writeStringField( 'title' , title );        
        generator.writeEndObject(); 
        
        String roomJson = generator.getAsString();
        
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');  
        req.setHeader(AUTH, accessToken); 
        req.setHeader(CONTENTTYPE, APPJSON);
        req.setBody(roomJson);
        req.setEndpoint(ROOMBASEURL);
        req.setTimeout(30000);
        
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
    
    /*Get Room Details.  https://developer.ciscospark.com/endpoint-rooms-roomId-get.html
        -roomId         : **Required** The room we are asking information on
        -showSipAddress : Will show the sip address if the string = true
    */
    public static HTTPResponse getRoomDetails(final String roomId, final string showSipAddress){
        String accessToken = Spark_System_Config.getBearerToken();        
        String query = '?showSipAddress='+ showSipAddress; 
        
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');  
        req.setHeader(AUTH, accessToken); 
        req.setHeader(CONTENTTYPE, APPJSON);      
        req.setEndpoint(ROOMBASEURL + roomId + query);
        req.setTimeout(30000);
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        
        /* Checking to see if the access token was accepted */
        if ( res.getStatusCode() == 401){
            String newToken   = Spark_System_Config.generateBearerToken();
            system.debug('UPDATE ROOM NEW BEARER ' + newToken);
            req.setHeader(AUTH, newToken);
            res            = http.send(req); 
            Spark_System_Config.setBearerToken(newToken);
        }
        return res;    
    } 
    
    /*Update A Room API.  https://developer.ciscospark.com/endpoint-rooms-roomId-put.html
        -roomId : **REQUIRED** the room that we are going to update
        -title  : the new title of the room
    */
    public static HTTPResponse updateRoom(final string roomId, final String title){
        String accessToken = Spark_System_Config.getBearerToken();
        
        JSONGenerator generator = JSON.createGenerator(true); 
        generator.writeStartObject(); 
        generator.writeStringField( 'title' , title );        
        generator.writeEndObject(); 
        
        String roomJson = generator.getAsString();

        HttpRequest req = new HttpRequest();
        req.setMethod('PUT');  
        req.setHeader(AUTH, accessToken); 
        req.setHeader(CONTENTTYPE, APPJSON);
        req.setBody(roomJson);
        req.setEndpoint(ROOMBASEURL + roomId);
        
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
    
    /*Delete A Room API. https://developer.ciscospark.com/endpoint-rooms-roomId-delete.html
        roomId : **REQUIRED** the room that we are going to delete
    */
    public static HTTPResponse deleteRoom(final string roomId){
        String accessToken = Spark_System_Config.getBearerToken();
       
        HttpRequest req = new HttpRequest();
        req.setMethod('DELETE');  
        req.setHeader(AUTH, accessToken); 
        req.setHeader(CONTENTTYPE, APPJSON);
        req.setEndpoint(ROOMBASEURL + roomId);
        
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