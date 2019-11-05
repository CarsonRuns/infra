/************************************************************************************************************************************
Name    : C360TestClass
Author  : C360 Dev team
Purpose : Contains logic to execute test methods of C360 - First Release
Date    : 24/01/2019
Change History : none
*************************************************************************************************************************************/
@isTest
public class C360TestClass {
static testMethod void testMethod1() 
    {
       
        Offer__c off = new Offer__C();
        off.Name ='OfferName';
        off.Offer_Level_1_Name__c='OfferName';
        off.Annual_Recurring_Revenue_ARR__c = 100000;
        off.Tier_Support__c = 'Level1';
        off.Term_Length__c = '2 Years';
        off.Next_Contract_Renewal_Date__c =system.Today();
        insert off;
        
        Offer_Task__c offtsk = new Offer_Task__c();
        offtsk.Task_Completed_Date__c = Date.newInstance(2016, 12, 9);
        offtsk.Task_Name__c = 'Test Task';
        offtsk.Task_Type__c = Offer_Task__C.Task_Type__c.getDescribe().getPicklistValues()[1].getValue();
        offtsk.Additional_Notes__c = 'Test Notes';
        offtsk.Task_Stage__c = 'Purchase';
        offtsk.Offer_Name__c =off.Id;
        insert offtsk;
        Id AccID = off.Id;
        Id AccIDT = offtsk.Id;
        date completedDate = offtsk.Task_Completed_Date__c;  
        string complDate=string.valueOf(completedDate);
        Integer a =123;
        String Stage ='Purchase';
        string nextstage='Onboard';
        String onloadStage = offtsk.Task_Stage__c;
        String NullString ='';
        String inNum ='0';
        String inNum1 ='1';
        String inNum2 ='2';
        String inNum3 ='3';
        boolean flag =True;
        String objapi='Offer_Stages__c';
        String obj='Offer__c';
    
        Test.startTest();
        List<Id> offerId = new List<Id>();
        offerId.add(off.Id);
        
       // MyPartnerContactController.getContactList(offerId);
        breadcrumbApex.fetchOffer(off.Id);
        // breadcrumbApex.fetchBUAccount(AccID);
       // DocumentRollUpController.fetchDocumentList(off.Id);
        RenewalsUpcoming.fetchRenewals();
       // PipelineOpportunity.fetchPipelineOpp(AccID,'CloseDate',True);
       // PipelineOpportunity.fetchParentPipelineOpp(AccID);
      //  PipelineOpportunity.totalOpportunity();
       // PipelineOpportunity.formatCurr2(a);
       /* OfferKanban offerK= new OfferKanban();
        OfferKanban.activities(AccID,Stage);
        OfferKanban.exitCriteria(AccID,Stage);
        OfferKanban.getActivity(AccIDT);
        OfferKanban.saveActivity(AccIDT,complDate,Stage);
        MarkStageAsComplete.TaskDescription(AccID,Stage);
        MarkStageAsComplete.SaveOffer(AccID,nextstage,inNum,onloadStage);
        MarkStageAsComplete.SaveOffer(AccID,nextstage,inNum1,onloadStage);
        MarkStageAsComplete.SaveOffer(AccID,nextstage,inNum2,onloadStage);
        MarkStageAsComplete.SaveOffer(AccID,nextstage,inNum3,onloadStage);
        MarkStageAsComplete.getPicklistvalues(obj,objapi,flag);   */
        Test.stopTest(); 
      
    }
}