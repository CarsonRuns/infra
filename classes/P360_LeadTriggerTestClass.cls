@isTest(seeAllData = true)
public class P360_LeadTriggerTestClass{

    public static testMethod void testP360_UpdatePSRFields()
    {
        Id PSRUserId = GenericStaticTestData.gettestPSRUserRecord().id;
       lead l = GenericStaticTestData.gettesteLeadRecord();
       
       Test.startTest();
       
       l.PSR_SYS1__c = PSRUserId ;
       l.PSR_SYS2__c = PSRUserId ;
       l.PSR_SYS3__c = PSRUserId ;
       l.Partner_Lead_Status__c = Partner360Utils.PARTNER_STATUS_ACTIVELY_WORKING;
       l.ProductAmount__c = 10;
       l.ServicesAmount__c = 10;
        
       List<Lead> Leads = New list<Lead>();
       Leads.add(l);
       List<Lead> LeadsToUpsert = Leads.deepclone() ;
       LeadsToUpsert.add(l);
        
       system.runas(GenericStaticTestData.gettestPAUserRecord())
       {
          Upsert LeadsToUpsert;       
       }
       
       Test.stopTest();
       
    }
}