Public class CaseCloseEmailBounce {

// SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdateGet(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }

public static boolean OwnerFirstMail=TRUE;

public static void sendCloseCaseBounceEmail(String CaseId,String FromAddress,String Subject,String textBody,String FromName)
{
    case c =  [select Id,BounceBackEmailCounter__c from case where id =:caseId];
    if(flsUpdateGet(Case.BounceBackEmailId__c )){  //SCAVA FIX 
    c.BounceBackEmailId__c = FromAddress;
    }
    if(flsUpdateGet(Case.BounceBackFromName__c)) { //SCAVA FIX
    c.BounceBackFromName__c = FromName;
    }
    if(flsUpdateGet(Case.BounceBackSubject__c )){  //SCAVA FIX
    c.BounceBackSubject__c = Subject;
    }

    if(textBody.length() >=32000)
    c.BounceBackTextBody__c = textBody.substring(0,31999);
    else
    if(flsUpdateGet(Case.BounceBackTextBody__c)){ //SCAVA FIX
    c.BounceBackTextBody__c = textBody;
    }
    
    if(c.BounceBackEmailCounter__c == null)
    if(flsUpdateGet(Case.BounceBackEmailCounter__c)){  //SCAVA FIX
    c.BounceBackEmailCounter__c = 1;
    }
    else
    c.BounceBackEmailCounter__c = c.BounceBackEmailCounter__c+1;
    
    Utilities.setValidationSkip(true); //skips validation rules
    update c;
}

public static void sendReplyForDeletedCases(String FromAddress,String Subject,String textBody)
{
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    String[] toAddresses = new String[] {FromAddress};
    mail.setToAddresses(toAddresses);
    mail.setSubject(Subject);
    mail.setOrgWideEmailAddressId('0D2800000004D5o');
    String body = 'Hello,<Br/><Br/>We were unable to associate your email with an existing case. <Br/>While there are several possible reasons for this, the most common cause is that the system was unable to read the embedded case identifiers in the email.  Please attempt to send your email again, making sure to include the entire “ref:*********:ref”  portion in  the subject line.  This can be copied from the subject line of the original email response sent to you by our system.<Br/><Br/>In the event that you continue to have difficulties, please visit the following links for information on contacting us by phone, web or email so that we can further assist you: <Br/><Br/>For PDI Help Desk related questions: <Br/><Br/>PDI Help Desk Website:  http://www.cisco.com/go/pdihelpdesk<Br/><Br/>PDI Help Desk Email:  pdihd-team@cisco.com<Br/><Br/>For Partner Helpline related questions: <Br/><Br/>Partner Helpline Website:  http://www.cisco.com/go/ph<Br/><Br/>Partner Helpline Support Team: 1-800-GO-CISCO<Br/><Br/>Partner Helpline Community:<Br/><Br/>https://www.myciscocommunity.com/community/partner/programs_tools/partnerhelpline<Br/><Br/><Br/>Sincerely, <Br/><Br/>Cisco PDI Help Desk and Partner Helpline<Br/><Br/>';
     if (textBody != null)
    {
        body = body + textBody ;
    }
    mail.setHtmlBody(body);
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    system.debug('inside ph email bounce');
}

public static void sendOwnerEmail(String CaseId,String OwnerMail,String FromName,String FromAddress,String Subject,String textBody)
{
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    String[] toAddresses = new String[] {OwnerMail};
    // String[] ccAddresses = new String[] {OwnerMail};
    mail.setToAddresses(toAddresses);
    // mail.setCcAddresses(ccAddresses);
    mail.setSubject(Subject);
    String body = 'Hello,<Br/><Br/>You have received the following mail from the case requester '+ FromName +'(' + FromAddress + ')'+'<Br/><Br/>';
    if (textBody != null)
    {
        body = body + textBody ;
    }
    mail.setHtmlBody(body);
    mail.setOrgWideEmailAddressId('0D2800000004DKj');
    String EmailFailure = null;
    
    try {
        Messaging.SendEmailResult[] mailResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        if ( !mailResult[0].isSuccess() ) {
            EmailFailure = 'Email Failed: ' + mailResult[0].getErrors()[0].getMessage();
        }
    }
    catch(DmlException dmlEx) {
        EmailFailure = 'Email Failed: ' + dmlEx;
    }
    catch(System.EmailException emlEx) {
        EmailFailure = 'Email Failed: ' + emlEx;
    }
}


}