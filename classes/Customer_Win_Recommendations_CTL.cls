/*******************************************************************************************************************
Author          : Awnish Kumar
Created         : Feb 1,2019
Functionality   : Controller class for lxCustomerWinRecommendation component
-----------------------------------------------------------------------------
Modification History:
-----------------------------------------------------------------------------
Date                Author                      Change  
Mar 28,2019         Lei Zhou                    Added logic for Customer Stories
June 6,2019         Prithu Lahiri               Added Logic for Sales Presentation
*******************************************************************************************************************/
public class Customer_Win_Recommendations_CTL {
    
    @AuraEnabled
    public static SalesInsights getCustomerWinDetails(String recordId, Integer recCount){
        SalesInsights salesInsightsWrap = new SalesInsights();
        List<Customer_Win_Recommendation__c> salesInsightsLst = [select id,URL__c,BE__c,Title__c,Category__c, cwCompetitors__c,cwVertical__c,cwSegments__c  from Customer_Win_Recommendation__c  where Opportunity__c =: recordId order by Index__c asc];
       system.debug('Hello');
        if(!salesInsightsLst.isEmpty()){
            system.debug('Hello1'+salesInsightsLst);
           List<Customer_Win_Recommendation__c> salesPresentation = new List<Customer_Win_Recommendation__c>(); 
           List<Customer_Win_Recommendation__c> customerWins = new List<Customer_Win_Recommendation__c>();
           List<Customer_Win_Recommendation__c> salesHubs = new List<Customer_Win_Recommendation__c>();
           List<Customer_Win_Recommendation__c> learningMaps = new List<Customer_Win_Recommendation__c>();
           List<Customer_Win_Recommendation__c> customerStories = new List<Customer_Win_Recommendation__c>();
            
           integer cWin = 0;
           integer sHub = 0;
           integer lMap = 0;
           integer cStory = 0;
           integer sPre = 0; 
           for(Customer_Win_Recommendation__c salesInsight : salesInsightsLst){ 
                if(salesInsight.Category__c == 'Sales Presentation' && sPre < 4){  
                    salesPresentation.add(salesInsight);
                    sPre++;
               } 
              else if(salesInsight.Category__c == 'customerwins' && cWin < 2){
                    customerWins.add(salesInsight);
                    cWin++;
               }else if(salesInsight.Category__c == 'saleshub' && sHub < 2){
                    salesHubs.add(salesInsight);
                    sHub++;
                }else if(salesInsight.Category__c == 'learningmaps' && lMap < 2){
                    learningMaps.add(salesInsight);
                    lMap++;
                }else if(salesInsight.Category__c == 'customerstories' && cStory < 2){                    
                    customerStories.add(salesInsight);
                    cStory++;
               } 
              
               
            }
            if(!salesPresentation.isEmpty()){
                salesInsightsWrap.SalesPresentation = salesPresentation;
            }
            if(!customerWins.isEmpty()){
                salesInsightsWrap.customerWins = customerWins;
            }
            if(!salesHubs.isEmpty()){
                salesInsightsWrap.salesHubs = salesHubs;
            } 
            if(!learningMaps.isEmpty()){
                salesInsightsWrap.learningMaps = learningMaps;
            }
            if(!customerStories.isEmpty()){
                salesInsightsWrap.customerStories = customerStories;
            }
            
            salesInsightsWrap.count = salesInsightsLst.size();
        }else{
            salesInsightsWrap.count = 0;
        }
       
        return salesInsightsWrap;
    }
    
    @AuraEnabled
    public static Map<String,List<Customer_Win_Recommendation__c>> getCustomerWinDetailsByCategory(String recordId){
        Map<String,List<Customer_Win_Recommendation__c>> customerWinsMap = new Map<String,List<Customer_Win_Recommendation__c>>();
        List<Customer_Win_Recommendation__c> customerWins = [select id,URL__c,Title__c,Category__c,BE__c,Sub_BE__c,cwPrimary_Technology__c, cwCompetitors__c,cwAccount_Name__c,cwSegments__c,cwVertical__c,cwTheater__c, cwRegion__c from Customer_Win_Recommendation__c where Opportunity__c =: recordId order by Index__c asc];
       
        for(Customer_Win_Recommendation__c customerWin : customerWins){
            if(customerWinsMap.get(customerWin.Category__c)!=null){             
                List<Customer_Win_Recommendation__c> existingCustomerWins = customerWinsMap.get(customerWin.Category__c);
                existingCustomerWins.add(customerWin);
                customerWinsMap.put(customerWin.Category__c,existingCustomerWins);
            }else{
                List<Customer_Win_Recommendation__c> newCustomerWins = new List<Customer_Win_Recommendation__c>();
                newCustomerWins.add(customerWin);
                customerWinsMap.put(customerWin.Category__c,newCustomerWins);
            }
        }
        return customerWinsMap;
    }
    
