/************************************************************************************************************************************
Name    : APICalloutController
Author  : C360 Dev team
Purpose : Calling external service for getting TAC and NPS data and display in MY Customers page
Date    : 02/14/2019
Change History : 3/13/2019 Updated logic to apply Mycustomer filter for TAC and NPS
*************************************************************************************************************************************/
public class APICalloutController {
    //Method for TACAPI callout
    @AuraEnabled
    public static String doTACAPI(List<Id> customerids, boolean viewall){
        system.debug('TAC customerids'+customerids);
        Map<String,Account> mapCustIdAccount = new Map<String,Account>();
        string custIds='';
        List<Account> accountBUList = [Select Id,Name,AccountNumber,RecordtypeId from Account where (Id in :customerids or Parent.Id in :customerids) and RecordType.Name IN ('Customer','Business Unit') Order by AccountNumber ASC];
        
        // List<Account> accountBUList = [Select Id,Name,AccountNumber,RecordtypeId,(Select Id,Name,AccountNumber,RecordtypeId from childAccounts) from Account where Id in: customerids Order by AccountNumber DESC];               
        system.debug('TAC accountBUList'+accountBUList);
        ObjectRecordTypeIds__c accRTId = ObjectRecordTypeIds__c.getOrgDefaults();
        for(Account acc:accountBUList){ 
            if(acc.AccountNumber != null){
                if(acc.RecordtypeId == accRTId.Account_Customer_RecordType_18__c){
                    custIds += (accountBUList.size()==0?'':'%20')+acc.AccountNumber;
                }
                
                mapCustIdAccount.put(acc.AccountNumber,acc);
                
            }
        }  
        String customersId = '('+custIds+')';
        system.debug('CustIDs'+custIds);
        String res = API_TAC(customersId,viewall);
        system.debug('Res'+res);
        List<AccountTACWrapper> AccountWrapList = new List<AccountTACWrapper>();
        if(String.isNotBlank(res)){
            List<Object> resMap =(List<Object>)JSON.deserializeUntyped(res);
            string custNumber = '';
            String businessunitName='';
            Integer sav1; Integer sav2; Integer sav3;
            
            for(Object obj : resMap){
                String str = JSON.serialize(obj);
                Map<String,Object> responseMap = (Map<String,Object>) JSON.deserializeUntyped(str);
                if(mapCustIdAccount.containskey(String.valueOf(responseMap.get('business_unit_id')))){
                    custNumber = String.valueOf(responseMap.get('business_unit_id'));
                    businessunitName = String.valueOf(responseMap.get('business_unit_name'));
                    sav1 =Integer.valueOf(responseMap.get('sev1'));
                    sav2 =Integer.valueOf(responseMap.get('sev2'));
                    sav3 =Integer.valueOf(responseMap.get('sev3'));
                }
                AccountTACWrapper accWrapper = new AccountTACWrapper(mapCustIdAccount.get(custNumber),businessunitName,sav1,sav2,sav3);
                AccountWrapList.add(accWrapper);
            }
        }
        return JSON.serialize(AccountWrapList);
    }
    //Method to NPS API callout
    @AuraEnabled
    public static String doNPSAPI(List<Id> customerids,boolean viewall){ 
        system.debug('NPS customerids'+customerids);
        string custIds ='';     
        // List<Account> accountBUList = [Select Id,Name,AccountNumber,RecordtypeId,(Select Id,Name,AccountNumber,RecordtypeId from childAccounts) from Account where Id in: customerids Order by AccountNumber ASC];               
        
        List<Account> accountBUList = [Select Id,Name,AccountNumber,RecordtypeId from Account where (Id in :customerids or Parent.Id in :customerids) and RecordType.Name IN ('Customer','Business Unit') Order by AccountNumber ASC];
        Map<String,Account> mapCustIdAccount = new Map<String,Account>();
        ObjectRecordTypeIds__c accRTId = ObjectRecordTypeIds__c.getOrgDefaults();
        for(Account acc:accountBUList){ 
            if(acc.AccountNumber != null){
                if(acc.RecordtypeId == accRTId.Account_Customer_RecordType_18__c){
                    custIds += (accountBUList.size()==0?'':'%20')+acc.AccountNumber;
                }
                mapCustIdAccount.put(acc.AccountNumber,acc);   
            }
        }
        system.debug('CustId View all'+custIds);
        String customersId = '('+custIds+')';
        String res = API_NPS(customersId,viewall); 
        system.debug('NPS Res'+res);
        List<AccountNPSWrapper> AccountWrapList = new List<AccountNPSWrapper>();
        if(String.isNotBlank(res)){
            List<Object> resMap =(List<Object>)JSON.deserializeUntyped(res);
            String custNumber = '';
            for(Object obj : resMap){
                String str = JSON.serialize(obj);
                Map<String,Object> responseMap = (Map<String,Object>) JSON.deserializeUntyped(str);
                if(mapCustIdAccount.containskey(String.valueOf(responseMap.get('business_unit_id')))){
                    custNumber = String.valueOf(responseMap.get('business_unit_id'));
                }
                AccountNPSWrapper accWrapper = new AccountNPSWrapper(mapCustIdAccount.get(custNumber),String.valueOf(responseMap.get('business_unit_name')),Integer.valueOf(responseMap.get('nps_score')));
                AccountWrapList.add(accWrapper);
            }
        }
        return JSON.serialize(AccountWrapList);
    }
    
