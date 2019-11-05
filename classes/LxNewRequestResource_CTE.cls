public class LxNewRequestResource_CTE {
    @AuraEnabled
    public static map<string,id>  getRecordTypeNames(){
        List<RecordType> caseRecordTypeList = [SELECT Id, Name, DeveloperName, sObjectType FROM RecordType WHERE IsActive = TRUE and sObjectType='CASE'];
    	system.debug('Case Record Types'+caseRecordTypeList);
        map<string,id> caseRecordMap = new map<string,id>();
        for(RecordType rt : caseRecordTypeList){
            system.debug(rt.Name +' ::: '+rt.DeveloperName);
            caseRecordMap.put(rt.DeveloperName,rt.id);            
        }
        system.debug('caseRecordMap:::'+caseRecordMap);
        return caseRecordMap;
    }

    @AuraEnabled
    public static oppWrapper getDetails(String oppID){
        system.debug('-------------------oppID-------------'+oppID);
        Opportunity opp = [SELECT Primary_Partner__c, Account.Industry, Account.Country__c FROM Opportunity WHERE id=:oppID];
        User usr = [SELECT id FROM User WHERE id=:userinfo.getUserId()];
        system.debug(opp.Account.Country__c);
        
        List<Schema.PicklistEntry> countryLst = new List<Schema.PicklistEntry>();
        countryLst = Case.fields.Country__c.getDescribe().getpicklistvalues();
        String caseCountry; 
        for (Schema.PicklistEntry t : countryLst)
        {
            if (t.getValue().equalsIgnoreCase(String.valueOf(opp.Account.Country__c)))
            {
                caseCountry = t.getValue();
            }            
        }
        
        List<Schema.PicklistEntry> industryLst = new List<Schema.PicklistEntry>();
        industryLst = Case.fields.Customer_Industry__c.getDescribe().getpicklistvalues();
        String caseIndustry; 
        for (Schema.PicklistEntry t : industryLst)
        {
            if (t.getValue().equalsIgnoreCase(String.valueOf(opp.Account.Industry)))
            {
                caseIndustry = t.getValue();
            }            
        }
        
        oppWrapper oppWrap = new OppWrapper();
        oppWrap.opp = opp;
        oppWrap.usr = usr;
        oppWrap.caseCountry = caseCountry;
        oppWrap.caseIndustry = caseIndustry;
        System.debug('>>'+oppWrap);
        return oppWrap;
    }
       
    public class oppWrapper{
        @AuraEnabled public Opportunity opp;
        @AuraEnabled public User usr;
        @AuraEnabled public String caseCountry;
        @AuraEnabled public String caseIndustry;
    }
}