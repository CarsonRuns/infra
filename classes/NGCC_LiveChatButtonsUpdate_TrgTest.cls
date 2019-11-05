@isTest(SeeAllData = true)
public class NGCC_LiveChatButtonsUpdate_TrgTest{
    public static testMethod void insertLiveChatTranscript(){
        
        Campaign camp;
        camp = new Campaign(Name='Testing Campaign',
                Program_Event_Name__c = 'Program_Event_Name__c',
                Offer_Description__c = 'Offer_Description__c',
                Offer_URL__c = 'Offer_URL__c',
                Primary_Technology__c = 'Primary_Technology__c',
                Campaign_Code__c = 'Campaign_Code__c',
                Description = 'Campaign_Description__c',
                Program_Event_Description__c = 'Program_Event_Description__c',
                Offer_Name__c = 'Offer_Name__c',
                Offer_Architecture__c = 'Offer_Architecture__c'
              );
            insert camp;
            
            RecordType r = new RecordType();
                r=[select Id,Name from Recordtype where SobjectType='Lead' and Name='Prospect' limit 1];
            
                Lead leadOne= new Lead();
                leadOne.RecordTypeId = r.Id;
                leadOne.Status = 'New Prospect';
                leadOne.LastName = 'TestLast';
                leadOne.Company = 'Test Company';
                leadOne.Campaign_Name__c = camp.ID;
                leadOne.CustomCountry__c = 'EGYPT';
                leadOne.Theater__c = 'APJ';
                leadOne.Medium_Type__c = 'Inbound Chat';
                leadOne.Call_Center_Vendor__c = 'Convergys Manila - Global';
            insert leadOne;
           User Admin = [Select Id from User where Id=:UserInfo.getUserId()];
           LiveChatButton lcb = new LiveChatButton();
            system.runAs(Admin)
            {    
                
                lcb= [select id from LiveChatButton limit 1];
                //lcb.Type = 'Chat Button';
                //lcb.Name = 'TestName';
                //lcb.Skills = 'TestSkills';
                //lcb.DeveloperName = 'TestDeveloper';
                //lcb.OptionsHasInviteAfterAccept = false;
                //insert lcb;
            }
        LiveChatTranscript liveChat = new LiveChatTranscript();
        LiveChatVisitor livecVist = new LiveChatVisitor();
            insert livecVist;
        //liveChat.Name   
            liveChat.LiveChatVisitorId = livecVist.Id;
            liveChat.LeadID = leadOne.Id;
            if(lcb!=NULL)
            liveChat.LiveChatButtonId = lcb.Id;
        //Type, Name,,Developer Name, OptionsHasInviteAfterAccept
        insert liveChat;
        LiveChatTranscript liveChatOne = new LiveChatTranscript();
         liveChatOne.LiveChatVisitorId = livecVist.Id;
         liveChatOne.LeadID = leadOne.Id;
         insert liveChatOne;
    }
}