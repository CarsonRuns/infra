public without sharing class RenewalsUtilities {
    
/*
@ Created /Modified : Apr 12,2019
* @description : Method to get Customer Details in side component of Renewal Opportunity
* @param : List  accIds
* @return : Map<String,String>
*/ 
    public static Map<String,String> getCustomerAccountMapping(List<Id> accIds){
        
        ObjectRecordTypeIds__c objRecordTypeSettingBu = ObjectRecordTypeIds__c.getOrgDefaults();
		String customerRecordId = objRecordTypeSettingBu.Account_Customer_RecordType_18__c;
        
        Map<String,String> customerAccountMap = new Map<String,String>();
        system.debug('List of accIds'+accIds);
        List<Account> accounts = [select Id,Parent.Parent.Name,Parent.Parent.RecordtypeId from Account where Id in :accIds];
        for(Account acc: accounts){
            String accId = acc.Id;
            String customerName = acc.Parent.Parent.Name;
            String recordTypeId = acc.Parent.Parent.RecordtypeId;
            
            if(!customerAccountMap.containsKey(accId) && customerRecordId == recordTypeId){
                customerAccountMap.put(accId,customerName);
            }
        }
        return customerAccountMap;
    }
/*
@ Created /Modified : Apr 12,2019
* @description : Method to get Account Label names for Customer and BU Side component
* @param : "" 
* @return : Map<String,String>
*/   
    public static Map<String,String> getAccountLabelNames(){
        String type='Account';
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(type);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        Map<String, String> labelMap = new Map<String,String>();
        for (String fieldName: fieldMap.keySet()) {
            string label = fieldMap.get(fieldName).getDescribe().getLabel();
            labelMap.put(fieldName,label);
        }
        return labelMap;
    }


}