//*********** Change History ****************************
// 12/09: Removed the code to update Opportunity Theater
//*******************************************************

trigger OpptyFutureUpdate on Opportunity (after Update) {
    
    if ( !Utilities.getskipFuture() ){
        ID[] newOpptyNames = new ID[]{};
        ID[] statusOpptys = new ID[]{};
        ID[] allSyncOptyIds = new ID[]{};
    
        for(Opportunity o : System.Trigger.new) {
            
            // if an update trigger, then add to the sync to workspace list.
            if(trigger.isUpdate) {
                if(trigger.isUpdate && o.Name != System.Trigger.oldMap.get(o.Id).Name){
                    newOpptyNames.add(o.Id);
                }
                if(trigger.isUpdate && o.Opportunity_Status__c != System.Trigger.oldMap.get(o.Id).Opportunity_Status__c){
                    statusOpptys.add(o.Id);
                } 
                // Update workspace only if Opportunity fields have changed             
                if(o.Forecast_Status__c != trigger.oldMap.get(o.Id).Forecast_Status__c ||
                    o.CloseDate != trigger.oldMap.get(o.Id).CloseDate ||
                    o.Expected_Product__c != trigger.oldMap.get(o.Id).Expected_Product__c ||
                    o.Expected_Service__c != trigger.oldMap.get(o.Id).Expected_Service__c ||        
                    o.Opportunity_Status__c != trigger.oldMap.get(o.Id).Opportunity_Status__c)
                    {
                        allSyncOptyIds.add(o.Id); 
                    }                   
            }    
        }
        if( newOpptyNames.size() > 0 || statusOpptys.size() > 0)
            OpptyFutureClass.updateOpptys(newOpptyNames, statusOpptys);
            
        // sync all the opty workspaces with the oppty
        if(allSyncOptyIds.size() > 0)       
            OpptyFutureClass.syncWorkspaceWithOpty(allSyncOptyIds);        
        
    
  }
}