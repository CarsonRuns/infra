public class Add_Resource_As_OptyTeam {

    // SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdateGet(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }
     // SCAVA Helper Method to validate Create Access at field level
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }
//Class for adding resource as opty team
@FUTURE 
PUBLIC static void Add_Opty_team(ID[] ResourceId)
{

datetime startTime = datetime.now();
system.debug('starttime is '+startTime);

OpportunityTeamMember[] opptyTeamToUpdate = new OpportunityTeamMember[]{};
OpportunityShare[] OpptyShare = new OpportunityShare[]{}; 
Opportunity[] opptyToUpdate = new Opportunity[]{}; 
Resource_Request_Assignment__c[] se_resource=[Select Id,Opportunity_Name__c, Resource_Name__c from Resource_Request_Assignment__c
where id IN :ResourceId and Resource_Name__r.isactive =true ];

IF(se_resource.size() > 0)
{
// system.debug('opp size is '+Opp.size());

FOR (Integer l = 0; l < se_resource.size(); l++)
{

  OpportunityTeamMember otm = new opportunityTeamMember();
   if(flsUpdateGet(OpportunityTeamMember.OpportunityId)||flsGet(OpportunityTeamMember.OpportunityId)) //SCAVA FIX
   {
   otm.OpportunityId=se_resource[l].Opportunity_Name__c;
   }
   if(flsUpdateGet(OpportunityTeamMember.UserId)||flsGet(OpportunityTeamMember.UserId)) //SCAVA FIX
   {
   otm.UserId=se_resource[l].Resource_Name__c;
   }
   if(flsUpdateGet(OpportunityTeamMember.TeamMemberRole)||flsGet(OpportunityTeamMember.TeamMemberRole)) //SCAVA FIX
   {
   otm.TeamMemberRole='Systems Engineer';
   }

opptyTeamToUpdate.add(otm);

   OpportunityShare os = new OpportunityShare();
 if(flsUpdateGet(OpportunityShare.OpportunityId)||flsGet(OpportunityShare.OpportunityId)) //SCAVA FIX
   {
       os.OpportunityId=se_resource[l].Opportunity_Name__c;
   }
   if(flsUpdateGet(OpportunityShare.UserOrGroupId)||flsGet(OpportunityShare.UserOrGroupId)) //SCAVA FIX
   {
     os.UserOrGroupId=se_resource[l].Resource_Name__c; 
   }
   if(flsUpdateGet(OpportunityShare.OpportunityAccessLevel)||flsGet(OpportunityShare.OpportunityAccessLevel)) //SCAVA FIX
   {
       os.OpportunityAccessLevel='Edit';
   }
   opptyShare.add(os);

Opportunity o = new Opportunity (Id = se_resource[l].Opportunity_Name__c,
    SE_Assigned__c= true);
opptyToUpdate.add(o);
}

Utilities.setSkip(true);
Utilities.setValidationSkip(true);
Utilities.setSkipFuture(true);

update opptyToUpdate;
insert opptyShare;
insert opptyTeamToUpdate;

}
}


}