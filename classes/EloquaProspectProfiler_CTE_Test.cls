/*********************************************************************************************************************************
Name    : EloquaProspectProfiler_CTE_Test 
Author  : Mukesh Srivastava
Purpose : The purpose of the Test class to handle Eloqua Profiler Access on Both lead and Contact           
Created Date:  10/14/2014
Modification History: 
                      
**********************************************************************************************************************************/

@isTest(SeeAllData=true)
public class EloquaProspectProfiler_CTE_Test {
    
    public static testMethod void testEloquaProspectProfiler_CTE_PositiveTestA() {
     //   loadOrgRecTypeCS();
         Profile p = [SELECT Id FROM Profile WHERE Name = 'Cisco_Admin' Limit 1];
        User u= new User(Additional_User_Permissions__c = 'Enable EndUser ACCTCreation', Alias = 'newUser', Email = 'batchJobOppty@cisco.com',
                               EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                               LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'batchJobOppty@cisco.com.testing', Theatre__c = 'Americas-US Commercial');
        insert u; 

        u.Additional_User_Permissions__c = 'MCP Prospect Profiler';
        update u;
        Test.startTest();
        Lead leadObj  = new Lead(firstName='Test eLead',LastName ='Lead', RECORDTYPEID='0123000000004aRAAQ',company='Test End-User Account',email='test@test.com.test');
        leadObj.Status = '1 Waiting';
        leadObj.Latest_Lead_Acceptance_Date__c = Datetime.now();
        insert leadObj;   
        System.RunAs(u) {
            Test.setCurrentPageReference(New PageReference('Page.EloquaProspectProfilerLead'));
            ApexPages.Standardcontroller stdCtlLead = New ApexPages.StandardController(leadObj);
            EloquaProspectProfiler_CTE contManualLead = new EloquaProspectProfiler_CTE(stdCtlLead);
            contManualLead.validateLicense();
        }
        Test.stopTest();
    }
    
     public static testMethod void testEloquaProspectProfiler_CTE_sfdcActiveLeadA() {
    //    loadOrgRecTypeCS();
          Profile p = [SELECT Id FROM Profile WHERE Name = 'Cisco_Admin' Limit 1];
        User u= new User(Additional_User_Permissions__c = 'Enable EndUser ACCTCreation', Alias = 'newUser', Email = 'batchJobOppty@cisco.com',
                               EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                               LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'batchJobOppty@cisco.com.testing', Theatre__c = 'Americas-US Commercial');
        insert u; 
        u.Additional_User_Permissions__c = 'MCP Prospect Profiler';
        update u;
        Test.startTest();
        Lead leadObj  = new Lead(firstName='Test eLead',LastName ='Lead', RECORDTYPEID='0123000000004aRAAQ',company='Test End-User Account',email='test@test.com.test');
        leadObj.Status = '1 Waiting';
        leadObj.Latest_Lead_Acceptance_Date__c = Datetime.now();
        insert leadObj;   
        System.RunAs(u) {
            Test.setCurrentPageReference(New PageReference('Page.EloquaProspectProfilerLead'));
            ApexPages.Standardcontroller stdCtlLead = New ApexPages.StandardController(leadObj);
            EloquaProspectProfiler_CTE contManualLead = new EloquaProspectProfiler_CTE(stdCtlLead);
            contManualLead.sfdcActiveLead(leadObj);
            
        }
        Test.stopTest();
    }
    
    public static testMethod void testEloquaProspectProfiler_CTE_sfdcNotActiveLeadA() {
    //    loadOrgRecTypeCS();
         Profile p = [SELECT Id FROM Profile WHERE Name = 'Cisco_Admin' Limit 1];
        User u= new User(Additional_User_Permissions__c = 'Enable EndUser ACCTCreation', Alias = 'newUser', Email = 'batchJobOppty@cisco.com',
                               EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                               LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'batchJobOppty@cisco.com.testing', Theatre__c = 'Americas-US Commercial');
        insert u; 

        u.Additional_User_Permissions__c = 'MCP Prospect Profiler';
        update u;
        Test.startTest();
        Lead leadObj  = new Lead(firstName='Test eLead',LastName ='Lead', RECORDTYPEID='0123000000004aRAAQ',company='Test End-User Account',email='test@test.com.test');
        leadObj.Latest_Lead_Acceptance_Date__c = Datetime.now()-46;
        leadObj.Status = '1 Waiting';
        insert leadObj;   
        System.RunAs(u) {
            Test.setCurrentPageReference(New PageReference('Page.EloquaProspectProfilerLead'));
            ApexPages.Standardcontroller stdCtlLead = New ApexPages.StandardController(leadObj);
            EloquaProspectProfiler_CTE contManualLead = new EloquaProspectProfiler_CTE(stdCtlLead);
            Boolean result = contManualLead.sfdcActiveLead(leadObj);
            System.assertEquals(result, true);
        }
        Test.stopTest();
    }
    
