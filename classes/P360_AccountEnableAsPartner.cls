global with sharing class P360_AccountEnableAsPartner implements Database.Batchable<sObject> {
    
    private final string query;
    
    global P360_AccountEnableAsPartner(String query)
    {
        this.query = query;
    }        
    global Database.QueryLocator start(Database.BatchableContext BC)
    {        
        return Database.getQueryLocator(query);             
    }    
    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {   
        list<Account> listAccounts = new List<Account>();
        // loop over the list of accounts that need to be partner enabled
        // and set the isPartner field to true
        for(Account a: (List<Account>) scope)
        {
            // Enable channel account as a partner
            System.debug('ACCOUNT>>>>>' + a.id);
            a.IsPartner = true;
            listAccounts.add(a);
            
        }
        
        if(listAccounts.size() > 0)
            update listAccounts;
        
     }
     
     global void finish(Database.BatchableContext BC)
     {
        
     }      
     public static testmethod void testEnableAsPartner()
     {
         string accountid = GenericStaticTestData.gettestChannelAccountRecord1().id;
         test.startTest();
         string query = 'select Id from account where id ='+ '\'' + accountid + '\'';
         system.debug(query );
         P360_AccountEnableAsPartner p = new P360_AccountEnableAsPartner(query);           
         Database.executeBatch(p);        
         test.stopTest();
        
     }

}