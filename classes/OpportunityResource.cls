@RestResource(urlMapping='/MyOpportunity/*')

global with sharing class OpportunityResource {

    public static void writeLog(String Origin, String typ, String message, datetime t1, String tid){
    //write log asynchronously in future
        try{
            if (message <> null && message.length() > 32000){message=message.substring(0,32000);}
        
            Tx_Log__c l = new Tx_Log__c(
                name=tid,
                type__c=typ,
                originated__c=Origin,
                message__c=message,                
                duration__c=(datetime.now().getTime()-t1.getTime())
            );
            insert l;    
        }
        catch (Exception e){
            System.debug('failed to write log for '+Origin+' '+typ+' '+message+' '+tid);
        }
    
    }
    
    @HttpGet
    global static String doGet(RestRequest req, RestResponse res){
        DateTime t1 = datetime.now();    
        String returnValue;
        String param = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1); 

        String tid=UserInfo.getUserName()+':'+t1;
        String message;

        if (param == 'pageSetup'){ 
            returnValue = getPageSetupInfo();
        }
        else{
            returnValue = getAccountInfo(param);
        }

        writeLog('OpportunityResource', 'doGet', param, t1, tid);
        
        return returnValue;
    }
  
    
    public Static String getPageSetupInfo(){
   
        User currUser = [Select Position_1__c from User where id = :UserInfo.getUserId()];
        String fPostns = currUser.Position_1__c;        
        Pattern nlPattern = Pattern.compile('\r\n+');
        if(fPostns<>null){ fPostns =  nlPattern.matcher(fPostns).replaceAll(';');  }

        String CompValueLabel;
        Schema.DescribeFieldResult f = Opportunity.Competitors__c.getDescribe();
        f = f.getSObjectField().getDescribe();
        for(Schema.PicklistEntry pe : f.getPicklistValues()) {
            if (CompValueLabel == null){ CompValueLabel= pe.getValue() + ':' + pe.getLabel() + ';'; }
            else{ CompValueLabel+= pe.getValue() +':'+ pe.getLabel() + ';' ;}
        }
//        Cookie competitorsCookie= new Cookie('competitors',CompValueLabel,null,cExpire,false);
//        res.addCookie(competitorsCookie);      

        return fPostns +'^'+ CompValueLabel;    

    
    }
    
    public Static String getAccountInfo(String aName){
        Pattern spacePattern = Pattern.compile('%20');
        aName = spacePattern.matcher(aName).replaceAll('%');        
        String query = 'Select Id, Name from Account where recordTypeId = \''+ Utilities.getAccountEndUserRecordTypeId() +'\' and name like \'%'+ aName + '%\' limit 100';//49000';
        List<account> accountList = Database.query(query);
        String accts;
        for (account a: accountList){
            if (accts == null) accts = a.Name + ':' + a.Id + ';';
            else accts += a.Name + ':' + a.Id + ';';
        }

        if (accts == null) accts = 'no matches';
        return accts;
    }
    
    @HttpPost
    global static String doPost(RestRequest req, RestResponse res, String Name, Date CloseDate, String fPostn, String AccountId ){
        DateTime t1 = datetime.now();            
        String tid=UserInfo.getUserName()+':'+t1;
        String message;
        String retValue;
    
    
        Opportunity o = new Opportunity();
        o.Name = Name;
//        o.StageName = '1 – Prospect';
        o.StageName = '1 - Prospect';
        o.CloseDate = CloseDate;
        o.position__c = fPostn;
        o.AccountId = AccountId;
        o.expected_product__c=0;
        Utilities.setValidationSkip(true);//skips validation rules
        Utilities.setSkip(true);//skips certain trigger functionality
        insert o;
        
        writeLog('OpportunityResource', 'doPost', 'oppty '+ o.Id+'\nName: '+Name+'\nCloseDate: '+CloseDate+'\nfPostn: '+fPostn+'\nAccount: '+AccountId, t1, tid);
        
        //return 'created ' + o.Id;
        if (o.Id <> null){
            retValue= '{"status":"success", "oId":"' + o.Id + '"}';
        }
        else retValue='{"status":"error"}';
        
        return retValue;
        
    }
}