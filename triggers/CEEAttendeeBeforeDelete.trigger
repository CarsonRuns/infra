/***************************************************************************************************
Name    : CEEAttendeeBeforeDelete 
Author  : Eric Pesch
Purpose : Trigger for the CEE Attendee pre-work  
Created Date: Dec 1 2014
Modification History: 
Eric Pesch - Jan 5 2015: Added Comments, cleanup                     
*****************************************************************************************************/

trigger CEEAttendeeBeforeDelete on CEE_Attendee__c (before delete) {
    
    private final String TAG = 'CEEAttendeeBeforeDelete - ';
    CEE_Attendee__c[] resources = Trigger.old;
    
    List<CEE_Attendee__c> inviteResources = new List<CEE_Attendee__c>();
    List<CEE_Invite__c> oldInvites = null;
    List<CEE_Invite__c> delInvites = new List<CEE_Invite__c>();
    
    //Grab related attendees w/Agenda Items
    for(CEE_Attendee__c resource : resources){
        if(resource.Agenda_Item__c != null){
            inviteResources.add(resource);
        } 
    }
    
    //Grab invitations
    if(inviteResources.size() > 0){
        try{
            oldInvites = [select Id, Outlook_Invite_ID__c, CEE_Attendee__c from CEE_Invite__c where CEE_Attendee__c in : inviteResources ];
            
            //Check to see if active invites are out in outlook
            for(CEE_Invite__c oldInvite : oldInvites){
                for(Integer i = 0; i < inviteResources.size(); i++){
                    if(oldInvite.CEE_Attendee__c == inviteResources[i].Id){
                        if(oldInvite.Outlook_Invite_ID__c != null && oldInvite.Outlook_Invite_ID__c.length() > 10){
                            inviteResources[i].addError('Error - the CEE Attendee being deleted has an active Outlook Invitation - please cancel that invitation before removing this Attendee');
                        } else {
                            delInvites.add(oldInvite);
                            inviteResources.remove(i);
                        }
                    }
                }
            }
        } catch (Exception e){
            System.debug(TAG + 'Error in retrieving oldInvites, exiting');
            for(CEE_Attendee__c resource : inviteResources){
                resource.addError('Error - the CEE Attendee attached to an Agenda Item does not have an CEE Invite - please create one before continuing');
            }
        }
    }
    
    //Delete old invitations if related object removed
    try{
        delete delInvites;
    } catch (Exception e){
        System.debug(TAG + e.getStackTraceString());
    }
}