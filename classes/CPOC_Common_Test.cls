@isTest
public class CPOC_Common_Test{

    public static testMethod void cpocInsertUpdate(){
    
        User u = CEE_TestUtility.getUser('admin', true);
        Account a = new Account();
        Opportunity  o;
        Id RecordtypeIdValue;
        System.runas(u){
            //Loading CPOC custom setting
            CEE_TestUtility.loadCustomSettings();
        
            CPOC_Lab_Request__c cpoclabreq = new CPOC_Lab_Request__c();
            cpoclabreq.requested_days_5_plus__c = '5+ days,<1 day';
            cpoclabreq.CPOC_Approval__c = 'CPOC_Approval';
            cpoclabreq.CPOC_Approval_Process_London__c = 'CPOC_Approval_London';
            cpoclabreq.CPOC_Approval_RTP_SYDNEY__c = 'CPOC_Approval_Process_RTP_SYDNEY';
            cpoclabreq.CPOC_RTP_Sydney__c = 'CPOC RTP,CPOC Sydney';
            cpoclabreq.CPOC_Tokyo__c =  'CPOC Tokyo';
            cpoclabreq.CPOC_Type__c = 'Submitted,Hold,Cancelled,Scheduled';
            cpoclabreq.CPOC_Data_Migration_Flag__c = 'TRUE';
            insert cpoclabreq;
            //Get account
            a = new Account(name='Test End-User Account',CRName__c ='Test End-User Account',RECORDTYPEID='0123000000004aUAAQ',Country__c='UNITED STATES');
            insert a;
           //get opportunity
            o = CEE_TestUtility.getOpty();
            o.accountid = a.id;
            update o;
        }
        
        //Get Location
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
        
        //Getting Another Location        
        CEE_Location__c location1 = new CEE_Location__c();
        location1.Name = 'CPOC London';
        location1.Is_Location_Active__c = 'Yes';
        location1.Location_Type__c = 'CPOC';
        location1.Primary_Scheduler__c = primaryScheduler.id;
        location1.Secondary_Scheduler__c = secondScheduler.id;
        location1.Primary_Scheduler_Email__c = primaryScheduler.Email;
        location1.Secondary_Scheduler_Email__c = secondScheduler.Email;
        insert location1;
        
        //Get CEE Request
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
      
        
        //Updating Dates and Location for Notes
        cpocrequest.preferred_lab__c = 'CPOC London';        
        cpocrequest.CPOC_Status__c = 'Lab Redirect';
        cpocrequest.Customer_Start_date__c= Datetime.now() + 1;
        cpocrequest.Account_team_arrival_date__c = Datetime.now() + 1;
        cpocrequest.Requested_Customer_Arrival_Date__c = Datetime.now() + 1;
        cpocrequest.CPOC_Start_Date__c= Datetime.now() + 1;
        cpocrequest.CPOC_End_Date__c=Datetime.now() + 2;
        cpocrequest.Service_type__c = 'Pre-Built static test';
        cpocrequest.Requested_Days__c = '3 days' ;
        cpocrequest.Delivery_Type__c = '@CPOC';
        update cpocrequest;
                
        //Getting CEE Room
        CEE_Room__c room = new CEE_Room__c();
        room.Name = 'Customer Test Room 1';
        room.CEE_Location__c = location.id;
        room.Active__c = TRUE;
        room.Email_Code__c = 'prjangid@cisco.com';
        insert room;
        
        //Getting CPOC Room
        CPOC_Room__c cpocroom =  new CPOC_Room__c();
        cpocroom.Room__c = room.id;
        cpocroom.Customer_Engagements_Events__c = cpocrequest.id;
        cpocroom.CPOC_Start_Date__c = Datetime.now() +1;
        cpocroom.CPOC_End_date__c = Datetime.now() +2;
        insert cpocroom;
        
        //Getting Personnel
        Personnel__c  personnel = new Personnel__c();
        Personnel.CPOC_Location__c = location.id;
        Personnel.Is_Active__c = TRUE;
        personnel.User__c = primaryScheduler.id;
        insert personnel;
        
        //Getting CPOC Personnel
        CPOC_Personnel__c cpocpersonnel = new CPOC_Personnel__c();
        cpocpersonnel.Personnel__c = personnel.id;
        cpocpersonnel.Customer_Engagements_Events__c = cpocrequest.id; 
        cpocpersonnel.CPOC_Start_Date__c = Datetime.now() +1;
        cpocpersonnel.CPOC_End_date__c = Datetime.now() +2;
        insert cpocpersonnel;
        
        //Getting All Shared Resources
        CPOC_All_Shared_Resources__c resource = new CPOC_All_Shared_Resources__c();
        resource.Resource_Name__c = 'ACI';
        resource.CPOC_Location__c = location.id;
        insert resource;
        
        //Getting CPOC Shared Resources
        CPOC_Shared_Resource__c cpocresource = new CPOC_Shared_Resource__c();
        cpocresource.CPOC_All_Shared_Resource__c = resource.id;
        cpocresource.Customer_Engagements_Events__c = cpocrequest.id; 
        cpocresource.CPOC_Start_Date__c = Datetime.now() +1;
        cpocresource.CPOC_End_date__c = Datetime.now() +2;
        insert cpocresource;
        
        //Approve the Request
        Approval.ProcessWorkitemRequest req1 = new Approval.ProcessWorkitemRequest();
        req1.setComments('Approving request using Trigger');
        req1.setAction('Approve');
        Id retVal1;
        for(ProcessInstanceWorkitem workItem1  : [Select p.Id from ProcessInstanceWorkitem p
            where p.ProcessInstance.TargetObjectId =: cpocrequest.id])
        {
             retVal1  =  workItem1.Id;
        }
        Id workItemId1 = retVal1;
        if(workItemId1 == null)
        {
            cpocrequest.addError('Error Occured in Trigger');
        }
        else
        {
            req1.setWorkitemId(workItemId1);
            Approval.ProcessResult result1 =  Approval.process(req1);
            
        }      
        
        try{
        //Updating Dates and Location for Notes
        cpocrequest.preferred_lab__c = 'CPOC Bangalore';
        update cpocrequest;
        }Catch(Exception e){
        System.debug('Caught Exception');
        }
        
    
        
        test.stoptest();
    
    }