    public static String API_TAC(String custIds,boolean viewall){
        system.debug('custIds TACC'+custIds);
        system.debug(' viewall TAC'+viewall);
        Http h = new Http();
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        String orgId = UserInfo.getOrganizationId();
        C360TACCasesAPI__c sandboxTAC = C360TACCasesAPI__c.getValues('SandboxAPITAC');
        C360TACCasesAPI__c prodTAC = C360TACCasesAPI__c.getValues('ProductionAPITAC');
        String grant_type='';
        String client_id='';
        String client_secret='';
        String endPointURL='';
        string prodOrgId = prodTAC.Org_Id__c;
        HttpRequest req = new HttpRequest();
        if(orgId != prodOrgId){
            req.setEndpoint(sandboxTAC.BodyEndPointURL__c);
            req.setMethod('POST');    
            grant_type=sandboxTAC.Grant_Type__c;
            client_id=sandboxTAC.Client_Id__c;
            client_secret=sandboxTAC.Client_Secret__c;
            endPointURL = sandboxTAC.TACendPointURL__c;
        } else {
            req.setEndpoint(prodTAC.BodyEndPointURL__c);
            req.setMethod('POST');    
            grant_type=prodTAC.Grant_Type__c;
            client_id=prodTAC.Client_Id__c;
            client_secret=prodTAC.Client_Secret__c;
            endPointURL = prodTAC.TACendPointURL__c;
        }
        
        req.setBody('grant_type='+EncodingUtil.urlEncode(grant_type, 'UTF-8')
                    +'&client_id='+EncodingUtil.urlEncode(client_id, 'UTF-8')
                    +'&client_secret='+EncodingUtil.urlEncode(client_secret, 'UTF-8'));
        // Send the request, and return a response
        HttpResponse res = h.send(req);
        Map<String, Object> mapOfJSONData = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        string accessToken =(string) mapOfJSONData.get('access_token');
        system.debug('accessToken'+accessToken);
        HttpRequest req1 = new HttpRequest();
        if(viewall){
            endPointURL +='?customerId='+custIds+'&sortOrder=desc';
        }else{
            endPointURL +='?customerId='+custIds+'&sortOrder=desc&limit=3';
        }
        system.debug('endPointURL for TAC==='+endPointURL);
        req1.setEndpoint(endPointURL);
        req1.setMethod('GET');    
        String content_type='application/json';
        String Authorization='Bearer ' + accessToken;
        system.debug('Authorization == Access Token'+Authorization);
        req1.setHeader('Content-Type', content_type);
        req1.setHeader('Authorization', Authorization);
        req1.setTimeout(36000); 
        HttpResponse res1 = h.send(req1);
        res1 = h.send(req1);
        system.debug('response='+res1.getBody());
        string message =res1.getBody();
        return message;
    }
    
