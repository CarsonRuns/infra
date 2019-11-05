/* 
    Name            : LeadTACDuplicateBatchApex_Test 
    Author          : Eric Pesch (epesch)
    Release         : 1.0
    Functionality   : Tests for the scheduler and job to de-dupe TAC Generated Leads
    Created         : Sep 14 2015
    
    Modification History:
    Date        Author          Change 
*/

@isTest
private class LeadTACDuplicateBatchApex_Test {
    private static final String TAG = '[LeadTACDuplicateBatchApex_Test] - ';
    
    /*
     * @description Test Factory for following test methods
     */
    @testSetup static void setup(){
        //Call some setup factory utils
        UtilUnitTest.loadAllStaticData();
        if(Utilities.getConstant_CS('Lead TAC Duplicate Delete Days') == 'NA'){
            List<Org_Constant_CS__c> orgConstants = new List<Org_Constant_CS__c>();
            orgConstants.add(new Org_Constant_CS__c(Name='Lead TAC Duplicate Delete Days',Non_Production_Value__c='5',Production_Value__c='5'));
            insert orgConstants;
        }
        
        System.debug(TAG + 'org constant - ' + Utilities.getConstant_CS('Lead TAC Duplicate Delete Days'));
        
        //Setup dates for valid and invalid Leads
        DateTime pastCreateDate = DateTime.now(), pastDateInvalid = DateTime.now();
        pastCreateDate = pastCreateDate.addDays(-Integer.valueOf(Utilities.getConstant_CS('Lead TAC Duplicate Delete Days'))-1);
        pastDateInvalid = pastDateInvalid.addDays(-28);
        
        //Insert Account
        Account endCustomerAccount = new Account(name='Test End-User Account',CRName__c ='Test End-User Account',RECORDTYPEID='0123000000004aUAAQ',Country__c='UNITED STATES');
        insert endCustomerAccount;
        
        //Insert Lead, within 30 days (limit for duplicate lead check)
        Lead leadPast = new Lead(
            LastName = 'tacTest1',
            Company='tacTest1 account',
            Email='email1@email.com',
            Main_Technology__c='OTHER',
            Status='1 Waiting',
            Address_Line_1__c='address 1',
            CustomCity__c = 'city 1',
            CustomCountry__c = 'United States',
            End_Customer_Account__c = endCustomerAccount.Id,
            LeadSource = System.label.Lead_TAC_Generated_Source,
            Source_System_Id__c = 'tac1-1',
            Lead_Qualified_Date__c = pastDateInvalid);
        
        insert leadPast;
        leadPast.Lead_Qualified_Date__c = pastDateInvalid;
        update leadPast;
        
        //Insert lead, should go to rejected/duplicate status
        Lead newLead = new Lead(
            LastName = 'tacTest1_B',
            Company='tacTest1 account',
            Email='email1@email.com',
            Main_Technology__c='OTHER',
            Status='1 Waiting',
            Address_Line_1__c='address 1',
            CustomCity__c = 'city 1',
            CustomCountry__c = 'United States',
            End_Customer_Account__c = endCustomerAccount.Id,
            LeadSource = System.label.Lead_TAC_Generated_Source,
            Source_System_Id__c = 'tac1-2',Confirm_Duplicate__c=true,
            Lead_Qualified_Date__c = pastCreateDate);
            
        insert newLead;
    }
    
    /*
     * @description Test running the apex batch directly - delete 1 legacy lead/duplicate lead
     */
    static testMethod void leadDuplicate_testDelete() {
        List<Lead> currLeads = [select Id from Lead where IsDeleted =: false];
        System.assertEquals(2, currLeads.size());
        
        test.startTest();
        
        //Create the batch job and run
        LeadTACDuplicateBatchApex tacBatch = new LeadTACDuplicateBatchApex();
        Id batchId = Database.executeBatch(tacBatch);
        
        test.stopTest();
    }
    
    /*
     * @description Test running the apex batch scheduler - schedules job only
     */
    static testMethod void leadDuplicate_testScheduler() {
        String CRON_EXP = '0 0 23 * * ?';
        
        test.startTest();
        
        //Create the batch job and run
        String jobId = System.schedule('LeadTAC-'+DateTime.now(), CRON_EXP, new LeadTACDuplicateScheduler());
        
        //Verify Schedulable information
        CronTrigger ct = [select Id, CronExpression, TimesTriggered, NextFireTime from CronTrigger
                            where Id =: jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        
        test.stopTest();
    }
    
}