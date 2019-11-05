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
@isTest(SeeAllData=false)
private class JabberBatchUpdateTests {

    static testMethod void JabberBatchUpdateTest1() 
    {
        /*
        Account acc1 = new Account();
        acc1.Name = 'Test Jabber Bacth Acc1';
        acc1.CRCountry__c = 'INDIA';
        acc1.Partner_Account_Status__c = 'Active (Registered)';
        acc1.recordTypeId = Utilities.getAccountChannelRecordTypeId();
        insert acc1;
        
        
        Contact con1 = new Contact();
        con1.Lastname = 'Test Jabber Batch Con1';
        con1.AccountID = acc1.id;
        insert con1;
        */
        
        string strQuery = 'Select Id from Contact where Jabber_Phone_Number__c = null or Jabber_Phone_Number__c = \'\' limit 1';
        string strObj = 'Contact';
        
        test.startTest();
        JabberBatchUpdate jabberBatch = new JabberBatchUpdate(strQuery,strObj);
        database.executeBatch(jabberBatch, 2000);
        test.stopTest();
    }
    static testMethod void JabberBatchUpdateTest2() 
    {
        /*
        Account acc1 = new Account();
        acc1.Name = 'Test Jabber Bacth Acc1';
        acc1.CRCountry__c = 'INDIA';
        acc1.Partner_Account_Status__c = 'Active (Registered)';
        acc1.recordTypeId = Utilities.getAccountChannelRecordTypeId();
        insert acc1;
        
        
        Contact con1 = new Contact();
        con1.Lastname = 'Test Jabber Batch Con1';
        con1.AccountID = acc1.id;
        insert con1;
        */
        
        test.startTest();
        
        datetime schedulerTime = datetime.now().addMinutes(1);
        string strScheduleTime = '0 ' + schedulerTime.minute() + ' ' + 
            schedulerTime.hour() + ' ' + schedulerTime.day() + ' '+ 
            schedulerTime.month() + ' ? '+ schedulerTime.year();
        new JabberBatchUpdateScheduler('Contact');
        new JabberBatchUpdateScheduler();
        system.schedule('Test Jabber Update - ' + DateTime.Now().getTime(), strScheduleTime, new JabberBatchUpdateScheduler('Account'));
        test.stopTest();
    }
}