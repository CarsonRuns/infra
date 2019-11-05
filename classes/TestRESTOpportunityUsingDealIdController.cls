/*
Author : Cisco
Release : June 14, 2019 Release
Functionality : Test class for all RESTOpportunityUsingDealIdController

Modification History:
Itrack# Date Author Change
US251274 - CCE Punchout Link
*/
@isTest(SeeAllData=false)
public class TestRESTOpportunityUsingDealIdController {
     @testSetup
    static void dataSetUp(){
        List<Opportunity_Rest_API_Properties__c> orpList = new List<Opportunity_Rest_API_Properties__c>(); 
        
        Opportunity_Rest_API_Properties__c orp1 = new Opportunity_Rest_API_Properties__c(Name = 'Content-Type', Value__c = 'application/json');
    orpList.add(orp1);
        
        Opportunity_Rest_API_Properties__c orp2 = new Opportunity_Rest_API_Properties__c(Name = 'Error Code - Invalid Deal Id', Value__c = 'INVALID_DEALID');
    orpList.add(orp2);
        
        Opportunity_Rest_API_Properties__c orp3 = new Opportunity_Rest_API_Properties__c(Name = 'Error Message - Invalid Deal Id', Value__c = 'The dealID is not present in the system. Please retry with a new dealID.');
    orpList.add(orp3);
        
        Opportunity_Rest_API_Properties__c orp4 = new Opportunity_Rest_API_Properties__c(Name = 'HTTP Status Code - Bad Request', Value__c = '400');
    orpList.add(orp4);
        
        insert orpList;
    }
    
   static testMethod void testDoGetWithValidDealId() {
            Test.startTest();
            Org_Constants__c org = new Org_Constants__c();         
             org.key__c='Oppty: ProfileIds to skip Triggers';
             org.non_prod_value__c='00e30000000qiJjAAI';
             org.prod_value__c='00e30000000qiJjAAI';
             org.Type__c='URL';
             org.Prod_LT__c='GSTS,Data_Migration,Integration_Echo_Suppression';
             insert org;   
             ProfileID__c profileIds = new ProfileID__c(Cisco_Renewals__c='00e34000001CQnp',Cisco_PSS__c = '00e30000000rrZw', name='Cisco Systems, Inc.');
             insert profileIds;
             Deal_ID_Queue__c ds = new Deal_ID_Queue__c();
             ds.name = 'Deal ID Queue 1';
             ds.Deal_ID_Queue_Start__c = 61100001;
             ds.Deal_ID_Queue_Stop__c = 61100301;
             insert ds;
             CEE_TestUtility.loadCustomSettings();
        	 Account testAccount = new Account(Name = 'TestOpty', Country__c = 'US', Phone='(913) 839-0643', Fax=null, ZipPostalCode__c='95134');
        	 insert testAccount;
             Opportunity o = new Opportunity(name='Test',dealid__c = '61100206', AccountID = testAccount.Id, StageName='1 - Prospect', Position__c = 'US COMMERCIAL Dummy Territory',CloseDate=Date.today()+7, Expected_Product__c=100.0, Expected_Service__c= 100.0, Theater__c='USA', RecordTypeId='0123000000003ykAAA');
            
             insert o;
         	 Contact mockBusinessContact1  = new Contact(FirstName = 'Test billing First Name', LastName = 'Test billing Last Name');
             insert mockBusinessContact1 ;
         	 OpportunityContactRole mockBusinessContactRole1  = new OpportunityContactRole(OpportunityId = o.Id, ContactId=mockBusinessContact1.Id);
             insert mockBusinessContactRole1 ;
        
        RestRequest mockRequest = new RestRequest();
        RestResponse mockResponse = new RestResponse();
        
        mockRequest.requestURI = '/opportunity/61100206';
        mockRequest.httpMethod = 'GET';
        RestContext.request = mockRequest;
        RestContext.response = mockResponse;
        RESTOpportunityUsingDealIdController.doGet();        
        Test.stopTest();
    } 
    
      static testMethod void testDoGetWithMultipleBusinessAndValidDealId() {
           Test.startTest();
          Org_Constants__c org = new Org_Constants__c();         
             org.key__c='Oppty: ProfileIds to skip Triggers';
             org.non_prod_value__c='00e30000000qiJjAAI';
             org.prod_value__c='00e30000000qiJjAAI';
             org.Type__c='URL';
             org.Prod_LT__c='GSTS,Data_Migration,Integration_Echo_Suppression';
             insert org;   
             ProfileID__c profileIds = new ProfileID__c(Cisco_Renewals__c='00e34000001CQnp',Cisco_PSS__c = '00e30000000rrZw', name='Cisco Systems, Inc.');
             insert profileIds;
             Deal_ID_Queue__c ds = new Deal_ID_Queue__c();
             ds.name = 'Deal ID Queue 1';
             ds.Deal_ID_Queue_Start__c = 61100001;
             ds.Deal_ID_Queue_Stop__c = 61100301;
             insert ds;
             CEE_TestUtility.loadCustomSettings();
          
        
           Account testAccount = new Account(Name = 'testAccount', Country__c = 'US', Phone='(913) 839-0643', Fax=null, ZipPostalCode__c='95134');
            insert testAccount; 
            Opportunity mockOpportunity = new Opportunity(DealId__c = '61100011', AccountID = testAccount.Id, Name = 'Test Name', StageName = '1 - Prospect', CloseDate = date.today());
            insert mockOpportunity;
            Contact mockBusinessContact1  = new Contact(FirstName = 'Test billing First Name', LastName = 'Test billing Last Name');
            insert mockBusinessContact1 ;
            Contact mockBusinessContact2  = new Contact(FirstName = 'Test billing primary First Name', LastName = 'Test biling primary Last Name');
            insert mockBusinessContact2 ;
            Contact mockContact = new Contact(FirstName = 'Test contact First Name', LastName = 'Test contact Last Name');
            insert mockContact;
            OpportunityContactRole mockBusinessContactRole1  = new OpportunityContactRole(OpportunityId = mockOpportunity.Id, ContactId=mockBusinessContact1.Id);
            insert mockBusinessContactRole1 ;
            OpportunityContactRole mockBusinessContactRole2  = new OpportunityContactRole(OpportunityId = mockOpportunity.Id, ContactId=mockBusinessContact2.Id, IsPrimary = true);
            insert mockBusinessContactRole2 ;
           
        RestRequest mockRequest = new RestRequest();
        RestResponse mockResponse = new RestResponse();

        mockRequest.requestURI = '/opportunity/61100011';
        mockRequest.httpMethod = 'GET';
        RestContext.request = mockRequest;
        RestContext.response = mockResponse;
        RESTOpportunityUsingDealIdController.doGet();
       
        Test.stopTest();
    } 

 
}