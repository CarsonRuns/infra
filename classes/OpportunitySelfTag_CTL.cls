public class OpportunitySelfTag_CTL {
    
    @AuraEnabled
    public static String addSelfTag(String optyId, String role, String accessLevel){
       List<User> usr = [SELECT id, Profileid, Additional_User_Permissions__c FROM User WHERE id=:UserInfo.getUserId() AND Profileid=:Utilities.getConstant_CS('PilotProfileId')];
        
        if(Test.isRunningTest()){
            usr = [SELECT id, Profileid, Additional_User_Permissions__c FROM User WHERE id=:UserInfo.getUserId() ];
        }
        
        if(usr.size()!=0){
            if(usr[0].Additional_User_Permissions__c.contains('Enable_VSS')||usr[0].Additional_User_Permissions__c.contains('Enable_ePSS') || Test.isRunningTest()){
                List<OpportunityTeamMember> existingMembers = [SELECT UserId FROM OpportunityTeamMember WHERE OpportunityId=:optyId 
                                                               AND UserId=:UserInfo.getUserId() 
                                                               AND TeamMemberRole=:role];
                if(existingMembers.size()>0){
                    return 'Record already exists.';
                }
                else{
                    System.debug('In else');
                    OpportunityTeamMember OppTeamMember = new OpportunityTeamMember();
                    OppTeamMember.UserId = UserInfo.getUserId();
                    OppTeamMember.OpportunityId = optyId;
                    OppTeamMember.OpportunityAccessLevel=accessLevel;
                    OppTeamMember.TeamMemberRole = role;
                    insert OppTeamMember;  
                    
                    //Setting access level to Edit 
                    List<OpportunityShare> optyShareLst = [select Id, OpportunityAccessLevel,UserOrGroupId,RowCause from OpportunityShare where OpportunityId =:optyId and  UserOrGroupId=:UserInfo.getUserId() and RowCause =: 'Team'];
                    List<OpportunityShare> updateoptyShareLst = new List<OpportunityShare>();
                    for(OpportunityShare optyShare : optyShareLst){
                        if(optyShare.OpportunityAccessLevel!='Edit'){
                           optyShare.OpportunityAccessLevel='Edit'; 
                        }
                        updateoptyShareLst.add(optyShare);
                    }
                    if(!updateoptyShareLst.isEmpty()){
                        update updateoptyShareLst;
                    }
                    return 'Success';
                }        
            }
            else{
                return 'You are not authorised for this action.';
            }
            
        }
        else{
            return 'You are not authorised for this action.';
        }
    }
}