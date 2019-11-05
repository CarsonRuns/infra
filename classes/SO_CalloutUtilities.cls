/********************************************************************************************************************
Name    : SO_CalloutUtilities 
Author  : Apex User
Purpose : SO_CalloutUtilities contains methods required to make HTTP callouts
Created Date:  3/4/2018

**********************************************************************************************************************/

public class SO_CalloutUtilities {
    
    static integer callcount = 0;
    
    public static String getEndPointUrl(String name) {
    /**
    * This method Retrieves the End Point URL from Custom Setting - SO_CalloutParameters__c, for the API Passed in the "name" parameter
    * @param name Name of the API for whose End Point is to be retrieved
    * @return End_Point_URL__c The End Point URL for the API Passed in the "name" parameter
    */
    String constName = String.escapeSingleQuotes(name);
  //  List<Org_Constants__c> objCP = [SELECT non_prod_value__c FROM Org_Constants__c WHERE Key__c = :constName];
    String objCP = Utilities.getConstant_CS(constName) ; //Org_Constant_CS__c.getInstance(constName).Non_Production_Value__c ;
    
        //String objCP = getConstant(name,'URL'); 
        
 //       if (objCP.size()>0) {
            system.debug(constName+' EndPoint URL:::'+objCP);
           // return objCP[0].non_prod_value__c;
              return objCP ;
 //       }
 //       return null;
    }
    //Method to conver object into json format
    public static String serializeJSON(Object Obj) {
        return JSON.serialize(Obj);
    }

    //public static HttpRequest getRequest(String endPointUrl, String jsonString, String method, String access_token) {
    /**
    * This method creates the http request object
    * @param endPointUrl End Point URL of the Target API
    * @param jsonString Request Body in JSON format
    * @param method The HTTP request method - GET/POST/DELETE/PUT
    * @return req HttpRequest Object that can be sent over the callout
    */
      /*   
        HttpRequest req = new HttpRequest();
    
        try{
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization','Bearer '+access_token);
            req.setEndPoint(endPointUrl);
            req.setMethod(method);
            req.setTimeout(120000);     
            req.setCompressed(false);
            req.setBody(jsonString);
        }
        catch(Exception ex) {
            system.debug('Exception Creating Request:::'+ex.getMessage());
        }
        
        return req;
    }
*/

    public static HttpRequest getRequest(Map<String,String> headerMap, String endPointName, String jsonString, String method) {
    /**
    * This method creates the http request object
    * @param headerMap map contains content-Type and Authorization access token
    * @param endPointName to get End Point URL of the Target API
    * @param jsonString Request Body in JSON format
    * @param method The HTTP request method - GET/POST/DELETE/PUT
    * @return req HttpRequest Object that can be sent over the callout
    */
         
        HttpRequest req = new HttpRequest();
    
        try{
            if(headerMap != null && headerMap.size()>0){
                for(string header: headerMap.keySet()){
                    if(req.getHeader(header) == Null)
                    req.setHeader(header, headerMap.get(header));
                }
            }
            //req.setHeader('Content-Type', 'application/json');
            //req.setHeader('Authorization','Bearer '+access_token);
            string endPointUrl = getEndPointUrl(endPointName);
            if(!string.isEmpty(endPointUrl)){
                req.setEndPoint(endPointUrl);
            }
            req.setMethod(method);
            req.setTimeout(120000);     
            req.setCompressed(false);
            if(!string.isEmpty(jsonString)){
                req.setBody(jsonString);
            }            
        }
        catch(Exception ex) {
            system.debug('Exception Creating Request:::'+ex.getMessage());
        }
        
        return req;
    }
    
    public static HttpResponse doPost(String APIName, HttpRequest req) {
    /**
    * This method makes the http callout. If the callout fails, 5 re-attempts will made.
    * @param APIName Name of the Target API
    * @param req HttpRequest Object
    * @return res HttpResponse received from the target
    */
    
        Http http = new Http();
        HttpResponse res = new HttpResponse();
        boolean calloutfailed = false;
        
        system.debug('Request:::'+req);
        
        try {
            ++callcount;
            system.debug(APIName+' Callout Iteration:::'+callcount);
            res = http.send(req);
        } 
        catch (Exception ex){
            system.debug('CallOut Exception:::'+ex);
            calloutfailed = true;
        }
    
        if((res.getStatusCode()!=200||calloutfailed) && callcount<5)
            doPost(APIName, req);
        return res;
    }
    //Method conver json content into object
    public static Object deserializeJSONTyped(String strJSON, Type apexType){
        
        return (Object)JSON.deserialize(strJSON,apexType);
    }
    
/*    
    public static void captureLogs(String APIName, Id EntityId, String jsonString, HttpResponse res) {
        SO_APILogs.captureLogs(APIName, EntityId, jsonString, res.getBody(), res.getStatusCode());
    }   

  
    
     public static string generateJsonString(string eventAction, String resCecid, list<object> SkillCertRatings){         
        JSONGenerator genJson = JSON.createGenerator(true);         
        genJson.writeStartObject();
        genJson.writeStringField('event', eventAction);
        genJson.writeStringField('eventSource', 'ServicesOne');
        genJson.writeStringField('eventId', 'event');
        genJson.writeStringField('eventDateTime', 'event');
        genJson.writeStringField('resourceCecId', resCecid);
        genJson.writeStringField('lastModifiedDate', 'event');
        
        genJson.writeFieldName('skills');       
        genJson.writeStartArray();
        for(object  sObj: SkillCertRatings)
        {
            pse__Skill_Certification_Rating__c scrRec =(pse__Skill_Certification_Rating__c) sObj;
            genJson.writeStartObject();
            genJson.writeStringField('action', trigger.isDelete? 'deleteSkillRating':'insertSkillRating');
            genJson.writeStringField('skillId', scrRec.Id);
            genJson.writeStringField('skillExternalId','' );
            genJson.writeStringField('lastModifiedDate',string.valueOf(scrRec.CreatedDate));
            genJson.writeEndObject();
        }
        genJson.writeEndArray();
        genJson.writeEndObject();
     
         return genJson.getAsString(); //strJson;
     }
 */
  


}