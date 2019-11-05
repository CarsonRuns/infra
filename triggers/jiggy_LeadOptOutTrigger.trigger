trigger jiggy_LeadOptOutTrigger on Lead (before insert) {
    if(trigger.isBefore && trigger.isInsert) {
        for(Lead l : trigger.new) {
         /* if(l.jigsaw_clean__Jigsaw_Id__c != null && l.jigsaw_clean__Sync_Status__c.equals('I')) {
            throw new jiggy_CustomException('<p> Import Failed </p> <p>Import Failed! Please go back to Salesforce.com Account page</p>');
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Please do not remove/change Account Name within search page.');
          }*/
        }
    }
}