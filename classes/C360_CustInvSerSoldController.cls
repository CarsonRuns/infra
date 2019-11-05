/************************************************************************************************************************************
Name    : C360_CustInvSerSoldController
Author  : C360 Dev team
Purpose : Class used for API callout of Customer Inventory/Services Sold in Puchase Tab of Customer and BU
Date    : 28/06/2019
Change History : 
*************************************************************************************************************************************/
public class C360_CustInvSerSoldController {
    
    @AuraEnabled public static Integer customerCount {get;set;}
    @AuraEnabled public static Integer servicesCount {get;set;}
    
    //Controller invocation from JS for Customer Inventory
    @AuraEnabled
    public static String doCustomerInvAPI(Id customerId){
        String accountNum ='';
        Map<String,String> result = new Map<String,String>();
        Account accountRec = [SELECT AccountNumber FROM Account WHERE id =: customerId limit 1];
        if(accountRec != null && accountRec.AccountNumber != null){
            accountNum = accountRec.AccountNumber;
        }
        
        Boolean isCustomerRT = false;
        Id accountRecordtypeId = [SELECT Id, RecordtypeId FROM Account where Id = :customerId].RecordtypeId;
        ObjectRecordTypeIds__c accRTId = ObjectRecordTypeIds__c.getOrgDefaults();
        if(accountRecordtypeId == accRTId.Account_Customer_RecordTypeId__c){
            isCustomerRT = true;
        }
        
        String res = API_Inventory(accountNum,isCustomerRT);
        result.put('data',res);
        result.put('count',String.valueOf(customerCount));
        return JSON.serialize(result);  
    }
    //Method for InventoryAPI callout from Customer Inventory
    public static String API_Inventory(String accountNumber,Boolean isCustomerRT){       
        Http h = new Http();
        
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        String orgId = UserInfo.getOrganizationId();
        C360_API_Settings__c sandboxINV = C360_API_Settings__c.getValues('NonProductionCustomerInventory');
 
        String grant_type='';
        String client_id='';
        String client_secret='';
        String endPointURL='';
        String jsonResponse = '';

        HttpRequest req = new HttpRequest();
            req.setEndpoint(sandboxINV.Auth_EndPointURL__c);
            req.setMethod('POST');    
            grant_type=sandboxINV.Grant_Type__c;
            client_id=sandboxINV.Client_Id__c;
            client_secret=sandboxINV.Client_Secret__c;
            endPointURL = sandboxINV.EndPointURL__c;
        req.setBody('grant_type='+EncodingUtil.urlEncode(grant_type, 'UTF-8')
                    +'&client_id='+EncodingUtil.urlEncode(client_id, 'UTF-8')
                    +'&client_secret='+EncodingUtil.urlEncode(client_secret, 'UTF-8'));
        
        // Send the request, and return a response
        HttpResponse res = h.send(req);
        Map<String, Object> mapOfJSONData = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        string accessToken =(string) mapOfJSONData.get('access_token');
        system.debug('accessToken'+accessToken);
        HttpRequest req1 = new HttpRequest();
        if(isCustomerRT == true){
            EndPointURL = sandboxINV.EndPointURL__c+'?customerId='+accountNumber+'&limit=3';           
        }        
        else{
            EndPointURL = sandboxINV.EndPointURL__c+'?businessUnitId='+accountNumber+'&limit=3';  
        }
        system.debug('endPointURL for INV==='+endPointURL);
        req1.setEndpoint(endPointURL);
        req1.setMethod('GET');    
        String content_type='application/json';
        String Authorization='Bearer ' + accessToken;
        system.debug('Authorization == Access Token'+Authorization);
        req1.setHeader('Content-Type', content_type);
        req1.setHeader('Authorization', Authorization);
        req1.setTimeout(10000); 
        HttpResponse res1 = h.send(req1);
        res1 = h.send(req1);
        system.debug('response='+res1.getBody());
        string message =res1.getBody();
        
        jsonResponse = parseResponseToInventoryWrapper(message);
        system.debug('JSON response='+jsonResponse);
        return jsonResponse;
        
    }
    
