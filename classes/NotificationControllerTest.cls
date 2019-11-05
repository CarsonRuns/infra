@isTest
public class NotificationControllerTest {
    
    
    @isTest static void testUpdateAnnouncmentDetailsNull() {
        Announcement__c announcement = setupAnnouncement();
        User testUser = setupUser();
        testUser.Announcement_ID__c = announcement.Id;
        update testUser;
        System.runAs(testUser)
        {
            
            Test.StartTest();
            NotificationController.updateAnnouncmentDetails(''); 
            Test.StopTest();
            
            User usr = [select Announcement_Count__c from user where id = :testUser.Id];
            
        }
        
        
    }
    
    @isTest static void testUpdateAnnouncmentDetailsNotNull()
    {
        Announcement__c announcement = setupAnnouncement();
        User testUser = setupUser();
        testUser.Announcement_ID__c = announcement.Id;
        update testUser;
        System.runAs(testUser)
        {
            
            Test.StartTest();
            NotificationController.updateAnnouncmentDetails(announcement.Id);	  
            Test.StopTest();
            
            User usr = [select Announcement_Count__c from user where id = :testUser.Id];
            
        }
        
    }
    @isTest static void testIsPopupEnabledTest()
    {
        
        Announcement__c announcement = setupAnnouncement();
        User testUser = setupUser();
        testUser.Announcement_ID__c = announcement.Id;
        update testUser;
        
        
        System.runAs(testUser)
        {
            Test.StartTest();
            NotificationController.isPopupEnabled();
            Test.StopTest();
        }
        
    }
    
    public static Announcement__c setupAnnouncement(){
        Announcement__c testAnnouncement = new Announcement__c();
        
        testAnnouncement.Message__c = 'Trail message';
        testAnnouncement.Max_Count__c = 3;
        testAnnouncement.Start_Date__c = System.today();
        testAnnouncement.End_Date__c = System.today() + 120000;
        testAnnouncement.Deployed__c = true;
        
        insert testAnnouncement;
        
        return testAnnouncement;
        
    }
    
    public static User setupUser(){
        User testUser = CEE_TestUtility.getUser('temp',false);
        testUser.Announcement_Count__c = 2;
        insert testUser;
        return testUser;
    }
    
}