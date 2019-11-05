/*************************************************************************************************************************************

Change History: 
- 9/16 - Removed the Opportunity Team Member role hardcoding and replaced with Custom setting.

*************************************************************************************************************************************/


public class TSN_Add_CaseOwner_As_OptyTeam 
{

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
    //class for adding case owner as opty team 
    public static void TSN_Add_Opty_team(ID[] CaseId)
    {
        OpportunityTeamMember[] opptyTeamToUpdate = new OpportunityTeamMember[]{};
        OpportunityShare[] OpptyShare = new OpportunityShare[]{}; 
        Case[] c =[Select Id,Opportunity__c, OwnerId from Case where id IN :CaseId];  

        
        String salesTeamRole = Utilities.getConstant_CS('SalesTeamRole_Case');
        if(c.size() > 0)
        {
            for (Integer i = 0; i < c.size(); i++)
            {
            
                OpportunityTeamMember otm = new opportunityTeamMember();
            if(flsUpdateGet(OpportunityTeamMember.OpportunityId)||flsGet(OpportunityTeamMember.OpportunityId)) //SCAVA FIX
            {
                otm.OpportunityId=c[i].Opportunity__c;
            }
            if(flsUpdateGet(OpportunityTeamMember.UserId)||flsGet(OpportunityTeamMember.UserId)) //SCAVA FIX
            {
                otm.UserId=c[i].OwnerId;
            }
            if(flsUpdateGet(OpportunityTeamMember.TeamMemberRole)||flsGet(OpportunityTeamMember.TeamMemberRole)) //SCAVA FIX
            {
                otm.TeamMemberRole=salesTeamRole;
            }
                opptyTeamToUpdate.add(otm);
                OpportunityShare os = new OpportunityShare();
            if(flsUpdateGet(OpportunityShare.OpportunityId)||flsGet(OpportunityShare.OpportunityId)) //SCAVA FIX
            {   
                os.OpportunityId=c[i].Opportunity__c;
            }
             if(flsUpdateGet(OpportunityShare.UserOrGroupId)||flsGet(OpportunityShare.UserOrGroupId)) //SCAVA FIX
            {
                os.UserOrGroupId=c[i].OwnerId;
            }
            if(flsUpdateGet(OpportunityShare.OpportunityAccessLevel)||flsGet(OpportunityShare.OpportunityAccessLevel)) //SCAVA FIX
            {
                os.OpportunityAccessLevel='Edit';
            }
                
                opptyShare.add(os);
            
            }
            Utilities.setValidationSkip(true);
            try{
                insert opptyTeamToUpdate;
                insert opptyShare;
            }
            catch (Exception e){}  
        }    
    }
    
    public static void TSN_Add_Opty_team_insert(Map<ID, ID> ownerID_optyID_Map)
    {
        OpportunityTeamMember[] opptyTeamToUpdate = new OpportunityTeamMember[]{};
        OpportunityShare[] OpptyShare = new OpportunityShare[]{}; 
        String salesTeamRole = Utilities.getConstant_CS('SalesTeamRole_Case');
        
        if(ownerID_optyID_Map.size() > 0)
        {
            for (ID ownerID :ownerID_optyID_Map.keyset())
            {
            
                OpportunityTeamMember otm = new opportunityTeamMember();
             if(flsUpdateGet(OpportunityTeamMember.OpportunityId)||flsGet(OpportunityTeamMember.OpportunityId)) //SCAVA FIX
            {
                otm.OpportunityId=ownerID_optyID_Map.get(ownerID);
            }
            if(flsUpdateGet(OpportunityTeamMember.UserId)||flsGet(OpportunityTeamMember.UserId)) //SCAVA FIX
            {
                otm.UserId=OwnerID;
            }
            if(flsUpdateGet(OpportunityTeamMember.TeamMemberRole)||flsGet(OpportunityTeamMember.TeamMemberRole)) //SCAVA FIX
            {
                otm.TeamMemberRole=salesTeamRole;
            }
                
                opptyTeamToUpdate.add(otm);
                OpportunityShare os = new OpportunityShare();
            if(flsUpdateGet(OpportunityShare.OpportunityId)||flsGet(OpportunityShare.OpportunityId)) //SCAVA FIX
            {
                os.OpportunityId=ownerID_optyID_Map.get(ownerID);
            }
            if(flsUpdateGet(OpportunityShare.UserOrGroupId)||flsGet(OpportunityShare.UserOrGroupId)) //SCAVA FIX
            {
            
                os.UserOrGroupId=OwnerId;
            }
            
            if(flsUpdateGet(OpportunityShare.OpportunityAccessLevel)||flsGet(OpportunityShare.OpportunityAccessLevel)) //SCAVA FIX
            {
                os.OpportunityAccessLevel='Edit';
            }
                
                opptyShare.add(os);
            }
            Utilities.setValidationSkip(true);
            try{
                insert opptyTeamToUpdate;
                insert opptyShare;
            }
            catch (Exception e){}  
        }    
    }
}