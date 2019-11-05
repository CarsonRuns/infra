/************************************************************************************************************************************
Name    : C360_CustomerInventoryController
Author  : C360 Dev team
Purpose : This class has re-usable API callout methods(GET API) which can be called from other classes.
Date    : 28/06/2019
Change History : none 
*************************************************************************************************************************************/

public class C360_CustomerInventoryController {
    
    @AuraEnabled
    public static Integer custInvTotalCount {get;set;}
    public static List<String> businessEntityList {get;set;}
    public static List<String> prodClassList {get;set;}
    public static List<String> prodFamilyList {get;set;}
    
    //Fetch account record based on recordId and to get the recordType of account
    @AuraEnabled
    public static String fetchAccount(Id accountId){
        Boolean isCustomerRT = false;
        Account accountRec = new Account();
        accountRec = [select id,AccountNumber,RecordtypeId from Account where Id=:accountId limit 1];
        ObjectRecordTypeIds__c accRTId = ObjectRecordTypeIds__c.getOrgDefaults();
        if(accountRec.RecordTypeId == accRTId.Account_Customer_RecordTypeId__c){
            isCustomerRT = true;
        }
        Map<String,String> result = new Map<String,String>();
        result.put('account',JSON.serialize(accountRec));
        result.put('isCustomerRT',String.valueOf(isCustomerRT)); 
        return JSON.serialize(result);  
    }
    
    //Prepare the required parameter  to perform API callout for Customer Inventory initialLoad
    @AuraEnabled
    public static String initialLoadViewAll(String customerId,Boolean isCustomerRT,Integer startIndex,Integer endIndex){
        String result = doCustomerInventoryAPI(customerId,isCustomerRT,startIndex,endIndex,'data',null,null,null,null,null);
        Map<String,String> response = new Map<String,String>();
        response.put('data',result);
        response.put('total_count',String.valueOf(custInvTotalCount));
        response.put('businessEntity',JSON.serialize(businessEntityList));
        response.put('prodClass',JSON.serialize(prodClassList));
        response.put('prodFamily',JSON.serialize(prodFamilyList));
        return JSON.serialize(response);
    }
    
    //Prepare the parameters for sort and filter to perform API callout for Customer Inventory
    @AuraEnabled
    public static String customerInventoryActionsViewAll(String customerId,Boolean isCustomerRT,Integer startIndex,Integer endIndex,List<String> prodFamilyList,List<String> busEntityList,List<String> prodClassList,string sortOrder,string sortField){
        
        String sortFieldName=null;
        if(sortField!= null && sortField=='installLoc'){
            sortFieldName = 'INSTALL_LOCATION';
        }else if(sortField!= null && sortField == 'instDate'){
            sortFieldName = 'INSTALLATION_DATE';
        }else if(sortField!= null && sortField == 'soNo'){
            sortFieldName = 'PRODUCT_SALES_ORDER_NUMBER';
        }
        String result = doCustomerInventoryAPI(customerId,isCustomerRT,startIndex,endIndex,null,prodFamilyList,busEntityList,prodClassList,sortOrder,sortFieldName);
        Map<String,String> response = new Map<String,String>();
        response.put('data',result);
        response.put('total_count',String.valueOf(custInvTotalCount));
        return JSON.serialize(response);
    }
    
