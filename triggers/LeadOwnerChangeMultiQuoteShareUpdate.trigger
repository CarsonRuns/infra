//Bramha - 05/02/2016 - Added null check for leadOldNewOwnerMap processing to fix the deployment error for SOQL limit exception
trigger LeadOwnerChangeMultiQuoteShareUpdate on Lead (after update) {
    
    Map<id, Map<id, id>> leadOldNewOwnerMap = new Map<id, Map<id, id>>();
    
    //identify which leads have new owners and map new and old owner with the lead id
    for(Lead theLead: trigger.new){
        Lead theOldLead = trigger.oldMap.get(theLead.id);
        Lead theNewLead = trigger.newMap.get(theLead.id);
        
        
        //System.debug('theTP:' + theTP);
        //System.debug('theOldTP.owner:' + theOldTP.OwnerId);
        //System.debug('theNewTP.owner:' + theNewTP.OwnerId);
        
        if(theOldLead.OwnerId != theNewLead.OwnerId)
        {
            Map<id, id> oldNewOwner = new Map<id, id>();
            oldNewOwner.put(theOldLead.OwnerId, theNewLead.OwnerId);
            leadOldNewOwnerMap.put(theLead.id, oldNewOwner);
            //update the share for these leads
        }
    }
 
    //system.debug('tpOldNewOwnerMap.keyset()'+tpOldNewOwnerMap.keyset());
    
    //identify the affected Multiquotes and map them to the changed lead
    Map<id, id> mq_to_lead = new Map<id, id>();
    if(!leadOldNewOwnerMap.isEmpty()){
        List<Multi_Object_quote__c> affected_MQ = [Select id, Lead__c from Multi_Object_Quote__c where Lead__c in :leadOldNewOwnerMap.keyset()];        
        for(Multi_Object_quote__c mq: affected_MQ){
            mq_to_lead.put(mq.id, mq.Lead__c);
        }
        
        //get the list of shares to delete, if one of the updated share records has TP id and old owner in the above map
        List<Multi_Object_Quote__Share> removeShares = new List<Multi_Object_Quote__Share>();
        
        //system.debug('affected_MQ'+affected_MQ);
        for(Multi_Object_Quote__Share share : [select id, parentid, UserOrGroupId from Multi_Object_Quote__Share where parentid in :affected_MQ]){
            if(leadOldNewOwnerMap.get(mq_to_lead.get(share.parentid)).keyset().contains(share.UserOrGroupId)){
                removeShares.add(share);
            }
        }
        delete removeShares;
    }
    
    //create new share records with lead id and new owner from the above list.
    List<Multi_Object_Quote__Share> addShares = new List<Multi_Object_Quote__Share>();
    for(ID mqID : mq_to_lead.keyset()){
        for(ID newownerID : leadOldNewOwnerMap.get(mq_to_lead.get(mqID)).values()){
            Multi_Object_Quote__Share newShare = new Multi_Object_Quote__Share();
            newshare.ParentId = mqID;
            newshare.AccessLevel = 'Read';
            newshare.UserOrGroupId = newownerID;
            addShares.add(newshare);
        }
    }
    insert addShares;
    
}