/************************************************************************************************************************************
Name    : BreadCrumbApex
Author  : C360 Dev team
Purpose : Contains logic to execute on Breadcrumbs Component
Date    : 24/01/2019
Change History : none
*************************************************************************************************************************************/
public class breadcrumbApex {
 @AuraEnabled
    public static List<Offer__c> fetchOffer(Id OfferIds) {        
        List<Offer__c> myBreadcrumbs = [SELECT Id,Name,Annual_Recurring_Revenue_ARR__c,Tier_Support__c,Term_Length__c,Next_Contract_Renewal_Date__c,Customer_Name__r.Id,Customer_Name__r.Name from Offer__c where Id =:OfferIds]; 
        return myBreadcrumbs;  
    }
}