global without sharing class P360_PartnerProgramEnrollmentUpdate implements Database.Batchable<sObject> {
    
    // SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdate(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }
    
// SCAVA Helper Method to validate Create Access at field level
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }
    
    private final string query;
    
    global P360_PartnerProgramEnrollmentUpdate(String query)
    {
        try
        {
            this.query = query;
        }
        Catch(Exception e)
        {
            Tx_Log__c tl = new Tx_Log__c();
            //SCAVA FIX
            if(flsGet(Tx_Log__c.exception__c))
            {
            tl.exception__c = true;
            }
            if(flsGet(Tx_Log__c.message__c))
            {
            tl.message__c = e.getMessage();
            }
            if(flsGet(Tx_Log__c.originated__c))
            {
            tl.originated__c = 'P360_PartnerProgramEnrollmentUpdate - Constructor';
            }
            if(flsGet(Tx_Log__c.type__c))
            {
            tl.type__c = 'P360_Account_Job';
            }
            insert tl;
        }
    }        
    global Database.QueryLocator start(Database.BatchableContext BC)
    {        
        try
        {
            return Database.getQueryLocator(query); 
        }
        Catch(Exception e)
        {
            Tx_Log__c tl = new Tx_Log__c();
            tl.exception__c = true;
            tl.message__c = e.getMessage();
            tl.originated__c = 'P360_PartnerProgramEnrollmentUpdate - Start';
            tl.type__c = 'P360_Account_Job';
            insert tl;
            return Database.getQueryLocator(query); 
        }       
    }    
    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {   
        try
        {
            List<Account> AccountsToUpdate = New List<Account>();
            Set<Id> AccountIds = new Set<Id>();
            for(Account a : (List<Account>)scope)
            {
                if(a.Partner_Assignment_Eligible__c == 1 && a.isPartner != true)
                {
                    a.IsPartner = True;
                    AccountsToUpdate.add(a);
                }
                AccountIds.add(a.Id);
                
            }
            
            if(AccountsToUpdate.size() > 0)
                update AccountsToUpdate;
            
            List<Contact> ContactsToUpdate = new List<Contact>();       
            for(contact c : [Select Id,Partner_Program_Enrollment_Updated_Date__c from contact where RecordTypeId = '01280000000G6tn' and Accountid IN :AccountIds])
            {
                //SCAVA FIX
                if(flsUpdate(contact.Partner_Program_Enrollment_Updated_Date__c))
                {
                c.Partner_Program_Enrollment_Updated_Date__c = System.Today()-1;
                }
                ContactsToUpdate.add(c);
            }   
            if(ContactsToUpdate.size() > 0)
                update ContactsToUpdate;    
        }
        Catch(Exception e)
        {
            Tx_Log__c tl = new Tx_Log__c();
            //SCAVA FIX
            if(flsGet(Tx_Log__c.exception__c))
            {
            tl.exception__c = true;
            }
            if(flsGet(Tx_Log__c.message__c))
            {
            tl.message__c = e.getMessage();
            }
            if(flsGet(Tx_Log__c.originated__c))
            {
            tl.originated__c = 'P360_PartnerProgramEnrollmentUpdate - Execute';
            }
            if(flsGet(Tx_Log__c.type__c))
            {
            tl.type__c = 'P360_Account_Job';
            }
            insert tl;
        }
            
        
    }
     
    global void finish(Database.BatchableContext BC)
    {
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id = :BC.getJobId()];
        Tx_Log__c tl = new Tx_Log__c();
        if(a.NumberOfErrors > 0)
        //SCAVA FIX
        if(flsGet(Tx_Log__c.exception__c))
        {
        tl.exception__c = true;
        }
        if(flsGet(Tx_Log__c.message__c))
        {
        tl.message__c = 'The batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.';
        }
        if(flsGet(Tx_Log__c.originated__c))
        {
        tl.originated__c = 'P360_PartnerProgramEnrollmentUpdate - Finish';
        }
        if(flsGet(Tx_Log__c.type__c))
        {
        tl.type__c = 'P360_Account_Job';
        }
        insert tl;
    }  
    
    
}