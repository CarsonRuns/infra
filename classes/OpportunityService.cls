public class OpportunityService{
    /**
     * Checks if an opportunity object has valid technology amount and technology line item data
     *
     * @param o Opportunity object that has Expected_Product_Amount and Technology_Total_Mix__c
     */
    public static boolean hasValidTechnology(Opportunity o){
        boolean isValid = true;
        
        System.debug('***********************OpportunityService.hasValidTechnology() Start**********************************');
        System.debug('Opportunity.ID: ' + o.Id);
        System.debug('Opportunity.Expected_Product__c: ' + o.Expected_Product__c);
        System.debug('Opportunity.Technology_Total_Mix__c : ' + o.Technology_Total_Mix__c );
        if(o.Expected_Product__c <> 0 && o.Expected_Product__c !=null && o.Technology_Total_Mix__c != 100) {
            //Opportunity has an expected product amount but the technology line items do not add up to 100
            isValid = false;
        } else if ( (o.Expected_Product__c == 0 || o.Expected_Product__c == null) && o.Technology_Total_Mix__c > 0) {
            //Technology line items exists although expected product amount is 0
            isValid = false;
        }
        System.debug('***********************OpportunityService.hasValidTechnology() End**********************************');
        
        return isValid;
    }
    
    /**
     * Checks if an opportunity object has valid service amount and service line item data
     *
     * @param o Opportunity object that has Expected_Service_Amount and Service_Total_Mix__c
     */
    public static boolean hasValidService(Opportunity o){
        boolean isValid = true;
        
        System.debug('***********************OpportunityService.hasValidTechnology() Start**********************************');
        System.debug('Opportunity.ID: ' + o.Id);
        System.debug('Opportunity.Expected_Service__c : ' + o.Expected_Service__c );
        System.debug('Opportunity.Service_Total_Mix__c : ' + o.Service_Total_Mix__c );
        if(o.Expected_Service__c <> 0 && o.Expected_Service__c !=null && o.Service_Total_Mix__c != 100){
            //Opportunity has an expected service amount but the service line items do not add up to 100
            isValid = false;
        } else if((o.Expected_Service__c == null || o.Expected_Service__c == 0) && o.Service_Total_Mix__c > 0){
            //Service line items exists although expected servuce amount is 0 or null
            isValid = false;
        }
        return isValid;
    }
}