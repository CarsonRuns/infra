public class JabberPhoneCleanUpcls{
     Map<string,CountryCodeMapping__c> mapCountryCode = CountryCodeMapping__c.getAll();
     List<Tx_Log__c> lstErrObj = new List<Tx_Log__c>();

//Used for Cleaning the Phone number from Contact
    public void JabberContactPhoneClean(List<Contact> lstContact,Boolean accContactsUpdate){        
        Set<Id> setAccountId=new Set<Id>();      
        for (Contact objCon: lstContact) 
        {
            setAccountId.add(objCon.AccountId);        
        }
        Map<id,Account> accMap = new Map<id,Account>([Select id,CRCountry__c from Account where Id IN :setAccountId]);
        for (Contact con: lstContact) {

            string code='';
            string newPhone='';
            try
            {
                   if(con.Phone == null || con.Phone == ''){
                      con.Jabber_Phone_Number__c = '';
                   }
                  else {
                    newPhone = JabberPhoneClean(con.Phone);                  
                    Account acc =(Account) accMap.get(con.AccountId);
                    if(acc.CRCountry__c != null && acc.CRCountry__c != '' && mapCountryCode.containsKey(acc.CRCountry__c.toUpperCase())){
                        code =  mapCountryCode.get(acc.CRCountry__c.toUpperCase()).Code__c;
                    }
                     
                    integer i=code.length();
                    if(newPhone.length() >= i && code != newPhone.substring(0,i))
                    {
                        con.Jabber_Phone_Number__c=code+newPhone;
                    }
                    else
                    {
                        con.Jabber_Phone_Number__c=newPhone;
                    }
                }
            }
            catch(Exception e)
            {
                Tx_Log__c newErrorRecord = new Tx_Log__c();
                newErrorRecord.name = 'JabberPhoneCleanUpcls';
                newErrorRecord.originated__c = 'JabberPhoneCleanUpcls';
                newErrorRecord.type__c = e.getTypeName();
                newErrorRecord.exception__c = true;
                newErrorRecord.message__c = 'Contact Name: '+ con.Name + 
                    '\nRecord Id: '+con.Id+
                    '\nAccount Id: '+con.accountId + 
                    '\nError Message: '+ e.getMessage()+e.getCause()+
                    '\n Error Line #'+ e.getLineNumber();
                    
                lstErrObj.add(newErrorRecord);
            }
        }
        
        if(!lstErrObj.isEmpty())
        {
            database.insert(lstErrObj, false);
        }
        if(accContactsUpdate)
        {
            database.update(lstContact,false);
        }
    }

//Used for Cleaning the Phone number from Account
    public void JabberAccountPhoneClean(List<Account> lstAccount){
              
        for (Account acc: lstAccount) {
            string newAccPhone='';
            string code='';
            try
            {
                if(acc.Phone == null || acc.Phone == ''){
                    acc.Jabber_Phone_Number__c = '';
                }
                else {
                    newAccPhone = JabberPhoneClean(acc.Phone);           
                    if(acc.CRCountry__c != null && acc.CRCountry__c != '' && mapCountryCode.containsKey(acc.CRCountry__c.toUpperCase())){
                         code =  mapCountryCode.get(acc.CRCountry__c.toUpperCase()).Code__c;
                    }
                    integer i=code.length();
                    if(newAccPhone.length() >= i && code != newAccPhone.substring(0,i))
                    {
                        acc.Jabber_Phone_Number__c=code+newAccPhone;
                    }
                    else
                    {
                        acc.Jabber_Phone_Number__c=newAccPhone;
                    }
                }
            }
            catch(Exception e)
            {
                Tx_Log__c newErrorRecord = new Tx_Log__c();
                newErrorRecord.name = 'JabberPhoneCleanUpcls';
                newErrorRecord.originated__c = 'JabberPhoneCleanUpcls';
                newErrorRecord.type__c = e.getTypeName();
                newErrorRecord.exception__c = true;
                newErrorRecord.message__c = 'Account Name: '+ acc.Name + 
                    '\nRecord Id: '+acc.Id+
                    '\nError Message: '+ e.getMessage()+e.getCause()+
                    '\n Error Line #'+ e.getLineNumber();
                lstErrObj.add(newErrorRecord);
            }
        }
        if(!lstErrObj.isEmpty())
        {
            database.insert(lstErrObj, false);
        }
    }
    
    public string JabberPhoneClean(String ph)
    {
        string cleanPhone='';
        cleanPhone=ph.toLowerCase();
           
        integer extIndex= cleanPhone.indexOfAny('abcdefghijklmnopqrstuvwxyz');
        if(extIndex>-1)
        {
            cleanPhone = cleanPhone.substring(0,extIndex).replaceAll('[^\\d]','');
        }
        else
        {
            cleanPhone = cleanPhone.replaceAll('[^\\d]','');
        }
        if(cleanPhone.startsWith('0'))
        {
            boolean removeZero = true; 
                while (removeZero) {
                    if(cleanPhone.startsWith('0'))
                    {
                        cleanPhone= cleanPhone.substring(1); 
                    }
                    else
                    {
                        removeZero=false;
                    }
                }
        }
        
        return cleanPhone;
    }
}