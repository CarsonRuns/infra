trigger MulitTechUpdates on Workspace_Technology__c (after insert, after update, before delete) {
System.debug('*** MULTI UPDATE RUNNING');
    //Get ids of the children that were inserted, updated, or deleted 
    Set<Id> wtIds = trigger.isDelete ? trigger.oldMap.keySet() : trigger.newMap.keySet();
    
    //Get the parent records of affected child records from above
    List<AT_Workspace__c> workspaces = [
            SELECT Id, AT_Expected_Product__c, AT_Expected_Service__c, 
                (SELECT Id, BE_Type__c, Expected_000__c FROM Workspace_Technologies__r) 
            FROM AT_Workspace__c
            WHERE Id IN (SELECT workspace__c FROM Workspace_Technology__c WHERE Id IN :wtIds)
            and LastModifiedDate = LAST_90_DAYS
        ];
       
    //Set to clear validation rule 
    for (AT_Workspace__c w : workspaces) {
        w.Validate_Product_Service_Update__c = false;
    }
   
    upsert workspaces;
 
    //For all of the parent records with new/updated/deleted children, calculate the sum of the dollar amount on each child
    for (AT_Workspace__c w : workspaces) {
    
        w.AT_Expected_Product__c = 0.0;
        w.AT_Expected_Service__c = 0.0;
    
        //Based on whether the child affects the product or service dollar amount, add it to the sum as long as it still exists and was not deleted
        for(Workspace_Technology__c wt : w.Workspace_Technologies__r) {
            if(!trigger.isDelete || !wtIds.contains(wt.Id)) {
                if(wt.BE_Type__c == 'Product')
                    w.AT_Expected_Product__c += wt.Expected_000__c;
                if(wt.BE_Type__c == 'Service')
                    w.AT_Expected_Service__c += wt.Expected_000__c;
            }
        }        
    }   
   
    upsert workspaces;
    
    //Set to unclear validation rule 
    for (AT_Workspace__c w : workspaces) {
        w.Validate_Product_Service_Update__c = true;
    }
    
    upsert workspaces;
    
}