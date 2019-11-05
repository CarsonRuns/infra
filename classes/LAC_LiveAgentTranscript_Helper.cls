/*
    Name            : LiveAgent Transcript Helper
    Author          : Jason Reeh
    Release         : 1
    Functionality   :  This class contains the logic for the TGR_LAC_LiveChatTranscript trigger
    Created         : 3/12/2015
                    
    Modification History:
    Date         Author                Change     
    3/12/3015   Jason Reeh        Added to retrieve agents details before inserting records in object LiveChatTranscripts      
*/


public with sharing class LAC_LiveAgentTranscript_Helper 
{


    /**
    * @author Jason
    * @date 03-12-2015
    * @description  THIS METHOD WILL FIRE WHEN THE LiveChatTranscript  is inserted and will check that agent details like 
               "Manager ,Profile, Role" and assign it to LiveChatTranscript record .      
    * @param 
    * @return void.
    */
    
    public static void processLiveAgentTranscriptTrigger()
    {
        Map<Id,LAC_Utility.AdditionalAgentInfo> mapAgentInfo = new Map<Id,LAC_Utility.AdditionalAgentInfo>(); 
        Set<Id> sAgents = new Set<Id>(); 
        if(Trigger.isBefore && Trigger.isInsert)
        {
            /// Iterate all agents associated to LiveChatTranscript and add it to Set.
            for(LiveChatTranscript lct: (List<LiveChatTranscript>)Trigger.new)
            { 
                sAgents.add(lct.OwnerId); 
            }
            //retrieving agent details from Class LAC_Utility.fetchAdditionalAgentDetails
            mapAgentInfo = LAC_Utility.fetchAdditionalAgentDetails(sAgents); 
            LAC_Utility.AdditionalAgentInfo aai = new LAC_Utility.AdditionalAgentInfo(); 
           // Iterate through each record &  and assign agent details in LiveChatTranscript  record before insert.
            for(LiveChatTranscript lct: (List<LiveChatTranscript>) Trigger.new)
            { 
                aai = mapAgentInfo.get(lct.OwnerId); 
                if(aai!=null)
                { 
                    if(aai.Agent_ManagerId!=null)
                    { 
                        lct.Agent_Manager__c = aai.Agent_ManagerId; 
                    } //End if Agent Manager
                    if(aai.AgentProfileName!=null)
                    { 
                        lct.Agent_Profile__c = aai.AgentProfileName; 
                    } //End IF Profile name Assign
                    if(aai.AgentRoleName!=null)
                    { 
                        lct.Agent_Role__c = aai.AgentRoleName; 
                    } //End if for agent Role name assign
                }//End IF for additional agent info
            }//End FOR
        }//End IF for before insert trigger event
    }// END of Method processLiveAgentTranscriptTrigger
    
    /*
    public static void processLiveAgentTransfer()
    {
        Map<string,LAC_Custom__c> relationMap = new Map<string,LAC_Custom__c>();
        Set<string> chatkeySet = new Set<string> ();
        if(Trigger.isBefore && Trigger.isInsert)
        {
            for(LiveChatTranscript lct: (List<LiveChatTranscript>)Trigger.new)
            {
            	chatkeySet.add(lct.ChatKey);
            }
            
            System.debug(chatkeySet);
            for(LAC_Custom__c transferObj: [select Chat_Key__c, Case__c, Case__r.contactid from LAC_Custom__c where Chat_Key__c IN: chatkeySet])
            {
                relationMap.put(transferobj.Chat_Key__c,transferObj);
            }
           
			if(!relationMap.isEmpty())
			{  
				for(LiveChatTranscript lct: (List<LiveChatTranscript>)Trigger.new)
	            {
	                if(lct.caseid == null) 
	                {
	                     lct.caseid = relationMap.get(lct.ChatKey).Case__c;
	                     
	                }
	                if(lct.contactID == null) 
	                {
	              
	                     lct.contactID = relationMap.get(lct.ChatKey).Case__r.contactid;
	                }
				} 
			}
		}
		
        if(Trigger.isAfter && Trigger.isInsert)
		{
			for(LiveChatTranscript lct: (List<LiveChatTranscript>)Trigger.new)
            {
            	chatkeySet.add(lct.ChatKey);
            }
			LAC_LiveAgentTranscript_Helper.DeleteCustomRecords(chatkeySet);
		}  
    } 
    
    @future
    public static void DeleteCustomRecords(set<string> myIDs)
    {
    	System.debug('deleteid-->'+myids);
    	delete [select id from LAC_Custom__c where Chat_Key__c IN : myIDs];
    }
    */
}