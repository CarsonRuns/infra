/*
  myOverduePSSWorkspaces_CT
  author: Cong Chen
  
  custom controller that handles all the backend for the myOverduePSSWorkspaces apex class
  
  The URL would look something like this:
  ....../apex/myOverduePSSWorkspaces?option=overdue&territory=oneClick
  You have two URL variables: option and territory.
  territory can be a territory name or 'oneclick'
  option can be 'overdue'(>30) or 'pastdue'(>14, <30)
  
  option determines whether it is pastdue or overdue
  territory tells the system to either look up all the possible BA Territories under the logged in user or to simply match on whatever territory is given to it.

*/

public with sharing class myOverduePSSWorkspaces_CT {

     //Variables
    public AT_Workspace__c[] workspaces = new AT_Workspace__c[]{};
    private final String currentUserId;
    private final String currentUsername;
    private String sortDirection = 'ASC';
    private String sortExp = 'pssTeam';
    public Integer overdueDaysA { get; set;} // left side of the range of overdueDates
    public Integer overdueDaysB { get; set;} // right side of the range of overdueDates
    public String BATerritory = 'oneClick'; // String that holds the information of the current BA Territory
    private Integer i;
    
    // Flag that determines whether it is overdue or pastdue
    public boolean isOverdueOption { get; set; } 
    
    // Variables for territory handling
    public String territoriesString { get; set;}
    public String[] territories = new String[]{};
    public User[] territoryUsers = new User[]{};
    
    // Testing purposes
    //public String temp1 { get; set; }
    //public String temp2 { get; set; }
    
    // Default query string and is INCLUSIVE
    private String qry;
    private String qryA, qryB, qryC;
    private String qryTerritories;
    
    // sortExpression variable and it's getters and setters
    public String sortExpression {
        get {
            return sortExp;
        }
        set {
            //if the colum is clicked on, then switch between Asc and Des modes
            if (value == sortExp)
                sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
            else
                sortDirection = 'ASC';
            sortExp = value;
        }
    }
    
    // Default Constructor
    public myOverduePSSWorkspaces_CT() {
        this.currentUserId = UserInfo.getUserId(); //Set the current user ID
        this.currentUsername = UserInfo.getUserName().split('@')[0]; //Set the current username
        
        if (System.currentPagereference().getParameters().get('territory') == 'oneClick') {
            // Query to get the BA Territories for the current user
            qryTerritories = 'SELECT BA_Territories__c, Id FROM User WHERE Id = :currentUserId';
        
            // Go through the returned data and parse it assuming the form:
            //    BA Territory , Number
            territoryUsers = Database.query(qryTerritories); // Should always return a list of size 1
            territoriesString = territoryUsers[0].BA_Territories__c;
//            System.debug('territoriesString='+territoriesString);
            territories = territoriesString.split(',[0123456789 ]+\n'); // Regex splitting
//            System.debug('territories count='+territories.size());
            territoriesString = '';
            
            // Creating the appropriate String version of the array to inject into the query
            for (i = 0; i < territories.size(); i++) {
//                System.debug('territories[i]='+territories[i]);
//                territories[i] = '\'' + territories[i].trim() + ' ' + currentUsername + '\''; // Adding username
                territories[i] = '\'' + territories[i].trim() + '\''; // trim and quote
                //territories[i] = '\'' + territories[i].substring(0, territories[i].indexOf(',')) + '\''; // trim and quote
//                System.debug('stripped territories[i]='+territories[i]);
                territoriesString = territoriesString + ',' + territories[i];
//                System.debug('building:'+territoriesString);
            }
            territoriesString = territoriesString.substring(1); // get rid of the extra comma in the beginning
            
        }
        else {
            // Add the BA Territory given from the URL into string to be injected into the query
            BATerritory = System.currentPagereference().getParameters().get('territory');
//            territoriesString = '\'' + BATerritory + ' ' + currentUsername + '\'';
            territoriesString = '\'' + BATerritory + '\'';
        }
        
        // Test print outs
        //temp2 = '\'blah blah team\',\'cool\',\'asdfasdfsadf\'';
        //temp1 = 'salt1' + territoriesString +'salt2';
        
        // Default chunks of Query, by default, it is inclusive
        // The point of having them in chunks is that for pastdue, we want a range but for overdue, we only want the condition of greater than something.
        // This way, we can differentiate between the ranges and still be sourced from one original query
        qryA = 'SELECT Id, Name, Workspace_Stage__c, AT_Forecast_Status__c,  forecast_status__c, AT_Expected_Book_Date__c,  Account_Name__c, Opportunity__r.Name, expected_book_date__c, PSS_Workspace_Status__c, Opportunity__r.Opportunity_Status__c, AT_Team__c, AT_Expected_Product__c, PSS__c, AT_No_of_days_Overdue__c, Deal_ID__c, expected_product_000__c FROM AT_Workspace__c WHERE PSS__c = :currentUserId AND AT_No_of_days_Overdue__c >= :overdueDaysA  AND AT_Team__c IN (' + territoriesString + ') ';
        qryB = 'AND AT_No_of_days_Overdue__c <= :overdueDaysB ';
        qryC = 'AND PSS_Workspace_Status__c = \'Active\' AND AT_Forecast_Status__c IN (\'Commit\',\'Upside\') AND Forecast_Position_ID__c > \'0\' AND Forecast_Position_ID__c <> NULL AND Deal_ID__c <> NULL ORDER BY ';
        
        // By default, all the values are set assuming it's an overdue case
        // Note: This is set in case the page is called and nothing is passed in through the flag
        this.isOverdueOption = true; // by default, set this flag to true
        this.overdueDaysA = 30;
        this.overdueDaysB = null;
        qry = qryA + qryC;
        
        // Get the option from the url to determine whether is overdue or pastdue
        if (System.currentPagereference().getParameters().get('option') == 'overdue') {
            this.isOverdueOption = true;
            this.overdueDaysA = 30;
            this.overdueDaysB = null;
            qry = qryA + qryC;
        }
        else if (System.currentPagereference().getParameters().get('option') == 'pastdue') {
            this.isOverdueOption = false;
            this.overdueDaysA = 14;
            this.overdueDaysB = 30;
            qry = qryA + qryB + qryC;
        }
        system.debug(qry);
        viewData(); //generate the table
    }
    
    public PageReference viewData() { //Populates the table with values in a certain order
        //Use the appropriate field name when doing the query
        String temp = sortExpression;
        if (sortExpression == 'pssName')
            temp = 'Name';
        else if (sortExpression == 'opptyName')
            temp = 'Opportunity__r.Name';
        else if (sortExpression == 'accountName')
            temp = 'Account_Name__c';
        else if (sortExpression == 'dealID')
            temp = 'Deal_ID__c';
        else if (sortExpression == 'pssExpectedBookDate')
            temp = 'AT_Expected_Book_Date__c';
        else if (sortExpression == 'pssWorkspaceStatus')
            temp = 'PSS_Workspace_Status__c';
        else if (sortExpression == 'pssExpectedProduct')
            temp = 'AT_Expected_Product__c';
        else if (sortExpression == 'pssForecastStatus')
            temp = 'AT_Forecast_Status__c';
        else if (sortExpression == 'pssTeam')
            temp = 'AT_Team__c';
        else if (sortExpression == 'opptyExpectedBookDate')
            temp = 'expected_book_date__c';
        else if (sortExpression == 'opptyStatus')
            temp = 'Opportunity__r.Opportunity_Status__c';
        else if (sortExpression == 'opptyExpectedProduct')
            temp = 'expected_product_000__c';
        else if (sortExpression == 'opptyForecastStatus')
            temp = 'forecast_status__c';

        //build the full sort expression
        String sortFullExp = temp + ' ' + sortDirection;
        
        //Forming the query that is inclusive ordered according to the fields
        String qry1 = qry.replace('ORDER BY', 'ORDER BY ' + sortFullExp + ' LIMIT 1000');
        
        if (isOverdueOption) {
            // overdue case
            //Forming the query that is exclusive ordered according to the fields; = qry1 with > and < instead of >= and <=
            String qry2 = qry1.replace('>=', '>');
            workspaces = Database.query(qry2);
        }
        else {
            // pastdue case
            workspaces = Database.query(qry1);
        }
        return null;
    }
    
    // function that updates the information changed from inlineEditting
    public PageReference save() {
        try {
            update(workspaces);
 
            String url = '/apex/myOverduePSSWorkspaces' + '?option='+ System.currentPagereference().getParameters().get('option')+
                     '&territory='+ System.currentPagereference().getParameters().get('territory');
            System.debug('url='+url);
            PageReference pr = new PageReference(url);
            pr.setRedirect(true);
            return pr;
        }
        catch (System.DMLException e) {
            ApexPages.addMessages(e);
            return null;
        }
        return null;
    }
    
    public PageReference cancel() {
        viewData();
        return null;
    }
    
    // Getters and Setters
    public String getStringOverdueDaysA() {
        return String.valueOf(overdueDaysA);
    }
    
    public String getStringOverdueDaysB() {
        return String.valueOf(overdueDaysB);
    }
        
    public AT_Workspace__c[] getWorkspaces() {
        return workspaces;
    }
        
    public String getSortDirection() {
        //if not a column is selected
        if (sortExpression == null || sortExpression == '')
            return 'ASC';
        else
            return sortDirection;
    }
    
    public void setSortDirection(String value) {
        sortDirection = value;
    }
    
    // Test method to get coverage by salesforce
    public static testMethod void testMethods() {
        System.currentPageReference().getParameters().put('option', 'pastdue');
        myOverduePSSWorkspaces_CT c = new myOverduePSSWorkspaces_CT();
        c.save();
        c.cancel();
        c.getStringOverdueDaysA();
        c.getStringOverdueDaysB();
        c.getWorkspaces();
        c.getSortDirection();
        c.setSortDirection('ASC');
        
        c.sortExpression = 'opptyName';
        c.viewData();
        
        c.sortExpression = 'accountName';
        c.viewData();
        
        c.sortExpression = 'dealID';
        c.viewData();
        
        c.sortExpression = 'pssExpectedBookDate';
        c.viewData();
        
        c.sortExpression = 'pssWorkspaceStatus';
        c.viewData();
        
        System.currentPageReference().getParameters().put('option', 'overdue');
        myOverduePSSWorkspaces_CT c2 = new myOverduePSSWorkspaces_CT();
    }
}