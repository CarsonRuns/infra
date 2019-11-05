@isTest
private class CPOC_LoadBalanceController_Test {
    
    /*@method: Load Balance VF page tests*/
    private static testMethod void cpocLoadBalanceTest() {
        //Variables
        String testRoot = null, testEnv = null;
        
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
            
            CPOC_Primary_Architecture__c cpocarchitecture1 = new CPOC_Primary_Architecture__c(Architecture_Colour_Code__c = 'lightgreen',Name='Collaboration');
            CPOC_Primary_Architecture__c cpocarchitecture2 = new CPOC_Primary_Architecture__c(Architecture_Colour_Code__c = 'yellow',Name='Data Center / Virtualization');
            CPOC_Primary_Architecture__c cpocarchitecture3 = new CPOC_Primary_Architecture__c(Architecture_Colour_Code__c = 'lightpink',Name='Enterprise Networking');
            CPOC_Primary_Architecture__c cpocarchitecture4 = new CPOC_Primary_Architecture__c(Architecture_Colour_Code__c = 'orange',Name='Security');
            CPOC_Primary_Architecture__c cpocarchitecture5 = new CPOC_Primary_Architecture__c(Architecture_Colour_Code__c = 'LightBlue',Name='Service Provider');
            CPOC_Primary_Architecture__c cpocarchitecture6 = new CPOC_Primary_Architecture__c(Architecture_Colour_Code__c = '#CCCCCC',Name='WeekEnd');           
            insert cpocarchitecture1;
            insert cpocarchitecture2;
            insert cpocarchitecture3;
            insert cpocarchitecture4;
            insert cpocarchitecture5;
            insert cpocarchitecture6;
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
        CEE_Room__c ceeroom = new CEE_Room__c();
        ceeroom.CEE_Location__c = location.id;
        ceeroom.Name = 'Test Room';
        ceeroom.Email_Code__c = 'test email';
        insert ceeroom;
        
        //Setup Resources
        CPOC_All_Shared_Resources__c resource = new CPOC_All_Shared_Resources__c();
        resource.Resource_Name__c = 'ACI';
        resource.CPOC_Location__c = location.id;
        insert resource;
        
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
         
        //Record type
                RecordType ceeType = null;
                try{
                     ceeType = [select Id from RecordType where DeveloperName = 'Customer_Proof_Of_Concept_CPOC' and SobjectType = 'CEE__c'];
                     cpocrequest.RecordTypeId = ceeType.Id;
                } catch (Exception e){
                    System.debug('getBriefing - Error fetching record types - ' + e.getStackTraceString());
                }            
        insert cpocrequest;
        cpocrequest.request_status__c = 'Scheduled';
        update cpocrequest;
        //TEST = setup cpoc Room   
        CPOC_Room__c cpocroom = new CPOC_Room__c();
        cpocroom.CPOC_End_date__c = Datetime.now() + 1;
        cpocroom.CPOC_Start_Date__c = Datetime.now();
        cpocroom.Customer_Engagements_Events__c = cpocrequest.id;
        cpocroom.Room__c = ceeroom.id;
        insert cpocroom;
        
        //TEST = setup cpoc Shared Resources   
        CPOC_Shared_Resource__c cpocresource = new CPOC_Shared_Resource__c(); 
        cpocresource.CPOC_All_Shared_Resource__c = resource.id;
        cpocresource.Customer_Engagements_Events__c = cpocrequest.id; 
        cpocresource.CPOC_Start_Date__c = Datetime.now() +1;
        cpocresource.CPOC_End_date__c = Datetime.now() +2;
        insert cpocresource; 
        
        //TEST = setup cpoc Personnel   
        CPOC_Personnel__c cpocpersonnel = new CPOC_Personnel__c();
        cpocpersonnel.CPOC_End_date__c = Datetime.now() + 1;
        cpocpersonnel.CPOC_Start_Date__c = Datetime.now();
        cpocpersonnel.Customer_Engagements_Events__c = cpocrequest.id;
        cpocpersonnel.Personnel__c = ceepersonnel.id;
        insert cpocpersonnel;
        
        test.starttest();
        ApexPages.StandardController stdItem = new ApexPages.StandardController(cpocrequest);
        CPOC_LoadBalanceController balanceController = new CPOC_LoadBalanceController(stdItem);
        
        balanceController.getPersonalAvailability();
        balanceController.getCPOCRoomAvailability();
        balanceController.getCPOCSharedResourceAvailability();
        balanceController.getCPOCRequestAvailability();
        balanceController.getAllColourCodes();
        
        //Get classes
        CPOC_LoadBalanceController.Header testHeader = new CPOC_LoadBalanceController.Header();
        CPOC_LoadBalanceController.PMAvailability testPM1 = new CPOC_LoadBalanceController.PMAvailability();
        
        //Get utility methods
        List<CPOC_LoadBalanceController.Header> headers = balanceController.getHeaders();
        
        List<SelectOption> month = balanceController.getDynMonth();
        List<SelectOption> sites = balanceController.getDynSite();
        
        Test.stopTest();
    }
}