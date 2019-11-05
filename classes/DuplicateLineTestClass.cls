@isTest 
private class DuplicateLineTestClass {

    private static testMethod void testBatch() {
    
        Test.StartTest();
        
        Opportunity[] opptys = [Select Id from Opportunity limit 10];
        List<DuplicateLine__c> dls = new List<DuplicateLine__c>{};
        set<id> seId= new set<id>();
        Map<id,string[]> mapOp = new Map<id,string[]>();
        String input = 'value;One value;Two value;Three';
        String[] splitInput = input.split(' ');
        for (Opportunity o : opptys){
            DuplicateLine__c dl = new DuplicateLine__c(Status__c='ToUpdate',OpptyEx__c=o.Id);
            dls.add(dl);
            seId.add(o.id);         
            mapOp.put(o.id,splitInput);
        }
        upsert dls opptyEx__c;
        
        duplicateLineBatch recalculate = new duplicateLineBatch();
        recalculate.query='SELECT OpptyEx__c from DuplicateLine__c where Status__c = \'ToUpdate\' LIMIT 200';
        recalculate.email='dameyer@cisco.com';
        Database.BatchableContext BC;
        List<DuplicateLine__c> scope = new List<DuplicateLine__c>([SELECT OpptyEx__c from DuplicateLine__c where Status__c = 'ToUpdate' limit 200]);
        
        recalculate.start(BC);
        //recalculate.execute(BC, scope);
        //recalculate.finish(BC);
        recalculate.getLineDetails(seId);
        recalculate.updateOptys(mapOp);
        Test.StopTest();
    
    }
    
    private static testMethod void testTrigger() {
    
        Test.StartTest();
        
        OpportunityLineItem tmpLi = [Select OpportunityId,Mix__c,PricebookEntryId from OpportunityLineItem where isdeleted = false and PriceBookEntryId <> null and PriceBookEntry.IsActive= true limit 1 ];
        OpportunityLineItem newLi = new OpportunityLineItem(TotalPrice=0,OpportunityId=tmpLi.OpportunityId,Mix__c=50,Quantity=1,PricebookEntryId=tmpLi.PricebookEntryId);

        delete tmpLi;
        insert newLi;
        newLi.Mix__c = 10;
        update newLi;
        
        Test.StopTest();
    
    }
    private static testMethod void testInvokeUpdateTriggerBatch() {
    
        Test.StartTest();
        List<Account> scope = new List<Account>([SELECT id,name from account limit 1 ]);
        Database.BatchableContext BC;
        InvokeUpdateTriggerBatch  intb = new InvokeUpdateTriggerBatch ();
        //intb.start(BC);
        intb.execute(BC,scope);
        intb.finish(BC);          
        Test.StopTest();
    }   
    


}