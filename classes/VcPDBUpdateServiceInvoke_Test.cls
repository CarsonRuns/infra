@isTest 
private Class VcPDBUpdateServiceInvoke_Test
{
    static testMethod void MyTestMethod() 
    {
        
        Account a = new Account(name='TestVC',RecordtypeId =Utilities.getAccountChannelRecordTypeId());
        insert a;
        Test.startTest();
        Case c = new Case(AccountId = a.Id,RecordtypeId =Utilities.getCasePARecordTypeId());
        insert c;
        String Response = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><VCSFDCUpdateResponse xmlns="urn:cisco:names:message:vc"><vcsfdcupdateresponse><partnerId>353254</partnerId><country>UNITED KINGDOM</country><vcResponseTimeStamp>10-29-2010 04:39:11 CDT</vcResponseTimeStamp><vcResponseCode>SUCCESS</vcResponseCode></vcsfdcupdateresponse></VCSFDCUpdateResponse>';
        String Message = VcPDBUpdateServiceInvoke.getMessage(response) ;
        String Code = Utilities.getCode_Desc('INDIA');
        Set<Id> s = new Set<Id>(); 
        List<Account> al = [select id from Account Limit 5];
         for(Account acc: al)
         {  
            s.add(acc.id);    
         }  
        VcPDBUpdateServiceInvoke.CallPdbUpdateService(s, System.today());
        Test.stopTest();
    }
}