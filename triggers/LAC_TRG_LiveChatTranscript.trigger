/*
   
    Name            : LiveAgent Transcript Helper
    Author          : Jason Reeh
    Release         : 1
    Functionality   : Triggers process LiveAgentTranscriptTrigger from class LAC_LiveAgentTranscript_Helper
    Created         : 3/12/2015
                    
    Modification History:
    Date         Author                Change     
    12th March 2015   Jason Reeh        Added the trigger to invoke process LiveAgentTranscriptTrigger from class LAC_LiveAgentTranscript_Helper before inserting

*/



trigger LAC_TRG_LiveChatTranscript on LiveChatTranscript (before insert, after insert) 
{
    LAC_LiveAgentTranscript_Helper.processLiveAgentTranscriptTrigger(); 
    //LAC_LiveAgentTranscript_Helper.processLiveAgentTransfer(); 
}