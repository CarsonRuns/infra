trigger OpptyLineItemDuplicateLine on OpportunityLineItem (after delete, after insert, after update) {
//This trigger is to update merge field of technolofy and service for reporting
    Set<Id> dlis = new Set<Id>(); 
    Decimal oldMix;
    Utilities.setValidationSkip(true);
    if (Trigger.isInsert || Trigger.isUpdate){
        for (OpportunityLineItem oli: Trigger.new){
            try{
                oldMix = Trigger.oldMap.get(oli.Id).Mix__c;
            }
            catch (exception e){
                System.debug(e);
                oldMix = 19671128;
            }
            if ( Trigger.isInsert || ( Trigger.isUpdate && oli.Mix__c != oldMix )  ){
                dlis.add(oli.OpportunityId);
            }
        }
    }
    else{ //delete
        for (OpportunityLineItem oli: Trigger.old){
            dlis.add(oli.OpportunityId);                    
        }
    }
    DuplicateLine.processIds(dlis);   
}