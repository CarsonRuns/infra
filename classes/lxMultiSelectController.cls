public class lxMultiSelectController {
 @AuraEnabled
    public static List < forCheck > fetchLookUpValues(String searchKeyWord, String ObjectName,String field, String where1) {
        system.debug('ObjectName-->' + ObjectName);
        String searchKey ='%'+ searchKeyWord + '%';
        String fields= field;
        List < forCheck > returnList = new List < forCheck > ();
      
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5  
        String userId=(userInfo.getUserName()).substringBefore('@'); 
        String sQuery =  'select id,UserName,Reporting_Manager_Level_1_cec__c,'+fields+' from ' +ObjectName+' where '+where1;//fields+'!=null order by createdDate DESC LIMIT 5';
       List < sObject > lstOfRecords = Database.query(sQuery);
        //added by Kavya to add SE Manager to report list
        	forCheck fc1=new forCheck();
            fc1.label= string.valueOf(UserInfo.getName()+'('+UserInfo.getUserName().substringBefore('@')+')');
            fc1.value= string.valueOf(UserInfo.getUserId());
            returnList.add(fc1);
        //ends here
        for (sObject obj: lstOfRecords) {
            forCheck fc=new forCheck();
            String tmId = String.valueOf(obj.get('UserName'));
            fc.label= string.valueOf(obj.get(fields)+'('+tmId.substringBefore('@')+')');
            fc.value= string.valueOf(obj.id);
            returnList.add(fc);
        }
         	
        return returnList;
    }
    public class forCheck{
        @AuraEnabled
        public String label{get;set;}
        @AuraEnabled
        public string value{get;set;}
        
    }
}