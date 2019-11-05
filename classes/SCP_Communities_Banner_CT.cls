/*************** Change History ***************
 * @Modification History:
     * @Release: Sep-2015
     * @Author: bdabbara @Date:  9/8/2015
     * @Functionality: WR-01361 - Wrong TP Count displayed on LnP
    WR-01379 - Removed the Archive duration to the Lead count query.
    05/05/2015 - DE10499 - Changes done to fix the Lead Count for PA & PSR.
    US11655 - Updated the Lead Count to ensure the PA count includes the Leads for whom he/she is assigned as PSR.
        - Fixed VillageChief issues
/*************** Change History *************** */


global with sharing class SCP_Communities_Banner_CT {
    
    public integer tpCount { get; set; }
    public integer leadCount { get; set; }
    
    
    public SCP_Communities_Banner_CT() {
        createLangCookie();
    }
    public String output {
        get{
            if(output==null) {
                output='123';
            }
            return output; 
        }
        
        set; }
    public String message {
        get{
            if(message==null) {
                manipulateStr();
            }
            return message; 
        }
        
        set; }
    
    
    public integer leadmessage { 
        get {
            if(leadmessage == null) {
                leadCount();
            }            
            return leadmessage; 
        }
        
        set; }
    
    public integer tpmessage { 
        get {
            if(tpmessage == null) {
                tpCount();
            }
            return tpmessage;   
        }
        
        set; }
    
    
    
    
    public void manipulateStr(){        
        message = Label.PRM_BannerAlert;
        String ld = leadCount();
        String tp = tpCount();
        message = message.replaceFirst('\\{0\\}',ld);
        message = message.replaceFirst('\\{1\\}',tp); 
        // Get the base URL.
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        String leadUrl = sfdcBaseURL + '/'+prmFilterUtility.communityPrefix()+'/apex/SCP_communities_leadFilter_Clone?view=newleads';
        String tpUrl = sfdcBaseURL + '/'+ prmFilterUtility.communityPrefix()+ '/apex/SCP_Communities_targetProspectFilter?view=newprospects';
        message = message.replaceFirst('href =#','href ='+'\''+leadUrl+'\'');
        message = message.replaceFirst('href =#','href ='+'\''+tpUrl+'\'');
        
        if(ld!=null && !(ld.trim().equals('0')))
            message = message.replaceFirst('="_parent">','="_parent" class="simpleTooltip recfound" >' );
        else
            message = message.replaceFirst('="_parent">','="_parent" class="simpleTooltip norecfound" >' );
        
        
        if(tp!=null && !(tp.trim().equals('0')))
            message = message.replaceFirst('="_parent">','="_parent" class="simpleTooltip recfound" >' );
        else
            message = message.replaceFirst('="_parent">','="_parent" class="simpleTooltip norecfound" >' );
        
    }
    
    
    public String leadCount() {
        //Commented the code to fix the VillageChief exception - Unused local variable
        //Id userId = userInfo.getUserId();
        String ldcnt = null;
        // Get Lead Count
        String countQuery = ' SELECT COUNT() FROM Lead ';
        
        String selectedViewName = 'My Newly Assigned Leads';
        String whereClause = prmFilterUtility.whereClauseforViewForStringSelectedView(selectedViewName);
        
        if(whereClause != null ) {
            countQuery += ' WHERE Partner_Lead_Status__c IN '+whereClause;
        }            
        
        leadCount = Database.countQuery(countQuery);
        leadmessage = leadCount;        
        ldcnt = leadmessage+'';
        return ldcnt;
        
    }
    
    public String tpCount() {
        //Commented the code to fix the VillageChief exception - Unused local variable
        //Id userId = userInfo.getUserId();
        String tpcnt = null;
        //TP count
        //Commented the code to fix the VillageChief exception - Unused local variable
        //String accountId = prmFilterUtility.loggedInUserPartnerAccount;
        String q_where;
        String logUserAccounts = prmFilterUtility.loggedInUsersAccounts;
        System.debug(System.LoggingLevel.INFO,'#$ prmFilterUtility.loggedInUserAccounts : '+prmFilterUtility.loggedInUsersAccounts);
        if(logUserAccounts != null && logUserAccounts != '(') {
            System.debug(System.LoggingLevel.INFO, '### INSIDE NOT NULL ####');
            q_where = 'Where assignment_activated__c =true AND ( Customer_Account__c IN '+prmFilterUtility.loggedInUsersAccounts +' )';
        }
        else {
            System.debug(System.LoggingLevel.INFO, '### INSIDE  NULL ####');
            q_where = 'Where assignment_activated__c =true';
        }
        string countQuery = 'Select COUNT() FROM Assigned_Partner__c '+ q_where;
        
        String selctedViewName = 'My Newly Assigned Prospects';
        String whereClasue = prmFilterUtility.whereClauseforViewForStringSelectedView(selctedViewName);        
        if(whereClasue != null ) {
            countQuery += ' AND Partner_Status__c IN' +whereClasue;
        }                       
        tpCount = Database.countQuery(countQuery);        
        tpmessage = tpCount;
        tpcnt = tpmessage+'';
        return tpcnt;
        
    }
    
    
    
    public String createActivity(){
        String methodType = 'POST';
        
        Http h = new Http();
        
        HttpRequest req = new HttpRequest();
        
        req.setEndpoint('http://tools-dev.cisco.com/WWChannels/newpos/services/activities/createActivity');
        
        String bodyString='{"activityTitle": "Testing 123","message": "Testing123","type": "ALERT","source": "NULL","ccoId": "kimam","sourceType": "ONLINE","sourceAppId": "CPOS","sourceReferenceId": "Sub6582","userList": "NULL"}';
        
        req.setMethod(methodType);
        
        req.setHeader('Authorization','Basic '+'a2ltYW06Y3V0N2VWYWNhc3Nz');
        
        if (methodType == 'POST'){
            
            req.setHeader('Method', 'postAlert');
            
            req.setBody(bodyString); 
            
        } 
        
        
        
        // Send the request, and return a response 
        
        HttpResponse res = h.send(req);
        
        system.debug('CALLOUT RESPONSE ::' + res.getBody());
        
        output='567'+res.getBody();
        return output;
    }
    
    
    // Create cookie for laguage
    public void createLangCookie() {
      // Language key cookie
        String uLangKey = prmFilterUtility.getLangkey();
        Cookie langCookie = new Cookie('ulang',uLangKey,null,-1,false);
    // Account Role cookie
    String disti = prmFilterutility.loggedInUserIsDisti;
      System.debug(System.LoggingLevel.INFO,'Account Type : '+disti);
      Cookie accountTypeCookie = new Cookie('acctype',disti,null,-1,false);
      // Partner Name label cookie
      System.debug(System.LoggingLevel.INFO,'Partner Name Label : '+Label.PRM_Partner_Name);
      Cookie partnerName = new Cookie('partnername',Label.PRM_Partner_Name,null,-1,false);
        ApexPages.currentpage().setCookies(new Cookie []{langCookie,accountTypeCookie,partnerName});
        System.debug(System.LoggingLevel.INFO, '>>>>>>> Cookie creation Successfully ');
    }
    
     // Added by saduvvur
    @RemoteAction
   global static string messageString(){
       String messageStr = Label.PRM_BannerAlert;
        Id userId = userInfo.getUserId();
        String leadQuery, tpQuery, accIds,ld,tp;
        Integer leadCount, tpCount;
        // Get the archive duration days from Custom Setting
      LnP_Constants__c cs = LnP_Constants__c.getInstance();
      Integer archiveDays = Integer.valueOf(cs.Archive_Days__c);
        //WR-01379 - Added the Partner_Assigned_Date__c to query to match the count against Newly Assigned Leads view.
        //DE10499 - Added the filter ligic to whereClause based on the Partner User role
        //US11655 - Added the additional query parameter to get the PSR1 leads whom PA is assigned.
        if(prmFilterUtility.isPA){
        leadQuery = 'SELECT COUNT() FROM Lead Where (Partner_Lead_Status__c = \'Partner Assigned\' AND Partner_Assigned_Date__c = LAST_N_DAYS:'+archiveDays+') OR (Partner_Lead_Status__c = \'Assigned to PSR\' AND PSR_1__c = \''+userId+'\' AND Partner_Assigned_Date__c = LAST_N_DAYS: '+archiveDays+')';

        } else {
            leadQuery = 'SELECT COUNT() FROM Lead Where Partner_Lead_Status__c = \'Assigned To PSR\' AND PSR_Assigned_Date__c = LAST_N_DAYS:'+archiveDays;
        }
        
        tpQuery = 'Select COUNT() FROM Assigned_Partner__c Where assignment_activated__c =true AND Partner_Status__c = \'Partner Assigned\'';
        accIds = prmFilterUtility.loggedInUsersAccounts;
        if(accIds != null && accIds != '' && accIds != '(') {
          tpQuery += ' AND Customer_Account__c IN '+accIds;
        }
        leadCount = Database.CountQuery(leadQuery);

        tpCount = Database.CountQuery(tpQuery);
        
        ld = leadCount + '';
        // @WR-01361 - Fixed the TP could assignment.
        tp = tpCount + '';
       messageStr = messageStr.replaceFirst('\\{0\\}',ld);
       messageStr = messageStr.replaceFirst('\\{1\\}',tp);
       
       SCP_Communities_headerlinks__c headerLinks = SCP_Communities_headerlinks__c.getOrgDefaults();
       
       
       String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
    String leadUrl = sfdcBaseURL + '/' + prmFilterUtility.communityPrefix() + '/apex/' + headerLinks.Leads_Tab__c + '?view=newleads';
        String tpUrl = sfdcBaseURL + '/'+ prmFilterUtility.communityPrefix() + '/apex/' + headerLinks.Target_Prospects_Tab__c +'?view=newprospects';
        messageStr = messageStr.replaceFirst('href =#','href ='+'\''+leadUrl+'\'');
        messageStr = messageStr.replaceFirst('href =#','href ='+'\''+tpUrl+'\'');
        
        if(ld!=null && !(ld.trim().equals('0')))
            messageStr = messageStr.replaceFirst('="_parent">','="_parent" class="simpleTooltip recfound" >' );
        else
            messageStr = messageStr.replaceFirst('="_parent">','="_parent" class="simpleTooltip norecfound" >' );
        
        
        if(tp!=null && !(tp.trim().equals('0')))
            messageStr = messageStr.replaceFirst('="_parent">','="_parent" class="simpleTooltip recfound" >' );
        else
            messageStr = messageStr.replaceFirst('="_parent">','="_parent" class="simpleTooltip norecfound" >' );
        
       
       return messageStr;
   }
}