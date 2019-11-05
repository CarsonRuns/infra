@isTest
public class lxMultiSelectControllerTest {
 private static testMethod void testMethod1()
    {
        Utilities.setIsTestMethod(true);
        Utilities.setValidationSkip(true);        
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Cisco_ADMIN' Limit 1];
        User usr = lxTestDataFactory.createSingleUser(p.Id);
        usr.Reporting_Manager_Level_1_cec__c = (userInfo.getUserName()).substringBefore('@');
        usr.Additional_User_Permissions__c = 'SE User';
        usr.IsActive = true;
        insert usr;
        String userId = (usr.Username).substringBefore('@');
        User usr1 = [Select id,UserName,Name from User where Additional_User_Permissions__c includes ('SE User') and isActive=true limit 1];
        String where1 = 'Reporting_Manager_Level_1_cec__c=:userId AND Additional_User_Permissions__c includes (\'SE User\') and isActive=true';
       
        lxMultiSelectController.fetchLookUpValues('abc', 'User', 'Name', where1);
        lxMultiSelectController.forCheck frcheck = new lxMultiSelectController.forCheck();
        frcheck.label = 'test';
        frcheck.value = 'test';
        
    }
}