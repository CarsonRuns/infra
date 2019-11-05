/**
  * @author:        Paul Battisson (@pbattisson)
  * @description:   Test class for the LightningStandardController class.
  */
@isTest(seealldata=true)
private class LightningStandardControllerTest {

    private static final String testAccountName = 'Test Account';
    private static final String testAccountSite = 'Some site';
    private static final String testAccountNumber = '1234';
    private static final Integer testAccountNumberOfEmployees = 1000;
    private static Account acc = new Account(Name = testAccountName, AccountNumber = testAccountNumber, Site = testAccountSite, NumberOfEmployees = testAccountNumberOfEmployees);
    
    
    private static testMethod void testSave() {
        Id recordId = LightningStandardController.save('Account', acc);

        System.assertNotEquals(null, recordId, 'Null record Id returned.');
    }

    private static testMethod void testSaveMany() {
        Account acc2 = new Account();
        acc2.Name = 'Test Account2';

        List<Id> recordIds = LightningStandardController.saveMany('Account', new List<Account>{ acc, acc2 });

        for(Id recordId : recordIds) {
            System.assertNotEquals(null, recordId, 'Null record Id returned.');    
        }
    }

    private static testMethod void testQuery() {
        insert acc;

      
    }

    
     private static testMethod void testQueryWithFieldList() {
            insert acc;
            
    }

    private static testMethod void testQueryWithInFilterMap() {
        insert acc;

        Map<String, Object> inFilters = new Map<String, Object>{'Name' => new List<String>{testAccountName}};

        List<Account> accs = (List<Account>)LightningStandardController.query('Account', new List<String>{ 'Id', 'Name', 'AccountNumber' }, null, null, inFilters);

      //  System.assertEquals(1, accs.size());
      //  System.assertEquals(testAccountName, accs[0].Name);
       // System.assertEquals(testAccountNumber, accs[0].AccountNumber);
      //  System.assertEquals(acc.Id, accs[0].Id);
    }

    private static testMethod void testQueryWithAndFilterMap() {
        insert acc;

        Map<String, Object> andFilters = new Map<String, Object>{'Name' => testAccountName, 'AccountNumber' => testAccountNumber};

        List<Account> accs = (List<Account>)LightningStandardController.query('Account', new List<String>{ 'Id', 'Name', 'AccountNumber' }, andFilters, null, null);

     //   System.assertEquals(1, accs.size());
     //   System.assertEquals(testAccountName, accs[0].Name);
     //   System.assertEquals(testAccountNumber, accs[0].AccountNumber);
      //  System.assertEquals(acc.Id, accs[0].Id);
    }

    private static testMethod void testQueryWithOrFilterMap() {
        insert acc;

        Map<String, Object> orFilters = new Map<String, Object>{'Name' => testAccountName, 'AccountNumber' => testAccountNumber};

        List<Account> accs = (List<Account>)LightningStandardController.query('Account', new List<String>{ 'Id', 'Name', 'AccountNumber' }, null, orFilters, null);

    //    System.assertEquals(1, accs.size());
     //   System.assertEquals(testAccountName, accs[0].Name);
     //   System.assertEquals(testAccountNumber, accs[0].AccountNumber);
     //   System.assertEquals(acc.Id, accs[0].Id);
    }    
     private static testMethod void testWrapperCCE() {
            insert acc;
            Opportunity mockOpportunity = new Opportunity(DealId__c = '13238135', AccountID = acc.Id, Name = 'Test Name', StageName = '1 - Prospect', CloseDate = date.today());
            insert mockOpportunity;
        Boolean results = LightningStandardController.wrapperCCE(mockOpportunity.id);  
         
            
    }
    
    private static testMethod void testvalidateCCE() {
        Id recordId = LightningStandardController.save('Account', acc);
        Opportunity mockOpportunity = new Opportunity(DealId__c = '13238135', AccountID = acc.Id, Name = 'Test Name', StageName = '1 - Prospect', CloseDate = date.today());
        
            insert mockOpportunity;
        Map<String, List<String>> results = LightningStandardController.validateCCE(mockOpportunity.id);
       List<List<String>> val =  results.values(); 
       // List<String> obj = val[0];
        System.assertEquals(1, val.size(), 'Map should have one key entry');
      //   system.debug('-------:'+val[0][0]);
       // System.assertEquals(2, val[0].size(), 'List should have two accounts in first key');
        //System.assertEquals(testAccountName, obj[0]);
      //  System.assertEquals(testAccountName, results.success.Name);
          //  System.assertEquals(account.ZipPostalCode__c, (String) validateObj.get(0).getSobject ('account').get('ZipPostalCode__c'));
               // System.assertEquals(
                 //   System.assertEquals(
                 //       System.assertEquals(
        
    }
}