@isTest(seeAllData=true)
private class CaseEmailValidationTest
{
 private static testMethod void test_Case_Email()
  {
   Utilities.setIsTestMethod(true);
   
     Account a1 = new Account(name='TestVC1',RecordtypeId = '0123000000004aV'); 
        insert a1;
        Contact co = new Contact(AccountId = a1.Id, LastName = 'Test', Email = 'test@cisco.com' , RecordtypeId = '01280000000G6ti');
        insert co;   
        
        
        // Cisco_TSN User 
        Utilities.setValidationSkip(true);//skips validation rules 
Test.startTest();
        User currentUser = [select id from User where profileid=:Utilities.getTSNProfileId() and isactive=true limit 1];
        currentUser.Out_Of_Office_Start_Time__c = System.now();
        currentUser.Out_Of_Office_End_Time__c= System.now().addDays(2);
       currentUser.Out_Of_Office_Message__c= 'test';
       update currentUser;
       
       Case c2 = new Case(AccountId = a1.Id,RecordtypeId =Utilities.getCasePDIRecordTypeId(),ContactId = co.Id);
        c2.web_cco_id__c='TESTccoId2@cisco.com';
        c2.suppliedemail='TESTccoId2@cisco.com';
        c2.ownerId=currentUser.id;
        insert c2; // PDI Case
        
        EmailMessage msg1 = new EmailMessage(ParentId=c2.Id, FromName = 'Cisco Case Management', Incoming = True, TextBody = 'TestBody', FromAddress = 'test@cisco.com' ); 
        Insert msg1;
   
   Test.stopTest();
  }
}