    public static testMethod void testEloquaProspectProfiler_CTE_ngccActiveLeadA() {
    //    loadOrgRecTypeCS();
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Cisco_Admin' Limit 1];
        User u= new User(Additional_User_Permissions__c = 'Enable EndUser ACCTCreation', Alias = 'newUser', Email = 'batchJobOppty@cisco.com',
                               EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                               LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'batchJobOppty@cisco.com.testing', Theatre__c = 'Americas-US Commercial');
        insert u; 

        u.Additional_User_Permissions__c = 'MCP Prospect Profiler';
        update u;
        Test.startTest();
        Lead leadObj  = new Lead(firstName='Test eLead',LastName ='Lead', RECORDTYPEID='0123000000004aRAAQ',company='Test End-User Account',email='test@test.com.test');
        leadObj.Status = '1 Waiting'; 
        leadObj.Latest_Lead_Acceptance_Date__c = Datetime.now();
        insert leadObj;   
        System.RunAs(u) {
            Test.setCurrentPageReference(New PageReference('Page.EloquaProspectProfilerLead'));
            ApexPages.Standardcontroller stdCtlLead = New ApexPages.StandardController(leadObj);
            EloquaProspectProfiler_CTE contManualLead = new EloquaProspectProfiler_CTE(stdCtlLead);
            Boolean result = contManualLead.ngccActiveLead(leadObj);
            System.assertEquals(result, false);
        }
        Test.stopTest();
    }
    
    public static testMethod void testEloquaProspectProfiler_CTE_recordTypeCheckA() {
     //   loadOrgRecTypeCS();
         Profile p = [SELECT Id FROM Profile WHERE Name = 'Cisco_Admin' Limit 1];
        User u= new User(Additional_User_Permissions__c = 'Enable EndUser ACCTCreation', Alias = 'newUser', Email = 'batchJobOppty@cisco.com',
                               EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                               LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'batchJobOppty@cisco.com.testing', Theatre__c = 'Americas-US Commercial');
        insert u; 

        u.Additional_User_Permissions__c = 'MCP Prospect Profiler';
        update u;
        Test.startTest();
        Lead leadObj  = new Lead(firstName='Test eLead',LastName ='Lead', RECORDTYPEID='0123000000004aS',company='Test End-User Account',email='test@test.com.test');
        leadObj.Status = '1 Waiting';
        leadObj.LeadSource = 'test';
        leadObj.Latest_Lead_Acceptance_Date__c = Datetime.now();
        insert leadObj;   
        System.RunAs(u) {
            Test.setCurrentPageReference(New PageReference('Page.EloquaProspectProfilerLead'));
            ApexPages.Standardcontroller stdCtlLead = New ApexPages.StandardController(leadObj);
            EloquaProspectProfiler_CTE contManualLead = new EloquaProspectProfiler_CTE(stdCtlLead);
            Boolean result = contManualLead.leadRecordTypeCheck(leadObj);
            System.assertEquals(result, true);
        }
        Test.stopTest();
    }
 
     public static testMethod void testEloquaProspectProfiler_CTE_dateRangeCheckA() {
      //  loadOrgRecTypeCS();
         Profile p = [SELECT Id FROM Profile WHERE Name = 'Cisco_Admin' Limit 1];
        User u= new User(Additional_User_Permissions__c = 'Enable EndUser ACCTCreation', Alias = 'newUser', Email = 'batchJobOppty@cisco.com',
                               EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                               LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'batchJobOppty@cisco.com.testing', Theatre__c = 'Americas-US Commercial');
        insert u; 

        u.Additional_User_Permissions__c = 'MCP Prospect Profiler';
        update u;
        Test.startTest();
        Lead leadObj  = new Lead(firstName='Test eLead',LastName ='Lead', RECORDTYPEID='0123000000004aRAAQ',company='Test End-User Account',email='test@test.com.test');
        leadObj.Status = '3.7 Rejected-Not My Territory/Account';
        leadObj.Latest_Lead_Acceptance_Date__c = Datetime.now();
        insert leadObj;   
        System.RunAs(u) {
            Test.setCurrentPageReference(New PageReference('Page.EloquaProspectProfilerLead'));
            ApexPages.Standardcontroller stdCtlLead = New ApexPages.StandardController(leadObj);
            EloquaProspectProfiler_CTE contManualLead = new EloquaProspectProfiler_CTE(stdCtlLead);
            Boolean result = contManualLead.dateRangeCheck(leadObj);
            System.assertEquals(result, false);
        }
        Test.stopTest();
    }   
    
    public static testMethod void testEloquaProspectProfiler_CTE_isactiveA() {
      //  loadOrgRecTypeCS();
         Profile p = [SELECT Id FROM Profile WHERE Name = 'Cisco_Admin' Limit 1];
        User u= new User(Additional_User_Permissions__c = 'Enable EndUser ACCTCreation', Alias = 'newUser', Email = 'batchJobOppty@cisco.com',
                               EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                               LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'batchJobOppty@cisco.com.testing', Theatre__c = 'Americas-US Commercial');
        insert u; 

        u.Additional_User_Permissions__c = 'MCP Prospect Profiler';
        update u;
        Test.startTest();
        Lead leadObj  = new Lead(firstName='Test eLead',LastName ='Lead', RECORDTYPEID='0123000000004aRAAQ',company='Test End-User Account',email='test@test.com.test');
        leadObj.Status = '1 Waiting';
        leadObj.Latest_Lead_Acceptance_Date__c = Datetime.now();
        insert leadObj;   
        System.RunAs(u) {
            Test.setCurrentPageReference(New PageReference('Page.EloquaProspectProfilerLead'));
            ApexPages.Standardcontroller stdCtlLead = New ApexPages.StandardController(leadObj);
            EloquaProspectProfiler_CTE contManualLead = new EloquaProspectProfiler_CTE(stdCtlLead);
            Boolean result = contManualLead.isActiveLead(leadObj);
            System.assertEquals(result, false);           
        }
        Test.stopTest();
    }
    
    
    
}