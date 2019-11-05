public class NotificationController {
    
    //Function to know whether to enable the Notification
    @AuraEnabled
    public static ResultWrapper isPopupEnabled(){ 
        ResultWrapper wrapper = new ResultWrapper();
        boolean isPopupEnabled = false;
        
       	User usr = [select id,Announcement_ID__c,Announcement_Count__c from user where id=:userinfo.getuserid()];

        
        if(!Cache.Session.contains('notificationSession'+usr.id))
        {
            List<Announcement__c> announcements;
            announcements = [select id, Message__c,Message_Text__c,Max_Count__c,Template_Type__c from Announcement__c where Deployed__c=:true and Start_Date__c <= TODAY and End_Date__c >= TODAY limit 1];
            
            if(!announcements.isEmpty()){
                
                if(announcements[0].Template_Type__c=='Text'){
                    wrapper.content = announcements[0].Message_Text__c;
                }else{
                    wrapper.content = announcements[0].Message__c; 
                }  
                wrapper.announcementID = announcements[0].id;
                
                
                if(usr.Announcement_Count__c==null || announcements[0].id != usr.Announcement_ID__c || (announcements[0].id == usr.Announcement_ID__c && usr.Announcement_Count__c < announcements[0].Max_Count__c )){
                    isPopupEnabled = true;
                    try{
                        Cache.Session.put('notificationSession'+usr.id,true, 28800);
                    }catch(Exception e){
                        System.debug('Notification Cache Save Failed');
                    }
                    
                }
            }
        }
        
        
        wrapper.isPopupEnabled = isPopupEnabled;
        return wrapper;
    }
    
    @AuraEnabled
    public static void updateAnnouncmentDetails(String announcementID){
        try{
            User usr = [select id,Announcement_ID__c,Announcement_Count__c from user where id=:userinfo.getuserid()];
            if(usr.Announcement_ID__c==null || usr.Announcement_ID__c != announcementID){
                   usr.Announcement_ID__c = announcementID;
                usr.Announcement_Count__c = 1;
            }else{
                usr.Announcement_Count__c = usr.Announcement_Count__c + 1;
            }
            update usr;
        }catch(Exception e){
            System.debug('Announcement Count Update Failed');
        } 
    }
    
    public class ResultWrapper {
        @AuraEnabled boolean isPopupEnabled{get;set;}
        @AuraEnabled String content{get;set;}
        @AuraEnabled String announcementID{get;set;}
    }
    
    
}