    public static testMethod void cpocPersonnelInsertUpdate(){
    
        User u = CEE_TestUtility.getUser('admin', true);
        Account a = new Account();
        Opportunity o;
        Id RecordtypeIdValue;
        System.runas(u){
            CEE_TestUtility.loadCustomSettings();
            
            //Getting CPOC Custom Setting
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
        
        //Getting Location
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
        
        //Getting Another Location        
        CEE_Location__c location1 = new CEE_Location__c();
        location1.Name = 'CPOC London';
        location1.Is_Location_Active__c = 'Yes';
        location1.Location_Type__c = 'CPOC';
        location1.Primary_Scheduler__c = primaryScheduler.id;
        location1.Secondary_Scheduler__c = secondScheduler.id;
        location1.Primary_Scheduler_Email__c = primaryScheduler.Email;
        location1.Secondary_Scheduler_Email__c = secondScheduler.Email;
        insert location1;
        
        //Getting CPOC Request
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
        }catch (Exception e){
            System.debug('getBriefing - Error fetching record types - ' + e.getStackTraceString());
        }     
        insert cpocrequest;
        
        //Approving Request without adding Room
        try{
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments('Approving request using Trigger');
        req.setAction('Approve');
        Id retVal;
        for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p
            where p.ProcessInstance.TargetObjectId =: cpocrequest.id])
        {
             retVal  =  workItem.Id;
        }
        Id workItemId = retVal;
        if(workItemId == null)
        {
            cpocrequest.addError('Error Occured in Trigger');
        }
        else
        {
            req.setWorkitemId(workItemId);
            Approval.ProcessResult result =  Approval.process(req);
            
         }
        }catch(Exception e){
         system.debug('Exception Caught' + e);
        }
        
        //Getting CEE Room
        CEE_Room__c room = new CEE_Room__c();
        room.Name = 'Customer Test Room 1';
        room.CEE_Location__c = location.id;
        room.Active__c = TRUE;
        room.Email_Code__c = 'prjangid@cisco.com';
        insert room;
        
        //Getting CPOC Room
        CPOC_Room__c cpocroom =  new CPOC_Room__c();
        cpocroom.Room__c = room.id;
        cpocroom.Customer_Engagements_Events__c = cpocrequest.id;
        cpocroom.CPOC_Start_Date__c = Datetime.now() +1;
        cpocroom.CPOC_End_date__c = Datetime.now() +2;
        insert cpocroom;
        
        //Getting Personnel
        Personnel__c  personnel = new Personnel__c();
        Personnel.CPOC_Location__c = location.id;
        Personnel.Is_Active__c = TRUE;
        personnel.User__c = primaryScheduler.id;
        insert personnel;
        
        //Getting CPOC Personnel
        CPOC_Personnel__c cpocpersonnel = new CPOC_Personnel__c();
        cpocpersonnel.Personnel__c = personnel.id;
        cpocpersonnel.Customer_Engagements_Events__c = cpocrequest.id; 
        cpocpersonnel.CPOC_Start_Date__c = Datetime.now() +1;
        cpocpersonnel.CPOC_End_date__c = Datetime.now() +2;
        insert cpocpersonnel;
        
        //Redirect Lab, CPOC Room and Personnel will be deleted automatically
        cpocrequest.preferred_lab__c = 'CPOC London';
        cpocrequest.CPOC_Status__c = 'Lab Redirect';
        cpocrequest.Request_Status__c = 'Lab Redirect';
        update cpocrequest;
        
        cpocrequest.CPOC_Status__c = 'Pending';        
        update cpocrequest;
        
        
        try{
        cpocrequest.CPOC_Status__c = 'Rescheduled';
        update cpocrequest; 
        }catch(Exception e){
        System.debug('Exception Caught');
        } 

        
         //Getting CPOC Room
        CPOC_Room__c cpocroom1 =  new CPOC_Room__c();
        cpocroom1.Room__c = room.id;
        cpocroom1.Customer_Engagements_Events__c = cpocrequest.id;
        cpocroom1.CPOC_Start_Date__c = Datetime.now() +1;
        cpocroom1.CPOC_End_date__c = Datetime.now() +2;
        insert cpocroom1;
        CPOC_RoomTriggerImpl cpi = new CPOC_RoomTriggerImpl();
        cpi.beforeInit();
        cpi.afterInit();
        cpi.executeUnDelete(); 
        CPOC_PersonnelTriggerImpl pi = new CPOC_PersonnelTriggerImpl();
        pi.beforeInit();
        pi.afterInit();
        pi.executeUnDelete(); 
        
        test.stoptest();
    }
}