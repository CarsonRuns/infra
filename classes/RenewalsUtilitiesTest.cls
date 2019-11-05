@isTest
private class RenewalsUtilitiesTest {
    
    static testMethod void RenewalsUtilitiesMethodTest(){
        
        RenewalsUtilities RenewalsUtilitiesObj = new RenewalsUtilities();
        // ObjectRecordTypeIds__c ObjectRecordTypeIdsOb=new ObjectRecordTypeIds__c();
        // ObjectRecordTypeIdsOb.Account_Customer_RecordType_18__c = '0125B000000JoBZQA0' ;
        list<Account> acclist = [select id from account limit 10];
        List<Id> accIds = new List<Id>();
        for(Account acc : acclist){
            accIds.add(acc.id);
        }

        Map<String,String> customerAccountMap = new Map<String,String>();
        customerAccountMap = RenewalsUtilities.getCustomerAccountMapping(accIds);
        system.debug(customerAccountMap);
        
        Map<String,String> labelAccountMap = new Map<String,String>();

        labelAccountMap = RenewalsUtilities.getAccountLabelNames();
    }
    
    
}