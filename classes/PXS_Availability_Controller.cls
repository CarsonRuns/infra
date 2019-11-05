/***************************************************************************************************

Name    : PXS_Availability_Controller
Author  : 
Purpose : This class is used to dispaly the Bid Managers Availability details         
Created Date: April 5th 2017
Modification History: 
         
*****************************************************************************************************/


public class PXS_Availability_Controller{        
        private List<String> months { get; set; }
        private final Case cse;
        public String selMonth { get; set; } 
        public String selSite { get; set; }
        private DateTime selDateTime;
        private DateTime selEndDateTime;
        private Date selDate1;
        private Date selEndDate1;
        public Boolean calendarVisible { get; set; }
        public class Day {
            public Integer value { get; set; }
            public String display { get; set; }            
            public Day(){
                value = 0;
                display = null;
            }
        }
        public class Header {
            public String top { get; set; }
            public String bottom { get; set; }
            public Header(){
                top = null;
                bottom = null;
            }
        }             
        public List<Header> headers = null;
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
        
        public list<PXS_Level_of_Service__c> getAllColourCode(){
            return [select Name ,Level_of_Service_color_code__c from PXS_Level_of_Service__c order by Name];
        }
        public PXS_Availability_Controller(ApexPages.StandardController stdController){          
            if(!Test.isRunningTest()){             
               stdController.addFields(new List<String>{'Id','Opportunity_Territory_Level_01__c','Opportunity_Territory_Level_02__c'});
            }                           
            this.cse = (case)stdController.getRecord(); 
            if(cse.Opportunity_Territory_Level_02__c != label.PXS_GES && cse.Opportunity_Territory_Level_01__c != null) {
               this.selSite =  cse .Opportunity_Territory_Level_01__c;            
            } 
            else {
               this.selSite =  cse .Opportunity_Territory_Level_02__c;            
            }                          
            //setup the current month is default month.         
            this.selMonth = date.newInstance(datetime.now().date().year(),datetime.now().date().month(),1).format(); 
            //Setup months list
            months = new List<String> {'January','February','March','April','May','June','July','August',
                                        'September','October','November','December' };                          
            ShowAvailability();
        }
         //*@Class: PM Availability information container*/
        public class BIDMAvailability  {
            public case caseData { get; set; } //CPOC Reuqets            
            public List<Day> days { get; set; } //Request by day    
            public List<Double> hours { get; set; } //Hours worked in given day   
            public user  bPersonal { get; set; } // CPOC Personnels         
            public BIDMAvailability(){
                caseData = null;
                bPersonal = null;
                days = new List<Day>(); 
                hours = new List<Double> ();
                
            }
        }
         
        Transient public List<BIDMAvailability> caseBIDMAvailability { get; set; } 
        //This method is show Availability based on seletec type from UI (i.e Room, bidmanager, etc.. )
        public void ShowAvailability(){
            getBidMangerAvailability();               
        }
        
        
        //*@method: getter for Month listing(*/
        public List<SelectOption> getDynMonth(){
            List<SelectOption> dynMonth = new List<SelectOption>();
            Date currDate = null;
            if(currDate == null){
               currDate = Date.today();
            } else {                
                 currDate =datetime.now().date();
            }           
            Integer currMonth = currDate.month() - 4;
            Integer year = currDate.year();
            Integer day = currDate.day();
            boolean b = false;
            //Add next 12 months as choice in dropdown
            for(Integer i = 0; i < 12; i++){
                Integer month = Math.mod(currMonth+i,12); 
                //Increment year
                if(month == 0 && i != 0){
                   year++;
                }  
                if(month < 0 && !b){
                  year =  year - 1;
                  b = true;
                }
                if(Month == -3)
                {
                   month = 9;                      
                }
                if(month == -2){
                   month = 10;                 
                }
                if(month == -1){
                   month = 11;                 
                }
                Date myDate = ((i == 0) ? date.newInstance(year, month + i + 1, 1) : date.newInstance(year, month + 1, 1));             
                dynMonth.add(new SelectOption(myDate.format(), months[month] + ' ' + year.format().replace('.','').replace(',','')));             
                currDate = currDate.addMonths(1);               
            }               
            return dynMonth;
        }
        /*@method: Grab default availability information for PXS Case related to chosen site*/
        public BIDMAvailability getDefaultAvailability(case caseRecord, User perData ){
            BIDMAvailability newAvail = new BIDMAvailability();
            Date selDate = Date.parse(selMonth);
            newAvail.caseData = caseRecord;  
            newAvail.bPersonal = perData;  
            for(Integer i = 0; i < Date.daysInMonth(selDate.year(), selDate.month()); i++){
                Day tempDay = new Day();
                tempDay.value = 0;
                tempDay.display = 'no_data_box';                
                newAvail.days.add(tempDay);
                newAvail.hours.add(0.0);
            }
            return newAvail;
        }  

