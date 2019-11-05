/***************************************************************************************************
Name    : CEE_PMLoadBalanceController 
Author  : Eric Pesch
Purpose : Controller for the PM Load Balancing page to determine PM Availability by Briefing/Booked counts  
Created Date: Dec 1 2014
Modification History: 
Eric Pesch - Jan 5 2015: Added Comments, cleanup       
Eric Pesch - Feb 5 2015: Fix - Double counting backup PM in briefing if same as Primary PM
Eric Pesch - Feb 10 2015: Enhancement - New logic for Total Briefing Days, Request Status filtering  
Eric Pesch - Feb 24 2015: Fix - Edge case for multi-day Briefings spanning months, PTO spans months
Jay Dash - Nov Release : Removed backup pm counts in PM LoadAvailability page 
*****************************************************************************************************/

public class CEE_PMLoadBalanceController {
    
    /*@Class: Hold Header information*/
    public class Header {
        public String top { get; set; }
        public String bottom { get; set; }
        
        public Header(){
            top = null;
            bottom = null;
        }
    }
    
    /*@class: Hold day-by-day display information*/
    public class Day {
        public Integer value { get; set; }
        public String display { get; set; }
        
        public Day(){
            value = 0;
            display = null;
        }
    }
    
    /*@Class: PM Availability information container*/
    public class PMAvailability implements Comparable{
        public User pmUser { get; set; } //PMs
         
        //Storage variables
        public List<Day> days { get; set; } //Request by day
        public List<Double> hours { get; set; } //Hours worked in given day
        public Integer totalBriefingDays { get; set; } //Total briefing days
        public Integer totalBriefings { get; set; } //Total briefings
        public Integer totalOthers { get; set; } //Total other requests
        public Integer rowIndex { get; set; }
                
        public PMAvailability(){
            pmUser = null;
            days = new List<Day>();
            hours = new List<Double> ();
            totalBriefingDays = 0;
            totalBriefings = 0;
            totalOthers = 0;           
        }
        
        public Integer compareTo(Object compareTo) {
            PMAvailability compareToPM = (PMAvailability)compareTo;
            String userKey = pmUser.FirstName + ' ' + pmUser.LastName;
            String compareUserKey = compareToPM.pmUser.FirstName + ' ' + compareToPM.pmUser.LastName;
            
            if(pmUser.Id == compareToPM.pmUser.Id) return 0;
            if(userKey  > compareUserKey) return 1;
            return -1;
        }
    } 
    
    //Default controller variables
    private static final String TAG = 'CEE_PMLoadBalanceController - ';
    private final ApexPages.StandardController controller;
    private final CEE__c briefing;
    
    //Criteria - current Times
    private DateTime selDateTime;
    private DateTime selEndDateTime;
    
    //Availability list container
    public List<PMAvailability> availability { get; set; }
    
    //Criteria variables - month
    private List<String> months { get; set; }
    public String selMonth { get; set; }    
    
    //Criteria variables - site
    private List<String> sites = null;
    public Boolean selSiteDisabled { get; set; }
    public String selSite { get; set; }
    
    //Display Variables
    private List<String> baseHeaders { get; set; }
    public Boolean calendarVisible { get; set; }
    public List<Header> headers = null;
    public String currBriefing { get; set; }
    public String currBriefingDate { get; set; }
    
    //Iteration Variables
    public List<Integer> repeatCtr { get; set; }
       
    /*@Constructor: Initialize variables to show availability*/
    public CEE_PMLoadBalanceController(ApexPages.StandardController stdController){
        List<String> popFields = new List<String>{'Id','Name','Start_Date_Time__c','Primary_FSO__c', 'Primary_FSO__r.Name'};   
        this.controller = stdController;
        if(!Test.isRunningTest()){
            this.controller.addFields(popFields);
        }        
        this.briefing = (CEE__c)stdController.getRecord();
        this.currBriefing = this.briefing.Name;
        this.currBriefingDate = briefing.Start_Date_Time__c.date().format();
        this.repeatCtr = new List<Integer>();
        
        //Default variables
        this.selSiteDisabled = true;
        this.selMonth = briefing.Start_Date_Time__c.date().format();
        this.selSite = briefing.Primary_FSO__r.Name;
            
        //Setup months list
        months = new List<String> {'January','February','March','April','May','June','July','August','September','October',
            'November','December' };
        baseHeaders = new List<String>();   
        
        getCurrAvailability();
    }  
    
