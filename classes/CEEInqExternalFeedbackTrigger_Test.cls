/******************************************************************************************************************
Name    : CEEInqExternalFeedbackTrigger_Test
Author  : Priyanka Jangid
Purpose : Test for CEEInqExternalFeedbackTrigger  
Created Date: Nov 7 2016
Modification History:Test Class for updating the Inquisium survey feedbacks to CEE Account Team Feedback object 
Modification History:4th April 2017 - Updating the test class for Inquisium survey feedbacks for PXS Account Team Feedback object                     
*******************************************************************************************************************/
@isTest
public class CEEInqExternalFeedbackTrigger_Test{

    public static testMethod void CEEInqExtFeedbackTrigTest(){
    
        User u = CEE_TestUtility.getUser('admin', true);
        Account a = new Account();
        Opportunity  o;
        Id RecordtypeIdValue;
        System.runas(u){
            //Loading CPOC custom setting
            CEE_TestUtility.loadCustomSettings();
        
            
            
            //Get account
            a = new Account(name='Test End-User Account',CRName__c ='Test End-User Account',RECORDTYPEID='0123000000004aUAAQ',Country__c='UNITED STATES');
            insert a;
           //get opportunity
            o = CEE_TestUtility.getOpty();
            o.accountid = a.id;
            update o;
            
            
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
                
        //Get CEE Request
        CEE__c cpocrequest = new CEE__c();
        cpocrequest.preferred_lab__c = 'CPOC Bangalore';
        cpocrequest.Service_type__c = 'Custom';
        cpocrequest.Requested_Days__c = '3 days' ;
        cpocrequest.Delivery_Type__c = 'Virtual';
        cpocrequest.Type__c = 'CPOC Managed';
        cpocrequest.Requested_customer_Arrival_Date__c = Datetime.now();
        cpocrequest.CPOC_Start_Date__c = Datetime.now() - 4;
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
        
        
        //Get PXS Case Request
        Case pxsRequest = new case();
        pxsRequest.Subject='Test';
        pxsRequest.Status='New';
        pxsRequest.Case_Requester__c=u.id;
        pxsRequest.Opportunity__c=o.id;
        pxsRequest.Proposal_Due_Date__c=date.Today();
        pxsRequest.Type_of_Proposal__c='RFI';
        pxsRequest.Does_Proposal_Include_Recurring_Revenue__c='No';
        
       
        test.starttest(); 
        //Record type
              RecordType ceeType = null;
        RecordType PxsType =null;
        try{
             ceeType = [select Id from RecordType where DeveloperName = 'Customer_Proof_Of_Concept_CPOC' and SobjectType = 'CEE__c'];
             PxsType = [select Id from RecordType where DeveloperName='Proposal_Expert_Services' and SobjectType='Case'];
             cpocrequest.RecordTypeId = ceeType.Id;
             pxsRequest.RecordTypeId =PxsType .Id;
             
        } catch (Exception e){
            System.debug('getBriefing - Error fetching record types - ' + e.getStackTraceString());
        }      
        insert cpocrequest;
        insert pxsRequest;
                //Updating Dates and Location for Notes
        cpocrequest.preferred_lab__c = 'CPOC Tokyo';
        cpocrequest.Customer_Start_date__c= Datetime.now() + 1;
        cpocrequest.Account_team_arrival_date__c = Datetime.now() + 1;
        cpocrequest.Requested_Customer_Arrival_Date__c = Datetime.now() + 1;
        cpocrequest.CPOC_Start_Date__c= Datetime.now() + 1;
        cpocrequest.CPOC_End_Date__c=Datetime.now() + 2;
        cpocrequest.Service_type__c = 'Pre-Built static test';
        cpocrequest.Requested_Days__c = '3 days' ;
        cpocrequest.Delivery_Type__c = 'Insite';
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
        
        
         CEE_Inquisium_Survey_External_FeedBack__c ccf = new CEE_Inquisium_Survey_External_FeedBack__c();
         ccf.CEE__c = cpocrequest.id;
         ccf.Cisco_Improvement_Opportunity__c = 'Great Experience';
         ccf.Confidence_Level__c = '3 -  Same confidence';
         ccf.Content_Score__c = '5 - Highly Satisfied'; 
         ccf.Email_Address__c = 'prjangid@cisco.com';
         ccf.First_and_Last_Name__c = 'Priyanka Jangid'; 
         ccf.Improvement_Opportunity__c = 'Everything is above expectation';
         ccf.Recommendation_Feedback__c = 'Good';
         ccf.Recommendation_Score__c = '7';
         ccf.Presenter_Feedback__c = 'Excellent';
         ccf.Improvement_Opportunity__c = 'Yes';
         ccf.Hours_Saved_using_CXC_vs_First_time_Demo__c = '15 hours';
         ccf.CEC_ID__c = 'hpratapd@cisco.com';
         ccf.Attributed_to_CPOC_in_Closing_Deal__c = '60%';
         ccf.Reduction_in_Sales_Cycle_using_CPOC__c = '6.5 Weeks';
         ccf.Average_Hours_Saved_Using_CPOC__c = '15 hours';
         ccf.DLP_Order_Managment_Time_Saved_in_Days__c = '13 Days';
         ccf.Estimated_Spend_on_DLP_k_USD__c = '$300-$350';
         ccf.CPOC_Created_Additional_Opportunities__c = 'Yes';
         ccf.Additional_Feedback__c = 'good';
         ccf.Additional_Opportunity_Details__c = 'good';
         ccf.Attributed_to_CXC_in_Closing_Deal__c = '70%';
         ccf.Accelerate_Sales_Cycle_Virtual_Remote__c = '70%';
         ccf.Reduction_in_sales_cycle__c = '7 Weeks';       
         insert ccf;
         //Starting--- updating the Inquisium survey feedbacks to CEE Account Team Feedback object--Harshitha
         CEE_Inquisium_Survey_External_FeedBack__c atf = new CEE_Inquisium_Survey_External_FeedBack__c();
         atf.CEE__c = cpocrequest.id;
         atf.Cisco_Improvement_Opportunity__c = 'Great Experience';
         atf.Confidence_Level__c = '3 -  Same confidence';
         atf.Content_Score__c = '5 - Highly Satisfied'; 
         atf.Email_Address__c = 'prjangid@cisco.com';
         atf.First_and_Last_Name__c = 'Priyanka Jangid'; 
         atf.Improvement_Opportunity__c = 'Everything is above expectation';
         atf.Recommendation_Feedback__c = 'Good';
         atf.Recommendation_Score__c = '7';
         atf.Presenter_Feedback__c = 'Excellent';
         atf.Improvement_Opportunity__c = 'Yes';
         atf.Hours_Saved_using_CXC_vs_First_time_Demo__c = '15 hours';
         atf.Attributed_to_CPOC_in_Closing_Deal__c = '60%';
         atf.Reduction_in_Sales_Cycle_using_CPOC__c = '6.5 Weeks';
         atf.Average_Hours_Saved_Using_CPOC__c = '15 hours';
         atf.DLP_Order_Managment_Time_Saved_in_Days__c = '13 Days';
         atf.Estimated_Spend_on_DLP_k_USD__c = '$300-$350';
         atf.CPOC_Created_Additional_Opportunities__c = 'Yes';
         atf.Additional_Feedback__c = 'good';
         atf.Additional_Opportunity_Details__c = 'good';
         atf.Attributed_to_CXC_in_Closing_Deal__c = '70%';
         atf.Accelerate_Sales_Cycle_Virtual_Remote__c = '70%';
         atf.Reduction_in_sales_cycle__c = '7 Weeks';
         insert atf;
         
         //Ending--Test for updating the Inquisium survey feedbacks to CEE Account Team Feedback object--Harshitha
        //Starting--- updating the Inquisium survey feedbacks to PXS Account Team Feedback object-- mogana
         CEE_Inquisium_Survey_External_FeedBack__c ptf = new CEE_Inquisium_Survey_External_FeedBack__c();
                 ptf.CEE__c=pxsRequest.id;
                 ptf.Your_Role__c='Account Manager';
                 ptf.Recommendation_Score__c = '10';
                 ptf.Recommendation_Feedback__c = 'Test';
                 ptf.Additional_Feedback__c= 'Good Experience';
                 ptf.Attributed_to_Bid_Mgmt_in_Closing__c= '0%';
                 ptf.Average_hours_saved_using_Bid_Mgmt__c= '5 hours';
                 ptf.Reduction_in_Sales_Cycle_using_Bid_Mgmt__c= '0 Weeks';
                 ptf.Service_Satisfaction_level__c= '2 Disagree';
                 insert ptf; 
         
        test.stoptest();
    
    }
}