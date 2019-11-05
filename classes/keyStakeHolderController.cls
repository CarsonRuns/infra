public class keyStakeHolderController {
    
    @AuraEnabled
    public static Map<String,sObject> getRecord(String recId) {
        Map<String,sObject> outParams = new Map<String,sObject>();
        String keyPrefix = Account.sobjecttype.getDescribe().getKeyPrefix();
        if(recId.startsWith(keyPrefix)){
            Account acc = [Select Id,ParentId,RecordTypeId from Account where Id=:recId limit 1];
            ObjectRecordTypeIds__c accRTId = ObjectRecordTypeIds__c.getOrgDefaults();
            if(accRTId.Account_Customer_RecordTypeId__c == acc.RecordTypeId){
                outParams.put('Customer',acc);
            }else{
                outParams.put('BU',acc);
            }
        }
        else{
            Success_Plan__c successPlan = [Select Id,Customer_Name__c,Customer_BU_Name__c from Success_Plan__c where Id=: recId limit 1];
            outParams.put('SuccessPlan',successPlan);
        }
        return outParams;
    }
    
    @AuraEnabled
    public static Boolean isCurrentUserSPM(String recId) {
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        Map<String,sObject> recInfo = getRecord(recId);
        if(profileName == 'Cisco_SPM'){
            if(recInfo.get('Customer') != null || recInfo.get('BU') != null){
                return true;                
            }else if (recInfo.get('SuccessPlan') != null){
                return false;
            }else{
                return false;
            }
        }else{
            return false;
        }
    }
   
    @AuraEnabled
    public static Contact getContactRecord(String contactId) {
        return [select id,Name,Phone,Email,Title,JobFunction__c from Contact where Id=:contactId limit 1 ];
    }
    @AuraEnabled
    public static Id insertKeyStakeHolder(Key_StakeHolders__c keyStakeHolder){
        try{
            insert keyStakeHolder;
            
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
        return keyStakeHolder.id;
        
    }
}