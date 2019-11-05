@RestResource(urlMapping='/forecast/*')
global class ForecastRollup {
    
    global class Response{
        List<PeriodMap> summaryval;
        List<TeamView> teamview;
    }
    
    
    
     global abstract class PeriodDetails{ 
        Integer key1_col1_val=0;
        Integer key2_col1_val=0;
        @TestVisible Integer key1_col2_val=0;
        Integer key2_col2_val=0;
        Integer key1_col3_val=0;
        Integer key2_col3_val=0;
        Integer key1_col4_val=0;
        Integer key2_col4_val=0;
    }
    
    global class PeriodMap extends PeriodDetails{
        String periodId;
        
        
    }
    global class TeamView extends PeriodDetails{
        String territoryname;
        String fdaterritoryname;
        String territorykey;
        String lowestlevelflag;
        String nodelowestlevelflag;
        
    }
    @HttpPost
    global static response getForecastData(String territory,Integer level,String startDate,String endDate,String context,String periodId) {
        RestRequest request = RestContext.request;
        
        Response response = new Response();
        
        if(level == null || level < 0 || level > 8){
            level = 8;
        }
        
        Date stDate = Date.valueOf(startDate);
        Date enDate = Date.valueOf(endDate);
        
        
        if(context.equalsIgnoreCase('summary')){
            List<PeriodMap> result = calculateRollup(territory,stDate,enDate,level);
            response.summaryval = result;
        }
        else if(context.equalsIgnoreCase('teamview'))
        {
            List<TeamView> result = prepareTeamView(territory,stDate,enDate,level,periodId);
            response.teamview = result;
        }
        
        return response;
        
        
    }
    
    public static List<Territory2> getChildTerritoryList(String territory){
        Territory2 terr = [Select Derived_Segment1__c from Territory2 where Name=:territory];
        String territoryKey = terr.Derived_Segment1__c;
        List<Territory2> childTerritories = [select Name, Derived_Segment1__c, Lowest_Level__c, Node_Lowest_level__c from Territory2 where Derived_Parent_Segment1__c=:territoryKey];
        return childTerritories;
        
    }
    
    public static String getOpptyQuery(String territory,Date startDate,Date endDate, Integer level)
    {
        
        String query = 'SELECT  CurrencyIsoCode, Expected_Product__c, Expected_Service__c,'+ 
            'Name, Opportunity_Status__c, Territory2.Name, Territory2Id,'+ 
            'Territory2.Lowest_Level__c, Territory2.Node_Lowest_level__c, Territory2.Derived_Segment1__c,'+
            'closedate, Fiscal_Year__c, Fiscal_Quarter__c, Fiscal_Month_of_QTR__c, Fiscal_Week_of_Month__c,'+  
            'Owner.Email,Owner.Name, ForecastCategoryName '+ 
            'FROM Opportunity '+ 
            'WHERE (Opportunity_Status__c = :opptyStatus) '+  
            'and CloseDate >= :startDate '+ 
            'and CloseDate <= :endDate '+ 
            'and Territory2Id = :territoryIdList '+
            'ORDER BY CloseDate, Territory2.Name, DealId__c';
        return query;
    }
    
    public static List<Id> getOpptyTerritoryList(String territory, Integer level){
        String terrWhereClause = (level == 8)?'Territory2.Name':'Territory2.Level_'+level+'_Territory__c';
        
        String terrQuery = 'Select Id from Territory2 where '+terrWhereClause+' in (:territory)';
        List<Territory2> territoryList= Database.query(terrQuery);
        
        List<Id> territoryIdList = new List<Id>();
        for(Territory2 terr: territoryList){
            territoryIdList.add(terr.Id);
        }
        return territoryIdList;
    }
    
    public static Map<String,Decimal> getCurrencyRates(){
        List<CurrencyType> currencyType= [select isocode, conversionrate from currencytype];
        Map<String,Decimal> currencyMap = new Map<String,Decimal>();
        for(CurrencyType curr: currencyType){
            currencyMap.put(curr.IsoCode,curr.ConversionRate);
        }
        return currencyMap;
        
    }
    
    public static List<PeriodMap> calculateRollup(String territory,Date startDate,Date endDate, Integer level)
    {
        String opptyStatus = 'Active';
        String forecastCategoryNameAvoid = 'Omitted';
        
        
        List<Id> territoryIdList = getOpptyTerritoryList(territory, level);
        String query = getOpptyQuery(territory,startDate,endDate,level);
        
        List<Opportunity> result = Database.query(query);
        
        Map<String,Decimal> currencyMap = getCurrencyRates();
        
        List<PeriodMap> periodList = new List<PeriodMap>();
        
        for(Opportunity oppty: result){
            String periodId = oppty.Fiscal_Year__c + oppty.Fiscal_Quarter__c + oppty.Fiscal_Month_of_QTR__c + 'M';
            
            PeriodMap periodMap = null;
            
            for(PeriodMap period: periodList){
                if(period.periodId.equalsIgnoreCase(periodId)){
                    periodMap = period;
                    break;
                }
            }
            
            if(periodMap == null){
                periodMap = new PeriodMap();
                periodMap.periodId = periodId;
                
                periodList.add(periodMap);
            }
            
            periodMap = (PeriodMap) forecastBucket(oppty,periodMap,currencyMap);
            
            
        }
        
        
        return periodList;
    }
    
    
    public static List<TeamView> prepareTeamview(String territory,Date startDate,Date endDate, Integer level,String periodId)
    {
        String opptyStatus = 'Active';
        String forecastCategoryNameAvoid = 'Omitted';
        
        List<Id> territoryIdList = getOpptyTerritoryList(territory, level);
        String query = getOpptyQuery(territory,startDate,endDate,level);
        
        List<Opportunity> result = Database.query(query);
        List<String> territoryList = new List<String>();
        
        Map<String,Decimal> currencyMap = getCurrencyRates();
        
        List<TeamView> teamViewList = new List<TeamView>();
        
        for(Opportunity oppty: result){
            String opptyPeriodId = oppty.Fiscal_Year__c + oppty.Fiscal_Quarter__c + oppty.Fiscal_Month_of_QTR__c + 'M';
            if(!opptyPeriodId.equalsIgnoreCase(periodId))
            {
                continue;
            }
            String territoryname = oppty.Territory2.Name;
            String territorykey = oppty.Territory2.Derived_Segment1__c;
            String lowestlevelflag = oppty.Territory2.Lowest_Level__c?'Y':'N';
            String nodelowestlevelflag = oppty.Territory2.Node_Lowest_Level__c?'Y':'N';
            
            TeamView teamview = null;
            
            for(TeamView territoryteamview: teamViewList){
                if(territoryteamview.territoryname.equalsIgnoreCase(territoryname)){
                    teamview = territoryteamview; 
                    break;
                }
            }
            
            if(teamview == null){
                teamView = new TeamView();
                teamView.territoryname = territoryname;
                teamView.fdaterritoryname = territoryname;
                teamView.territorykey = territorykey;
                teamView.lowestlevelflag = lowestlevelflag;
                teamView.nodelowestlevelflag = nodelowestlevelflag;
                
                
                teamviewList.add(teamView);
                territoryList.add(territoryname);
            }
            
            teamView = (TeamView) forecastBucket(oppty,teamView,currencyMap);
            
            
        }
        
        teamViewList = updateTeamView(teamViewList, territory, territoryList);
        return teamViewList;
    }
    
    public static List<TeamView> updateTeamView(List<TeamView> teamViewList,String territory,List<String> territoryList){
        List<Territory2> childTerritories = getChildTerritoryList(territory);
        for(Territory2 terr: childTerritories){
            if(territoryList.contains(terr.Name)){
                continue;
            }
            else{
                TeamView teamView = new TeamView();
                teamView.territoryname = terr.Name;
                teamView.fdaterritoryname = terr.Name;
                teamView.territorykey = terr.Derived_Segment1__c;
                teamView.lowestlevelflag = terr.Lowest_Level__c?'Y':'N';
                teamView.nodelowestlevelflag = terr.Node_Lowest_level__c?'Y':'N';
                teamviewList.add(teamView);
            }
        }
        
        return teamViewList;
    }
    
    public static PeriodDetails forecastBucket(Opportunity oppty, PeriodDetails values, Map<String,Decimal> currencyMap){
        
        String forecastCategory = oppty.ForecastCategoryName;
        Integer productVal = 0;
        Integer svcVal = 0;
        String opptyCurrencyCode = oppty.CurrencyIsoCode;
        if(oppty.Expected_Product__c != null)
        {
            productVal = (Integer) (oppty.Expected_Product__c/currencyMap.get(opptyCurrencyCode));
        }
        if(oppty.Expected_Service__c != null)
        {
            svcVal = (Integer) (oppty.Expected_Service__c/currencyMap.get(opptyCurrencyCode));
        }
        if(forecastCategory.equalsIgnoreCase('Closed')){
            values.key1_col1_val += productVal;
            values.key2_col1_val += svcVal;
        }
        if(forecastCategory.equalsIgnoreCase('Closed') || 
           forecastCategory.equalsIgnoreCase('Commit')){
               values.key1_col2_val += productVal;
               values.key2_col2_val += svcVal;
           }
        if(forecastCategory.equalsIgnoreCase('Closed') || 
           forecastCategory.equalsIgnoreCase('Commit') ||
           forecastCategory.equalsIgnoreCase('Best Case')){
               values.key1_col3_val += productVal;
               values.key2_col3_val += svcVal;
           }
        if(forecastCategory.equalsIgnoreCase('Pipeline') || 
           forecastCategory.equalsIgnoreCase('Commit') ||
           forecastCategory.equalsIgnoreCase('Best Case')){
               values.key1_col4_val += productVal;
               values.key2_col4_val += svcVal;
           }
        return values;
    }
    
    
}