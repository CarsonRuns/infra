public with sharing class SCP_Communities_TPFilter_CT extends SCP_Communities_PageControllerBase  {


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
    
  
  // Constructor
  public SCP_Communities_TPFilter_CT() {
    System.debug(System.LoggingLevel.INFO,'$$$$$$$$$$$$$$$$$$$$$$$$$ INSIDE TP CONSTRUCTOR $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
    String view = ApexPages.currentpage().getParameters().get('view');
    if(view != null) {
      SCP_Communities_listviews__c mprec = [Select Id from SCP_Communities_listviews__c Where View_Alias__c = :view];
      this.selectedview = mprec.Id;
    }
    else {
      checkForExistingCookie();
    }
    
    String tpc =ApexPages.currentpage().getParameters().get('tpc');
    if(tpc != null && tpc == '1') {
      ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,Label.PRM_TP_WorkProspect_Creation_Successfull);
      ApexPages.addMessage(myMsg);
    }
    
    initlize();
    System.debug(System.LoggingLevel.INFO,'$$$$$$$$$$$$$$$$$$$$$$$$$ End of TP CONSTRUCTOR $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
  }

  // ovverridden methods of page controller base

  public Map<String, SCP_Communities_ComponentControllerBase> componentControllerMap { get; set; }
  public override Map<String, SCP_Communities_ComponentControllerBase> getComponentControllerMap(){
    System.debug(System.LoggingLevel.INFO, '*** INSIDE getComponentControllerMap OF Taeget Prospect : '+ this.componentControllerMap);
    if(this.componentControllerMap == null ) {
      this.componentControllerMap = new Map<String, SCP_Communities_ComponentControllerBase>();
    }
    return this.componentControllerMap;
  }
  //new method for putting value in the hashmap
  public override void setComponentControllerMap(String key, SCP_Communities_ComponentControllerBase compController){
    System.debug(System.LoggingLevel.INFO, '*** INSIDE setComponentControllerMap OF Target Prospect : '+key);
    if(this.componentControllerMap == null) {
      this.componentControllerMap = new Map<String, SCP_Communities_ComponentControllerBase>();
    }
    this.componentControllerMap.put(key,compController);    
      //setComponentController(compController);
  } 

  public override SCP_Communities_PageControllerBase getThis() {
    System.debug(System.LoggingLevel.INFO, '*** INSIDE getThis OF TP');
    return (SCP_Communities_TPFilter_CT)this;
  }

  public override Pagereference assignPSRs() {    
    string psr1_Id, psr2_Id, psr3_Id;
    psr= getPsr();    
    psr1_Id = psr.psr1_Id;
    psr2_Id = psr.psr2_Id;
    psr3_Id = psr.psr3_Id;
    if(psr1_Id == null && psr2_Id == null && psr3_Id == null) {
      ApexPages.addMessage(new ApexPages.Message(Apexpages.Severity.ERROR,'PSR\'s cannot be blank!'));
      return null;
    }

    List<Assigned_Partner__c> updateList = new List<Assigned_Partner__c>();
    if(pageRecords != null && !pageRecords.isEmpty()) {

      for(prmPagenationUtility.WrapperList rec : pageRecords) {
        if(rec.isSelected) {
          System.debug('*** psr1 : '+psr1_Id+' psr2 : '+psr2_Id+' psr3 : '+psr3_Id);
          if(psr1_Id != null && psr1_Id != '') {
          
             if(flsUpdateGet(Assigned_Partner__c.Assigned_Partner_Sales_Rep__c)||flsGet(Assigned_Partner__c.Assigned_Partner_Sales_Rep__c)) //SCAVA FIX
             {        
            rec.tp.Assigned_Partner_Sales_Rep__c = (Id)psr1_Id;
            }
          }
          if(psr2_Id != null && psr2_Id != '') {
          if(flsUpdateGet(Assigned_Partner__c.Assigned_Partner_Sales_Rep_2__c)||flsGet(Assigned_Partner__c.Assigned_Partner_Sales_Rep_2__c)) //SCAVA FIX
             {
            rec.tp.Assigned_Partner_Sales_Rep_2__c = (Id)psr2_Id;
            }
          }
          if(psr3_Id != null && psr3_Id != '') {
          if(flsUpdateGet(Assigned_Partner__c.Assigned_Partner_Sales_Rep_3__c)||flsGet(Assigned_Partner__c.Assigned_Partner_Sales_Rep_3__c)) //SCAVA FIX
             {
            rec.tp.Assigned_Partner_Sales_Rep_3__c = (Id)psr3_Id;
            }
          }

          updateList.add(rec.tp);          
        }
      }
    }
    if(!updateList.isEmpty()) {      
      update (UpdateList);
      pageRecords = new List<prmPagenationUtility.WrapperList>();
      myPg.clearPageRecords();
      doSearch();
    }    
    return null;
  }


  // End of ovverridden methods

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


  // Variblese used to collect filter parameters for Target Prospect
  
  // Get page base url
  public String getSearchPageUrl() {
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
    String pageUrl = baseUrl + 'apex/SCP_Communities_psrSearch';    
    return pageUrl;    
  }
  
/*  
  public String getWrokProspectPageUrl() {
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
    System.debug('*** baseUrl : '+baseUrl);
    
    String pageUrl = baseUrl + 'apex/SCP_Communities_WorkProspects';
    
    return pageUrl;
  }
  */
  public string customerName { get; set; }

  public List<String> selectedTagetArchitecture { get; set; }
  public List<SelectOption> targetArchitectureList {get; set;}

  public String ciscoRecommendedPSR { get; set; }
  public List<SelectOption> CRPSRList {get; set; }

  public List<SelectOption> industryList { get; set; }
  public List<string> selectedIndustry { get; set; }

  public List<SelectOption> technologyList { get; set; }
  public string selectedTechnology { get; set; }

  public List<SelectOption> countryList { get; set; }
  public List<string> selectedCountry { get; set; }

  public string stateorProvince { get; set; }
  public string city { get; set; }

  public string marketingPlay { get; set; }
  public List<Selectoption> marketingPlayList { get ;  set; }


  public string selectedView { 
    get {
      if(selectedView == null) {
        selectedView = viewOptions[0].getValue();
      }
      return selectedView;
    }
    set; 
  }
  
  public Boolean isNewlyAssignedProspect {
    get {
      string str = SCP_Communities_listviews__c.getValues('My Newly Assigned Prospects').Id;
      System.debug(System.LoggingLevel.INFO,'### str : '+str);
      if(selectedView == str) {
        isNewlyAssignedProspect = true;  
      }
      else {
        isNewlyAssignedProspect = false;
      }
      System.debug(System.LoggingLevel.INFO,'### isNewlyAssignedProspect : '+isNewlyAssignedProspect);
      return (isNewlyAssignedProspect);
    }
    set ;
  }

  private static Id UCP_viewId {
    get {
      if(UCP_viewId == null) {
        UCP_viewId = SCP_Communities_listviews__c.getValues('Uncovered Prospects').Id;
      }
      return UCP_viewId;
    }
    set;
  }
  
  public Boolean isEnglish {
    get{
      return (prmFilterUtility.logUser.LanguageLocaleKey == 'en_US');
    }
  }
  
  public List<SelectOption> viewOptions {
    get {      
      List<SelectOption> viewOptions = new List<SelectOption>();
      
      for(SCP_Communities_listviews__c vRec : prmFilterUtility.filterviews) {
        
        if(vRec.ObjectType__c.equalsIgnoreCase('TP')) {          
          viewOptions.add(new SelectOption(vRec.Id,vRec.Name));
          
          if(vRec.psr_status__c == null && vRec.pa_status__c == null) {
            UCP_viewId = vRec.Id;
          }
          
        }
        
      }

      return viewOptions;
    }
    set;
  }
  
  public Boolean isUncoveredProspects {
    get {
      if(selectedView == UCP_viewId ) {
        return true;
      }
      return false;
    }
  }
  
  public String uncoveredProspectsMsg {
    get {
      if(uncoveredProspectsMsg == null) {
        uncoveredProspectsMsg = Label.PRM_Uncovered_Prospects_Message;
        Integer tpCount = 0;
        String accId = prmFilterUtility.loggedInUserPartnerAccount;
        tpCount =[SELECT COUNT() 
          FROM Assigned_Partner__c 
          WHERE Assigned_Partner__c =:accId AND 
              Target_Prospect_Source__c ='Partner' AND 
              Customer_Account__r.Unallocated_Account__c ='Yes' AND Assignment_Activated__c = true];
        Integer rmCount = 600 - tpCount;
        rmCount = rmCount < 0 ? 0 : rmCount;
        uncoveredProspectsMsg = uncoveredProspectsMsg.replace('{0}',String.valueOf(rmCount));
        uncoveredProspectsMsg = uncoveredProspectsMsg.replace('{1}',String.valueOf(600));
      }
      return uncoveredProspectsMsg;
    }
    set;
  }

  // End of filter fields

  public string q_select { 
    get {
      if(q_select == null ) {
        q_select = ' SELECT Customer_Account__r.CRName__c,Customer_Account__r.CRCity__c, Customer_Account__r.CRAddressLine1__c,Customer_Account__r.CRState__c,';
        q_select += ' Customer_Account__r.CRCountry__c, Customer_Account__r.AddressLine1__c, Customer_Account__r.City__c, Customer_Account__r.State__c,';
        q_select += ' Customer_Account__r.Name, Customer_Account__r.Incumbent_Partner_Status__c, Customer_Account__r.flags__c, toLabel(Customer_Account__r.Country__c), ';
        q_select += ' toLabel(Customer_Account__r.Industry),Industry__c ,name,Expiration_Date__c ,Customer_Account__r.Owner.Name, Prospect_Age__c ,';
        q_select += ' toLabel(Target_Architecture__c),Assigned_Partner_Sales_Rep__c ,Target_Description__c, Partner_Assigned_Date__c,toLabel( partner_status__c),'; 
        q_select += ' Customer_Account__r.id,Customer_Account_Name__c, Customer_Account__r.CRZipPostalCode__c, Customer_Account__r.ownerid, id,Date_Added__c,'; 
        q_select += ' TBM_TAM_Name__c,Customer_Account__r.Incumbent_Partner_Status_Image__c,Partner_Added_Date_Time__c, Marketing_Play_Name__c,Cisco_Recomended_Partner_Sales_Rep__c ';
      }
      return q_select;
    }
    set;
  }

  public string q_from {
    get {
      if(q_from == null ) {
        q_from = 'From Assigned_Partner__c ';
      }
      return q_from;
    }
    set;
  }

  public string q_where {
    get {
      if(q_where == null) {
        System.debug(System.LoggingLevel.INFO,'#$ prmFilterUtility.loggedInUserAccounts : '+prmFilterUtility.loggedInUsersAccounts);
        if(prmFilterUtility.loggedInUsersAccounts != null) {
          q_where = 'Where id != null AND assignment_activated__c =true AND ( Customer_Account__c IN '+prmFilterUtility.loggedInUsersAccounts +' )';
        }
        else {
          q_where = 'Where id != null AND assignment_activated__c =true';
        }
      }
      return q_where;
    }
    set;
  }

  Integer q_limit {
    get {
      if(q_limit == null || q_limit == 0 ) {
        q_limit = 250;
      }
      return q_limit;
    }
    set;
  }
  
  Integer q_offset {
    get {
      if(q_offset == null) {
        q_offset = 0;
      }
      return q_offset;
    }
    set;
  }
  
  String q_orderBy {
    get {
      if(q_orderBy == null ) {
        q_orderBy = ' ORDER By Partner_Assigned_Date__c ';
      }
      return q_orderBy;
    }
    set;
  }

  public string q_finalQuery {
    get{
      //if(q_finalQuery == null ) {
        q_finalQuery = q_select + q_from + q_where + q_orderBy+ ' LIMIT '+q_limit + ' OFFSET '+q_offset;
      //}
      return q_finalQuery;
    }
    set;
  }


  public List<prmPagenationUtility.WrapperList> pageRecords;
  
  public List<prmPagenationUtility.WrapperList> getpageRecords() {
    return (pageRecords);
  }
  
  public void initlize() {
    try {
      
      System.debug(System.LoggingLevel.INFO,'$$$$$$$$$$$$$$$$$$$$$$$$$ INSIDE TP INITLIZE $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
      marketingPlayList = new List<SelectOption>();
      marketingPlayList.add(new SelectOption('All',Label.PRM_Picklist_Value_All));
  
      for(Aggregateresult ar : [Select Marketing_Play_Name__c, Count(Id) From Assigned_Partner__c Where  Marketing_Play_Name__c != null Group By Marketing_Play_Name__c ]) {
        marketingPlayList.add(new SelectOption((string)ar.get('Marketing_Play_Name__c'),(string)ar.get('Marketing_Play_Name__c')));
      }
  
      // Target Architecture
      targetArchitectureList = new list<SelectOption>();
    //  targetArchitectureList.add(new SelectOption('All',Label.PRM_Picklist_Value_All));    
      Schema.DescribeFieldResult ta  = Assigned_Partner__c.Target_Architecture__c.getDescribe();
      for(Schema.Picklistentry sp : ta.getPicklistValues()) {
        targetArchitectureList.add(new SelectOption(sp.value,sp.label));
      }
  
      // Cisco Recommended PSR
      CRPSRList = new List<SelectOption>();
      if(isPA && !isUncoveredProspects) {
        CRPSRList.add(new SelectOption('All',Label.PRM_Picklist_Value_Select_options));
        prmPSRLookUp_CT conRec = new prmPSRLookUp_CT();
        conRec.psrId = Userinfo.getUserId();
        conRec.currentUserParentAccountId = conRec.getCurrentUserParentAccountId();
        conRec.myCon = conRec.getMyCon();
        conRec.myCon.setPageSize(200);
        for(User userRec : (List<User>)conRec.myCon.getRecords()) {
          CRPSRList.add(new SelectOption(userRec.Id,userRec.Name));
        }
      }
  
      // Industry
      industryList = new list<SelectOption>();
  //    industryList.add(new SelectOption('All',Label.PRM_Picklist_Value_All));    
      //Schema.DescribeFieldResult ind  = Account.Industry.getDescribe();
      Schema.DescribeFieldResult ind  = SCP_Communities_DTO__c.Industry__c.getDescribe();
      for(Schema.Picklistentry sp : ind.getPicklistValues()) {
        industryList.add(new SelectOption(sp.value,sp.label));
      }
  
      // Technology
      technologyList = new List<SelectOption>();
      technologyList.add(new SelectOption('All',Label.PRM_Picklist_Value_Select_options));
  
      Schema.DescribeFieldResult mt  = Assigned_Partner__c.Technology_Filter__c.getDescribe();
      for(Schema.Picklistentry sp : mt.getPicklistValues()) {
        technologyList.add(new SelectOption(sp.value,sp.label));
      }
  
      //Contry
  
      countryList = new list<SelectOption>();
    //  countryList.add(new SelectOption('All',Label.PRM_Picklist_Value_All));    
      Schema.DescribeFieldResult con  = Account.Country__c.getDescribe();
      for(Schema.Picklistentry sp : con.getPicklistValues()) {
        countryList.add(new SelectOption(sp.value,sp.label));
      }
  
      //clearfields();
      //getViewbyFilter();
      myPg = null;
      doSearch();
      System.debug(System.LoggingLevel.INFO,'$$$$$$$$$$$$$$$$$$$$$$$$$ End of TP INITLIZE $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
    }
    catch(Exception ex) {
      System.debug(System.LoggingLevel.ERROR, '############## Exception ############ '+ex.getMessage());
      Apexpages.addMessages(ex);
    }
  }

  public void getViewbyFilter() {
    System.debug(System.LoggingLevel.INFO,'$$$$$$$$$$$$$$$$$$$$$$$$$ INSIDE TP getViewByFilter $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$');    
    if(selectedView != null) {
      if(!isUncoveredProspects) {
        string con = prmFilterUtility.whereClauseforView('tp', selectedView);        
        if(con != 'All') {
          q_where = q_where + ' AND  Partner_Status__c IN '+con;
        }
      }
      else {//(selectedView == 'Uncovered prospects')
        // For Uncovered view
        q_select = 'Select a.CRCity__c, a.City__c, a.CRCountry__c, a.Country__c, a.CRState__c, a.State__c,a.AddressLine1__c,a.CRAddressLine1__c , a.CRZipPostalCode__c, a.Current_FY_Wallet_Total_000__c, a.Id, a.Incumbent_Partner_Status__c, a.Industry, a.Name, a.CRName__c, a.Show_Account_in_Unallocated_Pool__c, a.Wallet_Switching_000__c, a.Wallet_Routing_000__c, a.Wallet_Security_000__c, a.Wallet_Wireless_000__c, a.Wallet_Collab_Applications__c, a.Wallet_Services_000__c, a.Wallet_Unified_Communications_000__c, a.Wallet_Data_Center_UCS_000__c, a.Wallet_Video_000__c, a.Wallet_Other_000__c, a.Expected_Bookings_Switching_000__c, a.Expected_Bookings_Routing_000__c, a.Expected_Bookings_Security_000__c, a.Expected_Bookings_Wireless_000__c, a.Expected_Bookings_Collab_Voice_000__c, a.Expected_Bookings_Data_Center_UCS_000__c, a.Expected_Bookings_Telepresence_000__c, a.Expected_Bookings_Collab_App_000__c, a.Expected_Bookings_Services_000__c, a.Current_FY_RAD_Strategy__c';
        q_from = ' FROM Account a ';
                if(Test.isRunningTest()) {
                    q_where = ' Id != null ';
                }
                else {
                  q_where = ' Where Id != null AND a.Show_Account_in_Unallocated_Pool__c = \'TRUE\' ';
                }
        
        q_limit = 20;
        q_offset = 0;
        q_orderBy = ' ORDER BY CreatedDate ASC NULLS Last ';        
      }
    }
    System.debug(System.LoggingLevel.INFO,'$$$$$$$$$$$$$$$$$$$$$$$$$ End of TP getViewByFilter $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
    
  }

  
  // Getting where clause

  public void doSearch() {
    try {
      System.debug(System.LoggingLevel.INFO,'$$$$$$$$$$$$$$$$$$$$$$$$$ INSIDE TP doSearch $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
      String cookieValue;
      q_select = null;
      q_from = null;
      q_where = null;
      q_orderBy = null;
      q_offset = null;
      q_limit = null;
      
      q_finalQuery = null;
      
      System.debug(System.LoggingLevel.INFO,'inside search ###'+q_where);
  
      // Filterting based on view
      getViewbyFilter();
      
      cookieValue = 'view : '+selectedView;    
      string whereClause = q_where;
      
      // Filtering based on Marketing play name  
      if(marketingPlay != null && marketingPlay != '' && marketingPlay != 'All') {
        whereClause  = whereClause + ' AND Marketing_Play_Name__c = \''+marketingPlay+'\'';
        cookieValue += ':: marketingplayname : '+marketingPlay;
      }
  
      // Customer Name
      if(customerName != null && customerName != '') {
        customerName = String.escapeSingleQuotes(customerName);
        if(isUncoveredProspects) {
          whereClause = whereClause + ' AND ( CRName__c LIKE \'%'+customerName +'%\''
            +' OR Name Like \'%'+customerName+'%\')';
        }
        else {
          whereClause = whereClause + ' AND ( Customer_Account__r.CRName__c LIKE \'%'+customerName +'%\''
            +' OR Customer_Account__r.Name Like \'%'+customerName+'%\''
            +' OR Name LIKE \'%'+customerName+'%\')';
        }
        cookieValue += ':: customerName : '+customername;
      }
  
      // Target Architecture
      string ta = prmFilterUtility.getMultiPickSelectedValue(selectedTagetArchitecture);
      if(ta != 'All') {
        whereClause = whereClause +'  AND Target_Architecture__c IN '+ta;
        cookieValue += ':: targetarchitecture : '+ta;
      }
  
      // Cisco recommended PSR
      if(!isUncoveredProspects && ciscoRecommendedPSR != null && ciscoRecommendedPSR != 'All' && ciscoRecommendedPSR != '') {
        if(isNewlyAssignedProspect) {
          whereClause = whereClause +' AND Cisco_Recomended_Partner_Sales_Rep__c = \''+ciscoRecommendedPSR+'\'';
          
        }
        else {
          whereClause = whereClause +' AND (Assigned_Partner_Sales_Rep__c = \''+ciscoRecommendedPSR+'\' OR Assigned_Partner_Sales_Rep_2__c = \''+ciscoRecommendedPSR+'\' OR Assigned_Partner_Sales_Rep_3__c = \''+ciscoRecommendedPSR+'\' )';
        }
        cookieValue += ':: ciscoRecommendedPSR : '+ciscoRecommendedPSR;
      }
  
      // Industry
      //string ind = prmFilterUtility.getMultiPickSelectedValue();
      string ind = prmFilterUtility.getMappedIndustries(selectedIndustry);
      if(ind != '' && ind != 'All') {
        if(isUncoveredProspects) {
          whereClause = whereClause +'  AND Industry IN '+ind;
        }
        else {
          whereClause = whereClause +'  AND Customer_Account__r.Industry IN '+ind;
        }
        cookieValue += ':: industry : '+ind;  
      }
  
      //Technology  
      if(selectedTechnology != null && selectedTechnology != 'All') {
        string str = prmFilterUtility.whereClauseforTPTechnology(selectedTechnology,isUncoveredProspects);
        if(str != null && str != '') {
          whereClause = whereClause + ' AND  '+str;
        }
        cookieValue += ':: technology : '+selectedTechnology;
      }
  
      // Country      
      string con = prmFilterUtility.getMultiPickSelectedValue(selectedCountry);
      if(con != 'All') {
        if(isUncoveredProspects) {
          whereClause = whereClause +' AND ( CRCountry__c IN '+con+' OR Country__c IN '+con+' )';
        } 
        else {
          whereClause = whereClause +' AND ( Customer_Account__r.CRCountry__c IN '+con+' OR Customer_Account__r.Country__c IN '+con+' )';
        }
        cookieValue += ':: country : '+con;
        
      }
  
      // State
      if(stateorProvince != null && stateorProvince != '') {
        stateorProvince = String.escapeSingleQuotes(stateorProvince);
        
        if(isUncoveredProspects) {
          whereClause = whereClause +' AND ( CRState__c LIKE \'%'+stateorProvince+'%\' OR State__c LIKE \'%'+stateorProvince+'%\' ) ';
        }
        else {
          whereClause = whereClause +' AND ( Customer_Account__r.CRState__c LIKE \'%'+stateorProvince+'%\' OR Customer_Account__r.State__c LIKE \'%'+stateorProvince+'%\' ) ';
        }
        cookieValue += ':: state : '+stateorProvince;
      }
  
      // City
      if(city != null && city != '') {
        city = String.escapeSingleQuotes(city);
        
        if(isUncoveredProspects) {
          whereClause = whereClause +' AND ( CRCity__c LIKE \'%'+city+'%\' OR City__c LIKE \'%'+city+'%\' ) ';
        }
        else {
          whereClause = whereClause +' AND ( Customer_Account__r.CRCity__c LIKE \'%'+city+'%\' OR Customer_Account__r.City__c LIKE \'%'+city+'%\' ) ';
        }
        cookieValue += ':: city : '+city;
      }
      
      // Create TP filter cookie
      prmFilterUtility.createFilterCookie('tp',cookieValue);
      
      q_where = whereClause;    
    
      clearmyPg();
      myPg.isUnCoveredView = isUncoveredProspects;
      
      if(pageRecords != null) {
        pageRecords.clear();
      }
      //pageRecords = new prmPagenationUtility.WrapperList();
      pageRecords =  myPg.getTPPageRecords();
      System.debug(System.LoggingLevel.INFO,'>>> pageRecords : '+pageRecords);
    }
    catch(System.QueryException queryEx) {
      System.debug(System.LoggingLevel.ERROR, '############## Exception ############ '+queryEx.getMessage());
      ApexPages.addMessages(queryEx);
    }
    catch( SearchException serEx) {
      System.debug(System.LoggingLevel.ERROR, '############## Exception ############ '+serEx.getMessage());
      ApexPages.addMessages(serEx);
    }
    catch(Exception ex) {
      System.debug(System.LoggingLevel.ERROR, '############## Exception ############ '+ex.getMessage());
      Apexpages.addMessages(ex);
    }

    System.debug(System.LoggingLevel.INFO,'$$$$$$$$$$$$$$$$$$$$$$$$$ End of TP doSearch $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
    //return whereClause;
  }

  public prmPagenationUtility myPg { get; set; }
  
  private void clearmyPg() {
    if(isUncoveredProspects) {
      if(myPg == null) {
        myPg = new prmPagenationUtility(q_finalQuery,q_limit);
      }
      else {
        myPg.queryStr1 = q_finalQuery;        
        myPg.clearPageRecords();
      }
      myPg.isUnCoveredView = true;
      return;
    }
    String wh1;
    String wh2;
    String o1;
    String o2;
    String q1;
    String q2;
    
    wh1 = q_where;
    wh2 = q_where;
    o1 = q_orderBy;
    o2 = q_orderBy;
    
    wh1 += ' AND ( Expiration_Date__c <= NEXT_N_DAYS:7 AND Expiration_Date__c >= TODAY ) ';
    o1 = ' ORDER BY Expiration_Date__c ASC NULLS FIRST ';
    q_where= null;
    q_orderBy = null;
    q_finalQuery = null;
    q_where = wh1;
    q_orderBy = o1;
    q1 = q_finalQuery;
    System.debug(System.LoggingLevel.INFO,'$$&& Query 1 : '+q1);
    
    wh2 += ' AND ( Expiration_Date__c = null OR Expiration_Date__c < TODAY OR Expiration_Date__c > NEXT_N_DAYS:7 ) ';
    q_where = null;
    q_orderBy = null;
    q_finalQuery = null;
    q_where = wh2;
    q_orderBy = o2;
    q2 = q_finalQuery;
    System.debug(System.LoggingLevel.INFO,'$$&& Query 2 : '+q2);
    if(myPg == null) {
      myPg = new prmPagenationUtility(q1,q2,q_limit);
    }
    else {
      myPg.queryStr1 = q1;
      myPg.queryStr2 = q2;
      
      myPg.clearPageRecords();
    }
    myPg.isUnCoveredView = false;
  }
  
  public Boolean isPA {
    get {
      return (prmFilterUtility.isPA);
    }
  }
  
  transient Component.Apex.SelectList viewList;
  
  public void setViewList(Component.Apex.SelectList value) {
    if(value != null) {
      viewList = value;
    }
  }
  
  
  public Component.Apex.SelectList getViewListComponent() {
    if(viewList == null) {
      viewList = new Component.Apex.SelectList();
      try {
        
        viewList = prmFilterUtility.getViewListComponent('TP');
      }
      catch(Exception ex) {
        System.debug(System.LoggingLevel.ERROR, '############## Exception ############ '+ex.getMessage());
        Apexpages.addMessages(ex);
      }
    }
    return viewList;
  }
  
  
  public PageReference openWorkProspectPage() {
  
    // Get Selected Account Id
    Id accountId;
    System.debug(System.LoggingLevel.INFO,'>>>>> getPageRecords() :'+getPageRecords());
    for(prmPagenationUtility.WrapperList rec : getPageRecords()) {
      if(rec.isSelected) {
        accountId = rec.acc.Id;
        break;
      }
    }
    if(accountId != null) {
      PageReference pg = new PageReference('/apex/SCP_Communities_WorkProspects');
      // To perforcem client side redirect and flush the view state
      pg.setRedirect(true);
      
      // Set accountId into Id parameter 
      pg.getParameters().put('Id',accountId);
      
      // Set return url
      string retURL = '/apex/SCP_Communities_targetProspectFilter';
      pg.getParameters().put('retURL',retURL);
      
      return pg;
    }
    return null;
  }
  
  public void checkForExistingCookie() {
    System.debug(System.LoggingLevel.INFO,'$$$$$$$$$$$$$$$$$$$$$$$$$ INSIDE TP checkingForExistingCookie $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
    
    selectedTagetArchitecture = new List<String>();

    ciscoRecommendedPSR = '';

    selectedIndustry = new List<string>();

    selectedTechnology = '';

    selectedCountry = new List<string>();
    String cvalue = prmFilterUtility.retriveFilterCookie('tp');    

    if(cvalue != null  && cvalue != '' ) {
      List<String> fieldValueList = cvalue.split('::');
      String fname,fvalue;

      for(String str : fieldValueList ) {
        fname = str.split(':')[0] != null ? str.split(':')[0].trim() : '';
        fvalue = str.split(':')[1] != null ? str.split(':')[1].trim() : '';

        if(fname != null && fname.equalsIgnoreCase('view')) {
          selectedView = fvalue;
        }
        if(fname != null && fname.equalsIgnoreCase('marketingplayname')) {
          marketingPlay = fvalue;
        }
        else if(fname != null && fname.equalsIgnoreCase('customerName')) {
          customername = fvalue;
        }
        else if(fname != null && fname.equalsIgnoreCase('targetarchitecture')) {
          selectedTagetArchitecture = prmFilterUtility.convertToMultiselectPickList(fvalue);
        }
        else if(fname != null && fname.equalsIgnoreCase('ciscoRecommendedPSR')) {
          ciscoRecommendedPSR = fvalue;
        }
        else if(fname != null && fname.equalsIgnoreCase('industry')) {
          selectedIndustry = prmFilterUtility.convertToMultiselectPickList(fvalue);
        }
        else if(fname != null && fname.equalsIgnoreCase('technology')) {
          selectedTechnology = fvalue;
        }
        else if(fname != null && fname.equalsIgnoreCase('country')) {
          selectedCountry = prmFilterUtility.convertToMultiselectPickList(fvalue);
        }
        else if(fname != null && fname.equalsIgnoreCase('state')) {
          stateorProvince = fvalue;
        }
        else if(fname != null && fname.equalsIgnoreCase('city')) {
          city = fvalue;
        }
      }
    }
    else {
      System.debug('### Cookie is null');
    }
    System.debug(System.LoggingLevel.INFO,'$$$$$$$$$$$$$$$$$$$$$$$$$ End of TP Checking for Existing Cookie $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
  }
  
  public void clearFields() {
    prmFilterUtility.removeFilterCookie('lead');
    pageRecords = new List<prmPagenationUtility.WrapperList>();
    q_select = null;
    q_from = null;
    q_where = null;
    q_orderBy = null;
    q_offset = null;
    q_limit = null;
    q_finalQuery = null;
  


    customerName = '';

    selectedTagetArchitecture = new List<String>();

    ciscoRecommendedPSR = '';

    selectedIndustry = new List<string>();

    selectedTechnology = '';

    selectedCountry = new List<string>();

    stateorProvince = '';
    city = '';

    marketingPlay = 'All';

    selectedView = viewOptions[0].getValue();
    isNewlyAssignedProspect = true;
    //getViewbyFilter();
    clearmyPg();
    initlize();
    
  }
  
  /* public String getDateFormat(){
        String dtFormat =null;
        String usrLocale = prmFilterUtility.logUser.LocaleSidKey;
        system.debug('userLocale'+usrLocale);
        SCP_Communities_locale_dateformat__c rec = new SCP_Communities_locale_dateformat__c();
        rec = [select Dateformat__c from SCP_Communities_locale_dateformat__c where name=:usrLocale LIMIT 1];
     //    rec = [select Dateformat__c from SCP_Communities_locale_dateformat__c where name='en_US' LIMIT 1];
        if(rec!=null && rec.Dateformat__c!=null)
            dtFormat = rec.Dateformat__c;
        else
            dtFormat = 'en_US';
        
        return dtFormat;
    }
    
       public String getUserDetails(){
      
      if(prmFilterUtility.isPA)
            return 'PA';
        else
            return 'PSR';
       }
  */
}