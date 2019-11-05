trigger addQuoteSummary on Quote__c (after insert) {

    Quote_Summary__c[] qs = new Quote_Summary__c[]{};
    Quote__c[] quotes = new Quote__c[]{};

     for(Quote__c q  : System.Trigger.new) {
         Quote_Summary__c tempQS = new Quote_Summary__c(Name='Quote Summary', Partner_Quote__c=q.Id);
         qs.add(tempQS);
     }
     
    insert qs;

}