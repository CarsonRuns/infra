global class SE_TeamMember{

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

    
    WebService static void addUser(String opptyID, String userID) {
        
        OpportunityTeamMember[] opptyTeamToUpdate = new OpportunityTeamMember[]{};
        OpportunityShare[] OpptyShare = new OpportunityShare[]{}; 
        
        
        OpportunityTeamMember otm = new opportunityTeamMember();
        if(flsUpdateGet(OpportunityTeamMember.OpportunityId)||flsGet(OpportunityTeamMember.OpportunityId)) //SCAVA FIX
        {
        otm.OpportunityId=opptyID; 
        }
        if(flsUpdateGet(OpportunityTeamMember.UserId)||flsGet(OpportunityTeamMember.UserId)) //SCAVA FIX
        {
        otm.UserId=userID;
        }
        if(flsUpdateGet(OpportunityTeamMember.OpportunityAccessLevel)||flsGet(OpportunityTeamMember.OpportunityAccessLevel)) //SCAVA FIX
        {
        otm.OpportunityAccessLevel='Edit';
        }
        if(flsUpdateGet(OpportunityTeamMember.TeamMemberRole)||flsGet(OpportunityTeamMember.TeamMemberRole)) //SCAVA FIX
        {
        otm.TeamMemberRole='Systems Engineer';
        }
        opptyTeamToUpdate.add(otm);
        
        OpportunityShare os = new OpportunityShare();
        if(flsUpdateGet(OpportunityShare.OpportunityId)||flsGet(OpportunityShare.OpportunityId)) //SCAVA FIX
        {
        os.OpportunityId=opptyID;
        }
        if(flsUpdateGet(OpportunityShare.UserOrGroupId)||flsGet(OpportunityShare.UserOrGroupId)) //SCAVA FIX
        {
        os.UserOrGroupId=userID;
        }
        if(flsUpdateGet(OpportunityShare.OpportunityAccessLevel)||flsGet(OpportunityShare.OpportunityAccessLevel)) //SCAVA FIX
        {       
        os.OpportunityAccessLevel='Edit';
        }
        if(flsUpdateGet(OpportunityShare.RowCause)||flsGet(OpportunityShare.RowCause)) //SCAVA FIX
        {
        os.RowCause='Team';
        }
        opptyShare.add(os);
                                                    
        insert opptyTeamToUpdate;
        insert opptyShare;
    }
    
    WebService static void deleteUser(String opptyTeamID) {
        
        OpportunityTeamMember otm = new OpportunityTeamMember(Id=opptyTeamID);
        delete otm;
    }
    
    static testMethod void opptyTeamMember() {       
        Opportunity opptys = GenericStaticTestData.gettestParentOpportunityRecord();       
        User[] userArray = [select Id from User where isActive = true LIMIT 1];        
        addUser(opptys.id, userArray[0].id);        
        // Test deleteUser
        OpportunityTeamMember[] otms = [select Id FROM OpportunityTeamMember LIMIT 1];        
        deleteUser(otms[0].id);         
    }

}