/**************************************
Author          : 
Release         : 
Created         : 
Functionality   : 

Modification History:
Itrack#        Date        		Author              		Change  
****************************************************************************
US290188    April 09,2019      Hari Krishna(ratharik)    Update SE Status on Opportunity on Update, Delete
US304314	June 19,2019	   Manikant Kella(mkella)	 Update SE IDs on oppty on update, delete
**********************************************/

trigger Update_Opty_Engagement_type on Resource_Request_Assignment__c (After insert, After update, After Delete) {
    
    Set<Id> optyIdsSetToUpdateStatus = new Set<Id>();
    
    //mkella- Start changes
    //for storing set ids to pass to apex controller
    Set<Id> optyIdsSetToUpdateSEIDs = new Set<Id>();
    //mkella- End changes
    
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        //This trigger is to update engagement type in opportunity    
        if(!Utilities.getskipFuture()) {
            Resource_Request_Assignment__c[] resources = Trigger.new;
            id[] optyids = new id[]{};
            
            for(Resource_Request_Assignment__c r: resources ) {
                if ((Trigger.isUpdate && Trigger.oldmap.get(r.Id).Assignment_Type__c!=Trigger.newmap.get(r.Id).Assignment_Type__c )
                    ||Trigger.isinsert ) {
                        optyids.add(r.Opportunity_Name__c);                
                    }
                
                //conditions to update SE Status
                if((Trigger.isUpdate && Trigger.oldmap.get(r.Id).Resource_Status__c != Trigger.newmap.get(r.Id).Resource_Status__c 
                    && (Trigger.newMap.get(r.Id).Resource_Status__c == 'Assigned' || Trigger.newMap.get(r.Id).Resource_Status__c == 'Direct Assignment'))
                   || (Trigger.isinsert && (Trigger.newMap.get(r.Id).Resource_Status__c == 'Assigned' 
                                            || Trigger.newMap.get(r.Id).Resource_Status__c == 'Direct Assignment')
                      )) {
                          optyIdsSetToUpdateStatus.add(r.Opportunity_Name__c);
                      }
                //mkella- US304314 Start changes 
                //      check if it is update and resource status are changed and if insert- check for Assigned and Direct status
                //      and send only those records
                if((Trigger.isUpdate && Trigger.oldmap.get(r.Id).Resource_Status__c != Trigger.newmap.get(r.Id).Resource_Status__c)
                   || (Trigger.isinsert && (Trigger.newMap.get(r.Id).Resource_Status__c == 'Assigned' 
                                            || Trigger.newMap.get(r.Id).Resource_Status__c == 'Direct Assignment')
                      )) {
                          optyIdsSetToUpdateSEIDs.add(r.Opportunity_Name__c);
                      }
                //mkella- End changes
            }
            
            if(!optyids.isEmpty() && optyids.size()> 0) {
                Update_Opty_Engagement_type.upd_opty(optyids);
            }
            
            if(!optyIdsSetToUpdateStatus.isEmpty()) {
                //call lxOpptyUpdateOnResourceAssignment to update SE Status on Oppty
                lxOpptyUpdateOnResourceAssignment.opportunityStatusUpdate(optyIdsSetToUpdateStatus);            
            }
            
            //mkella- US304314 Start changes
            //System.debug('SE IDs List values: '+optyIdsSetToUpdateSEIDs.size());
            //call method to update SE IDs on opptys
            if(!optyIdsSetToUpdateSEIDs.isEmpty()) {
                //System.debug('I should be called');
                lxOpptyUpdateOnResourceAssignment.opportunitySEIDsUpdate(optyIdsSetToUpdateSEIDs);            
            }
            //mkella- End changes
        }        
    }
    
    //On Delete 
    if(Trigger.isAfter &&  Trigger.isDelete) {
        for(Resource_Request_Assignment__c r: Trigger.Old) {                                                               
            optyIdsSetToUpdateStatus.add(r.Opportunity_Name__c);
            //mkella- US304314 Start changes
			optyIdsSetToUpdateSEIDs.add(r.Opportunity_Name__c);
			//mkella- End changes            
        }
        
        if(!optyIdsSetToUpdateStatus.isEmpty()) {
                //call lxOpptyUpdateOnResourceAssignment to update SE Status on Oppty
                lxOpptyUpdateOnResourceAssignment.opportunityStatusUpdate(optyIdsSetToUpdateStatus);            
            }
        //mkella- Start US304314 changes
            if(!optyIdsSetToUpdateStatus.isEmpty()) {
                //call lxOpptyUpdateOnResourceAssignment to update SE IDs on Oppty
                lxOpptyUpdateOnResourceAssignment.opportunitySEIDsUpdate(optyIdsSetToUpdateSEIDs);            
            }
            //mkella- End changes
    }    
}