/*
	Name    		: TACMuleAPIMock 
	Author  		: Eric Pesch (epesch)
	Release 		: 1.0
	Functionality 	: Mock tester for Mule endpoint
	Created			: Sep 14 2015
	
	Modification History:
	Date		Author			Change 
*/
public with sharing class TACMuleAPIMock {
	//Static variables
	private final static String TAG = 'TACMuleAPIMock';
	
	//Input variables
	public String installSiteId { get; set; }
	public String installSiteIdBody { get; set; }
	public String crParty { get; set; }
	public String crPartyBody { get; set; }
	
	//Input (custom)
	public String customPath { get; set; }
	public String customBody { get; set; }
	public String customMethod { get; set; }
	
	//Input URL variables
	public String rootURL { get; set; }
	public String pingToken { get; set; }
	
	//Input ping details
	public String clientId { get; set; }
	public String clientSecret { get; set; }
	
	//Output variables
	public String httpResult { get; set; }
	
	private class PingResponse {
		String access_token;
		String token_type;
		String expires_in;	
		String error_description;
		String error;	
	}
	
	/*
	 * @description Constructor
	 */
	public TACMuleAPIMock(){ 
		rootURL = Utilities.getConstant_CS('TAC Services API Endpoint');
	}
	
	/*
	 * @description picklist for custom method
	 *
	 * @return Picklist values
	 */
	public List<SelectOption> getMethods() {
		List<SelectOption> options = new List<SelectOption>();
		options.add(new SelectOption('GET','GET'));
		options.add(new SelectOption('POST','POST'));
		
		return options;	
	}
	
	public void callPingFederate(){
		try{
			String jsonBody = callHTTP(Utilities.getConstant_CS('Ping Federate Endpoint'), '', 'POST', '', true);
			PingResponse response = (PingResponse) JSON.deserialize(jsonBody, PingResponse.class);
			
			if(response.access_token != null) {
				pingToken = response.access_token;
			} else if (response.error != null) {
				pingToken = response.error + ' - ' + response.error_description;
			}
		} catch (Exception e){
			System.debug(TAG + 'Error mapping Ping Federate call to object - ' + e.getStackTraceString());
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,e + ' - ' + e.getStackTraceString()));
		}
	}
	
	/*
	 * @description call Install Site single search
	 */
	public void callInstallSite(){
		httpResult = callHTTP(rootURL, '/crparties/installsite/', 'GET', installSiteId, false);
	}
	
	/*
	 * @description call Install Site bulk search
	 */
	public void callInstallSiteSearch(){
		httpResult = callHTTP(rootURL, '/crparties/installsite/search','POST',installSiteIdBody, false);
	}
	
	/*
	 * @description call CR Party single search
	 */
	public void callAccount(){
		httpResult = callHTTP(rootURL, '/accounts/crparty/','GET', crParty, false);
	}
	
	/*
	 * @description call CR Party bulk search
	 */
	public void callAccountSearch(){
		httpResult = callHTTP(rootURL, '/accounts/crparty/search','POST',crPartyBody, false);
	}
	
	/*
	 * @description Make standard HTTP call
	 *
	 * @param path HTTP Path, relative to host
	 * @param method HTTP method (GET, POST)
	 * @param input Body (optional)
	 *
	 * @return HTTP Response body
	 */
	public String callHTTP(String host, String path, String method, String input, Boolean isRawResult){
		HttpRequest req = new HttpRequest();
		HttpResponse res = null;
		Http http = new Http();
		
		if(method == 'GET'){
			req.setEndpoint(host + path + input);
		} else if (method == 'POST'){
			if(host.contains('cloudsso')){
				System.debug(TAG + 'Client Id - ' + clientId + ' - Client Secret - ' + clientSecret);
				System.debug(TAG + 'FULL URL - ' + host + '?grant_type=client_credentials&client_id=' + clientId + '&client_secret=' + clientSecret);
				req.setEndpoint(host + '?grant_type=client_credentials&client_id=' + clientId + '&client_secret=' + clientSecret);
			} else {
				req.setEndpoint(host + path);
				req.setBody(input);
				req.setHeader('Content-Type','application/json');
				req.setHeader('Accept','application/json');
			}
		}
		req.setHeader('Authorization','Bearer ' + pingToken);
		req.setMethod(method);

		try{
			res = http.send(req);
		} catch(Exception e){
			System.debug(TAG + 'HTTP Error - ' + e.getStackTraceString());
		}
		
		if(res != null){
			if(isRawResult) return res.getBody();
			return res.toString() + '\r\n\r\n' + res.getBody();
		}
		
		return '';
	}
}