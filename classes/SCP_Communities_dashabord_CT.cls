/***************************************************************************************************
Name    : SCP_Communities_dashabord_CT 

Modification History: 
Bramha - LnP Dashboard chart fix for non-Engligh language (INC000034265118)
*****************************************************************************************************/ 

public with sharing class SCP_Communities_dashabord_CT {

    public String psr{get;set;}
    public String partner{get;set;}
    public String summaryLeadAgeingPSR{get;set;}
    public String leadAgePSRNotification{get;set;}
    public List <SCP_Alerts__c> lstSCPAlert {get;set;}
    public List<barChartData> leadStatusSummaryData{get;set;}
    public List<barChartData> prospectStatusSummaryData{get;set;}
    public Integer scpAlert {get;set;}
    public Integer leadDealCreatedCount{get;set;}
    public Integer leadDealCreatedNQP{get;set;}
    public String summaryLeadLinks{get;set;}
    public String summaryTPLinks{get;set;}
    public boolean isLeadChartDataAvailable{get;set;}
    public boolean isTPChartDataAvailable{get;set;}
    public boolean isScpMessagesDataAvailable{get;set;}
    public boolean showLeadNoData{get;set;}
    public boolean showTPNoData{get;set;}
    public String leadChartQuery{get;set;}
    public String tpChartQuery{get;set;}
    
    
    //test comment 
    
    public class barChartData{
        public String name{get;set;}
        public Integer data {get;set;}
        
        public barChartData(String name, Integer data){
            this.name = name;
            this.data = data;
        }
    }
    
    public Boolean isPA {
        get {
            return (prmFilterUtility.isPA);
        }
    }
    
    public SCP_Communities_dashabord_CT(ApexPages.StandardController stdController){
        this.dashboardDto = (SCP_Communities_DTO__c)stdController.getRecord();        
        
        // Check for existing cookie
        checkForExistingCookie();
        this.showLeadNoData = false;
        this.showTPNoData = false;
        this.isTPChartDataAvailable = false;
        this.isScpMessagesDataAvailable = false;
        //loadData();
    }
    
    public SCP_Communities_DTO__c dashboardDto{
        get{
            if(this.dashboardDto == null){
                dashboardDto = new SCP_Communities_DTO__c();
            }
            return this.dashboardDto;
        }
        set;
    }
    //add method getPartnerList
    //add variable partnerList
    //add variable partner
    
    ///added by dbibyk
      
      // Modified By: Santhosh 05 Nov 2014 
      // Release : November Sprint 3
      // User Story : US7058
      // Below code is added to populate the Partner name drop down values in Partnar mass update
      public list<selectOption> getPartnerList(){
        list<SelectOption> prtnrOptions = new list<SelectOption>();
        set<SelectOption> prtnrOptionsNew = new set<SelectOption>();
        prtnrOptions.add(new SelectOption('All', 'All'));
        // Loggedin Users Parent Account Id & Name
        String currentPartnerAccountId = prmFilterUtility.loggedInUserPartnerAccount;
        String currentPartnerAccountName = prmFilterUtility.loggedInUserPartnerAccountName;
        //  Add Distibuter Account to the list
        prtnrOptions.add(new SelectOption(currentPartnerAccountId,currentPartnerAccountName));
        //add options from junction object
            
        for(Disti_to_Partner_Mapping__c DP : [Select Partner__c, Channel_Partner__c from Disti_to_Partner_Mapping__c where Distributor__c=:currentPartnerAccountId]){
            if(DP.Partner__c != null){                      
                prtnrOptionsNew.add(new SelectOPtion(DP.Partner__c, DP.Channel_Partner__c));
            }               
        } 
        prtnrOptions.addAll(prtnrOptionsNew);
        return prtnrOptions;
      }
    
    ////
     // Modified By: Santhosh 05 Nov 2014 
     // Release : November Sprint 3
     // User Story : US7058  
     // Boolean flag to check weather the logedin user is Disti user
    public Boolean isDisti {
        get {
            return (prmFilterUtility.loggedInUserIsDisti == 'Distributor' );
        }
    }
    
    public List<selectOption> getPsrList(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('All',Label.PRM_Picklist_Value_All));
        for(User u: getPsrListUsers()){
            options.add(new SelectOption(u.Id,u.name));
        }
        
        return options;
    }
    
    public List<User> psrList;
    
    public List<User> getPsrListUsers(){
        /*if( psrList == null){
            //get\ parent account of running user
            User runningUser = [select contact.account.parent.parentId from User where id = :UserInfo.getUserId() limit 1][0];
            Id parentAccountId = runningUser.contact.account.parentId;
            psrList = [Select u.id, u.Name from User u where u.isactive=true and u.contact.account.parentId=:parentAccountId order by u.Name limit 100];
            
        }
        */
        
        List<String> userFields = new List<String>();
        userFields.add('Id');
        userFields.add('Name');
        
        //rmFilterUtility test = new prmFilterUtility();
        //return test.getUserList(userFields, null, ' Order by Name', null);
        Integer queryLimit = 250;
        prmFilterUtility prmUtil = new prmFilterUtility();
        return prmUtil.getUserList(userFields, null, ' Order by Name', queryLimit);
    }
    
    public void loadData(){
        System.Debug('Start loadData()');
        
        //Summary ALerts
        List<SCP_Alerts__c> summarlAlertList = [SELECT Id , Description__c from SCP_Alerts__c where Start_Date__c <= TODAY AND End_Date__c >= TODAY AND Notification_for__c includes ('Partners Users')];
        //review alerts
        
        //Age on Lead with 'Partner Assigned' status for Partner Admin logged on users only
        if(this.isPA){
            Integer partnerAssignedCount = [SELECT Count() from Lead l where Partner_Lead_Status__c = 'Partner Assigned' and PSR_Assigned_Date__c = NULL and Partner_Assigned_Date__c < LAST_N_DAYS:4 and CREATEDDATE = LAST_N_DAYS:120];
            this.summaryLeadAgeingPSR = Label.PRM_summaryLeadAgeingPSR;
            this.summaryLeadAgeingPSR = this.summaryLeadAgeingPSR.replaceFirst('\\{0\\}',partnerAssignedCount.format()); 
        }
        
        //Age on Leads with 'Assigned to PSR' status
        Integer assignedToPSRCount = [SELECT Count() from lead ld where ld.Partner_Lead_Status__c = 'Assigned To PSR' and ld.PSR_Assigned_Date__c < LAST_N_DAYS:4 and CREATEDDATE = LAST_N_DAYS:120];
        this.leadAgePSRNotification = Label.PRM_leadAgePSRNotification;
        this.leadAgePSRNotification = this.leadAgePSRNotification.replaceFirst('\\{0\\}',assignedToPSRCount.format());
        
        //get alert record to display in SCP Messages
        this.lstSCPAlert = [SELECT Id , Description__c from SCP_Alerts__c where Start_Date__c <= TODAY AND End_Date__c >= TODAY AND Notification_for__c includes ('Partners Users')];
        this.scpAlert = lstSCPAlert.size();
        this.isScpMessagesDataAvailable = false;
            
        if(this.scpAlert > 0){
            this.isScpMessagesDataAvailable = true;
        }
        
        //Get the time frame of lead and TPs to query
        //default time frame is LAST_WEEK
        String timeFrame = this.dashboardDto.View_By_Current_Calendar__c;
        if( 'Year'.equals(timeFrame)){
            timeFrame = 'THIS_YEAR';
        }else if('Quarter'.equals(timeFrame)){
            timeFrame = 'THIS_QUARTER';
        }else if('Month'.equals(timeFrame)){
            timeFrame = 'THIS_MONTH';
        }else{
            timeFrame = 'THIS_WEEK';
        }
        //US8645: Updated SOQL to not use != operator since that will do a full table scan.
        //String leadSummaryQuery = 'Select l.Partner_Lead_Status__c, toLabel(l.Partner_Lead_Status__c) leadStatus, COUNT(l.Id) statusCount, SUM(TotalValue__c) totalValue from Lead l where l.Partner_Lead_Status__c != NULL';
        String leadSummaryQuery = 'Select l.Partner_Lead_Status__c, toLabel(l.Partner_Lead_Status__c) leadStatus, COUNT(l.Id) statusCount, SUM(TotalValue__c) totalValue from Lead l where ';
        String leadDealQuery = 'Select Count(l.Id ) dealCount, SUM(Quote_Product_Net_Price__c) ProductValue, SUM(Quote_Service_Net_Price__c) ServiceValue from lead l where Partner_Lead_Status__c = \'Deal Created\' and Deal_ID__c != NULL and Deal_Create_Date_Time__c = '+timeFrame;
        
        String tpSummaryQuery = 'Select toLabel(a.Partner_Status__c) prospectStatus, COUNT(a.Id) totalCount from Assigned_partner__c a where a.Partner_Status__c != NULL';
        String tpDealQuery = 'Select Id from Assigned_Partner__c where Deal_Create_Date__c = ' + timeFrame;
        
        //Update query based on running user and psr selection
        if(!isPA){
            //running user is not a Partner Admin
          //leadSummaryQuery += ' and l.PSR_Assigned_Date__c = ' + timeFrame;
            leadSummaryQuery += ' l.PSR_Assigned_Date__c = ' + timeFrame;
            tpSummaryQuery += ' and a.PSR_Assigned_Date_Time__c = ' + timeFrame;
        } else if( psr!=null && psr.startsWith('005')){
            //TODO: Replace '005' with custom setting that stores object prefix
            //Update query to get records that users are assigned to
          //leadSummaryQuery += ' and l.PSR_Assigned_Date__c  = '+timeFrame+' and (PSR_1__c = \''+psr+'\' OR PSR_2__c = \''+psr+'\' OR PSR_3__c = \''+psr+'\')';
           // leadSummaryQuery += ' l.PSR_Assigned_Date__c  = '+timeFrame+' and (PSR_1__c = \''+psr+'\' OR PSR_2__c = \''+psr+'\' OR PSR_3__c = \''+psr+'\')';
           //SCAVA FIX
            leadSummaryQuery += ' l.PSR_Assigned_Date__c  = '+timeFrame+' and (PSR_1__c = \''+String.escapeSingleQuotes(psr)+'\' OR PSR_2__c = \''+String.escapeSingleQuotes(psr)+'\' OR PSR_3__c = \''+String.escapeSingleQuotes(psr)+'\')';
           // leadDealQuery += ' and (PSR_1__c = \''+psr+'\' OR PSR_2__c = \''+psr+'\' OR PSR_3__c = \''+psr+'\')';
           //SCAVA FIX
            leadDealQuery += ' and (PSR_1__c = \''+String.escapeSingleQuotes(psr)+'\' OR PSR_2__c = \''+String.escapeSingleQuotes(psr)+'\' OR PSR_3__c = \''+String.escapeSingleQuotes(psr)+'\')';
            
            // prospect queries
            //tpSummaryQuery += ' and a.PSR_Assigned_Date_Time__c = '+timeFrame+' and (Assigned_Partner_Sales_Rep__c = \''+psr+'\' OR Assigned_Partner_Sales_Rep_2__c = \''+psr+'\' OR Assigned_Partner_Sales_Rep_3__c = \''+psr+'\')';
            //SCAVA FIX
            tpSummaryQuery += ' and a.PSR_Assigned_Date_Time__c = '+timeFrame+' and (Assigned_Partner_Sales_Rep__c = \''+String.escapeSingleQuotes(psr)+'\' OR Assigned_Partner_Sales_Rep_2__c = \''+String.escapeSingleQuotes(psr)+'\' OR Assigned_Partner_Sales_Rep_3__c = \''+String.escapeSingleQuotes(psr)+'\')';
            //tpDealQuery += ' and (Assigned_Partner_Sales_Rep__c = \''+psr+'\' OR Assigned_Partner_Sales_Rep_2__c = \''+psr+'\' OR Assigned_Partner_Sales_Rep_3__c = \''+psr+'\')';
            //SCAVA FIX
            tpDealQuery += ' and (Assigned_Partner_Sales_Rep__c = \''+String.escapeSingleQuotes(psr)+'\' OR Assigned_Partner_Sales_Rep_2__c = \''+String.escapeSingleQuotes(psr)+'\' OR Assigned_Partner_Sales_Rep_3__c = \''+String.escapeSingleQuotes(psr)+'\')';
        }else {//Update query to get all records 
            //US8645: Updated SOQL to look at only Partner Assignment data field
            //leadSummaryQuery += ' ((l.Partner_Lead_Status__c = \'Partner Assigned\' and l.Partner_Assigned_Date__c = '+timeFrame + ') ' +
            //' or(l.Partner_Lead_Status__c in (\'Assigned To PSR\',\'Actively Working\',\'Deal Created\',\'Rejected-Invalid Contact\',\'Rejected-Already Deal\',\'Rejected-Project Canceled\',\'Rejected-Lost to Competition\',\'Rejected-Not My Territory/Account\',\'Rejected-No Customer Response\',\'Rejected-Duplicate\',\'Rejected-No Valid Project\',\'Closed-Order Through Stock\',\'Closed-Order Through Disti\') and l.PSR_Assigned_Date__c = '+timeFrame + '))';
            leadSummaryQuery += ' l.Partner_Assigned_Date__c = ' + timeFrame;
            tpSummaryQuery += ' and ((a.Partner_Status__c = \'Partner Assigned\' and a.Partner_Assigned_Date__c = '+timeFrame + ') ' +
                              ' or (a.Partner_Status__c != \'Partner Assigned\' and a.PSR_Assigned_Date_Time__c = '+timeFrame + '))';
        }
        
        //Update queries based on selected country
        if(this.dashboardDto.Country__c!=null){
            leadSummaryQuery += ' and l.CustomCountry__c = \''+this.dashboardDto.Country__c+'\'';
            leadDealQuery +=  ' and l.CustomCountry__c = \''+this.dashboardDto.Country__c+'\'';
            
            // prospect related Queries
            tpSummaryQuery += ' and a.Customer_Account__r.CRCountry__c = \''+this.dashboardDto.Country__c+'\'';
            tpDealQuery += ' and Customer_Account__r.CRCountry__c = \''+this.dashboardDto.Country__c+'\'';            
        }
        
        //Update queries based on entered Province State
        if(this.dashboardDto.State_Province__c!=null && this.dashboardDto.State_Province__c.length()>0){
            String state = this.dashboardDto.State_Province__c.trim().replace('*','%');
            leadSummaryQuery += ' and ( l.CustomState__c like \'%' + state + '%\' or l.state_Province_English__c like \'%' + state + '%\')';
            leadDealQuery +=  ' and ( l.CustomState__c like \'%' + state + '%\' or l.state_Province_English__c like \'%' + state + '%\')';
            
            // prospect related Queries
            tpSummaryQuery += ' and (a.Customer_Account__r.CRState__c like \'%' + state + '%\' or a.Customer_Account__r.State__c like \'%' + state + '%\')';
            tpDealQuery += ' and (Customer_Account__r.CRState__c like \'%' + state + '%\' or Customer_Account__r.State__c like \'%' + state + '%\')';
        }
        
        //Update queries based on Entered City
        if(this.dashboardDto.City__c!=null && this.dashboardDto.City__c.length()>0 && !'All'.equalsIgnoreCase(this.dashboardDto.City__c)){
            String city = this.dashboardDto.City__c.trim().replace('*','%');            
            leadSummaryQuery += ' and (l.CustomCity__c like \'%' + city + '%\' or l.City_English__c  like \'%' + city + '%\')';
            leadDealQuery +=  ' and (l.CustomCity__c like \'%' + city + '%\' or l.City_English__c  like \'%' + city + '%\')';
            
            // prospect related Queries
            tpSummaryQuery += ' and (a.Customer_Account__r.CRCity__c like \'%' + city + '%\' or a.Customer_Account__r.City__c like \'%' + city + '%\')';
            tpDealQuery += ' and (Customer_Account__r.CRCity__c like \'%' + city + '%\' or Customer_Account__r.City__c like \'%' + city + '%\')';
        }
        // If Logedin User is Disti user
        // then create where clause for Partner Name field
        if(isDisti && isPA && this.partner != null && partner != 'All') {
            
            // If Selected Partner is current Distributer Account
            String currentDistiAccountId = prmFilterUtility.loggedInUserPartnerAccount;
            partner = String.escapeSingleQuotes(partner);
            if(partner == currentDistiAccountId) {
                //leadSummaryQuery += ' and l.Channel_Partner__c = \''+partner+'\' AND (l.PSR_1__c != \'\' OR l.PSR_2__c != \'\' OR l.PSR_3__c != \'\' ) AND l.Lead_From_Distributor_lookUp__c = \'\' ';              
                //SCAVA FIX
                leadSummaryQuery += ' and l.Channel_Partner__c = \''+String.escapeSingleQuotes(partner)+'\' AND (l.PSR_1__c != \'\' OR l.PSR_2__c != \'\' OR l.PSR_3__c != \'\' ) AND l.Lead_From_Distributor_lookUp__c = \'\' ';
                //leadDealQuery += ' and l.Channel_Partner__c = \''+partner+'\' AND (l.PSR_1__c != \'\' OR l.PSR_2__c != \'\' OR l.PSR_3__c != \'\' ) AND l.Lead_From_Distributor_lookUp__c = \'\' ';
                //SCAVA FIX
                leadDealQuery += ' and l.Channel_Partner__c = \''+String.escapeSingleQuotes(partner)+'\' AND (l.PSR_1__c != \'\' OR l.PSR_2__c != \'\' OR l.PSR_3__c != \'\' ) AND l.Lead_From_Distributor_lookUp__c = \'\' ';
            }
            else {// Selected Partner is not Current Disti
               //leadSummaryQuery += ' and l.Channel_Partner__c = \''+partner+'\' AND l.Lead_From_Distributor_lookUp__c = \''+currentDistiAccountId+'\'';
                //SCAVA FIX
                leadSummaryQuery += ' and l.Channel_Partner__c = \''+String.escapeSingleQuotes(partner)+'\' AND l.Lead_From_Distributor_lookUp__c = \''+currentDistiAccountId+'\'';
                //leadDealQuery += ' and l.Channel_Partner__c = \''+partner+'\' AND l.Lead_From_Distributor_lookUp__c = \''+currentDistiAccountId+'\'';
                //SCAVA FIX
                leadDealQuery += ' and l.Channel_Partner__c = \''+String.escapeSingleQuotes(partner)+'\' AND l.Lead_From_Distributor_lookUp__c = \''+currentDistiAccountId+'\'';
            }
        }

        leadSummaryQuery += ' GROUP BY l.Partner_Lead_Status__c';
        tpSummaryQuery += ' GROUP BY a.Partner_Status__c';
        
        System.debug(System.LoggingLevel.INFO,'#### Lead Summary Query : '+leadSummaryQuery);
        System.debug(System.LoggingLevel.INFO,'#### Lead Deal Query : '+leadDealQuery);
        
        //Update the Lead Chart data
        List<AggregateResult> groupedLeadStatus = Database.query(leadSummaryQuery);
        this.leadStatusSummaryData = new List<barChartData>();
        this.isLeadChartDataAvailable = false;
        if(groupedLeadStatus.size()>0){
            
            // Map<String,Integer> from Lead Partner Lead Status picklist
            //
            Map<String, String> getlabelMapLead = new Map<String, String>();
            Map<String, Decimal> getValueMapLead = new Map<String, Decimal>();
            Map<String, Integer> dataMap = new Map<String, Integer>();
            Map<String, string> getValueLableMapLead = new Map<String, string>();
            List<String> leadStatusList = new List<String>();
            
            Schema.DescribeFieldResult ta  = Lead.Partner_Lead_Status__c.getDescribe();
            
            for(Schema.Picklistentry sp : ta.getPicklistValues()) {
                //Exclude Parnter Assigned status if running user is PSR
                if(this.isPA || !'Partner Assigned'.equals(sp.value)){
                    leadStatusList.add(sp.value);
                    getlabelMapLead.put(sp.value,sp.label);
                    dataMap.put(sp.value,0);
                    getValueMapLead.put(sp.value,0);
                    getValueLableMapLead.put(sp.label,sp.value);
                }
            }
            
            String leadStatus = '';
            integer lcount = 0;
            Decimal leadTotalValue = 0;            
            for(AggregateResult ar:  groupedLeadStatus) {                
                leadStatus = (String) ar.get('leadStatus');
                leadStatus = getValueLableMapLead.get(leadStatus);
                lcount = ar.get('statusCount') != null ? (Integer) ar.get('statusCount') : 0 ;
                leadTotalValue = ar.get('totalValue') != null ? (Decimal) ar.get('totalValue') : 0 ;                
                if(dataMap != null && dataMap.containsKey(leadStatus)) {
                    lcount += dataMap.get(leadStatus);
                    dataMap.put(leadStatus, lcount);
                    getValueMapLead.put(leadStatus, leadTotalValue);
                }
            }
            
            
            // Itrate through map to create data
            
            String leadStatusWorth = '';
            
              List<String> reverseLeadList = new List<String>();
            
            for(integer i = leadStatusList.size(); i> 0 ; i-- ) {
                reverseLeadList.add(leadStatusList[i-1]);
            }
            
            for(String str : reverseLeadList) {
                leadStatusWorth = getlabelMapLead.get(str) + ' ($'+ getValueMapLead.get(str) + 'K)';
                leadStatusSummaryData.add(new barChartData(leadStatusWorth,dataMap.get(str)));
            }
            
           
            this.isLeadChartDataAvailable = true;
             /*   
             for(AggregateResult ar:groupedLeadStatus){
                String leadStatusWorth = ar.get('leadStatus') + ' ($' + ar.get('totalValue') + 'K)';
                this.leadStatusSummaryData.add(new barChartData(leadStatusWorth,(Integer)ar.get('statusCount')));
            }
            */   
        }
        this.showLeadNoData = this.isLeadChartDataAvailable?false:true;
        
        System.debug(System.LoggingLevel.INFO, '*** Chart Data for leads : '+leadStatusSummaryData);
        
        System.debug('loadData().leadSummaryQuery');
        System.debug(leadSummaryQuery);
        System.debug('loadData().leadStatusSummaryData');
        System.debug(groupedLeadStatus);
        
        ////Generate Lead net qoute price message
        Integer leadDealCreatedCount = 0;
        Decimal leadDealCreatedNQP = 0;
        List<AggregateResult> groupLeadDeal = Database.query(leadDealQuery);
        if(groupLeadDeal!=null && groupLeadDeal.size()>0){
            leadDealCreatedCount = (Integer)groupLeadDeal[0].get('dealCount');
            Decimal productValue = groupLeadDeal[0].get('ProductValue')!=null?(Decimal)groupLeadDeal[0].get('ProductValue'):0;
            Decimal ServiceValue = groupLeadDeal[0].get('ServiceValue')!=null?(Decimal)groupLeadDeal[0].get('ServiceValue'):0;
            leadDealCreatedNQP = productValue + ServiceValue;
        }
        this.summaryLeadLinks = Label.PRM_summaryLeadLinks;
        this.summaryLeadLinks = this.summaryLeadLinks.replaceFirst('\\{0\\}',leadDealCreatedCount.format());
        this.summaryLeadLinks = this.summaryLeadLinks.replaceFirst('\\{1\\}',leadDealCreatedNQP.format());
        System.debug('loadData().leadDealQuery');
        System.debug(leadDealQuery);
        System.debug('loadData().groupLeadDeal');
        System.debug(groupLeadDeal);
        
        //Generate Target Prospect chart Data
        List<AggregateResult> groupedProspectStatus = Database.query(tpSummaryQuery);
        this.prospectStatusSummaryData = new List<barChartData>();
        this.isTPChartDataAvailable = false;
        if(groupedProspectStatus!=null && groupedProspectStatus.size() > 0){
            
            // Map<String,Integer> from Lead Partner Lead Status picklist
            //
            Map<String, String> getlabelMapTP = new Map<String, String>();
            Map<String, String> getValuelabelMapTP = new Map<String, String>();
            Map<String, Integer> dataMapTP = new Map<String, Integer>();
            
            Schema.DescribeFieldResult tp  = Assigned_Partner__c.Partner_Status__c.getDescribe();
            
            List<string> strLabels = new List<String>();
            
            for(Schema.Picklistentry sp : tp.getPicklistValues()) {
                //Exclude Parnter Assigned status if running user is PSR
                //Exclude if status is 'Assigned (New)' for both PA & PSR
                if((this.isPA || !'Partner Assigned'.equals(sp.value)) && !'Assigned (New)'.equals(sp.value)){
                    if(!'Closed'.equals(sp.value) && !'Rejected'.equals(sp.value)){
                        strLabels.add(sp.value);
                        getlabelMapTP.put(sp.value,sp.label);
                        dataMapTP.put(sp.value,0);
                        getValuelabelMapTP.put(sp.label, sp.value);
                    }
                }
            }
            
            System.debug(System.LoggingLevel.INFO, '*** dataMap TP before : '+dataMapTP);
            String tpStatus = '';
            integer tpCount = 0;
            
            for(AggregateResult ar : groupedProspectStatus) {
                
                tpStatus = (String) ar.get('prospectStatus');
                tpStatus = getValuelabelMapTP.get(tpStatus);
                tpCount = ar.get('totalCount') != null ? (Integer) ar.get('totalCount') : 0 ;
                
                if(dataMapTP != null && dataMapTP.containsKey(tpStatus)) {
                    tpCount += dataMapTP.get(tpStatus);
                    dataMapTP.put(tpStatus, tpCount);
                }
            }
            
            System.debug(System.LoggingLevel.INFO, '*** dataMap TP before : '+dataMapTP);
            
            // Itrate through map to create data
            System.debug(System.LoggingLevel.INFO,'*** Map key Set : '+dataMapTP.keySet());
            integer val = 1;
            
            
            List<String> reverseTPList = new List<String>();
            
            for(integer i = strLabels.size(); i> 0 ; i-- ) {
                reverseTPList.add(strLabels[i-1]);
            }
            
            
            for(String str : reverseTPList) {
                
                System.debug(System.LoggingLevel.INFO, 'Order : ' + val + ' Value : '+str);
                val+=1;
                
                prospectStatusSummaryData.add(new barChartData(getlabelMapTP.get(str),dataMapTP.get(str)));
            }
                 
            
            this.isTPChartDataAvailable = true;
          /*
            for(AggregateResult ar:groupedProspectStatus){
                Integer totalCount = ar.get('totalCount')!=null?(Integer)ar.get('totalCount'):0;
                this.prospectStatusSummaryData.add(new barChartData((String)ar.get('prospectStatus'),totalCount));
            }
            */
        }
        this.showTPNoData = this.isTPChartDataAvailable?false:true;
        System.debug(System.LoggingLevel.INFO, '*** Chart Data for TP : '+prospectStatusSummaryData);
        System.debug('loadData().tpSummaryQuery');
        System.debug(tpSummaryQuery);
        System.debug('loadData().prospectStatusSummaryData');
        System.debug(groupedProspectStatus);
        
        //Generate Target Prospect net qoute price message
        Integer tpDealCreatedCount = 0;
        Decimal tpDealCreatedNQP = 0;
        List<Assigned_Partner__c> tpSummaryGoupedResults = Database.query(tpDealQuery);
        System.debug('loadData().tpDealQuery');
        System.debug(tpDealQuery);
        System.debug('loadData().tpSummaryGoupedResults');
        System.debug(tpSummaryGoupedResults);
        if(tpSummaryGoupedResults!=null && tpSummaryGoupedResults.size()>0){
            String ProspectList = '\'';
            for(Integer i=0; i<tpSummaryGoupedResults.size(); i++){
                if(i==0){
                    ProspectList += tpSummaryGoupedResults[0].Id+'\'';
                }else{
                    ProspectList += ', \'' +tpSummaryGoupedResults[0].Id+'\'';
                }
            }
            System.debug('loadData().ProspectList');
            System.debug(ProspectList);
            String dealsQuery = 'Select count_distinct(d.Target_Prospect__c) dealCount, SUM(Quote_Product_Net_Price__c) ProductValue, SUM(Quote_Service_Net_Price__c) ServiceValue ' +
                                  'from Multi_Object_Quote__c d ' +
                                 'where d.Target_Prospect__c IN ('+ ProspectList + ') and d.Deal_Create_Date__c = '+timeFrame;
            List<AggregateResult> groupedProspectDeals = Database.query(dealsQuery);
            System.debug('loadData().dealsQuery');
            System.debug(groupedProspectDeals);
            System.debug('loadData().groupedProspectDeals');
            System.debug(groupedProspectDeals);
            tpDealCreatedCount = (Integer)groupedProspectDeals[0].get('dealCount');
            Decimal productValue = groupLeadDeal[0].get('ProductValue')!=null?(Decimal)groupLeadDeal[0].get('ProductValue'):0;
            Decimal ServiceValue = groupLeadDeal[0].get('ServiceValue')!=null?(Decimal)groupLeadDeal[0].get('ServiceValue'):0;
            tpDealCreatedNQP = productValue + ServiceValue;
        }
        this.summaryTPLinks = Label.PRM_summaryTPLinks;
        this.summaryTPLinks = this.summaryTPLinks.replaceFirst('\\{0\\}',tpDealCreatedCount.format());
        this.summaryTPLinks = this.summaryTPLinks.replaceFirst('\\{1\\}',tpDealCreatedNQP.format());
        
        System.debug('END loadData()');
        this.leadChartQuery = leadSummaryQuery;
        this.tpChartQuery = tpSummaryQuery;
    }
    
    public PageReference doSearch(){
        System.debug('doSearch()');
        System.debug('Calendar' + this.dashboardDto.View_By_Current_Calendar__c);
        System.debug('PSR' + this.psr);
        System.debug('Country' + this.dashboardDto.Country__c);
        System.debug('State' + this.dashboardDto.State_Province__c);
        System.debug('City' + this.dashboardDto.City__c);
        
        // Create Cookie value
        String cookieValue;
        cookieValue =  'calender : '+this.dashboardDto.View_By_Current_Calendar__c;
        cookieValue += ' :: psr : '+this.psr;
        if(this.dashboardDto.Country__c != null) {
            cookievalue += ' :: country : '+this.dashboardDto.Country__c;
        }
        if(this.dashboardDto.State_Province__c != null) {
            cookievalue += ' :: state : '+this.dashboardDto.State_Province__c;
        }
        if(this.dashboardDto.City__c != null) {
            cookieValue += ':: city : '+this.dashboardDto.City__c;
        }
        if(this.partner != null && this.partner != 'All') {
            cookieValue += ' :: partner : '+this.partner;
        }
        // Create cookie for dashboard
        prmFilterUtility.createFilterCookie('dashboard',cookieValue);
        
        this.loadData();
        return null;
    }
    
    public PageReference resetSearch(){
        System.debug('resetSearch()');
        this.dashboardDto.View_By_Current_Calendar__c = 'Week';
        this.psr = 'All';
        this.dashboardDto.Country__c = '';
        this.dashboardDto.State_Province__c = '';
        this.dashboardDto.City__c = '';
        this.partner = 'All';
        // Clear Cookie
        prmFilterUtility.removeFilterCookie('dashboard');
        this.loadData();
        return null;
    }
    
    public void checkForExistingCookie() {
        System.debug(System.LoggingLevel.INFO,'$$$$$$$$$$$$$$$$$$$$$$$$$ INSIDE Dashboard checkingForExistingCookie $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        

        String cvalue = prmFilterUtility.retriveFilterCookie('dashboard');
        System.debug('### cookie value after : '+cvalue);

        if(cvalue != null  && cvalue != '' ) {
            List<String> fieldValueList = cvalue.split('::');
            String fname,fvalue;

            for(String str : fieldValueList ) {
                fname = str.split(':')[0] != null ? str.split(':')[0].trim() : '';
                fvalue = str.split(':')[1] != null ? str.split(':')[1].trim() : '';

                if(fname != null && fname.equalsIgnoreCase('calender')) {
                    this.dashboardDto.View_By_Current_Calendar__c = fvalue;
                }
                if(fname != null && fname.equalsIgnoreCase('psr')) {
                    this.psr = fvalue;
                }
                else if(fname != null && fname.equalsIgnoreCase('country')) {
                    this.dashboardDto.Country__c = fvalue;
                }
                else if(fname != null && fname.equalsIgnoreCase('state')) {
                    this.dashboardDto.State_Province__c = fvalue;
                }
                else if(fname != null && fname.equalsIgnoreCase('city')) {
                    this.dashboardDto.City__c = fvalue;
                }
                else if(fname != null && fname.equalsIgnoreCase('partner')) {
                    this.partner = fvalue;
                }
            }
        }
        else {
            System.debug('### Cookie is null');
        }
        System.debug(System.LoggingLevel.INFO,'$$$$$$$$$$$$$$$$$$$$$$$$$ End of Dashboard Checking for Existing Cookie $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
    }
    
}