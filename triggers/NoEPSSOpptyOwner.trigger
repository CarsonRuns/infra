/***Modification History:
UserStory    Date               Author          Change Log
**************************************************************************************
US250307     March 20, 2019     Kavya           Included a condition to check for VSS
US301684     May 1, 2019        Awnish          Added changes for the LDR/BDR Flow

***************************************************************************************/
trigger NoEPSSOpptyOwner on Opportunity (after insert) {
    
    //set default postn for epss. lead convert and other.
    //epss/pss cannot own oppty. this is for lead convert. 
    //need addPhase line to set owner of phase. 
    Opportunity[] opptys = Trigger.new;
    ProfileID__c profileIds = ProfileID__c.getInstance();
   
    String pssProfileId = profileIds.Cisco_PSS__c;
    String currentUserProfileId = userinfo.getProfileId();
    if (opptys.size() == 1){
        Boolean CurrentUserEpss = false;
        Boolean OwnerEpss = false;       
        Opportunity opty = opptys[0];
        //Added Logic to get the Permission Set for the User
        User CurrentUser = [select Default_Position__c, Id, Profile.Name, Additional_User_Permissions__c,(SELECT Id,PermissionSet.ID, PermissionSet.Name,AssigneeId FROM PermissionSetAssignments)  from user where id = :UserInfo.getUserId()];
        //Check if the logged in User is BDR/LDR
        Boolean currentUserBDRORLDR = false;
        for(PermissionSetAssignment permSet : CurrentUser.PermissionSetAssignments){
            if(permSet.PermissionSet.Name== Utilities.getConstant_CS('NGCC_LDR_BDR_Permission_Set')){
                currentUserBDROrLDR = true;
            }
        }
        if(CurrentUser.Additional_User_Permissions__c <> null && (CurrentUser.Additional_User_Permissions__c.replace('Enable_ePSS','') != CurrentUser.Additional_User_Permissions__c ||
                                                                  CurrentUser.Additional_User_Permissions__c.contains('Enable_VSS')) 
           ){
               CurrentUserEpss=true;     
           }
        
        Id owner = opty.Opportunity_Owner_Am__c;
        if(owner == null){
            owner = opty.OwnerId;
        }
        
        User OwnerInfo = [select Default_Position__c, Id, ProfileId, Profile.Name, Additional_User_Permissions__c,(SELECT Id,PermissionSet.ID, PermissionSet.Name,AssigneeId FROM PermissionSetAssignments) from user where id = :owner];
        string OwnerProfileId = OwnerInfo.ProfileId;
        //Logic to check if the Opportunity Owner is Specialist
        if( Utilities.isEPSSuser(owner)){
            OwnerEpss=true;
        }
        //Logic to check if the Opportunity Owner is LDR/BDR
        Boolean ownerBDRORLDR = false;
        for(PermissionSetAssignment permSet : OwnerInfo.PermissionSetAssignments){
            if(permSet.PermissionSet.Name== Utilities.getConstant_CS('NGCC_LDR_BDR_Permission_Set')){
                ownerBDRORLDR = true;
            }
        }
        // Added currentUserBDROrLDR for LDR/BDR 
        if(currentUserBDROrLDR || CurrentUserEpss || currentUserProfileId.contains(pssProfileId) ){
            String tempPostn = OwnerInfo.Default_Position__c;
            Opportunity OpptyToUpdate = new Opportunity(Id=opty.Id);
            if( OwnerEpss == false && ownerBDRORLDR==false)
            {   
                //Set Opportunity Owner to AM
                if(opty.Opportunity_Owner_Am__c <> null)
                {
                    OpptyToUpdate.OwnerId = opty.Opportunity_Owner_Am__c;
                    update OpptyToUpdate;
                }
              
                if (tempPostn <> null || opty.Opportunity_Owner_Am__c <> null)
                {
                    Utilities.setValidationSkip(true);//skips validation rules
                    Utilities.setSkip(true);//skips certain trigger functionality
                    Utilities.setskipFuture(true);//skips more future calls
                    if(currentUserBDROrLDR==true){
                        //Add Opportunity Team Member
                        OpportunityTeamMember optyTeam = new opportunityTeamMember(OpportunityId=opty.Id, 
                                                                                   UserId=UserInfo.getUserId(),
                                                                                   OpportunityAccessLevel = 'Edit',
                                                                                   TeamMemberRole=Utilities.getConstant_CS('NGCC_Opportunity_Team_Role'));
                        insert optyTeam;
                        //get all of the sharing records which Salesforce created right now. rowCause is Sales Team.
                        List<OpportunityShare> oppShareRecords = [select Id, OpportunityAccessLevel, RowCause from OpportunityShare where OpportunityId =: opty.Id and RowCause = 'Team'];
                        // set team members access to read/write
                        for (OpportunityShare OppShare : oppShareRecords){
                            OppShare.OpportunityAccessLevel = 'Edit'; 
                        }
                        update oppShareRecords; 
                        
                        //Update Opportunity ID on the Lead Record
                        Lead ld = [select id,Existing_Opportunity__c from Lead where id=:opty.DRT_Lead__c];
                        ld.Existing_Opportunity__c = opty.Id;
                        update ld;
                        
                    }else{
                        Utilities.addStUser(opty.Id, UserInfo.getUserId(), 'Edit', 'Product Sales Specialist', 'Team');
                    }
                }
            }
            else {
                opty.addError('Specialists or VDC Sales Reps (LDRs, BDRs) cannot own opportunities. Please select the correct Account Owner in the "Opportunity Owner AM" field.');
            }
        }
        else if( OwnerEpss || currentUserProfileId.contains(pssProfileId) )
        {
            opty.addError('PSS users cannot own opportunities. Please choose another Owner AM.');
         }
    }
}