@istest(SeeAllData=true)
public class customerWinWrapper_test{
     public static testmethod void customerWinWrapper(){
         //List<string> lst = new <string>();
      String Json = '{'+
		'                    \"cwaccountname\": ['+
		'                        \"BANK OF KOREA\"'+
		'                    ],'+
		'                    \"cwtheater\": ['+
		'                        \"APJC-APAC\"'+
		'                    ],'+
		'                    \"lastmodified\": ['+
		'                        \"2018-12-05T00:00:00.000-0600\"'+
		'                    ],'+
		'                    \"cwsegments\": ['+
		'                        \"Commercial\"'+
		'                    ],'+
		'                    \"cwfiscalyear\": \"2019\",'+
		'                    \"bizent\": ['+
		'                        \"Data Center Networking\",'+
		'                        \"Data Center Switching\",'+
		'                        \"Enterprise Switching\",'+
		'                        \"Service Provider Routing\",'+
		'                        \"TECHNICAL SUPPORT SERVICES\"'+
		'                    ],'+
		'                    \"url\": \"https://salesconnect.cisco.com/open.html?h=CW-11516\",'+
		'                    \"cwcompetitors\": ['+
		'                        \"Juniper Networks\"'+
		'                    ],'+
		'                    \"cwvertical\": ['+
		'                        \"MFG- Cons. Prod. Man. Apparel\"'+
		'                    ],'+
		'                    \"subbizent\": ['+
		'                        \"NX2/4/5/6K\",'+
		'                        \"NX3K\",'+
		'                        \"NX9K\",'+
		'                        \"NX1K\",'+
		'                        \"Optics - DC Allocation\",'+
		'                        \"SAN\",'+
		'                        \"Optics - Ent. Networking Allocation\",'+
		'                        \"Optics - SP Routing Allocation\",'+
		'                        \"LEGACY SNTC-LEGACY SNTC\"'+
		'                    ],'+
		'                    \"date\": \"2009-11-15T14:12:12\",'+
		'                    \"category\": \"customerwins\",'+
		'                    \"industry\": \"Meraki Solutions\",'+
		'                    \"cwprimarytechnology\": ['+
		'                        \"Security\"'+
		'                    ]'+
		'                }';
         
        List<String> jsonLst = new List<String>();
        jsonLst.add(Json);
        opportunity optyid=[Select id from Opportunity limit 1];
         
         Test.startTest();
         customerWinWrapper.deserializeResp(optyid.Id,jsonLst);
         Test.stopTest();
          
        
    }
}