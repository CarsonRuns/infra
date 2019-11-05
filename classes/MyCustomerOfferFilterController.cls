public class MyCustomerOfferFilterController {
	//method to get list of customers Associated to Leadership and CSE users
    @auraEnabled
    public static accountListWrapper getAccountList(){
        String userId = userinfo.getUserId(); 
        boolean leadership=false;
        Set<String> groupNames = new Set<String>();
        ObjectRecordTypeIds__c accRTId = ObjectRecordTypeIds__c.getOrgDefaults();
        string custRecId=accRTId.Account_Customer_RecordTypeId__c;
        for (GroupMember gm : [select group.Name,group.DeveloperName from GroupMember where UserOrGroupId = :userId]) {
       		groupNames.add(gm.group.DeveloperName);
   		}
        if(groupNames.contains('CSE_Leadership')){
            leadership=true;
        }
        accountListWrapper listWrapper = new accountListWrapper();
        listWrapper.acc  = Database.query('SELECT Id,Name'+
                            +' FROM Account '+
                            +' WHERE RecordTypeId=:custRecId and '
                            + ((leadership) ? 'Account.Assigned_CSE__c!=null' : 'Account.Assigned_CSE__c=:userId'));
        system.debug('=== listWrapper.acc'+listWrapper.acc);
        List<Account> customers = listWrapper.acc;
        /*listWrapper.off = Database.query('SELECT Id,Name,Customer_Name__c'+
                            +' FROM Offer__c'+
                            +' WHERE Customer_Name__c in:customers');*/
        
        listWrapper.off = new Map<Id,Offer__c>([Select Id,Name,Offer_Level_1_Name__c from Offer__c where Customer_Name__c IN:customers and Offer_Level_1_Name__c Like '%DNA%']);
        system.debug('listWrapper==='+listWrapper.off);
        return listWrapper;
    }
    public class accountListWrapper{
        @AuraEnabled public List<Account> acc;
        @AuraEnabled public Map<Id,Offer__c> off;
    }
    
    @AuraEnabled 
    public static List<String> fetchOfferByCustomers(List<String> customerIds){
        Set<String> uniqueLvlName = new Set<String>();
        List<String> offerList = new List<String>();
        for(Offer__c off : [Select Id,Name,Offer_Level_1_Name__c from Offer__c where Customer_Name__c=:customerIds]){
            uniqueLvlName.add(off.Offer_Level_1_Name__c);
        }
        offerList.addAll(uniqueLvlName);
        return offerList;
    }
}