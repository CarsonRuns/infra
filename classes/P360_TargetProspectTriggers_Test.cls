@isTest(SeeAllData=false) 
public class P360_TargetProspectTriggers_Test {

public static testMethod void testP360_UpdatePSR_APFields_Trigger()
{       
       System.debug(System.LoggingLevel.INFO,'@@@@ Limits.getQueries(): '+Limits.getQueries()+' Limits.getLimitQueries(): '+Limits.getLimitQueries());
       UtilUnitTest.loadAllStaticData();
       System.debug(System.LoggingLevel.INFO,'@@@@ Limits.getQueries(): '+Limits.getQueries()+' Limits.getLimitQueries(): '+Limits.getLimitQueries());
       Id PSRUserId = GenericStaticTestData.gettestPSRUserRecord().id;
       Id partnerAccountId = GenericStaticTestData.gettestChannelAccountRecord1().Id;
       //Assigned_Partner__c TP = GenericStaticTestData.gettestTargetProspectRecord();
       Assigned_Partner__c TP = new Assigned_partner__c(Name='Test Target Prospect Record',TARGET_ARCHITECTURE__C='Any/All Technologies',
            TARGET_DESCRIPTION__C='Test Target Prospect Record',Assigned_Partner__c = partnerAccountId, Partner_Status__c = 'Partner Assigned', 
            Partner_Assigned_Date__c = DateTime.now(), PSR_Assigned_Date_Time__c = DateTime.now(), Assignment_Activated__c = true);
       System.debug(System.LoggingLevel.INFO,'@@@@ Limits.getQueries(): '+Limits.getQueries()+' Limits.getLimitQueries(): '+Limits.getLimitQueries());
       
       
       
       //TP.Assignment_Activated__c = true;
       //Update TP;
       System.debug(System.LoggingLevel.INFO,'@@@@ Limits.getQueries(): '+Limits.getQueries()+' Limits.getLimitQueries(): '+Limits.getLimitQueries());
       Test.startTest();
       TP.Assigned_PSR_SYS1__c = PSRUserId ;
       TP.Assigned_PSR_SYS2__c = PSRUserId ;
       TP.Assigned_PSR_SYS3__c = PSRUserId ;
       TP.Partner_Status__c   = Partner360Utils.PARTNER_STATUS_ACTIVELY_WORKING;
        
       List<Assigned_Partner__c> TPs = New list<Assigned_Partner__c>();
       TPs.add(TP);
       List<Assigned_Partner__c> TPsToUpsert = TPs.deepclone() ;
       TPsToUpsert[0].Target_Architecture__c = 'Video-TelePresence & Conferencing';
       TPsToUpsert.add(TP);
        
       system.runas(GenericStaticTestData.gettestPAUserRecord())
       {
          Upsert TPsToUpsert;       
          System.debug(System.LoggingLevel.INFO,'@@@@ Limits.getQueries(): '+Limits.getQueries()+' Limits.getLimitQueries(): '+Limits.getLimitQueries());
       }
       
       Test.stopTest();
       

}







}