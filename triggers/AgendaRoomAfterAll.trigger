/***************************************************************************************************
Name    : AgendaRoomAfterAll 
Author  : Eric Pesch
Purpose : Trigger for Post-Agenda Room work
Created Date: Dec 1 2014
Modification History: 
Eric Pesch - Jan 5 2015: Added Comments, cleanup      
CEE2 June 2015 - Added Insert/Update/Delete event logic               
*****************************************************************************************************/

trigger AgendaRoomAfterAll on Agenda_Room__c (after delete, after insert, after undelete, after update) {
    private final String TAG = 'AgendaRoomAfterAll - ';
    List<Agenda_Room__c> resources = Trigger.new;
    List<Agenda_Room__c> resourcesOld = Trigger.old;
    Map<String, CEE_Invite__c> oldInviteMap = new Map<String, CEE_Invite__c>();
    
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
                resource.addError('Error - could not retrieve the CEE Invite for the Room attached to the Briefing');
            }
        }
    }
    
    if(Trigger.isUpdate || Trigger.isDelete || Trigger.isInsert){
       if(!ceeRoomUpdate.runonce){
            ceeRoomUpdate.RoomUpdate(resources,resourcesOld);
        }
    }
    
    //Insert CEE Invitation for insert or undelete
    if(Trigger.isInsert || Trigger.isUndelete){
        List<CEE_Invite__c> newRoomInvites = new List<CEE_Invite__c>();
        
        //Create new default Invites
        for(Agenda_Room__c resource : resources){
            CEE_Invite__c newInvite = new CEE_Invite__c();
            newInvite.Room__c = resource.Id;
            newInvite.Outlook_Status__c = 'Not Invited';
            newInvite.Start_Date_Time__c = resource.Start_Date_Time__c;
            newInvite.End_Date_Time__c = resource.End_Date_Time__c;
            newInvite.Outlook_Invite_ID__c = 'null';
            
            newRoomInvites.add(newInvite);
        }
        
        //Insert new invites
        try{
            insert newRoomInvites;
        } catch(Exception e){
            System.debug(e.getStackTraceSTring());
            for(Agenda_Room__c resource : resources){
                resource.addError(e.getMessage());
            }
        }
    }
    //Update CEE Invitation details if update
    else if (Trigger.isUpdate){
        List<CEE_Invite__c> updateInvites = new List<CEE_Invite__c>();
        
        for(Agenda_Room__c resource : resources){
            CEE_Invite__c oldInvite = oldInviteMap.get(resource.Id);
            if(oldInvite != null && oldInvite.Outlook_Invite_ID__c.length() < 10){
                oldInvite.Start_Date_Time__c = resource.Start_Date_Time__c;
                oldInvite.End_Date_Time__c = resource.End_Date_Time__c;
                
                updateInvites.add(oldInvite);
            }
        }
        
        try{
            update updateInvites;
        } catch (Exception e){
            System.debug(TAG + 'updating CEE Invites - ' + e.getStackTraceString());
        }
    }
    //Delete CEE Invitation for delete
    else {
        List<CEE_Invite__c> delInvites = oldInviteMap.values();
        
        try{
            delete delInvites;
        } catch (Exception e){
            System.debug(TAG + 'deleting CEE Invites - ' + e.getStackTraceString());
        }
    }
}