    //Deserialize method for Customer inventory
    public static String parseResponseToInventoryWrapper(String res){
        
        List<CustomerInventoryWrapper> CustomerInvWrapList = new List<CustomerInventoryWrapper>();
        String data = '';
        if(String.isNotBlank(res)){
            Map<String,Object> resMap =(Map<String,Object>)JSON.deserializeUntyped(res);
            system.debug('== map data'+resMap.get('Products'));
            List<Object> resList =(List<Object>)resMap.get('Products');
            customerCount = Integer.valueOf(resMap.get('total_count'));
            string custNumber,productFamily,businessEntity,inventoryType,installLoc,installDate,subBE,soNo='';
            integer quantity;
            date instDate;
            for(Object obj : resList){
                String str = JSON.serialize(obj);
                Map<String,Object> responseMap = (Map<String,Object>)JSON.deserializeUntyped(str);
                productFamily = String.valueOf(responseMap.get('PRODUCT_FAMILY'));
                quantity =Integer.valueOf(responseMap.get('INVENTORY_QUANTITY'));
                businessEntity = String.valueOf(responseMap.get('BUSINESS_ENTITY'));
                inventoryType = String.valueOf(responseMap.get('PRODUCT_CLASSIFICATION'));
                installLoc = String.valueOf(responseMap.get('INSTALL_LOCATION'));
                installDate = String.valueOf(responseMap.get('INSTALLATION_DATE'));
                subBE = String.valueOf(responseMap.get('BUSINESS_SUB_ENTITY'));
                soNo = String.valueOf(responseMap.get('PRODUCT_SALES_ORDER_NUMBER'));
                if(installDate != null){
                    instDate = date.valueOf(installDate);
                }
                CustomerInventoryWrapper accWrapper = new CustomerInventoryWrapper(productFamily,businessEntity,quantity,inventoryType,installLoc,instDate,subBE,soNo);
                CustomerInvWrapList.add(accWrapper);
                data = JSON.serialize(CustomerInvWrapList);
            }
        }
        else if(res.containsIgnoreCase('No Data Found')){
            data = res;
        }
        system.debug('Res----->'+res);
        return data;
    }
    
    //Returns Data to Customer Inventory Component
    public  class CustomerInventoryWrapper{
        @AuraEnabled public String  productFamily {get;set;}
        @AuraEnabled public String  businessEntity {get;set;}
        @AuraEnabled public Integer quantity {get;set;}
        @AuraEnabled public String  inventoryType {get;set;}
        @AuraEnabled public String  installLoc {get;set;}
        @AuraEnabled public Date  instDate {get;set;}
        @AuraEnabled public String  subBE {get;set;}
        @AuraEnabled public String soNo {get;set;}
        
        public CustomerInventoryWrapper(string productFamily,string businessEntity,Integer quantity,string inventoryType,string installLoc,date instDate,string subBE,String soNo){
            this.productFamily = productFamily;
            this.businessEntity = businessEntity;
            this.quantity = quantity;
            this.inventoryType = inventoryType;
            this.installLoc = installLoc;
            this.instDate = instDate;
            this.subBE = subBE;
            this.soNo = soNo;
        }
    }
    
