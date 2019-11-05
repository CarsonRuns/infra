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
private class JabberPhoneControllerTests 
{
     
    static testMethod void jabberPhoneTest() 
    {
        Task taskRec = new Task();
        taskRec.Jabber_Call_End_Date_Time__c = null;
        taskRec.Jabber_Call_Start_Date_Time__c = System.Now();
        taskRec.ActivityDate = Date.today();
        taskRec.Subject = 'Call';
        taskRec.Phone_Number__c = '123456786';
        
        taskRec.Type = 'Call';
        taskRec.CallObject = 'Jabber Call';
        taskRec.Call_Results__c = 'Unsaved';
        taskRec.Jabber_Call_Duration_ms__c = 0;
        taskRec.CallDurationInSeconds = 0;
        taskRec.Caller__c = UserInfo.getName();
        insert taskRec;
        
        JabberPhoneController jpc = new JabberPhoneController();
        jpc.strServerAddr = 'testing 123';
        jpc.strCallType = 'Incoming';
        jpc.isClickToCall = false;
        jpc.updateCUCMServer();
        jpc.getTask1();
        jpc.getTask2();
        jpc.createNewTask();
        jpc.strCallLine = 'L1';
        jpc.strCallType = 'Outgoing';
        jpc.createNewTask();
        // end call
        jpc.strCallLine = 'L1';
        jpc.strMode = 'End Call';
        jpc.updateTask();
        // save call
        jpc.strCallLine = 'L2';
        jpc.strMode = 'Save';
        jpc.updateTask();
        
        // Search result update
        jpc.strCallLine = 'L2';
        jpc.strMode = 'Search Result Update';
        jpc.updateTask();
        // cancel call
        jpc.strCallLine = 'L2';
        jpc.strMode = 'Cancel';
        jpc.updateTask();
        
        // delete call log
        jpc.strCallLine = 'L2';
        jpc.strMode = 'Delete';
        jpc.updateTask();
        
        jpc.strL1TaskId = taskRec.id;
        jpc.strL2TaskId = taskRec.id;
        jpc.getActiveCallLog();
        
        jpc.queryLogList();
        jpc.getRecentCallList();
        jpc.getExistingTask();
        ApexPages.currentPage().getParameters().put('existingEventId',taskRec.Id);
        jpc.showOldTask();
        jpc.updateExisitingTask();
        jpc.cancelExisitingTask();
        
        try
        {
            jpc.isClickToCall = true;
            jpc.strRecordId = taskRec.Id;
            jpc.strObject = 'Account';
            jpc.poplateTaskFields(taskRec);
            
            jpc.strObject = 'Contact';
            jpc.poplateTaskFields(taskRec);
        }
        catch (exception e)
        {
            
        }
    }
    static testMethod void jabberPhoneNumberSearchTest() 
    {
        Account acc1 = new Account();
        acc1.Name = 'Test Jabber Ph 1';
        acc1.Phone = '12345678676';
        acc1.CRCountry__c = 'SPAIN';
        acc1.Partner_Account_Status__c = 'Active (Registered)';
        //acc1.recordTypeId = Utilities.getAccountChannelRecordTypeId();
        acc1.Jabber_Phone_Number__c = '12345678676';
        insert acc1;
        
        Contact con1 = new Contact();
        con1.Lastname = 'Jabber contact1';
        con1.AccountID = acc1.id;
        con1.Phone = '12345678676';
        //con1.recordTypeId = Utilities.getContactManualPartnerRecordTypeId();
        con1.Jabber_Phone_Number__c = '12345678676';
        insert con1;
        
        JabberPhoneUtils.searchJabberPhoneNumber('12345678676','2020');
        JabberPhoneUtils.searchPhoneNumber('12345678676','2020');
        JabberPhoneUtils.searchCustomerInfo('%1234567%','By Phone');
        JabberPhoneUtils.searchCustomerInfo('%Jabber%','By Name');
        JabberPhoneUtils.formatPhoneNumber('0asdf1234567');
    }
}