    /*@method: Grab Header display values*/
    public List<Header> getHeaders(){
        Date selDate = Date.parse(selMonth);
        String[] selDayOfWeek = CEE_Utility.getMonthDays(selDate.year(), selDate.month());
        headers = new List<Header>();
        
        for(Integer i = 0; i < Date.daysInMonth(selDate.year(), selDate.month()); i++){
            Header currHead = new Header();
            currHead.top = selDayOfWeek[i];
            currHead.bottom = (i+1).format();
            headers.add(currHead);
        }
        
        return headers;
    }
    
    /*@method: Grab default availability information for PMs related to chosen site*/
    private PMAvailability getDefaultAvailability(User pm){
        PMAvailability newAvail = new PMAvailability();
        Date selDate = Date.parse(selMonth);
        newAvail.pmUser = pm;
        
        for(Integer i = 0; i < Date.daysInMonth(selDate.year(), selDate.month()); i++){
            Day tempDay = new Day();
            tempDay.value = 0;
            tempDay.display = 'no_data_box';
            
            newAvail.days.add(tempDay);
            newAvail.hours.add(0.0);
        }
        
        return newAvail;
    }
    
    /*@method: Grab actual availability data for PMs related to chosen site*/
    public PMAvailability addBriefingAvailability(PMAvailability currAvail, CEE__c briefing, Boolean isPrimary){
        //FIX epesch 2/24/2015 - Multi-month briefing calculations using new DateTime methods
        DateTime currTime = briefing.Start_Date_Time__c;
        DateTime currEndTime = briefing.End_Date_Time__c;
        
        //Choose correct startDay based on Briefing OR month roll-back
        if(briefing.Start_Date_Time__c.month() != selDateTime.month()){
            currTime = DateTime.newInstance(selDateTime.year(), selDateTime.month(), 1);
        } 
        
        //Choose correct endDay based on Briefing OR month roll-over
        if(briefing.End_Date_Time__c.month() != selDateTime.month()){
            currEndTime = DateTime.newInstance(selDateTime.year(), selDateTime.month(), Date.daysInMonth(selDateTime.year(), selDateTime.month()), 23, 59, 59);
            //currEndTime = currEndTime.addDays(-1);
        }
        
        System.debug(TAG + 'currTime - ' + currTime + ' - currEndTime - ' + currEndTime);
        
        //EXCEPTIONS
        //PMAvailability null
        if(currAvail == null){
            System.debug(TAG + 'addBriefingAvailability - Error - null Availability found - PM not mapped to Site');
            return null;
        }
        
        System.debug(TAG + 'adding to PM - ' + currAvail.pmUser.Name + ' - ' + briefing.Name + ' - ' 
                        + briefing.Start_Date_Time__c.format('MM/dd/yyyy HH:mm:ss', UserInfo.getTimeZone().getID()) + ' - ' 
                        + briefing.End_Date_Time__c.format('MM/dd/yyyy HH:mm:ss', UserInfo.getTimeZone().getID()));
        
        
        //CALCULATE - Briefings
        if(briefing.EBC_CBC_Location__c != 'Other/FSO'){
            currAvail.totalBriefings++;
        }
        //CALCULATE - Other requests (Other/EBC)
        else {
            currAvail.totalOthers++;
        }
        
        //CALCULATE - Briefing times, hours
        for(Integer i = currTime.day()-1; i <= currEndTime.day()-1; i++){
            currAvail.days[i].value++;
            
            //CALCULATE - hourly
                System.debug(TAG + 'date - ' + (i+1).format() + ' - ' + currAvail.hours[i]);
                //End scenario - days were the same
                if(currTime.day() == currEndTime.day()){
                    //System.debug(TAG + 'hour A');
                    currAvail.hours[i] += (((currEndTime.getTime() - currTime.getTime())/1000.0)/60.0)/60.0;
                }
                //End scenario - i iterated through
                else if(i == currEndTime.day() - 1){
                    if(currEndTime != briefing.End_Date_Time__c){
                        //System.debug(TAG + 'hour B1');
                        currAvail.hours[i] += 24.0;
                    } else {
                        //System.debug(TAG + 'hour B2');
                        currAvail.hours[i] += (((currEndTime.getTime() - DateTime.newInstance(currEndTime.year(), currEndTime.month(), currEndTime.day()).getTime())/1000.0)/60.0)/60.0;
                    }
                //Normal scenario - start date or iterating through
                } else {
                    if(i == currTime.day() - 1){
                        //System.debug(TAG + 'hour C1');
                        currAvail.hours[i] += (((DateTime.newInstance(currTime.year(), currTime.month(), currTime.day()).addDays(1).getTime() - currTime.getTime())/1000.0)/60.0)/60.0;
                    } else {
                        //System.debug(TAG + 'hour C2');
                        currAvail.hours[i] += 24.0;
                    }
                }
            
            System.debug(TAG + 'date - ' + (i+1).format() + ' - ' + currAvail.hours[i]);
        }
        
        //CALCULATE - Briefing Days
        //NEW epesch 2/10/2015 - add total number of briefing days, not unique number of days in a month
        currAvail.totalBriefingDays = 0;
        for(Integer  i = 0; i < currAvail.days.size(); i++){
            if(currAvail.days[i].value > 0){
                currAvail.totalBriefingDays+= currAvail.days[i].value;
            }
        }                  
        
        return currAvail;
    }
    
