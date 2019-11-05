public class P360_Multi_Quote_After_Trg_Cls{
    public static void dealCreationDateUpdateOnTP(Set<Id> setTriggerMultiQuote)
    {
        List<Assigned_Partner__c> newTPwithDeal = [Select id,Deal_Create_Date__c from Assigned_Partner__c where Id IN : setTriggerMultiQuote];
        for(Assigned_Partner__c objTP:newTPwithDeal )
        {
            objTP.Deal_Create_Date__c = System.Today(); //Setting the Todays date when Deal Created 
        }
        
        Database.SaveResult[] updateTPResult = Database.update(newTPwithDeal,false);
    }
}