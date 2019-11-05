public with sharing class P360TxM_RM_DashboardCTE {
    
    public string strPartnerFilter;
    public String getstrPartnerFilter() {
        return this.strPartnerFilter;
    }
    public void setstrPartnerFilter(String search) {
        this.strPartnerFilter = search;
    }

  public PageReference cmdPartnerFilter() {

        strPartnerFilter = EncodingUtil.urlEncode(strPartnerFilter, 'UTF-8');
        urlsforDashboards();
        initDashboard();
        getChartData();
        getChartDataLead();
        return null;
    }


    public PageReference showAllFilter() {
        system.debug('Filtername' + selectedValue);
        urlsforDashboards();
        initDashboard();
        getChartData();
        getChartDataLead();
        return null;
    }


    public List < Assigned_Partner__c > lstTPExpiringTomorrow {get;set;}
    public List < Assigned_Partner__c > lstTPNotActivated {get;set;}
    public List < Assigned_Partner__c > lstTPExpiring {get;set;}
    public List < Lead > lstLeadWaiting {get;set;}
    public List < Lead > lstLeadReAssignment {get;set;}
    public List < Lead > lstLeadToDeal {get;set;}
    public List < SCP_Alerts__c > lstSCPAlert {get;set;}


    public integer TPExpiringTomorrow {get;set;}
    public integer TPWaitingToActivate {get;set;}
    public integer Lead1Waitings {get;set;}
    public integer LeadReassignment {get;set;}
    public integer LeadToDeal {get;set;}
    public integer TPExpiring2W {get;set;}
    public integer LeadPAToPSR {get;set;}
    public integer LeadWaitingPSR {get;set;}
    public integer TPsDeal {get;set;}
    public integer scpAlert {get;set;}

    public string selectedValue {get;set;}


    public static string strOwnerFilter = '';
    public static string strLeadsPartnerFilter = '';
    public static string strTPsPartnerFilter = '';
    public Id idTxM {get;set;}

    Datetime date5daysAgo = datetime.now() - 5;
    string strdate5daysAgo = date5daysAgo.format('MM/dd/yyyy');
    Datetime date4daysAgo = datetime.now() - 4;
    string strdate4daysAgo = date4daysAgo.format('MM/dd/yyyy');
    Datetime date14daysAhead = datetime.now() + 14;
    string strdate14daysAhead = date14daysAhead.format('MM/dd/yyyy');
    Datetime date1daysAhead = datetime.now() + 1;
    string strdate1daysAhead = date1daysAhead.format('MM/dd/yyyy');
    Datetime todaysDate = datetime.now();
    string strTodaysDate = todaysDate.format('MM/dd/yyyy');

    public List < SelectOption > getItems() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('My Leads and Target Prospects', 'My Leads and Target Prospects'));
        options.add(new SelectOption('All Leads and Target Prospects', 'All Leads and Target Prospects'));
        return options;
    }

    public Lead newlead {
        get;
        set;
    }
    public P360TxM_RM_DashboardCTE() {
        newlead = new Lead();
        selectedValue = 'My Leads and Target Prospects';
        P360TxMReportFilters__c filterValue = P360TxMReportFilters__c.getOrgDefaults();
        idTxM = '000000000000000AAA';
        urlLeadWaitingAssignment = filterValue.lvCSLeadWaitingAssignment__c;
        urlLeadWaitingReAssignment = filterValue.lvCSLeadWaitingReAssignment__c;
        urlLeadConvertedDeal5Days = filterValue.lvCSLeadConvertedDeal5Days__c;
        urlTPWaitingActivation = filterValue.lvCSTPWaitingActivation__c;
        urlTPExpiringTomorrow = filterValue.lvCSTPExpiringTomorrow__c;
        urlTPExpiringTwoWeeks = filterValue.lvCSTPExpiringTwoWeeks__c;
        urlLeadWaitingforPAfor4Days = filterValue.GenericLeadReport__c + filterValue.urlCSLeadWaitingforPAfor4Days__c + strdate4daysAgo + '&scope=user';
        urlLeadWaitingforPSRfor4Days = filterValue.GenericLeadReport__c + filterValue.urlCSLeadWaitingforPSRfor4Days__c + strdate4daysAgo + '&scope=user';
        urlTPDeals5Days = filterValue.TPDealReport__c + filterValue.urlCSTPDeals5Days__c + strdate5daysAgo + '&scope=user';
        urlTPChart = filterValue.TPChartReport__c  + '&scope=user';
        urlLeadChart = filterValue.LeadChartReport__c  + '&scope=user' ;
        urlPartnerWith10PlusPartnerAssigned  = filterValue.Lead10PlusPAReport__c + filterValue.urlLead10PlusPAReport__c + '&scope=user';
    }

    Public transient String leadQuery;
    Public transient String tpsQuery;


    public PageReference initDashboard() {
        String closedLeadRecordType = ObjectRecordTypeIds__c.getInstance().Closed_Lead_RecordTypeId__c;
        system.debug('idTxM' + idTxM);
        if (selectedValue == 'My Leads and Target Prospects') {
            strOwnerFilter = ' WHERE OwnerId =\'' + UserInfo.getUserId() + '\' AND ';
        } else {
            if (idTxM != '000000000000000AAA') {
                strOwnerFilter = ' WHERE OwnerId =\'' + idTxM + '\' AND ';
            } else {
                strOwnerFilter = ' WHERE';
            }
        }

        system.debug('strOwnerFilter ' + strOwnerFilter);

        if (newlead.Channel_Partner__c != Null) {
            strLeadsPartnerFilter = ' Channel_Partner__c =\'' + newlead.Channel_Partner__c + '\' AND';
            strTPsPartnerFilter = ' Assigned_Partner__c =\'' + newlead.Channel_Partner__c + '\' AND';
        }

        system.debug('strLeadsPartnerFilter ' + strLeadsPartnerFilter);
        system.debug('strTPsPartnerFilter ' + strTPsPartnerFilter);

        //Leads Waiting for Assignement
        leadQuery = 'SELECT ';
        for (Schema.FieldSetMember f: SObjectType.Lead.FieldSets.P360LeadTxMDashboardAlert.getFields()) {
            leadQuery += f.getFieldPath() + ', ';
        }
        leadQuery += 'Id, Name FROM Lead' + strOwnerFilter + strLeadsPartnerFilter;

        string leadQueryWaiting = leadQuery + ' Status = \'1 Waiting\' AND RecordTypeId !=\'' + closedLeadRecordType + '\' AND Lead_Qualified_Date__c = LAST_N_DAYS:120' +
                   'Order by Lead_Qualified_Date__c DESC';
        System.debug('leadQuery ' + leadQuery);
        List < Lead > lstLeads = Database.query(leadQueryWaiting);
        if(lstLeads.size()>1001)
        {
            Lead1Waitings =1001;
        }else{
            Lead1Waitings = lstLeads.size();
        }
        System.debug('Lead1Waitings ' + Lead1Waitings);
        System.debug('lstLeads' + lstLeads);
        if (Lead1Waitings != 0) {
            lstLeadWaiting = new List < Lead > ();

            for (integer i = 0; i < Lead1Waitings && i < 5; i++) {
                System.debug('lstLeads.............' + lstLeads.get(i));
                lstLeadWaiting.add(lstLeads.get(i));
            }
        }

        // TP Not Activated 
        tpsQuery = 'SELECT ';
        for (Schema.FieldSetMember f: SObjectType.Assigned_Partner__c.FieldSets.P360TPTxMDashboardAlert.getFields()) {
            tpsQuery += f.getFieldPath() + ', ';
        }
        
        tpsQuery += 'Id, Name FROM Assigned_Partner__c' + strOwnerFilter + strTPsPartnerFilter;
        System.debug('tpsQuery ' + tpsQuery);
        string tpsQueryNotAct = tpsQuery + ' Assignment_Activated__c =False AND Partner_Status__c = \'Assigned (New)\' AND CREATEDDATE = LAST_N_DAYS:120 Order by CreatedDate DESC';
        List < Assigned_Partner__c > lstNATPs = Database.query(tpsQueryNotAct);
        
        if(lstNATPs.size() > 1001)
        {
            TPWaitingToActivate = 1001;
        }else{
            TPWaitingToActivate = lstNATPs.size();
        }
        

        if (lstNATPs.size() != 0) {
            lstTPNotActivated = new List < Assigned_Partner__c > ();
            for (integer i = 0; i < 5 && i < TPWaitingToActivate; i++) {
                lstNATPs[i].Name = lstNATPs[i].Name.left(30)+'...';
                lstTPNotActivated.add(lstNATPs.get(i));
            }
        }


        leadQuery += ' ((Deal_Create_Date__c = LAST_N_DAYS:5 AND Partner_Lead_Status__c=\'Deal Created\' AND Deal_ID__c!=null) OR (RecordTypeId != \'' + 
                        closedLeadRecordType + '\' AND Partner_Lead_Status__c IN (\'Rejected-Not My Territory/Account\')) OR (RecordTypeId != \'' + closedLeadRecordType + '\' AND Partner_Lead_Status__c IN (\'Partner Assigned\',\'Assigned To PSR\') '+
                        'AND (Partner_Assigned_Date__c < LAST_N_DAYS:4 OR PSR_Assigned_Date__c < LAST_N_DAYS:4 OR Partner_Assigned_Date__c != Null))) AND Lead_Qualified_Date__c = LAST_N_DAYS:120' +
                        'Order by Lead_Qualified_Date__c DESC';
        tpsQuery += ' ((Expiration_Date__c != Null AND Expiration_Date__c =  NEXT_N_DAYS:15 AND (Partner_Status__c NOT IN(\'Closed\',\'Rejected\'))) OR (Deal_Create_Date__c = LAST_N_DAYS:5)) AND CREATEDDATE = LAST_N_DAYS:120 Order by Expiration_Date__c DESC';

        system.debug('LeadQuesry' + leadQuery);
        system.debug('tpsQuery ' + tpsQuery);

        List < Assigned_Partner__c > lstNotificationTPs = Database.query(tpsQuery);
        List < Lead > lstNotificationLeads = Database.query(leadQuery);
        ///////////////////////////////////////////////////

        TPExpiringTomorrow = 0;
        lstTPExpiringTomorrow = new List < Assigned_Partner__c > ();

        for (Assigned_Partner__c ap: lstNotificationTPs) {
            if(TPExpiringTomorrow <= 1001){
                if (lstTPExpiringTomorrow.size() < 5) {
                    if (ap.Expiration_Date__c <= System.today() + 1) {
                        ap.Name = ap.Name.left(30)+'...';
                        lstTPExpiringTomorrow.add(ap);
                        TPExpiringTomorrow = TPExpiringTomorrow + 1;
                    }
                } else {
                    if (ap.Expiration_Date__c <= System.today() + 1) {
                        TPExpiringTomorrow = TPExpiringTomorrow + 1;
                    }
                }
            }
            else
            {
                break;
            }
        }

        ///////////////////////

        TPExpiring2W = 0;
        lstTPExpiring = new List < Assigned_Partner__c > ();
        set < Id > debugTP2W = new Set < Id > ();

        for (Assigned_Partner__c ap: lstNotificationTPs) {
            DateTime e2WDateTime = System.today().addDays(14);
            Date e2WDate = e2WDateTIme.dateGMT();
            if(TPExpiring2W <= 1001)
            {
                if (lstTPExpiring.size() < 2) {
                    if (ap.Expiration_Date__c <= e2WDate && ap.Assignment_Activated__c) {
                        ap.Name = ap.Name.left(30)+'...';
                        lstTPExpiring.add(ap);
                        TPExpiring2W = TPExpiring2W + 1;
                        debugTP2W.add(ap.Id);
                    }
                } else {
                    if (ap.Expiration_Date__c <= e2WDate && ap.Assignment_Activated__c) {
                        TPExpiring2W = TPExpiring2W + 1;
                        debugTP2W.add(ap.Id);
                    }
                }
             }else{
                 break;
             }
        }
        System.debug('debugTP2W.add(ap.Id)' + debugTP2W);
        //////////////////////////////////////////////

        LeadToDeal = 0;
        lstLeadToDeal = new List < Lead > ();
        Set < Id > debugleadset = new Set < id > ();
        ///Lead Sort for Deal
        Map < String, Lead > mapstrLead = new map < String, Lead > ();
        integer j = 0;
        for (Lead l: lstNotificationLeads) {
            if (mapstrLead.containsKey(l.Deal_Id__c)) {
                mapstrLead.put(l.Deal_Id__c + j, l);
                j += 1;
            } else {
                mapstrLead.put(l.Deal_Id__c, l);
            }
        }

        List < String > strSortedLead = new list < string > ();
        strSortedLead.addall(mapstrLead.keySet());
        strSortedLead.sort();

        List < Lead > lstStoredLeadbyDeal = new List < Lead > ();
        if (!strSortedLead.isEmpty()) {
            for (integer i = strSortedLead.size() - 1; i >= 0; i--) {
                //system.debug('strSortedLead.size()' + strSortedLead.size());
                //system.debug('integer i' + i);
                //system.debug('mapstrLead.get(strSortedLead.get(i));' + mapstrLead.get(strSortedLead.get(i)));
                Lead ld = mapstrLead.get(strSortedLead.get(i));
                lstStoredLeadbyDeal.add(ld);
            }
        }

        ////
        for (Lead ld: lstStoredLeadbyDeal) {
            if(LeadToDeal <= 1001)
            {
                if (lstLeadToDeal.size() < 2) {
                    if (ld.Deal_id__c != null && ld.Partner_Lead_Status__c == 'Deal Created') {
                        lstLeadToDeal.add(ld);
                        LeadToDeal = LeadToDeal + 1;
                        debugleadset.add(ld.id);
                    }
                } else {
                    if (ld.Deal_id__c != null && ld.Partner_Lead_Status__c == 'Deal Created') {
                        LeadToDeal = LeadToDeal + 1;
                        //debugleadset.add(ld.id);
                    }
    
                }
            }else{
                break;
            }        
        }
        system.debug('debugleadset.add(ld.id)' + lstLeadToDeal);
        //////////////////////////////////////////////////////////////////

        LeadReassignment = 0;
        system.debug('lstLead' + lstNotificationLeads);
        lstLeadReAssignment = new List < Lead > ();

        for (Lead ld: lstNotificationLeads) {
            if(LeadReassignment <= 1001)
            {
                if (lstLeadReAssignment.size() < 5) {
                    if (ld.Partner_Lead_Status__c == 'Rejected-Not My Territory/Account' && (ld.Funding_Source__c == 'CISCO-FUNDED' || ld.Funding_Source__c == NULL || ld.Funding_Source__c == '')) {
                        lstLeadReAssignment.add(ld);
                        LeadReassignment = LeadReassignment + 1;
                    }
                } else {
                    if (ld.Partner_Lead_Status__c == 'Rejected-Not My Territory/Account' && (ld.Funding_Source__c == 'CISCO-FUNDED' || ld.Funding_Source__c == NULL || ld.Funding_Source__c == '')) {
                        LeadReassignment = LeadReassignment + 1;
                    }
    
                }
             }else{
                 break;
             }
         }

        //////////////////////////////////////////////////////////////////

        LeadPAToPSR = 0;
        LeadWaitingPSR = 0;
        system.debug('lstLead' + lstNotificationLeads);
        set < id > testPSRwith = new Set < id > ();
        for (Lead ld: lstNotificationLeads) {
                {
                    if (ld.Partner_Lead_Status__c == 'Partner Assigned' && ld.PSR_Assigned_Date__c == null && ld.Partner_Assigned_Date__c <= System.today() - 4 && LeadPAToPSR < 1001 )
                    // && (ld.PSR_Assigned_Date__c != null))
                    {
                        LeadPAToPSR = LeadPAToPSR + 1;
    
                        System.debug('Hello' + ld.Id);
                    }
                    if (ld.Partner_Lead_Status__c == 'Assigned To PSR' && ld.PSR_Assigned_Date__c <= System.today() - 4  && LeadWaitingPSR < 1001) {
                        LeadWaitingPSR = LeadWaitingPSR + 1;
                        testPSRwith.add(ld.Id);
                        system.debug('testPSRwith' + testPSRwith);
                    }
                }
        }

        //////////////////////////////////////////////////////////////////

        TPsDeal = 0;

        system.debug('lstLead' + lstNotificationLeads);
        for (Assigned_Partner__c ap: lstNotificationTPs) {
            {
                if (ap.Deal_Create_Date__c >= System.today() - 5) {
                    TPsDeal = TPsDeal + 1;
                }

            }
        }

        ////////////////////////////////////////////////////////////////////

        lstSCPAlert = [SELECT Id, Description__c from SCP_Alerts__c where Start_Date__c <= TODAY AND End_Date__c >= TODAY AND Notification_for__c includes ('Internal Users') Order by Start_Date__c LIMIT 5];
        scpAlert = lstSCPAlert.size();


        return null;
    }

    public list < P360TxMDashboardReportLinks__c > getlstReports() {
        List < P360TxMDashboardReportLinks__c > reportLinks = [Select Name, Name__c, ReportId__c from P360TxMDashboardReportLinks__c Order by Name];
        return reportLinks;
    }

    //Preparing for charts

    public class Data {

        public String name {
            get;
            set;
        }
        public Integer data {
            get;
            set;
        }

        public Data(String name, Integer data) {
            this.name = name;
            this.data = data;
        }
    }

    public static List < Data > getChartData() {
        List < Data > data = new List < Data > ();
        // Get all the data in one query
        String tpAccountId='Select customer_account__c from Assigned_Partner__c' + strOwnerFilter + strTPsPartnerFilter + ' CreatedDate = LAST_N_DAYS:120';
        List<Assigned_Partner__c> lstAccountId = Database.query(tpAccountId);
        Set<Id> setTPAccount=new Set<Id>();
        
        for(Assigned_Partner__c objAP : lstAccountId)
        {
            setTPAccount.add(objAP.customer_account__c);
        }
        
        Set<Id> setSharedAcc=new Set<id>();
        for(Account objAcc : [Select Id from Account where Id IN : setTPAccount])
        {
            setSharedAcc.add(objAcc.Id);
        
        }
        
        String tpsChartQuery = 'Select Partner_Status__c, count(Id) from Assigned_Partner__c' + strOwnerFilter + strTPsPartnerFilter + ' Customer_Account__c IN :setSharedAcc AND CreatedDate = LAST_N_DAYS:120 group by Partner_Status__c Order by count(Id) desc';

        system.debug('tpsChartQuery' + tpsChartQuery);
        AggregateResult[] groupedResults = Database.query(tpsChartQuery);


        for (AggregateResult a: groupedResults) {
            system.debug(a.get('Partner_Status__c'));
            system.debug(a.get('expr0'));
        }
        for (AggregateResult ar: groupedResults) {
            data.add(new Data(String.valueOf(ar.get('Partner_Status__c')), Integer.valueOf(ar.get('expr0'))));
        }
        //data.sort();
        system.debug('data' + data);
        return data;
    }

    public static integer LeadChartsize {
        get;
        set;
    }

    public integer getCountofPartnerAssignedLead (){
        string leadCountQuery ='Select Channel_Partner__r.Name,Count(Id) from Lead' + strOwnerFilter + strLeadsPartnerFilter + ' Partner_Lead_Status__c = \'Partner Assigned\' AND Funding_Source__c = \'CISCO-FUNDED\' AND Lead_Qualified_Date__c = LAST_N_DAYS:120 Group by Channel_Partner__r.Name HAVING Count(Id) >10';
        AggregateResult[] lstLeadPartnerCount = Database.query(leadCountQuery);
        Integer partnerLeadCount = lstleadPartnerCount.size();    
        return partnerLeadCount;
    
    }
    
    public static List < Data > getChartDataLead() {
        List < Data > dataLead = new List < Data > ();

        // Get all the data in one query
        String leadChartQuery = 'Select Partner_Lead_status__c,SUM(TotalValue__c), count(Id) from Lead' + strOwnerFilter + strLeadsPartnerFilter + ' Lead_Qualified_Date__c= LAST_N_DAYS:120 AND Channel_Partner__c != Null AND Partner_Lead_status__c != Null group by Partner_Lead_status__c Order by count(Id) desc Limit 49999';
        system.debug('LeadChartQuery' + leadChartQuery);
        AggregateResult[] groupedResults = Database.query(leadChartQuery);
        system.debug('LeadChartQuery' + leadChartQuery);
        system.debug('groupedResultslead' + groupedResults);
        String strRej;
        LeadChartsize = groupedResults.size();
        integer rejCount = 0;
        double rejTotalValue = 0;

        if (LeadChartsize != 0) {
            system.debug('LeadChartsize ' + LeadChartsize);
            for (AggregateResult ar: groupedResults) {

                strRej = String.valueOf(ar.get('Partner_Lead_status__c'));
                system.debug('strRej '+strRej+'Value'+ Integer.valueOf(ar.get('expr1')) );

                if (ar.get('Partner_Lead_status__c') == 'Closed-Order Through Disti') {
                    dataLead.add(new Data('Closed : Disti' + ' ($ ' + Integer.valueOf(ar.get('expr0')) + 'K)', Integer.valueOf(ar.get('expr1'))));
                } else if (ar.get('Partner_Lead_status__c') == 'Closed-Order Through Stock') {
                    dataLead.add(new Data('Closed : Stock' + ' ($ ' + Integer.valueOf(ar.get('expr0')) + 'K)', Integer.valueOf(ar.get('expr1'))));
                } else if (ar.get('Partner_Lead_status__c') == 'Rejected-Not My Territory/Account') {
                    dataLead.add(new Data('Rejected – Not my account' + ' ($ ' + Integer.valueOf(ar.get('expr0')) + 'K)', Integer.valueOf(ar.get('expr1'))));
                } else if (strRej.contains('Rejected') && strRej != 'Rejected-Not My Territory/Account') {
                    if(Integer.valueOf(ar.get('expr1')) != null){
                        rejCount += Integer.valueOf(ar.get('expr1'));
                    }
                    if(Integer.valueOf(ar.get('expr0')) != null){
                        rejTotalValue += Integer.valueOf(ar.get('expr0'));
                    }
                } else {
                    dataLead.add(new Data(String.valueOf(ar.get('Partner_Lead_status__c')) + ' ($ ' + Integer.valueOf(ar.get('expr0')) + 'K)', Integer.valueOf(ar.get('expr1'))));
                }
            }

            if (rejCount != 0) {
                dataLead.add(new Data('Rejected ($ ' + rejTotalValue + 'K)', rejCount));
            }
        }
        //dataLead.sort();
        system.debug('datafy' + dataLead.size());

        return dataLead;
    }

    public string urlLeadWaitingAssignment {
        get;
        set;
    }
    public string urlPartnerWith10PlusPartnerAssigned {
        get;
        set;
    }
    public string urlLeadWaitingReAssignment {
        get;
        set;
    }
    public string urlLeadConvertedDeal5Days {
        get;
        set;
    }
    public string urlLeadWaitingforPAfor4Days {
        get;
        set;
    }
    public string urlLeadWaitingforPSRfor4Days {
        get;
        set;
    }
    public string urlTPWaitingActivation {
        get;
        set;
    }
    public string urlTPExpiringTomorrow {
        get;
        set;
    }
    public string urlTPExpiringTwoWeeks {
        get;
        set;
    }
    public string urlTPDeals5Days {
        get;
        set;
    }
    public string urlTPChart {
        get;
        set;
    }
    public string urlLeadChart {
        get;
        set;
    }

    public void urlsforDashboards() {
        string urlPartnerLeadFlt = '';
        string urlPartnerTPFlt = '';
        string urlTxMOwnerLeadFlt = '';
        string urlTxMOwnerTPFlt = '';
        string scopeLead = '';
        string scopeTp = '';
        string urlPartnerTPDealFlt = '';
        string urlOwnerTPDeal = '';
        string strTPboolFilter = '';

        if (newlead.Channel_Partner__c != null) {
            urlPartnerLeadFlt = 'pc0=00N80000004xBRM&pn0=eq&pv0=' + String.valueOf(newlead.Channel_Partner__c).left(15);
            urlPartnerTPFlt = 'pc0=00N80000004xAw3&pn0=eq&pv0=' + String.valueOf(newlead.Channel_Partner__c).left(15);
            urlPartnerTPDealFlt = 'pc0=FK_00N80000004xAw3&pn0=eq&pv0=' + String.valueOf(newlead.Channel_Partner__c).left(15);
        }
        system.debug('idTxM'+idTxm);
        
        if (idTxm != null && idTxM != '000000000000000AAA') {
                List<User> lstUSR = [Select Name from User where Id =: idTXM limit 1];

            if(!lstUSR.isEmpty()){            
                    String strTxMName= EncodingUtil.urlEncode(lstUSR[0].name, 'UTF-8');
                    urlTxMOwnerLeadFlt = '&pc1=OWNER&pn1=eq&pv1=' + strTxMName + '&';
                    urlTxMOwnerTPFlt = '&pc1=00N80000004xAti&pn1=eq&pv1=' + String.valueOf(idTxM).left(15)+ '&';
                    urlOwnerTPDeal = '&pc1=FK_00N80000004xAti&pn1=eq&pv1=' + String.valueOf(idTxM).left(15)+ '&';
                }
                else
                {
                    urlTxMOwnerLeadFlt = '&pc1=OWNER&pn1=eq&pv1=' + String.valueOf(UserInfo.getUserId()).LEFT(15) + '&';
                    urlTxMOwnerTPFlt = '&pc1=00N80000004xAti&pn1=eq&pv1=' + String.valueOf(UserInfo.getUserId()).LEFT(15) + '&';
                    urlOwnerTPDeal = '&pc1=FK_00N80000004xAti&pn1=eq&pv1=' + String.valueOf(UserInfo.getUserId()).LEFT(15) + '&';
                
                }
        }
        else
        {
            if (idTxM == '000000000000000AAA')
            {
                urlTxMOwnerLeadFlt='';
                urlTxMOwnerTPFlt ='';
                urlOwnerTPDeal ='';                
            }else
            {
                urlTxMOwnerLeadFlt = '&pc1=OWNER&pn1=eq&pv1=' + String.valueOf(UserInfo.getUserId()).LEFT(15) + '&';
                urlTxMOwnerTPFlt = '&pc1=00N80000004xAti&pn1=eq&pv1=' + String.valueOf(UserInfo.getUserId()).LEFT(15) + '&';
                urlOwnerTPDeal = '&pc1=FK_00N80000004xAti&pn1=eq&pv1=' + String.valueOf(UserInfo.getUserId()).LEFT(15) + '&';
            }
        }
        
        if (SelectedValue == 'My Leads and Target Prospects') {
            scopeLead = '&scope=user';
            scopeTP = '&scope=user';
        } else {
            scopeLead = '&scope=org';
            scopeTP = '&scope=organization';
        }
        
        if(newlead.Channel_Partner__c != null && idTxM !='000000000000000AAA')
        {
            strTPboolFilter= '&bool_filter=1+AND+2+AND+3+AND+(4+AND+5)';
        }
        else if(newlead.Channel_Partner__c == null && idTxM =='000000000000000AAA')
        {
            strTPboolFilter= '&bool_filter=1+AND+(2+AND+3)';
        }else
        {
            strTPboolFilter= '&bool_filter=1+AND+2+AND+(3+AND+4)';
        }
        

        P360TxMReportFilters__c filterValue = P360TxMReportFilters__c.getOrgDefaults();

            if (SelectedValue == 'My Leads and Target Prospects' && (urlPartnerTPFlt == null || urlPartnerTPFlt == '' )) {
                urlLeadWaitingAssignment = filterValue.lvCSLeadWaitingAssignment__c;
                urlLeadWaitingReAssignment = filterValue.lvCSLeadWaitingReAssignment__c;
                urlLeadConvertedDeal5Days = filterValue.lvCSLeadConvertedDeal5Days__c;
                urlTPWaitingActivation = filterValue.lvCSTPWaitingActivation__c;
                urlTPExpiringTomorrow = filterValue.lvCSTPExpiringTomorrow__c;
                urlTPExpiringTwoWeeks = filterValue.lvCSTPExpiringTwoWeeks__c;
            } else {
                urlLeadWaitingAssignment = filterValue.GenericLeadReport__c + urlPartnerLeadFlt + urlTxMOwnerLeadFlt + filterValue.urlCSLeadWaitingAssignment__c + scopeLead;
                urlLeadWaitingReAssignment = filterValue.GenericLeadReport__c + urlPartnerLeadFlt + urlTxMOwnerLeadFlt + filterValue.urlCSLeadWaitingReAssignment__c + scopeLead;
                urlLeadConvertedDeal5Days = filterValue.LeadDealReport__c + urlPartnerLeadFlt + urlTxMOwnerLeadFlt + filterValue.urlCSLeadConvertedDeal5Days__c + strdate5daysAgo + scopeLead;
                urlTPWaitingActivation = filterValue.GenericTPReport__c + urlPartnerTPFlt + urlTxMOwnerTPFlt + filterValue.urlCSTPWaitingActivation__c + scopeTP;
                urlTPExpiringTomorrow = filterValue.GenericTPReport__c + urlPartnerTPFlt + urlTxMOwnerTPFlt + filterValue.urlCSTPExpiringTomorrow__c + strdate1daysAhead + scopeTP;
                urlTPExpiringTwoWeeks = filterValue.GenericTPReport__c + urlPartnerTPFlt + urlTxMOwnerTPFlt + filterValue.urlCSTPExpiringTwoWeeks__c + strTodaysDate + filterValue.urlCSTPExpiringTwoWeeks2__c + strdate14daysAhead + scopeTP + strTPboolFilter;
            
            }
            //Rest URLs will be Static
                urlLeadWaitingforPAfor4Days = filterValue.GenericLeadReport__c + urlPartnerLeadFlt + urlTxMOwnerLeadFlt + filterValue.urlCSLeadWaitingforPAfor4Days__c + strdate4daysAgo + scopeLead;
                urlLeadWaitingforPSRfor4Days = filterValue.GenericLeadReport__c + urlPartnerLeadFlt + urlTxMOwnerLeadFlt + filterValue.urlCSLeadWaitingforPSRfor4Days__c + strdate4daysAgo + scopeLead;
                urlTPDeals5Days = filterValue.TPDealReport__c + urlPartnerTPDealFlt + urlOwnerTPDeal + filterValue.urlCSTPDeals5Days__c + strdate5daysAgo + scopeTP;
                urlTPChart = filterValue.TPChartReport__c + urlPartnerTPFlt + urlTxMOwnerTPFlt + scopeTP;
                urlLeadChart = filterValue.LeadChartReport__c + urlPartnerLeadFlt + urlTxMOwnerLeadFlt + scopeLead;
                urlPartnerWith10PlusPartnerAssigned  = filterValue.Lead10PlusPAReport__c + urlPartnerLeadFlt + urlTxMOwnerLeadFlt + filterValue.urlLead10PlusPAReport__c + scopeLead;
        }

}