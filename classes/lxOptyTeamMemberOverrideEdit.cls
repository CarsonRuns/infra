/*
Author          : Manikant Kella
Release         : June,2019
Created         : Manikant Kella
Functionality   : Overriding Edit Action for OpptyTeam Member object to provide Reassign functionality


Modification History:
*------------------------------------------------------------------------------------
Itrack#        Date        Author                             Change  
*------------------------------------------------------------------------------------
US291442	May 01,2019	  Manikant Kella(mkella)	   Opty Team Member Override
*------------------------------------------------------------------------------------
*/

public class lxOptyTeamMemberOverrideEdit {
    //added by Kavya
    //method checks the oppty team record sharing rules and will display error message to users based on privileages
    @AuraEnabled
    public static Boolean initClass(Id recordId)
    {
        
        OpportunityTeamMember opp = [Select OpportunityId from OpportunityTeamMember where Id =:recordId limit 1];
        //checking whether logged in user is associated with any group
        List<GroupMember> UserassocGroup = [SELECT Id, group.id, group.name, group.type FROM GroupMember where UserOrGroupId = :UserInfo.getUserId()];
        List<String> UserGroupList = new List<String>();
        if(!UserassocGroup.isEmpty()){
            for(GroupMember grp : UserassocGroup) {
                UserGroupList.add(grp.group.id);
            }
        }
        //to fetcch the user and check if user associated witha any group and having edit access then allow them to edit
        List<OpportunityShare> optyShare = [select Id, OpportunityAccessLevel,UserOrGroupId,RowCause from OpportunityShare where OpportunityId =:opp.OpportunityId and (UserOrGroupId=:UserInfo.getUserId() or UserOrGroupId in :UserGroupList) and (OpportunityAccessLevel='Edit' or OpportunityAccessLevel='All')  limit 1];
        if(!optyShare.isEmpty())
        {
            return true;
        }
        //skip insufficient error for admin users
        else if (Utilities.skipUser() == true){
            return true;
        }
        return false;
    }
    //ends here
    //this method returns the user full name and displays in reassign section
    @AuraEnabled
    public static string fetchUser(String userId){
        User u = [select id,Name from User where id =: userId];
        return u.Name;
    }
    
    //this method updates opty team member record and inserts and deletes record if they reassign new user
    @AuraEnabled
    public static String upsertOptyTeam(Id optyTeamrecordId,String teamRole, String optyAccess,String userId, String teamMemberSel, Id opptyIdSelected){
        List<OpportunityTeamMember> opptyTeamMem = new List<OpportunityTeamMember>();
        opptyTeamMem = [Select id ,OpportunityAccessLevel,TeamMemberRole,UserId from OpportunityTeamMember where id=:optyTeamrecordId];
        try{
            if(String.isNotBlank(String.valueOf(teamMemberSel))){
                //delete opptyTeamMem;
                //System.debug('I am in if condition');
                OpportunityTeamMember optyTeam = new OpportunityTeamMember();
                optyTeam.OpportunityId = opptyIdSelected;
                optyTeam.UserId = teamMemberSel;
                
                optyTeam.OpportunityAccessLevel = optyAccess;
                optyTeam.TeamMemberRole =teamRole;
                insert optyTeam;
                delete opptyTeamMem;
                lxOptyTeamMemberOverrideEdit.updateSpecialistView(userId,teamMemberSel,opptyIdSelected);
                //System.debug('Now it should be Success');
                return 'Success';
            }else{
                //System.debug('I am in else condition');
                if(opptyTeamMem.size()>0 && opptyTeamMem!=null){            
                    for(OpportunityTeamMember optyTeamMem : opptyTeamMem ){
                        optyTeamMem.OpportunityAccessLevel = optyAccess;
                        optyTeamMem.TeamMemberRole = teamRole;
                    }
                    update opptyTeamMem;
                }
                return 'Success';
            }
        }catch(Exception e){
            System.debug('Exception: '+e.getMessage());
            String errorMessage;
            errorMessage = e.getMessage();
            return errorMessage;
        }
    }
    
    // this method updates the specialist view line items associated with user if user reassigns new team member and updates all those line items 
    // with new user
    public static void updateSpecialistView(String userId, String teamMemSelected,String opptyIdSelected){
        List<OpportunityLinesSV__c> specalistOpptyTeamList = new List<OpportunityLinesSV__c>();
        specalistOpptyTeamList = [Select id, Incubation_Specialist__c,Architecture_Specialist__c,Software_Specialist__c from OpportunityLinesSV__c where Opportunity__c =:opptyIdSelected and (Incubation_Specialist__c!='' or Architecture_Specialist__c !='' or Software_Specialist__c !='') and (Incubation_Specialist__c = :userId or Architecture_Specialist__c =:userId or Software_Specialist__c = :userId)];
        if(specalistOpptyTeamList.size()>0 && specalistOpptyTeamList!=null){
            for(OpportunityLinesSV__c optyLine : specalistOpptyTeamList){
                if(String.isNotBlank(optyLine.Incubation_Specialist__c) && optyLine.Incubation_Specialist__c == userId){
                    optyLine.Incubation_Specialist__c = teamMemSelected;
                }
                if(String.isNotBlank(optyLine.Architecture_Specialist__c) && optyLine.Architecture_Specialist__c == userId){
                    optyLine.Architecture_Specialist__c = teamMemSelected;
                }
                if(String.isNotBlank(optyLine.Software_Specialist__c) && optyLine.Software_Specialist__c == userId){
                    optyLine.Software_Specialist__c = teamMemSelected;
                }
            }
            update specalistOpptyTeamList;
        } 
    } 
}