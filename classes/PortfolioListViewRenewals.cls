/*
Apex Controller used for Lightning components on Portfolio Page drop down
*/
/*
* @description : Method to get User Territories , SAV values , Accounts , Product and Services.
* @param : User Territory IDs , SAV IDs , Account IDs
* @return : If data is available return User Territories , SAVs, Accounts , Product and Services
*/

public class PortfolioListViewRenewals {
    
    //Function to get SAV List,Product List,Service List, Date Filter Values, Default Date Value from custom settings
    @auraEnabled
    public static resultWrapper getRelatedItems(){ 
        String userId = userinfo.getUserId();
        String products;
        string services;
        string timelines;
        string stages;
        string defaulttimeline;
        resultWrapper trackerWrappercons = new resultWrapper();
        
        Renewals_Portfolio__c renewals = Renewals_Portfolio__c.getOrgDefaults();
        products=renewals.products__c;
        List<String> productslst = products.split(';');
        System.debug('-----productslst----'+productslst);
        
        services=renewals.services__c;
        List<String> servicelst = services.split(';');
        System.debug('-----servicelst----'+servicelst);
        
        timelines=renewals.Timelines__c;
        List<String> timelineslst = timelines.split(';');
        System.debug('-----timelineslst----'+timelineslst);
        
        stages=renewals.Stages__c;
        List<String> stageslst = stages.split(';');
        System.debug('-----stagelst----'+stageslst);
        
        defaulttimeline=renewals.Default_Timeline__c;
        
        //trackerWrappercons.savs=[select id,Name from Account_Group__c where Id in (Select SalesAccountView__c from RenewalsUserSAVMapping__c where User__c =:userId)];
        //trackerWrappercons.savs = null ;
        trackerWrappercons.prods = productslst;
        trackerWrappercons.services = servicelst; 
        trackerWrappercons.timelines = timelineslst;
        trackerWrappercons.DefaultTimeline = defaulttimeline;
        trackerWrappercons.stages = stageslst;
        trackerWrappercons.userTerritory = getUserTerritory();
        
        system.debug('trackerWrappercons:::'+trackerWrappercons);
        return trackerWrappercons;
    }

/*
@ Created /Modified : June 01,2019
* @description : Function to return a list of SAVs, for a given Territory.
* @param : territoryID
* @return : List of SAV
*/
    @AuraEnabled
    public static list<Account_Group__c> getSAVsByTerr(String terrId){
        decimal terrLevel;
        String terrName ;
        list<Territory2> terrIdlev6;
        Set<ID> terrList = new Set<ID>();
        ID TerrLevId ;
        list<Account_Group__c> savList = new list<Account_Group__c>();
        string savquery = '';
        
        //get Sav Limit from custom settings
        Renewals_Portfolio__c renewals = Renewals_Portfolio__c.getOrgDefaults();
        Integer Savlimit = Integer.ValueOf(renewals.Sav_Limit__c);
        
        /*
        *To fetch Territory name and level only for level 6 and 7
        */
        try{
            list<Territory2> trrList = [select id ,Name, Territory_Level__c from territory2 where id = :terrId and Territory_Level__c in (6.0,7.0)];
            
            for(Territory2 t : trrList){
                terrLevel = t.Territory_Level__c;
                terrName = t.Name ;
                TerrLevId = t.id;
            }
        }
        catch(Exception e)
        {
            system.debug('Error fetching Territory '+ e);
        }
        
        /*
* To fetch all level 7 child terriotories under level 6 territory selected by user
*/
        try{
            if(terrLevel == 6.0){
                terrIdlev6 = [select id from territory2 where Level_6_Territory__c =:terrName and territory_level__c =7.0 ];
                for(Territory2 t : terrIdlev6){
                    terrList.add(t.id);
                }
            }
        }
        catch(Exception ex) {
            system.debug('Exception getting Sav list : '+ ex);
        }
        
        /*If level is 7 , add territory id to list*/
        if (terrLevel == 7.0)
        {
            terrList.add(TerrLevId);
        }
        
        //query the savs for terrid's with limit from custom setting
        savquery = 'select Id, Name from Account_Group__c where parentTerritoryID__c in :terrList limit :Savlimit';
        try{
            savList = Database.query(savquery); 
        }catch(Exception ex) {
            system.debug('Exception getting Sav list : '+ ex);
        }
        system.debug('savList-->'+savList);
        return savList;
    }    
    
    
/*
@ Created /Modified : June 01,2019
* @description : Function to return a list of Accounts, for a Multiple SAVIds
* @param : list of SavIds from Multiselect SAV Dropdown
* @return : List of Account for Selected SAV
*/
    @AuraEnabled
    public static List<Account> getAccountsMultipleSav(list<string> SavIds){
        System.debug('SavIds -->'+SavIds);
        List<Account> accountsList = new List<Account>();
        List<id> accIds = new List<Id>();
        for(Account_Group_Relationship__c agr: [Select id,name,Account_ID__c,Account_Group__c from Account_Group_Relationship__c Where Account_Group__c in : SavIds]){
            accIds.add(agr.Account_ID__c);
        }
        if(accIds.size() > 0){
            for(Account acc: [select id,name from Account where id IN : accIds]){
                accountsList.add(acc);
            }
        }
        system.debug('accountsList::'+accountsList);
        
        return accountsList;
    }
    
/*
@ Created /Modified : June 01,2019
* @description : Function to return a list of SAVs, for a given Territory Based on search Text.This is for search-as-you-type feature
* @param : territoryID & searchText
* @return : List of SAV
*/
    @AuraEnabled
    public static List<Account_Group__c> savsByTerritoryIdandSavSearch(String searchText, string territoryID){
        String searchParam = searchText+'%';
        decimal terrLevel;
        String terrName ;
        list<Territory2> terrIdlev6;
        Set<ID> terrList = new Set<ID>();
        ID TerrLevId ;
        list<Account_Group__c> savList = new list<Account_Group__c>();
        string savquery = '';
        
        //get Sav Limit from custom settings
        Renewals_Portfolio__c renewals = Renewals_Portfolio__c.getOrgDefaults();
        Integer Savlimit = Integer.ValueOf(renewals.Sav_Limit__c);
        
        /*
        *To fetch Territory name and level only for level 6 and 7
        */
        try{
            list<Territory2> trrList = [select id ,Name, Territory_Level__c from territory2 where id = :territoryID and Territory_Level__c in (6.0,7.0)];
            
            for(Territory2 t : trrList){
                terrLevel = t.Territory_Level__c;
                terrName = t.Name ;
                TerrLevId = t.id;
            }
        }
        catch(Exception e)
        {
            system.debug('Error fetching Territory '+ e);
        }
       
          /*
* To fetch all level 7 child terriotories under level 6 territory selected by user
*/
        try{
            if(terrLevel == 6.0){
                terrIdlev6 = [select id from territory2 where Level_6_Territory__c =:terrName and territory_level__c =7.0 ];
                for(Territory2 t : terrIdlev6){
                    terrList.add(t.id);
                }
            }
        }
        catch(Exception ex) {
            system.debug('Exception getting Sav list : '+ ex);
        }
        
        /*If level is 7 , add territory id to list*/
        if (terrLevel == 7.0)
        {
            terrList.add(TerrLevId);
        }
        
        //query the savs for terrid's with limit from custom setting
       //savquery = 'select Id, Name from Account_Group__c where parentTerritoryID__c in :terrList and Name like :searchText% limit :Savlimit';
       savquery = 'select Id, Name from Account_Group__c where parentTerritoryID__c in :terrList and Name like :searchParam limit :Savlimit';
      
        system.debug('savquery'+savquery);
        try{
            savList = Database.query(savquery); 
        }catch(Exception ex) {
            system.debug('Exception getting Sav list : '+ ex);
        }
        system.debug('savList-->'+savList);
        return savList;
    }
     
