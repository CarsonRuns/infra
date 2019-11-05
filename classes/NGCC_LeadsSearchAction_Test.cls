@isTest(SeeAllData=true) 
public class NGCC_LeadsSearchAction_Test {
    @isTest
    public static void getLeadRecordstest(){
        Lead testLead = new Lead();
        testLead.RecordTypeId = ObjectRecordTypeIds__c.getInstance().Marketing_Lead_RecordType__c;
        testLead.FirstName = 'test';
        testLead.LastName = 'test';
        testLead.Title = 'Engineer';
        testLead.Contact_Department__c = 'Engineering';
        testLead.Phone = '(123) 123-4567';
        testLead.Call_Permission__c = 'Yes';
        testLead.Email = 'test@test.com';
        testLead.Preferred_Language__c = 'English: en_US';
        testLead.Company = 'Dummy Company';
        testLead.Address_Line_1__c = '123 Main Street';
        testLead.Address_Line_2__c = 'Suite 123';
        testLead.Address_Line_3__c = '';
        testLead.CustomCity__c = 'Some City';
        testLead.CustomState__c = 'Some State';
        testLead.CustomCountry__c = 'United States';
        testLead.CustomZip__c = '12345';
        testLead.Project_Flag__c = 'Yes';
        testLead.QATimeFrame__c = 'Unknown';
        testLead.QABudget__c = 'Budget amount not fixed';
        testLead.Main_Technology__c = 'Computers';
        testLead.QAPartner__c = 'Tech Company #2';
        testLead.ProductAmount__c = 10000;
        testLead.ServicesAmount__c = 11;
        
        INSERT testLead;
        
        NGCC_LeadsSearchAction.getLeadRecords(new list<String>{'test test'});
    }
        @isTest
    public static void getLeadRecordstest2(){
        Lead testLead = new Lead();
        testLead.RecordTypeId = ObjectRecordTypeIds__c.getInstance().Marketing_Lead_RecordType__c;
        testLead.FirstName = 'test';
        testLead.LastName = 'test';
        testLead.Title = 'Engineer';
        testLead.Contact_Department__c = 'Engineering';
        testLead.Phone = '(123) 123-4567';
        testLead.Call_Permission__c = 'Yes';
        testLead.Email = 'test@test.com';
        testLead.Preferred_Language__c = 'English: en_US';
        testLead.Company = 'Dummy Company';
        testLead.Address_Line_1__c = '123 Main Street';
        testLead.Address_Line_2__c = 'Suite 123';
        testLead.Address_Line_3__c = '';
        testLead.CustomCity__c = 'Some City';
        testLead.CustomState__c = 'Some State';
        testLead.CustomCountry__c = 'United States';
        testLead.CustomZip__c = '12345';
        testLead.Project_Flag__c = 'Yes';
        testLead.QATimeFrame__c = 'Unknown';
        testLead.QABudget__c = 'Budget amount not fixed';
        testLead.Main_Technology__c = 'Computers';
        testLead.QAPartner__c = 'Tech Company #2';
        testLead.ProductAmount__c = 10000;
        testLead.ServicesAmount__c = 11;
        
        INSERT testLead;
        
        NGCC_LeadsSearchAction.getLeadRecords(new list<String>{'test@cisco.com'});
    }
      @isTest
    public static void getLeadRecordstest3(){
        Lead testLead = new Lead();
        testLead.RecordTypeId = ObjectRecordTypeIds__c.getInstance().Marketing_Lead_RecordType__c;
        testLead.FirstName = 'test';
        testLead.LastName = 'test';
        testLead.Title = 'Engineer';
        testLead.Contact_Department__c = 'Engineering';
        testLead.Phone = '(123) 123-4567';
        testLead.Call_Permission__c = 'Yes';
        testLead.Email = 'test@test.com';
        testLead.Preferred_Language__c = 'English: en_US';
        testLead.Company = 'Dummy Company';
        testLead.Address_Line_1__c = '123 Main Street';
        testLead.Address_Line_2__c = 'Suite 123';
        testLead.Address_Line_3__c = '';
        testLead.CustomCity__c = 'Some City';
        testLead.CustomState__c = 'Some State';
        testLead.CustomCountry__c = 'United States';
        testLead.CustomZip__c = '12345';
        testLead.Project_Flag__c = 'Yes';
        testLead.QATimeFrame__c = 'Unknown';
        testLead.QABudget__c = 'Budget amount not fixed';
        testLead.Main_Technology__c = 'Computers';
        testLead.QAPartner__c = 'Tech Company #2';
        testLead.ProductAmount__c = 10000;
        testLead.ServicesAmount__c = 11;
        
        INSERT testLead;
        
        NGCC_LeadsSearchAction.getLeadRecords(new list<String>{'tdsfsffsd'});
    }
}