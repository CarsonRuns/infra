global class OpportunityRMNotification implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
        sendRMEmail();
    }
    public void sendRMEmail()
    {	
        Integer OptyLimit = Integer.valueOf(Renewals_Portfolio__c.getInstance().Opty_limit__c );
        String opptyRenewalRecordTypeId = Utilities.getOpptyRenewalRecordTypeId();
        string mailBody =String.valueOf(Renewals_Portfolio__c.getInstance().RM_Notif_mail_body__C);
        system.debug('-----rid---'+opptyRenewalRecordTypeId);
        List<Opportunity> oppList ;
        List<User> usrList ;
        try {
           oppList = [select id, name, ownerid, owner.firstname, last_ib_refresh__c from opportunity where recordtypeid= :opptyRenewalRecordTypeId
                                         and last_ib_refresh__c=LAST_n_days:7 limit :OptyLimit ];
        }
        catch (Exception e){
            System.debug('Error while fetching opportunity list : OpportunityRMNotification');
        }
        
        
        Map<Id, List<Opportunity>> rmOppMap = new Map<Id, List<Opportunity>>();     //map <ownerid, List<Opportunity>>()
        system.debug('oppList-->'+oppList);
        for(Opportunity opp: oppList){
            if(rmOppMap.containsKey(opp.ownerid)){
                List<Opportunity> rmOppList = new List<Opportunity>();
                rmOppList = rmOppMap.get(opp.ownerid);
                rmOppList.add(opp);
                rmOppMap.put(opp.ownerid, rmOppList);
            }
            else
                rmOppMap.put(opp.ownerid, new List<Opportunity>{opp});
            
        }
        system.debug('keyset in main class--->'+rmOppMap.keySet());
        
        //List<User> usrList = [select id, firstname from user where id=:rmOppMap.keySet() and isactive=true and renewal_ib_updates__c=true];
        try {
            usrList = [select id, firstname from user where id=:rmOppMap.keySet() and isactive=true and renewal_ib_updates__c=true];    
        }
        catch (exception e) {
            System.debug('Error while fetchin user details : OpportunityRMNotification');
        }
        
        //and id = '005800000050KrZAAU' // Ricahrds Id for testing
        system.debug('user in main class-------->'+usrList);
        Map<Id, User> usrMap = new Map<Id, User>();
        for(User usr: usrList){
            usrMap.put(usr.id, usr);
        }
        system.debug('usrMap-->'+usrMap);
        List<Messaging.SingleEmailMessage> mails ;
        mails = new List<Messaging.SingleEmailMessage>();
        
        for(Id rmid: rmOppMap.keyset()){
            if(usrMap.containsKey(rmid)){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                List<String> sendTo = new List<String>();
                //sendTo.add('0053400000BnLCAAA3'); 
                sendTo.add(rmid);
                mail.setToAddresses(sendTo);
                mail.setReplyTo('do_not_reply@cisco.com');
                mail.setSenderDisplayName('do_not_reply@cisco.com');
                mail.setSubject('Opportunities updated based on Contract and Installed Base changes');
                list<Opportunity> opptyList = rmOppMap.get(rmid);
                String body = '';
                body = BodyFormat(opptyList) ;
                system.debug('body--->'+body);
                //mail.setHtmlBody('Hello '+usrMap.get(rmid).firstname+','+'<br/><br/> The following renewal opportunities have been updated based on Contract and Installed Base changes : <br/><br/>' + body + '<br/> For more information, please review the Field History within the renewal opportunity. </br> <br/>Thanks');
                mail.setHtmlBody('Hello '+usrMap.get(rmid).firstname+','+mailBody.replace('|mail_body|',body ));
                mails.add(mail);        
            }   
        }
        if(!mails.isEmpty() && Renewals_Portfolio__c.getInstance().RM_IB_Notification__c==true){
            System.debug('sending emails');
            Messaging.sendEmail(mails);
        }
    }
    
    public String BodyFormat(List<Opportunity> lst)
    {
        system.debug('opportunity list for rm '+lst);
        String str = '' ;
        String OrgUrl = String.valueOf(URL.getSalesforceBaseUrl().getHost());
        for(Opportunity op : lst)
        {
            str += '<tr><td><a href="'+OrgUrl+'/'+op.id+'">'+ op.name +'</a></td>'+'<td>'+ op.last_ib_refresh__c +'</td></tr>' ;
        }
        system.debug('str-->'+str);
        str = str.replace('null' , '') ;
        String finalStr = '' ;
        finalStr = '<table border="1"> <td> Opportunity Name </td> <td> Refresh Date </td> '+ str +'</table>' ;
        return finalStr ;
    }
}