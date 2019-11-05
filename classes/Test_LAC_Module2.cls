@isTest 
public class Test_LAC_Module2 {
    static testMethod void insertNewTranscript() {
    	
    	
    	id userid=userInfo.getUserId();
        set<id> setuserid =new set<id>();
        setuserid.add(userid);
        LAC_Utility.fetchAdditionalAgentDetails(setuserid);
        
       	LiveChatvisitor visitorRec = new LiveChatvisitor();
       	insert visitorRec;
        LiveChatTranscript transcriptRec = new LiveChatTranscript();
        transcriptRec.LiveChatVisitorId = visitorRec.id;
        transcriptRec.body = 'test';
        insert transcriptRec;
        
    }
}