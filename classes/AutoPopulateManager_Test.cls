/**
   @Author :Jay Dash
   @name :AutoPopulateManager_Test
   @CreateDate : 11/11/2014
   @Description :Test class for class AutoPopulateManager
   @Version :1.0
   
  */
@isTest(SeeAllData=true)
private class AutoPopulateManager_Test{
    private static testMethod void testPov(){
        
                
        Profile p = [SELECT Id FROM Profile WHERE Name='Cisco_ADMIN'];
        user lead_se = new user(Alias = 'standt1', Email='testuser1@cisco.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US',TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@cisco.com',Manager_s_Email_Address__c='testuser3@cisco.com',Theatre__c='Americas-US Commercial',ProfileId = p.Id,IsActive=true);
                              
        insert lead_se;
                             
        user security_am = new user(Alias = 'standt0', Email='testuser0@cisco.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing0', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US',TimeZoneSidKey='America/Los_Angeles', UserName='testuser0@cisco.com',Manager_s_Email_Address__c='testuser1@cisco.com',Theatre__c='Americas-US Commercial',ProfileId = p.Id,IsActive=true);
  
        insert security_am;
          
        user od = new user(Alias = 'standt5', Email='testuser5@cisco.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing5', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US',TimeZoneSidKey='America/Los_Angeles', UserName='testuser5@cisco.com',Manager_s_Email_Address__c='testuser1@cisco.com',Theatre__c='Americas-US Commercial',ProfileId = p.Id,IsActive=true);
        insert od;
        
        user povcont  = new user(Alias = 'standt6', Email='testpovcontact@cisco.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing6', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US',TimeZoneSidKey='America/Los_Angeles', UserName='testpovcontact@cisco.com',Manager_s_Email_Address__c='testpovcontact1@cisco.com',Theatre__c='Americas-US Commercial',ProfileId = p.Id,IsActive=true);
   
        insert povcont;
        
        Test.startTest();
         
        Account acct  = GenericStaticTestData.getTestEndUserAccountRecordGreen();
        Contact cont  = GenericStaticTestData.gettestEndUserContactRecord();
        Opportunity oppr  = GenericStaticTestData.gettestParentOpportunityRecord(); 
        
        List<proof_of_value__c> pov = new List<proof_of_value__c>();
        proof_of_value__c pov1 = new Proof_of_value__c(Name='povtc001',Ship_to_Address__c='Address1',Ship_to_Contact_Email__c='test@mail.com',Ship_to_Contact_Name__c='Testname',Ship_to_Contact_Phone__c='11223344',PoV_Order_Category__c='POV Security',Supporting_Opportunity__c=oppr.Id ,POV_Description__c='testdescription',Products__c='ASA',POV_Type__c='Strategic',POV_Start_Date__c=Date.today(),Decision_Date__c=Date.today(),Expected_Bookings__c=100,POV_Duration_Days__c=45,Lead_SE__c=lead_se.id,Security_AM__c=security_am.id,POV_Contact__c=cont.Id,Plan_to_Win__c='test');
        pov.add(pov1);
        proof_of_value__c pov2 = new Proof_of_value__c(Name='povtc002',Ship_to_Address__c='Address1',Ship_to_Contact_Email__c='test@mail.com',Ship_to_Contact_Name__c='Testname',Ship_to_Contact_Phone__c='11223344',PoV_Order_Category__c='POV Security',Supporting_Opportunity__c=oppr.Id ,POV_Description__c='testdescription',Products__c='ASA',POV_Type__c='Strategic',POV_Start_Date__c=Date.today(),Decision_Date__c=Date.today(),Expected_Bookings__c=100,POV_Duration_Days__c=45,Lead_SE__c=povcont.id,Security_AM__c=povcont.id,POV_Contact__c=cont.Id,Plan_to_Win__c='test');
        pov.add(pov2);
        insert pov;
        //AutoPopulateManager.autoPopulate(pov);
        try{
        AutoPopulateManager.submitForApproval_NonSec(pov[0].id);
        }catch(Exception e){
            system.debug(e.getMessage());
        }
        Test.stopTest();
       
    }
}