@isTest(SeeAllData = true)
public class NoEPSSOpptyOwnerTest {
    
    
    
    private static testMethod void test(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Cisco_ADMIN']; 
        User u = new User(Alias = 'standt', Email='standarduser100@cisco.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles',Theatre__c='APJC-APAC', 
                          UserName='standarduser100@cisco.com');
                
        System.runAs(u){
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('End-User').getRecordTypeId();
        Date vCloseDate = System.today();
        User currentUser = [select defaultCurrencyIsoCode from User where Id = :UserInfo.getUserId()];
            
        //Query for Pricebook2
        String defaultPricebookId;
        Pricebook2[] pricebook2 = [select id from Pricebook2];
        if(pricebook2 == null || pricebook2.size() == 0){
            Pricebook2 createDefaultPB = new Pricebook2(name='default pricebook', isActive=true);
            insert createDefaultPB;
            defaultPricebookId = createDefaultPB.Id;
        }
        else{
            defaultPricebookId = pricebook2[0].Id;
            
        }
        
        Account acct1 = [select id from account where RecordTypeId=:devRecordTypeId limit 1];
        Opportunity oppty1 = new Opportunity(name='Test1',Accountid=acct1.id, StageName='3 - Proposal',CloseDate= vCloseDate,Competitors__c = 'A10 Networks',Expected_Product__c=2,Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode);
        oppty1.Expected_Service__c = 0;
        oppty1.Expected_Product__c = 10;
        insert oppty1;
        }
    }
    
    // Test Method to check the BDR/LDR Flow
     private static testMethod void NGCCUserTest(){
        //Creating NGCC User
        Profile p = [SELECT Id FROM Profile WHERE Name='Cisco_NGCC']; 
        User u = new User(Alias = 'standt', Email='standarduser1034@cisco.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          Position_1__c = 'XYZ',
                          TimeZoneSidKey='America/Los_Angeles',Theatre__c='	Americas-Canada', 
                          UserName='ngccusr1034@cisco.com');
        insert u;
         
        //Setting up LDR/BDR Permission Set
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'NGCC_DRR'];
        insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id);
        
        //Creating AM User
        Profile p1 = [SELECT Id FROM Profile WHERE Name='Cisco_Sales']; 
        User u1 = new User(Alias = 'standt', Email='standarduser1045@cisco.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p1.Id, 
                          TimeZoneSidKey='America/Los_Angeles',Theatre__c='	Americas-Canada', 
                          Position_1__c = 'ABC',
                          UserName='salesusr1045@cisco.com');
        insert u1;
        
            //lxTestDataFactory.createCustomSettings();                
         
        //Creating Opportunity Using BDR/LDR User
        System.runAs(u){

        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('End-User').getRecordTypeId();
        Date vCloseDate = System.today();
        User currentUser = [select defaultCurrencyIsoCode from User where Id = :UserInfo.getUserId()];
        
        //Query for Pricebook2
        String defaultPricebookId;
        Pricebook2[] pricebook2 = [select id from Pricebook2];
        if(pricebook2 == null || pricebook2.size() == 0){
            Pricebook2 createDefaultPB = new Pricebook2(name='default pricebook', isActive=true);
            insert createDefaultPB;
            defaultPricebookId = createDefaultPB.Id;
        }
        else{
            defaultPricebookId = pricebook2[0].Id;
            
        }
        //added by Kavya
        Id leadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('eLeads').getRecordTypeId();
       
        Lead l1 = new Lead(
            firstName='Test',
            LastName ='Lead', 
            RECORDTYPEID=leadRecordTypeId,
            company='Test End-User Account',
            email='test@test.com.test', 
            LeadSource='eLeads'
        );
        insert l1;
            
        Account acct1 = [select id from account where RecordTypeId=:devRecordTypeId limit 1];
           
        //Get Parent Opportunity Record Type    
        //Id opportunityRecTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Parent Opportunity').getRecordTypeId(); 
            
        Opportunity oppty1 = new Opportunity(
            name='Test1',
            Accountid=acct1.id, 
            //RECORDTYPEID = opportunityRecTypeID,
            StageName='1 - Prospect',
            CloseDate= vCloseDate,
            Expected_Product__c=2,
            Expected_Service__c = 0,
            Pricebook2Id=defaultPricebookId,
            CurrencyIsoCode=currentUser.defaultCurrencyIsoCode,
            Opportunity_Owner_AM__c = u1.Id,
            DRT_Lead__c = l1.Id
        );
        insert oppty1;
        }
    }
    
}