/**
  @ Author       : Raj
  @ Name         : JabberCustomAPIUserDetails
  @ Created Date : 11/10/2013
  @ Description  : REST webservice class to expose login user's jabber server details
  @ Version: 1.0
  */
@RestResource(urlMapping='/GetJabberUserDetails/*')
global class JabberCustomAPIUserDetails 
{
    @HttpGet
    global static User getJabberUserInfo()
    {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
       //SFDC TEST CASE 09308460 . Testing workaround to force clients to not cache the response.  Needed for IE as it is aggresive in using cache for xmlHttp requests 
        res.addHeader('Cache-Control', 'no-cache');
		User jabberUser = [select id, JabberUserID__c, CUCMServer__c from user where Id =: userinfo.getUserId()];
		return jabberUser;
    }
}