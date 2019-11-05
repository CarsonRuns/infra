global class OpptyOwnerSyncBatchApex implements Database.Batchable<sObject> {
    
    // SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdate(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }

public string query;
public List<Opportunity> OpptysToUpdate ;

String NotificationEmailId = Apex_Batch_Job__c.getInstance('OpptyOwnerSync').NotificationEmailId__c;

global OpptyOwnerSyncBatchApex(String q)
{
        query = q; 
        
}

global Database.QueryLocator start(Database.BatchableContext BC)
{
        System.debug('Query == '+query);
        return Database.getQueryLocator(query);
}
  
global void execute(Database.BatchableContext BC, List<Opportunity> scope)
{    
        System.debug('Scope:'+scope.size());
        OpptysToUpdate = new List<Opportunity>();

        for(Opportunity o : scope)
        { 
            Opportunity op = new opportunity(id= o.Id,Opportunity_Owner_AM__c=o.Opportunity_Owner_AM__c,OwnerId = o.OwnerId);

            if(op.Opportunity_Owner_AM__c != op.OwnerId)
            {
                //SCAVA FIX
               if(flsUpdate(Opportunity.Opportunity_Owner_AM__c))
                {
                op.Opportunity_Owner_AM__c = op.OwnerId ;
                }
                OpptysToUpdate.add(op);
            }
        }           
         utilities.setskipFuture(true);
         utilities.setValidationSkip(true);
         update OpptysToUpdate;
      
}
global void finish(Database.BatchableContext BC)
{
        system.debug('Job Finished at :' + system.now());
        sendEmail(BC.getJobId());
}


global void sendEmail(Id JobId)
{  
    
    AsyncApexJob aaj = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors
    FROM AsyncApexJob WHERE ID =: JobId ];
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    String[] toAddresses = new String[] {NotificationEmailId};
    mail.setToAddresses(toAddresses);
    mail.setSubject('Opportunity Owner Sync Job - '+ System.Today());
    String MailBody = 'Status : ' + aaj.Status + '<br/>';
    MailBody = MailBody + 'Total Batches : ' + aaj.TotalJobItems + '<br/>';
    MailBody = MailBody + 'Total Batches Procesed : ' + aaj.JobItemsProcessed + '<br/>';
    MailBody = MailBody + 'Failed Batches : ' + aaj.NumberOfErrors + '<br/>';
    mail.setHtmlBody(MailBody);
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
}


}