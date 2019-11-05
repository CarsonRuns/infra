/***************************************************************************************************
Name    : CPOCPersonnelEdit_Test 
Author  : Abinash Das
Purpose : Tests for the Personnel Edit Controller  
Created Date: Jul 8 2016                     
*****************************************************************************************************/

@isTest
private class CPOCPersonnelEdit_Test {

    /*@method: Resource page new test method*/
    static testMethod void personnelTestNew() {
        //Setup Account
        User admin = CEE_TestUtility.getUser('admin', true);
        Account a = null;
        Opportunity o = null;
        
        System.runAs(admin){
            CEE_TestUtility.loadCustomSettings();
            CPOC_Lab_Request__c cpoclabreq = new CPOC_Lab_Request__c();
            cpoclabreq.requested_days_5_plus__c = '5+ days,<1 day';
            cpoclabreq.CPOC_Approval__c = 'CPOC_Approval';
            cpoclabreq.CPOC_Approval_Process_London__c = 'CPOC_Approval_London';
            cpoclabreq.CPOC_Approval_RTP_SYDNEY__c = 'CPOC_Approval_Process_RTP_SYDNEY';
            cpoclabreq.CPOC_RTP_Sydney__c = 'CPOC RTP,CPOC Sydney';
            cpoclabreq.CPOC_Tokyo__c =  'CPOC Tokyo';
            cpoclabreq.CPOC_Type__c = 'Submitted,Hold,Cancelled,Scheduled';
            insert cpoclabreq;
            //Get account
            a = new Account(name='Test End-User Account',CRName__c ='Test End-User Account',RECORDTYPEID='0123000000004aUAAQ',Country__c='UNITED STATES');
            insert a;
           //get opportunity
            o = CEE_TestUtility.getOpty();
            o.accountid = a.id;
            update o;
            
        }
        //Setup location
        CEE_Location__c location = new CEE_Location__c();
        location.Name = 'CPOC Bangalore';
        location.Is_Location_Active__c = 'Yes';
        location.Location_Type__c = 'CPOC';
        User primaryScheduler = CEE_TestUtility.getUser('CPOC'+'1', true);
        User secondScheduler = CEE_TestUtility.getUser('CPOC'+'2', true);
        location.Primary_Scheduler__c = primaryScheduler.id;
        location.Secondary_Scheduler__c = secondScheduler.id;
        location.Primary_Scheduler_Email__c = primaryScheduler.Email;
        location.Secondary_Scheduler_Email__c = secondScheduler.Email;
        insert location;
        
        //Setup Personnel
        Personnel__c ceepersonnel = new Personnel__c();
        ceepersonnel.CPOC_Location__c = location.id;
        ceepersonnel.User__c = primaryScheduler.id;
        insert ceepersonnel;
        
        //Setup CPOC request
        CEE__c cpocrequest = new CEE__c();
        cpocrequest.preferred_lab__c = 'CPOC Bangalore';
        cpocrequest.Service_type__c = 'Custom';
        cpocrequest.Requested_Days__c = '3 days' ;
        cpocrequest.Delivery_Type__c = 'Virtual';
        cpocrequest.Type__c = 'CPOC Managed';
        cpocrequest.Requested_customer_Arrival_Date__c = Datetime.now();
        cpocrequest.CPOC_Start_Date__c = Datetime.now();
        cpocrequest.Number_of_Cisco_Attendees__c = 3;
        cpocrequest.Number_of_Customer_Attendees__c = 3;
        cpocrequest.Number_of_Partner_Attendees__c = 3;
        cpocrequest.Primary_Architecture__c = 'Collaboration';
        cpocrequest.Key_Technology__c = 'Conferencing';
        cpocrequest.SE_Email__c = 'prjangid@cisco.com';
        cpocrequest.SE_Manager_Email__c = 'prjangid@cisco.com';
        cpocrequest.Additional_Email_IDs__c = 'prjangid@cisco.com';
        cpocrequest.Test_Objectives__c = 'Test Data Objectives';
        cpocrequest.Opportunity__c = o.id;
        cpocrequest.Primary_Account__c = a.id;
        cpocrequest.request_status__c = 'Saved, not Submitted';
        test.starttest(); 
        //Record type
                RecordType ceeType = null;
                try{
                     ceeType = [select Id from RecordType where DeveloperName = 'Customer_Proof_Of_Concept_CPOC' and SobjectType = 'CEE__c'];
                     cpocrequest.RecordTypeId = ceeType.Id;
                } catch (Exception e){
                    System.debug('getBriefing - Error fetching record types - ' + e.getStackTraceString());
                }            
        insert cpocrequest;

        //TEST = setup cpoc Room   
        CPOC_Personnel__c cpocpersonnel = new CPOC_Personnel__c();
        cpocpersonnel.CPOC_End_date__c = Datetime.now() + 1;
        cpocpersonnel.CPOC_Start_Date__c = Datetime.now();
        cpocpersonnel.Customer_Engagements_Events__c = cpocrequest.id;
        cpocpersonnel.Personnel__c = ceepersonnel.id;
        insert cpocpersonnel;
         
        
        ApexPages.StandardController stdItem = new ApexPages.StandardController(cpocpersonnel);
        CPOC_PersonnelEditController personnelController = new CPOC_PersonnelEditController(stdItem);
        
        //Utility methods
        personnelController.getPersonnelOptions();
        personnelController.returnPersonalAvaibilityStatus();
        personnelController.doCancel();
        
        //Save
        personnelController.doSave();
      
        try{
        CPOC_Personnel__c cpoc1 = new CPOC_Personnel__c(Customer_Engagements_Events__c = cpocrequest.Id);
        ApexPages.StandardController stdItem1 = new ApexPages.StandardController(cpoc1);
        CPOC_PersonnelEditController personnelController1 = new CPOC_PersonnelEditController(stdItem1);
        personnelController1.getPersonnelOptions();
        personnelController1.doSave();
        personnelController1.selPersonnel = ceepersonnel.id;
        personnelController1.doSave();
        }Catch(Exception e){
        System.debug('Exception Caught' + e);
    }
    }
}