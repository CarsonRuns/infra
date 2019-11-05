public with sharing class Spark_System_Config {
    
      // SCAVA Helper Method to validate Create Access at field level
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }
    
    // SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdateGet(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }
    
    /* DECLARE CLASS CONSTANTS */
    static final String FINALAUTHLINK        = 'https://idbroker.webex.com/idb/oauth2/v1/access_token';    
    static final String SPARKBASEURL         = 'https://api.ciscospark.com/v1/';
    
    /* private constructor to silence VC warnings */
    public Spark_System_Config() {} 

   /* @Description: This function returns the stored authentication config for the Spark Integration.
    * @Return Spark_Config__c Object
    */
    
    @RemoteAction
    public Static Object getAuthConfig()
    {
      Spark_Config__c auth = new Spark_Config__c();       
      auth = [SELECT id, ApplicationId__c,ApplicationSecret__c,ApplicationScopes__c,
                     MachineId__c,MachineUid__c,MachineSecret__c,MachineOrg__c,ConfiguredObjects__c 
              FROM Spark_Config__c limit 1 ];
          
      return auth;    
    }
    
   /* @Description: This function writes the List object compiled in the Spark_System_Config VFP to the Spark_Config Object. The action flag
    * sends whether the record should be updated, or if no record exists, inserted. This action also updates the Machine Token, since the auth
    * credentials have been modified, as well as updates the Machine Id.
    * @Return Spark_Config__c Object
    */
    @RemoteAction
    public Static Object setAuthConfig( final List<Spark_Config__c> formObj, final String action )
    {
       /* If action is set to update, and set Spark_Config object approprietly. */
        if (action == 'update'){
            update formObj;
        } else {
            insert formObj;
        }
        
        
       /* Since we have changed credentials, we will want to 
        * re-generate the saved token.  Especially important
        * if credentials are the same, but scopes change.
        */
        updateToken();
        /* re-query config table to return newest saved values to the VF Page. */
        Spark_Config__c config;
        config = [SELECT id, ApplicationId__c,ApplicationSecret__c,ApplicationScopes__c,
                        MachineId__c,MachineUid__c,MachineSecret__c,MachineOrg__c,ConfiguredObjects__c 
                        FROM Spark_Config__c limit 1];
    return config;    
    }
    
   /* @Description: This method logs the association between the Spark Integration and the set of Standard Objects
    * that the administrator chooses.  SessionId is currently unused, but would be used to authenticate the tooling
    * API, for auto wrapper page creation.
    * @Return Spark_Config__c Object
    */
    @RemoteAction
    public Static Object setPageConfig( final List<Spark_Config__c> pageConfig, final String sessionId )
    {
        update pageConfig;         
        /* re-query table to ensure we have pulled the new values from the table */
        Spark_Config__c config = [SELECT id, ApplicationId__c,ApplicationSecret__c,ApplicationScopes__c,
                        MachineId__c,MachineSecret__c,MachineOrg__c,ConfiguredObjects__c  
                        FROM Spark_Config__c limit 1];
    return config;    
    }
    
    @RemoteAction
    public Static Void setTrigger(final String selectedObject, final String selectedField)
    {
        String j;
        Boolean triggerExists  = false;        
        String  newTrigger     = selectedObject +'.'+ selectedField;
        Spark_Config__c config = [SELECT TriggerFields__c FROM Spark_Config__c limit 1];
        
        if (String.isBlank(config.TriggerFields__c))
        {
            List<String> triggerString = new List<String>();
            triggerString.add(newTrigger);            
            system.debug('TRIGGER LIST ' + triggerString);
            j = JSON.serializePretty(triggerString);
            config.TriggerFields__c = j;
            update config;   
           
        } else {
            List<String> triggerDeserialized = (List<String>) JSON.deserialize(config.TriggerFields__c, List<String>.class);
            for (String t : triggerDeserialized)
            {
                system.debug('SET TRIGGER FIELD' + t);
                if (t == newTrigger)
                {
                triggerExists = true;   
                }
            }
            if (!triggerExists)
            {
              triggerDeserialized.add(newTrigger);
              j = JSON.serializePretty(triggerDeserialized);
              system.debug('SERIALIZATION OF TRIGGERS' + j);
              config.TriggerFields__c = j;
              update config;
            }
            
        }
  
    }
    
    @RemoteAction
    public Static Void removeTrigger(final String selectedObject, final String selectedField)
    {
        String j;       
        String  delTrigger     = selectedObject +'.'+ selectedField;
        Spark_Config__c config = [SELECT TriggerFields__c FROM Spark_Config__c limit 1];
        if (!String.isBlank(config.TriggerFields__c))
        {
            List<String> triggers = (List<String>) JSON.deserialize(config.TriggerFields__c,List<String>.class);
            for(Integer i = triggers.size() - 1; i >= 0; i--) {
                if(triggers[i].equals(delTrigger)) {
                    triggers.remove(i);
                }
            }
    
            j = JSON.serialize(triggers);
            config.TriggerFields__c = j;
            update config;
        }
    }
    
    @RemoteAction
    public Static List<String> listTrigger()
    {
       List<string> triggerFields = new List<String>();
       Spark_Config__c config = [SELECT TriggerFields__c FROM Spark_Config__c limit 1];
       
       if (!String.isBlank(config.TriggerFields__c))
       {
            List<String> triggers = (List<String>) JSON.deserialize(config.TriggerFields__c,List<String>.class);       
            for(string s: triggers){
                triggerFields.add(s);
            }
       }
        return triggerFields;       
    }
    
    @future(callout=true)
    public static void updateToken()
    {
        system.debug('RUN THE TOKEN UPDATE');
        String newToken   = generateBearerToken();
        system.debug('GENERATED TOKEN ' + newToken);
        updateMid(newToken);
        setBearerToken(newToken);                                     
    }
    
    
    private static void updateMid(final String token)
    {
        Spark_Config__c config;
        config = [SELECT id,MachineId__c,MachineUid__c  FROM Spark_Config__c limit 1];
        
        /* add Machine Base64 UID to config */
        String muuid = getMachineId(config.MachineId__c, token);
        system.debug('GET MACHINE ID ' + config.MachineId__c);
        system.debug('GET MACHINE UUID ' + muuid);
        config.MachineUid__c = muuid;
        update config;
    }

    @RemoteAction
    public static List<ApexPage> getConfiguredPages()
    {
        
        List<ApexPage> pages = new List<ApexPage>();                        
        pages = [select Id,Name from ApexPage WHERE Name like 'Spark_Page_%' and Name != 'Spark_Page_Include' ];
    
    return pages;
    }
    
    public static String getSingleConfiguredPage(final String objName)
    {
        String pageName  = '';
        String sparkPage = 'Spark_Page_'+ ObjName;
        ApexPage[] page = [select Id,Name from ApexPage WHERE Name = :sparkPage limit 1 ];
        ApexPage p;
        if (page.size() > 0)
        {
            p = page[0];
            pageName = p.Name;
        }
    return pageName;
    }

    public static String getMachineId(final String machineId, final String token)
    {
        system.debug('GET MACHINE TOKEN ' + token);
        HTTPResponse mid = Spark_People_API.getMachineUUID(machineId, token);
        String jSONBody  = mid.getBody();
        String uuid  = jSONBody.substringBetween('id":"','","');
        Blob   mblob = Blob.valueOf('ciscospark://us/PEOPLE/'+uuid);
        String buid  = EncodingUtil.base64Encode(mblob);
               buid  = buid.replace('=','');        
        system.debug('UUID Decoded' + buid);        
    return buid;
    }
    
    public static String getMachineUUID()
    {
        return [SELECT MachineUid__c FROM Spark_Config__c limit 1].MachineUid__c;
    }
    
    /* Below functions are for generating and saving new bearer tokens */
    
    public Static String generateBearerToken() {        
        string machineToken, genericAccessToken;
        
        Spark_Config__c config = [SELECT Id, MachineId__c, MachineSecret__c, MachineOrg__c, ApplicationId__c, ApplicationSecret__c, ApplicationScopes__c from Spark_Config__c limit 1 ];
        if (config == null){
            return 'Token Error';
        }
        String getTokenUri     = 'https://idbroker.webex.com/idb/token/'+ config.MachineOrg__c +'/v2/actions/GetBearerToken/invoke';   
        String appUserCode     = config.ApplicationId__c + ':' + config.ApplicationSecret__c;
        Blob   appUserBlob     = Blob.valueOf(appUserCode);
        String appUserAuth     = 'Basic ' + EncodingUtil.base64Encode(appUserBlob);
        String appScopes       = config.ApplicationScopes__c;
               appScopes       = appScopes.replace(';', ' ');
        
        /* This will Start by getting us a bearer token that we need for the sfdcspark user */   
        HttpRequest req2 = new HttpRequest();
         req2.setMethod('POST');
         req2.setHeader('Content-Type', 'application/json');
         req2.setBody('{"name":"'+ config.MachineId__c +'","password":"'+ config.MachineSecret__c +'"}');
         req2.setEndpoint(getTokenUri);
      try {     
         Http http2 = new Http();
         HTTPResponse res2 = http2.send(req2);
         Map<String, Object> jSONObject = (Map<String, Object>)JSON.deserializeUntyped(res2.getBody());
         genericAccessToken = (String)jSONObject.get('BearerToken');
      }catch(JSONException je){
        system.debug('JSON Bearer Exception' + je.getStackTraceString());
      }
      catch(CalloutException ce){
        system.debug('HTTP Bearer Callout General Exception' + ce.getStackTraceString());
      }    
         /* This will Start by getting us a bearer token that we need for the sfdcspark user */
         HttpRequest req3 = new HttpRequest();
         req3.setMethod('POST');
         req3.setHeader('Authorization', appUserAuth);
         req3.setHeader('Content-Type', 'application/x-www-form-urlencoded');
         req3.setBody('grant_type=urn:ietf:params:oauth:grant-type:saml2-bearer&assertion='+genericAccessToken+'&scope='+appScopes );
         req3.setEndpoint(FINALAUTHLINK);
      try {     
         Http http3 = new Http();
         HTTPResponse res3 = http3.send(req3);
         system.debug('TOKEN RESPONSE ' + res3.getBody());
         Map<String, Object> jSONObject = (Map<String, Object>)JSON.deserializeUntyped(res3.getBody());
         machineToken = 'Bearer ' + (String)jSONObject.get('access_token');
         system.debug('NEW MACHINE TOKEN ' + machineToken);
      }catch(JSONException je){
        system.debug('JSON Token Response Exception' + je.getStackTraceString());
      }
      catch(CalloutException ce){
        system.debug('Callout Token Response Exception' + ce.getStackTraceString());
      }    

    return machineToken; 
    }
    
    /* This function will be called to retreive the current stored bearer token 
     * return String
     */    
    public Static String getBearerToken()
    {
        List<Spark_Config__c> tokenLookup = new List<Spark_Config__c>();
        tokenLookup = [select BearerToken__c from Spark_Config__c limit 1 ];
        if (!tokenLookup.isEmpty())
        {
            return tokenLookup[0].BearerToken__c;   
        }
    return 'Invalid Token';    
    }
    
    
    public Static Void setBearerToken(final String machineToken)
    {
        Spark_Config__c[] bearerUpdate = [SELECT BearerToken__c FROM Spark_Config__c LIMIT 1];
        Spark_Config__c b;
        
        if(bearerUpdate.size() > 0 )
        {
            b = bearerUpdate[0];
            if(flsUpdateGet(Spark_Config__c.BearerToken__c)){
            b.BearerToken__c = machineToken;
            }
            update b;
        } else {
            Spark_Config__c i = new Spark_Config__c();
            if(flsGet(Spark_Config__c.BearerToken__c)){
            i.BearerToken__c = machineToken;  
            }   
            insert i; 
        }
    }
    
    
    
}