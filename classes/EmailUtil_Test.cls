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
@isTest
private class EmailUtil_Test {
    
    
    private static void prepareData() {
        //load custom settings
        User u = new User(Id = UserInfo.getUserId());
        
        System.runAs (u) {            
            Date dtToday = System.today() - 3;
            List<P360_Apex_Batch_Job__c> jobDetail = new List<P360_Apex_Batch_Job__c>();
            jobDetail.add(new P360_Apex_Batch_Job__c(Name='P360 dtToday',DT_DailyEmailNotification__c=dtToday,JobEmailAlerts__c='test@cisco.com'));
            insert jobDetail;
            
            List<Org_Constant_CS__c> orgConstant = new List<Org_Constant_CS__c>();
            orgConstant.add(new Org_Constant_CS__c(Name='P360 Partner Assigned',Non_Production_Value__c='Partner Assigned',Production_Value__c='Partner Assigned'));
            orgConstant.add(new Org_Constant_CS__c(Name='P360 Assigned to PSR',Non_Production_Value__c='Assigned to PSR',Production_Value__c='Assigned to PSR'));
            orgConstant.add(new Org_Constant_CS__c(Name='P360 Executive User',Non_Production_Value__c='Executive',Production_Value__c='Executive'));
            orgConstant.add(new Org_Constant_CS__c(Name='P360 Lead120Days',Non_Production_Value__c='120',Production_Value__c='120'));
            orgConstant.add(new Org_Constant_CS__c(Name='P360 Lead Aging',Non_Production_Value__c='1',Production_Value__c='1'));            
            insert orgConstant;
        }
    }
    
    static testMethod void UnitTestPSR() {
        prepareData();
        // TO DO: implement unit test
        UtilUnitTest.loadAllStaticData();
        List<Lead> newLead = new List<Lead>();  
        //List<Assigned_partner__c> TPs = new List<Assigned_partner__c>();
        //map<id,User> oldAcc = new map<id,User>();
        
        GenericStaticTestData.insertTestLeadRecords();                
        GenericStaticTestData.insertTestUserRecords();
        
        GenericStaticTestData.testeLeadRecord.PSR_1__c= GenericStaticTestData.testPSRUserRecord.id;
        GenericStaticTestData.testeLeadRecord.Partner_Lead_Status__c='Assigned To PSR';         
        GenericStaticTestData.testeLeadRecord.PSR_Assigned_Date__c = System.today() - 1;
        GenericStaticTestData.testeLeadRecord.PSR_2__c= GenericStaticTestData.testPSRUserRecord.id;       
        GenericStaticTestData.testeLeadRecord.PSR_3__c= GenericStaticTestData.testPSRUserRecord.id;
        newLead.add(GenericStaticTestData.testeLeadRecord);        
        update newLead;
        
      // ********* Scheduler Call ***************
        Test.StartTest();
      // Changed the scheduler calls from P360_DailyEmailNotification to P360EmailNotificationScheduler            
            P360EmailNotificationScheduler pDS2 = new P360EmailNotificationScheduler();      
            String sch2 = '0 0 23 * * ?';
            String jobId = System.schedule('Test check2', sch2, pDS2);         
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];        
            System.assertEquals(sch2, ct.CronExpression);
         
        Test.stopTest();
    }   
    
    static testMethod void UnitTestPA() {
        prepareData();
        // TO DO: implement unit test
        UtilUnitTest.loadAllStaticData();
        List<Lead> newLead = new List<Lead>();  
        //List<Assigned_partner__c> TPs = new List<Assigned_partner__c>();
        //map<id,User> oldAcc = new map<id,User>(); 
        
        GenericStaticTestData.insertTestLeadRecords();                
        GenericStaticTestData.insertTestUserRecords();        
       
        
        GenericStaticTestData.testManualLeadRecord.Channel_Partner__c  = GenericStaticTestData.testChannelAccountRecord1.id;
        GenericStaticTestData.testManualLeadRecord.Partner_Lead_Status__c='Partner Assigned'; 
        GenericStaticTestData.testManualLeadRecord.Partner_Assigned_Date__c = System.today() - 1;
        newLead.add(GenericStaticTestData.testManualLeadRecord);
        
        GenericStaticTestData.testPartnerGereratedLeadRecord.Partner_Lead_Status__c='Partner Assigned';
        newLead.add(GenericStaticTestData.testPartnerGereratedLeadRecord);  
        User us = new User(Id = UserInfo.getUserId());        
        System.runAs (us) {
           update newLead;
        }
        User u = new User(Id = UserInfo.getUserId());
        map<id,user> mapUsers =new Map<id,user>();
        map<id,user> mapPartnerUser = new map<id,user>();
        Set<Id> lst = new Set<Id>();
        lst.add(u.id);
        Set<Id> lstPA = new Set<Id>();
        lstPA.add(u.id);
        EmailNotification_Utility.psrLeadsCount.put(u.id,2);        
        mapUsers.put(u.id,u);
        mapPartnerUser.put(u.id,u);
        datetime dt = datetime.now(); 
        EmailNotification_Utility.checkStringNotNull(' ');               
        /********* Scheduler Call ****************/        
       Test.StartTest();
            // Changed the scheduler calls from P360_DailyEmailNotification to P360EmailNotificationScheduler
            EmailNotification_Utility.dtToday = system.today()-1;
            EmailNotification_Utility.lastRunDate = system.today()-1;            
            P360EmailNotificationScheduler pDS2 = new P360EmailNotificationScheduler();      
            String sch2 = '0 0 23 * * ?';
            system.schedule('Test check2', sch2, pDS2);
            EmailNotification_Utility.insertPA_PSR_RecordCount(null,lst,lstPA,mapUsers,mapPartnerUser);
            EmailNotification_Utility.validateAssignedDate(dt);            
        Test.stopTest();
    }
}