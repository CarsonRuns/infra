public class TSNUserUnifiedDetailsWebService{

public Static Case getCecVal(String fromCecVal) {


String fromCecId = fromCecVal;
Double trnId = Math.random();
String sMethod = 'userUnifiedDetails';
String responseBody;

//String url = 'https://wsgx.cisco.com/ccw/presence/services/PresenceService/'+sMethod; 
// Blob credentials = Blob.valueOf('ccwprs.gen'+':'+'ccw123*@#');

// Fetching the URL, U.N, PWD from custom meta data "CCW_PresenceService__mdt"
CCW_PresenceService__mdt ccw = [select UserName__c,Password__c,URL__c from CCW_PresenceService__mdt  ];

String url = ccw.URL__c+sMethod;
Blob credentials = Blob.valueOf(ccw.UserName__c+':'+ccw.Password__c);
String auth = 'Basic '+EncodingUtil.base64Encode(credentials);

Http h = new Http();
HttpRequest req = new HttpRequest();
req.setEndpoint(url);
req.setMethod('POST');
req.setHeader('content-type', 'text/xml; charset=utf-8'); 
req.setHeader('SOAPAction', sMethod);
req.setHeader('Authorization',auth );

String reqBody =  '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.service.presence.uc.cisco.com">   <soapenv:Header/>   <soapenv:Body>      <ws:userList>     <ws:appId>DFT</ws:appId>    <ws:appKey>dummy</ws:appKey>          <ws:trnId>'+trnId+'</ws:trnId>          <ws:clientAppTimeinGMT>2 May 2011 09:41:41 GMT</ws:clientAppTimeinGMT>          <ws:user>             <ws:cecId>'+fromCecId+'</ws:cecId>             <ws:fromCecId>'+fromCecId+'</ws:fromCecId>             <ws:pStatus/>             <ws:pStatusImgUrl/>          </ws:user>       </ws:userList>    </soapenv:Body> </soapenv:Envelope>';

req.setBody(reqBody);

HttpResponse res;

// TSN June Release will provide exception handling , if webservice is down. 
// The following changes will return null, if webservice is down. 

try{
     res = h.send(req);
}
catch (Exception e){
    System.debug('>>>>' +e);
    return null;
}
responseBody = res.getBody().trim();
Integer statusCode=res.getStatusCode();

System.debug('statusCode>>>>'+statusCode);

if(statusCode == 200){

Dom.Document doc = res.getBodyDocument();
Dom.XMLNode address = doc.getRootElement();
Dom.XMLNode Body = address.getChildElements()[0];

List<String> user_createResult = new List<String>();

Case c1 = new Case();


for(Dom.XMLNode child : Body.getChildElements()) {
    for(Dom.XMLNode subchild : child.getChildElements()) {
        for(Dom.XMLNode subchild1 : subchild.getChildElements()){
            
            if(subchild1.getName() == 'name' ||subchild1.getName() == 'title'||subchild1.getName() == 'flexField7')
            user_createResult.add(subchild1.getText());
            
            if(subchild1.getName() == 'name' && (subchild1.getText()!= '' && subchild1.getText()!= null))
            {
                c1.Cisco_Contact_Name__c = subchild1.getText();
               
            }
            else if(subchild1.getName() == 'title' && (subchild1.getText()!= '' && subchild1.getText()!= null))
            {
                c1.Cisco_Contact_Title__c = subchild1.getText();
                
            }
            else if(subchild1.getName() == 'flexField7' && (subchild1.getText()!= '' && subchild1.getText()!= null))
            {
                c1.Cisco_Contact_Mobile_Number__c = subchild1.getText();
                
            }
             else if(subchild1.getName() == 'flexField11' && (subchild1.getText()!= '' && subchild1.getText()!= null))
            {
                c1.Cisco_Contact_Internal_Phone_Number__c = '8'+''+subchild1.getText();
                
            }
              else if(subchild1.getName() == 'flexField13' && (subchild1.getText()!= '' && subchild1.getText()!= null))
            {
                c1.Cisco_Contact_Organization__c = subchild1.getText();
                
            }
             else if(subchild1.getName() == 'flexField6' && (subchild1.getText()!= '' && subchild1.getText()!= null))
            {
                c1.Cisco_Contact_Work_Phone_Number__c = subchild1.getText();
                
            }
             else if(subchild1.getName() == 'flexField14' && (subchild1.getText()!= '' && subchild1.getText()!= null))
            {
                c1.Web_Service_Error_Message__c = subchild1.getText();
                
            }
            else if(subchild1.getName() == 'address')
            {
                for(Dom.XMLNode subchild2 : subchild1.getChildElements())
                {
                    if(subchild2.getName() == 'country' && (subchild2.getText()!= '' && subchild2.getText()!= null))
                    {
                        c1.Cisco_Country__c = subchild2.getText();
                        
                    }
                }
               
            } 
        }     
    }
}
    return c1;
}
    return null;
}            
}