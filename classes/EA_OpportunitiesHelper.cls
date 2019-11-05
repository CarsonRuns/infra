@RestResource(urlMapping='/processOpps')
global with sharing class EA_OpportunitiesHelper {
    
    static final String CUMULATIVE_KEYWORD = 'Cumulative';
    
    @HttpPost   
    @ReadOnly webservice static String processOpps(String measure, String filter, List<String> metrics, List<String> weeknos ) {
        
        System.debug('@@sd measure: ' + measure);
        System.debug('@@sd filter: ' + filter);
        System.debug('@@sd metrics: ' + metrics);
        system.debug('@@sd weeknos' + weeknos);
        
        //casting weeknos from String to Integer
        List<Integer> weekNumbers = new List<Integer>();
        if(weeknos != null){
        Integer k;
        for(String week : weeknos){
            k = Integer.valueOf(week);
            weekNumbers.add(k);
        }
        }
        system.debug('----weekNumbers----' + weekNumbers);

        Map<String, List<ReturnItem>> metricNameToReturnItems = new Map<String, List<ReturnItem>>();
        List<Period> weeks = new List<Period>();
        if(weekNumbers.size() > 0){
        //applying the filter on weeks as per selected weeks from the dashboard
        weeks = [SELECT Number, StartDate, EndDate, FullyQualifiedLabel FROM Period where Type = 'Week' AND StartDate = THIS_FISCAL_QUARTER AND Number IN : weekNumbers order by StartDate];
        system.debug('-----' + weeks);
        }else{
        weeks = [SELECT Number, StartDate, EndDate, FullyQualifiedLabel FROM Period where Type = 'Week' AND StartDate = THIS_FISCAL_QUARTER order by StartDate];
        }
        // stage out our return items for each week, for each metric passed to us
        for (String m : metrics) {
            for (Period p : weeks) {
                List<ReturnItem> existingItems = metricNameToReturnItems.get(m);
                if (existingItems == null) {
                    existingItems = new List<ReturnItem>();
                }
                
                existingItems.add(new ReturnItem(String.valueOf(p.Number), m, 0.0));
                metricNameToReturnItems.put(m, existingItems);
            }
        }
        
        // for each of the metrics passed to us...
        for (String m : metrics) {
            // get query for this metric
            String q = buildQuery(measure, filter, m);
            
            if (q.length() == 0) continue;
            
            System.debug('@@sd running query for metric: ' + m);
            System.debug('@@sd   query: ' + q);
            
            // execute query for this metric. Note that the maximum # of queries here is 6.
            List<AggregateResult> opps = Database.query(q);
            System.debug('@@sd   query res: ' + opps);
            
            // the metric name determines if this is a cumulative query 
            Boolean isCumulative = m.contains(CUMULATIVE_KEYWORD);
            
            // map aggregate results to weeks
            Map<String, Decimal> resultWeeksToAmts = new Map<String, Decimal>();
            for (AggregateResult res : opps) {
                String week = (String)res.get('Fiscal_Week_String__c');
                Decimal amt = (Decimal)res.get('amt');
                System.debug('@@sd  week: ' + week);
                System.debug('@@sd  amt: ' + amt);
                
                if (week != null && amt != null) {
                    resultWeeksToAmts.put(week, amt);
                }
            }
            
            List<ReturnItem> items = metricNameToReturnItems.get(m);
            Decimal sum = 0;
            if(items!= null){
            for (ReturnItem item : items) {
                
                // from our query results, pull out the amount for this fiscal week and set that into the proper return item
                Decimal amt = resultWeeksToAmts.get(item.week);
                
                if (amt != null) {
                    
                    sum += amt;
                    
                    // if its cumulative, set the amount to the sum of the previous values + this val
                    if (isCumulative) {
                        item.amount = sum;
                    } else {
                        item.amount = amt;
                    }
                } else if (isCumulative) {
                    item.amount = sum;
                }
                //taking remainder to reflect the week number in the quarter
                item.week = String.valueOf(Math.mod(Integer.valueOf(item.week),13) == 0? 13 : Math.mod(Integer.valueOf(item.week),13));
               
            }
            }
        }
        
        
        List<ReturnItem> toReturn = new List<ReturnItem>();
        
        for (String metricName : metricNameToReturnItems.keySet()) {
            List<ReturnItem> items = metricNameToReturnItems.get(metricName);
            toReturn.addAll(items);
            
            // debug only
            // for (ReturnItem item : items) {
            //     System.debug('@@sd return item: ' + item);    
            // }
        }
        
        if (toReturn.size() > 0){
            return JSON.serialize(new PackagedReturnItem(toReturn));  
        }
        
        return '';
    }
    
    public static String buildQuery(String measure, String filter, String metric) {
        String q = '';
        if (metric.contains('QTD Actuals')) {
            // 1 - QTD ACTUALS
            //SCAVA
            q += 'SELECT Fiscal_Week_String__c, sum(' + String.escapeSingleQuotes(measure) + ') amt from Opportunity';
            q += ' WHERE Territory2.Level_2_Territory__c in (\'APJC__\', \'Americas\', \'EMEAR-REGION\')';
            q += ' AND RecordType.Name in (\'Parent Opportunity\', \'Partner Parent Opportunity\', \'Partner Phase Opportunity\', \'Phase Opportunity\',\'Bookings Opportunity\')';
            q += ' AND ' + String.escapeSingleQuotes(filter) + ' CloseDate = this_fiscal_quarter AND  (CloseDate != next_n_days:120 AND StageName in (\'5 - Closed Booked\')) GROUP by Fiscal_Week_String__c';
        } else if (metric.contains('Commit Forecast')) {
            // 2 - Commit Forecast
            q = 'SELECT Fiscal_Week_String__c, sum(' + String.escapeSingleQuotes(measure) + ') amt from Opportunity';
            q += ' WHERE  Territory2.Level_2_Territory__c in (\'APJC__\', \'Americas\', \'EMEAR-REGION\')';
            q += ' AND RecordType.Name in (\'Parent Opportunity\', \'Partner Parent Opportunity\', \'Partner Phase Opportunity\', \'Phase Opportunity\',\'Bookings Opportunity\')';
            q += ' AND ' + String.escapeSingleQuotes(filter) + ' CloseDate = this_fiscal_quarter AND ((CloseDate != next_n_days:120 AND StageName in (\'5 - Closed Booked\')) OR ((CloseDate != last_n_days:120 OR CloseDate = today) AND ForecastCategoryName in (\'Commit\'))) GROUP by Fiscal_Week_String__c';
        } else if (metric.contains('Best Case Forecast')) {
            // 3 - Best Case Forecast
            q = 'SELECT Fiscal_Week_String__c, sum(' + String.escapeSingleQuotes(measure) + ') amt from Opportunity';
            q += ' WHERE Territory2.Level_2_Territory__c in (\'APJC__\', \'Americas\', \'EMEAR-REGION\')';
            q += ' AND RecordType.Name in (\'Parent Opportunity\', \'Partner Parent Opportunity\', \'Partner Phase Opportunity\', \'Phase Opportunity\',\'Bookings Opportunity\')';
            q += ' AND ' + String.escapeSingleQuotes(filter) + ' CloseDate = this_fiscal_quarter AND ((CloseDate != next_n_days:120 AND StageName in (\'5 - Closed Booked\')) OR ((CloseDate != last_n_days:120 OR CloseDate = today) AND ForecastCategoryName in (\'Commit\',\'Best Case\'))) GROUP by Fiscal_Week_String__c';
        } else if (metric.contains('ROQ Open Pipeline')) {
            // 4 - ROQ Open Pipeline
            q = 'SELECT Fiscal_Week_String__c, sum(' + String.escapeSingleQuotes(measure) + ') amt from Opportunity';
            q += ' WHERE Territory2.Level_2_Territory__c in (\'APJC__\', \'Americas\', \'EMEAR-REGION\')';
            q += ' AND RecordType.Name in (\'Parent Opportunity\', \'Partner Parent Opportunity\', \'Partner Phase Opportunity\', \'Phase Opportunity\',\'Bookings Opportunity\')';
            q += ' AND ' + String.escapeSingleQuotes(filter) + ' CloseDate = this_fiscal_quarter AND (CloseDate != last_n_days:120 OR CloseDate = today) AND ForecastCategoryName in (\'Commit\',\'Best Case\',\'Pipeline\') GROUP by Fiscal_Week_String__c';
        } else if (metric.contains('Forecast to Go')) {
            // 5 - Forecast to Go
            q = 'SELECT Fiscal_Week_String__c, sum(' + String.escapeSingleQuotes(measure) + ') amt from Opportunity';
            q += ' WHERE Territory2.Level_2_Territory__c in (\'APJC__\', \'Americas\', \'EMEAR-REGION\')';
            q += ' AND RecordType.Name in (\'Parent Opportunity\', \'Partner Parent Opportunity\', \'Partner Phase Opportunity\', \'Phase Opportunity\',\'Bookings Opportunity\')';
            q += ' AND ' + String.escapeSingleQuotes(filter) + ' CloseDate = this_fiscal_quarter AND (CloseDate != last_n_days:120 OR CloseDate = today) AND ForecastCategoryName in (\'Commit\') GROUP by Fiscal_Week_String__c';
        } else if (metric.contains('Past Due Commit')) {
            // 6 - Past Due Commit
            q = 'SELECT Fiscal_Week_String__c, sum(' + String.escapeSingleQuotes(measure) + ') amt from Opportunity';
            q += ' WHERE Territory2.Level_2_Territory__c in (\'APJC__\', \'Americas\', \'EMEAR-REGION\')';
            q += ' AND RecordType.Name in (\'Parent Opportunity\', \'Partner Parent Opportunity\', \'Partner Phase Opportunity\', \'Phase Opportunity\',\'Bookings Opportunity\')';
            q += ' AND ' + String.escapeSingleQuotes(filter) + ' CloseDate = this_fiscal_quarter AND (CloseDate = last_n_days:120 AND CloseDate != today) AND ForecastCategoryName in (\'Commit\') GROUP by Fiscal_Week_String__c';
        }
        return q;
    }
    // response classes for analytics
    public class ReturnItem {
        public String week;
        public String Measures;
        public Decimal amount;
        public ReturnItem(String w, String qt, Decimal amt) {
            this.week = w;
            this.Measures = qt;
            this.amount = amt;
      //  System.debug('@@sd   ReturnItem  qt: ' + qt);
      //  System.debug('@@sd   ReturnItem amt: ' + amt);
      //  System.debug('@@sd   ReturnItem   w:' + w);
        }
    }
    public class ReturnMetadata {
        public List<String> strings;
        public List<String> numbers;
        public List<String> groups;
        public ReturnMetadata(List<String> strings, List<String> numbers, List<String> groups) {
            this.strings = strings;
            this.numbers = numbers;
            this.groups = groups;
        }
    }
    public class PackagedReturnItem {
        public List<ReturnItem> data;
        public ReturnMetadata metadata;
        public PackagedReturnItem(List<ReturnItem> data) {
            this.data = data;
            this.metadata = metadata;
            this.metadata = new ReturnMetadata(new List<String>{'week', 'Measures'}, new List<String>{'amount'}, new List<String>());
        }
    }
}