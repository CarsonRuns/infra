@isTest 
private Class OpptyOwnerSyncBatchApex_Test
{
    static testMethod void MyTestMethod() 
    {        
        Account a = new Account(name='TestBatchAccount',RecordtypeId =Utilities.getAccountEndUserRecordTypeId());
        insert a;       
        Opportunity o = new Opportunity(name ='Test' , accountId = a.Id,stagename ='1 - Prospect',closedate = system.today());
        insert o;        
        Test.startTest();
        OpptyOwnerScheduleBatchApex os = new OpptyOwnerScheduleBatchApex();
        String query = 'select ownerid ,Opportunity_Owner_AM__c,Id from Opportunity where Id =\'' + o.Id + '\'';
        OpptyOwnerSyncBatchApex load = new OpptyOwnerSyncBatchApex(query);
        ID JobId = Database.executeBatch(load,200);  
        Test.stopTest();
    }
}