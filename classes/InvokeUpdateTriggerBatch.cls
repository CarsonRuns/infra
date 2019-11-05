global class InvokeUpdateTriggerBatch implements Database.Batchable<sObject> {

    public boolean runTestMethod  = false; 
 
    global Database.QueryLocator start(Database.BatchableContext BC){
 
        String query = 'SELECT Id FROM Account';
        if (runTestMethod){
        	query = query  + ' limit 1';
        }
        return Database.getQueryLocator(query);     
 
    }
 
    global void execute(Database.BatchableContext BC, List<sObject> scope){       
 
        for (Account a : (List<Account>)scope)
        {
          // get all the contacts
          List<Contact> listContact = [select Id from Contact where accountId = :a.Id and duplicatePrevention__c != null]; 
          update listContact;       
        }
        
 
     }
 
    global void finish(Database.BatchableContext BC){
 
        System.debug('Batch Process Complete');
 
    }
    
    
      public static testMethod void testBatch() {
    
      	 InvokeUpdateTriggerBatch a = new InvokeUpdateTriggerBatch();
      	 Database.executeBatch(a,1);    	 
      	
      	
      }
     
 
}