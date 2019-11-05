/********** Change History **********
 * @Release: Q4FY15 Point Release
 * @Modification History: 
 01 - 05/21/2015 majanard :  Adding the Desc filter to the Lead search query.
 02 - 07/03/2015 sudi : Added new logic to load more than 400 records and based on user preference we are loading the grid.
 03 - 12/15/2015 - Updated the following methods to do the limited update to Lead field, 
       rather than the complete page reference of Lead (PBI000000056179)
        - AssignPartnerName()
        - updateStatus()
        - massUpdate()
 04 - 01/29/2016 - WR-01379 - Added changed for 'My Archived Leads' view for LnP
 05 - 02/26/2016 - Apply Archive Leads logic to only Partner Assigned/Assinged to PSR state only
 06 - 03/13/2016 - WR-01521 - Added logic to check if user has accepted the TnC for LnP Access & LnP Dialog methods are added
 07 - 03/13/2016 - WR-01379 - Updated Archive logic to limit for specific views
 08 DE10499 05/05/2016 - Updated whereClause for PA & PSR to consider Partner Assigned/PSR Assigned Date.
 09 - 06/13/2016 - US11655 - Updated the Lead Count to ensure the PA count includes the Leads for whom he/she is assigned as PSR.
    - Fixed VillageChief issues
 10 - 08/31/2016 -  kikamara -US12548:INC800004643525- Added label for the error message to be displayed.
 11 - 23-May-2019 - gchaithga - US305721 - Added DRT Lead field in the filter
***************************************/

