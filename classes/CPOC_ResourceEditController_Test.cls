/***************************************************************************************************
Name    : CEE_AgendaRoomEditController_Test 
Author  : Eric Pesch
Purpose : Tests for the Agenda Room Edit Visualforce Page  
Created Date: Dec 1 2014
Modification History: 
Eric Pesch - Jan 5 2015: Added Comments, cleanup                     
*****************************************************************************************************/

@isTest
private class CPOC_ResourceEditController_Test {

    /*@method: Resource page new test method*/
    static testMethod void resourceTestNew() {
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
        
        //Setup Room
        CPOC_All_Shared_Resources__c resource = new CPOC_All_Shared_Resources__c();
        resource.Resource_Name__c = 'ACI';
        resource.CPOC_Location__c = location.id;
        insert resource;
        
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
        CPOC_Shared_Resource__c cpocresource = new CPOC_Shared_Resource__c(); 
        cpocresource.CPOC_All_Shared_Resource__c = resource.id;
        cpocresource.Customer_Engagements_Events__c = cpocrequest.id; 
        cpocresource.CPOC_Start_Date__c = Datetime.now() +1;
        cpocresource.CPOC_End_date__c = Datetime.now() +2;
        insert cpocresource; 
                
        ApexPages.StandardController stdItem = new ApexPages.StandardController(cpocresource);
        CPOC_ResourceEditController resourceController = new CPOC_ResourceEditController(stdItem);
        
        //Utility methods
        resourceController.getResourceOptions();
        resourceController.doCancel();
        resourceController.returnResourceAvaibilityStatus();
        
        //Save
        resourceController.doSave();
        try{
        resourceController.resourceName = '';
        resourceController.selResource = null; 
        if(cpocresource.name!=null){
        resourceController.resourceName = cpocresource.name;  
        }    
        resourceController.doSave();
        }Catch(Exception e){
        System.debug('Exception Caught' + e);
        }
        try{
        ApexPages.StandardController stdItem1 = new ApexPages.StandardController(cpocresource);
        CPOC_ResourceEditController resourceController1 = new CPOC_ResourceEditController(stdItem1);
        resourceController1.resource.id = null;
        resourceController1.doSave();
        }Catch(Exception e){
        System.debug('Exception Caught' + e);
        } 
        
        
    }
    

}