    /*@method: Calculate PM status and color-code*/
    public List<PMAvailability> setStatusColors(List<PMAvailability> inputList){
        List<CEE_Calendar__c> blockDays = null; 
        List<PMAvailability> result = new List<PMAvailability>();      

        for(Integer j = 0; j < inputList.size(); j++){
            PMAvailability input = inputList.get(j);
            Date selDate = Date.parse(selMonth).toStartOfMonth();
            Date selEndDate = selDate.addMonths(1); 
            DateTime currDateTime = selDateTime;           
            
            if(input != null){       
                //System.debug(TAG + 'setStatusColors - ' + input.pmUser.FirstName + ' ' + input.pmUser.LastName);
            
                try{
                    blockDays = [SELECT Id, Name, Start_Date__c, End_Date__c, User__c FROM CEE_Calendar__c WHERE User__c =: input.pmUser.Id
                        AND ((Start_Date__c >=: selDate AND Start_Date__c <: selEndDate) OR (End_Date__c >=: selDate AND End_Date__c <: selEndDate))];
                } catch (Exception e){
                    System.debug(TAG + 'No CEE Calendars to retrieve Status Colors - ' + e.getStackTraceString());                
                }                    
                
                for(Integer i = 0; i < input.days.size(); i++){
                    input.days[i].display = 'available';               
                    
                    //Weekend Override
                    //System.debug(TAG + currDateTime.format('EEE, d MMM yyyy HH:mm:ss Z'));
                    if(currDateTime.format('E').trim().equalsIgnoreCase('Sat') || currDateTime.format('E').trim().equalsIgnoreCase('Sun')){
                        //System.debug(TAG + 'Weekend override');
                        input.days[i].display = 'closed';
                    }
                    
                    //Hour override
                    else if(input.hours[i] > 0.0 && input.hours[i] < 4.0){
                        //System.debug(TAG + 'Hour - Partial override - ' + input.hours[i].format());
                        input.days[i].display = 'partial';
                    } else if(input.hours[i] >= 4.0){
                        //System.debug(TAG + 'Hour - Full override - ' + input.hours[i].format());
                        input.days[i].display = 'unavailable';
                    }
                    
                    /*
                    //TODO - Number overrides removed based on new business requirements - Jan 2015
                    //2 briefings
                    else if(input.days[i].value == 2){
                        System.debug(TAG + 'Number Two override - ' + input.days[i].value);
                        input.days[i].display = 'two_brief';
                    }
                    //3 briefings
                    else if(input.days[i].value == 3){
                        System.debug(TAG + 'Number Three override - ' + input.days[i].value);
                        input.days[i].display = 'three_brief';
                    }
                    //4+ briefings   
                    else if(input.days[i].value >= 4){
                        System.debug(TAG + 'Number Four override - ' + input.days[i].value);
                        input.days[i].display = 'four_brief';
                    }*/
                    
                    //Calendar Override
                    //FIX epesch 2/24/2015 - now spans multi-month
                    if(blockDays != null && blockDays.size() > 0){
                        for(CEE_Calendar__c blockDay : blockDays){
                            //System.debug(TAG + 'Iterating blockDays - ' + blockDay.Name + ' - ' + blockDay.Start_Date__c + ' -> ' + blockDay.End_Date__c.addDays(1));
                            //System.debug(TAG + 'currDateTime - ' + currDateTime + ' - formatted - ' + currDateTime.format('MM/dd/yyyy HH:mm:ss', UserInfo.getTimeZone().getID()));
                            if((currDateTime >= (blockDay.Start_Date__c)) && (currDateTime <= (blockDay.End_Date__c.addDays(1)))){
                                //System.debug(TAG + 'Vacation override');
                                input.days[i].display = 'closed';
                            }
                        }
                    }
                    
                    selDate = selDate.addDays(1);
                    currDateTime = DateTime.newInstance(selDate.year(), selDate.month(), selDate.day());
                    //System.debug(TAG + 'currColor - ' + input.days[i].display);         
                }
                
                blockDays = null;
            }
            
            result.add(input);
        }
                
        return result;
    }
    
