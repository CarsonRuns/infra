@isTest(SeeAllData=true) 
public class NGCC_Fetch_Email_Info_Test {
    @isTest
    public static void getemailBodytest(){
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
        
        system.runAs(new User(id=userinfo.getuserid())){
            EmailTemplate validEmailTemplate = new EmailTemplate();
            validEmailTemplate.isActive = true;
            validEmailTemplate.Name = 'TestingFlowTemplate';
            validEmailTemplate.DeveloperName = 'TestingFlowTemplate';
            validEmailTemplate.TemplateType = 'text';
            validEmailTemplate.FolderId = UserInfo.getUserId();
            validEmailTemplate.Subject = 'TestingFlowTemplate';
            
            insert validEmailTemplate;
        }
        
        
        map<string,string> emailMap = NGCC_Fetch_Email_Info.getemailBody(testLead.id, 'TestingFlowTemplate');
        system.assertEquals(true, emailMap.size()>0);
    }
    @isTest
    public static void sendemailtest(){
        String body = 'test body';
        String Subject = 'test subject';
        string Emailaddress = 'test@test.com';
        NGCC_Fetch_Email_Info.sendemail(body, Subject, Emailaddress);
    }
    
}