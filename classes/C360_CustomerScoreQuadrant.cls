/*
************************************************************************************************************************************
Name    : C360_CustomerScoreQuadrant
Author  : C360 Dev team
Purpose : Apex Class for Customer Score Quadrant and Customer Score Quadrant (View all) component
Date	: 28/06/2019
Change History : none
*************************************************************************************************************************************
*/
public class C360_CustomerScoreQuadrant {
    //Customer Score Quadrant 4 records
    @AuraEnabled
    public static String healthScoreQuadrant(list<Id> customerIds){
        List<healthScoreWrapper> healthScoreWrapList = new List<healthScoreWrapper>();
        Map<String,Account> custIdAccount = new Map<String,Account>();
        Set<String> custAccNumber = new Set<String>();
        List<Account> accRecList = new List<Account>();
        accRecList  = [Select Id,Name,AccountNumber,RecordtypeId 
                       from Account 
                       where Parent.Id in :customerIds and RecordType.Name = 'Business Unit' Order by AccountNumber ASC];
        
        if(accRecList.size() > 0){
            for(Account acc:accRecList)
            {
                If(acc.AccountNumber != NULL)
                    custAccNumber.add(acc.AccountNumber);
                custIdAccount.put(acc.AccountNumber,acc);
            }
        }
        List<C360HealthScore__c> healthScoreList =  new List<C360HealthScore__c>();
        healthScoreList = [SELECT Id,Account_Number__c,Customer_hi__c,Utilization__c,Quality_Score__c,Sentiment_Score__c,Finance_Score__c 
                           FROM C360HealthScore__c 
                           WHERE Account_Number__c IN: custAccNumber];
        if(healthScoreList.size() > 0){
            for(C360HealthScore__c healthScor :healthScoreList ){
                healthScoreWrapper hsw = new healthScoreWrapper(custIdAccount.get(healthScor.Account_Number__c),custIdAccount.get(healthScor.Account_Number__c).Id,custIdAccount.get(healthScor.Account_Number__c).Name,(integer)healthScor.Customer_hi__c,(integer)healthScor.Utilization__c,(integer)healthScor.Quality_Score__c,(integer)healthScor.Sentiment_Score__c,(integer)healthScor.Finance_Score__c); 
                healthScoreWrapList.add(hsw);
            }
        }        
        return JSON.serialize(healthScoreWrapList);
        
    }
    
    //Customer Score Quadrant View all
    @AuraEnabled
    public static String healthScoreQuadrantList(string customerIds,Integer limValue){
        List<Id> customerIdsList = new List<Id>();
        if(customerIds != null){
            customerIdsList=customerIds.split(',');
        }
        List<healthScoreWrapper> healthScoreWrapList = new List<healthScoreWrapper>();
        Map<String,Account> custIdAccount = new Map<String,Account>();
        Set<String> custAccNumber = new Set<String>();
        List<Account> accRecList = new List<Account>();
        accRecList  = [Select Id,Name,AccountNumber,RecordtypeId from Account where Parent.Id in :customerIdsList and RecordType.Name = 'Business Unit'];
        
        if(accRecList.size() > 0){
            for(Account acc:accRecList)
            {
                If(acc.AccountNumber != NULL)
                    custAccNumber.add(acc.AccountNumber);
                custIdAccount.put(acc.AccountNumber,acc);
            }
        }
        List<C360HealthScore__c> healthScoreList =  new List<C360HealthScore__c>();
        healthScoreList = [SELECT Id,Account_Number__c,Customer_hi__c,Utilization__c,Quality_Score__c,Sentiment_Score__c,Finance_Score__c 
                           FROM C360HealthScore__c 
                           WHERE Account_Number__c IN: custAccNumber limit :limValue];
        if(healthScoreList.size() > 0){
            for(C360HealthScore__c healthScor :healthScoreList ){
                healthScoreWrapper hsw = new healthScoreWrapper(custIdAccount.get(healthScor.Account_Number__c),custIdAccount.get(healthScor.Account_Number__c).Id,custIdAccount.get(healthScor.Account_Number__c).Name,(integer)healthScor.Customer_hi__c,(integer)healthScor.Utilization__c,(integer)healthScor.Quality_Score__c,(integer)healthScor.Sentiment_Score__c,(integer)healthScor.Finance_Score__c); 
                healthScoreWrapList.add(hsw);
            }
        }
        return JSON.serialize(healthScoreWrapList);
        
    }
    
    //To get Total Count of Health Scores on Customer Score Quadrant View all
    @AuraEnabled
    public static Integer healthScoreQuadrantTotal(string customerIds){
        List<Id> customerIdsList = new List<Id>();
        if(customerIds != null){
            customerIdsList=customerIds.split(',');
        }
        List<Account> accRecList = new List<Account>();
        //  List<AggregateResult > ListHS = new List<AggregateResult();
        List<healthScoreWrapper> healthScoreWrapList = new List<healthScoreWrapper>();
        Map<String,Account> custIdAccount = new Map<String,Account>();
        Set<String> custAccNumbers = new Set<String>();
        //List<Account> accRecList = new List<Account>();
        accRecList  = [Select Id,Name,AccountNumber,RecordtypeId from Account where Parent.Id in :customerIdsList and RecordType.Name = 'Business Unit'];
        
        if(accRecList.size() > 0){
            for(Account acc:accRecList)
            {
                If(acc.AccountNumber != NULL)
                    custAccNumbers.add(acc.AccountNumber);
                custIdAccount.put(acc.AccountNumber,acc);
                
            }
        }
        AggregateResult healthScoreListFinal = [SELECT COUNT(Id) TotalHealthScores from C360HealthScore__c where Account_Number__c IN: custAccNumbers];
        Integer totalHealthScoresCount = (Integer)healthScoreListFinal.get('TotalHealthScores');
        return totalHealthScoresCount;
        
    } 
    
    //Wrapper Class which returns data
    public  class healthScoreWrapper{
        @AuraEnabled public Account account {get;set;}
        @AuraEnabled public String  customerName {get;set;}
        @AuraEnabled public Integer Index {get;set;}
        @AuraEnabled public Integer Utilization {get;set;}
        @AuraEnabled public Integer Quality {get;set;}
        @AuraEnabled public Integer sentimentScore {get;set;}
        @AuraEnabled public Integer Financials {get;set;}
        @AuraEnabled public String  buID {get;set;}
        
        
        public healthScoreWrapper(Account acc,String  buID,String custName,Integer Index,Integer Utilization,Integer Quality,Integer sentimentScore,Integer Financials){
            this.account = acc;
            this.customerName = custName;
            this.Index = Index;
            this.Utilization = Utilization;
            this.Quality = Quality;
            this.sentimentScore = sentimentScore;
            this.Financials = Financials;
            this.buID = buID;
        }
    }
}