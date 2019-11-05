/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(seeAllData=False)
private class P360_ReassignLeadsTPsonDeactiveUser_Test {

    static testMethod void UnitTestDeactiveUser() {
        // TO DO: implement unit test
        UtilUnitTest.loadAllStaticData();
        boolean callStackLimitExceeded = (Limits.getQueries() >= Limits.getLimitQueries());
        System.debug(System.LoggingLevel.INFO,'@@@@ Limits.getQueries(): '+Limits.getQueries()+' Limits.getLimitQueries(): '+Limits.getLimitQueries());
        System.debug(System.LoggingLevel.INFO, '@@@@ callStackLimitExceeded : '+callStackLimitExceeded);
        
        
        List<Lead> newLead = new List<Lead>();  
        List<Assigned_partner__c> TPs = new List<Assigned_partner__c>();
        map<id,User> oldAcc = new map<id,User>(); 
              
        
        GenericStaticTestData.insertTestLeadRecords();
                
        GenericStaticTestData.insertTestUserRecords();
        
        GenericStaticTestData.testeLeadRecord.PSR_1__c= GenericStaticTestData.testPSRUserRecord.id;
        GenericStaticTestData.testeLeadRecord.Partner_Lead_Status__c='Assigned To PSR';         
        GenericStaticTestData.testeLeadRecord.PSR_2__c= GenericStaticTestData.testPSRUserRecord.id;       
        GenericStaticTestData.testeLeadRecord.PSR_3__c= GenericStaticTestData.testPSRUserRecord.id;
        newLead.add(GenericStaticTestData.testeLeadRecord);
        callStackLimitExceeded = (Limits.getQueries() >= Limits.getLimitQueries());
        System.debug(System.LoggingLevel.INFO,'@@@@ Limits.getQueries(): '+Limits.getQueries()+' Limits.getLimitQueries(): '+Limits.getLimitQueries());
        System.debug(System.LoggingLevel.INFO, '@@@@ callStackLimitExceeded : '+callStackLimitExceeded);
        
        
        GenericStaticTestData.testPartnerGereratedLeadRecord.Partner_Lead_Status__c='Partner Assigned';
        newLead.add(GenericStaticTestData.testPartnerGereratedLeadRecord);
        
        update newLead;   
        callStackLimitExceeded = (Limits.getQueries() >= Limits.getLimitQueries());
        System.debug(System.LoggingLevel.INFO,'@@@@ Limits.getQueries(): '+Limits.getQueries()+' Limits.getLimitQueries(): '+Limits.getLimitQueries());
        System.debug(System.LoggingLevel.INFO, '@@@@ callStackLimitExceeded : '+callStackLimitExceeded);
        
        //List<Assigned_partner__c> lstTP =[select Assigned_partner__c,customer_account__c,Partner_Status__c,Assigned_Partner_Sales_Rep__c,Assigned_Partner_Sales_Rep_2__c,Assigned_Partner_Sales_Rep_3__c from Assigned_partner__c where partner_status__c='Partner Assigned' limit 1];
        
        Assigned_partner__c t1 = new Assigned_partner__c(Name='Test Target Prospect Record',TARGET_ARCHITECTURE__C='Any/All Technologies',TARGET_DESCRIPTION__C='Test Target Prospect Record',marketing_play_name__c = 'Testing123',Assigned_partner__c = GenericStaticTestData.gettestChannelAccountRecord1().id,customer_account__c = GenericStaticTestData.gettestEndUserAccountRecordRed().id,Partner_Status__c='Partner Assigned',Partner_Assigned_Date__c=system.now(),Assignment_Activated__c = True);
        TPs.add(t1); 
        
        Assigned_partner__c t2 = new Assigned_partner__c(Name='Test Target Prospect Record',TARGET_ARCHITECTURE__C='Any/All Technologies',TARGET_DESCRIPTION__C='Test Target Prospect Record',marketing_play_name__c = 'Testing1234',Assigned_partner__c = GenericStaticTestData.gettestChannelAccountRecord1().id,customer_account__c = GenericStaticTestData.gettestEndUserAccountRecordRed().id,Partner_Status__c='Assigned To PSR',Assigned_Partner_Sales_Rep__c= GenericStaticTestData.testPSRUserRecord.id,Assigned_Partner_Sales_Rep_2__c= GenericStaticTestData.testPSRUserRecord.id,Assigned_Partner_Sales_Rep_3__c= GenericStaticTestData.testPSRUserRecord.id,PSR_Assigned_Date_Time__c=system.now(),Assignment_Activated__c = True);
         TPs.add(t2);       

        //insert TPs;
        
        callStackLimitExceeded = (Limits.getQueries() >= Limits.getLimitQueries());
        System.debug(System.LoggingLevel.INFO,'@@@@ Limits.getQueries(): '+Limits.getQueries()+' Limits.getLimitQueries(): '+Limits.getLimitQueries());
        System.debug(System.LoggingLevel.INFO, '@@@@ callStackLimitExceeded : '+callStackLimitExceeded);
        
        test.startTest();        

        system.runAs(GenericStaticTestData.testAMUserRecord){
         GenericStaticTestData.testPSRUserRecord.IsActive = false;
         update GenericStaticTestData.testPSRUserRecord; 
        callStackLimitExceeded = (Limits.getQueries() >= Limits.getLimitQueries());
        System.debug(System.LoggingLevel.INFO,'@@@@ Limits.getQueries(): '+Limits.getQueries()+' Limits.getLimitQueries(): '+Limits.getLimitQueries());
        System.debug(System.LoggingLevel.INFO, '@@@@ callStackLimitExceeded : '+callStackLimitExceeded);
        }
        test.stopTest();
    }
    
