trigger OpptyLineRenewalTCV on OpportunityLineItem (before insert, before update) {
    List<OpportunityLineItem> newArray = new List<OpportunityLineItem>();
    List<Id> opptyIds = new List<Id>();
    Map<Id, Opportunity> opptyMap = new Map<Id, Opportunity>();
    if(Trigger.isUpdate){
        for(OpportunityLineItem oli: Trigger.new){
            if(oli.Expected_TCV_000s__c!=Trigger.oldMap.get(oli.id).Expected_TCV_000s__c)
                newArray.add(oli);
        }
    }
    else{
        newArray = Trigger.new;
    }
    System.debug('**newArray**'+newArray.size());
    
    for(OpportunityLineItem oli: newArray){
        if((Id)oli.Opportunity_RecordTypeId__c==(Id)Utilities.getOpptyRenewalRecordTypeId()){
               oli.TotalPrice=oli.Expected_TCV_000s__c;
               oli.Opportunity_Line_Value__c=oli.Expected_TCV_000s__c;
               System.debug('**Opp Line Value**'+oli.Opportunity_Line_Value__c);
           }
    }
}