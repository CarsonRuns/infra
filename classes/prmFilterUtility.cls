public with sharing class prmFilterUtility {

    public static user logUser {
        // Modified By: Sudi 17 Oct 2014 
        // Release : November Sprint 3 ,
        // User Story : US7054
        // We added extra fields to account select query to get account type
        get {
            if (logUser == null) {
                logUser = [Select Id, User.LocaleSidKey, UserRole.Name, LanguageLocaleKey, Contact.Partner_Admin_Roles__c, Contact.AccountId, Contact.Account.Type, Contact.Account.Name, Contact.Account.PDB_BE_GEO_ID__c, Contact.CCO_ID__c, Contact.Account.ParentId FROM User Where id = : userinfo.getUserId()];
            }            
            return logUser;
        }
        set;
    }
    public static Map<String, User_Preference__c> viewPreferenceMap {
        get {
            if(viewPreferenceMap == null) {
                viewPreferenceMap = new Map<String,User_Preference__c >();
                try {
                    for(User_Preference__c p : [select id, View_Id__c, User__c, Selected_column_order__c,
                                            Lead_Available_Fields__c,Columns_Sort_Order__c 
                                            from User_Preference__c 
                                            where User__c=:userinfo.getUserId() AND
                                            View_Id__c != null 
                                            order by View_Id__c]) {
                        viewPreferenceMap.put(p.View_Id__c, p);
                    }
                    
                } 
                catch(Exception sqlEx) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'No View Settings found!'));
                }
            }
            return viewPreferenceMap;   
        }
        set;
    }
    
    public static User_Preference__c logUserPreference{
        get{
               if (logUserPreference == null) {
                    list<User_Preference__c> lstData = [select id, User__c,Selected_column_order__c,Lead_Available_Fields__c,Columns_Sort_Order__c from User_Preference__c where User__c=:userinfo.getUserId()];
                    logUserPreference = (!lstData.isEmpty()) ? lstData[0]:null;
                }
                System.debug('*************** getlogUserPreference **************************');
                System.debug(logUserPreference);                
                return logUserPreference; 
           }
        set{ 
            System.debug('*************** setlogUserPreference **************************');
            System.debug(value);                
            logUserPreference = value;}
    }

    public static string loggedInUserGadgetLanguage {
        get {
            if (loggedInUserGadgetLanguage == null) {
                if (SCP_Communities_languageMap__c.getInstance(logUser.LanguageLocaleKey).Value__c != null) {
                    loggedInUserGadgetLanguage = SCP_Communities_languageMap__c.getInstance(logUser.LanguageLocaleKey).Value__c;
                } else {
                    loggedInUserGadgetLanguage = logUser.LanguageLocaleKey;
                }
            }
            return loggedInUserGadgetLanguage;
        }
        set;
    }

    public static Boolean isEnglish {
        get {
            return (logUser.LanguageLocaleKey == 'en_US');
        }

    }

    // Below method returns Channel Account
    public static string loggedInUserPartnerAccount {
        get {
            if (loggedInUserPartnerAccount == null) {
                loggedInUserPartnerAccount = logUser.Contact.AccountId;
            }
            return (loggedInUserPartnerAccount == null ? '' : loggedInUserPartnerAccount);
        }
        set;
    }
    // Below variable returns logedin users Channal Account Name
    public static string loggedInUserPartnerAccountName {
        get {
            if (loggedInUserPartnerAccountName == null) {
                loggedInUserPartnerAccountName = logUser.Contact.Account.Name;
            }
            return (loggedInUserPartnerAccountName == null ? '' : loggedInUserPartnerAccountName);
        }
        set;
    }
    // Modified By: Sudi 17 Oct 2014 
    // Release : November Sprint 3 ,
    // User Story : US7054
    // Below variable is used to find the login user is Distributor or partner.
    public static string loggedInUserIsDisti {
        get {
            if (loggedInUserIsDisti == null) {
                loggedInUserIsDisti = logUser.Contact.Account.Type;
            }
            return (loggedInUserIsDisti == null ? '' : loggedInUserIsDisti);
        }
        set;
    }

    public static String getCCOID() {
        return (String)(logUser.Contact.CCO_ID__c);
    }

    public static String getLangkey() {
        return (String)(logUser.LanguageLocaleKey);
    }

    // List<String> to hold view drop down values
    public static List < String > getviewList() {
        List < String > viewList = new List < String > ();
        for (SCP_Communities_listviews__c rec: filterviews) {
            if (rec.objecttype__c.equalsIgnoreCase('Lead')) {
                viewList.add(rec.Id);
            }
        }
        return viewList;
    }

    public static List < SCP_Communities_listviews__c > filterviews {
        get {
            if (filterviews == null) {
                filterviews = new List < SCP_Communities_listviews__c > ([select id, name, psr_status__c, pa_status__c, Order__c,
                   objecttype__c, Custom_Label__c from SCP_Communities_listviews__c
                   ORDER By ObjectType__c ASC, Order__c ASC]);
            }                        

            lead_statusMap = new Map < String, String > ();            

            integer papsr = isPA ? 1 : (isPSR ? 2 : 3);            

            for (SCP_Communities_listviews__c vrec: filterviews) {

                if (vrec.objecttype__c.equalsIgnoreCase('Lead')) {
                    if (papsr == 1) { // for PA
                        lead_statusMap.put(vrec.Id, vrec.PA_Status__c);
                    } else if (papsr == 2) { // for PSR
                        lead_statusMap.put(vrec.Id, vrec.PSR_Status__c);
                    }
                }                
            }                        
            return filterviews;
        }
        set;
    }

    public static Map <ID, SCP_Communities_listviews__c > scpListViewsMapById {
        get {
            Map<Id, SCP_Communities_listviews__c> scpListViewsMapById = new Map<Id,SCP_Communities_listviews__c>(); 
            for (SCP_Communities_listviews__c vrec: filterviews) {
                scpListViewsMapById.put(vrec.Id, vrec);
            }
            return scpListViewsMapById;
        }
        set;
    }

    public static void refreshFilterviews() {
        List < SCP_Communities_Listviews__c > views = filterviews;
    }

    public static string getMultiPickSelectedValue(List < String > value) {
        string returnVal = '(';
        if (value != null) {
            for (string val: value) {
                if (val.equalsIgnoreCase('All')) {
                    return ('All');
                }
                returnVal = returnVal + '\'' + val + '\',';
            }
            if (returnVal != '(') {
                returnVal = returnVal.substring(0, (returnVal.length() - 1));
                returnVal = returnVal + ')';
                return (returnVal);
            }
        }

        return 'All';
    }
    public static Set < ID > adminProfileIdSet {
        get {
            if (adminProfileIdSet == null || adminProfileIdSet.isEmpty()) {
                adminProfileIdSet = new Set < Id > ();

                for (SCP_Communities_adminprofiles__c rec: [Select Id, Profile_ID__c From SCP_Communities_adminprofiles__c]) {
                    adminProfileIdSet.add(rec.Profile_ID__c);
                }
            }
            return adminProfileIdSet;
        }
        set;
    }

    public static boolean isPA {
        get {

            if (adminProfileIdSet.contains(userInfo.getProfileId())) {
                return true;
            }
            isPA = false;
            // Check if current user role end's Partner Executive
            string roleName = logUser.UserRole.Name;
            string partnerAdminRoles = logUser.Contact.Partner_Admin_Roles__c;
            if (roleName != null && roleName.endsWith('Partner Executive')) {
                // Check if current user contact's Patner Admin Role contains "PARTNER_LED_APP_ADMIN" & "PARTNER_LED_APP_USER"
                if (partnerAdminRoles != null && partnerAdminRoles.contains('PARTNER_LED_APP_ADMIN') /* && partnerAdminRoles.contains('PARTNER_LED_APP_USER')*/ ) {
                    isPA = true;
                }
            }

            return isPA;
        }
        set;
    }


    public static boolean isPSR {
        get {
            isPSR = false;
            // Check if current user role end's Partner User
            string roleName = logUser.UserRole.Name;
            string partnerAdminRoles = logUser.Contact.Partner_Admin_Roles__c;
            if (roleName != null && roleName.endsWith('Partner User')) {
                // Check if current user contact's Patner Admin Role contains  "PARTNER_LED_APP_USER" but not "PARTNER_LED_APP_ADMIN"
                if (partnerAdminRoles != null && partnerAdminRoles.contains('PARTNER_LED_APP_USER') && !partnerAdminRoles.contains('PARTNER_LED_APP_ADMIN')) {
                    isPSR = true;
                }
            }
            return isPSR;
        }
        set;
    }

    public static boolean isAdmin {
        get {

            return (adminProfileIdSet.contains(userinfo.getProfileId()));
        }
    }



    // Has map for pa for tp's for Leads
    public static Map < String, string > lead_statusMap {
        get {
            if (lead_statusMap == null) {
                lead_statusMap = new Map < String, String > ();
                refreshFilterviews();
            }
            return lead_statusMap;
        }
        set;
    }

    // Has map for pa for tp's for TP
    public static Map < String, String > tp_statusMap {
        get;
        set;
    }

    public static Map < String, String > gettp_statusMap() {

        System.debug(System.LoggingLevel.INFO, '### Inside getter TP StatusMap : TIme ' + DateTime.now() + ' map : ' + tp_statusMap);

        if (tp_statusMap == null || tp_statusMap.isEmpty()) {
            tp_statusMap = new Map < String, String > ();
            //refreshFilterviews();
            integer papsr = isPA ? 1 : (isPSR ? 2 : 3);            

            for (SCP_Communities_listviews__c vrec: filterviews) {

                if (vRec.ObjectType__c.equalsIgnoreCase('TP')) {
                    if (papsr == 1) { // for PA
                        tp_statusMap.put(vrec.Id, vrec.PA_Status__c);
                    } else if (papsr == 2) { // for PSR
                        tp_statusMap.put(vrec.Id, vrec.PSR_Status__c);
                    }
                }

            }
        }
        System.debug(System.LoggingLevel.INFO, '### tp_statusMap before return getter : ' + tp_statusMap);
        return tp_statusMap;
    }




    public static string whereClauseforView(string objName, string selectedView) {
        string str = ' ( ';
        if (objName == 'tp') {
            System.debug(System.LoggingLevel.INFO, '### tp_statusMap whereclauseforview  : ' + gettp_statusMap().get(selectedView));
            if (selectedView != null && gettp_statusMap() != null && gettp_statusMap().get(selectedView) != null) {
                for (string s: gettp_statusMap().get(selectedView).split(',')) {
                    str = str + '\'' + s.trim() + '\',';

                }
                if (str != ' ( ') {
                    str = str.substring(0, (str.length() - 1));
                    str = str + ' ) ';
                    return str;
                }
            }
        } else {
            System.debug(System.LoggingLevel.INFO, '##selectedView ## '+selectedView +' *** Inside whereclauseforview : ' + lead_statusMap + ' lead_statusMap.get(selectedView) ' + lead_statusMap.get(selectedView));            
            Map<string, string> mapVal = new  Map<string, string>();
            if(selectedView.length() == 15){                
                for(string strVal : lead_statusMap.keySet()){
                    mapVal.put(strVal.substring(0,15), lead_statusMap.get(strVal));             
                }
                if (selectedView != null && lead_statusMap != null && mapVal.get(selectedView) != null) {
                    for (string s: mapVal.get(selectedView).split(',')) {
                        str = str + '\'' + s + '\',';
                    }
                    if (str != ' ( ') {
                        str = str.substring(0, (str.length() - 1));
                        str = str + ' ) ';                    
                        return str;
                    }
                }
            }else{
                if (selectedView != null && lead_statusMap != null && lead_statusMap.get(selectedView) != null) {
                    for (string s: lead_statusMap.get(selectedView).split(',')) {
                        str = str + '\'' + s + '\',';
                    }
                    if (str != ' ( ') {
                        str = str.substring(0, (str.length() - 1));
                        str = str + ' ) ';                    
                        return str;
                    }
                }
            }
        }
        return 'All';
    }

    public static String whereClauseforViewForStringSelectedView(String selctedViewName) {
        string str = ' ( ';

        if (selctedViewName != null) {

            SCP_Communities_listviews__c viewRec = SCP_Communities_listviews__c.getValues(selctedViewName);

            String statusValues;

            if (isPA && viewRec != null) {
                statusValues = viewRec.PA_Status__c;
            } else if (isPSR && viewRec != null) {
                statusValues = viewRec.PSR_Status__c;
            }

            if (statusValues != null) {

                for (string s: statusValues.split(',')) {
                    str = str + '\'' + s.trim() + '\',';
                }

                if (str != ' ( ') {
                    str = str.substring(0, (str.length() - 1));
                    str = str + ' ) ';
                    return str;
                }
            }
        }

        return 'All';
    }


    public static string whereClauseforTPTechnology(string technology, Boolean isUncoveredProspect) {
        string str = '';
        if (technology != null) {
            if (technology.equalsIgnoreCase('Collab Applications')) {
                if (isUncoveredProspect) {
                    str = '( Wallet_Collab_Applications__c != null  AND  Expected_Bookings_Collab_App_000__c != null )';
                } else {
                    str = '( Customer_Account__r.Wallet_Collab_Applications__c != null  AND  Customer_Account__r.Expected_Bookings_Collab_App_000__c != null )';
                }

                return str;
            }
            if (technology.equalsIgnoreCase('Collab Voice')) {
                if (isUncoveredProspect) {
                    str = '( Wallet_Unified_Communications_000__c != null  AND  Expected_Bookings_Collab_Voice_000__c != null )';
                } else {
                    str = '( Customer_Account__r.Wallet_Unified_Communications_000__c != null  AND  Customer_Account__r.Expected_Bookings_Collab_Voice_000__c != null )';
                }
                return str;
            }
            if (technology.equalsIgnoreCase('DataCenter UCS')) {
                if (isUncoveredProspect) {
                    str = '( Wallet_Data_Center_UCS_000__c != null  AND  Expected_Bookings_Data_Center_UCS_000__c != null )';
                } else {
                    str = '( Customer_Account__r.Wallet_Data_Center_UCS_000__c != null  AND  Customer_Account__r.Expected_Bookings_Data_Center_UCS_000__c != null )';
                }
                return str;
            }
            if (technology.equalsIgnoreCase('Other')) {
                if (isUncoveredProspect) {
                    str = '( Wallet_Other_000__c != null  AND  Expected_Booking_Other__c != null )';
                } else {
                    str = '( Customer_Account__r.Wallet_Other_000__c != null  AND  Customer_Account__r.Expected_Booking_Other__c != null )';
                }
                return str;
            }
            if (technology.equalsIgnoreCase('Routing')) {
                if (isUncoveredProspect) {
                    str = '( Wallet_Routing_000__c != null  AND  Expected_Bookings_Routing_000__c != null )';
                } else {
                    str = '( Customer_Account__r.Wallet_Routing_000__c != null  AND  Customer_Account__r.Expected_Bookings_Routing_000__c != null )';
                }
                return str;
            }
            if (technology.equalsIgnoreCase('Security')) {
                if (isUncoveredProspect) {
                    str = '( Wallet_Security_000__c != null  AND  Expected_Bookings_Security_000__c != null )';
                } else {
                    str = '( Customer_Account__r.Wallet_Security_000__c != null  AND  Customer_Account__r.Expected_Bookings_Security_000__c != null )';
                }
                return str;
            }
            if (technology.equalsIgnoreCase('Services')) {
                if (isUncoveredProspect) {
                    str = '( Wallet_Services_000__c != null  AND  Expected_Bookings_Services_000__c != null )';
                } else {
                    str = '( Customer_Account__r.Wallet_Services_000__c != null  AND  Customer_Account__r.Expected_Bookings_Services_000__c != null )';
                }
                return str;
            }
            if (technology.equalsIgnoreCase('Switching')) {
                if (isUncoveredProspect) {
                    str = '( Wallet_Switching_000__c != null  AND  Expected_Bookings_Switching_000__c != null )';
                } else {
                    str = '( Customer_Account__r.Wallet_Switching_000__c != null  AND  Customer_Account__r.Expected_Bookings_Switching_000__c != null )';
                }

                return str;
            }
            if (technology.equalsIgnoreCase('Telepresence')) {
                if (isUncoveredProspect) {
                    str = '( Wallet_Video_000__c != null  AND  Expected_Bookings_Telepresence_000__c != null )';
                } else {
                    str = '( Customer_Account__r.Wallet_Video_000__c != null  AND  Customer_Account__r.Expected_Bookings_Telepresence_000__c != null )';
                }
                return str;
            }
            if (technology.equalsIgnoreCase('Wirless')) {
                if (isUncoveredProspect) {
                    str = '( Wallet_Wireless_000__c != null  AND  Expected_Bookings_Wireless_000__c != null )';
                } else {
                    str = '( Customer_Account__r.Wallet_Wireless_000__c != null  AND  Customer_Account__r.Expected_Bookings_Wireless_000__c != null )';
                }
                return str;
            }

        }
        return str;
    }

    public static Component.Apex.SelectList getViewListComponent(String objectType) {


        Component.Apex.SelectList viewList = new Component.Apex.SelectList();
        viewList.Id = 'viewList';
        viewList.styleClass = 'view_list_class dataCol uiMultiSelectMain';
        viewList.expressions.value = '{!selectedView}';
        viewList.size = 1;

        // Creating action support
        Set < String > rerenderSet = new Set < String > ();


        if (objectType == 'TP') {                        
            rerenderSet.add('pg1');                                    
        } else {
           rerenderSet.add('block1');
        }        
        Component.Apex.ActionSupport actionSpt = new Component.Apex.ActionSupport();
        actionSpt.event = 'onchange';
        actionSpt.expressions.action = '{!doSearch}';        
        actionSpt.status = 'searching';       

        // Creating select options child
        Component.Apex.SelectOption selOption = new Component.Apex.SelectOption();

        for (SCP_Communities_listviews__c lrec: prmFilterUtility.filterviews) {

            if (lrec.ObjectType__c.equalsIgnoreCase(objectType)) {               
                selOption = new Component.Apex.SelectOption();
                selOption.itemValue = lrec.Id;
                selOption.expressions.itemLabel = '{!$Label.' + lrec.Custom_Label__c + '}';
                viewList.childComponents.add(selOption);
            }
        }
        Component.Apex.SelectOptions so = new Component.Apex.SelectOptions();
        so.expressions.value = '{!viewOptions}';

        // Adding child components
        viewList.childComponents.add(actionSpt);
        return viewList;
    }


    public String currentUserParentAccountId;

    /**
     * @description Retrieved the parent account id of running user
     *
     * @param N/A
     *
     * @return The parent account id of running user
     */
    public Id getCurrentUserParentAccountId() {
        
        if (currentUserParentAccountId == null) {
            currentUserParentAccountId = logUser.Contact.Account.ParentId;
            if (currentUserParentAccountId == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Current User does not have associated Parent Account!'));
            }
        }
        return (currentUserParentAccountId);
    }

    /**
     * @description Helper method to get a list of visible users for the running Partner Admin user
     *
     * @param userFields List of user fields to retrieve
     * @param whereClause Additional where clause to append to query
     * @param orderBy Order by clause to append to query.  String must start with 'Order by'
     * @param queryLimit Limit to append to query
     *
     * @return the calculated budget
     */
    public List < User > getUserList(
        List < string > userFields,
        String whereClause,
        String orderBy, Integer queryLimit) {        
        String userQuery = 'Select ';

        for (String field: userFields) {
            userQuery += field + ', ';
        }
        userQuery = userQuery.substring(0, userQuery.length() - 2);


        userQuery += ' from User Where isActive = true ';
        String parentId = null;

        if (getCurrentUserParentAccountId() != null) {
            parentId = (String) getCurrentUserParentAccountId();
        }

        String addedAccountParentClause = parentId != null && parentId.length() > 0 ? ' AND Contact.Account.ParentId = \'' + parentId + '\' ' : ' ';
        String addedWhereClause = (whereClause != null && whereClause.length() > 0 ? ' and ' + whereClause : ' ');
        String addedOrderBy = (orderBy != null && orderBy.length() > 0 ? ' ' + orderBy : ' ');
        String addedLimit = (queryLimit != null && queryLimit > 0 ? ' Limit ' + queryLimit : ' ');
        userQuery += addedAccountParentClause + ' ' + addedWhereClause + ' ' + addedOrderBy + ' ' + addedLimit;
        
        System.debug(userQUery);

        return (List < User > ) Database.query(userQUery);
    }

    /**
     * @description Helper method to check if current user is patner user or not
     *
     * @return -1 if not patner user else 1 for patner user
     */
    public static Integer checkPatnerUser() {
        String runningUserProfileId = UserInfo.getProfileId().substring(0, 15);
        String partnerProfileId = '00e800000011h7J'; //ProfileID__c.getInstance().Partner360_Portal_Profile__c.substring(0,15);
        System.debug(System.LoggingLevel.INFO, '=====partnerProfileId : ' + partnerProfileId + ' === runningUserProfileId  : ' + runningUserProfileId + ' comp : ' + (runningUserProfileId.equals(partnerProfileId)) + '===========');
        if (!runningUserProfileId.equals(partnerProfileId)) {
            return -1;
        }
        return 1;
    }

    /* @ Description     : Static method to create cookie for leads, tp and dashboard pages
     *                       to preserve the filter while navigating accross different pages
     * @ Defect      : DE5364
     * @ User Story  :
     * @ Param           : objecttype -> name of the filter page
     *                     cookieValue -> cookie value
     */

    public static void createFilterCookie(String objecttype, String cookieValue) {
        string sessionId = userinfo.getSessionId();
        System.debug(System.LoggingLevel.INFO, '$4$ sessionId : ' + sessionId);
        String cname = 'filter' + sessionId + objecttype;
        String cvalue = EncodingUtil.urlEncode(cookieValue, 'UTF-8');        
        Cookie filterCookie = new Cookie(cname, cvalue, null, -1, false);
        ApexPages.currentpage().setCookies(new Cookie[] {
            filterCookie
        });        

    }

    /* @ Description     : Static method to retrieve cookie for leads, tp and dashboard pages
     *                       to preserve the filter while navigating accross different pages
     * @ Defect      : DE5364
     * @ User Story  :
     * @ Param           : objecttype -> name of the filter page
     * @ returns        : cookieValue -> cookie value
     */

    public static string retriveFilterCookie(string objectType) {
        String sessionId = userinfo.getSessionId();
        System.debug(System.LoggingLevel.INFO, '$4$ sessionId : ' + sessionId);
        string cname = 'filter' + sessionId + objectType;
        string cvalue;
        Cookie filterCookie = ApexPages.currentPage().getCookies().get(cname);
        System.debug(System.LoggingLevel.INFO, '4$4 Cname : ' + cname);
        System.debug(System.LoggingLevel.INFO, '$4$ All Cookies' + ApexPages.currentPage().getCookies());
        if (filterCookie != null) {
            cvalue = filterCookie.getValue();            
            cvalue = EncodingUtil.urlDecode(cvalue, 'UTF-8');            
            return cvalue;
        }
        return null;
    }

    /* @ Description     : Static method to convert string formed from multiselect picklist to
     *                       picklist
     * @ Defect      : DE5364
     * @ User Story  :
     * @ Param           : value -> string formed form multiselect picklist for filtering
     * @ returns        : List<Strin> -> List of String contining selected values
     */
    public static List < String > convertToMultiselectPickList(String value) {

        List < String > returnList = new List < String > ();
        value = value.replace('(', '').replace(')', '').trim();

        for (String s: value.split(',')) {
            s = s.replace('\'', '').trim();
            returnList.add(s);
        }


        return returnList;
    }

    public static void removeFilterCookie(string objectType) {
        string sessionId = userinfo.getSessionId();
        System.debug(System.LoggingLevel.INFO, '$4$ sessionId : ' + sessionId);
        String cname = 'filter' + sessionId + objectType;
        Cookie blankCookie = new Cookie(cname, '', null, -1, false);
        ApexPages.currentpage().setCookies(new Cookie[] {
            blankCookie
        });

    }

    public static String loggedInUsersAccounts {
        get {
            if (loggedInUsersAccounts == null) {
                loggedInUsersAccounts = '(';

                for (Account a: [Select Id From Account LIMIT 250]) {
                    System.debug(System.LoggingLevel.INFO, ' @@@ a.Id :' + a.Id);
                    loggedInUsersAccounts += ' \'' + a.Id + '\', ';
                }
                if (loggedInUsersAccounts.equalsIgnoreCase('(')) {
                    return null;
                }
                loggedInUsersAccounts = loggedInUsersAccounts.substring(0, (loggedInUsersAccounts.length() - 2));
                loggedInUsersAccounts += ') ';
            }
            System.debug(System.LoggingLevel.INFO, '### loggedInUsersAccount' + loggedInUsersAccounts);

            return loggedInUsersAccounts;
        }
        set;
    }
    public static string communityPrefix() {
        if (SCP_Communities_headerlinks__c.getInstance() != null)
            return SCP_Communities_headerlinks__c.getInstance().community_prefix__c;
        else
            return 'lp';
    }

    // Menthod to return date format based on login user local key
    /*public static String getDateFormat(){
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
    }*/

    // Method returns the postion array of dates in datatable
    // return string will contains integer position seprated by ","
    // params: pageType : Will have a string "Lead" or "TP"
    // params: selecctedView : will have selected view alias
    public static String getDatePosition(String pageType, String selectedView) {
        String position = '';

        // Get the view record from custom settings
        selectedView = String.escapeSingleQuotes(selectedView);
        SCP_Communities_listviews__c vrec = [Select Id, Name, View_Alias__c From SCP_Communities_listviews__c Where Id = : selectedView];

        // Page type is Lead then 
        if (pageType.equalsIgnoreCase('Lead')) {
            // for leads the view will be same for both PA and PSR
            // For My Converted Leads and My Rejected Leads 
            // ..date coulms index will be one less then other views

            if (vrec.View_Alias__c.equalsIgnoreCase('convertedleads') || vrec.View_Alias__c.equalsIgnoreCase('rejectedleads')) {
                position = '7,8';
            } else { // for all other views
                position = '8,9';
            }
        } else if (pageType.equalsIgnoreCase('TP')) { // If page type is TP
            // If view is "My Newly Assigned Prospects"
            // .. date index will change for PA and PSR
            // ..for all other views date index is same both for PA & PSR
            // if view is uncovered prospects we don't have any date fields
            if (vrec.View_Alias__c.equalsIgnoreCase('uncoveredprospects')) {
                return position;
            }
            if (vrec.View_Alias__c.equalsIgnoreCase('newprospects')) {
                if (isPA) {
                    position = '5,10';
                } else if (isPSR) {
                    position = '4,9';
                }
            }
            // for all other views
            else {
                position = '4,9';
            }

        }
        return position;
    }
    /**
     * @description Helper method to generate a CSV of lead/to Industry picklist list value based on
     * list of industry names passed into method.  Utilizes the Industry Map custom settings
     * SCP_Communities_industryMap__c to Map industry name to list of lead/tp industry picklist options
     *
     * @param industry List of strings fields containing name of industries
     *
     * @return empty string or CSV of lead/tp industry picklist options
     */
    public static String getMappedIndustries(List < String > industry) {
        System.debug(industry);
        String industries = '';
        Set < String > industrySet;

        if (industry != null && industry.size() > 0) {
            //Check if All exist in industry list
            industrySet = new Set < String > (industry);
            industries = industrySet.contains('All') ? 'All' : '';

            //All is not in industry list then continue processing
            if (!'All'.equals(industries)) {
                //Query the Industry Map custom settings for lead/tp industry
                String mappedIndustriesQuery = 'select mappedIndustries__c from SCP_Communities_industryMap__c where ';
                String industryIn = '';
                for (integer i = 0; i < industry.size(); i++) {
                    if (i != 0) {
                        industryIn += 'or ';
                    }
                    industryIn += 'name like \'' + industry[i] + '%\'';
                }
                mappedIndustriesQuery += industryIn;
                mappedIndustriesQuery += ' order by name';

                System.debug(mappedIndustriesQuery);

                List < SCP_Communities_industryMap__c > mappedIndustrieResultSet = (List < SCP_Communities_industryMap__c > ) Database.query(mappedIndustriesQuery);

                //Check there are results from industryMap query then create the csv lead/tp industry options
                if (mappedIndustrieResultSet.size() > 0) {
                    industries += '(';
                    for (integer j = 0; j < mappedIndustrieResultSet.size(); j++) {
                        if (j != 0) {
                            industries += ',';
                        }
                        industries += mappedIndustrieResultSet[j].mappedIndustries__c;
                    }
                    industries += ')';
                }
            }
        }

        return industries;
    }
    
    
    /*
    Added by saduvvur
    */
    public static Map < String, String > fieldValueLabelMap {
    get {
        
        if( fieldValueLabelMap == null ) {
            
            fieldValueLabelMap = new Map< String, String > ();
            
            Schema.DescribeFieldResult avalFields  = User_Preference__c.Lead_Available_Fields__c.getDescribe();
            
            for(Schema.Picklistentry sp : avalFields.getPicklistValues()) {
                
                fieldValueLabelMap.put(sp.value,sp.label);
                
            }
            
        }
        
        return fieldValueLabelMap;
        
    }
    set;
   }
}