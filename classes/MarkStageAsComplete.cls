/************************************************************************************************************************************
Name    : MarkStageAsComplete
Author  : C360 Dev team
Purpose : Contains logic to execute Mark Stage as Complete button Component on OfferKanban Component
Date    : 21/01/2019
Change History : none
*************************************************************************************************************************************/
public class MarkStageAsComplete {
    
     @AuraEnabled
    public static List<Task> TaskDescription(Id OfferIds,String TaskStage){
        //Below code will execute to get all Offer Task Data
        List<Task> offerTasks = [SELECT Id,Task_Name__c,Task_Stage__c,DateCompleted__c FROM Task where WhatId =:OfferIds AND Task_Stage__c =: TaskStage];
        return offerTasks;

    }
    
    @AuraEnabled
    public static Offer__c SaveOffer(Id OfferId, String nextStage, String indexStage, String onloadStage){
       //Code to populate Max of Task Completed Date onto Milestone Section Date Field after thier respective stages closed
        Offer__c offer = new Offer__c();
        offer.Id = OfferId;
        Date lastExitCriteriaDate = [SELECT Id, DateCompleted__c  
                                          FROM Task 
                                          where WhatId =:OfferId AND Task_Stage__c =: onloadStage AND Task_Type__c='EXIT CRITERIA'
                                          ORDER BY DateCompleted__c DESC
                                          LIMIT 1].DateCompleted__c;
       
        if(indexStage == '0'){
            offer.Purchase_Timestamp__c = lastExitCriteriaDate;
        }else if(indexStage == '1'){
            offer.Onboard_Timestamp__c = lastExitCriteriaDate;
        }
        else if(indexStage == '2'){
            offer.Implement_Timestamp__c = lastExitCriteriaDate;
        }
        else if(indexStage == '3'){
            offer.Use_Timestamp__c = lastExitCriteriaDate;
        }
        else if(indexStage == '4'){
            offer.Engage_Timestamp__c = lastExitCriteriaDate;
        }
        else if(indexStage == '5'){
            offer.Adopt_Timestamp__c = lastExitCriteriaDate;
        }
        else if(indexStage == '6'){
            offer.Optimize_Timestamp__c = lastExitCriteriaDate;
        }
        else if(indexStage == '7'){
            offer.Advocate_Timestamp__c = lastExitCriteriaDate;
        }
        
        offer.Offer_Stages__c = nextStage;
        offer.TECH_isOfferCanBeUpdated__c = TRUE;
        
        Datetime now = Datetime.now();
        Integer offset = UserInfo.getTimezone().getOffset(now);
        Datetime local = now.addSeconds(offset/1000);
        
        offer.TECH_Last_Modified_Stage_Date__c  = local;
        
        update offer;
        
        //To be fixed 
        offer.TECH_isOfferCanBeUpdated__c = false;
        update offer;
        return offer;
    }
    
      @AuraEnabled
    public static List<String> getPicklistvalues(String objectName, String field_apiname,Boolean nullRequired){
        //Method to get the Picklist values from offer object
        List<String> optionlist = new List<String>();
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        Map<String, Schema.SObjectField> field_map = gd.get(objectName.toLowerCase()).getDescribe().fields.getMap(); 
        
        List<Schema.PicklistEntry> picklistValues = field_map.get(field_apiname).getDescribe().getPickListValues();
        
        if(nullRequired == true){
            optionlist.add('--None--');
        }
        
        for (Schema.PicklistEntry pv : picklistValues) {
            optionlist.add(pv.getValue());
        }
        return optionlist;
    }
}