/************************************************************************************************************************************
Name    : C360_Callout
Author  : C360 Dev team
Purpose : This class has re-usable API callout methods(GET API) which can be called from other classes.
Date    : 28/06/2019
Change History : none
*************************************************************************************************************************************/

global class C360_Callout{
	
    public static String requestURL;
    
    // General API Callout for GET API.
	public static C360_ResponseWrapper doGET(String service,
                                       String URL,
                                       String authorisationHeader,
                                       String contentType,
                                       Decimal timedOut,
                                       map<String,String> headersMap){

        HttpRequest r = getHttpRequest(service, 'GET', authorisationHeader, contentType, url, null, timedOut,headersMap);
        C360_ResponseWrapper responseReceived = getResponse(r);
        return responseReceived ;
    }
    
    //re-usable method of getting the response into HTTPResponse for the request.
	private static C360_ResponseWrapper getResponse(HttpRequest r){
        
		try {
            Http h = new Http();
            HttpResponse responseback = h.send(r);
            return new C360_ResponseWrapper(false,null,responseback);
         }
        catch(Exception e) {
            return new C360_ResponseWrapper(e,null);
        } 
    }
    
    //Re-usable method to prepare the HTTP Request
	private static HTTPRequest getHttpRequest(String service,
                                              String methodType,
                                              String authorisationHeader,
                                              String contentType,
                                              String URL,
                                              String requestBody,
                                              Decimal isTimedOut,
											  map<String,String> headersMap){    
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod(methodType);
        requestUrl = url;
         
        if (contentType != null && contentType != ''){
            req.setHeader('Content-Type', contentType); 
        }           
        if (authorisationHeader != null)
            req.setHeader('Authorization', authorisationHeader); 
               
        if (headersMap != null && headersMap.size() > 0 ){
            for(String s :headersMap.keyset()){
                req.setHeader(s, headersMap.get(s));   
            }
        }
        if(isTimedOut!= null){
            req.setTimeout(Integer.valueOf(istimedOut));                                          
        }                     
        
        if (requestBody != null)
            req.Setbody(requestBody);
        return req;
    }
}