    /*@method: Refresh availability list*/
    public void getCurrAvailability(){   
        List<CEE__c> briefings = null;
        Set<ID> pmIdList = new Set<ID>();
        Map<Id, PMAvailability> managerAvailability = new Map<Id, PMAvailability>();
        ApexPages.getMessages().clear();        
        
        //Return variables
        if(availability == null){
            availability = new List<PMAvailability>();
        } else {
            availability.clear();
        }
        calendarVisible = false;
        
        //Date variables
        Date selDate = Date.parse(selMonth).toStartOfMonth();
        Date selEndDate = selDate.addMonths(1);
        selDateTime = DateTime.newInstance(selDate.year(), selDate.month(), 1);
        selEndDateTime = DateTime.newInstance(selDate.year(), selDate.month()+1, 1);
        
        //Determine PMs chosen
        try{
            //Find PM based on mapping for site
            List<Briefing_PM__c> managers = [SELECT Id, Site_Name__c, Primary_PM__c, Primary_PM__r.FirstName, Primary_PM__r.LastName, Secondary_PM__c, Secondary_PM__r.FirstName, Secondary_PM__r.LastName FROM Briefing_PM__c WHERE Site_Name__c =: selSite];
            
            for(Briefing_PM__c manager : managers){
                
                if(manager.Primary_PM__c != null){
                    User pmUser = new User();
                    pmIdList.add(manager.Primary_PM__c);
                    pmUser.Id = manager.Primary_PM__c;
                    pmUser.FirstName = manager.Primary_PM__r.FirstName;
                    pmUser.LastName = manager.Primary_PM__r.LastName;
                                                          
                    if(!managerAvailability.containsKey(pmUser.Id)){
                        //Create new availability block
                        System.debug(TAG + 'adding primary PM - ' + pmUser.Name + '-' + pmUser.FirstName + pmUser.LastName); 
                        PMAvailability newAvail = getDefaultAvailability(pmUser);                        
                        
                        managerAvailability.put(pmUser.Id, newAvail);
                    }  
                }
                
                if(manager.Secondary_PM__c != null){
                    User pmUser = new User();
                    pmIdList.add(manager.Secondary_PM__c);              
                    pmUser.Id = manager.Secondary_PM__c;
                    pmUser.FirstName = manager.Secondary_PM__r.FirstName; 
                    pmUser.LastName = manager.Secondary_PM__r.LastName;                   
                   
                    if(!managerAvailability.containsKey(pmUser.Id)){
                        //Create new availability block
                        System.debug(TAG + 'adding secondary PM - ' + pmUser.Name+ '-' + pmUser.FirstName + pmUser.LastName);
                        PMAvailability newAvail = getDefaultAvailability(pmUser);                        
                        
                        managerAvailability.put(pmUser.Id, newAvail);
                    }                                
                }
            }
        } catch (Exception e){
            System.debug(TAG + 'Unable to find retrieve PMs - ' + e.getStackTraceString());
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, 'Unable to retrieve PMs for the chosen site'));
            
