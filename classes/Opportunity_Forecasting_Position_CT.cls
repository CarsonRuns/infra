public class Opportunity_Forecasting_Position_CT{
    public Opportunity oppty{get;set;}
    public boolean redirectTechnology{get;set;}
    public boolean redirectService{get;set;}
    public boolean hasForecastingPosition{get;set;}
    
    // SCAVA FIX , CONVERT BOOLEAN INTO STRING   
    @TestVisible
    public String redirectTechnology1{
    get{
       redirectTechnology1 =(redirectTechnology)? 'true' : 'false';
       return redirectTechnology1 ;
    }
   public set;
    }
    
    // SCAVA FIX , CONVERT BOOLEAN INTO STRING    
    @TestVisible
    public String redirectService1{
    get{
       redirectService1 = (redirectService)? 'true' : 'false';
       return redirectService1 ;
    }
    private set;
    }
    
    // SCAVA FIX , CONVERT BOOLEAN INTO STRING
    @TestVisible
    public String  hasForecastingPosition1{
    get{
        hasForecastingPosition1 = (hasForecastingPosition)? 'true' : 'false';
        return hasForecastingPosition1 ;
    }
    private set;
    }   
    
    
    public Opportunity_Forecasting_Position_CT(ApexPages.StandardController stdController) {    
        this.oppty = [select id, Expected_Service__c, Expected_Product__c, Service_Total_Mix__c, Technology_Total_Mix__c, Position__c 
                        from Opportunity 
                       where id=:stdController.getRecord().Id];
        this.redirectTechnology = !OpportunityService.hasValidTechnology(oppty);
        this.redirectService = !OpportunityService.hasValidService(oppty);
        if(oppty.Position__c != null){
            this.hasForecastingPosition = true;
        } else {
            this.hasForecastingPosition = false;
        }
    }
}