    @AuraEnabled
    public static Map<String,String> preValidations(String recordId){
        system.debug('Inside Prevalidation');
        Log_Headers__c[] listOfp2Ids=[Select Product2Ids__c,productFamilyids__c from Log_Headers__c where Opportunity__c=:recordId Order by createdDate Desc limit 1];
        List<OpportunityLineItem>optyLineItem=[Select Product2Id,PriceBookEntry.Product2.Business_Entity__c,Product_Family__c,PriceBookEntry.Product2.Sub_Business_Entity__c,opportunity.Competitors__c,opportunity.Account.VMTOP__c,opportunity.Account.LineofBusiness__c,opportunity.Account.Theatre__c,Product_Family_Ref__r.name from OpportunityLineItem where OpportunityId=:recordId and Mix__c!=0];
        boolean apiCall=false;
        List<String> productIds=new List<String>();
        List<String> productFamilyIds=new List<String>();
        system.debug('Log Header Value'+listOfp2Ids);
        system.debug('OpptyLine value'+optyLineItem);
        //If Line item is added/deleted from Opportunity
        if(listOfp2Ids.size()>0 && !optyLineItem.isEmpty()){
            productIds=String.valueOf(listOfp2Ids[0].Product2Ids__c).split(',');
            system.debug('Product Family Value'+listOfp2Ids[0].Product2Ids__c);
           if(listOfp2Ids[0].productFamilyids__c!=null){
            productFamilyIds=String.valueOf(listOfp2Ids[0].productFamilyids__c).split(',');
            }
            system.debug('Product Set Value'+productIds);
            //If Line Item is added/modified
             system.debug('optyLineItem.size -->'+optyLineItem.size());
             system.debug('productIds.size() -->'+productIds.size());
            system.debug('productFamily.size() -->'+productFamilyIds.size());
            if(optyLineItem.size()>=productIds.size() || optyLineItem.size()>=productFamilyIds.size()){
                for(OpportunityLineItem olId:optyLineItem){
                     if(!String.valueOf(listOfp2Ids[0].Product2Ids__c).contains(String.valueof(olId.Product2Id)) ||  !productFamilyIds.contains(String.valueof(olId.Product_Family_Ref__r.name))){
                         apiCall= true;
                         break;
                    }            
                }
            }
            //If Line item is deleted-records in Log_Headers__c will be more than in opptyLineItem 
            else {
                system.debug('Inside Else');
                apiCall=true;
            }
        }
        //If Lineitem is added for the first time
        else if(listOfp2Ids.size()==0 && !optyLineItem.isEmpty()) {
            system.debug('If No Log Header');
            apiCall=true;
        }
        else if(optyLineItem.isEmpty()){
            system.debug('optyLineItem Is empty');
            List<Customer_Win_Recommendation__c> delIds=[Select id from Customer_Win_Recommendation__c where Opportunity__c =: recordId];
            customerWinWrapper.deleteRec(recordId,delIds);
            List<Log_Headers__c> logHeaders=[Select id from Log_Headers__c where Opportunity__c =: recordId];
            try{
                delete logHeaders;
            }
            catch(DmlException e) { 
                System.debug('The following exception has occurred: ' + e.getMessage());
            }
        }
        system.debug('Flag Value'+apiCall);
        Map<String,String>payloadsForAPI=new Map<String,String>();
      
        if(apiCall==true){
            //Get all prod and non-prod values from Custom Settings
            List<String> categories=new List<String>{'customerWinJSON','customerStoryJSON','salesHubJSON','learningMapJSON','SalesInsightURL','SalesPresentationJSON'};
                //  String payload;
            Map<String,String> mapPayloads=new map<String,String>();
            mapPayloads.put('SalesPresentationJSON',Utilities.getConstant_CS('SalesPresentationJSON'));
            mapPayloads.put('customerWinJSON',Utilities.getConstant_CS('customerWinJSON'));
            mapPayloads.put('salesHubJSON',Utilities.getConstant_CS('salesHubJSON'));
            mapPayloads.put('learningMapJSON',Utilities.getConstant_CS('learningMapJSON'));
            mapPayloads.put('SalesInsightURL',Utilities.getConstant_CS('SalesInsightURL')); 
             mapPayloads.put('SalesPresentationURL',Utilities.getConstant_CS('SalesPresentationURL'));   
             mapPayloads.put('customerStoryJSON',Utilities.getConstant_CS('customerStoryJSON'));
           
            //Preparing Payload
            Map<String,String> body=CustomerWinJSON.getJsonString(optyLineItem);
            system.debug('Map Value'+body.get('salesPresentation'));
            for(String mapP:mapPayloads.keySet()){
                String finalPayload;
                if(mapP.contains('customerWinJSON') || mapP.contains('customerStoryJSON')){
                    String cwlistOfQuery='"title", "url" , "cwvertical", "cwsegments", "cwcompetitors","bizent","subbizent","cwtheater","cwregion","date","category"';
                    String finalPayload1=mapPayloads.get(mapP).replace('body',body.get('CustomerWin'));
                    finalPayload=finalPayload1.replace('listOfQuery',cwlistOfQuery);
                    payloadsForAPI.put(mapP,finalPayload);
                }               
                else if(mapP.contains('salesHubJSON')|| mapP.contains('learningMapJSON')){
                    String otherQuery='"title","url","bizent","category","date"';
                    String finalPayload1=mapPayloads.get(mapP).replace('body',body.get('Others'));
                    finalPayload=finalPayload1.replace('otherQuery',otherQuery);
                    payloadsForAPI.put(mapP,finalPayload);
                }
                 else if(mapP.contains('SalesPresentationJSON')){
                    system.debug('Inside Payload');
                    string source='"title","url","bizent","category","date"';
                    String finalPayload1=mapPayloads.get(mapP).replace('body',body.get('salesPresentation'));
                    finalPayload=finalPayload1.replace('lstsource',source);
                    system.debug('Final Payload'+finalPayload);
                    payloadsForAPI.put(mapP,finalPayload);
                    
                }
              
                else{
                    payloadsForAPI.put(mapP,mapPayloads.get(mapP));
                }
            }
        }
        System.debug('payload-->'+payloadsForAPI);
        return payloadsForAPI;
    }
    @AuraEnabled
    public static boolean parseJsonResponse(String recordId,List<String> responseJson){
        //Call SalesConnect API with 3 payloads 
        system.debug('responseJson Value'+responseJson);
        Boolean logInserted=false;
        Boolean insertLog=false;
        if(!responseJson.isEmpty()){
            insertLog= customerWinWrapper.deserializeResp(recordId,responseJson);
        }
        if(insertLog==true || responseJson.isEmpty()){
            List<OpportunityLineItem>optyLineItem=[Select Product2Id,Product_family__c,Product_Family_Ref__r.name from OpportunityLineItem where OpportunityId=:recordId];
            List<String>LProduct2Ids=new List<String>();
            List<String>lProductFamilyId= new List<String>();
            for(OpportunityLineItem olId:optyLineItem){
                LProduct2Ids.add(String.valueOf(olId.Product2Id));
                lProductFamilyId.add(String.valueOf(olId.Product_Family_Ref__r.name));
            }
            if(!LProduct2Ids.isEmpty()){
                Log_Headers__c insertRecord=new Log_Headers__c();
                String Product2Ids=String.join(LProduct2Ids,',');
                String productfamilyIds=String.join(lProductFamilyId,',');
                insertRecord.Opportunity__c=recordId;
                insertRecord.Product2Ids__c=Product2Ids;
                insertRecord.productFamilyids__c=productfamilyIds;
                
                try{
                    Database.insert(insertRecord);
                    logInserted=true;
                }
                catch(DmlException e) { 
                    System.debug('The following exception has occurred: ' + e.getMessage());
                }
            }
        }
        return logInserted;
    }
    public class SalesInsights{
        @AuraEnabled
        public Integer count{get;set;}
        @AuraEnabled
        public List<Customer_Win_Recommendation__c> customerWins{get;set;}
        @AuraEnabled
        public List<Customer_Win_Recommendation__c> learningMaps{get;set;}
        @AuraEnabled
        public List<Customer_Win_Recommendation__c> salesHubs{get;set;}
        @AuraEnabled
        public List<Customer_Win_Recommendation__c> customerStories{get;set;}
        @AuraEnabled
        public List<Customer_Win_Recommendation__c> SalesPresentation{get;set;}
    }
    
     
}