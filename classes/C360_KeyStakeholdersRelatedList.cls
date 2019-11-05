/************************************************************************************************************************************
Name    : C360_KeyStakeholdersRelatedList
Author  : C360 Dev team
Purpose : Contains logic to execute on fetching and returing Unique Contacts related to Key Stakeholders in the C360_KeyStakeholder and C360_KeyStakeholderViewall components
Date    : 4/04/2019
Change History : none
*************************************************************************************************************************************/

public class C360_KeyStakeholdersRelatedList {
    //Check HasRecordId is Customer/BU
    public static Boolean isCustomerFlag(String recordId){
        Boolean isCustomerRT = false;
        String keyPrefix = Account.sobjecttype.getDescribe().getKeyPrefix();
        if(recordId.startsWith(keyPrefix)){
            Id accountRecordtypeId = [SELECT Id, RecordtypeId FROM Account where Id =:recordId].RecordtypeId;
            ObjectRecordTypeIds__c accRTId = ObjectRecordTypeIds__c.getOrgDefaults();
            if(accountRecordtypeId == accRTId.Account_Customer_RecordTypeId__c){
                isCustomerRT = true;
            }
        }
        return isCustomerRT;
    }
    
    //Fetch Unique contacts associated with Keystakeholders related to Customer/BU
    @AuraEnabled 
    public static List<Contact> fetchKeyStakeHolders(String recordId){
        Boolean isCustomer = isCustomerFlag(recordId);
        List<AggregateResult > lstCM = new List<AggregateResult>();
        List<Id> setContactID = new List<Id>();
        lstCM =Database.query('select Contact__c, contact__r.Name, COUNT(Id)'
                              +' from Key_Stakeholders__c'
                              +' where '+ 
                              +( (isCustomer) ? ' Customer_Account__c =: recordId' :' Business_Unit_Account__c =: recordId' )
                              + ' group by Contact__c, contact__r.Name order by COUNT(Id) DESC, contact__r.Name ASC LIMIT 5');
        system.debug('Keystakeholdercontacts'+lstCM);
        if(lstCM.size()>0){
            for (AggregateResult ar : lstCM)  {
                setContactID.add((Id)ar.get('Contact__c')); 
            }
        }
        
        Map<Id,contact> contactlist = new Map<Id,contact>([select id,Name,Title,Email,Phone from Contact Where Id IN :setContactID limit 10]);
        List<contact> finalcontactList = new List<contact>();
        
        for(Integer i = 0; i<setContactID.size();i++){
            finalcontactList.add(contactlist.get(setContactID[i]));
        }
        
        return finalcontactList;
    }
    
    //Fetch Unique Primary contact for a key skateholder, use by SPM
    @AuraEnabled 
    public static String fetchPrimaryKeyStakeHolder(String recordId){
        String contactId = [SELECT Contact__c 
                                  FROM Key_Stakeholders__c 
                                  WHERE Primary_Contact__c = TRUE AND Business_Unit_Account__c =: recordId LIMIT 1].Contact__c;
        
        return contactId;
    }
    
    @AuraEnabled
    public static Boolean isCurrentUserSPM(String recordId) { 
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        if(profileName == 'Cisco_SPM'){
            Boolean isCustomer = isCustomerFlag(recordId);
            if(isCustomer){
                return false;
            }else{
                return true;
            }
            
        }else{
            return false;
        }
    }
    
    //Fetch Unique contacts associated with Keystakeholders related to Customer/BU for lazy loading
    @AuraEnabled 
    public static List<Contact> fetchKeyStakeHoldersLazy(String recordId,Integer limValue){
        Boolean isCustomer = isCustomerFlag(recordId);
        
        List<AggregateResult > lstCM = new List<AggregateResult>();
        List<Id> setContactID = new List<Id>();
        lstCM =Database.query('select Contact__c, contact__r.Name, COUNT(Id)'
                              +' from Key_Stakeholders__c'
                              +' where '+ 
                              +( (isCustomer) ? ' Customer_Account__c =: recordId' :' Business_Unit_Account__c =: recordId' )
                              + ' group by Contact__c, contact__r.Name order by COUNT(Id) DESC, contact__r.Name ASC  limit '+limValue);
        system.debug('Keystakeholdercontacts'+lstCM);
        if(lstCM.size()>0){
            for (AggregateResult ar : lstCM)  {
                setContactID.add((Id)ar.get('Contact__c')); 
            }
        }
        
        Map<Id,contact> contactlist = new Map<Id,contact>((List<contact>)Database.query(' select id,Name,Title,Email,Phone from Contact'
                                                                                        +' Where Id IN :setContactID ' 
                                                                                        +' limit '+limValue));
        List<contact> finalcontactList = new List<contact>();
        
        for(Integer i = 0; i<setContactID.size();i++){
            finalcontactList.add(contactlist.get(setContactID[i]));
        }
        return finalcontactList;
        
    }
    //Fetch count of contacts associated with Keystakeholders related to Customer/BU
    @AuraEnabled 
    public static Integer TotalKeyStakeHolders(String recordId){
        
        Boolean isCustomer = isCustomerFlag(recordId);
        
        List<AggregateResult > lstCM = new List<AggregateResult>();
        List<Id> setContactID = new List<Id>();
        lstCM =Database.query('select Contact__c, contact__r.Name, COUNT(Id)'
                              +' from Key_Stakeholders__c'
                              +' where '+ 
                              +( (isCustomer) ? ' Customer_Account__c =: recordId' :' Business_Unit_Account__c =: recordId' )
                              + ' group by Contact__c, contact__r.Name order by COUNT(Id) DESC, contact__r.Name ASC');
        system.debug('Keystakeholdercontacts'+lstCM);
        if(lstCM.size()>0){
            for (AggregateResult ar : lstCM)  {
                setContactID.add((Id)ar.get('Contact__c')); 
            }
        }
        
        AggregateResult StakeholdersList= [select Count(Id) TotalContacts from Contact Where Id IN : setContactID];
        Integer totalStakeholdersCount = (Integer)StakeholdersList.get('TotalContacts');
        return totalStakeholdersCount;  
    }
    
    //Insertion keystakeholder
    @AuraEnabled
    public static void insertKeyStakeHolderCustomer(Key_StakeHolders__c keyStakeHolder){
        system.debug('keyStakeHolder'+keyStakeHolder);
        insert keyStakeHolder;
    }
    
    @AuraEnabled
    public static Contact getContactRecordCustomer(String contactId) {
        system.debug('contact');
        return [select id,Name,Phone,Email,Title,JobFunction__c from Contact where Id=:contactId limit 1 ];
        
    }
}