      @TestVisible private void loadDefaultValues(){
            ApexPages.getMessages().clear();
            Date selDate = Date.parse(selMonth).toStartOfMonth(); 
            selDate1 = Date.newInstance(selDate.year(), selDate.month(), 1);             
            selEndDate1 = Date.newInstance(selDate.year(), selDate.month()+1, 1);            
            selDateTime = DateTime.newInstance(selDate.year(), selDate.month(),1);             
            selEndDateTime = DateTime.newInstance(selDate.year(), selDate.month()+1,1);                        
        }

        // This method is used to get the PXS BID Manager Availability for the selected sales region/entity location
        public void getBidMangerAvailability(){
            Map<Id, BIDMAvailability> personalAvailability = new Map<Id, BIDMAvailability>(); 
            map<Id,Id> mpPersonalFinalLst = new map<Id,Id>();            
            caseBIDMAvailability = new List<BIDMAvailability>();
            loadDefaultValues();
            calendarVisible = false; 
            list<Case> casePersonals = new List<Case>();
            try{
            //This query is to retrive the Bid manager and location details from the PXS_Bid_Manager__c object
                list<PXS_Bid_Manager__c> BidManagers=[SELECT Bid_Manager__c,Bid_Manager__r.FirstName,Bid_Manager__r.LastName, Name from PXS_Bid_Manager__c where Name =: selSite ORDER BY Bid_Manager__r.FirstName ];
                set<id> setIds = new set<id>();
                for(PXS_Bid_Manager__c pes : BidManagers){
                    setIds.add(pes.Bid_Manager__c);
                    if(pes.Bid_Manager__c != null){
                          User pUser = new User(id= pes.Bid_Manager__c,FirstName=pes.Bid_Manager__r.FirstName,LastName = pes.Bid_Manager__r.LastName);                                                           
                          if(!personalAvailability.containsKey(pUser.Id)){                          
                               BIDMAvailability newAvail = getDefaultAvailability(null,pUser);                                        
                               personalAvailability.put(pUser.Id, newAvail);
                         }  
                    }                   
                }
                // This Query to retrieve PXS Requests BID Manager Availability based on selected location & Start, End dates 
                    casePersonals = [SELECT Id,CaseNumber,ownerid,owner.name,owner.FirstName, owner.LastName, Opportunity_Account_Name__c,Proposal_Due_Date__c, Owner_Change_Date__c,Level_of_Service__c from Case where (ownerid in:setIds) AND RecordTypeId=:Utilities.getRequestPXSRecordTypeId() AND (status='In Process') AND 
                    (Opportunity_Territory_Level_02__c=:selSite or Opportunity_Territory_Level_01__c=:selSite) AND ((Owner_Change_Date__c >=: selDateTime AND Owner_Change_Date__c <=: selEndDateTime) OR (Proposal_Due_Date__c >=: selDate1 AND Proposal_Due_Date__c <=: selEndDate1) OR(Owner_Change_Date__c <=: selDateTime AND Proposal_Due_Date__c >=: selEndDate1)) ORDER BY owner.name];                                 
               //Calculate Personal Availability
                for(Case cpr : casePersonals){
                    User pUser = new User(); 
                    pUser.id= cpr.ownerid;             
                    pUser.FirstName =cpr.owner.FirstName;
                    pUser.LastName = cpr.owner.LastName;
                    mpPersonalFinalLst.put(cpr.ownerid,cpr.id);                
                    BIDMAvailability newAvail = getDefaultAvailability(cpr,pUser);  
                    caseBIDMAvailability.add(addBriefingAvailability(newAvail,cpr.Owner_Change_Date__c, cpr.Proposal_Due_Date__c)); 
                                             
                } 
                caseBIDMAvailability = finalPersonalsData(mpPersonalFinalLst,personalAvailability,caseBIDMAvailability);
                if(!caseBIDMAvailability.isEmpty()){
                    calendarVisible =true;
                }
                caseBIDMAvailability = setStatusColors(caseBIDMAvailability);
                
            }
            
            catch (Exception e){
                 System.debug('Exception --'+e.getMessage());
            }
        }
         @TestVisible private List<BIDMAvailability> finalPersonalsData(map<id,Id> mpIds,  Map<Id, BIDMAvailability> mpPersonals,List<BIDMAvailability> inputList){
            for(Id Per : mpPersonals.keySet()){
                if(!mpIds.containsKey(Per)){
                  BIDMAvailability personalAv = mpPersonals.get(Per);
                  inputList.add(personalAv);
                }
            }
            return inputList;
        }
        
