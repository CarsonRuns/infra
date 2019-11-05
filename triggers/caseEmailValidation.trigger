trigger caseEmailValidation on EmailMessage (before Insert,before delete) { 
    
    Case[] caseUpdates = new Case[]{};
    Set<Id> CasesIds =  new Set<Id>();


    if(Trigger.isInsert)
    {
        for (EmailMessage c :  trigger.new)
        {
            if(c.incoming) CasesIds.add(c.ParentId);
        }
    }

    Map<Id,Case> casesForIncomingEmail =  new Map<Id,case>([Select Status,OwnerId,recordtypeid from case where id IN :CasesIds]);

    if(Trigger.isDelete && !Utilities.skipUser()){
        for(EmailMessage c : Trigger.old) {
            c.addError('Case emails cannot be deleted');
        }
    }
    else if(Trigger.isInsert){
        for(EmailMessage c : Trigger.new) {
            if(c.Incoming){
                Case temp = casesForIncomingEmail.get(c.parentId);
                
                String ownerID = temp.OwnerId; 
                Boolean ownerFlag = ownerID.substring(0,3).contains('00G');
                
                temp.Partner_Email__c = '<b>From: </b>' + c.FromName + '<BR><b>Email Address: </b>' + c.FromAddress + '<BR><b>Subject: </b>' + c.subject + '<BR><BR><b>Email Body: </b><BR><BR>' + c.TextBody;                 temp.Partner_Email_Date__c = datetime.now();
                caseUpdates.add(temp); 
                
                String EmailBody ;
                if(c.htmlBody !=null)
                EmailBody = c.htmlBody;
                else
                EmailBody = c.textBody;
                
                //nishi - start
                List<User> engPtoDetails = [select Id, Out_Of_Office_Start_Time__c, Out_Of_Office_End_Time__c, Out_Of_Office_Message__c ,Name from User where Id =: ownerID];
                if(engPtoDetails.size() > 0){
                    for(User each : engPtoDetails){
                        if(each.Out_Of_Office_Start_Time__c<= System.Now() && each.Out_Of_Office_End_Time__c>= System.Now()){
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                            String[] toAddresses = new String[] {c.FromAddress};
                            mail.setToAddresses(toAddresses);
                            mail.setSubject(System.Label.Out_Of_Office_Email_Subject);
                            mail.setOrgWideEmailAddressId('0D2800000004D5o');
                            
                            //String body = 'Hello,<Br/><Br/>I am OOO from '+ each.PTO_Start_Date__c.format() + ' to ' + each.PTO_End_Date__c.format() + ' with limited access to email. Please expect a delay in response.<Br/><Br/>Thanks,<Br/>'+each.User__r.Name; 
                            if(String.isBlank(each.Out_Of_Office_Message__c)){
                                String body = 'Hello,<Br/><Br/>I am OOO with limited access to email. Please expect a delay in response.<Br/><Br/>Thanks,<Br/>'+each.Name; 
                                mail.setHtmlBody(body);
                            }
                            else{
                                mail.setHtmlBody(each.Out_Of_Office_Message__c);
                            }
                            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                        }
                    }
                }
                //end
                
                // Auto Reply to Case Owner for TSN Cases
                                
                if(CaseCloseEmailBounce.OwnerFirstMail && !ownerFlag && temp.OwnerId != Utilities.getCaseManagementUserId() 
                && temp.recordtypeId == Utilities.getCaseTSNRecordTypeId() && temp.status !='Closed')  
                {
                    String tempmail = [Select Email from User where Id =:temp.OwnerId].Email;
                    CaseCloseEmailBounce.sendOwnerEmail(temp.id,tempmail,c.FromName,c.FromAddress,c.Subject,EmailBody);
                    CaseCloseEmailBounce.OwnerFirstMail = False;
                }
                
                //close case email bounce
                
                if(temp.status =='Closed' && temp.recordtypeId == Utilities.getCasePHRecordTypeId()) // PH Email Bounce
                {
                    CaseCloseEmailBounce.sendCloseCaseBounceEmail(temp.id,c.FromAddress,c.Subject,EmailBody,c.FromName);
                }
                else if(temp.status =='Closed' && temp.recordtypeId == Utilities.getCasePDIRecordTypeId()) // PDI email Bounce
                {
                    CaseCloseEmailBounce.sendCloseCaseBounceEmail(temp.id,c.FromAddress,c.Subject,EmailBody,c.FromName);
                }
                else if(temp.status =='Closed' && temp.recordtypeId == Utilities.getCaseTSNRecordTypeId()) // TSN email Bounce
                {
                    System.debug('Inside TSN incoming email>>>');
                    CaseCloseEmailBounce.sendCloseCaseBounceEmail(temp.id,c.FromAddress,c.Subject,EmailBody,c.FromName);

                }
            }
        }
    }
    if(caseUpdates.size() > 0){
        try{
            Utilities.setValidationSkip(true); //skips validation rules
            update caseUpdates;
        }
        catch(exception e){}
    }
}