    public static String API_NPS(String custIds,boolean viewall){
        system.debug('custIds NPS'+custIds);
        system.debug(' viewall NPS'+viewall);
        Http h = new Http();
        
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        String orgId = UserInfo.getOrganizationId();
        C360TACCasesAPI__c sandboxNPS = C360TACCasesAPI__c.getValues('SandboxAPINPS');
        C360TACCasesAPI__c prodNPS = C360TACCasesAPI__c.getValues('ProductionAPINPS'); 
        String grant_type='';
        String client_id='';
        String client_secret='';
        String endPointURL='';
        string prodOrgId = prodNPS.Org_Id__c;
        HttpRequest req = new HttpRequest();
        if(orgId != prodOrgId){
            req.setEndpoint(sandboxNPS.BodyEndPointURL__c);
            req.setMethod('POST');    
            grant_type=sandboxNPS.Grant_Type__c;
            client_id=sandboxNPS.Client_Id__c;
            client_secret=sandboxNPS.Client_Secret__c;
            endPointURL=sandboxNPS.TACendPointURL__c;
        } else {
            req.setEndpoint(prodNPS.BodyEndPointURL__c);
            req.setMethod('POST');    
            grant_type=prodNPS.Grant_Type__c;
            client_id=prodNPS.Client_Id__c;
            client_secret=prodNPS.Client_Secret__c;
            endPointURL = prodNPS.TACendPointURL__c;
        }
        
        req.setBody('grant_type='+EncodingUtil.urlEncode(grant_type, 'UTF-8')
                    +'&client_id='+EncodingUtil.urlEncode(client_id, 'UTF-8')
                    +'&client_secret='+EncodingUtil.urlEncode(client_secret, 'UTF-8'));
        // Send the request, and return a response
        HttpResponse res = h.send(req);
        Map<String, Object> mapOfJSONData = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        string accessToken =(string) mapOfJSONData.get('access_token');
        
        HttpRequest req1 = new HttpRequest();
        if(viewall){
            endPointURL +='?customerId='+custIds+'&sortOrder=asc';
        }else{
            endPointURL +='?customerId='+custIds+'&sortOrder=asc&limit=3';
        }
        system.debug('endPointURL for NPS==='+endPointURL);
        req1.setEndpoint(endPointURL);
        req1.setMethod('GET');    
        String content_type='application/json';
        String Authorization='Bearer ' + accessToken;
        req1.setHeader('Content-Type', content_type);
        req1.setHeader('Authorization', Authorization);
        req1.setTimeout(72000);
        HttpResponse res1 = h.send(req1);
        res1 = h.send(req1);
        system.debug('response NPS=='+res1.getBody());
        string message =res1.getBody();
        return message;
    }
    public  class AccountTACWrapper{
        @AuraEnabled public Account account {get;set;}
        @AuraEnabled public String  customerName {get;set;}
        @AuraEnabled public Integer severity1 {get;set;}
        @AuraEnabled public Integer severity2 {get;set;}
        @AuraEnabled public Integer severity3 {get;set;}
        public AccountTACWrapper(Account acc,String custName,Integer sev1,Integer sev2,Integer sev3){
            this.account = acc;
            this.customerName = custName;
            this.severity1 = sev1;
            this.severity2 = sev2;
            this.severity3 = sev3;
        }
    }
    public  class AccountNPSWrapper{ 
        @AuraEnabled public Account account {get;set;}
        @AuraEnabled public String  customerName {get;set;}
        @AuraEnabled public Integer npsScore {get;set;}
        public AccountNPSWrapper(Account acc,String custName,Integer npsScore){
            this.account = acc;
            this.customerName = custName;
            this.npsScore = npsScore;
            
        }
    }
}