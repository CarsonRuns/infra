@isTest (SeeAllData=true)

public class Oppty_SecurityContact_test{
    static testMethod void testOpptyContactUpdate(){
         test.starttest();
         
         Opportunity oppty = GenericStaticTestData.gettestParentOpportunityRecord();
        
         List<User> users = new List<User>();
         users.Add(GenericStaticTestData.gettestAMUserRecord());
         users.Add(GenericStaticTestData.gettestAMUserRecord());
         users.Add(GenericStaticTestData.gettestAMUserRecord());
         users.Add(GenericStaticTestData.gettestAMUserRecord());
                  
         List<SecurityTeamRole__c> SecRoles = SecurityTeamRole__c.getAll().values();
         String Sec_Eng;
         String Sec_Mgr;
         
         for(SecurityTeamRole__c secrole :SecRoles){
             if(secrole.Security_Engineer__c != null){
                 Sec_Eng = secrole.Security_Engineer__c;
             }
             if(secrole.Security_Manager__c != null){
                 Sec_Mgr = secrole.Security_Manager__c;
             }
         }
         
         List<OpportunityTeamMember> oppTeamMember = new List<OpportunityTeamMember>();
         for(integer i=0; i<4;i++){
             if(i==3)
                 oppTeamMember.add(new OpportunityTeamMember(OpportunityId = oppty.id, TeamMemberRole = Sec_Mgr, UserId = users[i].id));
             else
                 oppTeamMember.add(new OpportunityTeamMember(OpportunityId = oppty.id, TeamMemberRole = Sec_Eng, UserId = users[i].id));    
         }
    
            try{
                insert oppTeamMember;
            } catch(Exception e) {
                System.debug('InsertException = '+e);
            }   
        
        List<OpportunityTeamMember> oppTeamInsert = new List<OpportunityTeamMember>();
        oppTeamInsert.add(new OpportunityTeamMember(OpportunityId = oppty.id, TeamMemberRole = Sec_Mgr, UserId = users[1].id));
        oppTeamInsert.add(new OpportunityTeamMember(OpportunityId = oppty.id, TeamMemberRole = Sec_Eng, UserId = users[2].id)); 
            
        Database.SaveResult[] sr;
            
        if(!oppTeamInsert.isEmpty()){
            try{
               sr = Database.insert(oppTeamInsert, false);
            } catch(Exception e) {
                System.debug('InsertException = '+e);
            } 
        }
               
        if(!sr.isEmpty()){
            OpportunityTeamMember opt_del = new OpportunityTeamMember(Id = sr[0].getID());
            delete opt_del;   
        }
               
        OpportunityTeamMember opt_upd = new OpportunityTeamMember(Id = sr[1].getID());
        opt_upd.TeamMemberRole = Sec_Mgr;
        
        try{
            update opt_upd;
        } catch (Exception e){
                System.debug('UpdateException = '+e);
            }
       test.stopTest();
    }
}