/***************************************************************************************************
Name    : AgendaRoomBeforeAll 
Author  : Eric Pesch
Purpose : Trigger on the Agenda Room object  
Created Date: Dec 1 2014
Modification History: 
Eric Pesch - Jan 5 2015: Added Comments, cleanup                     
*****************************************************************************************************/

trigger AgendaRoomBeforeAll on Agenda_Room__c (before delete, before insert, before update) {
    private final String TAG = 'AgendaRoomBeforeAll - ';
    
    //Resources 
    List<Agenda_Room__c> resources = Trigger.new;
    Map<Id, CEE_Room__c> resourceRooms = null;
    List<Agenda_Room__c> resourcesOld = Trigger.old;
    
    //Old related resources
    Map<String, List<Agenda_Room__c>> oldRoomMap = new Map<String, List<Agenda_Room__c>>();
    Map<String, Set<Id>> siteMap = new Map<String, Set<Id>>();
    Map<String, CEE_Invite__c> oldInviteMap = new Map<String, CEE_Invite__c>();
    
    //Retrive old rooms if insert or update
    if(Trigger.isInsert || Trigger.isUpdate){
        Set<Id> briefingIDs = new Set<Id>();
        Set<Id> roomIDs = new Set<Id>();
        
        //Add all unique briefing IDs to retrieve previous rooms
        for(Agenda_Room__c resource : resources){
            briefingIDs.add(resource.Customer_Engagements_Events__c);
            roomIDs.add(resource.Room__c);
        }   
        
        //Find all valid rooms
        try{
            List<Agenda_Room__c> oldRooms = [select Id, Room__c, Customer_Engagements_Events__c from Agenda_Room__c
                                            where Customer_Engagements_Events__c in : briefingIDs];
            for(Agenda_Room__c oldRoom : oldRooms){
                if(oldRoomMap.containsKey(oldRoom.Customer_Engagements_Events__c)){
                    oldRoomMap.get(oldRoom.Customer_Engagements_Events__c).add(oldRoom);
                } else {
                    oldRoomMap.put(oldRoom.Customer_Engagements_Events__c, new List<Agenda_Room__c>{oldRoom});
                }
            }
            
            resourceRooms = new Map<Id, CEE_Room__c>([Select Id, CEE_Location__c from CEE_Room__c where Id in : roomIDs]);
        } catch (Exception e){
            System.debug(TAG + 'Error in retrieving old Rooms, exiting');
            for(Agenda_Room__c resource : resources){
                resource.addError('Error - Could not retrieve previous Rooms from the Briefing');
            }
        }
        
        //Find all CEE Locations associated to Briefing
        try{
            List<Briefing_Site__c> addtSites = [select Id, Additional_Participant_Location__c, Customer_Engagements_Events__c from Briefing_Site__c
                                                where Customer_Engagements_Events__c in : briefingIDs];
            for(Briefing_Site__c addtSite : addtSites){
                if(siteMap.containsKey(addtSite.Customer_Engagements_Events__c)){
                    siteMap.get(addtSite.Customer_Engagements_Events__c).add(addtSite.Additional_Participant_Location__c);
                } else {
                    siteMap.put(addtSite.Customer_Engagements_Events__c, new Set<Id>{addtSite.Additional_Participant_Location__c});
                }
            }
            
            List<CEE__c> briefings = [select Id, Primary_FSO__c from CEE__c where Id in : briefingIDs];
            for(CEE__c briefing : briefings){
                if(siteMap.containsKey(briefing.Id)){
                    siteMap.get(briefing.Id).add(briefing.Primary_FSO__c);
                } else {
                    siteMap.put(briefing.Id, new Set<Id>{briefing.Primary_FSO__c});
                }
            }
        } catch (Exception e){
            System.debug(TAG + 'Error in retrieving associated Sites, exiting');
            for(Agenda_Room__c resource : resources){
                resource.addError('Error - Could not retrieve associated CEE Locations from the Briefing');
            }
        }
        
        //See if room is part of the CEE locations on the briefing
        for(Agenda_Room__c resource : resources){
            Boolean isValidSite = false;
            for(ID location : siteMap.get(resource.Customer_Engagements_Events__c)){
                if(resourceRooms.get(resource.Room__c).CEE_Location__c == location){
                    isValidSite = true;
                    break;
                }
            }
            
            if(!isValidSite){
                System.debug(TAG + 'Room not in given sites');
                resource.addError('Error - Room chosen is not part of the Sites on the Briefing');
            }
        }
    }
    
    //Retrive old invites if update or delete
    if(Trigger.isUpdate || Trigger.isDelete){
        try{
            List<CEE_Invite__c> oldInvites = [select Id, Outlook_Invite_ID__c, Room__c from CEE_Invite__c where Room__c in : resourcesOld ];
            
            if(oldInvites != null){
                for(CEE_Invite__c oldInvite : oldInvites){
                    oldInviteMap.put(oldInvite.Room__c, oldInvite);
                }
            }
        
        } catch (Exception e){
            System.debug(TAG + 'Error in retrieving oldInvites, exiting');
            for(Agenda_Room__c resource : resourcesOld){
                resource.addError('Error - Could not retrieve the CEE Invite for the Room attached to the Briefing');
            }
        }
    }
    
    //Check if we can delete old rooms
    //--Cannot delete with active outlook invite
    if(Trigger.isInsert){
        //Iterate through old rooms, find Exceptions
        for(Agenda_Room__c resource : resources){
            if(oldRoomMap.get(resource.Customer_Engagements_Events__c) != null){
                for(Agenda_Room__c oldRoom : oldRoomMap.get(resource.Customer_Engagements_Events__c)){
                    //Prevent room from being added if duplicate
                    if(oldRoom.Room__c == resource.Room__c){
                        resource.addError('Error - The Room chosen has already been added to this Briefing');
                        break;
                    }
                }
            }
        }
    } else if(Trigger.isUpdate){
        for(Agenda_Room__c resource : resources){
            if(resource.Room__c != Trigger.oldMap.get(resource.Id).Room__c){
                //Check if room value changing has old active Outlook invite
                if(oldInviteMap.get(resource.Id).Outlook_Invite_ID__c != null 
                        && oldInviteMap.get(resource.Id).Outlook_Invite_ID__c.length() > 10){
                    resource.addError('Error - The Room being deleted has an active Outlook Invitation - please cancel that invitation before changing the Room');          
                }
            }
        }
    } else {
        //Check if they have active Outlook invitation
        for(Agenda_Room__c resource : resourcesOld){
            if(oldInviteMap.get(resource.Id) != null
                    && oldInviteMap.get(resource.Id).Outlook_Invite_ID__c != null 
                    && oldInviteMap.get(resource.Id).Outlook_Invite_ID__c.length() > 10){
                resource.addError('Error - The Room being deleted has an active Outlook Invitation - please cancel that invitation before changing the Room');          
            } 
        }
    } 
}