@isTest(SeeAllData=true)
public class EloquaEngage_CTE_Test {

    public static testMethod void engageTest() {
        user u = new user(firstName = 'Test', LastName = 'AM', USERNAME = 'testam@cisco.com.test.test', email = 'testam@cisco.com.test', ALIAS = 'testam', COMMUNITYNICKNAME = 'testam', ISACTIVE = True,
            TIMEZONESIDKEY = 'America/Los_Angeles', PROFILEID = '00e30000000dcbg', LANGUAGELOCALEKEY = 'en_US', THEATRE__C = 'APJC-APAC',
            LOCALESIDKEY = 'en_US', EMAILENCODINGKEY = 'UTF-8');
        insert u;

        u.Additional_User_Permissions__c = 'MCP Prospect Profiler';
        u.GCS_Enabled__c = true;
        update u;
        
        user u2 = new user(firstName = 'Test', LastName = 'AM', USERNAME = 'testam1234@cisco.com.test.test', email = 'testam@cisco.com.test', ALIAS = 'tes234', COMMUNITYNICKNAME = 'tem2134', ISACTIVE = True,
            TIMEZONESIDKEY = 'America/Los_Angeles', PROFILEID = '00e30000000dcbg', LANGUAGELOCALEKEY = 'en_US', THEATRE__C = 'APJC-APAC', 
            LOCALESIDKEY = 'en_US', EMAILENCODINGKEY = 'UTF-8');
        insert u2;

        Test.startTest();
            Lead leadObj  = new Lead(firstName='Test eLead',LastName ='Lead', RECORDTYPEID='0123000000004aR',company='Test End-User Account',email='test@test.com.test');
            leadObj.Status = '1 Waiting';
            insert leadObj;   
            
            System.RunAs(u) {
                ApexPages.Standardcontroller stdCtlLead = New ApexPages.StandardController(leadObj);
                EloquaEngage_CTE contManualLead = new EloquaEngage_CTE(stdCtlLead);
                
            }
            
            System.RunAs(u2) {
                ApexPages.Standardcontroller stdCtlLead = New ApexPages.StandardController(leadObj);
                EloquaEngage_CTE contManualLead = new EloquaEngage_CTE(stdCtlLead);
                
            }
        Test.stopTest();
    }
}