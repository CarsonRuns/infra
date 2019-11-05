@isTest(SeeAllData=true)
public class MarkStageAsCompleteTest {
    static testMethod void testMethod01() 
    {
    
         Profile prof = [select id from profile where name LIKE '%Cisco_CustomerSuccess%'];
         User user = new User(Alias = 'newUser', Email='newuser@cisco.com',
         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
         LocaleSidKey='en_US', ProfileId = prof.id,
         TimeZoneSidKey='America/Los_Angeles', UserName='newuser@cisco.com', 
         Theatre__c = 'Americas-US Commercial', Additional_User_Permissions__c='Enable EndUser ACCTCreation');
         insert user;
    
           
         system.runAs(user){            
            Account acc = new Account();
            acc.Name = 'Test acc1';
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            insert acc;
            
             Offer__c off = new Offer__C();
             off.Name ='OfferName';
             off.Offer_Level_1_Name__c='OfferName';
             off.Annual_Recurring_Revenue_ARR__c = 100000;
             off.Tier_Support__c = 'Level1';
             off.Term_Length__c = '2 Years';
             off.Next_Contract_Renewal_Date__c =system.Today();
             off.Customer_Name__c = acc.Id;
             insert off;
           
             Task offtsk = new Task();
             offtsk.DateCompleted__c = Date.newInstance(2016, 12, 9);
             offtsk.Task_Name__c = 'Test Task';
             offtsk.Task_Type__c = Task.Task_Type__c.getDescribe().getPicklistValues()[1].getValue();
             offtsk.Description = 'Test Notes';
             offtsk.Task_Stage__c = 'Purchase';
             offtsk.whatId =off.Id;
             insert offtsk;
             
             String Stage ='Purchase';
             string nextstage='Onboard';
             String onloadStage = offtsk.Task_Stage__c;
             String inNum ='0';
             String inNum1 ='1';
             String inNum2 ='2';
             String inNum3 ='3';
             String inNum4 ='4';
             String inNum5 ='5';
             String inNum6 ='6';
             String inNum7 ='7';
             boolean flag =True;
             String objapi='Offer_Stages__c';
             String obj='Offer__c';
             
             Id AccID = off.Id;
             Id AccIDT = offtsk.Id;
            
            //Starting test
            Test.startTest(); 
            
            List<Task> offList = MarkStageAsComplete.TaskDescription(AccID,Stage);
            System.assertEquals(offList.size(),1);
             
            
             MarkStageAsComplete.SaveOffer(AccID,nextstage,inNum,onloadStage);
            
             MarkStageAsComplete.SaveOffer(AccID,nextstage,inNum1,onloadStage);
             MarkStageAsComplete.SaveOffer(AccID,nextstage,inNum2,onloadStage);
             MarkStageAsComplete.SaveOffer(AccID,nextstage,inNum3,onloadStage);
             MarkStageAsComplete.SaveOffer(AccID,nextstage,inNum4,onloadStage);
             MarkStageAsComplete.SaveOffer(AccID,nextstage,inNum5,onloadStage);
             MarkStageAsComplete.SaveOffer(AccID,nextstage,inNum6,onloadStage);
             MarkStageAsComplete.SaveOffer(AccID,nextstage,inNum7,onloadStage);
             MarkStageAsComplete.getPicklistvalues(obj,objapi,flag); 
                        
            Test.stopTest();     
        }
    }
}