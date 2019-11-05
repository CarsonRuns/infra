trigger TPOwnerChangeMultiQuoteShareUpdate on Assigned_Partner__c (after update) {
    
    Map<id, Map<id, id>> tpOldNewOwnerMap = new Map<id, Map<id, id>>();
    
    //identify which leads have new owners and map new and old owner with the tp id
    for(Assigned_Partner__c theTP: trigger.new){
        Assigned_Partner__c theOldTP = trigger.oldMap.get(theTP.id);
        Assigned_Partner__c theNewTP = trigger.newMap.get(theTP.id);
        
        //System.debug('theTP:' + theTP);
        //System.debug('theOldTP.owner:' + theOldTP.OwnerId);
        //System.debug('theNewTP.owner:' + theNewTP.OwnerId);
        
        if(theOldTP.OwnerId != theNewTP.OwnerId)
        {
            Map<id, id> oldNewOwner = new Map<id, id>();
            oldNewOwner.put(theOldTP.OwnerId, theNewTP.OwnerId);
            tpOldNewOwnerMap.put(theTP.id, oldNewOwner);
            //update the share for these leads
        }
    }
 
    //system.debug('tpOldNewOwnerMap.keyset()'+tpOldNewOwnerMap.keyset());
    
    //identify the affected Multiquotes and map them to the changed lead
    List<Multi_Object_quote__c> affected_MQ = [Select id, Target_Prospect__c from Multi_Object_Quote__c where Target_Prospect__c in :tpOldNewOwnerMap.keyset()];
    Map<id, id> mq_to_tp = new Map<id, id>();
    for(Multi_Object_quote__c mq: affected_MQ){
        mq_to_tp.put(mq.id, mq.Target_Prospect__c);
    }
    
    //get the list of shares to delete, if one of the updated share records has TP id and old owner in the above map
    List<Multi_Object_Quote__Share> removeShares = new List<Multi_Object_Quote__Share>();
    
    //system.debug('affected_MQ'+affected_MQ);
    for(Multi_Object_Quote__Share share : [select id, parentid, UserOrGroupId from Multi_Object_Quote__Share where parentid in :affected_MQ]){
        if(tpOldNewOwnerMap.get(mq_to_tp.get(share.parentid)).keyset().contains(share.UserOrGroupId)){
            removeShares.add(share);
        }
    }
try{    
    delete removeShares;
}    
catch(Exception ex)
{
   //throw ex;
}
    
    //create new share records with lead id and new owner from the above list.
    List<Multi_Object_Quote__Share> addShares = new List<Multi_Object_Quote__Share>();
    for(ID mqID : mq_to_tp.keyset()){
        for(ID newownerID : tpOldNewOwnerMap.get(mq_to_tp.get(mqID)).values()){
            Multi_Object_Quote__Share newShare = new Multi_Object_Quote__Share();
            newshare.ParentId = mqID;
            newshare.AccessLevel = 'Read';
            newshare.UserOrGroupId = newownerID;
            addShares.add(newshare);
        }
    }
try{    
    insert addShares;
    
}
catch(Exception ex)
{
   //throw ex;
}    }