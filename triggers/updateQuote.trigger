trigger updateQuote on Quote_Summary__c (after insert) {

    Quote__c[] quotes = new Quote__c[]{};
    
    for(Quote_Summary__c qs : System.Trigger.new) {
        if(qs.Partner_Quote__c != null) {
            Quote__c qTemp = new Quote__c(Id=qs.Partner_Quote__c, Quote_Summary__c=qs.Id);
            quotes.add(qTemp);
        }
    }
    
    if(quotes.size()>0)
        update quotes;

}