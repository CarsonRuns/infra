@isTest
global class DSE_Http_Mule_Response_Test implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"access_token":"MuleToken","token_type":"abc","expires_in":"5352"}');
        res.setStatusCode(200);
        return res;
    }
}