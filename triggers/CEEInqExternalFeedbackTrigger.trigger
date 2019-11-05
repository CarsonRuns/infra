/************************************************************************************************************
Name    : CEEInqExternalFeedbackTrigger
Author  : Priyanka Jangid
Purpose : This is a Trigger for updating the Inquisium survey feedbacks to Customer Feedback object and CEE Account Team Feedback object .
Created Date: 11/4/2016
Modification History:  Trigger for updating the Inquisium survey feedbacks to CEE Account Team Feedback object.
Modification History:  4th April 2017 -Trigger for updating the Inquisium survey feedbacks to PXS Account Team Feedback object.
*************************************************************************************************************/

 trigger CEEInqExternalFeedbackTrigger on CEE_Inquisium_Survey_External_FeedBack__c (after Insert){  
    list<CEE_Customer_Feedback__c> lstUpdate = new list<CEE_Customer_Feedback__c>(); 
    list<CEE_Account_Team_Feedback__c> lstAccUpdate = new list<CEE_Account_Team_Feedback__c>();
     list<PXS_Account_Team_Feedback__c> lstPXSAccUpdate = new list<PXS_Account_Team_Feedback__c>();
         for(CEE_Inquisium_Survey_External_FeedBack__c c:trigger.new){
             if(c.CEC_ID__c != '' && c.CEC_ID__c != null){
             if(c.Recommendation_Score__c != '' && c.Recommendation_Score__c != null){
                 CEE_Account_Team_Feedback__c atf= new CEE_Account_Team_Feedback__c();
                 atf.Name__c = c.First_and_Last_Name__c;
                 atf.CEC_ID__c = c.CEC_ID__c;
                 atf.CEE__c = c.CEE__c;
                 atf.NPS_Rating__c = c.Recommendation_Score__c;
                 atf.Reason_for_NPS_Rating__c = c.Recommendation_Feedback__c;
                 atf.Customer_Confidence_Increase__c= c.Confidence_Level__c;
                 atf.Attributed_to_CPOC_in_Closing_Deal__c= c.Attributed_to_CPOC_in_Closing_Deal__c;
                 atf.Reduction_in_Sales_Cycle_using_CPOC__c= c.Reduction_in_Sales_Cycle_using_CPOC__c;
                 atf.Hrs_Saved_CPOC_vs_1st_time_Demo_Setup__c= c.Average_Hours_Saved_Using_CPOC__c;
                 atf.DLP_order_Mgmt_Time_Saved_in_Days__c= c.DLP_Order_Managment_Time_Saved_in_Days__c;
                 atf.Estimated_Spend_on_DLP_K_USD__c= c.Estimated_Spend_on_DLP_k_USD__c;
                 atf.CPOC_helped_create_addtl_Opportunities__c= c.CPOC_Created_Additional_Opportunities__c;
                 atf.Additional_Feedback__c= c.Additional_Feedback__c;
                 atf.Attributed_to_CXC_in_Closing_Deal__c= c.Attributed_to_CXC_in_Closing_Deal__c;
                 atf.Accelerate_Sales_Cycle_Virtual_Remote__c= c.Accelerate_Sales_Cycle_Virtual_Remote__c;
                 atf.Reduction_in_sales_cycle_using_CXC__c= c.Reduction_in_sales_cycle__c;
                 atf.Hours_Saved_using_CXC_vs_First_time_Demo__c= c.Hours_Saved_using_CXC_vs_First_time_Demo__c;
                 atf.CXC_helped_to_create_addl_opportunities__c= c.Improvement_Opportunity__c;
                 atf.Additional_Opportunity_Details__c = c.Additional_Opportunity_Details__c;
                 lstAccUpdate.add(atf); 
                  }
                 }
               
            //Updating the code for PXS Account team feedback
            else if((c.Recommendation_Score__c!= '' && c.Recommendation_Score__c!= null) && (c.Your_Role__c!=''&& c.Your_Role__c!= null)){ 
                PXS_Account_Team_Feedback__c ptf= new PXS_Account_Team_Feedback__c();
                 ptf.Case__c=c.CEE__c;
                 system.debug('..........'+ptf.Case__c);
                 ptf.Name__c = c.First_and_Last_Name__c;
                 ptf.Your_Role__c=c.Your_Role__c;
                 ptf.NPS_Rating__c = c.Recommendation_Score__c;
                 ptf.Reason_for_NPS_Rating__c = c.Recommendation_Feedback__c;
                 ptf.Additional_Feedback__c= c.Additional_Feedback__c;
                 ptf.Attributed_to_Bid_Mgmt_in_Closing__c= c.Attributed_to_Bid_Mgmt_in_Closing__c;
                 ptf.Average_hours_saved_using_Bid_Mgmt__c= c.Average_hours_saved_using_Bid_Mgmt__c;
                 ptf.Reduction_in_Sales_Cycle_using_Bid_Mgmt__c= c.Reduction_in_Sales_Cycle_using_Bid_Mgmt__c;
                 ptf.Service_Satisfaction_level__c= c.Service_Satisfaction_level__c;
                 lstPXSAccUpdate.add(ptf); 
                  }
           else if(c.Recommendation_Score__c != ''&& c.Recommendation_Score__c != null) {
                 CEE_Customer_Feedback__c ccf= new CEE_Customer_Feedback__c();
                 ccf.CEE__c = c.CEE__c;
                 ccf.Cisco_Improvement_Opportunity__c = c.Cisco_Improvement_Opportunity__c;
                 ccf.Confidence_Level__c = c.Confidence_Level__c;
                 ccf.Content_Score__c = c.Content_Score__c;
                 ccf.Customer_Experience__c = c.Customer_Experience__c; 
                 ccf.Email_Address__c = c.Email_Address__c;
                 ccf.First_and_Last_Name__c = c.First_and_Last_Name__c; 
                 ccf.Improvement_Opportunity__c = c.Improvement_Opportunity__c;
                 ccf.Recommendation_Feedback__c = c.Recommendation_Feedback__c;
                 ccf.Recommendation_Score__c = c.Recommendation_Score__c;
                 ccf.Speaker_Feedback__c = c.Speaker_Feedback__c;
                 ccf.Presenter_Feedback__c = c.Presenter_Feedback__c;
                 lstUpdate.add(ccf);
            }
         }
         if(!lstUpdate.isEmpty())
            insert lstUpdate;
         if(!lstAccUpdate.isEmpty())
             insert lstAccUpdate;
         if(!lstPXSAccUpdate.isEmpty())
             insert lstPXSAccUpdate;
             
             
             }