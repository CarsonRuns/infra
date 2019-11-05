@isTest
public class OfferKanbanTest {
    static testMethod void testMethod1() 
    {
         Profile prof = [select id from profile where name LIKE '%Cisco_CustomerSuccess%'];
         User user = new User(Alias = 'newUser', Email='newuser@cisco.com',
         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
         LocaleSidKey='en_US', ProfileId = prof.id,
         TimeZoneSidKey='America/Los_Angeles', UserName='newuser@cisco.com', 
         Theatre__c = 'Americas-US Commercial', Additional_User_Permissions__c='Enable EndUser ACCTCreation');
         insert user;
        
        //Creating dataset
        Offer__c off = new Offer__C();
        off.Name ='OfferName';
        off.Offer_Level_1_Name__c='OfferName';
        off.Annual_Recurring_Revenue_ARR__c = 100000;
        off.Tier_Support__c = 'Level1';
        off.Term_Length__c = '2 Years';
        off.Next_Contract_Renewal_Date__c =system.Today();
        insert off;
        
        Task offtsk = new Task();
        offtsk.DateCompleted__c = Date.newInstance(2016, 12, 9);
        offtsk.Task_Name__c = 'Test Task';
        offtsk.Task_Type__c = Task.Task_Type__c.getDescribe().getPicklistValues()[1].getValue();        
        offtsk.Description = 'Test Notes';
        offtsk.Task_Stage__c = 'Purchase';
        offtsk.whatid =off.Id;
        insert offtsk;
        
        Task offtsk1 = new Task();
        offtsk1.DateCompleted__c = Date.newInstance(2016, 11, 9);
        offtsk1.Task_Name__c = 'Test Task';
        offtsk1.Task_Type__c = Task.Task_Type__c.getDescribe().getPicklistValues()[0].getValue();        
        offtsk1.Description = 'Test Notes';
        offtsk1.Task_Stage__c = 'Purchase';
        offtsk1.whatid =off.Id;
        insert offtsk1;
        
        Id AccID = off.Id;
        Id AccIDT = offtsk.Id;       
        date completedDate = offtsk.DateCompleted__c;  
        string complDate=string.valueOf(completedDate);       
        String Stage ='Purchase';
           
        system.runAs(user){
        Test.startTest();
        List<Id> offerId = new List<Id>();
        offerId.add(off.Id);
        
        OfferKanban offerK= new OfferKanban();
        List<Task> offer1 = OfferKanban.activities(AccID,Stage);
        System.assertEquals(offer1.size(),1);       
        
        List<Task> offer2 = OfferKanban.exitCriteria(AccID,Stage);
        System.assertEquals(offer2.size(),1);              
        
        String offer3 =  OfferKanban.getActivity(AccIDT);
        System.assertEquals(offer3!= null,true);
                   
        String offer4 = OfferKanban.saveActivity(AccIDT,complDate,Stage);
        String offer5 = OfferKanban.saveActivity(AccIDT,'',Stage);        
        System.assertEquals(offer4!= null,true);
        Test.stopTest(); 
        }
    }
}