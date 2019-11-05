/**************************************
Author          : Kavya 
Release         : Mar Release version 1
Created         : Feb 21,2019
Functionality   : PSS - Edit Oppty fields except $, Book Date and Stage, Technology/Service line items

Modification History:
Itrack#        Date             Author                      Change  
****************************************************************************
US250307     Feb 21 ,2019  Kavya                            Initial draft
**********************************************/
@isTest(SeeAllData=true)
public class lxPilotUserCheckTest {
    
    @isTest(SeeAllData=true)
    static void testPilotUserTaggedAndEdit()
    {
        User userForTesting = [SELECT Id FROM User WHERE Profileid =:Utilities.getConstant_CS('PilotProfileId') 
                               AND Additional_User_Permissions__c includes ('Enable_ePSS') AND IsActive=True limit 1 ];
        
        
        OpportunityTeamMember optTeam = [Select Id,OpportunityId from OpportunityTeamMember limit 1];
        
        OpportunityTeamMember oppTeamMem = new OpportunityTeamMember();
        oppTeamMem.UserId = userForTesting.Id;
        oppTeamMem.OpportunityId = optTeam.OpportunityId;
        oppTeamMem.OpportunityAccessLevel='Edit';
        oppTeamMem.TeamMemberRole = 'Incubation Specialist';
        insert oppTeamMem;
        
        List<Opportunity> oppListForMap = [SELECT Id,StageName,CloseDate,Expected_Product__c,Expected_Service__c 
                                           FROM Opportunity where Id=:optTeam.OpportunityId limit 1];
        
        User user = [Select Id FROM User WHERE Id=:oppTeamMem.UserId and IsActive=True];
        system.runAs(user){
            Map<Id,Opportunity> oldOpp = new Map<Id,Opportunity>();
            for(Opportunity opp:oppListForMap)
            {
                oldOpp.put(oppTeamMem.OpportunityId,opp);
            }
            lxPilotUserCheck.CheckBeforeUpdate(oldOpp,oppListForMap,'noLines');
            lxPilotUserCheck.CheckBeforeUpdate(oldOpp,oppListForMap,'lines');
        }
        
        
        User userForTesting1 = [SELECT Id FROM User WHERE Profileid =:Utilities.getConstant_CS('PilotProfileId') 
                                          AND Additional_User_Permissions__c includes ('Enable_VSS') limit 1];
        
        OpportunityTeamMember optTeam1 = [Select Id,OpportunityId from OpportunityTeamMember limit 1];
        
        OpportunityTeamMember oppTeamMem1 = new OpportunityTeamMember();
        oppTeamMem1.UserId = userForTesting1.Id;
        oppTeamMem1.OpportunityId = optTeam1.OpportunityId;
        oppTeamMem1.OpportunityAccessLevel='Edit';
        oppTeamMem1.TeamMemberRole = 'Incubation Specialist';
        insert oppTeamMem1;
        
        List<Opportunity> oppListForMap1 = [SELECT Id,StageName,CloseDate,Expected_Product__c,Expected_Service__c 
                                           FROM Opportunity where Id=:optTeam1.OpportunityId limit 1];
        
        User user1 = [Select Id FROM User WHERE Id=:oppTeamMem1.UserId and IsActive=True];
        system.runAs(user1){
            Map<Id,Opportunity> oldOpp = new Map<Id,Opportunity>();
            for(Opportunity opp:oppListForMap1)
            {
                oldOpp.put(oppTeamMem1.OpportunityId,opp);
            }
            lxPilotUserCheck.CheckBeforeUpdate(oldOpp,oppListForMap1,'noLines');
            lxPilotUserCheck.CheckBeforeUpdate(oldOpp,oppListForMap1,'lines');
        }
    }
    @isTest(SeeAllData=true)
    static void testPilotUser()
    {
        Map<Id,Opportunity> oldOpp = new Map<Id,Opportunity>();
        User userForTesting = [SELECT Id FROM User WHERE Profileid =:Utilities.getConstant_CS('PilotProfileId') 
                               AND Additional_User_Permissions__c includes ('Enable_ePSS') AND IsActive=True LIMIT 1];
        
        User userForTesting1 = [SELECT Id FROM User WHERE Profileid =:Utilities.getConstant_CS('PilotProfileId') 
                                AND Additional_User_Permissions__c includes ('Enable_VSS') AND IsActive=True LIMIT 1]; 
        
        List<Opportunity> oppList = [SELECT Id FROM Opportunity limit 1];
        system.runAs(userForTesting){
            lxPilotUserCheck.CheckBeforeUpdate(oldOpp,oppList,'noLines');
            lxPilotUserCheck.CheckBeforeUpdate(oldOpp,oppList,'lines');
        }
        system.runAs(userForTesting1){
            lxPilotUserCheck.CheckBeforeUpdate(oldOpp,oppList,'noLines');
            lxPilotUserCheck.CheckBeforeUpdate(oldOpp,oppList,'lines');
        }
        
    }
}