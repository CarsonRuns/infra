global with sharing class RenewalsATEBEData {
    
    //Function to get the Bar Chart Data
    @RemoteAction
    @ReadOnly
    global static AggregateResult[] getAtrByBeGroupings(List<Id> accountIds,String dateValue, Boolean OwnerFlag) {
        String optyRecordType = Utilities.getOpptyRenewalRecordTypeId();
        String accountIDWhereClause = '';
        Map<String,Integer> returnValues = new Map<String,Integer>();
        String userId = userinfo.getUserId();
        AggregateResult[] queryResult = new AggregateResult[]{};
        List<String> stageList = getStageList(); 
            
            //If account list is not empty, add account where clause
            if(!accountIds.isEmpty()){
                accountIDWhereClause = ' and Opportunity.AccountId in :accountIds ';
            }  
        
        String atrBeQuery = 'select Business_Entity__c, '+ 
            'sum(Expected_ATR__c) atr '+ 
            'from OpportunityLineItem '+ 
            'where Opportunity.RecordType.Id = :optyRecordType and Opportunity.StageName in :stageList '+ 
            RenewalsDataService.getDateWhereClauseOpty(dateValue,'OptyLine')+ getOptyOwnerWhereClause(OwnerFlag) +
            accountIDWhereClause+
            ' group by Business_Entity__c';
        
        system.debug('atrBeQuery-->'+atrBeQuery);
        try
        {
            queryResult = Database.query(atrBeQuery);
        }
        catch(Exception e){
            System.debug('Error in ATR By BE SOQL Query');
        }
        return queryResult;
    }
    
    //Function to get Donut Chart Data
    @RemoteAction
    @ReadOnly
    global static AggregateResult[] getAtrDonutChartData(List<Id> accountIds,String dateValue,List<String> businessEntityList, Boolean OwnerFlag) {
        String optyRecordType = Utilities.getOpptyRenewalRecordTypeId();
        String userId = userinfo.getUserId();
        String accountIDWhereClause = '';
        String businessEntityWhereClause = '';
        Map<String,Integer> returnValues = new Map<String,Integer>();
        AggregateResult[] queryResult = new AggregateResult[]{};
        List<String> stageList = getStageList();
        
        //If account list is not empty add account where clause
        if(!accountIds.isEmpty()){
          	 accountIDWhereClause = ' and Opportunity.AccountId in :accountIds ';
        }  
        
        //If business entity list is not empty add it to where clause
        if(!businessEntityList.isEmpty()){
            businessEntityWhereClause = ' and Business_Entity__c in :businessEntityList ';
        }  
        
        String atrOfferQuery = 'select ProductCode, '+ 
            'sum(Expected_ATR__c) atr '+ 
            'from OpportunityLineItem '+ 
            'where Opportunity.RecordType.Id = :optyRecordType and Opportunity.StageName in :stageList '+ 
            RenewalsDataService.getDateWhereClauseOpty(dateValue,'OptyLine')+getOptyOwnerWhereClause(OwnerFlag) +
            accountIDWhereClause+
            businessEntityWhereClause+
            ' group by ProductCode order by ProductCode desc';
        system.debug('atrOfferQuery-->'+atrOfferQuery);
        try{
            queryResult = Database.query(atrOfferQuery);
        }
        catch(Exception e){
            System.debug('Error in Donut Chart SOQL Query');
        }
        return queryResult;
    }
    
    //Function to get Funnel chart data
    @RemoteAction
    @ReadOnly
    global static Map<String,Object> getAtrFunnelChartData(List<Id> accountIds,String dateValue,List<String> businessEntityList, Boolean OwnerFlag) {
        String optyRecordType = Utilities.getOpptyRenewalRecordTypeId();
        String userId = userinfo.getUserId();
        String accountIDWhereClause = '';
        String businessEntityWhereClause = '';
        Map<String,Integer> returnValues = new Map<String,Integer>();
        AggregateResult[] queryResult = new AggregateResult[]{};
        List<String> stageList = getStageList();
        
        //if account is not empty add it to where clause
        if(!accountIds.isEmpty()){
            accountIDWhereClause = ' and Opportunity.AccountId in :accountIds ';
        }  
        
        //if business entity is not empty add it to while clause
        if(!businessEntityList.isEmpty()){
            businessEntityWhereClause = ' and Business_Entity__c in :businessEntityList ';
        }  
        
        String atrStageQuery = 'select StageName, '+ 
            ' sum(Expected_Total_ATR_000s__c) atr '+ 
            ' from Opportunity where Id in (select OpportunityId from OpportunityLineItem '+ 
            'where Opportunity.RecordType.Id = :optyRecordType and Opportunity.StageName in :stageList '+ 
            RenewalsDataService.getDateWhereClauseOpty(dateValue,'OptyLine')+ getOptyOwnerWhereClause(OwnerFlag) +
            accountIDWhereClause+
            businessEntityWhereClause+
            ' ) group by StageName order by StageName ';
        system.debug('atrStageQuery-->'+atrStageQuery) ;
        try{
            queryResult = Database.query(atrStageQuery);
        }catch(Exception e){
            System.debug('Error in Funnel Chart SOQL Query');
        }
        Map<String,Object> result = new Map<String,Object>();
        result.put('data',queryResult);
        result.put('stages',stageList);
        return result;
    }
    
    //Function to get the Stage List from Custom Settings
    static List<String> getStageList(){
        Renewals_Portfolio__c renewals = Renewals_Portfolio__c.getOrgDefaults();
        string stages='';
        stages=renewals.Stages__c;
        List<String> stageslst = stages.split(';');
        return stageslst;
    }
    
    //Function to return where clause for MyOpty fetch - June Release (US291241)
    public static string getOptyOwnerWhereClause(Boolean OwnerFlag){
        String OptyOwnerWhereClause = '';
        
        if(OwnerFlag==true){
            OptyOwnerWhereClause = ' and opportunity.OwnerId = :userId ' ;
        }
        return OptyOwnerWhereClause;
    }    
}