public class VcPDBUpdateServiceInvoke
{

// SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdate(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }
    
// SCAVA Helper Method to validate Create Access at field level
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }
    
public static Integer Permission;

public static Integer getPermission(){
        System.debug('before group query');
        if ( Permission == null ) {
                        Permission = [Select count() from GroupMember g  where Group.Name = :Utilities.getPAGroupName() and UserOrGroupId = :UserInfo.getUserId()];
                        System.debug('after group query');
        }
        return Permission;
}


public @future(callout=true) static void CallPdbUpdateService(set<Id> AccountIds,Date LastUsedDate)
{
    List<Account> AccountsToUpdate =  New List<Account>();
    List<Tx_Log__c> Logs = new List<Tx_Log__c>();
    String Response = '';
    String Messeage = '';
    String URL = Utilities.getConstant_CS('VC Update Svc Url'); 
    Blob VCHeaderValue = Blob.valueOf( Utilities.getConstant_CS('VC user:pass'));
    String VCAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(VCHeaderValue);
        
    Date d = LastUsedDate;
    Integer m = d.month();
    Integer dy = d.day();
    Integer yr = d.year();
    Datetime dt =Datetime.newInstance(yr,m,dy);
    String dateStr = String.valueOf(dt.format('MM/dd/yyyy'));
    
        
    for(Account a : [Select Id,Country__c,PDB_BE_ID__c from Account where Id IN : AccountIds])
    {
        //Sfdc Update
        //SCAVA FIX
        if(flsUpdate(Account.VC_Used_Date__c))
        {
        a.VC_Used_Date__c = LastUsedDate;
        }
        if(flsUpdate(Account.VC_Used_Flag__c))
        {
        a.VC_Used_Flag__c = True ;
        }
        AccountsToUpdate.add(a);  
            
        if(AccountIds.size()<11)
        {
            String flag = 'Y';
            String RequestSting ='<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'+
                                 '<VCSFDCUpdateRequest xmlns="urn:cisco:names:message:vc">'+
                                  '<vcsfdcupdaterequest>'+
                                        '<requestorApp>SFDC</requestorApp>'+
                                        '<partnerId>'+a.PDB_BE_ID__c+'</partnerId>'+
                                        '<country>'+Utilities.getISOCountryCode(a.Country__c)+'</country>'+
                                        '<vcUsedFlag>'+flag+'</vcUsedFlag>' +
                                        '<vcLastUsedDate>'+dateStr+'</vcLastUsedDate>' +
                                        '<vcRequestTimeStamp>10-06-2010 13:30:03 PDT</vcRequestTimeStamp>'+
                                  '</vcsfdcupdaterequest>'+
                               '</VCSFDCUpdateRequest>';

            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(URL);
            req.setMethod('POST');
            req.setHeader('Authorization', VCAuthorizationHeader);        
            req.setHeader('content-type', 'text/xml; charset=utf-8'); 
            req.setBody(RequestSting);
            System.debug('Check this out:'+RequestSting);
            System.debug('Check this out:'+req);
            Boolean Exc = false;
            DateTime T1 = System.now();
            HttpResponse res ;
            try
            {
                res = h.send(req);
                Response = res.getBody();
                
            }
            catch (Exception e)
            {
                Exc = true;
                Messeage = e.getMessage();
            }
        
        
        
//log the web service call.
            Tx_Log__c Log  = new Tx_Log__c();
            //SCAVA FIX
            if(flsGet(Tx_Log__c.name))
            {
            Log.name = UserInfo.getUserName()+':'+datetime.now()+':'+ a.Id;
            }
            if(flsGet(Tx_Log__c.type__c))
            {
            Log.type__c = 'updateVCEligible';
            }
            if(flsGet(Tx_Log__c.originated__c))
            {
            Log.originated__c = 'VcPDBUpdateServiceInvoke';
            }
            if(flsGet(Tx_Log__c.duration__c))
            {
            Log.duration__c = System.now().getTime() - T1.getTime();
            }
            if(flsGet(Tx_Log__c.exception__c))
            {
            Log.exception__c = Exc;
            }
            System.debug(Exc);
            
            if(flsGet(Tx_Log__c.message__c))
            {
                if(Exc)Log.message__c = Messeage;
            }
            else
            {
              //System.debug(Response);
                try
                {
                    Log.message__c = getMessage(Response);
                }
                catch (exception e)
                {
                    Log.message__c = 'Response Parse Error';
                    Log.message__c = Log.message__c + e.getMessage();
                }
                
            }
            Logs.add(Log);        
        }
        
    }
    if(Logs.size()>0)
        insert Logs;

    if(AccountsToUpdate.size()>0)
    {
        Update AccountsToUpdate;
        Utilities.setskipFuture(true);
    }
    
}

Public Static String getMessage(String response)
    {
        String Message = '';
        String firstChar = response.substring(0,1);
        Boolean ServiceUp = false;
        if (firstChar == '<')
        {
            ServiceUp = true;
            XmlStreamReader reader = new XmlStreamReader(response);
            while(reader.hasNext())
            {
                if (reader.getLocalName()=='vcsfdcupdateresponse')
                    {
                        ServiceUp = true;
                    }

                if ( reader.getLocalName()=='partnerId')
                {
                    reader.next();
                    //system.debug(reader.getEventType());
                    Message = Message + ':PartnerId =' + reader.getText() ;
                    reader.next();
                }
                if ( reader.getLocalName()=='country' )
                {
                    reader.next();
                    //system.debug(reader.getEventType());
                    Message = Message + ':ISO country code =' + reader.getText() ;
                    reader.next();
                }
                if ( reader.getLocalName()=='vcResponseTimeStamp' )
                {
                    reader.next();
                    //system.debug(reader.getEventType());
                    Message = Message +':vcResponseTimeStamp =' + reader.getText() ;
                    reader.next();
                }
                if ( reader.getLocalName()=='vcResponseCode')
                {
                    reader.next();
                    //system.debug(reader.getEventType());
                    Message = Message + ':vcResponseCode =' + reader.getText() ;
                    reader.next();
                }
                
                reader.next();
            } 
                
        }
        else
            Message = 'VC service is not accessible';            
        return Message;
        }


}