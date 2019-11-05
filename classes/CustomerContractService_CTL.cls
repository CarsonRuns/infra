/**************************************
Author          : Awnish Kumar 
Release         : Mar Release version 1
Created         : Feb 15,2019
Functionality   : Customer Contract Service Multipicklist and dependent Picklist

**********************************************/

public class CustomerContractService_CTL {
    // Method for Saving Service line items on CRMDB  
    @AuraEnabled
    public static void saveServiceLineItem(String customerContractID, String service, List<String> serviceSubCategories){
        List<Customer_Contract_Services__c> customerContractServices = [select id,Name,Service_Sub_Category__c from Customer_Contract_Services__c where Customer_Contract__c =: customerContractID and name=:service];
        if(!customerContractServices.isEmpty()){
            customerContractServices[0].Service_Sub_Category__c = string.join(serviceSubCategories,',');
            update customerContractServices[0];
        }else{
            Customer_Contract_Services__c customerContractService = new Customer_Contract_Services__c();
            customerContractService.Name = service;
            customerContractService.Service_Sub_Category__c = string.join(serviceSubCategories,',');
            customerContractService.Customer_Contract__c = customerContractID;
            insert customerContractService;
        }
        
    }
    
    // Method for Deleting Service line items on CRMDB      
    @AuraEnabled
    public static void deleteServiceLineItem(String customerContractServiceID){
        List<Customer_Contract_Services__c> customerContractServices = [select id from Customer_Contract_Services__c where id =: customerContractServiceID];
        delete customerContractServices;
    }
    
    // Method for Fetching Service line items on CRMDB     
    @AuraEnabled
    public static List<Customer_Contract_Services__c> getServiceLineItem(String customerContractID){
        return [select id,Name,Service_Sub_Category__c from Customer_Contract_Services__c where Customer_Contract__c =: customerContractID order by lastmodifieddate desc];
    }
    
    // Method for fetching Parent Child Service line items on CRMDB  
    @AuraEnabled
    public static Map<String,List<String>> getParentChildServices(){
        Customer_Contract_Services__c contractSrvice = new Customer_Contract_Services__c();
        Map<String,List<String>> services  = DependentPicklist_CTL.getDependentMap(contractSrvice,'Service_Name__c','Service_Sub_Category_Name__c');       
        return services;
    }
    
    // Method for Checking User Add Permissions on CRMDB      
    @AuraEnabled
    public static Boolean checkUserAddPermission(){
        
        // US278229--CRMDB--hsinghi--03/17/19
        
        Boolean hasEditAccess=false;
        Set<ID> permissionId=new Set<ID>();  
        
        List<PermissionSetAssignment> permissionsList = [SELECT PermissionSet.Name, PermissionSet.ID FROM PermissionSetAssignment 
                                                         where AssigneeId =:UserInfo.getUserId()]; 
        
        for(PermissionSetAssignment permissions :permissionsList ){
            permissionId.add(permissions.PermissionSet.ID);
        }
        
        String allowedIdList = Utilities.getConstant_CS('CRMDB_SDM_ADMIN');        
        List<String> allowedId= allowedIdList.split(',');
        
        for(String id : allowedId){
            if(permissionId.contains(id)){
                hasEditAccess = True;                
            }
        }      
        
        return hasEditAccess;
        
        
    }  
}