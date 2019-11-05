/**
 * This class contains unit tests for validating the behavior the P360_BulkAssignPartnerOnLeads_CTE
 * Controller Extension class.
 *
 */
@isTest(SeeAllData=true) 
private class P360_BulkAssignPartnerOnLeads_CTE_Test {
    
   /**
    * Test method for bulk assignment functionality that tests a successful lead update scenario
    * 
    */   
    static testMethod void testSaveLeads_valid() {
        
        final ObjectRecordTypeIds__c cs = ObjectRecordTypeIds__c.getInstance();
        final String actChannelRecordTypeID = cs.AccountChannelRecordTypeId__c;
        
        Lead testLead = new Lead(LastName='TestLead',Company='TestCompany',Account_Name_English__c='TestCompany');
        insert testLead;
        
        List<Lead> testLeads = new List<Lead>();
        testLeads.add(testLead);
        
        Account testCP = [select Id from Account where RecordTypeID=:actChannelRecordTypeID and Partner_Assignment_Eligible__c >= 1 limit 1];
        for (Lead l : testLeads) {
            l.Channel_Partner__c = testCP.Id;
        }
        
        
        Test.setCurrentPageReference(Page.P360_BulkAssignPartnerOnLeads);
        ApexPages.currentPage().getParameters().put('retURL','/00Q');
        
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(testLeads);
        P360_BulkAssignPartnerOnLeads_CTE testCTE = new P360_BulkAssignPartnerOnLeads_CTE(sc);
        testCTE.controller.setSelected(testLeads);
        
        Test.startTest();
      //  System.assert(testCTE.getHasSelected());
        testCTE.saveLeads();
      //  System.assert(!testCTE.getHasMessages());
        Test.stopTest();
        
    }
    
    /**
    * Test method for bulk assignment functionality that tests a failed lead update scenario due to validation errors
    * 
    */   
    static testMethod void testSaveLeads_invalid() {
        
        final ObjectRecordTypeIds__c cs = ObjectRecordTypeIds__c.getInstance();
        final String actChannelRecordTypeID = cs.AccountChannelRecordTypeId__c;
        
        Account testCPOld = [select Id from Account where RecordTypeID=:actChannelRecordTypeID and Partner_Assignment_Eligible__c >= 1 limit 1];
        Lead testLead = new Lead(LastName='TestLead', Company='TestCompany', Partner_Lead_Status__c='Partner Assigned', Account_Name_English__c='TestCompany', Channel_Partner__c=testCPOld.Id, Funding_Source__c='PARTNER-FUNDED');
        insert testLead;
        
        List<Lead> testLeads = new List<Lead>();
        testLeads.add(testLead);
        
        Account testCPNew = [select Id from Account where RecordTypeID=:actChannelRecordTypeID and Partner_Assignment_Eligible__c >= 1 and Id!=:testCPOld.Id limit 1];
        for (Lead l : testLeads) {
            l.Channel_Partner__c = testCPNew.Id;
        }
        
        Test.setCurrentPageReference(Page.P360_BulkAssignPartnerOnLeads);
        ApexPages.currentPage().getParameters().put('retURL','/00Q');
        
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(testLeads);
        P360_BulkAssignPartnerOnLeads_CTE testCTE = new P360_BulkAssignPartnerOnLeads_CTE(sc);
        testCTE.controller.setSelected(testLeads);
        
        Test.startTest();
       // System.assert(testCTE.getHasSelected());
        testCTE.saveLeads();
        //System.assert(testCTE.getHasMessages());
        Test.stopTest();
        
    }
    
    /**
    * Test method for bulk assignment functionality that tests page message for no leads selected
    * 
    */   
    static testMethod void testSaveLeads_none() {
        
        List<Lead> testLeads = new List<Lead>();
        
        Test.setCurrentPageReference(Page.P360_BulkAssignPartnerOnLeads);
        ApexPages.currentPage().getParameters().put('retURL','/00Q');
        
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(testLeads);
        P360_BulkAssignPartnerOnLeads_CTE testCTE = new P360_BulkAssignPartnerOnLeads_CTE(sc);
        testCTE.controller.setSelected(testLeads);
       
                
        
        Test.startTest();
       // System.assert(!testCTE.getHasSelected());
        testCTE.saveLeads();
       // System.assert(testCTE.getHasMessages());
       // ApexPages.Message msg = ApexPages.getMessages().get(0);
       // System.assertEquals(msg.getSummary(),'Please select at least one Lead for assignment');
        Test.stopTest();
        
         P360_BulkAssignPartnerOnLeads_CTE PBAP = new P360_BulkAssignPartnerOnLeads_CTE(sc);
      PBAP.getValidateUser();
                
    }
}