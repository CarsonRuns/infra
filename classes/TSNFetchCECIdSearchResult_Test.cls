@isTest(SeeAllData=true)
private Class TSNFetchCECIdSearchResult_Test{
     private static testMethod void test(){
     
     Account a = new Account(name='TestVC',RecordtypeId = '0123000000004aV');
     insert a; 
        
     Contact co = new Contact(AccountId = a.Id, LastName = 'Test', Email = 'abc@yahoo.com' , RecordtypeId = '01280000000G6ti');
     insert co; 
    
     Case testTSNCase = new Case(RecordTypeId=Utilities.getCaseTSNRecordTypeId(),Contact_Type__c = 'Cisco',Cisco_Contact__c='susv@cisco.com',Web_CCO_ID__c='susv',AccountId = a.Id,ContactId = co.Id); 
     insert testTSNCase; // TSN Case
     
     Set<Id> caseIdList=new Set<Id>();
     caseIdList.add(testTSNCase.Id);   
     
     StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
     mock.setStaticResource('UserUnifiedXML_Data');
     mock.setStatusCode(200);
     mock.setHeader('Content-Type', 'text/plain');  
        
     Test.StartTest();
     TSNFetchCECIdSearchResult.doCECIdSearch(caseIdList);    
     Test.setMock(HttpCalloutMock.class, mock);
     TSNUserUnifiedDetailsWebService.getCecVal('test');
     try{
        testTSNCase.Cisco_Contact_Name__c = 'Test Name';
        testTSNCase.Cisco_Contact_Title__c = 'Test Title';
        update testTSNCase;
       }catch(Exception ex){}

     Test.StopTest();
   }
}