@isTest
public class MyPartnerContactControllerTest {
    static testMethod void MyPartnerContactControllerTestMethod()
    {
        Profile prof = [select id from profile where name LIKE '%Cisco_CustomerSuccess%'];
        User user = new User(Alias = 'newUser', Email='newuser@cisco.com',
         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
         LocaleSidKey='en_US', ProfileId = prof.id,
         TimeZoneSidKey='America/Los_Angeles', UserName='newuser@cisco.com', 
         Theatre__c = 'Americas-US Commercial', Additional_User_Permissions__c='Enable EndUser ACCTCreation');
        insert user;
        
        system.runAs(user)
        {
	    Offer__c off = new Offer__C();
        off.Name ='OfferName';
        off.Offer_Level_1_Name__c='OfferName';
        off.Annual_Recurring_Revenue_ARR__c = 100000;
        off.Tier_Support__c = 'Level1';
        off.Term_Length__c = '2 Years';
        off.Next_Contract_Renewal_Date__c =system.Today();
        insert off;
            
   		Id AccID = off.Id; 
           
   		List<Id> accountIds = new List<Id>();
            for(Offer__c offerlist:[Select Id,Customer_Name__c from Offer__c where Id =:AccId]){
               accountIds.add(offerlist.Customer_Name__c);}
            
     Test.startTest();
      	   List<Id> offerId = new List<Id>();
           offerId.add(off.Id);
           MyPartnerContactController.getContactList(offerId);
           System.assertEquals(offerId.size(),1);
     Test.stopTest(); 
    }
   }
}