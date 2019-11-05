/***************************************************************************************************

Name    : CPOC_LoadBalanceController 
Author  : Sudi
Purpose : This class is used to calculate the CPOC Request, Room, Personal and Shared Resource Availability.         
Created Date: Jan 25 2016
Modification History: 
         Sudi - 17 Aug 2016 : Normalization, Added try catch blocks for missing methods.
*****************************************************************************************************/
public class CPOC_LoadBalanceController {
        
        private List<String> months { get; set; }
        public String selMonth { get; set; } 
        public Boolean selSiteDisabled { get; set; }
        public String selSite { get; set; }
        private DateTime selDateTime;
        private DateTime selEndDateTime;
        public Boolean calendarVisible { get; set; }
        public Boolean calenderSharedRes {get; set;}
        public string selectedType {get;set;}
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
        public list<CPOC_Primary_Architecture__c> getAllColourCodes(){
            return [select Name ,Architecture_Colour_Code__c from CPOC_Primary_Architecture__c order by Name];
        }
         /*@Class: PM Availability information container*/
        public class PMAvailability implements Comparable{
            public CEE__c cpocLocData { get; set; } //CPOC Reuqets
            public string ceeRequestId {get;set;}
            public user  cpocPersonal { get; set; } // CPOC Personnels
            public CEE_Room__c cpocRoom {get;set;} // CPOC Room 
            public CPOC_All_Shared_Resources__c cpocSharedRes { get; set;}
            //Storage variables
            public List<Day> days { get; set; } //Request by day    
            public List<Double> hours { get; set; } //Hours worked in given day
            public list<CEE__c> requestIds {get;set;} 
            public PMAvailability(){
                cpocLocData = null;
                cpocPersonal = null;
                ceeRequestId = null;
                cpocRoom = null;  
                cpocSharedRes = null;
                days = new List<Day>(); 
                hours = new List<Double> ();
                requestIds = new list<CEE__c>();
            }
            
