@istest
private class AccountTestMethods{
    
    private static testMethod void testChannelContactActDeact(){
        
        Account a = new Account(name='TestAccount',Partner_Account_Status__c='Active (Registered)',recordTypeId=Utilities.getAccountChannelRecordTypeId());
        Insert a;
        Contact c = new Contact(lastname='testContact',AccountId=a.Id, recordtypeId=Utilities.getContactManualPartnerRecordTypeId());
        Insert c;
        a.Partner_Account_Status__c='Inactive';
        Update a;
        a.Partner_Account_Status__c='Active (Registered)';
        Update a;
    
    }
    static testmethod void  accountDeletetest()
    {
      List<Account> acclist = new List<Account>();
       /* Account a = new Account(name='TestAccount',Partner_Account_Status__c='Active (Registered)',recordTypeId=Utilities.getAccountChannelRecordTypeId(),Country__c='UNITED STATES');
        Insert a;
        acclist.add(a);*/
        
         Account  accountTest= UtilUnitTest.getAccount(); 
         insert accountTest; 
        acclist.add(accountTest);
       
        
        Test.startTest();
        AccountBO ABO = new AccountBO();
        AccountBO.accountDelete(acclist);
       // AccountBO.accountGeoLocBeforeUpsertBatch(acclist);
        Test.StopTest();
      
    }
    static testmethod void accountGeoLocBeforeUpsertBatchtest()
    {
       // UtilUnitTest.loadAllStaticData();
       List<Account> acclist = new List<Account>(); 
        Account partnerAccountId = GenericStaticTestData.gettestChannelAccountRecord1();
        //partnerAccountId.CRAdressFlag__c = false;
        partnerAccountId.AddressLine1_English__c = 'test123';
        partnerAccountId.CRAddressLine1__c = 'TestQA';
        partnerAccountId.CRAddressLine1__c = 'Test';
        partnerAccountId.CRAddressLine2__c = 'Test';
        partnerAccountId.CRCity__c = 'test';
        partnerAccountId.CRState__c = 'testState';
        partnerAccountId.CRZipPostalCode__c = 'Q12345';
        partnerAccountId.CRCountry__c = 'UNITESTATES';
        partnerAccountId.AddressLine2_English__c = 'TEST123';
        partnerAccountId.City_English__c = 'TestEnd';
        partnerAccountId.State_Province_English__c = 'TESt';
        partnerAccountId.Zip_Postal_Code_English__c = '12sdf';
        partnerAccountId.Country_English__c = 'Testtest';
        acclist.add(partnerAccountId);
        update acclist;
        
        
        
          /*  Assigned_Partner__c assigned_partnercTest = new Assigned_partner__c(Name='Test Target Prospect Record',TARGET_ARCHITECTURE__C='Any/All Technologies',
            TARGET_DESCRIPTION__C='Test Target Prospect Record',Assigned_Partner__c = acclist[0].id , Partner_Status__c = 'Partner Assigned', 
            Partner_Assigned_Date__c = DateTime.now(), PSR_Assigned_Date_Time__c = DateTime.now());
            insert assigned_partnercTest;
            assigned_partnercTest.Assignment_Activated__c = true;
            update assigned_partnercTest;*/
           
      system.debug('acclist>>'+acclist);
        
      
            
        Test.startTest();
        
      //  AccountBO.accountGeoLocBeforeUpsertBatch(acclist);
        
        Test.stoptest();
        
    
    }
    static testmethod void deletetest()
    {
      List<Account> acclist = new List<Account>(); 
        Account partnerAccountId = GenericStaticTestData.gettestChannelAccountRecord1();
        //partnerAccountId.CRAdressFlag__c = false;
        partnerAccountId.AddressLine1_English__c = 'test123';
        partnerAccountId.CRAddressLine1__c = 'TestQA';
        partnerAccountId.CRAddressLine1__c = 'Test';
        partnerAccountId.CRAddressLine2__c = 'Test';
        partnerAccountId.CRCity__c = 'test';
        partnerAccountId.CRState__c = 'testState';
        partnerAccountId.CRZipPostalCode__c = 'Q12345';
        partnerAccountId.CRCountry__c = 'UNITESTATES';
        partnerAccountId.AddressLine2_English__c = 'TEST123';
        partnerAccountId.City_English__c = 'TestEnd';
        partnerAccountId.State_Province_English__c = 'TESt';
        partnerAccountId.Zip_Postal_Code_English__c = '12sdf';
        partnerAccountId.Country_English__c = 'Testtest';
        acclist.add(partnerAccountId);
        delete acclist; 
    }
}