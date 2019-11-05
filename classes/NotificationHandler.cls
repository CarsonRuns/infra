/*
Author          : Awnish Kumar
Release         : August 9,2019
Created         : June 13, 2019
Functionality   : Notification Trigger Handler

Modification History:
Itrack#        Date        Author              Change 

*/
public class NotificationHandler implements System.Queueable, Database.AllowsCallouts {
    public String sObjName;
    
    public NotificationHandler(String sObjName){
        this.sObjName = sObjName;
    }
    public void execute(System.QueueableContext objContext)
    {
        String authEndPoint = Utilities.getConstant_CS('NAAS Authentication');
        String naasAPIEndPoint = Utilities.getConstant_CS('NAAS End Point');
        String naasAPIBody = Utilities.getConstant_CS('NAAS API Body');
        String opertaionsMailer = Utilities.getConstant_CS('NAAS Operations Mailer');
        naasAPIBody = naasAPIBody.replace('objectName', sObjName);
        Http authHttp = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(authEndPoint);
        OAuth2 authResponse = new OAuth2();
        try{
            HttpResponse res = authHttp.send(req);
            authResponse = (OAuth2)JSON.deserialize(res.getbody(), OAuth2.class);
            String authToken = authResponse.access_token;
            if(authToken!=null){
                Http naasAPICallHttp = new Http();
                HttpRequest naasAPICallReq = new HttpRequest();
                naasAPICallReq.setHeader('Authorization','Bearer '+authToken);
                naasAPICallReq.setMethod('POST');
                naasAPICallReq.setHeader('Content-Type',  'application/json');
                naasAPICallReq.setHeader('Accept',  'application/json');
                naasAPICallReq.setEndpoint(naasAPIEndPoint);
                naasAPICallReq.setBody(naasAPIBody);
                HttpResponse naasAPICallRes = naasAPICallHttp.send(naasAPICallReq);
                //Notify Support Team incase failure occurs in the Mule API Call
                if(!naasAPICallRes.getBody().Contains('Completed')){
                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                    message.toAddresses = new String[] {opertaionsMailer};
                    message.subject = 'Error Occured in the Daily Digest Mule API Call';
                    message.htmlbody = naasAPICallRes.getBody();
                    Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                }
            }
        }
        catch(exception ex){
            system.debug(ex);
        }
    }
    //Wrapper Class for the Auth Token Response
    class OAuth2
    {
        public String expires_in{get;set;}
        public String token_type{get;set;}
        public String access_token{get;set;}
    }
}