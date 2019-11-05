@isTest(seeAllData= true)
public class ForecastRollupTest { 
    
    static void setDefaultTerrs(){
    
       
        
        List<Territory2Type> terriType  = [SELECT id, DeveloperName from Territory2Type where  DeveloperName = 'DR' LIMIT 1];
        
        //insert territory model
        List<Territory2Model>   terrModel = [Select Id from Territory2Model where State = 'Active' limit 1];
      
      
        
        Territory2 parentTerr = new Territory2(
                DeveloperName = 'TestTerritory', 
                Territory2ModelId=terrModel[0].Id, Name='Parent Territory', Territory2TypeId=terriType[0].Id,AccountAccessLevel = 'All',
                OpportunityAccessLevel = 'Edit');
                insert parentTerr;
        system.debug('parentTerr'+parentTerr);
        Territory2 childTerr = new Territory2(Name='Child Territory',DeveloperName = 'Test1Territory', 
                Territory2ModelId=terrModel[0].Id,Territory2TypeId=terriType[0].Id,AccountAccessLevel = 'All',
                OpportunityAccessLevel = 'Edit',Level_7_Territory__c='Parent Territory');
                insert childTerr;
                system.debug('childTerr'+childTerr);
    }
    
    @future
    static void setDefaultTerrsAsync(){
        setDefaultTerrs();
    }
    
    
    static void insertOppty(){
        
        Test.startTest();
        setDefaultTerrsAsync();
        Test.stopTest();
        //Insert account
        Account a =  new Account(Name='AccountTest', RecordTypeId = '0123000000004aU',Account_Status__c='Active');
        insert a;
        List<Account> accList = new List<Account>();
        accList.add(a);
        
        Utilities.setIsTestMethod(true);
        
        Territory2 terr = [Select Id from Territory2 where Name='Child Territory' limit 1];
        ObjectTerritory2Association ota = new ObjectTerritory2Association(ObjectId=accList[0].Id, Territory2Id=terr.Id, AssociationCause='Territory2Manual');
        insert ota;
        
        Id terrId = terr.Id;
        Opportunity oppty = new Opportunity(Name='Test oppty',Expected_Product__c=100,Expected_Service__c=100,
                                           Opportunity_Status__c='Active',Territory2Id=terrId,closedate=Date.valueOf('2018-09-05'),
                                           ForecastCategoryName='Commit',recordtypeId=utilities.getOpptyParentRecordTypeId(),
                                           StageName = '4 - Agreement',CurrencyIsoCode='USD',Competitors__c='comp',AccountId=a.id);
        
        insert oppty;
        system.debug('oppty'+oppty);
        System.debug(oppty.Fiscal_Year__c);
        System.debug(oppty.Fiscal_Quarter__c);
        System.debug(oppty.Fiscal_Month_of_QTR__c);
    }
    
    @isTest static void testGetChildTerritoryList(){
        
        setDefaultTerrs();
        List<Territory2> childTerrList= ForecastRollup.getChildTerritoryList('Parent Territory');
        System.assert(childTerrList.size()>0);
    }
    
    @isTest static void testUpdateTeamView(){
        
        setDefaultTerrs();
        List<ForecastRollup.TeamView> teamViewList = new List<ForecastRollup.TeamView>();
        
        List<String> territoryList = new List<String>();
        territoryList.add('Child Territory');
        teamViewList = ForecastRollup.updateTeamView(teamViewList, 'Parent Territory', territoryList);
        System.assert(teamViewList.size()>0);
        
        territoryList = new List<String>();
        teamViewList = ForecastRollup.updateTeamView(teamViewList, 'Parent Territory', territoryList);
        System.assert(teamViewList.size()>1);
    }
    
    @isTest static void testGetOpptyTerritoryList(){
        
        setDefaultTerrs();
        List<Id> terrIdList = ForecastRollup.getOpptyTerritoryList('Parent Territory', 7);
        System.assert(terrIdList.size()==1);
        
    }
    
    @isTest static void testGetCurrencyRates(){
        
        Map<String,Decimal> currencyList = ForecastRollup.getCurrencyRates();
        System.assert(!currencyList.isEmpty());
        
    }
    
    @isTest static void testGetForecastDataSummary(){
        
     
        insertOppty();
        
        ForecastRollup.getForecastData('Parent Territory', 7, '2018-08-05', '2018-11-05', 'summary', 'periodId');
        

    }
    
     @isTest static void testGetForecastDataTeamView(){
        
        
        insertOppty();
        
        ForecastRollup.getForecastData('Parent Territory', 7, '2018-08-05', '2018-11-05', 'teamview', '201921M');
    }
    
    @isTest static void testForecastBucket(){
        Opportunity oppty = new Opportunity(Name='Test oppty',Expected_Product__c=100,Expected_Service__c=100,
                                           Opportunity_Status__c='Active',closedate=Date.valueOf('2018-09-05'),
                                           ForecastCategoryName='Commit',recordtypeId=utilities.getOpptyParentRecordTypeId(),
                                           StageName = '4 - Agreement',CurrencyIsoCode='USD');
        
        Map<String,Decimal> currencyMap = ForecastRollup.getCurrencyRates();
        
        ForecastRollup.TeamView teamView = new ForecastRollup.TeamView();
        
        ForecastRollup.PeriodDetails details = ForecastRollup.forecastBucket(oppty,teamView,currencyMap);
        System.assertEquals(100, details.key1_col2_val);
        
    }
    
}