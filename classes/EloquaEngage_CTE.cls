public with sharing class EloquaEngage_CTE {

    public String value {get;set;}

    public EloquaEngage_CTE(ApexPages.StandardController controller) {
         List<User> ulist=[Select Additional_User_Permissions__c, GCS_Enabled__c from User where Id=: UserInfo.getUserId() Limit 1];
       
         if (ulist[0].GCS_Enabled__c){
             value = Org_Constant_CS__c.getInstance('Eloqua_Engage_GCS').Production_Value__c;
         } else {
            value = Org_Constant_CS__c.getInstance('Eloqua_Engage_Global').Production_Value__c;
         }
    }


}