@isTest
global class MockHttpResponseNAASGenerator implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {       
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"access_token": "IsW7yXrVGJKcz2Jf1EKeFFoNBDSS","token_type": "Bearer","expires_in": 3599}');
        res.setStatusCode(200);
        return res;
    }
}