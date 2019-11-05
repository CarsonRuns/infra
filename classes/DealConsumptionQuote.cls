public class DealConsumptionQuote{
    public Opportunity oppty {get; protected set;}
    public Id opptyid ;
    public DealConsumptionQuote(ApexPages.StandardSetController controller) {
    }
    public string dealConsumptionURL {get;set;}
      
    public DealConsumptionQuote(ApexPages.StandardController stdController) {}
    public void init() { 
           opptyid = ApexPages.currentPage().getParameters().get('id');
           dealConsumptionURL = Utilities.getConstant_CS('PDR Deal Consumption'); //getting CCW Deal Consumption URL from Utilities class 
           try{     
           this.oppty = [SELECT Id, Name,RecordTypeId, DealID__c,ownerId,owner.Name,RecordType.Name, Opportunity_Status__c,Deal_Type__c, Quote_Count__c, Partner_Deal_Status__c, Contractual_Pricing_Letter_Opportunity__c,Account.Name,
             Partner_Expected_Book_Date__c,Expected_Product__c,Expected_Service__c,StageName,Forecast_Status__c,Forecast_Discount__c,Opportunity_Owner_AM__c,Position__c,Lost_Cancelled_Reason__c,Cisco_Capital_Financing__c,Installed_Base__c,Competitors__c FROM Opportunity WHERE Id =: opptyid  ];
             }
             Catch(Exception e){
                 System.debug('Exception at Deal Consumption Controller :'+e.getMessage());
             }
    }    
}