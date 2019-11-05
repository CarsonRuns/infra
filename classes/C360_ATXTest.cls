/************************************************************************************************************************************
Name    : C360_ATXTest
Author  : C360 Dev team
Purpose : Contains logic to execute test methods of C360_ATX
Date    : 28/06/2019
Change History : none
*************************************************************************************************************************************/
@isTest
public class C360_ATXTest {
    @testSetup
    static void dataset(){
      //Creating dataset
        Profile prof = [select id from profile where name LIKE '%Cisco_CustomerSuccess%'];
        User user = new User(Alias = 'newUser', Email='newuser@cisco.com',
                             EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                             LocaleSidKey='en_US', ProfileId = prof.id,
                             TimeZoneSidKey='America/Los_Angeles', UserName='newuser@cisco.com', 
                             Theatre__c = 'Americas-US Commercial', Additional_User_Permissions__c='Enable EndUser ACCTCreation');
        
        insert user;  
    }
     static testMethod void test_ATX() 
    {
         Test.startTest(); 
            List<ATX__c> atxparent = C360_ATX.fetchParentATX();
        	//System.assert(atxparent.size()>0);
            List<ATX__c> atxchild = C360_ATX.fetchChildATX(10);
       		// System.assert(atxchild.size()>0);
            Integer atxtotal = C360_ATX.TotalATX();
           // System.assert(atxtotal >0);
        Test.stopTest();
    }
}