 /*
@ Created /Modified : May 01,2019 / Sprint 6 changes
* @description : Function to return User-Territories from RenewalUserTerritoryMapping__c junction object
* @param : NA
* @return : List of Territory
*/
    @AuraEnabled
    public static List<Territory2> getUserTerritory(){
        String userId = userinfo.getUserId();
        list<RenewalUserTerritoryMapping__c> usrterritoryList = new list<RenewalUserTerritoryMapping__c>();
        Set<Id> usrterrId = new Set<Id>();
        string usrterrquery = '';
        List<Territory2> finalterritoryList = new List<Territory2>();
        
        //get territory limit from custom settings
        Renewals_Portfolio__c renewals = Renewals_Portfolio__c.getOrgDefaults();
        Integer trrlimit = Integer.ValueOf(renewals.Territory_Limit__c);
        
        //query TerritoryID__c for logged in user with limit
        usrterrquery += 'select TerritoryID__c from RenewalUserTerritoryMapping__c  where user__c =:userId limit :trrlimit';
        try{
            usrterritoryList = Database.query(usrterrquery);
        }catch(Exception ex) {
            system.debug('Exception getting territory list : '+ ex);
        }
        //Create set id of TerritoryID__c from queried list
        for(RenewalUserTerritoryMapping__c rt : usrterritoryList){
            usrterrId.add(rt.TerritoryID__c);
        }
        //Create a list of Terr Name and id
        if(usrterrId.size() > 0){
            for(Territory2 trr : [select Id,Name from territory2 where id in :usrterrId ]){
                finalterritoryList.add(trr);
            }
        }
        return finalterritoryList;
    }
    

   
    public class  resultWrapper{
        @AuraEnabled public List<Account_Group__c> savs{get;set;}
        @AuraEnabled public List<string> prods{get;set;}
        @AuraEnabled public List<string> services{get;set;}
        @AuraEnabled public List<string> timelines{get;set;}
        @AuraEnabled public List<string> stages{get;set;}
        @AuraEnabled public string DefaultTimeline{get;set;}
        @AuraEnabled public List<Territory2> userTerritory{get;set;}
        
    }
}