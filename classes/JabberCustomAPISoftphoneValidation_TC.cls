@IsTest(SeeAllData=true)
private class JabberCustomAPISoftphoneValidation_TC{
    //method to create account
    static Id createAccount(){
        Account testAccount = new Account();
        testAccount.Name = 'testAccount';
        testAccount.AddressLine1__c = 'testLine';
        testAccount.City__c = 'Delhi';
        testAccount.Country__c = 'INDIA';
        testAccount.CRAddressLine1__c = 'testLine';
        testAccount.CRCity__c = 'Delhi';
        testAccount.CRCountry__c = 'INDIA';
        insert testAccount;
        return testAccount.Id;
    }
    
    //method to create contact
    static Id createContact(Id accountId){
        Contact testContact = new Contact();
        testContact.AccountId = accountId;
        testContact.FirstName = 'Scott';
        testContact.LastName = 'Tiger';
        insert testContact;
        return testContact.Id;
    }
    
    //method to create lead
    static Id createLead(){
        Lead testLead = new Lead();
        testLead.LastName= 'testLead';
        testLead.Company = 'CISCO';
        testLead.Status = '1 Waiting';
        testLead.Address_Line_1__c = 'testLine';
        testLead.CustomCity__c = 'Delhi';
        testLead.CustomCountry__c = 'INDIA';
        testLead.Country_English__c = 'INDIA';
        insert testLead;
        return testLead.Id;
    }
    
    //method to create opportunity
    static Id createOpportunity(Id accountId){
        Opportunity testOppty = new Opportunity();
        testOppty.Name = 'testOppty';
        testOppty.AccountId = accountId;
                testOppty.CloseDate = Date.Today() + 1;
        testOppty.StageName = '1 - Prospect';
        testOppty.Lost_Cancelled_Reason__c = 'Cancelled - Opportunity created in error';
        testOppty.Competitors__c = 'Aastra';
        testOppty.Dollar_Amount_Greater_than_5M__c = 'Less than 5 Million';
        insert testOppty;
        return testOppty.Id;
    }
    
    private static testMethod void testCodePrefix(){
        Id accountId = createAccount();
        Id opptyId = createOpportunity(accountId);
        Id contactId = createContact(accountId);
        Id leadId = createLead();
                map<string,CountryCodeMapping__c> mapCountryMappingCustomSetting = CountryCodeMapping__c.getAll();

                //inserting record in custom setting for restricting test class to fail
                if(mapCountryMappingCustomSetting.isEmpty()){
                            CountryCodeMapping__c customSetting = new CountryCodeMapping__c();
                            customSetting.name = 'INDIA';
                            customSetting.Code__c = '91';
                            insert customSetting;
               }
        
        //sending the http request for account
        RestRequest req = new RestRequest(); 
                RestResponse res = new RestResponse();
        req.requestURI = System.Label.Jabber_Country_Code_Search_URL+accountId;
        req.httpMethod  = 'GET';
                RestContext.request = req;
                RestContext.response = res;

                string countryCode = JabberCustomAPISoftphoneValidation.getCountryCode();
        
        //sending the http request for opportunity
        req = new RestRequest(); 
                res = new RestResponse();
        req.requestURI = System.Label.Jabber_Country_Code_Search_URL+opptyId;
        req.httpMethod  = 'GET';
                RestContext.request = req;
                RestContext.response = res;

                countryCode = JabberCustomAPISoftphoneValidation.getCountryCode();
        
        //sending the http request for contact
        req = new RestRequest(); 
               res = new RestResponse();
        req.requestURI = System.Label.Jabber_Country_Code_Search_URL+contactId;
        req.httpMethod  = 'GET';
                RestContext.request = req;
                RestContext.response = res;

        countryCode = JabberCustomAPISoftphoneValidation.getCountryCode();

        //sending the http request for lead
        req = new RestRequest(); 
                res = new RestResponse();
        req.requestURI = System.Label.Jabber_Country_Code_Search_URL+leadId;
        req.httpMethod  = 'GET';
                RestContext.request = req;
                RestContext.response = res;
        
                countryCode = JabberCustomAPISoftphoneValidation.getCountryCode();
    }
}