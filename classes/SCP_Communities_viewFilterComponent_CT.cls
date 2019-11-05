public with sharing class SCP_Communities_viewFilterComponent_CT extends SCP_Communities_PageControllerBase {
    
    // SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdate(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }

    public SCP_Communities_viewFilterComponent_CT() {
        try {
            String view = ApexPages.currentpage().getParameters().get('view');
            if(view != null) {
                SCP_Communities_listviews__c mprec = [Select Id from SCP_Communities_listviews__c Where View_Alias__c = :view];
                this.selectedview = mprec.Id;
            }
            else {          
                checkForExistingCookie();
            }
            initlize();
            String gadgetLanguageCode = prmFilterUtility.loggedInUserGadgetLanguage;
            if( gadgetLanguageCode == null || 'fr_CA'.equals(gadgetLanguageCode)){
                gadgetLanguageCode = 'en_US';
            }
            String documentName = Label.PRM_Lead_Download_template_document_Name_prefix+gadgetLanguageCode;
            System.debug(System.LoggingLevel.INFO,'>>>> documentname '+documentName);
            Document document = [SELECT Id, Name, Body,Type FROM Document where name=:documentName LIMIT 1];
            DocId = document.Id;
            //System.debug(System.LoggingLevel.INFO,'>>>> DocId : '+DocId);

        }
        catch(Exception ex) {
            String expMsg = ex.getMessage();
            if(expMsg.contains('List has no rows for assignment to SObject')) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'No Lead Upload template found for the current language');
                ApexPages.addMessage(myMsg);
            }
            else {
                Apexpages.addMessages(ex);
            }
                
            
        }
    }



    // Sobject type filed from visualforce page
    public string sObjectName { get; set; }
    // Modified By: Sudi 17 Oct 2014 
    // Release : November Sprint 3
    // User Story : US7049
    // Added new field partner lead Id to display in the list filter view. 
    // Added new field Channel partner name to display to disti user.
    public string q_select {
        get {
            q_select =  ' Id, Name, Company,End_Customer_Account__c, Account_Name_English__c,';
            q_select += ' toLabel(Partner_Lead_Status__c), Cisco_Rec_PSR__c, PSR_1__c, Partner_Assigned_Date__c,';
            q_select += ' Main_Technology__c, QABudget__c, ProgramEvent__c, ';
            q_select += ' Address_Line_1__c, CustomCity__c, CustomState__c, CustomZip__c, Country,';
            q_select += ' Address_Line_1_English__c, City_English__c, State_Province_English__c, Partner_Lead_Id__c, Channel_Partner_Name__c, Zip_Postal_Code_English__c, toLabel(Country_English__c) , ';
            q_select += ' Program_Event_Name__c, toLabel(Lead_Category__c), toLabel(LeadSource), toLabel(Industry), Date_Added__c, Lead_Qualified_Date__c, Deal_ID__c ';
            return q_select;
        }
        set;
        
    }
    public string q_from {
        get {
            return ('Lead');
        }
    }
    public string q_where {
        get {
            if(q_where == null) {
                q_where = 'Id != null ';
            }
            return q_where;
        }
        set;
    }

    public string q_queryStr {
        get {
            return ('SELECT '+q_select+' FROM '+q_from+' WHERE '+q_where + '  ORDER BY Partner_Assigned_Date__c LIMIT 500 OFFSET 0 ');
        }
    }
    // Modified By: Sudi 10 Oct 2014 
    // Release : November Sprint 2
    // User Story : US7048
    // Below method is added for Export lead functionality, passing list view and get the Partner lead status
    @RemoteAction
    public static String getListViewStatus(string lstViewId){
        string str = prmFilterUtility.whereClauseforView('lead', lstViewId);
        return str.trim();
    } 
    public prmPagenationUtility myPg {
        get {
            if(myPg == null) {
                System.debug('*** Query String : '+q_queryStr);
                myPg = new prmPagenationUtility(q_queryStr,500);
                myPg.pg_PageSize = 500;

            }
            return myPg;
        }
        set;
    }

    public Boolean isNewlyAssignedLeads { 
        get {
            string str = SCP_Communities_listviews__c.getValues('My Newly Assigned Leads').Id;
            System.debug(System.LoggingLevel.INFO,'### str : '+str);
            if(selectedView == str) {
                isNewlyAssignedLeads = true;    
            }
            else {
                isNewlyAssignedLeads = false;
            }
            System.debug(System.LoggingLevel.INFO,'### isNewlyAssignedLeads : '+isNewlyAssignedLeads);
            return (isNewlyAssignedLeads);
        }
        set; 
    }

    public List<prmPagenationUtility.WrapperList> pageRecords { get; set; }

    /*
     * Getter and Setter for the search variables
     */
    public string customerName { get; set; }
    public List<string> selectedLeadCategory { get; set; }
    public List<string> selectedLeadSource { get; set; }
    public List<string> selectedIndustries { get; set; }
    public List<string> selectedMainTechnology { get; set; }
    public string selectedPartner{get;set;}
    // Modified By: Sudi 17 Oct 2014 
    // Release : November Sprint 3
    // User Story : US7054
    // Below varible used for store the lead filter on partner name values 
    public List<string> selectedPartnerName{get;set;}
    public string programEventName { get; set; }
    public List<String> selectedCountries { get; set; }
    public string country { get; set; }
    public string stateProvince { get; set; }
    public string city { get; set; }

    public List<SelectOption> leadCategoryList { get; set; }
    public List<SelectOption> leadSourceList { get; set; }
    public List<SelectOption> leadIndustryList { get; set; }
    public List<SelectOption> leadMainTechnologyList { get; set; }
    public List<SelectOption> countryList { get; set; }
    // Modified By: Sudi 17 Oct 2014 
    // Release : November Sprint 3
    // User Story : US7054
    // Below varible used for store the partner name picklist values
    public List<SelectOption> partnerNameList{get;set;}
    // End of Variable declaration for lead search


    public string getMultiPickSelectedValue(List<String> value) {
        string returnVal = '(';
        if(value != null ) {
            for(string val : value) {
                if(val.equalsIgnoreCase('All')) {
                    return ('All');
                }
                val = String.escapeSingleQuotes(val);
                returnVal = returnVal +'\''+val+'\',';
            }
            System.debug(System.LoggingLevel.INFO,'>>>>>> value : '+value +' returnVal : '+ returnVal);
            if(returnVal != '(') {
                returnVal = returnVal.substring(0,(returnVal.length()-1));
                returnVal = returnVal + ')';
                return (returnVal);
            }               
        }
        return 'All';
    }


    public Boolean isPA {
        get {
            return (prmFilterUtility.isPA);
        }
    }

    public Boolean isPSR {
        get {
            return (prmFilterUtility.isPSR);
        }
    }

    public Boolean isEnglish {
        get {
            return (prmFilterUtility.isEnglish);
        }
    }


    public string selectedView { 
        get {
            if(selectedView == null) {
                selectedViewList = new List<string>();
                selectedViewList.addAll(prmFilterUtility.lead_statusMap.keySet());
                selectedView = selectedViewList[0];
            }
            return selectedView;
        }
        set; }

    public List<String> selectedViewList { get; set; }

    transient Component.Apex.SelectList viewList;

    public void setViewList(Component.Apex.SelectList value) {
        if(value != null) {
            viewList = value;
        }
    }

    public Component.Apex.SelectList getViewListComponent() {
        if(viewList == null ) {

            try {   
                viewList = new Component.Apex.SelectList();
                viewList = prmFilterUtility.getViewListComponent('Lead');
            }
            catch(Exception ex) {
                ApexPages.addMessages(ex);
            }           
        }
        return viewList;
    }

    public Id DocId { get; set; }
    public string queryStr { get; set; }

    public string psr1_name { get; set; }
    public string psr1_Id { get; set; }
    public string psr2_name { get; set; }
    public string psr2_Id {get; set;}
    public string psr3_name { get; set; }
    public string psr3_Id { get; set; }


    public void initlize() {

        pageRecords = new List<prmPagenationUtility.WrapperList>();
        leadCategoryList = new List<SelectOption>();
        //leadCategoryList.add(new SelectOption('All',Label.PRM_Picklist_Value_All));

        Map<String, Schema.SobjectField> allfieldsmap = Schema.SObjectType.Lead.fields.getMap();
        Schema.DescribeFieldResult describedField = allfieldsmap.get('Lead_Category__c').getDescribe();

        Schema.DescribeFieldResult leadCategory  = Lead.Lead_Category__c.getDescribe();
        for(Schema.Picklistentry sp : leadCategory.getPicklistValues()) {
            leadCategoryList.add(new SelectOption(sp.value,sp.label));
        }

        leadSourceList = new List<SelectOption>();
        //  leadSourceList.add(new SelectOption('All',Label.PRM_Picklist_Value_All));
        Schema.DescribeFieldResult leadSource  = Lead.LeadSource.getDescribe();
        for(Schema.Picklistentry sp : leadSource.getPicklistValues()) {
            leadSourceList.add(new SelectOption(sp.value,sp.label));
        }

        leadIndustryList = new List<SelectOption>();
        // leadIndustryList.add(new SelectOption('All',Label.PRM_Picklist_Value_All));
        Schema.DescribeFieldResult leadIndustry  = Lead.Industry.getDescribe();
        for(Schema.Picklistentry sp : leadIndustry.getPicklistValues()) {
            leadIndustryList.add(new SelectOption(sp.value,sp.label));
        }

        leadMainTechnologyList = new List<SelectOption>();
        //    leadMainTechnologyList.add(new SelectOption('All',Label.PRM_Picklist_Value_All));

        Schema.DescribeFieldResult mainTechnology  = Lead.Main_Technology_filter__c.getDescribe();
        for(Schema.Picklistentry sp : mainTechnology.getPicklistValues()) {
            leadMainTechnologyList.add(new SelectOption(sp.value,sp.label));
        }
        
        countryList = new List<SelectOption>();
        //countryList.add(new SelectOption('All',Label.PRM_Picklist_Value_All));

        Schema.DescribeFieldResult country  = Lead.CustomCountry__c.getDescribe();
        for(Schema.Picklistentry sp : country.getPicklistValues()) {
            countryList.add(new SelectOption(sp.value,sp.label));
        }
        // Modified By: Sudi 17 Oct 2014 
        // Release : November Sprint 3
        // User Story : US7054
        // Below Code is added for load the Partner name pick list values for disti and channnel partner junction object
        partnerNameList = new List<SelectOption>();         
        for(Disti_to_Partner_Mapping__c DP : [Select Partner__c, Channel_Partner__c from Disti_to_Partner_Mapping__c where Distributor__c=:channelAccount]){                        
            partnerNameList.add(new SelectOPtion(DP.Partner__c,DP.Channel_Partner__c));             
        } 
        q_where = null;
        isNewlyAssignedLeads = false;
        if(myPg != null) {
            myPg.clearPageRecords();
            myPg = null;
        }
        System.debug('*** q_QueryStr = '+q_QueryStr);
        doSearch();
    }
    
    /*
     * Function Name    : doSearch
     * Description    : Function to form the dynamic soql using the search parameters
     * Input Param    : -
     * Output Param  : -
     */
    public void doSearch() {
        try {
            string cookieValue = '';
            isNewlyAssignedLeads = false;
            myPg = null;
            q_where = null;
            viewList = null;
            string whereClause = q_where;
            System.debug('*** q_where : '+q_where);
            System.debug('*** selectedView : '+selectedView);
            // Filter by view
            string str = prmFilterUtility.whereClauseforView('lead', selectedView);
            cookieValue  += 'view : '+selectedView;
            if(str != 'All') {
                whereClause = whereClause + ' AND Partner_Lead_Status__c IN '+str;  
            }
            System.debug('*** Where clause in doseach after view : '+whereClause);
            //escape each search value with single quotes
            customerName = null != customerName ?String.escapeSingleQuotes(customerName) :'';

            programEventName = null != programEventName ?String.escapeSingleQuotes(programEventName) :'';

            stateProvince = null != stateProvince ?String.escapeSingleQuotes(stateProvince) :'';
            city = null != city ?String.escapeSingleQuotes(city) :'';

            System.debug(System.LoggingLevel.INFO,'>>>>>> selectedLeadSource : '+selectedLeadSource);
            
            string lc = getMultiPickSelectedValue(selectedLeadCategory);
            string ls = getMultiPickSelectedValue(selectedLeadSource);
            string ind = getMultiPickSelectedValue(selectedIndustries);
            string mt = getMultiPickSelectedValue(selectedMainTechnology);
            string cu = getMultiPickSelectedValue(selectedCountries);
            // Modified By: Sudi 17 Oct 2014 
            // Release : November Sprint 3
            // User Story : US7054
            // Below Code is added for get partner name picklist values
            string pn = getMultiPickSelectedValue(selectedpartnerName);

            if('' != customerName ) {
                whereClause = whereClause + ' AND ( Company LIKE \'%' + customerName  +'%\'  OR Account_Name_English__c LIKE \'%' + customerName  +'%\')';  
                cookieValue += ' :: customerName : '+customerName;
            }

            if('' != lc && lc != 'All') {
                whereClause = whereClause + ' AND Lead_Category__c IN '+lc;
                cookieValue += ' :: leadCatagory : '+lc;
            }
            if( '' != ls && ls != 'All') {
                whereClause = whereClause + ' AND LeadSource IN '+ls;
                cookieValue += ' :: leadSource : '+ls;
            }
            if('' != ind && ind != 'All') {
                whereclause = whereClause + ' AND Industry IN '+ind;
                cookieValue += ' :: industry : '+ind;
            }
            if('' != mt && mt != 'All') {
                whereClause = whereClause +  ' AND  Main_Technology__c IN '+mt;
                cookieValue += ' ::  maintechnology : '+mt;
            }
            if('' != programEventName && programEventName != 'All' ) {
                whereClause = whereClause + ' AND Program_Event_Name__c LIKE \'%'+programEventName+ '%\'';
                cookieValue += ' ::  programevent : '+programEventName;
            }

            if('' != cu && cu != 'All') {
                whereClause = whereClause +  ' AND Country  IN '+cu;
                cookieValue += ' ::  country : '+cu;
            }

            if('' != stateProvince) {
                whereClause = whereClause +  ' AND ( CustomState__c LIKE \'%'+stateProvince+'%\' OR State_Province_English__c LIKE \'%'+stateProvince+'%\' ) ';
                cookieValue += ' ::  state : '+stateProvince;
            }
            if('' != city) {
                whereClause = whereClause +  ' AND ( CustomCity__c LIKE \'%'+city+'%\' OR City_English__c LIKE \'%'+city+'%\' ) ';
                cookieValue += ' ::  city : '+city;
            }
            // Modified By: Sudi 17 Oct 2014 
            // Release : November Sprint 3
            // User Story : US7054
            // Below condition is added for only disti user we are going to partner name filter to dynamic soql 
            if(isDisti && '' != pn && pn != 'All' ){
                whereClause = whereClause + ' AND Channel_Partner__c IN ' + pn;
                cookieValue  += ' ::  partnername : '+pn;
            }
            if(whereClause != q_where) {
                q_where = whereClause;
            }

            prmFilterUtility.createFilterCookie('lead',cookieValue);

            //pobj.retriveCookie('lead');

            if(myPg != null) {
                myPg = null;
                //pageRecords.clear();
                myPg.clearPageRecords();
            }
            pageRecords = myPg.getLeadPageRecords();
            System.debug('*** Where Clause at the end : '+whereClause);
            System.debug('*** pagerecords count : '+pageRecords.size());
        }

        catch(System.QueryException qEx) {
            ApexPages.addMessages(qEx);
        }

        catch(Exception ex) {
            ApexPages.addMessages(ex);
        }

    }

    public string setlistSize { 
        get
        {
            if(setlistSize == null)
            {
                setListSize = '10';
            }
            return setListSize;
        }
        set;
    }

    public Void AssignPartnerName(){
        try{
            User usr = prmFilterUtility.logUser;
            system.debug('selectedPartner :::' + selectedPartner);
            if(selectedPartner == null || selectedPartner == ''){
                ApexPages.addMessage(new ApexPages.Message(Apexpages.Severity.ERROR,'Partner Name cannot be blank!'));
                return; 
            }
            List<Lead> updateList = new List<Lead>();
            if(this.pageRecords != null && !this.pageRecords.isEmpty()) {
                account acc= [select id from account where Id=:selectedPartner limit 1];
                for(prmPagenationUtility.WrapperList rec : pageRecords) {
                    if(rec.isSelected) {    
                        system.debug('Sudi in---->' + usr.Contact.Account.Name);
                        //SCAVA FIX
                        if(flsUpdate(Lead.Channel_Partner__c))
                        {
                        rec.leadRec.Channel_Partner__c= acc.Id; 
                        }
                        //rec.leadRec.Distributor_Name__c = usr.Contact.Account.Name;                               
                        updateList.add(rec.leadRec);    
                        system.debug('Sudi out ---->' +updateList);                 
                    }
                }
            }
            if(!updateList.isEmpty()) {             
                update (UpdateList);
                //clearAsignPSRFields();
                myPg.clearPageRecords();
                pageRecords = new List<prmPagenationUtility.WrapperList>();
                doSearch();
            }
        }
        catch (Exception ex){
            ApexPages.addMessages(ex);
        }    
    }
    public override PageReference assignPSRs() {
        try {
            if(psr1_Id == null && psr2_Id == null && psr3_Id == null) {
                ApexPages.addMessage(new ApexPages.Message(Apexpages.Severity.ERROR,'PSR\'s cannot be blank!'));
                return null;
            }
            List<Lead> updateList = new List<Lead>();
            if(this.pageRecords != null && !this.pageRecords.isEmpty()) {

                for(prmPagenationUtility.WrapperList rec : pageRecords) {
                    if(rec.isSelected) {
                        System.debug('*** psr1 : '+psr1_Id+' psr2 : '+psr2_Id+' psr3 : '+psr3_Id);
                        if(psr1_Id != null && psr1_Id != '') {
                            rec.leadRec.PSR_1__c = (Id)psr1_Id;
                        }
                        if(psr2_Id != null && psr2_Id != '') {
                            rec.leadRec.PSR_2__c = (Id)psr2_Id;
                        }
                        if(psr3_Id != null && psr3_Id != '') {
                            rec.leadRec.PSR_3__c = (Id)psr3_Id;
                        }
                        updateList.add(rec.leadRec);
                        System.debug('*** Santosh record is selcted inside assign PSR : '+ rec.leadRec.PSR_1__c);
                    }
                }
            }
            if(!updateList.isEmpty()) {
                System.debug('*** Inside updatelist of assign psr');
                update (UpdateList);
                clearAsignPSRFields();
                myPg.clearPageRecords();
                pageRecords = new List<prmPagenationUtility.WrapperList>();
                doSearch();

            }
            System.debug('*** Santosh Inside assignPSRs : '+pageRecords);
        }
        catch(Exception ex) {
            ApexPages.addMessages(ex);
        }
        return null;
    }
    // PSR Bulk Assignment Component

    public void clearAsignPSRFields() {
        psr1_name = null;
        psr1_Id = null;
        psr2_name = null;
        psr2_Id = null;
        psr3_name = null;
        psr3_Id = null;

    }

    public String psrKey { 
        get{
            psrKey = 'psr';
            return psrKey;
        }
        set;
    }
    public SCP_Communities_PSRBulk_CT psr { get; set; }


    public SCP_Communities_PSRBulk_CT getPsr() {
        if(getComponentControllerMap() != null && getComponentControllerMap().get(psrKey) != null) {
            psr = (SCP_Communities_PSRBulk_CT) getComponentControllerMap().get(psrKey);
            return psr;
        }
        return (new SCP_Communities_PSRBulk_CT());
    }


    // Lead upload methods start

    public String Userlang { 
        get{
            return  prmFilterUtility.loggedInUserGadgetLanguage;
        }
        set;}

    public String CCOId { 
        get{
            return  prmFilterUtility.getCCOID();
        }
        set;}



    public String Currentuseraccount { 
        get{
            return String.valueof(new prmFilterUtility().getCurrentUserParentAccountId());
        }
        set; }


    public String channelAccount{
        get{
            return String.valueof(prmFilterUtility.loggedInUserPartnerAccount);
        }
    }
    // Modified By: Sudi 17 Oct 2014 
    // Release : November Sprint 3
    // User Story : US7054
    // Below variable is used to find the login user is Distributor or partner.
    public boolean isDisti{
        get{            
            return (prmFilterUtility.loggedInUserIsDisti =='Distributor')?true:false;
        }
    }

    // Lead upload methods End
    
    public void checkForExistingCookie() {
        
        selectedleadCategory = new List<string>();
        selectedleadSource = new List<string>();
        selectedIndustries = new List<string>();
        selectedmainTechnology = new List<string>();
        selectedCountries= new List<string>();
        selectedPartnerName = new List<string>();
        
        String cvalue = prmFilterUtility.retriveFilterCookie('lead');
        System.debug('### cookie value after : '+cvalue);

        if(cvalue != null  && cvalue != '' ) {
            List<String> fieldValueList = cvalue.split('::');
            String fname,fvalue;

            for(String str : fieldValueList ) {
                fname = str.split(':')[0] != null ? str.split(':')[0].trim() : '';
                fvalue = str.split(':')[1] != null ? str.split(':')[1].trim() : '';

                if(fname != null && fname.equalsIgnoreCase('view')) {
                    selectedView = fvalue;
                }
                else if(fname != null && fname.equalsIgnoreCase('customerName')) {
                    customername = fvalue;
                }
                else if(fname != null && fname.equalsIgnoreCase('leadcategory')) {
                    selectedLeadCategory = prmFilterUtility.convertToMultiselectPickList(fvalue);
                }
                else if(fname != null && fname.equalsIgnoreCase('leadSource')) {
                    selectedLeadSource = prmFilterUtility.convertToMultiselectPickList(fvalue);
                }
                else if(fname != null && fname.equalsIgnoreCase('Industry')) {
                    selectedIndustries = prmFilterUtility.convertToMultiselectPickList(fvalue);
                }
                else if(fname != null && fname.equalsIgnoreCase('maintechnology')) {
                    selectedMainTechnology = prmFilterUtility.convertToMultiselectPickList(fvalue);
                }
                else if(fname != null && fname.equalsIgnoreCase('programevent')) {
                    programEventName = fvalue;
                }
                else if(fname != null && fname.equalsIgnoreCase('country')) {
                    selectedCountries = prmFilterUtility.convertToMultiselectPickList(fvalue);
                }
                else if(fname != null && fname.equalsIgnoreCase('state')) {
                    stateProvince = fvalue;
                }
                else if(fname != null && fname.equalsIgnoreCase('city')) {
                    city = fvalue;
                }
                // Modified By: Sudi 17 Oct 2014 
                // Release : November Sprint 3
                // User Story : US7054
                // Below else if is added for new lead filter partner name for disti user 
                else if(fname != null && fname.equalsIgnoreCase('partnername')){
                    selectedPartnerName = prmFilterUtility.convertToMultiselectPickList(fvalue);
                }
            }
            //return;
        }
        else {
            System.debug('### Cookie is null');
        }
        
    }
    
    public void clearFields() {
        prmFilterUtility.removeFilterCookie('lead');
        customerName = '';
        selectedleadCategory = new List<string>();
        selectedleadSource = new List<string>();
        selectedIndustries = new List<string>();
        selectedmainTechnology = new List<string>();
        programEventName = '';
        selectedCountries= new List<string>();
        // Modified By: Sudi 17 Oct 2014 
        // Release : November Sprint 3
        // User Story : US7054
        // Below code added for clear partner name filter for disti user 
        selectedPartnerName = new List<string>();
        stateProvince = '';
        city = '';
        selectedView = null;
        // Get view options     
        initlize();
        
    }
    
}