            return;
        }
        
        String[] filterList = System.Label.CEE_PM_Load_Balance_Filter.split('//');
        for(String s : filterList){
            System.debug(TAG + 'Filter - ' + s);
        }
        
        try{
            //Retrieve briefings for pm list
            //NEW - Add filter by Request Status
            //FIX epesch 2/24/2015 - selEndTime filtering by Start_Date_Time__c, NOT End_Date_Time__c
            briefings = [SELECT Id, Name, Primary_FSO__c,Primary_FSO__r.Name, Backup_PM__c, Program_Manager__c, Start_Date_Time__c, End_Date_Time__c, EBC_CBC_Location__c FROM CEE__c 
                        WHERE (Program_Manager__c in : pmIdList) AND Request_Status__c in : (filterList)
                        AND ((Start_Date_Time__c >=: selDateTime AND Start_Date_Time__c <: selEndDateTime) OR (End_Date_Time__c >=: selDateTime AND End_Date_Time__c <: selEndDateTime))];
        } catch (Exception e){
            System.debug(TAG + 'Unable to retrieve briefings, or none available - ' + e.getStackTraceString());
        }
        
        //Populate Days
        for(CEE__c briefing : briefings){
            //Calculate primary PM
            PMAvailability primaryAvailability = null; 
            PMAvailability backupAvailability = null;
            
            if(briefing.Program_Manager__c != null){
               primaryAvailability = managerAvailability.get(briefing.Program_Manager__c);
               managerAvailability.put(briefing.Program_Manager__c, addBriefingAvailability(primaryAvailability, briefing, true));
            }
                            
        } 
        
        //Add PM data to availability list
        List<PMAvailability> currValues = managerAvailability.values();
        availability = setStatusColors(currValues);       

        //Populate availability for PM
        if(availability.size() > 0){
            calendarVisible = true;
        }
        
        return;
    }
    public void setCurrAvailability(){ }
    
    /*@method: getter for Month listing(*/
    public List<SelectOption> getDynMonth(){
        List<SelectOption> dynMonth = new List<SelectOption>();
        Date currDate = null;
        
        if(briefing != null){
            currDate = briefing.Start_Date_Time__c.date();
        } else {
            currDate = Date.today();
        }
        Integer currMonth = currDate.month() - 1;
        Integer year = currDate.year();
        
        //Add next 12 months as choice in dropdown
        for(Integer i = 0; i < 12; i++){
            Integer month = Math.mod(currMonth+i,12);
            
            //Increment year
            if(month == 0 && i != 0){
                year++;
            }
            
            dynMonth.add(new SelectOption(currDate.format(), months[month] + ' ' + year.format().replace('.','').replace(',','')));
            currDate = currDate.addMonths(1);
        }
        
        return dynMonth;
    }
    public void setDynMonth(List<SelectOption> options){ }
    
    /*@method: getter for EBC-only site listing*/
    public List<SelectOption> getDynSite(){
        List<SelectOption> dynSite = new List<SelectOption>();
        try{
            List<CEE_Location__c> sites = [SELECT Id, Name FROM CEE_Location__c WHERE Location_Type__c =: 'EBC/EC' ORDER BY Name Asc];
            
            for(CEE_Location__c site : sites){
                dynSite.add(new SelectOption(site.Name,site.Name));    
            }            
            
            this.selSiteDisabled = false;
        } catch (Exception e){
            System.debug(TAG + e.getStackTraceString());
            dynSite.add(new SelectOption('Unable to retrieve sites','Unable to retrieve sites', true));
        }
        
        return dynSite;
    }
    public void setDynSite(List<SelectOption> sites){ }
}