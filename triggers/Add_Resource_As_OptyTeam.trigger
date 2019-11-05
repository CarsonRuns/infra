trigger Add_Resource_As_OptyTeam on Resource_Request_Assignment__c (after insert, after update) 
{
// This trigger is to add team member to opportunity freom resource request assignment object
IF ( !Utilities.getskipFuture() )
{   
    Resource_Request_Assignment__c[] Resource = Trigger.new;
    ID[] ResourceId = new ID[]{};
    
    FOR (Resource_Request_Assignment__c r: Resource )
    {
        IF ((Trigger.isUpdate && Trigger.oldmap.get(r.Id).Resource_Status__c!=Trigger.newmap.get(r.Id).Resource_Status__c && Trigger.newMap.get(r.Id).Resource_Status__c == 'Assigned' )
            ||( Trigger.isinsert&&(Trigger.newmap.get(r.Id).Resource_Name__c!=Null)) && Trigger.newMap.get(r.Id).Resource_Status__c == 'Direct Assignment' 
            )
        {
         ResourceId.add(r.ID);
        }
    }
    
    system.debug('resource.size'+ResourceId.size());
    IF (ResourceId.size() > 0)
    {      
       Add_Resource_As_OptyTeam.Add_Opty_team(ResourceId);
    }
}
}