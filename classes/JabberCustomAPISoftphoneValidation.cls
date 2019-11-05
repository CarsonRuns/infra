@RestResource(urlMapping='/GetCountryCode/*')
global class JabberCustomAPISoftphoneValidation{
    @HttpGet
    global static string getCountryCode(){
        string country;
        string code='';
        string recordId;
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

       //SFDC TEST CASE 09308460 . Testing workaround to force clients to not cache the response.  Needed for IE as it is aggresive in using cache for xmlHttp requests 
        res.addHeader('Cache-Control', 'no-cache');
        // END SFDC TEST

        map<string,CountryCodeMapping__c> mapCountryCode = CountryCodeMapping__c.getAll();
        recordId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        if(recordId.startsWith('00Q')){
            Lead lead = [Select Id,CustomCountry__c,Country_English__c from Lead where Id = :recordId];
            if(lead.CustomCountry__c != '' && lead.CustomCountry__c != null){
                country = lead.CustomCountry__c;
            }else{
                country = lead.Country_English__c;
            }
            system.debug('***lead.CustomCountry__c='+ lead.CustomCountry__c);
            system.debug('***lead.Country_English__c='+ lead.Country_English__c);
        }
        else if(recordId.startsWith('001')){
            Account account = [Select Id,CRCountry__c from Account where Id = :recordId];
            country = account.CRCountry__c;
        }
        else if(recordId.startsWith('003')){
            Contact contact = [Select Id,Account.CRCountry__c from Contact where Id = :recordId];
            country = contact.Account.CRCountry__c;
        }
        else if(recordId.startsWith('006')){
            Opportunity opportunity = [Select Id,Account.CRCountry__c from Opportunity where Id = :recordId];
            country = opportunity.Account.CRCountry__c;
        }
        else if(recordId.startsWith('500'))
        {
          case caseRec = [select Id, CaseNumber,Contact.Account.CRCountry__c from case where Id =: recordId];
          country = caseRec.Contact.Account.CRCountry__c;
        } 
        if(country != '' && country != null){
            if(mapCountryCode.containsKey(country.toUpperCase())){
                
                code =  mapCountryCode.get(country.toUpperCase()).Code__c;
                system.debug('*** settings found'+ code);
            }
        }         
        return code;     
    }   
}