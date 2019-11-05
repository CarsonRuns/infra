/***************************************************************************************************
Name    : NGCC_Fetch_Email_Info
Author  : Ghattamaneni Chaithanya
Purpose : This class is controller for NGCC_Preview_Email_Flow Component, it is responsible to get the email template with merge fields
Date	: 20-feb-2019

Modification History: 

*****************************************************************************************************/
public class NGCC_Fetch_Email_Info {
    @AuraEnabled
    public static map<string,string> getemailBody(String SelectedLeadId, String TemplateName){
        map<string,string> emailmap = new map<string,string>();
        EmailTemplate et = [select id,Body from EmailTemplate where DeveloperName=:TemplateName];
        Messaging.SingleEmailMessage email = 
        Messaging.renderStoredEmailTemplate(et.id, SelectedLeadId ,null);
        if(email.getHtmlBody() != null ){
            emailmap.put(email.getHtmlBody(), email.getSubject());
        }else{
            emailmap.put(email.getPlainTextBody(), email.getSubject());
        }        
        return emailmap;
    }
    @AuraEnabled
    public static void sendemail(String body,String Subject,string Emailaddress){
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String[] sendingTo = new String[]{Emailaddress};
        email.setToAddresses(sendingTo);
        email.setSubject(Subject);
        email.setHtmlBody(body);
        List<Messaging.SendEmailResult> results ;
        try{
			results =  Messaging.sendEmail(new Messaging.Email[] { email });            
        }catch(exception e){
        }
    }
}