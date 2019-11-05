/************************************************************************************************************************************
Name    : C360_ServicesSoldController
Author  : C360 Dev team
Purpose : logic to request and get response from API for C360_ViewAllServiceSold data. 
		  This class has re-usable API callout methods(GET API) which can be called from other classes.
Date    : 28/06/2019
Change History : none
*************************************************************************************************************************************/
public class C360_ServicesSoldController {
    @AuraEnabled
    public static Integer servicesSoldCount {get;set;}
    public static List<String> serviceTypeList {get;set;}
    public static List<String> serviceGroupList {get;set;}
    
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
        system.debug('account record'+accountRec);
        Map<String,String> result = new Map<String,String>();
        result.put('account',JSON.serialize(accountRec));
        result.put('isCustomerRT',String.valueOf(isCustomerRT)); 
        return JSON.serialize(result);  
    }
   //Prepare the required parameter  to perform API callout for Services Sold initialLoad
    @AuraEnabled
    public static String initialLoadViewAll(String customerId,Boolean isCustomerRT,Integer startIndex,Integer endIndex){
        system.debug('===customer Id'+customerId);
        String result = doServicesSoldAPI(customerId,isCustomerRT,startIndex,endIndex,'data',null,null,null,null);
        Map<String,String> response = new Map<String,String>();
        response.put('data',result);
        response.put('total_count',String.valueOf(servicesSoldCount));
        response.put('serviceType',JSON.serialize(serviceTypeList));
        response.put('serviceGroup',JSON.serialize(serviceGroupList));
        return JSON.serialize(response);
    }
    //Prepare the parameters for sort and filter to perform API callout for Services Sold
    @AuraEnabled
    public static String servicesSoldActionsViewAll(String customerId,Boolean isCustomerRT,Integer startIndex,Integer endIndex,List<String> serviceType,List<String> serviceGroup,String sortOrder,String sortField){
        String sortFieldName=null;
        if(sortField!= null && sortField=='EndDate'){
            sortFieldName = 'CONTRACT_LINE_END_DATE';
        }else if(sortField!= null && sortField == 'ACV'){
            sortFieldName = 'TOTAL_CONTRACT_VALUE';
        }
        String result = doServicesSoldAPI(customerId,isCustomerRT,startIndex,endIndex,null,serviceType,serviceGroup,sortOrder,sortFieldName);
        Map<String,String> response = new Map<String,String>();
        system.debug('===result'+result);
        response.put('data',result);
        response.put('total_count',String.valueOf(servicesSoldCount));
        return JSON.serialize(response);
        
    }
    // GET API callout for Services Sold by passing paramaters
    public static String doServicesSoldAPI(String customerId,Boolean isCustomerRT,Integer startIndex,Integer endIndex,String filterLoad,List<String> serviceType,List<String> serviceGroup,String sortOrder,String sortField){
        Http h = new Http();
        C360_API_Settings__c setting = C360_Util.getConstant('ServiceSold');
        String grant_type='';
        String client_id='';
        String client_secret='';
        C360_ResponseWrapper r;
        String jsonResponse = null;
        String params = '';
        String EndPointURL = '';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(setting.Auth_EndPointURL__c);
        req.setMethod('POST');    
        grant_type=setting.Grant_Type__c;
        client_id=setting.Client_Id__c;
        client_secret=setting.Client_Secret__c;
        EndPointURL = setting.EndPointURL__c;
        system.debug('===setting'+setting);
        system.debug('===grant_type='+grant_type +'&client_id='+client_id +'==client_secret'+client_secret);
        req.setBody('grant_type='+EncodingUtil.urlEncode(grant_type, 'UTF-8')
                    +'&client_id='+EncodingUtil.urlEncode(client_id, 'UTF-8')
                    +'&client_secret='+EncodingUtil.urlEncode(client_secret, 'UTF-8'));
        HttpResponse resp = h.send(req);
        Map<String, Object> mapOfJSONData = (Map<String, Object>) JSON.deserializeUntyped(resp.getBody());
        string accessToken =(string) mapOfJSONData.get('access_token');
        String AuthorizationToken='Bearer ' + accessToken;
        if(isCustomerRT){
            params ='?customerId='+customerId+'&sortorder=desc&startIndex='+startIndex+'&endIndex='+endIndex; 
        }
        else{		
            params = '?businessUnitId='+customerId+'&sortorder=desc&startIndex='+startIndex+'&endIndex='+endIndex;		
        }        
        if(filterLoad!=null){
            params+='&filterLoad='+filterLoad;
        }
        if(serviceType != null && serviceType.size()>0){
            String encodedserviceType = C360_Util.encodeString(C360_Util.convertListToString(serviceType));
            params+='&serviceType='+encodedserviceType;
        }
        if(serviceGroup != null && serviceGroup.size()>0){
            String encodedserviceGroup = C360_Util.encodeString(C360_Util.convertListToString(serviceGroup));
            params+='&serviceGroup='+encodedserviceGroup;
        }
        if(sortOrder != null){
            params+='&sortOrder='+sortOrder;
        }
        if(sortField != null){
            params+='&sortField='+sortField;
        }
        system.debug('====oc '+setting +'=='+setting.EndPointURL__c+params);
        List<String> pickListValues = new List<String>();
        r = C360_Callout.doGET('ServiceSold',setting.EndPointURL__c+params,AuthorizationToken,'application/json',setting.Timeout__c, new Map<String,String>());
        if(r != null && r.response != null && r.response.getStatusCode() == 200){
            system.debug('==response'+r.response.getBody());
            String resBody = r.response.getBody();
            jsonResponse = parseResponseToServicesSoldWrapper(resBody,filterLoad);
        }
        else{
            jsonResponse = 'Unable to connect to API.Please try again after sometime'; 
        }
        return jsonResponse;
    }
    //Parse the response for CustomerInventory API to capture the data,picklist values and total count.
    public static String parseResponseToServicesSoldWrapper(String res,String filterLoad){
        List<ServicesSoldWrapper> AccountWrapList = new List<ServicesSoldWrapper>();
        String jsonRes = '';
        if(String.isNotBlank(res) && !res.containsIgnoreCase('No data found')){
            Map<String,Object> resMap =(Map<String,Object>)JSON.deserializeUntyped(res);
            system.debug('== map data'+resMap.get('Products'));
            servicesSoldCount = Integer.valueOf(resMap.get('total_count'));
            List<Object> resList =(List<Object>)resMap.get('Products');
            
            string serviceType,serviceGroup,ACV,ENDDATE='';
            date EnDate;
            
            for(Object obj : resList){
                String str = JSON.serialize(obj);
                Map<String,Object> responseMap = (Map<String,Object>) JSON.deserializeUntyped(str);
                serviceType = String.valueOf(responseMap.get('SERVICE_TYPE'));
                serviceGroup =String.valueOf(responseMap.get('SERVICE_GROUP'));
                ACV = String.valueOf(responseMap.get('TOTAL_CONTRACT_VALUE'));                    
                ENDDATE = String.valueOf(responseMap.get('CONTRACT_LINE_END_DATE'));
                if(ENDDATE!= null && ENDDATE!=''){
                    EnDate = date.valueOf(ENDDATE);
                }
                ServicesSoldWrapper accWrapper = new ServicesSoldWrapper(serviceType,serviceGroup,ACV,EnDate);
                AccountWrapList.add(accWrapper);
                jsonRes = JSON.serialize(AccountWrapList);
            }
            if(filterLoad!=null){
                if(resMap.get('ServiceType')!= null && resMap.get('ServiceType')!=''){
                    List<Object> resPickList =(List<Object>)resMap.get('ServiceType');
                    serviceTypeList = new List<String>(); 
                    serviceTypeList = parsePicklistValues(resPickList,'SERVICE_TYPE');
                }
                if(resMap.get('ServiceGroup')!= null && resMap.get('ServiceGroup')!=''){
                    List<Object> resPickList =(List<Object>)resMap.get('ServiceGroup');
                    serviceGroupList = new List<String>();
                    serviceGroupList = parsePicklistValues(resPickList,'SERVICE_GROUP');
                }
                
            }
        }
        else if(res.containsIgnoreCase('No data found')){
            system.debug('=== res no data found'+res);
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
    
    public  class ServicesSoldWrapper{
        @AuraEnabled public String  serviceType {get;set;}
        @AuraEnabled public String  serviceGroup {get;set;}
        @AuraEnabled public String ACV {get;set;}
        @AuraEnabled public Date  EndDate {get;set;}
        public ServicesSoldWrapper(string serviceType,string serviceGroup,string ACV,date EndDate){
            this.serviceType = serviceType;
            this.serviceGroup = serviceGroup;
            this.ACV = ACV;
            this.EndDate = EndDate;
        }
    }
    
    
}