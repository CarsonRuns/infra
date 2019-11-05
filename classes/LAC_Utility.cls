/*
    Name            : LAC_Utility 
    Author          : Jason Reeh
    Release         : 1
    Functionality   : Generic global class that contains constants and methods that can be re-used by all classes for consistency
    Created         : 3/12/2015
                    
    Modification History:
    Date         Author                Change     
    12th March 2015   Jason Reeh        Added the Method fetchAdditionalAgentDetails to retrieve all Live agents 
    
      
*/



public with sharing class LAC_Utility 
{

 
    /**
    * @author Jason
    * @date 03-12-2015
    * @description  THIS METHOD WILL be invoked from other classes to get the live agents Details      
    * @param set of ID's.
    * @return Map of AdditionalAgentInfo
    */
   public static Map<Id,LAC_Utility.AdditionalAgentInfo> fetchAdditionalAgentDetails(Set<Id> sAgents){
    Map<Id,AdditionalAgentInfo> mapAgentInfo = new Map<Id,AdditionalAgentInfo>();
    List<User> lstUsers = new List<User>();
    
    lstUsers = [Select User.Name, UserRole.Name, UserRole.Id, UserRoleId, Profile.Name, Profile.Id, ProfileId, ManagerId, Id From User u where Id in :sAgents ];
    
    // adding agent details to map mapAgentInfo
        if(!lstUsers.isEmpty()){
        AdditionalAgentInfo aai;
            // Assign agent details to wrapper class and store it in map   
            for(User u: lstUsers){
                aai = new AdditionalAgentInfo();
                aai.AgentProfileName = u.Profile.Name;
                aai.Agent_Name = u.Name;
                if(u.UserRoleId!=null){
                aai.AgentRoleName = u.UserRole.Name;
                }
            if(u.ManagerId!=null){
                aai.Agent_ManagerId = u.ManagerId;
            }
            mapAgentInfo.put(u.Id,aai);
            }// End for
        }// If List is not empty
        return mapAgentInfo;
    }// End fetchAdditionalAgentDetails
    
    
    // Wrapper/Inner class for  Agent details.
    public class AdditionalAgentInfo{
        public Id AgentId {set;get;}
        public String Agent_Name {set;get;}
        public String Agent_ManagerId {set;get;}
        public String AgentRoleName {set;get;}
        public String AgentProfileId {set;get;}
        public String AgentProfileName {set;get;}
    }// End inner class
}