    static testMethod void UnitTestTargetProspectDeactiveUser() {
        // TO DO: implement unit test
        UtilUnitTest.loadAllStaticData();
        GenericStaticTestData.insertTestUserRecords();
        System.debug(System.LoggingLevel.INFO,'@@@@ Limits.getQueries(): '+Limits.getQueries()+' Limits.getLimitQueries(): '+Limits.getLimitQueries());
        
        
        List<Assigned_partner__c> TPs = new List<Assigned_partner__c>();
        map<id,User> oldAcc = new map<id,User>(); 

        Assigned_partner__c t1 = new Assigned_partner__c(Name='Test Target Prospect Record',TARGET_ARCHITECTURE__C='Any/All Technologies',TARGET_DESCRIPTION__C='Test Target Prospect Record',marketing_play_name__c = 'Testing123',Assigned_partner__c = GenericStaticTestData.gettestChannelAccountRecord1().id,customer_account__c = GenericStaticTestData.gettestEndUserAccountRecordRed().id,Partner_Status__c='Partner Assigned',Partner_Assigned_Date__c=system.now(),Assignment_Activated__c = True);
        TPs.add(t1); 
        
        Assigned_partner__c t2 = new Assigned_partner__c(Name='Test Target Prospect Record',TARGET_ARCHITECTURE__C='Any/All Technologies',TARGET_DESCRIPTION__C='Test Target Prospect Record',marketing_play_name__c = 'Testing1234',Assigned_partner__c = GenericStaticTestData.gettestChannelAccountRecord1().id,customer_account__c = GenericStaticTestData.gettestEndUserAccountRecordRed().id,Partner_Status__c='Assigned To PSR',Assigned_Partner_Sales_Rep__c= GenericStaticTestData.testPSRUserRecord.id,Assigned_Partner_Sales_Rep_2__c= GenericStaticTestData.testPSRUserRecord.id,Assigned_Partner_Sales_Rep_3__c= GenericStaticTestData.testPSRUserRecord.id,PSR_Assigned_Date_Time__c=system.now(),Assignment_Activated__c = True);
         TPs.add(t2);       

        insert TPs;
        
        System.debug(System.LoggingLevel.INFO,'@@@@ Limits.getQueries(): '+Limits.getQueries()+' Limits.getLimitQueries(): '+Limits.getLimitQueries());
        
        test.startTest();        

        system.runAs(GenericStaticTestData.testAMUserRecord){
            GenericStaticTestData.testPSRUserRecord.IsActive = false;
            update GenericStaticTestData.testPSRUserRecord; 
            System.debug(System.LoggingLevel.INFO,'@@@@ Limits.getQueries(): '+Limits.getQueries()+' Limits.getLimitQueries(): '+Limits.getLimitQueries());
        }
        test.stopTest();
    }
}