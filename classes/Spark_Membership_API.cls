/*  This Class is a mimic of the Membership API reference at https://developer.ciscospark.com/resource-memberships.html
 *  The calls are converted into APEX so that they can be used the same as it would in the in the ciscospark developer site
 */
public with sharing class Spark_Membership_API {

    static final String MEMBERBASEURL  = 'https://api.ciscospark.com/v1/memberships/';
    static final String AUTH           = 'Authorization';
    static final String CONTENTTYPE    = 'Content-Type';
    static final String APPJSON        = 'application/json';
    static final String PEREMAIL       = 'personEmail';
    static final String ISMOD          = 'isModerator';
    
    /* private constructor to silence VC warnings */
    private Spark_Membership_API() {}
    
    /* This the the List Membership Call. https://developer.ciscospark.com/endpoint-memberships-get.html
     -roomId      : Limits results to this room
     -personId    : Limits results to this person
    */
    /*
     -personEmail : Limits results to this person 
     -maxNumber   : The total number of members to be returned
     - options array Map<String,String> Options = new Map<String,String>{'personId'=>'','personEmail'=>'', 'max'=> ''};
            System.debug(myStrings.get('a'));
    */
    
    public static HTTPResponse listMembership(final string roomId, final map<String,String> Options ){ 
        String accessToken = Spark_System_Config.getBearerToken();
        String personId = 'personId';
        /* Constructs Query Paramters */
        String memberBody = 'roomId='+roomId;         
        if(Options.keyset().contains(personId))   { memberBody += '&personId='+ Options.get(personId); }
        if(Options.keyset().contains(PEREMAIL))   { memberBody += '&personEmail='+ Options.get(PEREMAIL); }
        if(Options.keyset().contains('max')) { memberBody += '&max='+ Options.get('max'); }       
        
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');  
        req.setHeader(AUTH, accessToken); 
        req.setHeader(CONTENTTYPE, APPJSON);
        req.setEndpoint(MEMBERBASEURL + '?' + memberBody);
        
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
    
    /*This the the Create Membership Call. https://developer.ciscospark.com/endpoint-memberships-post.html
     -roomId      : **REQUIRED** Room the membership will be created for
     -personId    : Person added to the membership
     -personEmail : Person added to the membership
    */
    public static HTTPResponse createMembership(final string roomId, final map<String,String> Options){       
            String accessToken = Spark_System_Config.getBearerToken(); 
            String personId = 'personId';
            /* Constructs Json String from Options Map & roomId */
            JSONGenerator generator = JSON.createGenerator(true); 
            generator.writeStartObject(); 
            generator.writeStringField('roomId', roomId);
            if(Options.keyset().contains(personId) )    { generator.writeStringField(personId, Options.get(personId)); }
            if(Options.keyset().contains(PEREMAIL) ) { generator.writeStringField(PEREMAIL, Options.get(PEREMAIL)); }
            if(Options.keyset().contains(ISMOD) ) {
                Boolean mod = boolean.valueOf(Options.get(ISMOD));
                generator.writeBooleanField(ISMOD, mod); 
            }
            generator.writeEndObject();
        
            String memberJson = generator.getAsString();
              system.debug('CREATE MEMBERSHIP STRING: ' + memberJson);      
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');  
            req.setHeader(AUTH, accessToken); 
            req.setHeader(CONTENTTYPE, APPJSON);
            req.setBody(memberJson);
            req.setEndpoint(MEMBERBASEURL);
            
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
    
    /* This the the Get Membership Details. https://developer.ciscospark.com/endpoint-memberships-membershipId-get.html
     * -membershipId : The membership we are looking for information on
     */
    public static HTTPResponse getMembershipDetails(final string membershipId){   
        String accessToken = Spark_System_Config.getBearerToken();
       
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');  
        req.setHeader(AUTH, accessToken); 
        req.setHeader(CONTENTTYPE, APPJSON);
        req.setEndpoint(MEMBERBASEURL + membershipId);
        
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
    
    /*This is the Update a Membership. https://developer.ciscospark.com/endpoint-memberships-membershipId-put.html
     * -membershipId : the membership we are modifying
     * -isModerator  : moderators have sole access to adding and removing users from the room
     */
    public static HTTPResponse updateMembership(final string membershipId, final boolean isModerator){
        String accessToken = Spark_System_Config.getBearerToken();
        
        JSONGenerator generator = JSON.createGenerator(true); 
        generator.writeStartObject(); 
        generator.writeBooleanField(ISMOD, isModerator );
        generator.writeEndObject();
        
        String memberJson = generator.getAsString();
            
        HttpRequest req = new HttpRequest();
        req.setMethod('PUT'); 
        req.setHeader(AUTH, accessToken); 
        req.setHeader(CONTENTTYPE, APPJSON);
        req.setBody(memberJson);
        req.setEndpoint(MEMBERBASEURL + membershipId);
        
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
    
    /* This is the call to delete a membership https://developer.ciscospark.com/endpoint-memberships-membershipId-delete.html
     * -membershipId : The membership we are deleting
     */
    public static HTTPResponse deleteMembership(final string membershipId, final String token){
        String accessToken;
        if (token == NULL)
        {
            accessToken = Spark_System_Config.getBearerToken();    
        } else {
            accessToken = token;
        }
            
        HttpRequest req = new HttpRequest();
        req.setMethod('DELETE');  
        req.setHeader(AUTH, accessToken); 
        req.setHeader(CONTENTTYPE, APPJSON);
        req.setEndpoint(MEMBERBASEURL + membershipId);
        
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