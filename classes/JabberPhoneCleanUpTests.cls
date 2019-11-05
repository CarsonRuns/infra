@isTest
private class JabberPhoneCleanUpTests {
    private static testmethod void TestJabberAcccleanup()
    {
    
        Account acc = new Account();
        Account acc1 = new Account();
        Account acc2 = new Account();
        
        acc.Name = 'Test JAbber';
        acc.Phone = '9535 0829abc69';
        acc.CRCountry__c = 'INDIA';
        acc.Partner_Account_Status__c = 'Active (Registered)';
        
        List<RecordType> rc = [Select id from RecordType where name = 'channel'];
        acc.recordTypeId = rc[0].Id;
        //acc.recordTypeId = Utilities.getAccountChannelRecordTypeId();
        
        acc1.Name = 'Test Jabber1';
        acc1.Phone = '9535 0829a%@@c69';
        acc1.CRCountry__c = 'SPAIN';
        acc1.Partner_Account_Status__c = 'Active (Registered)';
        acc1.recordTypeId = Utilities.getAccountChannelRecordTypeId();
        
        acc2.Name = 'Test Jabber2';
        acc2.Phone = '4087075492';
        acc2.CRCountry__c = 'usa';
        acc2.Partner_Account_Status__c = 'Active (Registered)';
        acc2.recordTypeId = Utilities.getAccountChannelRecordTypeId();
        
        //List<RecordType> rc1 = [Select id from RecordType where name = 'channel'];
        //acc1.recordTypeId = rc1[0].Id;
        
        List<Account> lstAcc = new List<Account>();
        lstAcc.add(acc);
        lstAcc.add(acc1);
        lstAcc.add(acc2);
        
        Test.startTest();
        insert lstAcc;
        Test.stopTest();
        
        acc1.Phone = '08407253155';
        acc1.CRCountry__c = 'india';
        update acc1;

        
        /*Account a = new Account(name='TestAccount',Partner_Account_Status__c='Active (Registered)',recordTypeId=Utilities.getAccountChannelRecordTypeId());
        Insert a;
        Contact c = new Contact(lastname='testContact',AccountId=a.Id, recordtypeId=Utilities.getContactManualPartnerRecordTypeId());
        Insert c;
        a.Partner_Account_Status__c='Inactive';
        Update a;
        a.Partner_Account_Status__c='Active (Registered)';
        Update a;*/
    
    
        
        //Account a = new Account(name='TestAccount',Partner_Account_Status__c='Active (Registered)',recordTypeId=Utilities.getAccountChannelRecordTypeId(),Phone = '9535 0829a%@@c69',CRCountry__c = 'SPAIN');
        //Insert a;
        
        
    }
    
        
    
    static testmethod void TestJabberConcleanup()
    {
        
       // List<Account> lstAcn = [select id from Account where CRCountry__c != null Limit 1];
        Account jAcc = GenericStaticTestData.gettestChannelAccountRecord1();   
        string contactRecId=Utilities.getContactManualPartnerRecordTypeId();    
        
        Contact con = new Contact();
        Contact con1 = new Contact();
        Contact con2 = new Contact();
        
        con.Lastname = 'Jabber contact';
        con.AccountID = jAcc.Id;
        con.Phone = '09535 0829abc69';
        con.RecordTypeId=contactRecId;
                
        con1.Lastname = 'Jabber contact1';
        con1.AccountID = jAcc.Id;
        con1.Phone = '9535hjn 0829abc69';
        con1.RecordTypeId=contactRecId;
        
        con2.Lastname = 'Jabber contact3';
        con2.AccountID = jAcc.Id;
        con2.Phone = '';
        con2.RecordTypeId=contactRecId;
        
        List<Contact> lstCon = new List<Contact>();
        lstCon.add(con);
        lstCon.add(con1);
        lstCon.add(con2);
        
        Test.startTest();
        insert lstCon;
        Test.stopTest();
        
        
    }

}