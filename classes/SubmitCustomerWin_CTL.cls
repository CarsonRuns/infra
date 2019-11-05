public with sharing class SubmitCustomerWin_CTL {
	
	@AuraEnabled
	public static CustomerWinWrap getOpportunityDetails(String recID){
        System.debug(recID);
        CustomerWinWrap swwrap = new CustomerWinWrap();
		Opportunity opty = [select id,StageName,DealID__c from Opportunity where id =: recID limit 1];
        swwrap.url = Utilities.getConstant_CS('SalesConnectURL');
        swwrap.opty = opty;
		return swwrap;
	}
    public class CustomerWinWrap{ 
        @AuraEnabled
        public String url{get;set;}
        @AuraEnabled
        public Opportunity opty{get;set;}
    }
}