@isTest
global class TACMuleAPIMock_Test_Svc implements HttpCalloutMock {
	
	global HTTPResponse respond(HTTPRequest req){
		HttpResponse res = new HttpResponse();
		
		res.setHeader('Content-Type','application/json');
		res.setStatusCode(200);
		if(req.getBody() == 'installSite') res.setBody('{"response":"200 OK"');
		else if(req.getBody() == 'installBody') res.setBody('{"response":"200 OK"');
		else if(req.getBody() == 'cr') res.setBody('{"response":"200 OK"');
		else if(req.getBody() == 'crBody') res.setBody('{"response":"200 OK"');
		else res.setBody('{"access_token":"token","token_type":"type"}');
		
		return res;
	}
}