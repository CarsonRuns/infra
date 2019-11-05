trigger OpptyOwnerPostnChk on Opportunity (before insert, before update) {
    Opportunity[] opptys = Trigger.new; 
    Set<Id> OpptyOwner = new Set<Id>{}; 
    Set<id> epsUserwithPostion = new Set<id>{}; 
    Set<Id> UsersWithPositions = new Set<Id>{};     
    Set<Id> NonAMOwners = new Set<Id>{};  
    Set<id> ownerAMIDs = new set<id>();
    
    ProfileID__c profileIds = ProfileID__c.getInstance();
    

    for (Opportunity o : opptys){ /*get all new owners*/
        if(o.OwnerId != null){
            OpptyOwner.add(o.OwnerId);
             ownerAMIDs.add(o.Opportunity_Owner_AM__c);
        }   
    }
    // saduvvur modified on 8/13/2015
    // merged multiple soql queris using maps to fix test class issues
    //Map of default forecast position based on Opportunity AM
    Map<id,user> myMap = new Map<id,User>([select Default_Position__c,Position_1__c, Profile.Name, Additional_User_Permissions__c , Id from user where id in : OpptyOwner]);
    Map<id,user> myMapAM = new Map<id,User>([select Default_Position__c,Position_1__c, Profile.Name, Additional_User_Permissions__c , Id from user where id in : ownerAMIDs]);    
   
    for(User u : myMap.values() ){
        if(u.Position_1__c != null){
            UsersWithPositions.add(u.Id);
        }        
        if(u.Additional_User_Permissions__c <> null  && (u.Additional_User_Permissions__c.replace('Enable_ePSS','') != u.Additional_User_Permissions__c || u.Profile.Name == 'Cisco_PSS')){
            epsUserwithPostion.add(u.id);
           
        }else if(u.Additional_User_Permissions__c <> null  && u.Additional_User_Permissions__c.replace('Enable_ePSS','') != u.Additional_User_Permissions__c){
            NonAMOwners.add(u.Id);
        }
    }
    
    
    String recordTypeIds = Utilities.OpptyOwnerPostnChkRecordTypes();
    for (Opportunity o : opptys){
        if(!Trigger.isInsert && (o.OwnerId != Trigger.oldmap.get(o.Id).OwnerId) ){  /*if update & new owner*/  
            String ownerProfileId = myMap.get(o.OwnerId).profileId;
            if( (recordTypeIds.contains(o.RecordTypeId) && !UsersWithPositions.contains(o.OwnerId)) || NonAMOwners.contains(o.OwnerId)
                ){/*if parent type and no postn*/
                o.OwnerId.addError(Label.Opportunity_Owner_Change_Error);
            } else {
            }
        } 
        else if (!Utilities.skipUser() && o.Position__c == null && UsersWithPositions.contains(o.OwnerId)){   
            if (recordTypeIds.contains(o.RecordTypeId) ){                 
                if(Trigger.isInsert)
                {
                    if(myMap.get(o.ownerId).Position_1__c != null && myMap.get(o.ownerId).Position_1__c!='')
                    {
                        string[] strPostion = myMap.get(o.ownerId).Position_1__c.split('\n');
                        if(strPostion.size() == 1){
                            o.Position__c = myMap.get(o.ownerId).Position_1__c.split('\n')[0].trim();
                        }
                    }
                    else
                    {
                        System.debug('Unable to Determine Forecast Position for userid->' + o.ownerId);
                    }                        
                }  
            }                           
        }
        else if(!Utilities.skipUser() && o.Position__c == null && epsUserwithPostion.contains(o.ownerId)){     
            if(!(myMapAM.isEmpty()) && myMapAM.get(o.Opportunity_Owner_AM__c).Position_1__c != null && myMapAM.get(o.Opportunity_Owner_AM__c).Position_1__c!='')
            {
                string[] strPostion = myMapAM.get(o.Opportunity_Owner_AM__c).Position_1__c.split('\n');               
                if(strPostion.size() == 1){                 
                    o.Position__c = myMapAM.get(o.Opportunity_Owner_AM__c).Position_1__c.split('\n')[0].trim();
                }           
            }
            else
            {
                System.debug('Unable to Determine Forecast Position for userid->' + o.Opportunity_Owner_AM__c);
            }   
        }
    }
}