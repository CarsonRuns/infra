/*
Author: Bapu Rao Srigadde
Created Date: 6/7/2015 
Purpose: This trigger is for updating the chat type on the LiveChatTranscript object for reporting purposes.
Criteria: if associated 'chat button' record 'OptionsHasInviteAfterAccept' is true then chat type should be 'proactive chat' else 'chat button' 
*/
trigger NGCC_LiveChatButtonsUpdate_Trg on LiveChatTranscript (Before Insert, Before Update) {
    Map<id,LiveChatButton> m = new Map<Id,LiveChatButton>();
    List<LiveChatButton> rec = new List<LiveChatButton>();
    //fetching all the existing livechatbutton records
        rec = [Select OptionsHasInviteAfterAccept, Id From LiveChatButton];
        
        if(rec.size()>0){
            for(LiveChatButton b : rec){
                m.put(b.id, b);
            }
            // Processing all newly created LiveChatTranscript
            for (LiveChatTranscript l: trigger.new){
                l.Lead__c = l.LeadId;
                
                if(m.keyset().contains(l.LiveChatButtonId)){
                    if(m.get(l.LiveChatButtonId).OptionsHasInviteAfterAccept == true && l.LiveChatButtonId != Null)
                          l.Chat_Type__c = 'Proactive Chat';
                       else
                            l.Chat_Type__c = 'Chat Button';
                        
                    }
             }    
      }
       
}