    //Controller invocation from JS for Services Sold
    @AuraEnabled
    public static String doServicesAPI(Id customerId){
        String accountNum ='';
        Map<String,String> result = new Map<String,String>();
        Account acc = [SELECT accountNumber FROM Account WHERE id =: customerId limit 1 ];
        if(acc != null && acc.AccountNumber != null){
            accountNum = acc.AccountNumber;     
        }
        
        Boolean isCustomerRT = false;
        Id accountRecordtypeId = [SELECT Id, RecordtypeId FROM Account where Id = :customerId].RecordtypeId;
        ObjectRecordTypeIds__c accRTId = ObjectRecordTypeIds__c.getOrgDefaults();
        if(accountRecordtypeId == accRTId.Account_Customer_RecordTypeId__c){
            isCustomerRT = true;
        }
        
        String res = API_Services(accountNum,isCustomerRT);
 
        result.put('data',res);
        result.put('count',String.valueOf(servicesCount));
        return JSON.serialize(result);  
    }
    //Method for ServicesAPI callout for Services Sold
    public static String API_Services(String accountNumber,Boolean isCustomerRT){
        Http h = new Http();
        
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        String orgId = UserInfo.getOrganizationId();
        C360_API_Settings__c sandboxSERV = C360_API_Settings__c.getValues('NonProductionServiceSold');

        String grant_type='';
        String client_id='';
        String client_secret='';
        String endPointURL='';
        String jsonResponse = '';

        HttpRequest req = new HttpRequest();
            req.setEndpoint(sandboxSERV.Auth_EndPointURL__c);
            req.setMethod('POST');    
            grant_type=sandboxSERV.Grant_Type__c;
            client_id=sandboxSERV.Client_Id__c;
            client_secret=sandboxSERV.Client_Secret__c;
            endPointURL = sandboxSERV.EndPointURL__c;
        req.setBody('grant_type='+EncodingUtil.urlEncode(grant_type, 'UTF-8')
                    +'&client_id='+EncodingUtil.urlEncode(client_id, 'UTF-8')
                    +'&client_secret='+EncodingUtil.urlEncode(client_secret, 'UTF-8'));
        
        // Send the request, and return a response
        HttpResponse res = h.send(req);
        Map<String, Object> mapOfJSONData = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        string accessToken =(string) mapOfJSONData.get('access_token');
        system.debug('accessToken'+accessToken);
        HttpRequest req1 = new HttpRequest();
        if(isCustomerRT == true){
            EndPointURL = sandboxSERV.EndPointURL__c+'?customerId='+accountNumber+'&limit=3';           
        }        
        else{
            EndPointURL = sandboxSERV.EndPointURL__c+'?businessUnitId='+accountNumber+'&limit=3';  
        }
        system.debug('endPointURL for ServicesSold==='+endPointURL);
        req1.setEndpoint(endPointURL);
        req1.setMethod('GET');    
        String content_type='application/json';
        String Authorization='Bearer ' + accessToken;
        system.debug('Authorization == Access Token'+Authorization);
        req1.setHeader('Content-Type', content_type);
        req1.setHeader('Authorization', Authorization);
        req1.setTimeout(10000); 
        HttpResponse res1 = h.send(req1);
        res1 = h.send(req1);
        system.debug('response='+res1.getBody());
        string message =res1.getBody();
        
        jsonResponse = parseResponseToServiceWrapper(message);
        system.debug('JSON response='+jsonResponse);
        return jsonResponse;
    }
    
    //Deserialize method for Services Sold
    public static String parseResponseToServiceWrapper(String res){
        List<ServiceSoldWrapper> ServiceSoldWrapList = new List<ServiceSoldWrapper>();
        String jsonRes = '';
        if(String.isNotBlank(res) && !res.containsIgnoreCase('No Data Found')){
            Map<String,Object> resMap =(Map<String,Object>)JSON.deserializeUntyped(res);
            List<Object> resList =(List<Object>)resMap.get('Products');
            servicesCount = Integer.valueOf(resMap.get('total_count'));
            string custNumber,serviceType,serviceGroup,ACV,endDate='';
            Date completeDate;
            
            
            for(Object obj : resList){
                String str = JSON.serialize(obj);
                Map<String,Object> responseMap = (Map<String,Object>)JSON.deserializeUntyped(str);
                
                serviceType = String.valueOf(responseMap.get('SERVICE_TYPE'));
                serviceGroup = String.valueOf(responseMap.get('SERVICE_GROUP'));
                ACV = String.valueOf(responseMap.get('TOTAL_CONTRACT_VALUE'));               
                endDate = String.valueOf(responseMap.get('CONTRACT_LINE_END_DATE'));
                
                completeDate = date.valueOf(endDate);
                
                ServiceSoldWrapper accWrapper = new ServiceSoldWrapper(serviceType,serviceGroup,ACV,completeDate);
                ServiceSoldWrapList.add(accWrapper);
                jsonRes = JSON.serialize(ServiceSoldWrapList);
            }
        }
        else if(res.containsIgnoreCase('No Data Found')){
            jsonRes = res;
        }
        return jsonRes;
    }
    //Returns Data to Services Sold Component
    public  class ServiceSoldWrapper{
        @AuraEnabled public String  serviceType {get;set;}
        @AuraEnabled public String  serviceGroup {get;set;}
        @AuraEnabled public String  ACV {get;set;}
        @AuraEnabled public Date  beginDate {get;set;}
        @AuraEnabled public Date  completeDate {get;set;}
        @AuraEnabled public String  endDate {get;set;}
        
        
        public ServiceSoldWrapper(string serviceType,string serviceGroup,string ACV,date completeDate){
            this.serviceType = serviceType;
            this.serviceGroup = serviceGroup;
            this.ACV = ACV;
            this.completeDate = completeDate;
        }
    }
}