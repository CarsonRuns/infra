public class lxMultiSelectPicklist {
 @AuraEnabled
    public static List < forCheck > fetchLookUpValues(String ObjectName,String field) {
        system.debug('ObjectName-->' + ObjectName);
       // String searchKey ='%'+ searchKeyWord + '%';
        String fields= field;
        //System.debug('field' + field);
         System.debug('>>Shivi');
        List < forCheck > returnList = new List < forCheck > ();
      
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5 
        String userId=(userInfo.getUserName()).substringBefore('@');
//String conditoin Reporting_Manager_Level_1_cec__c=:userId.toUpperCase() AND Additional_User_Permissions__c includes ('SE User')]; 
          String var='('+'\''+'SE User'+'\''+')';
        String sQuery =  'select id,'+field+' from ' +ObjectName + ' where '+ 'Reporting_Manager_Level_1_cec__c='+ '\''+userId.toUpperCase()+'\''+' AND isActive=true AND Additional_User_Permissions__c includes '+ var;
        System.debug(sQuery);

        List < sObject > lstOfRecords = Database.query(sQuery);
    	//adding logged In user
        forCheck fcheck=new forCheck();
        fcheck.label=UserInfo.getName();
        fcheck.value=UserInfo.getUserId();
        returnList.add(fcheck);
        
        for (sObject obj: lstOfRecords) {
            forCheck fc=new forCheck();
            fc.label= string.valueOf(obj.get(fields));
            fc.value= string.valueOf(obj.id);
            returnList.add(fc);
        }
       
        System.debug('>>'+returnList);
        return returnList;
    }
    public class forCheck{
        @AuraEnabled
        public String label{get; set;}
        @AuraEnabled
        public string value{get; set;}
    }
    @AuraEnabled
    public static List<forCheck> getReportees(){
        String userId=(userInfo.getUserName()).substringBefore('@');
        List<User> reporteeLst=[Select id,Name from User where Reporting_Manager_Level_1_cec__c=:userId.toUpperCase() AND Additional_User_Permissions__c includes ('SE User') AND isActive=true];
        
         List < forCheck > returnList = new List < forCheck > ();
        forCheck fcheck=new forCheck();
        fcheck.label=UserInfo.getName();
        fcheck.value=UserInfo.getUserId();
        returnList.add(fcheck);
         for (User obj: reporteeLst) {
            forCheck fc=new forCheck();
            fc.label= obj.Name;
            fc.value= obj.Id;
            returnList.add(fc);
        }
        return returnList;
    }

}