public with sharing class SCP_Communities_leadFilter_CT_Clone extends SCP_Communities_PageControllerBase {

      // SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdateGet(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }
     // SCAVA Helper Method to validate Create Access at field level
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }
    
    public Integer archiveDays {get;set;}
    
    public SCP_Communities_leadFilter_CT_Clone() {
        LnP_Constants__c cs = LnP_Constants__c.getInstance();
        archiveDays = Integer.valueOf(cs.Archive_Days__c);
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
            List<Document> docList = [SELECT Id, Name, Body,Type FROM Document where name=:documentName LIMIT 1];
            if(docList != null && !docList.isEmpty()) {
                DocId = docList[0].Id;           
            }
            else {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'No Lead Upload template found for the current language');
                ApexPages.addMessage(myMsg);
            }
        }
        catch(Exception ex) {
            //Commented the code to fix the VillageChief exception - Unused local variable
            //String expMsg = ex.getMessage();            
            Apexpages.addMessages(ex);          
        }
    }
    
    // Get page base url
    public String getSearchPageUrl() { 
        return BaseUrl + 'apex/SCP_Communities_psrSearch';                
    }        
    // get page baseURl
    public String BaseUrl {
        get {
            String baseUrl = Site.getBaseUrl();
            
            if(baseUrl == null || baseUrl == '') {
                    baseUrl =  '/';
            }
            else {
                List<String> listBase = baseUrl.split('/');
                if(listBase.size() > 1) {
                        baseUrl = '/'+ listBase[(listBase.size()-1)] + '/';
                }
            }
            system.debug('baseUrl=='+baseUrl);
            return baseUrl;
            }
            private set;
        }
        
        public String getViewSettingsUrl() {            
            return BaseUrl + 'SCP_Communities_viewSetting';               
        }

    //*********** WR-01521 LnP Dialog ************* 
    
    public boolean getIsChekAccesLead(){
       /*This method will check if the user has ever accepted the TnC or if accepted earlier,
       is it matching the current reset date and return the boolean parameter to page to display the popup or not.*/
       List<user> usList = [select id, LnP_TC_Accepted__c, LnP_T_C_Acepted_Date__c, LnP_TC_Reset_Date__c from User where id=:UserInfo.getUserId() limit 1];     
        LnP_Constants__c cs = LnP_Constants__c.getInstance();
        Date resetDate = cs.Reset_Date__c;   
        if(resetDate != null){     
            if(!usList.isEmpty()){
                Date acceptedDate;
                if(usList[0].LnP_T_C_Acepted_Date__c != null){
                    acceptedDate = usList[0].LnP_T_C_Acepted_Date__c;
                }   
                Date custResetdDate; 
                if(usList[0].LnP_TC_Reset_Date__c != null){
                    custResetdDate = usList[0].LnP_TC_Reset_Date__c;
                }            
                if(usList[0].LnP_TC_Accepted__c){
                    if( acceptedDate >= custResetdDate && custResetdDate <= resetDate){
                        return true;
                    }else{
                        return false;
                    }
                }
            }
            return false;
        } else {
            return true;
        }
    } 
  
      @RemoteAction
        public static boolean updateTC(){
        //This method is being executed by the Page when the user accepts the TnC popup
            LnP_Constants__c cs = LnP_Constants__c.getInstance();
            List<user> usList = [select id, LnP_TC_Accepted__c, LnP_T_C_Acepted_Date__c, LnP_TC_Reset_Date__c from User where id=:UserInfo.getUserId()];
            if(!usList.isEmpty()){
                Date resetDate = cs.Reset_Date__c;
                usList[0].LnP_TC_Accepted__c = true;
                usList[0].LnP_T_C_Acepted_Date__c = system.today();                
                usList[0].LnP_TC_Reset_Date__c = resetDate;                 
                update usList;
                return true;    
            }
            return false;       
        } 
    //*********** WR-01521 LnP Dialog End *************          

  // Sobject type filed from visualforce page
  public string sObjectName { get; set; }

  public string q_select {
    get {     
      q_select =  ' Id, Name, Company,End_Customer_Account__c, Account_Name_English__c, Lead_From_Distributor_BE_GEO_ID_PDB__c,';
      q_select += ' toLabel(Partner_Lead_Status__c), toLabel(SCP_Partner_Lead_Status__c),Cisco_Rec_PSR__c, PSR_1__c, Partner_Assigned_Date__c,';
      q_select += ' Main_Technology__c, QABudget__c, ProgramEvent__c,ProductAmount__c ,ServicesAmount__c, Distributor_Name__c, ';
      q_select += ' Address_Line_1__c, CustomCity__c, CustomState__c, CustomZip__c, Country, toLabel(CustomCountry__c), Lead_Distributor_Name__c ,';
      q_select += ' Address_Line_1_English__c, City_English__c, State_Province_English__c, Partner_Lead_Id__c, Campaign_Description__c, Channel_Partner_Name__c, Zip_Postal_Code_English__c, toLabel(Country_English__c) , ';
      q_select += ' Program_Event_Name__c, toLabel(Lead_Category__c), toLabel(LeadSource), toLabel(Industry), Date_Added__c, Lead_Qualified_Date__c, Deal_ID__c,';      
      // added by gchaitha for US305721
      q_select += ' DRT_Lead__c';
      // end
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

  // 5/21: Set the query return set order by DESC
  public string q_queryStr {
    get {        
        String  sortOrder = 'Partner_Assigned_Date__c DESC,';
        if( prmFilterUtility.viewPreferenceMap != null && 
            prmFilterUtility.viewPreferenceMap.containsKey(selectedView)){
         User_Preference__c lup = prmFilterUtility.viewPreferenceMap.get(selectedView);
          string availSortFields = (lup.Columns_Sort_Order__c != null) ? 
                                    lup.Columns_Sort_Order__c : '';  
         if(availSortFields != ''){   
             sortOrder = '';
             for(string so : availSortFields.split(';')){
                string [] arryStr = so.split('~~');
                SCP_Communities_LeadFilter_Columns__c scpFilter = getLeadFieldAPI(arryStr[0]);
                if(scpFilter != null){
                    string str = (isEnglish) ? scpFilter.Field_API_Name__c   + ' ' + arryStr[1] + ',': scpFilter.Non_English_API_Name__c  + ' ' + arryStr[1] + ','; 
                    sortOrder += str ;
                }
             }      
         }        
      }         
      sortOrder = (sortOrder != '') ? sortOrder.removeEnd(',') : '';
      return ('SELECT '+q_select+' FROM '+q_from+' WHERE '+q_where + '  ORDER BY '+ sortOrder + ' limit 10000');
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
  
  public Boolean isSelectedChekBox { 
    get {
      Set<Id> viewIds = new Set<Id>();
      viewIds.add(SCP_Communities_listviews__c.getValues('My Newly Assigned Leads').Id);
      viewIds.add(SCP_Communities_listviews__c.getValues('All Active Leads').Id);
      viewIds.add(SCP_Communities_listviews__c.getValues('My Accepted Leads').Id);
      viewIds.add(SCP_Communities_listviews__c.getValues('My Archived Leads').Id);
      if(viewIds.contains(selectedView)) {
        isSelectedChekBox = true;
      }
      else {
        isSelectedChekBox = false;
      }
      return isSelectedChekBox;
    } 
    set; 
  }
  public Boolean isMassEdit { get; set; }
  public List<prmPagenationUtility.WrapperList> editPageRecords { get; set; }

  public List<prmPagenationUtility.WrapperList> pageRecords { get; set; }

  /*
 * Getter and Setter for the search variables
 */
  public string customerName { get; set; }
  public List<string> selectedLeadCategory { get; set; }
  public List<string> selectedLeadSource { get; set; }
  public List<string> selectedIndustries { get; set; }
  public List<string> selectedMainTechnology { get; set; }
  public string programEventName { get; set; }
  public List<String> selectedCountries { get; set; }
  public string country { get; set; }
  public string stateProvince { get; set; }
  public string city { get; set; }
  public string showSelectedCount{get;set;}
  public List<SelectOption> leadCategoryList { get; set; }
  public List<SelectOption> leadSourceList { get; set; }
  //public List<SelectOption> leadIndustryList { get; set; }
  public string campaignDescription { get; set; }
  public List<SelectOption> leadMainTechnologyList { get; set; }
  public List<SelectOption> countryList { get; set; }
  // added by gchaitha for US305721
  public Boolean DRTLead { get; set; }
  // end
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
  
  public Boolean isDisti {
    get{      
        return (prmFilterUtility.loggedInUserIsDisti =='Distributor')?true:false;
      }
  }
  public List<string> selectedPartnerName{get;set;}
  public List<SelectOption> partnerNameList { get; set; }
  public Boolean isEnglish {
    get {
      return (prmFilterUtility.isEnglish);
    }
  }


  public string selectedView { 
    get {
      if(selectedView == null) {
        selectedViewList = new List<string>();
        selectedViewList.addAll(prmFilterUtility.getviewList());
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
  /*
   Modified By: Sudi 2  July 2015   
   Below method is used to load the leadfilter grid using dynamic apex
  */
   public Component.Apex.PageBlockTable getDataTableComponent() {
      Component.Apex.PageblockTable table = new Component.Apex.PageblockTable();
      if(isMassEdit != null ) {
          table.rendered= !isMassEdit;
      }
      else {
          table.rendered = true;
      }  
      table.styleClass='leadTB';      
      table.expressions.value='{!pageRecords}';
      table.align='center' ;
      table.var = 'l';
      string val;
      table.id='lead_table';           
      if(selectedView != null) {
        populateDefaultColumns(table, selectedView);       
        
        if( prmFilterUtility.viewPreferenceMap != null && 
            prmFilterUtility.viewPreferenceMap.containsKey(selectedView)){
            User_Preference__c lup = prmFilterUtility.viewPreferenceMap.get(selectedView);
            string availFields = (  lup.Selected_column_order__c != null) ? 
                                    lup.Selected_column_order__c : '';
            
            if(availFields != null && availFields != '') {
                List<String> avaFildList =  availFields.split(';');
                
                for(string selectedFields : avaFildList){
                    Component.Apex.Column Column = new Component.Apex.Column();
                           if(selectedFields == 'PSR 1') {
                                             String text = getGirdHeaderlocal(selectedFields) + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp&nbsp;';
                        Component.Apex.OutPutText cheader = new Component.Apex.OutPutText( value = text );
                        cheader.escape = false;
                               Column.Facets.header = cheader;
                           }
                           else {
                               Column.Facets.header = new Component.Apex.OutputText(value=getGirdHeaderlocal(selectedFields));
                           }
                           SCP_Communities_LeadFilter_Columns__c scpFilter = getLeadFieldAPI(selectedFields);
                      
                    if(scpFilter != null){
                        if(scpFilter.Field_API_Name__c != scpFilter.Non_English_API_Name__c){
                            Component.Apex.OutputText opFieldUS = new Component.Apex.OutputText();                                                                    
                            val = 'l.leadRec.'+ scpFilter.Field_API_Name__c;
                            opFieldUS.expressions.value = '{!NULLVALUE('+val+',\' -- \')}';
                            System.debug(System.LoggingLevel.INFO,' #### opFieldUS.expressions.value : '+opFieldUS.expressions.value);
                            opFieldUS.styleclass = 'newLine';   
                            Column.childcomponents.add(opFieldUS);
                            if(!isEnglish){
                                Component.Apex.outputField opFieldLoc = new Component.Apex.outputField();                                                                                                                                         
                                opFieldLoc.expressions.value = '{!l.leadRec.'+ scpFilter.Non_English_API_Name__c  + '}';
                                System.debug(System.LoggingLevel.INFO,' #### opFieldUS.expressions.value : '+opFieldUS.expressions.value);
                                Column.childcomponents.add(opFieldLoc);
                            }
                        }
                        else{
                            Component.Apex.outputField opFieldUS = new Component.Apex.outputField();                        
                            val = 'l.leadRec.'+ scpFilter.Field_API_Name__c;                        
                            opFieldUS.expressions.value = '{!'+val+'}';
                            System.debug(System.LoggingLevel.INFO,' #### opFieldUS.expressions.value : '+opFieldUS.expressions.value);
                            Column.childcomponents.add(opFieldUS);
                        }
                    }
                    
                    table.childcomponents.add(Column); 
                }
            }
            else {
                populateDefaultView(table);
            }
        }
        else {
             populateDefaultView(table);
        }
      }
      else {
        populateDefaultView(table);
      }
       return table;
   }
  /*
   Modified By: Sudi 16 July 2015  
   Below method is used get the lead grid Header labels based on fields added to the user prefernce
  */
    public string getGirdHeaderlocal(string sValue ) {
        string strReturn = '';        
        if( prmFilterUtility.fieldValueLabelMap.containsKey(sValue) ) {
            if(sValue == 'Lead Source'){
                strReturn = Lead.LeadSource.getDescribe().getLabel();
            }
            else if(sValue == 'Industry'){
                strReturn = Lead.Industry.getDescribe().getLabel(); 
            }
            else{
                strReturn = prmFilterUtility.fieldValueLabelMap.get( sValue );
            }
        }
        
        System.debug(System.LoggingLevel.INFO,'%%%%% value = '+sValue+' label = '+strReturn);
        
        return strReturn;
   }
   
    /*
   Modified By: Sudi 8 july 2015   
   Below method is used to load the first 2 default columns i.e. checkbox and customer name
  */
    public void populateDefaultColumns(Component.Apex.PageblockTable table, String viewId) {
                                 
      Component.Apex.Column CheckBoxColumn = new Component.Apex.Column();
      Component.Apex.OutputText chkHeader = new Component.Apex.OutputText();
      Component.Apex.inputCheckBox inputCheckBox = new  Component.Apex.inputCheckBox();
      inputCheckBox.id='select_all';      
      inputCheckBox.expressions.value = '{!selectAll}';       
      inputCheckBox.styleclass='hdCheck';              
      chkHeader.childcomponents.add(inputCheckBox);
      CheckBoxColumn.Facets.header = chkHeader;                        
      Component.Apex.inputCheckBox inputCheckBoxData = new  Component.Apex.inputCheckBox();
      inputCheckBoxData.styleclass='chkbox';
      inputCheckBoxData.expressions.value='{!l.isSelected}';      
      CheckBoxColumn.childcomponents.add(inputCheckBoxData);
      
      if(isSelectedChekBox){
        table.childcomponents.add(CheckBoxColumn);
      }
      
      //Second Column Customer Name
       Component.Apex.Column CustomerNameColumn = new Component.Apex.Column();
       CustomerNameColumn.Facets.header = new Component.Apex.OutputText(value=Label.PRM_Customer_Name);
       Component.Apex.outputLink CustomerNamelink = new Component.Apex.outputLink();
       CustomerNamelink.expressions.value = '{!URLFOR($Action.Lead.View, l.leadRec.Id, null)}';
       CustomerNamelink.id='theLink';
       Component.Apex.OutputText outLinkValue =  new Component.Apex.OutputText();
       outLinkValue.expressions.value = '{!l.hyperlink}';
       outLinkValue.styleClass = 'newLine';
       CustomerNamelink.childcomponents.add(outLinkValue);         
       CustomerNameColumn.childcomponents.add(CustomerNamelink);
       if(!isEnglish){                        
           Component.Apex.OutputText locCustomerName = new Component.Apex.OutputText();
           locCustomerName.expressions.value = '{!l.cname_en}';
           CustomerNameColumn.childcomponents.add(locCustomerName);
       }
       table.childcomponents.add(CustomerNameColumn);
       
       // Modified By: Sudi 19 Aug 2015 
       // Release : Aug Sprint 4
       // User Story : US8845     
       // Third column Partner name for diti user is always display.       
       Component.Apex.Column PartnerNameColumn = new Component.Apex.Column();  
       PartnerNameColumn.Facets.header = new Component.Apex.OutputText(value=Label.PRM_Partner_Name);  
       Component.Apex.outputField PartnerNameField = new Component.Apex.outputField();                                                     
       PartnerNameField.expressions.value = '{!l.leadRec.Channel_Partner_Name__c}';       
       PartnerNameColumn.childcomponents.add(PartnerNameField); 
       if(isDisti){
            table.childcomponents.add(PartnerNameColumn);
       }           
    }
   /*
   Modified By: Sudi 10 Oct 2014   
   Below method is used to load default grid with all columns if user not created his view settings
  */
    public void populateDefaultView(Component.Apex.PageblockTable table) {
        //Schema.DescribeFieldResult leadCategory  = User_Preference__c.Lead_Available_Fields__c.getDescribe();
        // Commented by saduvvur
        Map<String, String> valLabelMap = new Map<String,String>();
        valLabelMap = prmFilterUtility.fieldValueLabelMap;
        
        for( String value : valLabelMap.keySet() ) {
            Component.Apex.Column Column = new Component.Apex.Column();         
            Column.Facets.header = new Component.Apex.OutputText( value = valLabelMap.get( value ) );
            SCP_Communities_LeadFilter_Columns__c scpFilter = getLeadFieldAPI( value );
            
            if(scpFilter != null){
                if(scpFilter.Field_API_Name__c != scpFilter.Non_English_API_Name__c){
                    Component.Apex.OutputText opFieldUS = new Component.Apex.OutputText();                                
                    opFieldUS.expressions.value = '{!l.leadRec.'+ scpFilter.Field_API_Name__c  + '}';
                    opFieldUS.styleClass = 'newLine';
                    Column.childcomponents.add(opFieldUS);
                    if(!isEnglish){                    
                        Component.Apex.outputField opFieldLoc = new Component.Apex.outputField();
                        opFieldLoc.expressions.value = '{!l.leadRec.'+ scpFilter.Non_English_API_Name__c  + '}';
                        Column.childcomponents.add(opFieldLoc);
                    }
                }
                else{
                    Component.Apex.outputField opFieldUS = new Component.Apex.outputField();
                    opFieldUS.expressions.value = '{!l.leadRec.'+ scpFilter.Field_API_Name__c  + '}';
                    Column.childcomponents.add(opFieldUS);
                }
                table.childcomponents.add(Column);  
            }
        }
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
    System.debug(System.LoggingLevel.INFO,'### INSIDE INITLIZE ###');       
    pageRecords = new List<prmPagenationUtility.WrapperList>();
    leadCategoryList = new List<SelectOption>(); 
    // added by gchaitha for US305721
    DRTLead = DRTLead==true?true:false;
    // end
    //Commented the code to fix the VillageChief exception - Unused local variable
    //Map<String, Schema.SobjectField> allfieldsmap = Schema.SObjectType.Lead.fields.getMap();
    Schema.DescribeFieldResult leadCategory  = Lead.Lead_Category__c.getDescribe();
    for(Schema.Picklistentry sp : leadCategory.getPicklistValues()) {
      leadCategoryList.add(new SelectOption(sp.value,sp.label));
    }
    
    leadSourceList = new List<SelectOption>();    
    Schema.DescribeFieldResult leadSource  = Lead.LeadSource.getDescribe();
    for(Schema.Picklistentry sp : leadSource.getPicklistValues()) {
      leadSourceList.add(new SelectOption(sp.value,sp.label));
    }
    
    /*leadIndustryList = new List<SelectOption>();    
    Schema.DescribeFieldResult leadIndustry  = SCP_Communities_DTO__c.Industry__c.getDescribe();
    for(Schema.Picklistentry sp : leadIndustry.getPicklistValues()) {
      leadIndustryList.add(new SelectOption(sp.value,sp.label));
    }*/

    leadMainTechnologyList = new List<SelectOption>();    
    Schema.DescribeFieldResult mainTechnology  = Lead.Main_Technology_filter__c.getDescribe();
    for(Schema.Picklistentry sp : mainTechnology.getPicklistValues()) {
      leadMainTechnologyList.add(new SelectOption(sp.value,sp.label));
    }

    countryList = new List<SelectOption>();    
    Schema.DescribeFieldResult country  = Lead.CustomCountry__c.getDescribe();
    for(Schema.Picklistentry sp : country.getPicklistValues()) {
      countryList.add(new SelectOption(sp.value,sp.label));
    }
    // Modified By: Sudi 02 Nov 2014 
    // Release : November Sprint 3
    // User Story : US7054
    // Below code is added to populate the Partner name drop down values in Partnar mass update
    partnerNameList = new list<SelectOption>();    
    String currentPartnerAccountId = prmFilterUtility.loggedInUserPartnerAccount;
        String currentPartnerAccountName = prmFilterUtility.loggedInUserPartnerAccountName;    
        partnerNameList.add(new SelectOption(currentPartnerAccountId,currentPartnerAccountName));  
        set<SelectOption> newList = new set<SelectOption>();
    for(Disti_to_Partner_Mapping__c DP : [Select Partner__c, Channel_Partner__c from Disti_to_Partner_Mapping__c where Distributor__c=:channelAccount]){
      if(DP.Partner__c != null){            
        newList.add(new SelectOPtion(DP.Partner__c,DP.Channel_Partner__c));
      }        
    } 
    partnerNameList.addAll(newList);
    q_where = null;
    isNewlyAssignedLeads = false;
    if(myPg != null) {
      myPg.clearPageRecords();
      myPg = null;
    }    
    doSearch();
    System.debug(System.LoggingLevel.INFO,'### END OF INITLIZE ###');
  }

  /*
 * Function Name  : doSearch
 * Description    : Function to form the dynamic soql using the search parameters
 * Input Param    : -
 * Output Param   : -
 */
  public Pagereference doSearch() {
    try {
      string cookieValue = '';
      isNewlyAssignedLeads = false;
      selectAll = false;
      myPg = null;
      q_where = null;
      viewList = null;
      showSelectedCount = '';
      string whereClause = q_where;      
      // Filter by view
      string str = prmFilterUtility.whereClauseforView('lead', selectedView);
      cookieValue  += 'view : '+selectedView;
      
      //WR-01379 01/29 - Added for Archive Leads
      // Get the Archive Lead view ID to compare and process the dynamic query.
      Map<String, SCP_Communities_listviews__c> scpLv = SCP_Communities_listviews__c.getAll();
      String archiveViewID = scpLv.get('My Archived Leads').id;
      String activeViewID = scpLv.get('All Active Leads').id;
      String acceptedViewID = scpLv.get('My Accepted Leads').id;
      String newlyAssignedViewID = scpLv.get('My Newly Assigned Leads').id;     
       // Get the archive duration days from Custom Setting
       LnP_Constants__c cs = LnP_Constants__c.getInstance();
       Integer archiveDays = Integer.valueOf(cs.Archive_Days__c);
   
       //WR-01379 03/13 - Remove the 'My Active Leads' from 'My Archive Leads' view.
       //Compute the PartnerLeadStatus to apply Archive days
        String[] leadStatus = str.split(',');
        String archiveStatus1 = '';
        String archiveStatus2 = '';
        for(String s :leadStatus){
            if(s.contains('Actively Working')){
                archiveStatus2 = archiveStatus2 + s;
            } else {
                if(archiveStatus1 == ''){
                    archiveStatus1 = s;
                } else {
                    archiveStatus1 = archiveStatus1 +','+s;
                }
            }            
        }
          
      // DE10499 - Split the whereClause based on PA/PSR to consider Partner Assigned/PSR Assigned date.
      string psrStatus = 'Assigned To PSR';
      string uId = UserInfo.getUserId();
      if(str != 'All') {
          if(prmFilterUtility.isPA){
                if((selectedView == activeViewID || selectedView == acceptedViewID) && archiveStatus1!=''){
                    whereClause = whereClause + ' AND  (( Partner_Lead_Status__c ='+ archiveStatus2 + '  OR (Partner_Lead_Status__c IN '+ archiveStatus1 +' )AND Partner_Assigned_Date__c = LAST_N_DAYS:'+archiveDays+'))';
                }else if((selectedView == activeViewID || selectedView == acceptedViewID) && archiveStatus1==''){
                    whereClause = whereClause + ' AND Partner_Lead_Status__c IN'+ archiveStatus2 + ' AND Partner_Assigned_Date__c = LAST_N_DAYS:'+archiveDays;
                }else if(selectedView == newlyAssignedViewID){
                    // For Active lead View
                    //US11655 - Added the PSR parameters to query.
                    whereClause = whereClause + ' AND ((Partner_Lead_Status__c IN '+ str +' AND Partner_Assigned_Date__c = LAST_N_DAYS:'+archiveDays+') OR ( Partner_Lead_Status__c = \''+psrStatus+'\' AND Partner_Assigned_Date__c = LAST_N_DAYS:'+archiveDays+' AND PSR_1__c =  \''+uId+'\'))';
               }else if(selectedView == archiveViewID){
                   // For Archived View, filter for Partner_Lead_Status__c is removed.
                    whereClause = whereClause + ' AND Partner_Lead_Status__c IN '+ str +' AND Partner_Assigned_Date__c < LAST_N_DAYS:'+archiveDays;
                } else { 
                    whereClause = whereClause + ' AND Partner_Lead_Status__c IN '+ str;
                } 
            } else {
                if((selectedView == activeViewID || selectedView == acceptedViewID) && archiveStatus1!=''){
                    whereClause = whereClause + ' AND  (( Partner_Lead_Status__c ='+ archiveStatus2 + '  OR (Partner_Lead_Status__c IN '+ archiveStatus1 +' )AND PSR_Assigned_Date__c = LAST_N_DAYS:'+archiveDays+'))';
                }else if((selectedView == activeViewID || selectedView == acceptedViewID) && archiveStatus1==''){
                    whereClause = whereClause + ' AND Partner_Lead_Status__c IN'+ archiveStatus2 + ' AND PSR_Assigned_Date__c = LAST_N_DAYS:'+archiveDays;
                } else if(selectedView == newlyAssignedViewID){
                    // For Active lead View
                    whereClause = whereClause + ' AND Partner_Lead_Status__c IN '+ str +' AND PSR_Assigned_Date__c = LAST_N_DAYS:'+archiveDays;
               }else if(selectedView == archiveViewID){
                   // For Archived View, filter for Partner_Lead_Status__c is removed.
                    whereClause = whereClause + ' AND Partner_Lead_Status__c IN '+ str +' AND PSR_Assigned_Date__c < LAST_N_DAYS:'+archiveDays;
                } else { 
                    whereClause = whereClause + ' AND Partner_Lead_Status__c IN '+ str;
                } 
            }
        
      }          
         
      //escape each search value with single quotes
      customerName = null != customerName ?String.escapeSingleQuotes(customerName) :'';

      programEventName = null != programEventName ?String.escapeSingleQuotes(programEventName) :'';
      
      campaignDescription = null != campaignDescription ?String.escapeSingleQuotes(campaignDescription) : '';

      stateProvince = null != stateProvince ?String.escapeSingleQuotes(stateProvince) :'';
      city = null != city ?String.escapeSingleQuotes(city) :'';

      System.debug(System.LoggingLevel.INFO,'>>>>>> selectedLeadSource : '+selectedLeadSource);
      
      string lc = getMultiPickSelectedValue(selectedLeadCategory);
      string ls = getMultiPickSelectedValue(selectedLeadSource);      
      //Removed as per the WR-0741
      //string ind = prmFilterUtility.getMappedIndustries(selectedIndustries);
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
      //Removed as per the WR-0741
      /*if('' != ind && ind != 'All') {
        whereclause = whereClause + ' AND Industry IN '+ind;
        cookieValue += ' :: industry : '+ind;
      }*/
      if('' != mt && mt != 'All') {
        whereClause = whereClause +  ' AND  Main_Technology__c IN '+mt;
        cookieValue += ' ::  maintechnology : '+mt;
      }
      if('' != programEventName && programEventName != 'All' ) {
        whereClause = whereClause + ' AND Program_Event_Name__c LIKE \'%'+programEventName+ '%\'';
        cookieValue += ' ::  programevent : '+programEventName;
      }
      
      if('' != campaignDescription && campaignDescription != 'All' ) {
        whereClause = whereClause + ' AND Campaign_Description__c LIKE \'%'+campaignDescription+ '%\'';
        cookieValue += ' ::  campaignDes : '+campaignDescription;
      }   
        
      if('' != cu && cu != 'All') {
        whereClause = whereClause +  ' AND CustomCountry__c  IN '+cu;
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
      // added by gchaitha for US305721
      if(DRTLead == true) {
        whereClause = whereClause + ' AND DRT_Lead__c = true ';
        cookieValue  += ' ::  DRTLead : true';
      }  
      // end  
      if(whereClause != q_where) {
        q_where = whereClause;
      }
            
     prmFilterUtility.createFilterCookie('lead',cookieValue);      
      if(myPg != null) {
        myPg = null;        
        myPg.clearPageRecords();
      }      
      setCon = null;
      getleads();      
      isMassEdit = false;            
    }

    catch(System.QueryException qEx) {
      ApexPages.addMessages(qEx);
    }
    catch(Exception ex) {
      ApexPages.addMessages(ex);
    }
    
    return null;
  }
  // Modified By: Sudi 02 Nov 2014 
  // Release : November Sprint 3
  // User Story : US7093
  // Below code is method is added to assign the partner name to the selected leads in lead filter page

  public override Pagereference AssignPartnerName(string PartnerAccId){
      try{
        User usr = prmFilterUtility.logUser;        
        if(PartnerAccId == null || PartnerAccId == ''){
          ApexPages.addMessage(new ApexPages.Message(Apexpages.Severity.ERROR,'Partner Name cannot be blank!'));
        return null;  
        }
        List<Lead> updateList = new List<Lead>();
//Updated as part of PBI000000056179
        Map<String, String> getlabelMapLead = new Map<String, String>();
        Schema.DescribeFieldResult ta  = Lead.Partner_Lead_Status__c.getDescribe();            
        for(Schema.Picklistentry sp : ta.getPicklistValues()) {
            getlabelMapLead.put(sp.value,sp.label);
        }
        if(this.pageRecords != null && !this.pageRecords.isEmpty()) {       
            for(prmPagenationUtility.WrapperList rec : pageRecords) {
                Lead ldUpdate = new Lead(Id=rec.leadRec.id);
                if(rec.isSelected && rec.leadRec.Partner_Lead_Status__c ==getlabelMapLead.get('Partner Assigned')) {            
                    if(rec.leadRec.Lead_From_Distributor_BE_GEO_ID_PDB__c == null){

                      if(flsUpdateGet(Lead.Lead_From_Distributor_BE_GEO_ID_PDB__c )||flsGet(Lead.Lead_From_Distributor_BE_GEO_ID_PDB__c)) //SCAVA FIX
                       {
                      ldUpdate.Lead_From_Distributor_BE_GEO_ID_PDB__c = usr.Contact.Account.PDB_BE_GEO_ID__c; 
                       }                      
                    }
                    if(flsUpdateGet(Lead.Channel_Partner__c)||flsGet(Lead.Channel_Partner__c)) //SCAVA FIX
                    {
                    ldUpdate.Channel_Partner__c= PartnerAccId; 
                    }
                    if(flsUpdateGet(Lead.PSR_1__c)||flsGet(Lead.PSR_1__c)) //SCAVA FIX
                    {
                    ldUpdate.PSR_1__c = null;
                    }
                    if(flsUpdateGet(Lead.PSR_2__c)||flsGet(Lead.PSR_2__c)) //SCAVA FIX
                    {
                    ldUpdate.PSR_2__c = null;
                    }   
                    if(flsUpdateGet(Lead.PSR_3__c)||flsGet(Lead.PSR_3__c)) //SCAVA FIX
                    {
                    ldUpdate.PSR_3__c = null;
                    }
                    if(flsUpdateGet(Lead.Partner_Lead_Status__c)||flsGet(Lead.Partner_Lead_Status__c)) //SCAVA FIX
                    {
                    ldUpdate.Partner_Lead_Status__c ='Partner Assigned';
                    }                   
                    updateList.add(ldUpdate);                      
                }
            }
        }
      if(!updateList.isEmpty()) {        
        update (UpdateList);
        clearAsignPSRFields();
        cancelMassUpdate();
        myPg.clearPageRecords();
        pageRecords = new List<prmPagenationUtility.WrapperList>();
        doSearch();
      }
      else{
        cancelMassUpdate();
      }
      }
      catch (Exception ex){
        ApexPages.addMessages(ex);
      }
      return null;
    }
    
    public override Pagereference assignPSRs() {
    try {
      psr= getPsr();      
      psr1_Id = psr.psr1_Id;
      psr2_Id = psr.psr2_Id;
      psr3_Id = psr.psr3_Id;
      
      if(psr1_Id == null && psr2_Id == null && psr3_Id == null) {
        ApexPages.addMessage(new ApexPages.Message(Apexpages.Severity.ERROR,'PSR\'s cannot be blank!'));
        return null;
      }
      List<Lead> updateList = new List<Lead>();
      if(this.pageRecords != null && !this.pageRecords.isEmpty()) {

        for(prmPagenationUtility.WrapperList rec : pageRecords) {
          if(rec.isSelected == true) {  
            lead ldUpdate = new lead(Id=rec.leadRec.id);          
            if(psr1_Id != null && psr1_Id != '') {
            if(flsUpdateGet(lead.PSR_1__c)||flsGet(lead.PSR_1__c)) //SCAVA FIX
              {
              ldUpdate.PSR_1__c = (Id)psr1_Id;
              }
            }
            if(psr2_Id != null && psr2_Id != '') {
            if(flsUpdateGet(lead.PSR_2__c)||flsGet(lead.PSR_2__c)) //SCAVA FIX
              {
              ldUpdate.PSR_2__c = (Id)psr2_Id;
              }
            }
            if(psr3_Id != null && psr3_Id != '') {
            
            if(flsUpdateGet(lead.PSR_3__c)||flsGet(lead.PSR_3__c)) //SCAVA FIX
              {
              ldUpdate.PSR_3__c = (Id)psr3_Id;
              }
            }
            updateList.add(ldUpdate);            
          }
        }
      }
      if(!updateList.isEmpty()) {        
        update (UpdateList);
        clearAsignPSRFields();
        myPg.clearPageRecords();
        pageRecords = new List<prmPagenationUtility.WrapperList>();
        doSearch();
      }      
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
    set;
  }



  public String Currentuseraccount { 
    get{
      return String.valueof(new prmFilterUtility().getCurrentUserParentAccountId());
    }
    set; 
  }


  public String channelAccount{
    get{
      return String.valueof(prmFilterUtility.loggedInUserPartnerAccount);
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
        else if(fname != null && fname.equalsIgnoreCase('campaignDesc')) {
          campaignDescription = fvalue;
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
        // added by gchaitha for US305721
        else if(fname != null && fname.equalsIgnoreCase('DRTLead')){
          DRTLead = fvalue=='true'?true:false;
        } 
        // end
          
      }      
    }
    else {      
      System.debug(System.LoggingLevel.INFO,'### Cookie is null');
    }    
  }
  
  public void clearFields() {
    prmFilterUtility.removeFilterCookie('lead');
    // added by gchaitha for US305721
    DRTLead = false;
    // end  
    customerName = '';
    selectedleadCategory = new List<string>();
    selectedleadSource = new List<string>();
    selectedIndustries = new List<string>();
    selectedmainTechnology = new List<string>();
    programEventName = '';
    campaignDescription = '';
    showSelectedCount= '';
    selectedCountries= new List<string>();
    // Modified By: Sudi 17 Oct 2014 
    // Release : November Sprint 3
    // User Story : US7054
    // Below code added for clear partner name filter for disti user 
    selectedPartnerName = new List<string>();
    stateProvince = '';
    city = '';
    isSelectedChekBox = false;
    selectedView = null;
    isMassEdit = false;
    selectAll = false;
    psr = getPsr();
    psr.leadStatus ='';
    psr.selectedPartner ='';
    editPageRecords = new List<prmPagenationUtility.WrapperList>();
    // Get view options    
    initlize();
    
  }
  
  public override Pagereference updateStatus(Lead leadRec) {
    try {
        List<Lead> updateList = new List<Lead>();
        String leadStatus = leadRec.Partner_Lead_Status__c; 
        //Updated as part of PBI000000056179
        Map<String, String> getlabelMapLead = new Map<String, String>();
        Schema.DescribeFieldResult ta  = Lead.Partner_Lead_Status__c.getDescribe();            
        for(Schema.Picklistentry sp : ta.getPicklistValues()) {
            getlabelMapLead.put(sp.value,sp.label);
        }       
        if(this.pageRecords != null && !this.pageRecords.isEmpty()) {           
          for(prmPagenationUtility.WrapperList rec : pageRecords) {
            Lead ldUpdate = new Lead(Id=rec.leadRec.id);
            if(rec.isSelected) {              
              if(isPA && rec.leadRec.Partner_Lead_Status__c ==  getlabelMapLead.get('Partner Assigned') && (leadStatus == 'Assigned to PSR' || leadStatus == 'Actively Working')) {                
                if(rec.leadRec.PSR_1__c == null || rec.leadRec.PSR_1__c == '') {
                
                if(flsUpdateGet(lead.PSR_1__c)||flsGet(lead.PSR_1__c)) //SCAVA FIX
                 {
                  ldUpdate.PSR_1__c = prmFilterUtility.logUser.Id;
                 }
                  System.debug(System.LoggingLevel.INFO,'&&&& Lead Rec PSR1 : '+rec.leadRec.PSR_1__c+' &&&& prmFilterUtility.logUser.Id : '+prmFilterUtility.logUser.Id);
                }
              }
              if(flsUpdateGet(lead.Partner_Lead_Status__c)||flsGet(lead.Partner_Lead_Status__c)) //SCAVA FIX
              {
              ldUpdate.Partner_Lead_Status__c = leadStatus;
              }
              updateList.add(ldUpdate);              
            }
          }
        }
        if(!updateList.isEmpty()) {          
          update (UpdateList);
          clearAsignPSRFields();
          myPg.clearPageRecords();
          psr = getPsr();
          psr.leadStatus ='';
          showSelectedCount= '';
          pageRecords = new List<prmPagenationUtility.WrapperList>();
          doSearch();  
        }        
    }
    catch(Exception ex) {
      System.debug(System.LoggingLevel.ERROR, '################## Exception ###################');
      System.debug(System.LoggingLevel.ERROR,ex.getMessage());
      ApexPages.addMessages(ex);
    }
    return null;
  }
  
  public SCP_Communities_LeadFilter_Columns__c getLeadFieldAPI(string sFieldLabel){
    //Commented the code to fix the VillageChief exception - Consider simply returning the value vs storing it in local variable
    // SCP_Communities_LeadFilter_Columns__c myCS1 = SCP_Communities_LeadFilter_Columns__c.getValues(sFieldLabel);    
    // return myCS1;     
    return SCP_Communities_LeadFilter_Columns__c.getValues(sFieldLabel);
  } 
  
  public override void enableMassEdit(String status) {
    if(status == 'Actively Working' || status.startsWith('Closed-Order')) {
      isMassEdit = true;
      editPageRecords = new List<prmPagenationUtility.WrapperList>();
    
      for(prmPagenationUtility.WrapperList rec : pageRecords) {
        if(rec.isSelected) {
          rec.selectedStatus = status;
          editPageRecords.add(rec);
        }
      }
      renderPSR = false;
    }
    else {
      renderPSR = true;
      isMassEdit = false;
    }    
  }
  /*
  * Modified by : Saduvvur 
  * Modified on : 10/22/2014
  * Method to update selected lead records modified using mass update
  */
  public Pagereference massUpdate() {
    try {      
        List<Lead> updateList = new List<Lead>();
        //Updated as part of PBI000000056179
        Map<String, String> getlabelMapLead = new Map<String, String>();
        Schema.DescribeFieldResult ta  = Lead.Partner_Lead_Status__c.getDescribe();            
        for(Schema.Picklistentry sp : ta.getPicklistValues()) {
            getlabelMapLead.put(sp.value,sp.label);
        }   
        
      if(this.pageRecords != null && !this.pageRecords.isEmpty()) {  
          for(prmPagenationUtility.WrapperList rec : pageRecords) {                     
            if(rec.isSelected) {
              lead ldUpdate = new lead(Id=rec.leadRec.id);
              String leadStatus = rec.selectedStatus; 
              if(isPA && rec.leadRec.Partner_Lead_Status__c == getlabelMapLead.get('Partner Assigned') && (leadStatus == 'Assigned to PSR' || leadStatus == 'Actively Working')) {
                if(rec.leadRec.PSR_1__c == null || rec.leadRec.PSR_1__c == '') {
                if(flsUpdateGet(lead.PSR_1__c)||flsGet(lead.PSR_1__c)) //SCAVA FIX
                {
                ldUpdate.PSR_1__c = prmFilterUtility.logUser.Id;  
                }                 
                }
              }
              if(flsUpdateGet(lead.Partner_Lead_Status__c)||flsGet(lead.Partner_Lead_Status__c)) //SCAVA FIX
                {
              ldUpdate.Partner_Lead_Status__c = leadStatus;  
                }
                if(flsUpdateGet(lead.ProductAmount__c)||flsGet(lead.ProductAmount__c)) //SCAVA FIX
                {
              ldUpdate.ProductAmount__c = rec.leadRec.ProductAmount__c;
              }
              if(flsUpdateGet(lead.ServicesAmount__c)||flsGet(lead.ServicesAmount__c)) //SCAVA FIX
                {
              ldUpdate.ServicesAmount__c = rec.leadRec.ServicesAmount__c;
              }
              if(flsUpdateGet(lead.Distributor_Name__c)||flsGet(lead.Distributor_Name__c)) //SCAVA FIX
                {
              ldUpdate.Distributor_Name__c = rec.leadRec.Distributor_Name__c; 
               }              
              updateList.add(ldUpdate);              
            }
          }
        }       
        if(!updateList.isEmpty()) {          
          update (UpdateList);
          isMassEdit = false;
          selectAll = false;
          renderPSR = false;
          clearAsignPSRFields();
          psr = getPsr();
          psr.leadStatus ='';
          myPg.clearPageRecords();
          showSelectedCount= '';
          pageRecords = new List<prmPagenationUtility.WrapperList>();
          doSearch();  
        }        
    }
    catch(Exception ex) {
      System.debug(System.LoggingLevel.ERROR, '################## Exception ###################');
      System.debug(System.LoggingLevel.ERROR,ex.getMessage());      
      ApexPages.addMessages(ex);      
    }
    return null;
  }
  /*
  * Modified by : Saduvvur 
  * Modified on : 10/22/2014
  * Method to cancelMassUpdate and reset the drop down selections
  */
  public override Pagereference cancelMassUpdate() {
    psr = getPsr();
    psr.leadStatus ='';
    psr.selectedPartner ='';
    psr.disableUpdate = false;
    isMassEdit = false;
    selectAll = false;
    renderPSR = false;
    showSelectedCount= '';
    for(prmPagenationUtility.WrapperList rec : pageRecords) {
      if(rec.isSelected) {
        rec.isSelected = false;
      }
    }
    pageRecords = new List<prmPagenationUtility.WrapperList>();
    doSearch();
    return null;
  }  
  public Boolean renderPSR { get; set; } 
  public Boolean istoggelSelectAll { get; set; }  
  public Boolean selectAll { get; set; }
  public void toggelPSR() {
    istoggelSelectAll = false;
    System.debug(System.LoggingLevel.INFO,'########## INSIDE TOGGEL PSR ##########');
    renderPSR = false;
    integer chkCount = 0;
    for(prmPagenationUtility.WrapperList rec : pageRecords) {
      if(rec.isSelected){
        renderPSR = true;
        chkCount ++;        
      }
    }
    if(chkCount == 1){
        showSelectedCount = chkCount + ' ' +Label.PRM_record_selected; 
    }
    else if(chkCount > 1 ){
        showSelectedCount = chkCount + ' ' + Label.PRM_records_selected;
    }
    else{
        showSelectedCount = '';
        //renderPSR = false;
    }       
  }
  
  // pagination veriables used on page
   Public Integer noOfRecords{get; set;}
   Public integer size{get;set;}
   public string sizeStr{get;set;}
   public Integer totalPages {get; set; } 
   
   public Integer startNo { get; set; }
   public Integer endNo { get; set; }
   // standard set controller for pagination
   public ApexPages.StandardSetController setCon {
        get{            
            if(setCon == null){                   
                sizeStr = (sizeStr == null) ? '10' : sizeStr;                
                size = integer.valueof(sizeStr);                                  
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(q_queryStr));
                setCon.setPageSize(size);
                noOfRecords = setCon.getResultSize();                
                setCon.setPageNumber(1);
                pageNumber = 1;               
            }
            return setCon;
        }set;
    }
  /*
  * Modified by : Sudi 
  * Modified on : 07/10/2015
  * method is used to get the lead wrapperlist class.
  */
public List<prmPagenationUtility.WrapperList> getleads(){       
    pageRecords = new List<prmPagenationUtility.WrapperList>();
    
    System.debug(' *************** Final Query --> '+ q_queryStr);    
    String qstr = 'SELECT COUNT() FROM LEAD WHERE '+q_where;
    System.debug(' *************** Final Query String --> '+ qstr);
    Integer totalRecCount =  Database.countQuery(qstr) ;
    System.debug(System.LoggingLevel.DEBUG,' ******************************* Total # of records = ' + totalRecCount );
    
    if( totalRecCount > 10000 ) {
    
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,System.Label.LnP_Filter_Text);
        ApexPages.addMessage(myMsg);
        
    }
        
    for(lead a : (List<lead>)setCon.getRecords()){          
         pageRecords.add(new prmPagenationUtility.WrapperList(a));          
    }
    cal();
    return pageRecords;
}
/*
  * Modified by : Sudi 
  * Modified on : 07/10/2015
  * method is used to refresh the grid if user select the page number
  */
    public pageReference refresh() {
        setCon = null;
        renderPSR =false;
        selectAll = false;
        showSelectedCount= '';
        getleads();                
        return null;
    }
     
    public Boolean hasNext { get; set; }
    public Boolean hasPrevious { get; set; }
  
    public Integer pageNumber {get; set; }
  
    public void first() {
        setCon.first();
        renderPSR =false;
        selectAll = false;
        showSelectedCount= '';
        getleads();        
    }
  
    public void last() {
        setCon.last();
        renderPSR =false;
        selectAll = false;
        showSelectedCount= '';
        getleads();        
    }
  
    public void previous() {
        setCon.previous();
        renderPSR =false;
        selectAll = false;
        showSelectedCount= '';
        getleads();        
    }
  
    public void next() {
        setCon.next();
        renderPSR =false;
        selectAll = false;
        showSelectedCount= '';
        getleads();       
    }
    
    public void setPageNum() {
        if(pageNumber == null) {
            pageNumber = 1;
        }
        renderPSR =false;
        selectAll = false;
        showSelectedCount= '';
        setCon.setPageNumber(pageNumber);
        getleads();
        cal();
    }
    public void cal() {
        pageNumber = setCon.getpageNumber();
        totalPages = 0;
        if(noOfRecords >0) {
            Integer mod = math.mod(noOfRecords,size);
            Double div = noOfRecords/size;
            totalPages =(integer) (mod  == 0 ? div : math.floor(div)+1);
        }          
        startNo = (pageNumber * size)+1-size;        
        if(noOfRecords  == 0){
            startNo= 0;
        }
        if((pageNumber * size)>noOfRecords) { 
            endNo = noOfRecords;
        }
        else {
            endNo = (pageNumber * size);
        }        
        hasNext = setCon.getHasNext();
        hasPrevious = setCon.getHasPrevious();             
    }    
}