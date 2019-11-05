/************************************************************************************************************************************
Name    : JiffleNowMeetingSchedular_CTE
Author  : Mukesh Srivastava
Purpose : This class is a controller extension for initiating JiffleMeeting and 
            1) Making sure only visibile and active opportunity list is shown the user for scheduling the meeting
            2) Pursing Parameters from different initiation points where Jiffle Meeting can be Initiated
            3) 
Created Date: 4/15/2015
Modification History: 
[7/27/2015] Awnish: Added a logic to fetch the Help Guide Image - PBI000000051759
*************************************************************************************************************************************/
public with sharing class JiffleNowMeetingSchedular_CTE {
    // Declaring Variables
    public List < Jiffle_Meeting_Session__c > lstMeetingSession {get;set;}
    public CEE__c CEENew {get;set;}
    public String selectedCEE {get;set;}
    public String selectedOppty {get;set;}
    public Boolean eMode {get;set;}
    public String CEEId;
    public String eventId;
    public String eId;
    public String accountId;
    public String opptyId;
    public String opptyName;
    public String returnURL;
    public ApexPages.StandardSetController jiffleCEESession {get;set;}
    public Integer size {get;set;}
    public Integer noOfRecords {get;set;}
    public Id idOfJiffleRec {get;set;}
    public string sessionEditId {get;set;}

    //@ Constructor to process all the parameter from different scenarios
    public JiffleNowMeetingSchedular_CTE(ApexPages.StandardController controller) {
        CEENew = new CEE__c(); //Initiazing New CEE record
        idOfJiffleRec = Schema.SObjectType.CEE__c.getRecordTypeInfosByName().get('Jifflenow (Event, Tradeshow, Conference)').getRecordTypeId();
        // Collecting all the parameters
        CEEId = ApexPages.currentPage().getParameters().get('id');
        eventId = ApexPages.currentPage().getParameters().get('eventId');
        accountId = ApexPages.currentPage().getParameters().get('accId');
        opptyId = ApexPages.currentPage().getParameters().get('opptyId');
        opptyName = ApexPages.currentPage().getParameters().get('opptyName');
        eId = ApexPages.currentPage().getParameters().get('eId');
        returnURL = ApexPages.currentPage().getParameters().get('retURL');
        sessionEditId = '#'+ ApexPages.currentPage().getParameters().get('sessionId');
        size = 5;
        // When Users are redirected from JiffleNow or User is creating new meeting from Event list page or from Event detailed page
        if (eventId != null) {
            createMeetingFromEvent();
        } else If(eId != null) {
            CEENew.Jiffle_Event__c = eId;            
        }

        // When User has initiated from Account
        if (accountId != null) {
            CEENew.Primary_Account__c = accountId;
        }
        
        // When User has initiated from Opportunity
        if (opptyId != null) {
            createMeetingFromOppty();
        }
        
        //When User want to edit the Engagement
        if (CEEId != NULL) {
            editMeeting();
        }
    }

    //@ Method Set the value of Jiffle Event received from URL Parameter when initiated from Event
    public void createMeetingFromEvent() {
        CEENew.Jiffle_Event__c = [Select Id from Jiffle_Event__c where Event_UUID__c = : eventId limit 1].Id;
        CEENew.Primary_Account__c = null;
    }

    //@ Method Set the value of Oppoty and Account received from URL Parameter when initiated from Opportunity
    public void createMeetingFromOppty() {
            if (opptyName == null) {
                Opportunity opObj = [Select Name, AccountId,Opportunity_Status__c from Opportunity where Id = : opptyId LIMIT 1];
                Id opId = opptyId;
                if(opObj.Opportunity_Status__c == 'Active'){
                    selectedOppty = opId + opObj.Name;
                }else{
                    ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Info, System.Label.NonActiveOpportunityMessage);
                    ApexPages.addmessage(msg);  
                }
                CEENew.Primary_Account__c = opObj.AccountId;
            } else {
                selectedOppty = opptyId + opptyName;
            }
        }
        
    //@ Method Get the list of meetings/Sessions scheduled for under scoped engagement       
    public void editMeeting() {
        eMode = true;       
        Set < Id > setMeetingSession = new Set < Id > ();
        for (Jiffle_Attendee_Invitee__c jAIObj: [Select Jiffle_Session_Meeting__c, Requestor_Email__c from Jiffle_Attendee_Invitee__c 
                                                    Where Customer_Engagements_Events__c = : CEEId AND Requestor_Email__c =: UserInfo.getUserEmail()]) {
            setMeetingSession.add(jAIObj.Jiffle_Session_Meeting__c);
        }
        lstMeetingSession = [Select Id, End_Date_Time__c, External_Edit_URL__c, Name, Jiffle_Meeting_Location__c, Meeting_Type__c, 
                                Request_Status__c, Start_Date_Time__c, Jiffle_Agenda_Item__c,Jiffle_Agenda_Item__r.Topic__c from Jiffle_Meeting_Session__c 
                                Where Id IN: setMeetingSession Order by Start_Date_Time__c DESC];        
        jiffleCEESession = new ApexPages.StandardSetController(lstMeetingSession);
        noOfRecords = jiffleCEESession.getResultSize();        
    }
    
    public List<Jiffle_Meeting_Session__c> getCEESessions() {
        jiffleCEESession.setPageSize(size);
        return (List<Jiffle_Meeting_Session__c>) jiffleCEESession.getRecords();
    }
    
    //@ Method Reading the account selected by user called by action support
    public pageReference readAccount() {
        getOppties();
        return null;
    }
    
    //@ Method Cancel the Operation and return to ReturnURL if any
    public pageReference cmdCancel() {
        PageReference pageRef = new PageReference(returnURL);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
     //@ Method to fetch the help guide image link from document
    public String getHelpGuideImageLink(){   
       Org_Constant_CS__c jnOrgCS = Org_Constant_CS__c.getValues('JiffleNowHelpGuideImageURL');
       String helpGuideURL = jnOrgCS.Production_Value__c;
        Organization org = [Select Id, IsSandbox FROM Organization limit 1];
        if(org.IsSandbox == TRUE){
            helpGuideURL = jnOrgCS.Non_Production_Value__c;
        }
         return helpGuideURL ;
    }

    //@ Method reset the page when user is in Edit mode
    public pageReference submitNewRequest() {
        return null;
    }
    
    //@ Method to find out production and sandbox URLs
    public String getJiffleURL(){        
        Org_Constant_CS__c jnOrgCS = Org_Constant_CS__c.getValues('JiffleNowInstanceURL');        
        String strJiffleURL = jnOrgCS.Production_Value__c;
        
        Organization org = [Select Id, IsSandbox FROM Organization limit 1];
        if(org.IsSandbox == TRUE){
            strJiffleURL = jnOrgCS.Non_Production_Value__c;
        }
        return strJiffleURL;
    }

    //@ Method Creating Opportunity list of options
    public List < SelectOption > getOppties() {
        List < SelectOption > options = new List < SelectOption > ();

        //Add blank and default option to display when the page loads.
        options.add(new SelectOption(' ', 'Select an Opportunity'));
        options.add(new SelectOption('000000000000012345No Related Opportunity', 'No Related Opportunity'));

        //Create list of all the active opportunities associated to account selected for meeting with value as combination of Opportunity Id and Opportunity Name
        List < Opportunity > lstOppty;
        if (CEEId != NULL) {
            List < CEE__c > CEEExisting = [Select Id, Primary_Account__c, Opportunity__c, Opportunity__r.Name from CEE__c where Id = : CEEId Limit 1];
            selectedCEE = CEEExisting[0].Opportunity__c + CEEExisting[0].Opportunity__r.Name;
            lstOppty = new List < Opportunity > ([SELECT Id, Name FROM Opportunity Where AccountId = : CEEExisting[0].Primary_Account__c AND Opportunity_Status__c = 'Active'
                ORDER BY Name ASC
            ]);
        } else {
            system.debug('sss'+CEENew.Primary_account__c);
            if(CEENew.Primary_Account__c != NULL){
                lstOppty = new List < Opportunity > ([SELECT Id, Name FROM Opportunity Where AccountId = : CEENew.Primary_Account__c AND Opportunity_Status__c = 'Active'
                    ORDER BY Name ASC
                ]);
            }
        }
        // Setting the list of Options
        if(lstOppty != NULL){
            for (Opportunity oObj: lstOppty) {
                options.add(new SelectOption(oObj.Id + oObj.Name, oObj.Name));
            }
            
            //reseting selected value when user changed account
            if(lstOppty.size()>0){
                selectedOppty = '';            
            }else{
                selectedOppty = '000000000000012345No Related Opportunity';
            }
        }        
        return options;
    }
}