    // GET API callout for customer Inventory by passing paramaters
    public static String doCustomerInventoryAPI(String customerId,Boolean isCustomerRT,Integer startIndex,Integer endIndex,String filterLoad,List<String> prodFamilyList,List<String> busEntityList,List<String> prodClassList,string sortOrder, string sortField){
        Http h = new Http();
        C360_API_Settings__c setting = C360_Util.getConstant('CustomerInventory');
        String grant_type='';
        String client_id='';
        String client_secret='';
        C360_ResponseWrapper r = null;
        String jsonResponse = null;
        String params ='';
        String EndPointURL = '';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(setting.Auth_EndPointURL__c);
        req.setMethod('POST');    
        grant_type=setting.Grant_Type__c;
        client_id=setting.Client_Id__c;
        client_secret=setting.Client_Secret__c;
        EndPointURL = setting.EndPointURL__c;
        req.setBody('grant_type='+EncodingUtil.urlEncode(grant_type, 'UTF-8')
                    +'&client_id='+EncodingUtil.urlEncode(client_id, 'UTF-8')
                    +'&client_secret='+EncodingUtil.urlEncode(client_secret, 'UTF-8'));
        HttpResponse resp = h.send(req);
        Map<String, Object> mapOfJSONData = (Map<String, Object>) JSON.deserializeUntyped(resp.getBody());
        string accessToken =(string) mapOfJSONData.get('access_token');
        String AuthorizationToken='Bearer ' + accessToken;
        if(isCustomerRT){
            params ='?customerId='+customerId+'&startIndex='+startIndex+'&endIndex='+endIndex;           
        }
        else{
            params = '?businessUnitId='+customerId+'&startIndex='+startIndex+'&endIndex='+endIndex;
        }
        if(filterLoad!=null){
            params+='&filterLoad='+filterLoad;
        }       
        if(prodFamilyList != null && prodFamilyList.size()>0){
            String encodedproductFamily = C360_Util.encodeString(C360_Util.convertListToString(prodFamilyList));
            params+='&productFamily='+encodedproductFamily;
        }
        if(busEntityList != null && busEntityList.size()>0){
            String encodedbusinessEntity = C360_Util.encodeString(C360_Util.convertListToString(busEntityList));
            params+='&businessEntity='+encodedbusinessEntity;
        }
        if(prodClassList != null && prodClassList.size() > 0){
            String encodedprodClass = C360_Util.encodeString(C360_Util.convertListToString(prodClassList));
            params+='&productClassification='+encodedprodClass;
        }
        
        if(sortOrder != null){
            params+='&sortOrder='+sortOrder;
        }
        if(sortField != null){
            params+='&sortField='+sortField;
        }
                
        List<String> pickListValues = new List<String>();
        r = C360_Callout.doGET('CustomerInventoryService',setting.EndPointURL__c+params,AuthorizationToken,'application/json',setting.Timeout__c, new Map<String,String>());
        if(r != null && r.response != null && r.response.getStatusCode() == 200){
            String resBody = r.response.getBody();
            jsonResponse = parseResponseToInventoryWrapper(resBody,filterLoad);
        }
        else{
            jsonResponse = 'Unable to connect to API.Please try again after sometime';
        }
        return jsonResponse;
    }
    //Parse the response for CustomerInventory API to capture the data,picklist values and total count.
    public static String parseResponseToInventoryWrapper(String res,String filterLoad){
        List<CustomerInventoryWrapper> AccountWrapList = new List<CustomerInventoryWrapper>();
        String jsonRes = '';
        if(String.isNotBlank(res) && !res.containsIgnoreCase('No data found')){
            Map<String,Object> resMap =(Map<String,Object>)JSON.deserializeUntyped(res);
            custInvTotalCount = Integer.valueOf(resMap.get('total_count'));
            List<Object> resList =(List<Object>)resMap.get('Products');
            string custNumber,productFamily,businessEntity,inventoryType,installLoc,installDate,subBE,soNo='';
            integer quantity;
            date instDate;
            for(Object obj : resList){
                String str = JSON.serialize(obj);
                Map<String,Object> responseMap = (Map<String,Object>) JSON.deserializeUntyped(str);
                productFamily = String.valueOf(responseMap.get('PRODUCT_FAMILY'));
                quantity =Integer.valueOf(responseMap.get('INVENTORY_QUANTITY'));
                businessEntity = String.valueOf(responseMap.get('BUSINESS_ENTITY'));
                inventoryType = String.valueOf(responseMap.get('PRODUCT_CLASSIFICATION'));
                installLoc = String.valueOf(responseMap.get('INSTALL_LOCATION'));
                installDate = String.valueOf(responseMap.get('INSTALLATION_DATE'));
                subBE = String.valueOf(responseMap.get('BUSINESS_SUB_ENTITY'));
                soNo = String.valueOf(responseMap.get('PRODUCT_SALES_ORDER_NUMBER'));
                if(installDate!= null && installDate!=''){
                    instDate = date.valueOf(installDate);
                }
                CustomerInventoryWrapper accWrapper = new CustomerInventoryWrapper(productFamily,businessEntity,quantity,inventoryType,installLoc,instDate,subBE,soNo);
                AccountWrapList.add(accWrapper);
                jsonRes = JSON.serialize(AccountWrapList);
            }
            if(filterLoad!=null){
                if(resMap.get('BusinessEntity')!= null && resMap.get('BusinessEntity')!=''){
                    List<Object> resPickList =(List<Object>)resMap.get('BusinessEntity');
                    businessEntityList = new List<String>();
                    businessEntityList = parsePicklistValues(resPickList,'BUSINESS_ENTITY');
                }
                if(resMap.get('ProductClassification')!= null && resMap.get('ProductClassification')!=''){
                    List<Object> resPickList =(List<Object>)resMap.get('ProductClassification');
                    prodClassList = new List<String>(); 
                    prodClassList = parsePicklistValues(resPickList,'PRODUCT_CLASSIFICATION');
                }
                if(resMap.get('ProductFamily')!= null && resMap.get('ProductFamily')!=''){
                    List<Object> resPickList =(List<Object>)resMap.get('ProductFamily');
                    prodFamilyList = new List<String>();
                    prodFamilyList = parsePicklistValues(resPickList,'PRODUCT_FAMILY');
                    
                }
            }
        }
        else if(res.containsIgnoreCase('No data found')){
            jsonRes = 'No data found';
        }
        return jsonRes;
    }
    //Parse the picklist values from response to List of Strings
    public static List<String> parsePicklistValues(List<Object> resList,String key){
        List<String> pickListValues = new List<String>();
        
        for(Object obj: resList){
            Map<String,Object> mapResObj = (Map<String,Object>)obj;
            pickListValues.add(String.valueOf(mapResObj.get(key)));
        }
        return pickListValues;
    }
    
    
    public class CustomerInventoryWrapper{
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
    
    
    
}