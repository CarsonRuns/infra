/************************************************************************************************************************************
Name    : MyPartnerContactController
Author  : C360 Dev team
Purpose : Contains logic to execute on fetching opportunities to display on renewals opportunity Component
Date    : 24/01/2019
Change History : none
*************************************************************************************************************************************/
public class RenewalsUpcoming {
    // Method to fetch the Upcoming renewals

    @AuraEnabled
    public static List<Opportunity> fetchRenewals() {        
        List<Opportunity> RenewalData = [SELECT Id,AccountId,Account.Name,Account.Available_to_Renew__c,Name FROM Opportunity where Recordtype.Name like '%Renewals%'];         
        return RenewalData ;  
    }
}