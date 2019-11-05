/***************************************************************************************************
Name    : CEERoomBeforeUpsert 
Author  : Eric Pesch
Purpose : Trigger for inserting a CEE_Room__c object 
Created Date: Dec 1 2014
Modification History: 
Eric Pesch - Jan 5 2015: Added Comments, cleanup                     
*****************************************************************************************************/

trigger CEERoomBeforeUpsert on CEE_Room__c (before insert, before update) {
    private final String TAG = 'CEERoomBeforeUpsert - ';
    CEE_Room__c[] resources = Trigger.new;
    
    Map<String, String> locationMap = new Map<String, String>();
    Map<String, Map<String, String>> roomMap = new Map<String, Map<String, String>>();
    Set<String> locNames = new Set<String>();
    
    //Storage - query items
    List<CEE_Location__c> locations;
    List<CEE_Room__c> oldRooms;
    
    //Find rooms where we need to add locations
    for(CEE_Room__c resource : resources){
        if(resource.CEE_Location__c == null){
            if(resource.EBC_CBC_Location__c != null){
                locNames.add(resource.EBC_CBC_Location__c);
            } else if (resource.Building__c != null){
                locNames.add(resource.Building__c);
            }
        }
    }
    
    //Fetch room details
    try{
        locations = [select Id, Name from CEE_Location__c where Name in :locNames];
        oldRooms = [select Id, Name, Email_Code__c, CEE_Location__c from CEE_Room__c where CEE_Location__c in :locations];
    } catch (Exception e){
        for(CEE_Room__c resource : resources){
            resource.addError('Unable to fetch location details for the given Room');
        }
    }
    
    //Fill location map
    for(CEE_Location__c location : locations){
        locationMap.put(location.Name.trim().toUpperCase(), location.Id);
    }
    
    //Fill room map
    for(CEE_Room__c room : oldRooms){
        if(roomMap.get(room.CEE_Location__c) == null){
            //System.debug(TAG + 'Adding new location - ' + room.CEE_Location__c + ' - ' + room.Name);
            Map<String, String> newLocation = new Map<String, String>();
            newLocation.put(room.Email_Code__c.trim().toUpperCase(), room.Id);
            
            roomMap.put(room.CEE_Location__c, newLocation);
        } else {
            //System.debug(TAG + 'Adding old to old location' + room.CEE_Location__c + ' - ' + room.Name);
            Map<String, String> oldLocation = roomMap.get(room.CEE_Location__c);
            oldLocation.put(room.Email_Code__c.trim().toUpperCase(), room.Id);
            
            roomMap.put(room.CEE_Location__c, oldLocation);
        }
    }
    
    //Assign locations to rooms    
    //System.debug(TAG + 'Adding room information');
    for(CEE_Room__c resource : resources){
        if(resource.CEE_Location__c == null){
            if(resource.EBC_CBC_Location__c != null){
                resource.CEE_Location__c = locationMap.get(resource.EBC_CBC_Location__c.trim().toUpperCase());
            } else if (resource.Building__c != null){
                resource.CEE_Location__c = locationMap.get(resource.Building__c.trim().toUpperCase());
            }
            
            //Validate duplicate room in a given location
            if(resource.CEE_Location__c != null){
                if(roomMap.get(resource.CEE_Location__c)!= null && roomMap.get(resource.CEE_Location__c).get(resource.Email_Code__c.trim().toUpperCase()) != null){
                    System.debug(TAG + 'Error - room already added to location - ' + resource.CEE_Location__c);
                    resource.addError('Room already added as part of this Location');
                }
            }
        }
    }
}