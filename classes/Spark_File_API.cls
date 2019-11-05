public with sharing class Spark_File_API {
  
	/* private constructor to silence VC warnings */
	private Spark_File_API() {} 
  
  	public static HTTPResponse getSparkFileDetail(final String url)
    {
        /* use the stored bearerToken for Authentication */          
        String accessToken = Spark_System_Config.getBearerToken();
        
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');  
        req.setHeader('Authorization', accessToken); 
        req.setHeader('Content-Type', 'application/octet-stream');
        req.setCompressed(true); 
        req.setTimeout(60000); 
        req.setEndpoint(url);

        Http h = new Http();       
        HttpResponse res = h.send(req);
        
        system.debug('HEAD REsponse:' + res);
            if ( res.getStatusCode() == 401 ){
            String newToken   = Spark_System_Config.generateBearerToken();
            req.setHeader('Authorization', newToken);
            res             = h.send(req);
            Spark_System_Config.setBearerToken(newToken);
            }
    return res;
    }
  
    
}