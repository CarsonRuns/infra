/*
Author          : Anjali
Release         : May 3rd, 2019 Release
Created         : April 11, 2019
Functionality   : Btach Job to Integrate Qualifications in CRMDB


Modification History:
Itrack#        Date         Author       Change 
US277513       4/18/2019    Anjali       New Contract(Parent/Child) Request Automation   
US277544       5/18/2019    Hardik       A-TCCV Contract Automation
US293454       5/30/2019    Hardik       Change Request (CR) Automation
US318316       6/02/2019    Awnish       Code Cleanup and Fix for Parent Record Summation Issue
*/
global class BatchForCRMDB implements Database.Batchable<sObject>,Schedulable  {
    
    //Collecting the batches of records for CRMDB to be passed to execute
    global Database.QueryLocator start(Database.BatchableContext BC) {
        DateTime todayQuery = system.Today().addDays(-7);
        String query;
        //Added for Test Class to fecth the test data
        if(Test.isRunningTest()){
            query = 'SELECT ID,Contract_Year_1_Revenue__c,Total_CMS_Booking_Value_000__c,Name,Service_Account_Manager__c,Integrated_with_CRMDB__c,Opportunity__r.Account.Name,Service_Delivery_Manager__c,Opportunity_Deal_ID__c,CMS_Pursuit_Type__c,Qualification_Forecast_Status__c,Contract_Duration__c,CMS_Regional_SDM_Manager__c FROM Qualification__c';
        }
        else{
            query = 'SELECT ID,Contract_Year_1_Revenue__c,Total_CMS_Booking_Value_000__c,Name,Integrated_with_CRMDB__c,Service_Account_Manager__c,Opportunity__r.Account.Name,Service_Delivery_Manager__c,Opportunity_Deal_ID__c,CMS_Pursuit_Type__c,Qualification_Forecast_Status__c,Contract_Duration__c,CMS_Regional_SDM_Manager__c FROM Qualification__c WHERE ID IN (SELECT ParentId FROM Qualification__History WHERE CreatedDate >: todayQuery AND Field =\'Qualification_Forecast_Status__c\') AND Qualification_Forecast_Status__c= \'Booked\' AND CRMDB__c = NULL';
        }
        return Database.getQueryLocator(query);
    }
    
    //Process CRMDB Qualifications. Create CRMDB Parent/Child and Link Qualifications to CRMDB Record
    global void execute(Database.BatchableContext BC, List<Qualification__c> qualificationList) {
        System.debug('In execute method'+qualificationList);
        List<CRMDB__c> crmdbChildList= new List<CRMDB__c>();
        List<CRMDB__c> crmdbParentList= new List<CRMDB__c>();
        List<Qualification__c> qualList = new List<Qualification__c>(); 
        List<Qualification__c>updateQualList = new List<Qualification__c>();
        
        //querying all the Global Parents 
        List<CRMDB__C> parentList = [SELECT ID,Account_Name__c FROM CRMDB__c WHERE Master_Customer_Name__c = NULL];
        Map<ID,ID> parentMap = new Map<ID,ID>();
        //populating map with parents record names
        for(CRMDB__C parent : parentList){
            parentMap.put(parent.Account_Name__c,parent.Id);            
        }
        List<CRMDB__C> parentList1 = [SELECT ID,Account_Name__c,Date_Customer_first_became_CMS_Customer__c,Reference_Account__c,Theater__c,Segment__c,
                                      GES_or_CGEM_Area__c,SDM_Assigned__c,Manager__c,Global_Fortune_500_Rank_2018__c,Customer_Website__c,Industry__c,
                                      US_Fortune_500_Rank_2018__c,Headquarter_Location__c,Countries_Served__c,Revenue_Year__c,Revenue_in_US__c,
                                      Customers__c,Employees__c,Notes__c
                                      FROM CRMDB__c WHERE Master_Customer_Name__c = NULL];
        
        Map<ID,CRMDB__C> parentMap1 = new Map<ID,CRMDB__C>();
        //populating map with parents record names
        for(CRMDB__C parent : parentList1){
            parentMap1.put(parent.Account_Name__c,parent);            
        }
        //for loop based on the value of of cms pursuit type
        for(Qualification__c qualification : qualificationList)
        {         
            //Logic to process qualification with CMS Persuit Type as Renew/New/Expand
            if ((qualification.CMS_Pursuit_Type__c == 'Renew' ||qualification.CMS_Pursuit_Type__c == 'New'|| qualification.CMS_Pursuit_Type__c == 'Expand') && qualification.Integrated_with_CRMDB__c==false){   
                CRMDB__c c = new CRMDB__c();
                //if loop if the parent already exist -- to create child of that parent
                if(parentMap1.get(qualification.Opportunity__r.Account.Id)!=Null){
                    CRMDB__C crmdb = parentMap1.get(qualification.Opportunity__r.Account.Id);
                    c.Date_Customer_first_became_CMS_Customer__c = crmdb.Date_Customer_first_became_CMS_Customer__c;
                    c.Reference_Account__c = crmdb.Reference_Account__c;
                    c.Theater__c = crmdb.Theater__c;
                    c.Segment__c = crmdb.Segment__c;
                    c.GES_or_CGEM_Area__c = crmdb.GES_or_CGEM_Area__c;
                    c.SDM_Assigned__c = String.isNotBlank(qualification.CMS_Regional_SDM_Manager__c)?qualification.CMS_Regional_SDM_Manager__c:crmdb.SDM_Assigned__c;
                    c.Manager__c = String.isNotBlank(qualification.Service_Delivery_Manager__c)?qualification.Service_Delivery_Manager__c:crmdb.Manager__c;
                    c.Global_Fortune_500_Rank_2018__c = crmdb.Global_Fortune_500_Rank_2018__c;
                    c.Headquarter_Location__c = crmdb.Headquarter_Location__c;
                    c.Countries_Served__c = crmdb.Countries_Served__c;
                    c.Revenue_Year__c = crmdb.Revenue_Year__c;
                    c.Revenue_in_US__c = crmdb.Revenue_in_US__c;
                    c.Customers__c = crmdb.Customers__c;
                    c.Employees__c = crmdb.Employees__c;
                    c.Notes__c = crmdb.Notes__c;
                    C.Customer_Website__c = crmdb.Customer_Website__c;
                    c.US_Fortune_500_Rank_2018__c = crmdb.US_Fortune_500_Rank_2018__c;
                    c.Industry__c = crmdb.Industry__c;
                    c.DID__c = qualification.Opportunity_Deal_ID__c;
                    c.Account_Name__c = qualification.Opportunity__r.Account.Id;
                    c.Annual_CMS_Contract_Value__c = qualification.Contract_Year_1_Revenue__c;
                    c.Total_CMS_Contract_Value__c = qualification.Total_CMS_Booking_Value_000__c;
                    c.Annual_CMS_Contract_Value_CR_S__c = qualification.Contract_Year_1_Revenue__c;
                    c.Total_CMS_Contract_Value_CR_S__c = qualification.Total_CMS_Booking_Value_000__c; 
                    c.Contract_Term_Months__c = String.isNotBlank(qualification.Contract_Duration__c)?Integer.valueOf(qualification.Contract_Duration__c) :0;
                    c.Name =  qualification.Name;                      
                    c.Master_Customer_Name__c = parentMap1.get(c.Account_Name__c).Id;
                    c.Active_Customer__c='No-pending activation';
                    crmdbChildList.add(c);
                }
                //if parent doesn't exist then create parent and a child
                else{
                    //creating new parent
                    if(qualification.Name.length()<74){
                        c.Name =  qualification.Name;  }
                    else{
                        c.name = qualification.Name.Substring(0,72) ;
                    }
                    c.Name =  c.Name + ' GLOBAL';
                    c.Account_Name__c = qualification.Opportunity__r.Account.Id;
                    c.DID__c = qualification.Opportunity_Deal_ID__c;
                    c.SDM_Assigned__c = qualification.CMS_Regional_SDM_Manager__c;
                    c.Manager__c = qualification.Service_Delivery_Manager__c;
                    c.Annual_CMS_Contract_Value__c= qualification.Contract_Year_1_Revenue__c;
                    c.Total_CMS_Contract_Value__c= qualification.Total_CMS_Booking_Value_000__c;
                    c.Annual_CMS_Contract_Value_CR_S__c = qualification.Contract_Year_1_Revenue__c;
                    c.Total_CMS_Contract_Value_CR_S__c = qualification.Total_CMS_Booking_Value_000__c; 
                    c.Active_Customer__c='No-pending activation';
                    c.Is_Customer_on_CAP__c='No';
                    crmdbParentList.add(c);
                }
            }
            //Logic to process qualification with CMS Persuit Type as Change Request/A-TCCV
            else if(qualification.CMS_Pursuit_Type__c == 'Change Request' || qualification.CMS_Pursuit_Type__c == 'A-TCCV'){
                qualification.CRMDB__c = parentMap.get(qualification.Opportunity__r.Account.Id); 
                qualification.Integrated_with_CRMDB__c=true;
                qualList.add(qualification); 
                
            }
            qualification.Integrated_with_CRMDB__c=true;
            updateQualList.add(qualification);
        }
        
        try {
            database.update(updateQualList);
            database.upsert(crmdbChildList,false);        
            database.upsert(qualList,false);
            Id srId;
            if(!crmdbParentList.isEmpty()){
                Database.SaveResult[] resultList = database.insert(crmdbParentList);
                List<Id> lstInserted = new List<Id>();
                for (Database.SaveResult sr : resultList) {
                    if (sr.isSuccess()) {
                        lstInserted.add(sr.getId());
                        srId=sr.getId();
                    }            
                }
                if(lstInserted.size()>0){ 
                    DescribeSObjectResult describeResult = lstInserted[0].getSObjectType().getDescribe();
                    // fetch list of field names of case object
                    List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
                    String query = 'SELECT '+ String.join( fieldNames, ',' ) +' FROM CRMDB__c WHERE id IN:lstInserted';
                    List<CRMDB__c> parentRecord = Database.query( query );
                    //copy all parent case details and assign to child case variable
                    List<CRMDB__c> childList = new List<CRMDB__c>();
                    List<CRMDB__c> parentUpdateList = new List<CRMDB__c>();
                    for(CRMDB__c pr:parentRecord){
                        CRMDB__c c = new CRMDB__c();
                        c = pr.clone(false);
                        // assign Parent case look up id value to Child Case Parent Case Number field
                        c.Master_Customer_Name__c = pr.Id; 
                        //String stringToRemove = 'GLOBAL';
                        c.Name = pr.Name.remove('GLOBAL');
                        childLIst.add(c);   
                        //Update Annual and Total CMS value to Zero 
                        pr.Annual_CMS_Contract_Value__c = 0;
                        pr.Total_CMS_Contract_Value__c = 0;
                        pr.Annual_CMS_Contract_Value_CR_S__c = 0;
                        pr.Total_CMS_Contract_Value_CR_S__c = 0; 
                        parentUpdateList.add(pr);
                    }
                    insert childList;
                    update parentUpdateList;
                }
            }
        } 
        catch(Exception e) {
            System.debug('Exception e '+e.getLineNumber());
            System.debug(e);
        }
    }   
    
    global void finish(Database.BatchableContext BC) {
        system.debug('In finish method');
    }
    
    global void execute(SchedulableContext SC) {        
        BatchForCRMDB processBatch = new BatchForCRMDB ();
        Database.executeBatch(processBatch);
    }
}