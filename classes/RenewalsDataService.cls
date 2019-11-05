public with sharing class RenewalsDataService {
/*
Apex Controller used for Lightning components on Portfolio Page
*/
    /*
@ Created /Modified : Feb 07,2019
* @description : Method to get All UpComing Renewal Opportunities
* @param : User selectedProducts, selectedServices, selectedTimeLine and selectedAccounts
* @return : If data is available return list top5 of upcoming renewal opportunities sorted by Expected ATR
*/
    @AuraEnabled
    public static ResultWrapper getUpcomingRenewalsOppty( list<String> selectedProducts, list<String> selectedServices, String selectedTimeLine, list<String> selectedAccounts, Boolean OwnerFlag) {
        List<Opportunity> lstupComingOpty = new List<Opportunity>();
        String userId = userinfo.getUserId();
        string upQuery = '';
        //Add products and services in list	
        List<String> lstprodserv = addProductServiceBE(selectedProducts,selectedServices);
        
        //Get the RecordTypeId for Renewals Oppty
        String opptyRenewalRecordTypeId = Utilities.getOpptyRenewalRecordTypeId();
        
        List<String> stageList = getStageList();
        system.debug('lstprodserv----'+lstprodserv);
        system.debug('stageList-----'+stageList);
        
        system.debug('UpComing Renewals selectedProducts---' +selectedProducts + 'selectedServices---'+selectedServices + 'selectedTimeLine---'+selectedTimeLine + 'selectedAccounts'+ selectedAccounts);
        
        
        if(selectedProducts.isEmpty() && selectedServices.isEmpty()){
            upQuery = 'SELECT Account.parent.parent.name ,Account.parent.parent.Id , Id, Name, convertCurrency(Expected_Product__c),convertCurrency(Expected_Service__c),convertCurrency(Total_Prior_ATR__c),Account.Name,StageName,CloseDate ,account.parent.parent.Assigned_CSE__r.Name FROM Opportunity where RecordTypeid= \'' +opptyRenewalRecordTypeId+'\' ';
            upQuery += getDateWhereClauseOpty(selectedTimeLine,'Opportunity')+getAccountWhereClauseOpty(selectedAccounts,'Opportunity')+getOptyOwnerWhereClause(OwnerFlag);
            upQuery += ' and closeDate > TODAY and StageName in :stageList order by Total_Prior_ATR__c desc NULLS LAST LIMIT 5 ';
        }else{
            upQuery = 'SELECT Account.parent.parent.name,Account.parent.parent.Id ,Id, Name, convertCurrency(Expected_Product__c),convertCurrency(Expected_Service__c),convertCurrency(Total_Prior_ATR__c),Account.Name,StageName,CloseDate  FROM Opportunity where Id in (Select OpportunityId from OpportunityLineItem where Opportunity.RecordTypeid= \'' +opptyRenewalRecordTypeId+'\' ';
            upQuery += getDateWhereClauseOpty(selectedTimeLine,'OptyLine') + getAccountWhereClauseOpty(selectedAccounts,'OptyLine') + getBusinessEntityWhereClause(lstprodserv) + getOptyOwnerWhereClause(OwnerFlag);
            upQuery += ' and Opportunity.closeDate >= TODAY and Opportunity.StageName in :stageList) order by Total_Prior_ATR__c desc NULLS LAST LIMIT 5';
        }
        system.debug('upQuery---' +upQuery);
        try{
            lstupComingOpty = Database.query(upQuery);
        }
        catch(Exception ex) {
            system.debug('Exception getting list of upcoming oppty : '+ ex);
            
        }
        
        //Get Customer Names for the Oppty Account Id's
        Map<String,String> customerAccountMap = new Map<String,String>();
        if(!lstupComingOpty.isEmpty()){
            List<Id> accIds = new List<Id>();
            for(Opportunity oppty:lstupComingOpty){
                accIds.add(oppty.Account.Id);
            }
            customerAccountMap = RenewalsUtilities.getCustomerAccountMapping(accIds);
        }
        
        ResultWrapper rw = new ResultWrapper();
        rw.opptys = lstupComingOpty;
        rw.customerAccountMap = customerAccountMap;
        return rw;
    }
    
    /*
@ Created /Modified : Feb 07,2019
* @description : Method to get All OverDue Renewal Opportunities
* @param : User selectedProducts, selectedServices, selectedTimeLine and selectedAccounts
* @return : If data is available return list of top 5 over due renewal opportunities sorted by Expected ATR
*/
    @AuraEnabled
    public Static ResultWrapper getOverDueRenewalsOppty(list<String> selectedProducts, list<String> selectedServices, String selectedTimeLine, list<String> selectedAccounts,Boolean OwnerFlag) {
        string overduequery = '';
        String userId = userinfo.getUserId();
        List<Opportunity> lstoverDueOpty = new List<Opportunity>();
        //Add products and services in list
        
        List<String> lstprodserv = addProductServiceBE(selectedProducts,selectedServices);
        
        //Get the Renewal RecordTypeId from Org Constanst
        string opptyRenewalRecordTypeId = Utilities.getOpptyRenewalRecordTypeId();
        List<String> stageList = getStageList();
        system.debug('OverDue Renewals selectedProducts---' +selectedProducts + 'selectedServices---'+selectedServices + 'selectedTimeLine---'+selectedTimeLine + 'selectedAccounts'+ selectedAccounts);
        //Query the overdue oppty
        system.debug('WhereClause-->'+getOptyOwnerWhereClause(OwnerFlag)) ;
        if(selectedProducts.isEmpty() && selectedServices.isEmpty()){
            overduequery = 'SELECT Account.parent.parent.name ,Id,Name,convertCurrency(Expected_Product__c),convertCurrency(Expected_Service__c),convertCurrency(Total_Prior_ATR__c),Account.Name,StageName,CloseDate  FROM Opportunity where RecordTypeid =\'' +opptyRenewalRecordTypeId+'\' '; 
            //overduequery += ' and closeDate = THIS_FISCAL_QUARTER ';
            overduequery += getDateWhereClauseOpty(selectedTimeLine,'Opportunity') +  getAccountWhereClauseOpty(selectedAccounts,'Opportunity') + getOptyOwnerWhereClause(OwnerFlag);
            overduequery += ' and closeDate < TODAY and StageName in :stageList order by Total_Prior_ATR__c desc NULLS LAST LIMIT 5 ' ;
        }else{
            overduequery = 'SELECT Account.parent.parent.name ,Id,Name,convertCurrency(Expected_Product__c),convertCurrency(Expected_Service__c),convertCurrency(Total_Prior_ATR__c),Account.Name,StageName,CloseDate  FROM Opportunity where Id in (Select OpportunityId from OpportunityLineItem where Opportunity.RecordTypeid =\'' +opptyRenewalRecordTypeId+'\' ';
            overduequery += getDateWhereClauseOpty(selectedTimeLine,'OptyLine') + getAccountWhereClauseOpty(selectedAccounts,'OptyLine') + getBusinessEntityWhereClause(lstprodserv) + getOptyOwnerWhereClause(OwnerFlag);
            overduequery += ' and Opportunity.closeDate < TODAY and Opportunity.StageName in :stageList ) order by Total_Prior_ATR__c desc NULLS LAST LIMIT 5';
        }
        system.debug('overduequery---' +overduequery);
        try{
            lstoverDueOpty = Database.query(overduequery);
        }
        catch(Exception ex) {
            system.debug('Exception getting list of overdue oppty : '+ ex);
            
        }
        //Get Customer Names for the Oppty Account Id's
        Map<String,String> customerAccountMap = new Map<String,String>();
        if(!lstoverDueOpty.isEmpty()){
            List<Id> accIds = new List<Id>();
            for(Opportunity oppty:lstoverDueOpty){
                accIds.add(oppty.Account.Id);
            }
            customerAccountMap = RenewalsUtilities.getCustomerAccountMapping(accIds);
        }
        
        ResultWrapper rw = new ResultWrapper();
        rw.opptys = lstoverDueOpty;
        rw.customerAccountMap = customerAccountMap;
        return rw;
        
    }
    
    /*
@ Created /Modified : Feb 07,2019
* @description : Method to get All Lost Renewal Opportunities
* @param : User selectedProducts, selectedServices, selectedTimeLine and selectedAccounts
* @return : If data is available return list of top 5 lost renewal opportunities with stage 5 - Closed Lost
*/
    @AuraEnabled
    public Static ResultWrapper getLostRenewalsOppty(list<String> selectedProducts, list<String> selectedServices, String selectedTimeLine, list<String> selectedAccounts,Boolean OwnerFlag) {
        string lostrenewaloptyquery = '';
        String userId = userinfo.getUserId();
        List<Opportunity> lstlostOpty = new List<Opportunity>();
        
        //Add products and services in list
        List<String> lstprodserv = addProductServiceBE(selectedProducts,selectedServices);
        
        //Get the Renewal RecordTypeId from Org Constanst
        string opptyRenewalRecordTypeId = Utilities.getOpptyRenewalRecordTypeId();
        //Query the Lost oppty
        string stageName = '5 - Closed Lost';
        system.debug('Lost Renewals selectedProducts---' +selectedProducts + 'selectedServices---'+selectedServices + 'selectedTimeLine---'+selectedTimeLine + 'selectedAccounts'+ selectedAccounts);
        if(selectedProducts.isEmpty() && selectedServices.isEmpty()){
            lostrenewaloptyquery = 'SELECT Account.parent.parent.name ,Id,Name,convertCurrency(Expected_Product__c),convertCurrency(Expected_Service__c),convertCurrency(Total_Prior_ATR__c),Account.Name, StageName,CloseDate  FROM Opportunity where RecordTypeid =\'' +opptyRenewalRecordTypeId+'\' '; 
            lostrenewaloptyquery += getDateWhereClauseOpty(selectedTimeLine,'Opportunity')+getAccountWhereClauseOpty(selectedAccounts,'Opportunity') + getOptyOwnerWhereClause(OwnerFlag);
            lostrenewaloptyquery += ' and StageName =  :stageName order by Total_Prior_ATR__c desc NULLS LAST LIMIT 5';
        }else{
            lostrenewaloptyquery = 'SELECT Account.parent.parent.name ,Id,Name,convertCurrency(Expected_Product__c),convertCurrency(Expected_Service__c),convertCurrency(Total_Prior_ATR__c),Account.Name, StageName,CloseDate  FROM Opportunity where Id in (Select OpportunityId from OpportunityLineItem where Opportunity.RecordTypeid =\'' +opptyRenewalRecordTypeId+'\' ';
            lostrenewaloptyquery += getDateWhereClauseOpty(selectedTimeLine,'OptyLine') + getAccountWhereClauseOpty(selectedAccounts,'OptyLine') + getBusinessEntityWhereClause(lstprodserv) + getOptyOwnerWhereClause(OwnerFlag);
            lostrenewaloptyquery += ' and Opportunity.StageName =  :stageName) order by Total_Prior_ATR__c desc NULLS LAST LIMIT 5';
        }
        
        system.debug('lostrenewaloptyquery---' +lostrenewaloptyquery);
        try{
            lstlostOpty = Database.query(lostrenewaloptyquery);
        }
        catch(Exception ex) {
            system.debug('Exception getting list of lost oppty : '+ ex);
        }
        //Get Customer Names for the Oppty Account Id's
        Map<String,String> customerAccountMap = new Map<String,String>();
        if(!lstlostOpty.isEmpty()){
            List<Id> accIds = new List<Id>();
            for(Opportunity oppty:lstlostOpty){
                accIds.add(oppty.Account.Id);
            }
            customerAccountMap = RenewalsUtilities.getCustomerAccountMapping(accIds);
        }
        
        ResultWrapper rw = new ResultWrapper();
        rw.opptys = lstlostOpty;
        rw.customerAccountMap = customerAccountMap;
        return rw;
    }
    
    /*
@ Created /Modified : Feb 07,2019
* @description : Method to get All Renewal Opportunities sorted by top forecasted attrition
* @param : User selectedProducts, selectedServices, selectedTimeLine and selectedAccounts
* @return : If data is available return list Renewal Opportunities sorted by top forecasted attrition 
*/
    
    @AuraEnabled
    public Static ResultWrapper getTopAttrition (  list<String> selectedProducts, list<String> selectedServices, String selectedTimeLine, list<String> selectedAccounts,Boolean OwnerFlag) 
    {
        string topAttrquery = '';
        List<Opportunity> lstAttrOpty = new List<Opportunity>();
        //Add products and services in list
        List<String> lstprodserv = addProductServiceBE(selectedProducts,selectedServices);
        String userId = userinfo.getUserId();
        //Get the Renewal RecordTypeId from Org Constanst
        string opptyRenewalRecordTypeId = Utilities.getOpptyRenewalRecordTypeId();
        
        List<String> stageList = getStageList();
        system.debug('Top Attr Renewals selectedProducts---' +selectedProducts + 'selectedServices---'+selectedServices + 'selectedTimeLine---'+selectedTimeLine + 'selectedAccounts'+ selectedAccounts);
        if(selectedProducts.isEmpty() && selectedServices.isEmpty()){
            topAttrquery = 'select  Account.parent.parent.name ,Id , Name , Account.Name ,convertCurrency(Expected_Total_Attrition__c), convertCurrency(Expected_Product__c) , convertCurrency(Expected_Service__c),Prior_Contract_Expiration_Date__c ,StageName ,account.parent.parent.Assigned_CSE__r.Name,convertCurrency(Total_Prior_ATR__c)  FROM Opportunity where RecordTypeid =\'' +opptyRenewalRecordTypeId+'\' ';
            topAttrquery += getDateWhereClauseOpty(selectedTimeLine,'Opportunity') + getAccountWhereClauseOpty(selectedAccounts,'Opportunity') + getOptyOwnerWhereClause(OwnerFlag);
            topAttrquery += ' and StageName in :stageList order by Expected_Total_Attrition__c desc NULLS LAST LIMIT 5';
        }else{
            topAttrquery = 'select Account.parent.parent.name ,Id , Name , Account.Name ,convertCurrency(Expected_Total_Attrition__c), convertCurrency(Expected_Product__c) , convertCurrency(Expected_Service__c),Prior_Contract_Expiration_Date__c ,StageName ,convertCurrency(Total_Prior_ATR__c)  FROM Opportunity where Id in (Select OpportunityId from OpportunityLineItem where Opportunity.RecordTypeid =\'' +opptyRenewalRecordTypeId+'\' ';
            topAttrquery += getDateWhereClauseOpty(selectedTimeLine,'OptyLine') + getAccountWhereClauseOpty(selectedAccounts,'OptyLine') + getBusinessEntityWhereClause(lstprodserv) +getOptyOwnerWhereClause(OwnerFlag);
            topAttrquery += ' and Opportunity.StageName in :stageList ) order by Expected_Total_Attrition__c desc NULLS LAST LIMIT 5';
        }
        system.debug('topAttrquery---' +topAttrquery);        
        try{
            lstAttrOpty = Database.query(topAttrquery);
        }
        catch(Exception ex) {
            system.debug('Exception getting list of topforecasted atr oppty : '+ ex);
        }
        
        //Get Customer Names for the Oppty Account Id's
        Map<String,String> customerAccountMap = new Map<String,String>();
        if(!lstAttrOpty.isEmpty()){
            List<Id> accIds = new List<Id>();
            for(Opportunity oppty:lstAttrOpty){
                accIds.add(oppty.Account.Id);
            }
            customerAccountMap = RenewalsUtilities.getCustomerAccountMapping(accIds);
        }
        
        ResultWrapper rw = new ResultWrapper();
        rw.opptys = lstAttrOpty;
        rw.customerAccountMap = customerAccountMap;
        return rw;
        
    }
    
    /*
@ Created /Modified : Feb 07,2019
* @description : Method to get All Land Opportunities to capture upsell and cross-sell
* @param : User selectedProducts, selectedServices, selectedTimeLine and selectedAccounts
* @return : If data is available return list All Land Opportunities to capture upsell and cross-sell
*/
    
    @AuraEnabled
    public Static ResultWrapper getUpsellCrossSell(  list<String> selectedProducts, list<String> selectedServices, String selectedTimeLine, list<String> selectedAccounts,Boolean OwnerFlag) 
    {
        string listquery = '';
        String userId = UserInfo.getUserId();

        
        List<Opportunity> lstUpsellOpty = new List<Opportunity>();
        //Add products and services in list
        
        List<String> lstprodserv = addProductServiceBE(selectedProducts,selectedServices);
        
        //Get the Renewal RecordTypeId from Org Constanst
        ObjectRecordTypeIds__c objRecordTypeSetting = ObjectRecordTypeIds__c.getOrgDefaults();
        string opptyparentRecordTypeId = objRecordTypeSetting.Opportunity_Parent_RecordTypeId__c;
        system.debug('UpSell Cross Sell selectedProducts---' +selectedProducts + 'selectedServices---'+selectedServices + 'selectedTimeLine---'+selectedTimeLine + 'selectedAccounts'+ selectedAccounts);
        //Query the Lost oppty
        if(selectedProducts.isEmpty() && selectedServices.isEmpty()){
            listquery = 'select Account.parent.parent.name ,Id, Name ,Account.Name ,convertCurrency(Expected_Total_Value_000_s__c),StageName,CloseDate  FROM Opportunity where RecordTypeid =\'' +opptyparentRecordTypeId+'\' ';
            listquery += getDateWhereClauseOpty(selectedTimeLine,'Opportunity') + getAccountWhereClauseOpty(selectedAccounts,'Opportunity')+ getOptyOwnerWhereClause(OwnerFlag);
            listquery += ' and createdById = :userId';
            listquery += ' and stageName NOT IN (\'5 - Closed Won\', \'5 - Closed Cancelled\', \'5 - Closed Lost\', \'5 - Closed Booked\') order by Expected_Total_Value_000_s__c desc NULLS LAST LIMIT 5';
        }else{
            listquery = 'select Account.parent.parent.name ,Id, Name ,Account.Name ,convertCurrency(Expected_Total_Value_000_s__c),StageName,CloseDate  FROM Opportunity where Id in (Select OpportunityId from OpportunityLineItem where Opportunity.RecordTypeid =\'' +opptyparentRecordTypeId+'\' ';
            listquery += getDateWhereClauseOpty(selectedTimeLine,'OptyLine') + getAccountWhereClauseOpty(selectedAccounts,'OptyLine') + getOptyOwnerWhereClause(OwnerFlag);
            listquery += ' and createdById = :userId';
            listquery += ' and Opportunity.stageName NOT IN (\'5 - Closed Won\', \'5 - Closed Cancelled\', \'5 - Closed Lost\', \'5 - Closed Booked\') ) order by Expected_Total_Value_000_s__c desc NULLS LAST LIMIT 5';
        }
        System.debug('UpSell CrossSell listQuery: ' + listQuery);
        
        
        try{
            lstUpsellOpty = Database.query(listquery);
        }
        catch(Exception ex) {
            system.debug('Exception getting list of upsell/crosssell oppty : '+ ex);
        }
        //Get Customer Names for the Oppty Account Id's
        Map<String,String> customerAccountMap = new Map<String,String>();
        if(!lstUpsellOpty.isEmpty()){
            List<Id> accIds = new List<Id>();
            for(Opportunity oppty:lstUpsellOpty){
                accIds.add(oppty.Account.Id);
            }
            customerAccountMap = RenewalsUtilities.getCustomerAccountMapping(accIds);
        }
        
        ResultWrapper rw = new ResultWrapper();
        rw.opptys = lstUpsellOpty;
        rw.customerAccountMap = customerAccountMap;
        return rw;
    } 
    
    /*
@ Created /Modified : Feb 07,2019
* @description : Generic method to build where clause for Date in above functions
* @param : selectedTimeLine, objectToQuery
* @return : dynamic date where clause
*/
    public static string getDateWhereClauseOpty(String selectedTimeLine, string objectToQuery){
        String dateWhereClause='';
        string closeDate = '';
        if(objectToQuery == 'Opportunity'){
            closeDate = 'closeDate';
        }else{
            closeDate = 'Opportunity.closeDate';
        }
        if(selectedTimeLine == 'THIS FISCAL QUARTER'){
            dateWhereClause = ' and '  +closeDate+ '= THIS_FISCAL_QUARTER ';
        }else if(selectedTimeLine == 'THIS FISCAL MONTH'){
            dateWhereClause = ' and ' +closeDate+  '= THIS_MONTH ';
        }else if(selectedTimeLine == 'NEXT FISCAL MONTH'){
            dateWhereClause = ' and ' +closeDate+ '= NEXT_MONTH ';
        }else if(selectedTimeLine == 'THIS FISCAL YEAR'){
            dateWhereClause = ' and ' +closeDate+ '= THIS_FISCAL_YEAR ';
        }else if(selectedTimeLine == 'LAST FISCAL MONTH'){
            dateWhereClause = ' and ' +closeDate+ '= LAST_MONTH ';
        }
        else{
            dateWhereClause = ' and ' +closeDate+  '= THIS_FISCAL_QUARTER ';
        }
        return dateWhereClause;
    }
    
    /*
@ Created /Modified : Feb 07,2019
* @description : Generic method to build where clause for Account in above functions
* @param : selectedTimeLine, objectToQuery
* @return : dynamic Account where clause
*/    
    public static String getAccountWhereClauseOpty(List<String> selectedAccounts, string objectToQuery){
        String accountWhereClause = '';
        string AccountId = '';
        if(objectToQuery == 'Opportunity'){
            AccountId = 'AccountId';
        }else{
            AccountId = 'Opportunity.AccountId';
        }
        if(!selectedAccounts.isEmpty()){
            accountWhereClause =' and '+AccountId+ ' in :selectedAccounts ';
        }
        return accountWhereClause;
    }
    
    /*
@ Created /Modified : Feb 07,2019
* @description : Generic method to build where clause for BusinessEntity in above functions
* @param : lstprodserv
* @return : BusinessEntityWhereClause string
*/    
    
    public static string getBusinessEntityWhereClause(List<String> lstprodserv){
        String businessEntityWhereClause = '';
        if(!lstprodserv.isEmpty()){
            businessEntityWhereClause = ' and Business_Entity__c in :lstprodserv ' ;
        }
        return businessEntityWhereClause;
    }
    /* 
@ Created /Modified : May 15,2019
* @description : Generic method to build where clause for Opportunity Owner
* @param : OwnerFlag
* @return : OptyOwnerWhereClause string
*/    
    
    public static string getOptyOwnerWhereClause(Boolean OwnerFlag){
        String OptyOwnerWhereClause = '';
        
        if(OwnerFlag==true){
            OptyOwnerWhereClause = ' and OwnerId = :userId ' ;
        }
        return OptyOwnerWhereClause;
    }    
    
    /*
@ Created /Modified : Feb 07,2019
* @description : Generic method add products and services in a list
* @param : selectedProducts,selectedServices 
* @return : list of prod and serv
*/   
    public static list<String> addProductServiceBE (list<String> selectedProducts,list<String> selectedServices){
        List<String> lstselectedprodserv = new List<String>();
        lstselectedprodserv.addAll(selectedProducts);
        lstselectedprodserv.addAll(selectedServices);
        return lstselectedprodserv;
    }
    
    /*
@ Created /Modified : Feb 07,2019
* @description : Generic method get Stage from custom setting
* @param : ''
* @return : list of prod and serv
*/  
    public static List<String> getStageList(){
        Renewals_Portfolio__c renewals = Renewals_Portfolio__c.getOrgDefaults();
        string stages='';
        stages=renewals.Stages__c;
        List<String> stageslst = stages.split(';');
        return stageslst;
    }
    
    
    @AuraEnabled
    public static List<ListView> getListViews(string table) {
        
        Renewals_Portfolio__c renewals = Renewals_Portfolio__c.getOrgDefaults();
        //Get the List View's using list View Name
        String listViewName = null;
        if(table.equals('UpcomingRenewals')){
            listViewName = renewals.RenewalsUpcomingListView__c ;
        }
        else if(table.equals('OverdueRenewals')){
            listViewName = renewals.RenewalsOverdueListView__c; 
        }
        else if(table.equals('LostRenewals')){
            listViewName = renewals.RenewalsLostListView__c; 
        }
        else if(table.equals('UpSellCrossSell')){
            listViewName = renewals.UpSellCrossSellListView__c; 
        }
        else if(table.equals('AttritionRenewals')){
            listViewName = renewals.RenewalsAttritionListView__c; 
        }
        List<ListView> listviews = 
            [SELECT Id, Name FROM ListView WHERE SobjectType = 'Opportunity' and Name = :listViewName ];
        return listviews;
    }
    
    @AuraEnabled
    public static Map<String,PortfolioRenewalResourceLink__c> UrlFromCustomSetting(){
        
        Map<String,PortfolioRenewalResourceLink__c> allCodes = PortfolioRenewalResourceLink__c.getAll();
        
        return allCodes;
    }
    
    public class  ResultWrapper{
        @AuraEnabled public List<Opportunity> opptys{get;set;}
        @AuraEnabled public Map<String,String> customerAccountMap{get;set;}
    }
    
}