       //This method is used to set the colour of the i.e. green , red
        public List<BIDMAvailability> setStatusColors(List<BIDMAvailability> inputList){  
            List<BIDMAvailability> result = new List<BIDMAvailability>();           
            for(Integer j = 0; j < inputList.size(); j++){
                BIDMAvailability input = inputList.get(j);
                Date selDate = Date.parse(selMonth).toStartOfMonth();                
                DateTime currDateTime = selDateTime;   
                string techType = input.caseData.Level_of_Service__c;                
                if(input != null ){                     
                    for(Integer i = 0; i < input.days.size(); i++){
                        input.days[i].display = 'no_data';    
                        if(input.days[i].value > 0){  
                            PXS_Level_of_Service__c PrimaryArch = PXS_Level_of_Service__c.getInstance(techType);                         
                           input.days[i].display = (PrimaryArch == null) ? '' : PrimaryArch.Level_of_Service_color_code__c; 
                        }      
                        //Weekend Override                    
                        if(currDateTime.format('E').trim().equalsIgnoreCase('Sat') || currDateTime.format('E').trim().equalsIgnoreCase('Sun')){  
                            PXS_Level_of_Service__c PrimaryArchPto = PXS_Level_of_Service__c.getInstance('Weekend');                          
                            input.days[i].display = (PrimaryArchPto == null) ? '' : PrimaryArchPto.Level_of_Service_color_code__c;
                        }                                                                                                                                              
                        selDate = selDate.addDays(1);
                        currDateTime = DateTime.newInstance(selDate.year(), selDate.month(), selDate.day());                        
                    }              
                }               
                result.add(input);
            }                          
            return result;
            
        }
               
        /*@method: Grab actual availability data for PXS Request related to chosen site*/
        public BIDMAvailability addBriefingAvailability(BIDMAvailability currAvail, DateTime startDate,Date endDate){
            DateTime currTime = startDate;
            DateTime currEndTime = ((endDate == null) ? startDate.Date() : endDate);
            Date currEnd = ((endDate == null) ? startDate.Date() : endDate);
            Date CorrectEndate = ((endDate == null) ? startDate.Date() : endDate);
            //Choose correct startDay based on roomData OR month roll-back
            if(startDate.month() != selDate1.month()){
                currTime = DateTime.newInstance(selDateTime.year(), selDateTime.month(), 1);
            }             
            //Choose correct endDay based on roomData OR month roll-over
            if(CorrectEndate.month() != selDate1.month()){
                currEndTime = DateTime.newInstance(selDateTime.year(), selDateTime.month(), Date.daysInMonth(selDateTime.year(), selDateTime.month()), 23, 59, 59);  
                currEnd = Date.newInstance(selDate1.year(), selDate1.month(), Date.daysInMonth(selDate1.year(), selDate1.month()));          
            }                       
            //EXCEPTIONS
            //PMAvailability null
            if(currAvail == null){
                return null;
            }                                  
            //CALCULATE - roomData times, hours
            for(Integer i = currTime.day()-1; i <= currEnd.day()-1; i++){
                currAvail.days[i].value++;                
                    //CALCULATE - hourly                    
                    //End scenario - days were the same
                    if(currTime.day() == currEndTime.day()){                        
                        currAvail.hours[i] += (((currEndTime.getTime() - currTime.getTime())/1000.0)/60.0)/60.0;
                    }
                    /*if(curr.day() == currEnd.day()){                        
                        currAvail.hours[i] += (((currEnd.getDate() - curr.getDate())/1000.0)/60.0)/60.0;
                    }*/
                    //End scenario - i iterated through
                    else if(i == currEndTime.day()-1 ){
                        if(currEndTime == CorrectEndate){                           
                           currAvail.hours[i] += (((currEndTime.getTime() - DateTime.newInstance(currEndTime.year(), currEndTime.month(), currEndTime.day()).getTime())/1000.0)/60.0)/60.0;
                        } else {                                                        
                            currAvail.hours[i] += 24.0;
                        }
                    //Normal scenario - start date or iterating through
                    } else {
                        if(i == currTime.day()-1 ){                            
                           currAvail.hours[i] += (((DateTime.newInstance(currTime.year(), currTime.month(), currTime.day()).addDays(1).getTime() - currTime.getTime())/1000.0)/60.0)/60.0;
                        } else {                            
                            currAvail.hours[i] += 24.0;
                        }
                    }                               
            }                       
            return currAvail;
        }         
        
        
             
     /*@method: getter for PXS Lab site listing*/
            public List<SelectOption> getDynSite(){
                    List<SelectOption> options = new List<SelectOption>();
                    set<String> setUniqueTerritory = new set<String>();
                    
                    for(Opportunity_Territory_Name__c setting : Opportunity_Territory_Name__c.getAll().values()){
                        if(!setUniqueTerritory.contains(setting.Territory_Name__c)){}
                            options.add(new SelectOption(setting.name, setting.Territory_Name__c));
                            setUniqueTerritory.add(setting.Territory_Name__c);
                            options.sort();
                            }
                  
            return options; 
               
    }
    }