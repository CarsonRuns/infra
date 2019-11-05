@isTest (seeAllData = true)
private class JabberCustomAPIUserDetailsTests 
{
	private static testmethod void TestJabberUserInfo()
    {
    	//sending the http request for account
    	string strURL = System.URL.getSalesforceBaseURL().toExternalForm();
        RestRequest req = new RestRequest(); 
                RestResponse res = new RestResponse();
        req.requestURI = strURL+'/services/apexrest/GetJabberUserDetails';
        req.httpMethod  = 'GET';
                RestContext.request = req;
                RestContext.response = res;
    	User csr = JabberCustomAPIUserDetails.getJabberUserInfo();
    }
}