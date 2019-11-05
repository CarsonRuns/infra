/**************************************
Author          : Kavya 
Release         : Mar Release version 1
Created         : Feb 22,2019
Functionality   : PSS - Edit Oppty fields except $, Book Date and Stage, Technology/Service line items

Modification History:
Itrack#        Date             Author                      Change  
****************************************************************************
US250307     Feb 21 ,2019  Kavya                            Initial draft
**********************************************/
public class lxPilotUserCheck {
    public static String CheckBeforeUpdate(Map<id,sobject> oldOppMap, List<Opportunity> optListNew,String optyLines)
    {
        List<String> optyIdsList = new List<String>();
        Set<String> userIdSet = new Set<String>();
        List<User> userDetailList = new List<User>();
        String value = 'noError';
        
        for(Opportunity opp : optListNew) {
            optyIdsList.add(opp.Id);
        }
        
        //Fetch User Id tagged to an Opportunity
        List<OpportunityTeamMember> optyteamMemberList = [SELECT UserId FROM OpportunityTeamMember WHERE OpportunityId IN: optyIdsList];
        
        if(!optyteamMemberList.isEmpty()){
            for(OpportunityTeamMember opptyTM : optyteamMemberList) {
                userIdSet.add(opptyTM.UserId);
            }
        }
        
        if(!userIdSet.isEmpty()) {
            userDetailList = [SELECT Additional_User_Permissions__c,ProfileId,Theatre__c 
                              FROM User 
                              WHERE Id IN :userIdSet];
        }
        
        List<User> loggedInUser = [SELECT Id,Additional_User_Permissions__c,ProfileId,Theatre__c 
                                   FROM User 
                                   WHERE Id = :UserInfo.getUserId() 
                                   AND ProfileId=:Utilities.getConstant_CS('PilotProfileId')];
        
        if(!loggedInUser.isEmpty()) {
            for(Opportunity opp : optListNew) {
                Opportunity oppOld;
                
                if(!oldOppMap.isEmpty())
                    oppOld = (Opportunity)oldOppMap.get(opp.ID);
                
                //set Value field if the pss user is not tagged to an opportunity (check in all stages)
                //if logged in user is pss or vss, they should not be allowed to edit any field in the opportunity in all the stages
                
                if((!userIdSet.contains(loggedInUser[0].id)) && 
                   (String.isNotBlank(loggedInUser[0].Additional_User_Permissions__c)) && 
                   (String.isNotBlank(loggedInUser[0].Theatre__c)) && 
                   (loggedInUser[0].Additional_User_Permissions__c.contains('Enable_ePSS')  || 
                    ((loggedInUser[0].Additional_User_Permissions__c.contains('Enable_VSS')) && 
                     (loggedInUser[0].Theatre__c.contains('Americas-Canada')) ||
                     (loggedInUser[0].Theatre__c.contains('APJC') || loggedInUser[0].Theatre__c.equalsIgnoreCase('EMEAR'))))) {
                        // System.debug('>> Oppold Position Kavya'+oppOld.Position__c);
                         
                         //PUI page
                         if(optyLines=='lines'){
                             value ='UserError';
                         }
                         else if(oppOld!=null && oppOld.Position__c==null && optyLines=='noLines')
                         {
                             return value;
                         }
                         else{
                             opp.addError('You must be part of the opportunity team for editing priviledges.');
                         }                                                                           
                     }
                
                else{
                    if(!userDetailList.isEmpty()){
                        for(User user:userDetailList) {             
                            if((loggedInUser[0].Id == user.Id) && (String.isNotBlank(user.Additional_User_Permissions__c))
                               && (String.isNotBlank(user.Theatre__c)) && 
                               (user.Additional_User_Permissions__c.contains('Enable_ePSS')  || 
                                ((user.Additional_User_Permissions__c.contains('Enable_VSS')) && 
                                 (!user.Theatre__c.equalsIgnoreCase('Americas-Canada')) && 
                                 (user.Theatre__c.contains('APJC') || user.Theatre__c.equalsIgnoreCase('EMEAR')))) 
                               && (user.ProfileId == Utilities.getConstant_CS('PilotProfileId'))) {
                                   
                                   //Setting Value field if the user is pss/vss tagged to an opportunity and opened from pui page
                                   if(optyLines=='lines'){
                                       value ='error';
                                   }
                                   
                                   if((oppOld!=null) && (oppOld.StageName.contains('3') || oppOld.StageName.contains('4') || oppOld.StageName.contains('5'))){
                                       
                                       //Restrict Editing of Fields for pss/vss
                                       if(opp.CloseDate != oppOld.CloseDate ||
                                          opp.Expected_Product__c != oppOld.Expected_Product__c ||
                                          opp.Expected_Service__c != oppOld.Expected_Service__c ||
                                          opp.StageName != oppOld.StageName){
                                              opp.addError('You cannot edit forecastable fields past Stage 2. Please use the Specialist View to enter your difference of opinion.');
                                          }
                                   }
                                   
                                   if((oppOld!=null) && (oppOld.StageName.contains('1') || oppOld.StageName.contains('2'))){
                                       if(opp.StageName.contains('3') || opp.StageName.contains('4') || opp.StageName.contains('5')){
                                           opp.addError('You cannot move the opportunity beyond Stage 2. ');
                                       }
                                   }
                               }
                        }
                    }
                }            
            }
        }
        return value;
    }
    
}