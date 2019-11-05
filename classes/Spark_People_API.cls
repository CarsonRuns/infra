/*  This Class is a mimic of the People API reference at https://developer.ciscospark.com/resource-people.html
*   The calls are converted into APEX so that they can be used the same as it would in the in the ciscospark developer site
*/
public with sharing class Spark_People_API {
    
    
    static final String PEOPLEBASEURL  = 'https://api.ciscospark.com/v1/people/';
    static final String AUTH           = 'Authorization';
    static final String CONTENTTYPE    = 'Content-Type';
    static final String APPJSON        = 'application/json';
    static final String GET            = 'GET';

    
    /* private constructor to silence VC warnings */
    private Spark_People_API() {}
    
    /*This the the List People Call. https://developer.ciscospark.com/endpoint-people-get.html
        -email       : The email of the person you are looking for
        -displayName : The name of the person you are looking for.  Whole name is not necessary
        -maxNumber   : The maximum number of results that will be returned
    */
    
    
    public static HTTPResponse listPeople(final map<String,String> Options ){
        String accessToken = Spark_System_Config.getBearerToken();
        /* Constructs Query Paramters */
        String peopleQuery = '0=0'; /* a dummy parameter in case no options are given */      
        if(Options.keyset().contains('email') )   { peopleQuery += '&email='+ Options.get('email'); }
        if(Options.keyset().contains('displayName') )   { peopleQuery += '&displayName='+ Options.get('displayName'); }
        if(Options.keyset().contains('max') ) { peopleQuery += '&max='+ Options.get('max'); }       
        
        HttpRequest req = new HttpRequest();
        req.setMethod(GET);  
        req.setHeader(AUTH, accessToken); 
        req.setHeader(CONTENTTYPE, APPJSON);        
        req.setEndpoint(PEOPLEBASEURL + '?' + peopleQuery );
        
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
    
    /*This is the Get Person Detail Call. https://developer.ciscospark.com/endpoint-people-personId-get.html
        -personId : The Id of the person you are looking for
    */
    public static HTTPResponse getPersonDetails(final string personId, final String token){
        String accessToken;
        /* token may be passed from a function, to avoid repeated soql
         * queries during looped API requests */
        if (token == NULL){
         accessToken = Spark_System_Config.getBearerToken();
        } else {
         accessToken = token;
        }
        HttpRequest req = new HttpRequest();
        req.setMethod(GET);  
        req.setHeader(AUTH, accessToken); 
        req.setHeader(CONTENTTYPE, APPJSON);
        req.setEndpoint(PEOPLEBASEURL + personId);
        
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
    
    /* This the call to return information base off of Authentication token. 
        DOES NOT WORK FOR MACHINE ACCOUNT. 
        https://developer.ciscospark.com/endpoint-people-me-get.html
        No parameters.  Will return information based off of the authentication Token
    */
    public static HTTPResponse getMyDetails(){
        String accessToken = Spark_System_Config.getBearerToken();
       
        HttpRequest req = new HttpRequest();
        req.setMethod(GET);  
        req.setHeader(AUTH, accessToken); 
        req.setHeader(CONTENTTYPE, APPJSON);
        req.setEndpoint(PEOPLEBASEURL + 'me');
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        
        /* Checking to see if the access token was accepted */
        if ( res.getStatusCode() == 401){
            String newToken   = Spark_System_Config.generateBearerToken();
            req.setHeader(AUTH, newToken);
            res = http.send(req);
            Spark_System_Config.setBearerToken(newToken);
        }
        return res;    
    } 
    
    public Static HTTPResponse getMachineUUID(final String client, final String token)
    {
        String accessToken;
        if (token == NULL){
         accessToken = Spark_System_Config.getBearerToken();
        } else {
         accessToken = token;
        }
 
        HttpRequest req = new HttpRequest();
        req.setMethod(GET);  
        req.setHeader(AUTH, accessToken); 
        req.setHeader(CONTENTTYPE, APPJSON);
        req.setEndpoint('https://conv-a.wbx2.com/conversation/api/v1/users/directory?q='+ client +'&includeMyBots=true');
        
        Http http        = new Http();
        HTTPResponse res = http.send(req);
        
        /* Checking to see if the access token was accepted */
        if ( res.getStatusCode() == 401){
            String newToken   = Spark_System_Config.generateBearerToken();
            req.setHeader(AUTH, newToken);
            res = http.send(req);
            Spark_System_Config.setBearerToken(newToken);
        }
        return res; 
    }

}