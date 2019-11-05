@isTest(SeeAllData=True)
public class  DocumentRollUpControllerTest {
        
       static testMethod void testMethod1() 
    {
        //Creating dataset
        Profile prof = [select id from profile where name LIKE '%Cisco_CustomerSuccess%'];
        User user = new User(Alias = 'newUser', Email='newuser@cisco.com',
         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
         LocaleSidKey='en_US', ProfileId = prof.id,
         TimeZoneSidKey='America/Los_Angeles', UserName='newuser@cisco.com', 
         Theatre__c = 'Americas-US Commercial', Additional_User_Permissions__c='Enable EndUser ACCTCreation');
        insert user;
            
        System.runas(user){            
            //Insert Customer Account Record
            Account CustomerAcc = new Account();
            Id CustrRcrdId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            CustomerAcc.RecordTypeId = CustrRcrdId;
            CustomerAcc.Name = 'CustomerTestAccount';
            insert CustomerAcc;
            system.debug('CustomerAcc>>>'+CustomerAcc);            
            
            CS_Documents__c Docu = new CS_Documents__c();
            Docu.Name = 'TestDoc';
            Docu.URL__c = 'www.google.com';
            Docu.Account__c = CustomerAcc.Id;
            insert Docu;
                          
            Test.startTest();
            List<CS_Documents__c> docList = DocumentRollUpController.fetchDocumentList(CustomerAcc.Id);
            System.assertEquals(docList.size(),1);
            DocumentRollUpController.delteDocById(Docu.Id);   
            CS_Documents__c delDoc = [SELECT Id,isdeleted from CS_Documents__c where Id=:Docu.Id ALL ROWS];
            System.assertEquals(delDoc.isdeleted,true);              
            Test.stopTest();
        }
    }
}