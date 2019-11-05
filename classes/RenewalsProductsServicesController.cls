public with sharing class RenewalsProductsServicesController {
 /*
Apex Controller used for Lightning components on Product & Service tab
*/   
    
    /*
@ Created /Modified : Feb 07,2019
* @description : Method to get All Products and Services for Corresponding Opportunity
* @param : optyId, productCode
* @return : If data is available return list All Products and Services for Corresponding Opportunity
*/
    @AuraEnabled
    public static ProductServiceResponse getProductandServices(Id optyId,String productCode) {
        
        ProductServiceResponse response = new ProductServiceResponse();
        List<OpportunityLineItem> lstproduct = new List<OpportunityLineItem>();
        List<OpportunityLineItem> lstservice = new List<OpportunityLineItem>();
        ObjectRecordTypeIds__c objRecordTypeSetting = ObjectRecordTypeIds__c.getOrgDefaults();
        String opptyRenewalRecordTypeId = objRecordTypeSetting.Opportunity_Renewal_RecordTypeId__c;
        if (productCode == 'Technology') {
            try{
                lstproduct = [SELECT Business_Entity__c,Product2.Sub_Business_Entity_Name__c,Product_Family__c,convertCurrency(Expected_TCV__c), convertCurrency(Prior_TCV__c) , convertCurrency(Expected_ATR__c) ,convertCurrency(Prior_ATR__c), Term_in_Months__c, Prior_Term__c,Product_Family_Service_Level_Recurring__c , Attrition_reason_code__c, convertCurrency(Total_Attrition__c) FROM OpportunityLineItem WHERE OpportunityId = :optyId and  ProductCode = 'Technology' order by Expected_TCV__c desc];
            }catch(Exception ex) {
                system.debug('Exception getting list of products : '+ ex);
                return NULL;
            }
            
            if(! lstproduct.isEmpty()){ 
                response.lstopptyProducts = lstproduct;  
                response = prdservAggregation(lstproduct,response,'Product');
                response.aggregateCount = getCounts(optyId,'Technology');
            }
        }
        if (productCode == 'Service') {
            try{  
                lstservice = [SELECT Product2.Service_Category__c, Product2.Service_Program__c, Product2.Service_Level_1__c,Service_Level__c,Service_Level_Ref__r.Name, Product2.Service_Level_Name_1__c, convertCurrency(Expected_TCV__c), convertCurrency(Prior_TCV__c), convertCurrency(Expected_ATR__c),convertCurrency(Prior_ATR__c),Term_in_Months__c,Prior_Term__c,Product_Family_Service_Level_Recurring__c, Attrition_reason_code__c, convertCurrency(Total_Attrition__c) FROM OpportunityLineItem WHERE OpportunityId = :optyId and ProductCode = 'Service' order by Expected_TCV__c desc];
            }catch(Exception ex) {
                system.debug('Exception getting list of services : '+ ex);
                return NULL;
            }
            
            if(! lstservice.isEmpty()){ 
                response.lstopptyServices = lstservice;
                response = prdservAggregation(lstservice,response,'Service');
                response.aggregateCount = getCounts(optyId, 'Service');
            }
        }
        return response;
    }
    
    /*
@ Created /Modified : Feb 07,2019
* @description : Method to get for Aggregations of Product & Services
* @param : List of lstlineitem, ProductServiceResponse,aggType
* @return : If data is available return map of all prod and service aggregations
*/
    
    public static ProductServiceResponse prdservAggregation(List<OpportunityLineItem> lstlineitem, ProductServiceResponse response, String aggType) {
        System.debug('lstlineitem==>'+lstlineitem);
        Map<String,Decimal> aggMap = new Map<String,Decimal>();
        Set<String> offers = new Set<String>();
        Set<String> servTech = new Set<String>();
        aggMap.put('ExpTCV',0);
        aggMap.put('PriorTCV',0);
        aggMap.put('ExpATR',0);
        aggMap.put('PriorATR',0);
        aggMap.put('ATTR',0);
        aggMap.put('ExpectedTerm',0);
        aggMap.put('PriorTerm',0);
        for(OpportunityLineItem opplineitem: lstlineitem){
            if(aggMap.containsKey('ExpTCV') && opplineitem.Expected_TCV__c!=null)
                aggMap.put('ExpTCV',(aggMap.get('ExpTCV') + opplineitem.Expected_TCV__c/1000));
            
            if(aggMap.containsKey('PriorTCV') && opplineitem.Prior_TCV__c!=null)
                aggMap.put('PriorTCV',(aggMap.get('PriorTCV') + opplineitem.Prior_TCV__c/1000));
            
            if(aggMap.containsKey('ExpATR') && opplineitem.Expected_ATR__c!=null)
                aggMap.put('ExpATR',(aggMap.get('ExpATR') + opplineitem.Expected_ATR__c/1000));
            
            if(aggMap.containsKey('PriorATR') && opplineitem.Prior_ATR__c!=null)
                aggMap.put('PriorATR',(aggMap.get('PriorATR') + opplineitem.Prior_ATR__c/1000));
            
            if(aggMap.containsKey('ATTR') && opplineitem.Total_Attrition__c!=null)
                aggMap.put('ATTR',(aggMap.get('ATTR') + opplineitem.Total_Attrition__c/1000));
            
            if(aggMap.containsKey('ExpectedTerm') && opplineitem.Term_in_Months__c!=null)
                aggMap.put('ExpectedTerm',(aggMap.get('ExpectedTerm') + opplineitem.Term_in_Months__c));
            
            if(aggMap.containsKey('PriorTerm') && opplineitem.Prior_Term__c!=null)
                aggMap.put('PriorTerm',(aggMap.get('PriorTerm') + opplineitem.Prior_Term__c));
            
            if(aggType=='Service' && opplineitem.Product2.Service_Level_1__c!=null){
                offers.add(opplineitem.Product2.Service_Level_1__c);
            }
            if(aggType=='Service' && opplineitem.Service_Level_Ref__r.Name!=null){
                servTech.add(opplineitem.Service_Level_Ref__r.Name);
            }
            
        }
        aggMap.put('servDescOfferCount',offers.size());
        aggMap.put('servTechCount',servTech.size());
        system.debug('aggMap-->'+aggMap);
        if(aggType=='Product')
            response.mapopptyProductsAgg=aggMap;
        if(aggType=='Service')
            response.mapopptyServicesAgg=aggMap;
        return response;
    }
    
    /*
@ Created /Modified : Feb 07,2019
* @description : Wrapper for Product List,Service List, Product Aggregations, Service Aggregations
* @return : Wrapper ProductServiceResponse
*/
    public class ProductServiceResponse{
        @AuraEnabled
        public List<OpportunityLineItem> lstopptyProducts {get;set;}
        @AuraEnabled
        public List<OpportunityLineItem> lstopptyServices {get;set;}
        @AuraEnabled
        public Map<String,Decimal>   mapopptyProductsAgg {get;set;} 
        @AuraEnabled
        public Map<String,Decimal>   mapopptyServicesAgg {get;set;}  
        
        @AuraEnabled
        public List<AggregateResult> aggregateCount {get;set;}
        
        public ProductServiceResponse(){
            lstopptyServices = new List<OpportunityLineItem>();
            lstopptyProducts = new List<OpportunityLineItem>();
            
            
            mapopptyProductsAgg = new Map<String,Decimal>();
            mapopptyServicesAgg = new Map<String,Decimal>();
            
            aggregateCount = new List<AggregateResult>();
        }
    }
    
    /*
@ Created /Modified : Feb 07,2019
* @description : Method to get count of few Product & Services fields
* @param : Opporunity Id, productCode
* @return : If data is available return list of Aggregate Result
*/
    
    @AuraEnabled
    public static list<AggregateResult> getCounts(Id optyId, string productCode) {
        list<AggregateResult> results = [select count_distinct(Business_Entity__c) Business_Entity__c, count_distinct(Product_Family__c) Product_Family__c,count_distinct(Product2.Sub_Business_Entity_Name__c) Sub_Business_Entity_Name__c,count_distinct(Product2.Service_Category__c) Service_Category__c from OpportunityLineItem where OpportunityId = :optyId and ProductCode = :productCode];
        return results;
    }
    
    /*
@ Created /Modified : Feb 07,2019
* @description : Method to get Product & Services ATR Graph Data
* @param : Opporunity Id
* @return : If data is available return list of Aggregate Result for Graph
*/
    
    @AuraEnabled
    public static AggregateResult[] getProductServiceATRGraphData(Id opportunityId){
        AggregateResult[] queryResult = [select Business_Entity__c,ProductCode, sum(Expected_ATR__c) expected_atr, sum(Prior_ATR__c) prior_atr from OpportunityLineItem where Opportunity.Id = :opportunityId group by Business_Entity__c, ProductCode];
        return queryResult;
    }
    
    
}