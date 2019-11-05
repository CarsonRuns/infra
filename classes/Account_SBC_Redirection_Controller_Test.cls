@isTest(SeeAllData=true)
public class Account_SBC_Redirection_Controller_Test {
     public static testMethod void test_sbc(){
        Profile p1 = [SELECT Id FROM profile WHERE name='Cisco_Admin'];
          
        User newUser = new User(alias = 'newUser1',email='newuser1@cisco.com',emailencodingkey='UTF-8', lastname='Testing',languagelocalekey='en_US',Additional_User_Permissions__c='Enable EndUser ACCTCreation',localesidkey='en_US', profileid = p1.Id,timezonesidkey='America/Los_Angeles',Theatre__c='Americas-US Commercial', username='newuser1@cisco.com');
        insert newUser;
        
        System.RunAs(newUser){
        test.startTest();
        Account acc = new Account(Name = 'test');
        insert acc;
        Test.setCurrentPageReference(New PageReference('Page.Acct_Search_Before_Create_Redirect_10_0'));
        
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        Account_SBC_Redirection_Controller sbc = new Account_SBC_Redirection_Controller(sc);
        sbc.errorMsg = 'test';
        sbc.leadDetail = 'test';
        sbc.idLead = 'test';
        sbc.IdChannel = 'test';
        sbc.IdCompetitor = 'test';
        sbc.IdEndUser = 'test';
        sbc.IdUnregisteredResller = 'test';
        sbc.userCountry = 'test';
        sbc.redirectToCreate();
        sbc.recordTypeId = null ;  
        sbc.redirectToCreate();
        test.stopTest();
        }
     }
}