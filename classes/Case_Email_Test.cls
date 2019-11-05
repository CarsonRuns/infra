@isTest
private class Case_Email_Test
{
 static testMethod void test_Case_Email()
  {
   Utilities.setIsTestMethod(true);
   Utilities.setValidationSkip(true);//skips validation rules

   Test.startTest();
   Case_Email caseEmailObject=new Case_Email();  

   //Account object
   Account act = new Account(name='TestVC',RecordtypeId =Utilities.getAccountChannelRecordTypeId());
   insert act;
   
    //Contact object
   Contact co = new Contact(AccountId = act.Id, LastName = 'Test', Email = 'test@cisco.com',RecordtypeId =Utilities.getContactManualPartnerRecordTypeId() );
   insert co;
   
   //Case TSN Object  
   Case testcase = new Case(AccountId = act.Id,RecordtypeId =Utilities.getCaseTSNRecordTypeId(),ContactId = co.Id);
   insert testCase;

   
   
   //TSN Case Comment Object
   CaseComment testCaseComment=new CaseComment(parentId=testCase.id);
   testCaseComment.commentBody='test Comment Body ';
   //testCaseComment.createdDate=System.today();
   List<CaseComment> listOfCaseComment=new List<CaseComment>();
   listOfCaseComment.add(testCaseComment);
   insert listOfCaseComment;
  
   //TSN Email Message 1 Object
   EmailMessage testEmailMessage1=new EmailMessage(parentId=testCase.id);
   testEmailMessage1.HtmlBody='Test Html Body ';
   testEmailMessage1.TextBody='Test Text Body';
   testEmailMessage1.MessageDate=System.today()-1;
   testEmailMessage1.Subject='Test Subject';
   testEmailMessage1.FromName = 'Cisco Case Management';

   //TSN Email Message 2 Object
   EmailMessage testEmailMessage2=new EmailMessage(parentId=testCase.id);
   testEmailMessage2.HtmlBody='Test Html Body ';
   testEmailMessage2.TextBody='Test Text Body';
   testEmailMessage2.MessageDate=System.today();
   testEmailMessage2.Subject='Test Subject';
   testEmailMessage2.FromName = 'Cisco Case Management';

   //TSN Email Message 3 Object
   EmailMessage testEmailMessage3=new EmailMessage(parentId=testCase.id);
   testEmailMessage3.TextBody='Test Text Body';
   testEmailMessage3.MessageDate=System.today();
   testEmailMessage3.Subject='Test Subject';
   testEmailMessage3.FromName = 'Cisco Case Management';
   
   //Email Messages List 
   List<EmailMessage> listOfEmailMessage=new List<EmailMessage>();
   listOfEmailMessage.add(testEmailMessage1);
   listOfEmailMessage.add(testEmailMessage2);
   listOfEmailMessage.add(testEmailMessage3);
   insert listOfEmailMessage;
  

   //TSN Case History Object
   CaseHistory testCaseHistory=new CaseHistory(caseId=testCase.id); 
   List<CaseHistory> listOfCaseHistory=new List<CaseHistory>();
   listOfCaseHistory.add(testCaseHistory);
   System.debug('&&#$%***'+listOfCaseHistory);
 
 
   String testCaseNumber=[select id,casenumber from case where id=:testCase.id].caseNumber;
   caseEmailObject.setCaseId(testCaseNumber);  
   String caseId=caseEmailObject.getCaseId();
   caseEmailObject.getBody();  
   List<Case_Email.CaseInfo> listCaseData=caseEmailObject.populateCaseInfoList(listOfCaseComment,listOfEmailMessage,listOfCaseHistory);
   caseEmailObject.sortList(listCaseData);

   Test.stopTest();
  }
}