            public Integer compareTo(Object compareTo) {
                PMAvailability compareToPM = (PMAvailability)compareTo;
                String userKey = cpocLocData.Name ;
                String compareUserKey = compareToPM.cpocLocData.Name ;
                
                if(cpocLocData.Id == compareToPM.cpocLocData.Id) return 0;
                if(userKey  > compareUserKey) return 1;
                return -1;
            }
        } 
        Transient public List<PMAvailability> CPOCReqAvailability { get; set; } 
        Transient public List<PMAvailability> CPOCRoomAvailability { get; set; }
        Transient public List<PMAvailability> CPOCPersonalAvailability { get; set; }
        Transient public List<PMAvailability> CPOCShareResourceAvailability { get; set; }
        private static final String TAG = 'CPOC_LoadBalanceController - ';        
        private final CEE__c briefing;
        public CPOC_LoadBalanceController(ApexPages.StandardController stdController){                                    
             if(!Test.isRunningTest()){             
                stdController.addFields(new List<String>{'Id','Name','Preferred_Lab__c','Requested_Customer_Arrival_Date__c'});
             }                               
            this.briefing = (CEE__c)stdController.getRecord();    
            //setup the current month is default month.         
            this.selMonth = date.newInstance(datetime.now().date().year(),datetime.now().date().month(),1).format();            
            // setup the default type
            if(selectedType == null){
                selectedType = 'All';
            }
            // Setup the default location
            if(briefing.Preferred_Lab__c != null) {
                this.selSite =  briefing.Preferred_Lab__c ;            
            }
            //Setup months list
            months = new List<String> {'January','February','March','April','May','June','July','August',
                                        'September','October','November','December' };      
            ShowAvailability();
        }
        //This method is show Availability based on seletec type from UI (i.e Room, personal, etc.. )
        public void ShowAvailability(){
            if(selectedType == 'CPOC_Request')
                getCPOCRequestAvailability();
            if(selectedType == 'CPOC_Room')
                getCPOCRoomAvailability();
            if(selectedType == 'CPOC_Personal')
                getPersonalAvailability();
            if(selectedType == 'CPOC_SharedResource')
                getCPOCSharedResourceAvailability(); 
            if(selectedType == 'All'){
                getCPOCRequestAvailability();
                getCPOCRoomAvailability();
                getPersonalAvailability();
                getCPOCSharedResourceAvailability(); 
            }
        }
     /*@method: getter for Month listing(*/
        public List<SelectOption> getDynMonth(){
            List<SelectOption> dynMonth = new List<SelectOption>();
            Date currDate = null;
            
            if(briefing == null){
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
                system.debug('Month ---> ' + month);
                //Increment year
                if(month == 0 && i != 0){
                    year++;
                }
                //fixed the new year problem  
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
        /*@method: Grab default availability information for CPOC Request related to chosen site*/
        private PMAvailability getDefaultAvailability(CEE__c ceeRecord, User perData, CEE_Room__c roomData,
                                                      CPOC_All_Shared_Resources__c cSharedResource,string reqId){
            PMAvailability newAvail = new PMAvailability();
            Date selDate = Date.parse(selMonth);
            newAvail.cpocLocData = ceeRecord;
            newAvail.ceeRequestId = reqId;
            newAvail.cpocPersonal = perData;
            newAvail.cpocRoom = roomData;
            newAvail.cpocSharedRes = cSharedResource;
            
            for(Integer i = 0; i < Date.daysInMonth(selDate.year(), selDate.month()); i++){
                Day tempDay = new Day();
                tempDay.value = 0;
                tempDay.display = 'no_data_box';                
                newAvail.days.add(tempDay);
                newAvail.hours.add(0.0);
            }
            
            return newAvail;
        }        
        private void loadDefaultValues(){
            ApexPages.getMessages().clear();
            Date selDate = Date.parse(selMonth).toStartOfMonth();           
            selDateTime = DateTime.newInstance(selDate.year(), selDate.month(), 1);             
            selEndDateTime = DateTime.newInstance(selDate.year(), selDate.month()+1, 1);                        
        }
        // This method is used to get the CPOC Personal Availability for the select CPOC location
        public void getPersonalAvailability(){

            Map<Id, PMAvailability> personalAvailability = new Map<Id, PMAvailability>(); 
            map<Id,Id> mpPersonalFinalLst = new map<Id,Id>();            
            CPOCPersonalAvailability = new List<PMAvailability>();
            loadDefaultValues();
            try{
                //Getting all Personal for the selected location
                list<Personnel__c> lstPersonal = [SELECT User__c,User__r.firstName, User__r.LastName,CPOC_Location__c, Is_Active__c 
                                                  FROM Personnel__c 

                                                  WHERE CPOC_Location__r.Name =:selSite AND Is_Active__c = TRUE ORDER BY User__r.firstName];
                //Setting the default Map with empty availability for the all CPOC personal for the seletec location
                for(Personnel__c pes : lstPersonal){
                    if(pes.User__c != null){
                          User pUser = new User(id= pes.User__c,FirstName =pes.User__r.FirstName,LastName = pes.User__r.LastName);                                                           
                          if(!personalAvailability.containsKey(pUser.Id)){                          
                               PMAvailability newAvail = getDefaultAvailability(null,pUser,null,null,null);                                        
                               personalAvailability.put(pUser.Id, newAvail);
                         }  
                    }                   
                }
                // This Query to retrieve CPOC Requests personal based on selected location & Start, End dates              
                list<CPOC_Personnel__c> cpocPersonals = [SELECT Id,Customer_Engagements_Events__c,Customer_Engagements_Events__r.Name,
                                                            Personnel__c,Personnel__r.User__c,Customer_Engagements_Events__r.CPOC_Start_Date__c, 
                                                            Customer_Engagements_Events__r.CPOC_End_Date__c,CPOC_Start_Date__c,CPOC_End_Date__c,
                                                            Personnel__r.User__r.FirstName,Personnel__r.User__r.LastName,Customer_Engagements_Events__r.Primary_Architecture__c                                                     
                                                        FROM CPOC_Personnel__c                       

                                                        WHERE Customer_Engagements_Events__r.Preferred_Lab__c =:selSite 
                                                        AND Customer_Engagements_Events__r.Request_Status__c = 'Scheduled'
                                                        AND ((CPOC_Start_Date__c >=: selDateTime AND CPOC_Start_Date__c <=: selEndDateTime)
                                                        OR (CPOC_End_Date__c >=: selDateTime AND CPOC_End_Date__c <=: selEndDateTime)
                                                        OR(CPOC_Start_Date__c <=: selDateTime AND CPOC_End_Date__c >=: selEndDateTime))
                                                        ORDER BY Personnel__r.User__r.FirstName];                                      
                 //Calculate Personal Availability
                for(CPOC_Personnel__c cpr : cpocPersonals){                             
                    CEE__c briefing = new CEE__c();
                    briefing.Id= cpr.Customer_Engagements_Events__c;
                    briefing.Primary_Architecture__c = cpr.Customer_Engagements_Events__r.Primary_Architecture__c;              
                    briefing.CPOC_Start_Date__c= cpr.Customer_Engagements_Events__r.CPOC_Start_Date__c;
                    briefing.CPOC_End_Date__c = cpr.Customer_Engagements_Events__r.CPOC_End_Date__c;
                    User pUser = new User();                                      

                    pUser.id= cpr.Personnel__r.User__c;             
                    pUser.FirstName =cpr.Personnel__r.User__r.FirstName;
                    pUser.LastName = cpr.Personnel__r.User__r.LastName;                
                    mpPersonalFinalLst.put(cpr.Personnel__r.User__c,briefing.id);                
                    PMAvailability newAvail = getDefaultAvailability(briefing,pUser,null,null,cpr.Customer_Engagements_Events__r.Name);  
                    CPOCPersonalAvailability.add(addBriefingAvailability(newAvail,cpr.CPOC_Start_Date__c,cpr.CPOC_End_Date__c));                           
                } 
                CPOCPersonalAvailability = finalPersonalsData(mpPersonalFinalLst,personalAvailability,CPOCPersonalAvailability);
                CPOCPersonalAvailability = setStatusColors(CPOCPersonalAvailability);
            }
            catch (Exception e){
                 System.debug(TAG + e.getStackTraceString());
            }
        }
        // This method is used to get CPOC room availability for selected location
        public void getCPOCRoomAvailability(){

            Map<Id, PMAvailability> roomAvailability = new Map<Id, PMAvailability>();
            map<Id,Id> mpRoomsFinalLst = new map<Id,Id>();
            CPOCRoomAvailability = new List<PMAvailability>();           
            loadDefaultValues();
            try{
                list<CEE_Room__c> lstRooms = [SELECT Name,CEE_Location__c,Active__c 
                                              FROM CEE_Room__c 
                                              WHERE CEE_Location__r.Name =:selSite
                                              AND Active__c = TRUE 
                                              ORDER BY Name];
                for(CEE_Room__c cRoom : lstRooms){          
                    if(!roomAvailability.containsKey(cRoom.Id)){                          
                        PMAvailability newRoomAvail = getDefaultAvailability(null,null,cRoom,null,null);                                        
                        roomAvailability.put(cRoom.Id, newRoomAvail);
                    }  
                }
                 // This Query to retrieve CPOC Requests room based on selected location & Start, End dates           
                list<CPOC_Room__c> cpocRooms = [SELECT Id,Customer_Engagements_Events__c,Customer_Engagements_Events__r.Name, 
                                                    CPOC_Start_Date__c, CPOC_End_Date__c,room__r.Name,room__c,
                                                    Customer_Engagements_Events__r.CPOC_Start_Date__c,Customer_Engagements_Events__r.CPOC_End_Date__c,
                                                    Customer_Engagements_Events__r.Primary_Architecture__c  
                                                FROM CPOC_Room__c                       
                                                WHERE Customer_Engagements_Events__r.Preferred_Lab__c =:selSite AND Customer_Engagements_Events__r.Request_Status__c = 'Scheduled' 
                                                AND ((CPOC_Start_Date__c >=: selDateTime AND CPOC_Start_Date__c <=: selEndDateTime)
                                                OR (CPOC_End_Date__c >=: selDateTime AND CPOC_End_Date__c <=: selEndDateTime)
                                                OR(CPOC_Start_Date__c <=: selDateTime AND CPOC_End_Date__c >=: selEndDateTime))
                                                ORDER By room__r.Name]; 
                //Calculate rooms Availability
                for(CPOC_Room__c cRoom : cpocRooms){
                    CEE__c briefing = new CEE__c();
                    briefing.Id= cRoom.Customer_Engagements_Events__c;
                    briefing.Primary_Architecture__c = cRoom.Customer_Engagements_Events__r.Primary_Architecture__c;                
                    briefing.CPOC_Start_Date__c= cRoom.Customer_Engagements_Events__r.CPOC_Start_Date__c;
                    briefing.CPOC_End_Date__c = cRoom.Customer_Engagements_Events__r.CPOC_End_Date__c;              
                    CEE_Room__c CpocRoom = new CEE_Room__c(id = cRoom.room__c);
                    CpocRoom.Name = cRoom.room__r.Name;                
                    mpRoomsFinalLst.put(cRoom.room__c,cRoom.Customer_Engagements_Events__c);                
                    PMAvailability newAvail = getDefaultAvailability(briefing,null,CpocRoom,null,cRoom.Customer_Engagements_Events__r.Name);  
                    CPOCRoomAvailability.add(addBriefingAvailability(newAvail,cRoom.CPOC_Start_Date__c,cRoom.CPOC_End_Date__c));
                }
                CPOCRoomAvailability = finalPersonalsData(mpRoomsFinalLst,roomAvailability,CPOCRoomAvailability);
                CPOCRoomAvailability = setStatusColors(CPOCRoomAvailability); 
            }
            catch (Exception e){
                 System.debug(TAG + e.getStackTraceString());
            }
        }
        //This Method is used to get the CPOC Shared resource Availability for the selected location
        public void getCPOCSharedResourceAvailability(){

            map<Id,PMAvailability> sharedResourceAvailability = new Map<Id,PMAvailability>();
            map<Id,Id> mpSharedResourceFinalLst = new map<Id,Id>();
            CPOCShareResourceAvailability = new List<PMAvailability>();
            loadDefaultValues(); 
            calenderSharedRes = false;
            try{
                list<CPOC_All_Shared_Resources__c> lstAllSharedResource = [select Name,CPOC_Location__c,Resource_Name__c from CPOC_All_Shared_Resources__c where CPOC_Location__r.name =:selSite order by Resource_Name__c];
                for(CPOC_All_Shared_Resources__c cShared : lstAllSharedResource){
                    if(!sharedResourceAvailability.containsKey(cShared.Id)){
                         PMAvailability newResourceAvail = getDefaultAvailability(null,null,null,cShared,null);  
                         sharedResourceAvailability.put(cShared.Id,newResourceAvail);
                    }
                }
                if(!lstAllSharedResource.isEmpty())
                    calenderSharedRes= true;
                list<CPOC_Shared_Resource__c> lstCpocSharedResource = [Select Id,Customer_Engagements_Events__c,Customer_Engagements_Events__r.Name, 
                                     CPOC_Start_Date__c, CPOC_End_Date__c,CPOC_All_Shared_Resource__r.Resource_Name__c,
                                     CPOC_All_Shared_Resource__r.Name,CPOC_All_Shared_Resource__c,Customer_Engagements_Events__r.CPOC_Start_Date__c,
                                     Customer_Engagements_Events__r.CPOC_End_Date__c,Customer_Engagements_Events__r.Primary_Architecture__c
                                     From CPOC_Shared_Resource__c                       

                                     WHERE Customer_Engagements_Events__r.Preferred_Lab__c =:selSite AND Customer_Engagements_Events__r.Request_Status__c = 'Scheduled' 
                                     AND ((CPOC_Start_Date__c >=: selDateTime AND CPOC_Start_Date__c <=: selEndDateTime)
                                     OR (CPOC_End_Date__c >=: selDateTime AND CPOC_End_Date__c <=: selEndDateTime)
                                     OR(CPOC_Start_Date__c <=: selDateTime AND CPOC_End_Date__c >=: selEndDateTime)) 
                                     order by CPOC_All_Shared_Resource__r.Resource_Name__c]; 
                                     

                for(CPOC_Shared_Resource__c cSharedRes : lstCpocSharedResource){
                    CEE__c briefing = new CEE__c();
                    briefing.Id= cSharedRes.Customer_Engagements_Events__c;
                    briefing.Primary_Architecture__c = cSharedRes.Customer_Engagements_Events__r.Primary_Architecture__c;               
                    briefing.CPOC_Start_Date__c= cSharedRes.Customer_Engagements_Events__r.CPOC_Start_Date__c;
                    briefing.CPOC_End_Date__c = cSharedRes.Customer_Engagements_Events__r.CPOC_End_Date__c;  
                    CPOC_All_Shared_Resources__c cpocShared = new CPOC_All_Shared_Resources__c(id=cSharedRes.CPOC_All_Shared_Resource__c);
                    cpocShared.Resource_Name__c = cSharedRes.CPOC_All_Shared_Resource__r.Resource_Name__c;               
                    mpSharedResourceFinalLst.put(cSharedRes.CPOC_All_Shared_Resource__c,cSharedRes.Customer_Engagements_Events__c);                   
                    PMAvailability newAvail = getDefaultAvailability(briefing,null,null,cpocShared,cSharedRes.Customer_Engagements_Events__r.Name); 
                    CPOCShareResourceAvailability.add(addBriefingAvailability(newAvail,cSharedRes.CPOC_Start_Date__c,cSharedRes.CPOC_End_Date__c));
                }          
                CPOCShareResourceAvailability = finalPersonalsData(mpSharedResourceFinalLst,sharedResourceAvailability,CPOCShareResourceAvailability);
                CPOCShareResourceAvailability = setStatusColors(CPOCShareResourceAvailability);
            }
            catch (Exception e){
                 System.debug(TAG + e.getStackTraceString());
            }
        }
        //This Method is used to get the CPOC Request Availability for the selected location
        public void getCPOCRequestAvailability(){                                                                                                                  


            ApexPages.getMessages().clear();    
            CPOCReqAvailability = new List<PMAvailability>();                                           
            calendarVisible = false;            
            loadDefaultValues(); 
            try{
                map<Id, CEE__c> mpCEErequest = new map<Id,CEE__c>([SELECT Id, Name,CPOC_Start_Date__c,CPOC_End_Date__c,Primary_Architecture__c,Primary_Account__r.Name                                                                                        
                                                                    FROM CEE__c 

                                                                    WHERE Preferred_Lab__c =:selSite AND Request_Status__c ='Scheduled' 
                                                                    AND ((CPOC_Start_Date__c >=: selDateTime AND CPOC_Start_Date__c <=: selEndDateTime)
                                                                    OR (CPOC_End_Date__c >=: selDateTime AND CPOC_End_Date__c <=: selEndDateTime)
                                                                    OR(CPOC_Start_Date__c <=: selDateTime AND CPOC_End_Date__c >=: selEndDateTime))]); 
                 //Calculate CPOC Request Availability
                for(CEE__c briefing : mpCEErequest.values()){                                
                    PMAvailability newAvail = getDefaultAvailability(briefing,null,null,null,null);                 
                    CPOCReqAvailability.add(addBriefingAvailability(newAvail,briefing.CPOC_Start_Date__c,briefing.CPOC_End_Date__c));                
                } 
                if(!CPOCReqAvailability.isEmpty())
                    calendarVisible = true;                                                   

                CPOCReqAvailability = setStatusColors(CPOCReqAvailability);                                                                                   
            }
            catch (Exception e){
                 System.debug(TAG + e.getStackTraceString());
            }
        }
        //This method is used to add free persons data
        private List<PMAvailability> finalPersonalsData(map<id,Id> mpIds,  Map<Id, PMAvailability> mpPersonals,List<PMAvailability> inputList){
            for(Id Per : mpPersonals.keySet()){
                if(!mpIds.containsKey(Per)){
                  PMAvailability personalAv = mpPersonals.get(Per);
                  inputList.add(personalAv);
                }
            }
            return inputList;
        }      
        //This method is used to set the colour of the i.e. green , red
        public List<PMAvailability> setStatusColors(List<PMAvailability> inputList){            
            List<PMAvailability> result = new List<PMAvailability>();           
            for(Integer j = 0; j < inputList.size(); j++){
                PMAvailability input = inputList.get(j);
                Date selDate = Date.parse(selMonth).toStartOfMonth();                
                DateTime currDateTime = selDateTime;   
                string techType = input.cpocLocData.Primary_Architecture__c;                
                if(input != null){                      
                    for(Integer i = 0; i < input.days.size(); i++){
                        input.days[i].display = 'no_data';    
                        if(input.days[i].value > 0){  
                           CPOC_Primary_Architecture__c PrimaryArch = CPOC_Primary_Architecture__c.getInstance(techType);                         
                           input.days[i].display = (PrimaryArch == null) ? '' : PrimaryArch.Architecture_Colour_Code__c;                         
                        }      
                        //Weekend Override                    
                        if(currDateTime.format('E').trim().equalsIgnoreCase('Sat') || currDateTime.format('E').trim().equalsIgnoreCase('Sun')){  
                            CPOC_Primary_Architecture__c PrimaryArchPto = CPOC_Primary_Architecture__c.getInstance('WeekEnd');                          
                            input.days[i].display = (PrimaryArchPto == null) ? '' : PrimaryArchPto.Architecture_Colour_Code__c;
                        }                                                                                                                                              
                        selDate = selDate.addDays(1);
                        currDateTime = DateTime.newInstance(selDate.year(), selDate.month(), selDate.day());                        
                    }               
                }               
                result.add(input);
            }                   
            return result;
        }
               
        /*@method: Grab actual availability data for CPOC Request related to chosen site*/
        public PMAvailability addBriefingAvailability(PMAvailability currAvail, DateTime startDate,DateTime endDate){
        
            DateTime currTime = startDate;
            DateTime currEndTime = ((endDate == null) ? startDate : endDate);
            DateTime CorrectEndate = ((endDate == null) ? startDate : endDate);                                                 
            //Choose correct startDay based on roomData OR month roll-back
            if(startDate.month() != selDateTime.month()){
                currTime = DateTime.newInstance(selDateTime.year(), selDateTime.month(), 1);
            }             
            //Choose correct endDay based on roomData OR month roll-over
            if(CorrectEndate.month() != selDateTime.month()){
                currEndTime = DateTime.newInstance(selDateTime.year(), selDateTime.month(), Date.daysInMonth(selDateTime.year(), selDateTime.month()), 23, 59, 59);            
            }                       
            //EXCEPTIONS
            //PMAvailability null
            if(currAvail == null){
                System.debug(TAG + 'addBriefingAvailability - Error - null Availability found - PM not mapped to Site');
                return null;
            }                                  
            //CALCULATE - roomData times, hours
            for(Integer i = currTime.day()-1; i <= currEndTime.day()-1; i++){
                currAvail.days[i].value++;                
                    //CALCULATE - hourly                    
                    //End scenario - days were the same
                    if(currTime.day() == currEndTime.day()){                        
                        currAvail.hours[i] += (((currEndTime.getTime() - currTime.getTime())/1000.0)/60.0)/60.0;
                    }
                    //End scenario - i iterated through
                    else if(i == currEndTime.day() - 1){
                        if(currEndTime == CorrectEndate){                           
                            currAvail.hours[i] += (((currEndTime.getTime() - DateTime.newInstance(currEndTime.year(), currEndTime.month(), currEndTime.day()).getTime())/1000.0)/60.0)/60.0;
                        } else {                                                        
                            currAvail.hours[i] += 24.0;
                        }
                    //Normal scenario - start date or iterating through
                    } else {
                        if(i == currTime.day() - 1){                            
                            currAvail.hours[i] += (((DateTime.newInstance(currTime.year(), currTime.month(), currTime.day()).addDays(1).getTime() - currTime.getTime())/1000.0)/60.0)/60.0;
                        } else {                            
                            currAvail.hours[i] += 24.0;
                        }
                    }                               
            }                       
            return currAvail;
        }        
        /*@method: getter for CPOC Lab site listing*/
        public List<SelectOption> getDynSite(){
            List<SelectOption> dynSite = new List<SelectOption>();            
            try{
                List<CEE_Location__c> sites = [SELECT Id, Name 
                                               FROM CEE_Location__c 
                                               WHERE Location_Type__c = 'CPOC' 
                                               ORDER BY Name ASC];
                
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
    }