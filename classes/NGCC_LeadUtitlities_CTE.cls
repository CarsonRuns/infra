/******************************************************************************************************************************************************
Name    : NGCC_LeadUtitlities_CTE
Author  : Mukesh Srivastava
Purpose : Controller Extension to manage multiple functionalities across NGCC project
            1) Validate Lead Address Detail with CR database real time
            2) Creating response when an agent tries to connect to the customer
            3) Creating Response and Launching Call Script when agent is in conversion with customer
            4) Submitting Lead for Approval process and later Approving,Rejecting or sending to Sales
Created Date: 4/18/2014
Modification History: Dan: Added CR Address Validation functionality
                      Serge: Added enhancement for Call Script Invocation
                      Dan: Replaced method call to NGCC_CRAddressValidation to be one method call
                      Fazurulla: NULL check added at line 275 for Call_Script__c           
                      Awnish Kumar: Fix for the discrepancy in count between side bar notification and lead view list between line 569 to 575
                              PL/CL fix for Convergys Suzhou China - PBI000000046290
                              validateSelectedCallScript method added to launch Call Script based on the theatre - PBI000000047279
                      Fazurulla :Added logic where the field 'First Call Attempt' field is timestamped when the first response is saved against a lead record-INC000033193950
                      Fazurulla : Added new logic and method for Approval processs to cancel button # PBI000000051940
                      Fazurulla : added to check PL/CL flag for APJ theater - INC000033649456
                      Fazurulla : Implemented new logic for Senior Agent role #PBI800000001913
                      Fazurulla : Added approval logic for New Call center's : Concentrix Sofia Bulgaria and Raya Warsaw Poland #PBI800000001554,PBI800000001488
                      Fazurulla : Added code snippet for an issue "SDR's not able to close any open records"
                      Fazurulla : Leads stuck in picked for routing or send to sales logic has been implemented-validatePostalCodeCheck()
User    : Ghattamaneni Chaithanya
Purpose : Adding Dispostion Sub Type field to page
          Condition based displaying the Disposition Sub Type field Line NO#232-238  
date    : July 16,2018

User    : Ghattamaneni Chaithanya
Purpose : Added Contact Reason and Persona fields to page US291144
      	   Line no : 108-111, 310-326
date    : June 14,2019
*********************************************************************************************************************************************************/
public class NGCC_LeadUtitlities_CTE {
    Public CC_Response__c response {get; set;}
    Public String outputText {get; set;}
    // scava changes made by deepak for XSS
    public string jsStart {get{ return '<script>';}  set;}
    public string jsEnd {get{ return '</script>';}  set;}
    public string textToBeDisplayedAtStart {get;  set;}
    public string textToBeDisplayedAtEnd {get;  set;}
    public string windowHrefUrl {get;   set;}
    // end of scava made by deepak
    Public String returnedUrl {get; set;}
    Public String rejectReason {get; set;}
    Public String nextApproval {get; set;}
    Public Boolean showComment {get; set;}
    Public Boolean showCallScript {get; set;}
    Public Boolean showGeneric {get; set;}
    Public Boolean bAppReq {get; set;}
    Public Boolean bAppReject {get; set;}
    Public Boolean bAppEMEAR {get; set;}
    Public Boolean refreshPage {get; set;}
    Public String showAlert {get; set;}
    public Boolean bCancelLead {get; set;}
    Private final Lead Led;
    public Id UserId{get;set;}
    public boolean calluserlookuuppage{get;set;} //added by Bapu
    public boolean openInSameWindow{get;set;}//added by Bapu
    public String msg {get; set;} //added by Bapu
    public String dropdownNote {get; set;}//added by bapu
    Id objectid;
    public id ids;
    Private ApexPages.StandardController standardController;
    Private final Lead firstlead;
    Private final Lead leadDetail;
    Public Set<Id> actId;

    public Boolean isInConsoleMode {get; set;}
    // Deepak : For stored XSS scava issue
    public string isInConsoleMode1 {
    get{isInConsoleMode1 = (isInConsoleMode)?'true':'false';
    Return isInConsoleMode1;
    }
    private set;
    }
    
    // Deepak : Stored XSS Ends here
    
    public String redirectConsoleURL {get; set;}
    public String LeadId;
    
    // SCAVA Helper Method
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }
    
    // SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdateGet(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }

    Public LIST < GroupMember > actList;
    List < CC_Response_Detail__c > newResDetail = new List < CC_Response_Detail__c > ();

    public void setIsInConsoleMode(){
        isInConsoleMode = true;
    }
        
    public boolean winLead {get; set;}
    public string leadStatus {get; set;}

    public boolean showDispSubtype {get; set;}
    public string Disposition {get;set;}    
    
    // added by gchaitha to display Contact Reason andPersona fields US291144
    public boolean showContactReason {get; set;}
    public boolean showPersona {get; set;}
    // end
    
    /* @Constructor to get record detail in the context */
    public NGCC_LeadUtitlities_CTE(ApexPages.StandardController controller) {
        winLead = false; 
        leadStatus = '';
        showGeneric = true;
        showCallScript = true;
        calluserlookuuppage = false;
        openInSameWindow = false;
        refreshPage = false;
        isInConsoleMode = false;
        this.firstlead = (Lead) controller.getRecord();
        this.standardController = controller;
        showAlert = '';
        if(ids!= null)
        ids = firstlead.id;
        //added by Bapu
        this.Led = (Lead)controller.getRecord();
        objectid = Apexpages.currentPage().getParameters().get('Id');
        // Message for next approver selection page for EMEAR approval Process
        msg = 'This record requires additional approval.<br/>Your administrator has specified that you must manually choose who the next approver should be.';
        msg += '<br/>Specify a user in the box below, then click Send to Next Approver.';

        leadDetail = [Select Name, Status, Company, Address_Line_1__c, Address_Line_2__c,Address_Line_3__c, CustomCity__c, CustomState__c, CustomZip__c,
            Route_to_AM__r.Email, Source_Event_Number__c, Campaign_Name__c, ProgramEvent__c, Partner_Contact_Email__r.Email, First_Call_Attempt__c,
            Description, No_of_Attempts__c, Campaign_Name__r.Call_Script__c, Campaign_Name__r.Maximum_No_Attempts__c,Medium_Type__c, DedupeRecord__c,
            CustomCountry__c,SDR_Lead_Owner_New__c,PL_CL_Flag__c, email, Lead_Qualifier__c, Call_Center_Vendor__c,Lead_Qualifier_Call_Center__c, Theater__c, NGCC_Win_Lead__c   from Lead where Id = : firstlead.Id limit 1


        ];
        
        if(leadDetail.NGCC_Win_Lead__c){
            winLead = true;
        }
        
        if(leadDetail.status != null){
            leadStatus = leadDetail.status;
        }
        
        system.debug('!! Lead detail' + leadDetail.Status);
                     
      }
   
   

    /* @method: set refresh variable to false to stop a secondary refresh in console view*/
    public void resetRefresh(){
        refreshPage = false;
    }

    /* @method: Make a call out to verify the address detail for the lead with Customer Registry */
    public void cmdValidateAddress() {
        firstlead.Id = leadDetail.Id;
        firstlead.Company = leadDetail.Company;
        firstlead.Address_Line_1__c = leadDetail.Address_Line_1__c;
        firstlead.Address_Line_2__c = leadDetail.Address_Line_2__c;
        firstlead.Address_Line_3__c = leadDetail.Address_Line_3__c;
        firstlead.CustomCity__c = leadDetail.CustomCity__c;
        firstlead.CustomState__c = leadDetail.CustomState__c;
        firstlead.CustomCountry__c = leadDetail.CustomCountry__c;
        firstlead.CustomZip__c = leadDetail.CustomZip__c;



        String result = NGCC_CRAddressValidationCallout.addressValidation(firstlead);

        if (result.contains('error')) {
            Map < String, Object > errorMsg = (Map < String, Object > ) JSON.deserializeUntyped(result);
            String text = (String) errorMsg.get('error');
            showAlert = text;
        } else {
            Type t = Type.forName(standardController.getRecord().getSObjectType().getDescribe().getName());
            Lead newlead = (Lead) JSON.deserialize(result, t);
            refreshPage = true;
            standardController.save();
        }
    }
    /**********************************************************Response and Call Script*************************************************************/
    /* @method: Invoking create response process by default some of attribute of the resposne as lead detail
    //          1) If the Lead already exceeded the maximum number of attempt allowed then show error message
    //          2) Defaulting call script(Campaign) and language(Country) based on lead detail */
    public void cmdCallScript() {
        if (leadDetail.No_of_Attempts__c >= leadDetail.Campaign_Name__r.Maximum_No_Attempts__c) {
            showAlert = 'Max # of attempts has been reached.  Please close record with \'Max# of Attempts\' disposition if you have not committed to calling contact back. ';
        }
        response = new CC_Response__c();
        //SCAVA Fix
        if(flsGet(CC_Response__c.Name)){
        response.Name = leadDetail.Name + System.Now();
        }
        if(flsGet(CC_Response__c.Call_Script__c)){
        response.Call_Script__c = leadDetail.Campaign_Name__r.Call_Script__c;
        }
        if(flsGet(CC_Response__c.Lead__c)){
        response.Lead__c = leadDetail.Id;
        }
        if(flsGet(CC_Response__c.AM_Email_Id__c)){
        response.AM_Email_Id__c = leadDetail.Route_to_AM__r.Email;
        }
        if(flsGet(CC_Response__c.Campaign__c)){
        response.Campaign__c = leadDetail.Campaign_Name__c;
        }
        if(flsGet(CC_Response__c.Key_Code__c)){
        response.Key_Code__c = leadDetail.ProgramEvent__c;
        }
        if(flsGet(CC_Response__c.Partner_Contact_Email_Id__c)){
        response.Partner_Contact_Email_Id__c = leadDetail.Partner_Contact_Email__r.Email;
        }
        if(flsGet(CC_Response__c.Source_Event_Number__c)){
        response.Source_Event_Number__c = leadDetail.Source_Event_Number__c;
        }
        if(flsGet(CC_Response__c.Source_System_Name__c)){
        response.Source_System_Name__c = 'NGCC';
        }
        if(flsGet(CC_Response__c.Response_Type__c)){
        response.Response_Type__c = leadDetail.Medium_Type__c;
        }
        if(flsGet(CC_Response__c.Notes__c)){
        response.Notes__c = dropdownNote ;
        }
        //SCAVA Fix

        try {
            List < NGCC_Mapping_Object__c > mObj = [Select Language__c from NGCC_Mapping_Object__c where Name = : leadDetail.CustomCountry__c Limit 1];
            if (!mObj.isEmpty()) {
                response.Language__c = mObj[0].Language__c;
            } else {
            //SCAVA
                if(flsGet(CC_Response__c.Language__c)){
                response.Language__c = 'English: en_US';
                }
            //SCAVA
        }
            
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'Country Information not valid'));
        }
        showCallScript = false;
        showGeneric = false;
    }

    /* @method: Invoking Cancel Lead process  */
    public pageReference cmdCancelLead() {
        bCancelLead = true;
        showGeneric = false;
        return null;
    }
     
    /* @method: Processing Cancel Lead process  */
    public void cmdProcessCancelLead() {
        if (firstlead.Status == 'Approval Pending') {
            processApprovalRequestForCancel('Reject', 'Cancelled');
        }
        //SCAVA
        if(flsGet(lead.Status)||flsUpdateGet(lead.Status)){
        firstlead.Status = 'Cancel';
        }
        if(flsGet(lead.MQL_Validation__c)||flsUpdateGet(lead.MQL_Validation__c)){
        firstlead.MQL_Validation__c = '';
        }
        //SCAVA

        Database.SaveResult dbUpdateLead = Database.update(firstlead, true);
        bCancelLead = false;
        showGeneric = true;
        refreshPage = true;
    }
    /*@Method : Invoking Approval process to cancel the lead */
    //@Added by Fazurulla 
    public void processApprovalRequestForCancel(String strAction, String strComment) {    
        try {            
            List < ProcessInstanceWorkItem > items = [SELECT Id
                FROM ProcessInstanceWorkItem
                WHERE ProcessInstance.Status = 'Pending'
                AND ProcessInstance.TargetObjectId = : firstlead.Id LIMIT 1 ];
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setAction(strAction);
            //req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            req.setComments(strComment.abbreviate(4000));
            req.setWorkitemId(items[0].Id);
            Approval.ProcessResult result = Approval.process(req);               
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error occured' + e.getMessage()));
       }
    }

    /* @method: Validate if the response status is Call Back and Nurture then display the Comment and Date time field
    // @sets the flag to rereneder the block to show the comment and date time */
    public void statusUpdate() {
        string Outcomes = System.Label.NGCC_Disposition_SubType_Outcomes; 
        if(flsGet(CC_Response__c.status__c)||flsUpdateGet(CC_Response__c.status__c)){
        response.status__c = Disposition;
        }
        if (response.status__c == 'Call Back' ) {
            showComment = true;
        } else {
            showComment = false;
        }
        // added by gchaitha to display Disposition Sub Type
        if (response.status__c != null && response.status__c != '' && Outcomes.containsIgnoreCase(response.status__c)){
            showDispSubtype = true;
        }else {
            showDispSubtype = false;
        }
        showContactReason = false;
        showPersona = false;
        //end
    }
    //added by gchaitha to display Contact Reason andPersona fields US291144
    public void DispositionChange() {
        system.debug(response.Disposition_Sub_Type__c);
        showContactReason = true;
        showPersona = true;
    }
    //end
    /* @ Method added by Awnish to validate the selected call script # PBI000000047279*/
    public boolean validateSelectedCallScript(){
    if(response.Call_Script__c != null){
            String selectedCallScript = response.Call_Script__c;
            CC_Call_Script__c callScript = [select id,Theater__c from CC_Call_Script__c where id =: selectedCallScript limit 1];
            if(leadDetail.Theater__c ==null || callScript.Theater__c == null || (callScript.Theater__c == leadDetail.Theater__c)){
                return true;
            }else {
                showAlert = 'Call Script theater doesn\'t match with the lead theater. Please select valid Call Script.';
                return false;
            }
        }else{
            showAlert = 'Please select Call Script.';
            return false;
        }
    
    }
    
    /* @method: Allow user to save the response
    //          1) If the Response status = Refer a New Contact then redirect the user to Search for existing contact
    //          2) Else save the response and depending on status update the lead statuses */
    public pagereference saveResponse() {
    Boolean saveResponseFlag = validateSelectedCallScript(); //Added to validate the selected call script # PBI000000047279 - Awnish
     if(saveResponseFlag){
        if (response.status__c != 'Refer a New Contact') {
                //if (response.status__c != 'Ghost Chat' && response.status__c != 'Ghost Call'){
                NGCC_QA_and_Lead_Mapping__c myCSStatus = NGCC_QA_and_Lead_Mapping__c.getValues(response.Status__c);
                if(flsGet(CC_Response__c.Call_Status__c)){
                response.Call_Status__c = myCSStatus.Call_Status__c;
                }
            //}
            
            
            try {
                insertResponse();

                /*if (isInConsoleMode != true){
                    outputText = '<script>window.top.location.reload();</script>';
                } else {
                    outputText = '<script>refreshPage();</script>';
                }*/
                // scava changes made by deepak
                if (isInConsoleMode != true){
                    textToBeDisplayedAtStart = '';
                    textToBeDisplayedAtEnd = '';
                    windowHrefUrl = '';
                    outputText = 'window.top.location.reload();';
                } else {
                    textToBeDisplayedAtStart = '';
                    textToBeDisplayedAtEnd = '';
                    windowHrefUrl = '';
                    outputText = 'refreshPage();';
                }
                // scava end 
            } catch (Exception e) {
                if(e.getMessage().contains('Call Back Time')){
                    response.Call_Back_Time__c.addError(e.getDmlMessage(0));
                }
                return null;
            }
        } else {
            NGCC_QA_and_Lead_Mapping__c myCSStatus = NGCC_QA_and_Lead_Mapping__c.getValues(response.Status__c);
            response.Call_Status__c = myCSStatus.Call_Status__c;

            insertResponse();
            LIST < PDBCountryLookup__c > countryCode = [select name from PDBCountryLookup__c where Code_Desc__c = : leadDetail.CustomCountry__c Limit 1];
            NGCC_State_List__c stateCS = new NGCC_State_List__c();
            if(leadDetail.CustomState__c != NULL){
                stateCS = NGCC_State_List__c.getValues(leadDetail.CustomState__c);
            }


            String country;
            if (!countryCode.isEmpty()) {
                country = encodeURL(countryCode[0].name);
            } else {
                country = '';
            }

            String company = encodeURL(leadDetail.company);
            String State;
            if (country == 'US' && stateCS != NULL) {
                State = encodeURL(stateCS.Code__c);
            } else {
                State = encodeURL(leadDetail.CustomState__c);
            }

            String campaign;
            if (leadDetail.Campaign_Name__c != null) {
                campaign = encodeURL(leadDetail.Campaign_Name__c);
            } else {
                campaign = '';
            }
            //added by bapu
            String address1;
            if (leadDetail.Address_Line_1__c != null) {
                address1 = encodeURL(leadDetail.Address_Line_1__c);
            } else {
                address1 = '';
            }
            String address2;
            if (leadDetail.Address_Line_2__c != null) {
                address2 = encodeURL(leadDetail.Address_Line_2__c);
            } else {
                address2 = '';
            }
            String address3;
            if (leadDetail.Address_Line_3__c != null) {
                address3 = encodeURL(leadDetail.Address_Line_3__c);
            } else {
                address3 = '';
            }
            String city = encodeURL(leadDetail.CustomCity__c);
            String postalCode = encodeURL(leadDetail.CustomZip__c);
            String redirectURL = '/apex/NGCC_MODS_SFDC_Contact_Search?ResponseId=' + response.id;
            redirectURL = redirectURL + '&company=' + company + '&state=' + state;
            redirectURL = redirectURL + '&countryName=' + country + '&city=' + city + '&postalCode=' + postalCode + '&campaign=' + campaign+'&address1='+address1+'&address2=' + address2+'&address3=' +address3;
            redirectConsoleURL = redirectURL;
            /*if (isInConsoleMode){
                redirectConsoleURL = redirectConsoleURL + '&console=true';
                outputText = 'Please wait..<script>changeSubtab();</script>';
            } else {
                outputText = 'Please wait..<script>window.top.location.href =\'' + redirectUrl + '\'</script>';
            }*/
            //scava Changes made by dchamola
            if (isInConsoleMode){
                redirectConsoleURL = redirectConsoleURL + '&console=true';
                textToBeDisplayedAtStart = 'please wait...';
                textToBeDisplayedAtEnd = '';
                windowHrefUrl = '';
                outputText = 'changeSubtab();';
            } else {
                textToBeDisplayedAtStart = 'please wait...';
                textToBeDisplayedAtEnd = '\'';
                windowHrefUrl = 'window.top.location.href =\'';
                outputText = redirectUrl;
            }
            //End of Scava Changes
        }
       }
        
        list<Lead> leadlistUpdated = [select id,Status from Lead where id =:firstlead.id];
        if(leadlistUpdated.size() >0){
            if(flsGet(lead.Status)||flsUpdateGet(lead.Status)){
                leadDetail.Status = leadlistUpdated[0].Status;
                system.debug('leadDetail.Status=='+leadlistUpdated[0].Status);
            }
        }         
       //Dedupe Process for Inbound Call and Chat
         List<Lead> thisLead = new List<Lead>();
        if((response.Response_Type__c == 'Inbound Call' || response.Response_Type__c == 'Inbound Chat') && leadDetail.DedupeRecord__c !=null){
            if(response.Response_Type__c == 'Inbound Call'){
                if(flsGet(lead.Medium_Type__c)||flsUpdateGet(lead.Medium_Type__c)){
                leadDetail.Medium_Type__c = 'Inbound Call';
                }
            }else if(response.Response_Type__c == 'Inbound Chat'){
                leadDetail.Medium_Type__c = 'Inbound Chat';
            }
            if(flsGet(lead.DedupeRecord__c)||flsUpdateGet(lead.DedupeRecord__c)){
            leadDetail.DedupeRecord__c = null;
            }
            if(flsGet(lead.DeduperProcessing__c)||flsUpdateGet(lead.DeduperProcessing__c)){
            leadDetail.DeduperProcessing__c = true;
            }
            thisLead.add(leadDetail);
        }
        
        if(thisLead.size()>0){
            NGCC_Lead_Deduper.leadDeduper(thisLead);
        }
      
      
   
       return null;
    }

    /* @method: Insert the response  and update the lead No.of attempt with increase count */
    public void insertResponse() {
        //SCAVA 
        if(flsGet(CC_Response__c.Response_Date_Time__c)){
        response.Response_Date_Time__c = System.now();
        }
        system.debug(' response.Disposition_Sub_Type__c=='+response.Disposition_Sub_Type__c);
        system.debug('response=='+response+' response.status__c=='+response.Disposition_Sub_Type__c);
        Database.SaveResult insertResponse = Database.Insert(response, true);
        //NEW & SCAVA
        lead l = [select id,status from lead where id=:response.lead__c];
        if(flsGet(lead.Status)||flsUpdateGet(lead.Status)){
        leadDetail.status = l.status;
        }
        system.debug('insertResponse=='+insertResponse);        
        /*if (leadDetail.No_of_Attempts__c == Null) {
            leadDetail.No_of_Attempts__c = 0;
            leadDetail.First_Call_Attempt__c = System.now();
        }
        if (leadDetail.No_of_Attempts__c == 0){
            leadDetail.First_Call_Attempt__c = System.now(); 
        }
        NGCC_QA_and_Lead_Mapping__c myCSStatus = NGCC_QA_and_Lead_Mapping__c.getValues(response.Status__c);
        if(myCSStatus != Null){
            if (myCSStatus.Lead_Status__c != Null && myCSStatus.Lead_Status__c != '') {
                leadDetail.Status = myCSStatus.Lead_Status__c;
            }
        }
        leadDetail.No_of_Attempts__c = leadDetail.No_of_Attempts__c + 1;
        leadDetail.Latest_Agent_Notes__c = response.Notes__c;
        Database.SaveResult updateLead = Database.Update(leadDetail, false);*/
    }

    /* @method: Allowing user to launch the call script after creating response and response detail and passing requried information via URL Parameter */
    public void launchCallScript() {
        Boolean launchCallScriptFlag = validateSelectedCallScript(); //Added to validate the selected call script # PBI000000047279 - Awnish
        if(launchCallScriptFlag){
        //SCAVA
            if(flsGet(CC_Response__c.Status__c)){ 
            response.Status__c = '';
            }
            if(flsGet(CC_Response__c.Call_Script_Executed__c)){
            response.Call_Script_Executed__c = true;
           }
        //SCAVA         
            insertResponse();
            responseManagement(leadDetail, response);
            List < String > langcode = response.language__c.split(': ');
            String redirectURL = '/apex/Ngcc_CallScript?Id=' + leadDetail.Id + '&ResponseId=' + response.id + '&lang=' + langcode[1];
            if (isInConsoleMode){
                redirectConsoleURL = redirectURL + '&console=true';
                //scava Changes made by dchamola
                //outputText = 'Please wait..<script>changeSubtab();</script>';
                textToBeDisplayedAtStart = 'Please wait...';
                textToBeDisplayedAtEnd = '';
                windowHrefUrl = '';
                outputText = 'changeSubtab();';
            } else {
                //outputText = 'Call Script is Launching..<script>window.top.location.href =\'' + redirectUrl + '\'</script>';
                textToBeDisplayedAtStart = 'call script is launching...';
                textToBeDisplayedAtEnd = '\'';
                windowHrefUrl = 'window.top.location.href =\'';
                outputText = redirectUrl;
                //scava End 
            }
          }
        }

    /* @method to create or update response detail depending on criteria
    //        1) if Resposne Detail doesnt exist then create the response detail based on the call script
    //        2) if Response Detail exist but not part of SFDC(meaning came from MODS then assign existing response against the call script Q&A
    //        3) if Response Detail exist but part of SFDC then Reparent the reponse detail */
    public void responseManagement(Lead record, CC_Response__c response) {
        LIST < CC_Response__c > responseExist = [select Call_Script_Executed__c, Id from CC_Response__c where Lead__c =:record.Id AND Id !=:response.Id AND No_of_Question__c > 0 Order by LastModifiedDate Desc LIMIT 1];
        if (responseExist.isEmpty()) {
            createCallScript(response, True);
            Database.SaveResult[] insertResponseDetail = Database.insert(newResDetail, false);
        } else if (responseExist[0].Call_Script_Executed__c) {
            reparentCallScript(response, responseExist[0].Id);
        } else {
           createCallScript(response, True);
            createCallScriptWithExistingResponse(newResDetail, responseExist[0].Id);
            Database.SaveResult[] insertExistingResponseDetail = Database.insert(newResDetail, false);
        }
    }

    /* @method: Preparing the new response detail with almost cloning Call Script Q&A */
    public void createCallScript(CC_Response__c response, Boolean firstResponse) {
        try{
       if(response.Call_Script__c != Null){
        Lead leadPrepopulation = new Lead();
        List<Integer> intSeq= new List<Integer>();



        if (firstResponse) {
            leadPrepopulation = getLeadPrePopulation();
        }
        
        Map < String, NGCC_Response_Detail_To_Call_Script_Q_A__c > mapResDetailToCSQA = NGCC_Response_Detail_To_Call_Script_Q_A__c.getAll();
        string query = 'SELECT Id';
        for (NGCC_Response_Detail_To_Call_Script_Q_A__c csQ: mapResDetailToCSQA.values()) {
            query = query + ',' + csQ.Call_Script_Q_A_Field__c;
        }

        query = query + ',Validation_Both_Conditional_or_Required__c,CC_Master_Question_Bank__r.MODS_Question_Answer_Code__c from CC_Call_Script_Q_A__c where Call_Script__c = \'' + response.Call_Script__c + '\'';
  List < CC_Call_Script_Q_A__c > responseDetails = database.query(query);
         Set < String > setAnswer = new Set < String > ();
        integer seq=0;
        for (CC_Call_Script_Q_A__c r: responseDetails) {
            CC_Response_Detail__c newDetail = new CC_Response_Detail__c();


            for (String strResDetail: mapResDetailToCSQA.keyset()) {
                newDetail.put(strResDetail, r.get(mapResDetailToCSQA.get(strResDetail).Call_Script_Q_A_Field__c));
            }
            newDetail.put('Response_Id__c', response.Id);
            newDetail.put('Validation_Both_Conditional_or_Required__c', r.Validation_Both_Conditional_or_Required__c);

            // If this is the first reponse try to prepopulate the field
            if (firstResponse && mapQCodeField.containsKey(r.CC_Master_Question_Bank__r.MODS_Question_Answer_Code__c)) {


                if(r.Question_Type__c == 'Radio' || r.Question_Type__c == 'Picklist')
                {
                    if (r.Answer_Options__c != Null) {
                        intSeq.add(seq);
                        Set < String > strNewValue = new Set < String > (r.Answer_Options__c.split(','));
                        for (String optionName: strNewValue) {
                            optionName = Id.valueOf(optionName.subString(optionName.indexOf(':') + 1, optionName.length()));
                            setAnswer.add(optionName);
                        }

                    }
                }
                string strCR;

                if(r.Question_Type__c == 'DateTime' && leadPrepopulation.get(mapQCodeField.get(r.CC_Master_Question_Bank__r.MODS_Question_Answer_Code__c))!= NULL){
                    strCR = String.valueof(leadPrepopulation.get(mapQCodeField.get(r.CC_Master_Question_Bank__r.MODS_Question_Answer_Code__c)));
                    DateTime dt= datetime.valueOf(strCR);
                    strCR = String.ValueOf(dt.format());


                }else{
                    strCR = String.valueof(leadPrepopulation.get(mapQCodeField.get(r.CC_Master_Question_Bank__r.MODS_Question_Answer_Code__c)));
                }


                if(strCR == 'true'){
                    strCR = 'Yes';
                }else if(strCR == 'false'){
                    strCR = 'No';
                }else
                {
                    strCR = strCR;
                }


                if(r.Question_Type__c == 'Route To AM'){
                    newDetail.put('Route_To_AM__c',strCR);
                }else if(r.Question_Type__c == 'Route To Partner'){
                    newDetail.put('Route_To_Partner__c',strCR);
                }else if(r.Question_Type__c == 'Preferred Partner'){
                    newDetail.put('Preferred_Partner_Account__c',strCR);
                }else if(r.Question_Type__c == 'Route To PSR'){
                    newDetail.put('Route_To_PSR__c',strCR);
                }


                newDetail.put('Customer_Response__c', strCR );
                newDetail.put('Customer_Response_Detail__c', strCR);
                newDetail.put('Customer_Response_Detail_Local__c', strCR);
            }
            newResDetail.add(newDetail);
            seq++;
        }


        Map<String,Id> mapAnswerTextId = new Map<String,Id>();
        for(CC_Master_Question_Answer_Bank__c mQA: [Select Id,Answer_Text__c from CC_Master_Question_Answer_Bank__c where Id IN: setAnswer]){
            string strAnswerLower = mQA.Answer_Text__c.toLowerCase();
            mapAnswerTextId.put(strAnswerLower  ,mQA.Id);
        }


        for(integer i:intSeq){
            string strCusRes = newResDetail[i].Customer_Response__c;
            if(strCusRes != NULL){
                strCusRes = strCusRes.toLowerCase();
                if(mapAnswerTextId.containsKey(strCusRes))
                {
                    if(flsGet(CC_Response_Detail__c.Customer_Response__c)||flsUpdateGet(CC_Response_Detail__c.Customer_Response__c)){
                    newResDetail[i].Customer_Response__c = mapAnswerTextId.get(strCusRes );
                    }
                }
            }
        }
    }
        }catch(exception e){}
    }

    map < String, String > mapQCodeField = new map < String, String > ();

    /* @method: query all the lead detail whcih need to be prepopulated */
    public Lead getLeadPrePopulation() {
        Map < String, NGCC_QA_and_Lead_Mapping__c > mapLeadDetailQA = NGCC_QA_and_Lead_Mapping__c.getAll();
        string query = 'SELECT Id';
        for (NGCC_QA_and_Lead_Mapping__c lDetail: mapLeadDetailQA.values()) {
            if (lDetail.Purpose__c != null && lDetail.Purpose__c.contains('Lead')) {
                if (!query.contains(lDetail.FieldName__c) &&  !lDetail.FieldName__c.contains('Phone')) {
                    query = query + ',' + lDetail.FieldName__c;
                }
                
                mapQCodeField.put(lDetail.Name, lDetail.FieldName__c);
                
            }
        }
  query = query + ',Phone,MobilePhone,Route_to_AM__r.Email,ProgramEvent__c,Partner_Contact_Email__r.Email,';
        query = query + 'First_Call_Attempt__c,No_of_Attempts__c, Campaign_Name__r.Call_Script__c,Campaign_Name__r.Maximum_No_Attempts__c';
        query = query + ' FROM Lead WHERE Id = \'' + firstlead.Id + '\' LIMIT 1';
        return Database.query(query);
    }

    /* @method: Preparing the response detail if existing response detail received from MODS */
    public void createCallScriptWithExistingResponse(List < CC_Response_Detail__c > newResponseDetail, Id oldResponseId) {
        Map < String, CC_Response_Detail__c > mapOldResponseDetail = new Map < String, CC_Response_Detail__c > ();
        for (CC_Response_Detail__c oldResponseDetail: [Select Customer_Response__c, Customer_Response_Detail__c,
            CC_Master_Question_Answer_Bank__c from CC_Response_Detail__c WHERE
            Response_Id__c = : oldResponseId
        ]) {
            mapOldResponseDetail.put(oldResponseDetail.CC_Master_Question_Answer_Bank__c, oldResponseDetail);
        }
        for (CC_Response_Detail__c newRDObj: newResponseDetail) {
            if (mapOldResponseDetail.containsKey(newRDObj.CC_Master_Question_Answer_Bank__c)) {
                newRDObj.Customer_Response__c = mapOldResponseDetail.get(newRDObj.CC_Master_Question_Answer_Bank__c).Customer_Response__c;
            }
        }
    }

    /* @method: Reparent the response detail since this is new response for the same lead for which we already had tried to capture response */
    public void reparentCallScript(CC_Response__c newResponse, Id oldResponseId) {
        List < CC_Response_Detail__c > responseDetails = [select Response_Id__c from CC_Response_Detail__c where Response_Id__c = : oldResponseId];
        for (CC_Response_Detail__c r: responseDetails) {
            r.Response_Id__c = newResponse.Id;
            r.Completed__c = false;
        }
        Database.SaveResult[] updateResponseDetail = Database.update(responseDetails, false);
    }

    /**********************************************************Lead Approval Process**************************************************************/

    /* @method: Requalify the lead for approval process
     */
    public pageReference cmdRequalify() {
        //SCAVA
       if(flsGet(lead.Status)||flsUpdateGet(lead.Status)){
        firstlead.Status = 'New Prospect';
       }
       if(flsGet(lead.Call_Status__c)||flsUpdateGet(lead.Call_Status__c)){
        firstlead.Call_Status__c = '';
       }
       if(flsGet(lead.Outcome__c)||flsUpdateGet(lead.Outcome__c)){
        firstlead.Outcome__c = '';
       }//SCAVA
        Database.SaveResult updateRejLead = Database.update(firstlead, false);
        refreshPage = true;
        return null;

    }

    /* @method: Verifying whether approval controls need to shown based on logged in user or logged in user queue
    // @set the flag to ensure controls are displayed only when needed */
    public void approvalNeeded() {
        try {
            if (leadDetail.Status == 'Approval Pending') {
                User usr = [Select UserRole.Name from User where Id = : UserInfo.getUserId() LIMIT 1];
                if (usr.UserRole.name == NULL || !usr.UserRole.Name.contains('SDR')) {
                    system.debug('@@user role' + UserRole.Name);
                    map<Id,Group> mapIdGroup = new map<Id,Group>([SELECT Id from Group where RelatedId = : UserInfo.getUserRoleId()]);
                    LIST < GroupMember > actList = [SELECT GroupId from GroupMember where UserOrGroupId =: UserInfo.getUserId() OR
                                             UserOrGroupId IN : mapIdGroup.keySet()];
                    actId = new set<Id>();
                    if (actList.size() > 0) {
                        for(GroupMember g:actList){
                            actId.add(g.GroupId);
                        }
                    }

                    Integer i = [SELECT count()
                        FROM ProcessInstanceWorkItem
                        WHERE ProcessInstance.Status = 'Pending'
                        AND ProcessInstance.TargetObjectId = : firstlead.Id AND(ActorId IN : actId OR ActorId = : UserInfo.getUserId())
                        LIMIT 1
                    ];

                    if (i > 0) {
                        bAppReq = true;
                        showGeneric = false;
                    } else {
                        bAppReq = false;
                    }
                } else {
                    showGeneric = false;
                }
            }
        } catch (exception e) {
            bAppReq = false;
            showGeneric = false;
        }
    }

    /* @method: To process the record which are approved by approver
    //          1) If the Lead Theater is EMEAR , then if the approver is Site Manager then provide a lookup to assign next approver
    //          2) Else allow user to Approve the lead  */
    public pageReference cmdApprove() {
        try {
            if (firstlead.Theater__c == 'EMEAR') {
                List < UserRole > uRole = [Select Name from UserRole where Id = : UserInfo.getUserRoleId() LIMIT 1];
                List< UserRole > seniorAgentRole = [SELECT Id,name FROM UserRole WHERE Id IN (SELECT UserRoleId FROM User WHERE Id = : leadDetail.SDR_Lead_Owner_New__c ) limit 1];
                List<User> userMarketingCallCenter = [select id,Marketing_Call_Center__c from user where Id =: leadDetail.SDR_Lead_Owner_New__c limit 1];
                if (!uRole.isEmpty()) {
                    if (uRole[0].Name.contains('Site Manager')) {
                        if((!seniorAgentRole.isEmpty()) && userMarketingCallCenter[0].Marketing_Call_Center__c.contains('Convergys Manila - Global')){
                            bAppEMEAR = true;
                            bAppReq = false;
                        }else if((!seniorAgentRole.isEmpty()) && (seniorAgentRole[0].name.contains('Senior Agent') || seniorAgentRole[0].name.contains('SDR'))){
                            processApprovalRequest('Approve', 'Approved');
                            //outputText = '<script>window.top.location.reload();</script>';
                            //outputText = '<script>refreshPage();</script>';
                            //Changes made by dchamola
                            textToBeDisplayedAtStart = '';
                            textToBeDisplayedAtEnd = '';
                            windowHrefUrl = '';
                            outputText = 'refreshPage();';
                            //scava end
                        }else{
                        bAppEMEAR = true;
                        bAppReq = false;
                        }
                    } else {
                        processApprovalRequest('Approve', 'Approved');
                        //outputText = '<script>window.top.location.reload();</script>';
                        //outputText = '<script>refreshPage();</script>';
                        //scava changes made by dchamola
                        textToBeDisplayedAtStart = '';
                        textToBeDisplayedAtEnd = '';
                        windowHrefUrl = '';
                        outputText = 'refreshPage();';
                        //scava end
                    }
                } else {
                    processApprovalRequest('Approve', 'Approved');

                    //outputText = '<script>window.top.location.reload();</script>';
                    //outputText = '<script>refreshPage();</script>';
                    //scava changes made by dchamola
                    textToBeDisplayedAtStart = '';
                    textToBeDisplayedAtEnd = '';
                    windowHrefUrl = '';
                    outputText = 'refreshPage();';
                    //scava end
                }
            } else {
                processApprovalRequest('Approve', 'Approved');
            }
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error occured' + e.getMessage()));
        }
        return null;

    }

    /* @method: Allowing user submit the record for approval and initiaited approval process */
    public pageReference cmdSubmitForApproval() {
            //to check if lead was submitted by SDR already in console.
            Lead submittedLead = new Lead();
            submittedLead = [select id, status, email from lead where id =: leadDetail.Id];
                if(submittedLead.Status =='Approval Pending'){
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Info, 'Your Lead is sent to next approver already. Please refresh the "Tab" to see Lead Status.');
                    ApexPages.addMessage(msg);
                    //refreshPage = true;
                    return null;
                 
                    }
            
         try{
            if(leadDetail.Theater__c == 'APJ' && leadDetail.PL_CL_Flag__c ==null){
                 showAlert = 'Please enter PL/CL Flag.It is Mandatory for APJ theater leads ';
             }else{ 
            if (firstlead.Theater__c == 'APJ' || firstlead.Theater__c == 'Americas' || firstlead.Theater__c == 'Greater China'){
                  Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                  req1.setObjectId(firstlead.id);
                  Approval.ProcessResult result = Approval.process(req1);
                  refreshPage = true;
                 
            }
            else{
                UserId=Led.OwnerId;
                List < UserRole > uRole = [Select Name from UserRole where Id = : UserInfo.getUserRoleId() LIMIT 1];
                if(firstlead.Theater__c == 'EMEAR' && (leadDetail.Call_Center_Vendor__c == 'Convergys Manila - Global' || leadDetail.Lead_Qualifier_Call_Center__c=='Convergys Manila - Global')){
                    openInSameWindow = true;
                }else if(firstlead.Theater__c == 'EMEAR' && (uRole[0].Name.contains('Senior Agent') ||uRole[0].Name.contains('SDR') )){
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setObjectId(firstlead.id);
                    Approval.ProcessResult result = Approval.process(req1);
                    refreshPage = true;
                }else if(firstlead.Theater__c == 'EMEAR'){
                    openInSameWindow = true;
                    }
                } 
          }      
        } catch (Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error occured' + e.getMessage()));
        }
        
            return null;
    }

    /* @method: Allowing user to submit of the record for sending the lead to sales and update some lead attributes. */
    public pageReference cmdSendToSales() {
        // Added by Awnish to check PL/CL flag for Convergys Suzhou China - PBI000000046290
       try {
            if(leadDetail.Call_Center_Vendor__c == 'Convergys Suzhou China' && leadDetail.PL_CL_Flag__c ==null){
                showAlert = 'Please enter PL/CL Flag. ';

            } else {
                Id mktgLeadRecType;
                ObjectRecordTypeIds__c orgConstant = ObjectRecordTypeIds__c.getInstance(); // initiate custom setting contain object record type
                mktgLeadRecType = orgConstant.Marketing_Qualified_Lead__c; // assign marketing lead recordtype to variable
                //SCAVA
                if(flsGet(lead.Status)||flsUpdateGet(lead.Status)){
                firstlead.Status = 'Send to Sales';
                }
                if(flsGet(lead.Submitted_to_Sales_Date__c)||flsUpdateGet(lead.Submitted_to_Sales_Date__c)){
                firstlead.Submitted_to_Sales_Date__c = system.today();
                }
                if(flsGet(lead.RecordTypeId)||flsUpdateGet(lead.RecordTypeId)){
                firstlead.RecordTypeId = mktgLeadRecType;
                }
                if(flsGet(lead.Cisco_Rec_PSR__c)||flsUpdateGet(lead.Cisco_Rec_PSR__c)){
                firstlead.Cisco_Rec_PSR__c = null;
                }
                if(flsGet(lead.Channel_Partner__c)||flsUpdateGet(lead.Channel_Partner__c)){
                firstlead.Channel_Partner__c = null;
                }
                if(flsGet(lead.Rejected_Reason_Details__c)||flsUpdateGet(lead.Rejected_Reason_Details__c)){
                firstlead.Rejected_Reason_Details__c = null; 
                }
                //SCAVA
                Database.SaveResult updateLead = Database.update(firstlead, false);
                refreshPage = true;

            }
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error occured' + e.getMessage()));
        }
        return null;
    }


    /* @method: Invoke rejection process if the approver not satisified with lead detail and displaying rejected reason */
    public void cmdReject() {
        try {

            if (leadDetail.Medium_Type__c == 'Inbound Chat' && firstlead.Theater__c == 'APJ' && leadDetail.Call_Center_Vendor__c == 'Convergys Manila - Global'){
                  //SCAVA
                  if(flsGet(lead.ownerid)||flsUpdateGet(lead.ownerid)){
                  firstlead.ownerid = leadDetail.lead_qualifier__c;
                  }//SCAVA
                  update firstlead;
            }
            bAppReject = true;
            bAppReq = false;
            showGeneric = false;
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error occured' + e.getMessage()));
        }
    }

    /* @method: Allowing user to cancel the lead if approver feel the lead is nowhere valid */
    public void cmdCancel() {
        try {
            bAppReject = true;
            bAppReq = false;
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error occured' + e.getMessage()));
        }
    }

    /* @method: Process the rejection detail */
    public void processApprovalRejected() {
        try {
            processApprovalRequest('Reject', rejectReason);
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error occured' + e.getMessage()));
        }
    }

    //@method Process the EMEAR approval 
    public void processApprovalEMEAR() {
        processApprovalRequest('Approve', nextApproval);
    }
    
    
    /* @method: Process the rejection detail and update the detail with rejected detail */
    public void processApprovalRequest(String strAction, String strComment) {
    
        try {
            
            List < ProcessInstanceWorkItem > items = [SELECT Id
                FROM ProcessInstanceWorkItem
                WHERE ProcessInstance.Status = 'Pending'
                AND ProcessInstance.TargetObjectId = : firstlead.Id AND(ActorId = : actId OR ActorId = : UserInfo.getUserId())
                LIMIT 1
            ];

            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setAction(strAction);
            req.setNextApproverIds(new Id[] {UserInfo.getUserId()});//added by Bapu
            req.setComments(strComment.abbreviate(4000));
            req.setWorkitemId(items[0].Id);
            
            if (strAction != 'Approve') {
                 //SCAVA
                if(flsGet(lead.Rejected_Reason_Details__c)||flsUpdateGet(lead.Rejected_Reason_Details__c)){
                firstlead.Rejected_Reason_Details__c = strComment.abbreviate(4000);
                }
                if(flsGet(lead.Status)||flsUpdateGet(lead.Status)){
                firstlead.Status = 'Rejected';
                }//SCAVA
                
                 ////APJ : Sellbytel Sydney Australia & Sellbytel Kuala Lumpur CCM queue Setup - Fazurulla 03FEB17
                if (leadDetail.Theater__c == 'APJ' &&
                   ((leadDetail.Call_Center_Vendor__c == 'Sellbytel Sydney Australia'||leadDetail.Lead_Qualifier_Call_Center__c =='Sellbytel Sydney Australia') ||
                   (leadDetail.Call_Center_Vendor__c == 'Sellbytel Kuala Lumpur'||leadDetail.Lead_Qualifier_Call_Center__c =='Sellbytel Kuala Lumpur'))){
                    Map<String,NGCC_CCM_Requalification__c> ccmId = NGCC_CCM_Requalification__c.getAll();
                    if(ccmId.containsKey(leadDetail.Call_Center_Vendor__c) || ccmId.containsKey(leadDetail.Lead_Qualifier_Call_Center__c)){
                        if(String.isNotBlank(leadDetail.Call_Center_Vendor__c)){
                            firstlead.OwnerId = ccmId.get(leadDetail.Call_Center_Vendor__c).CCMQueueId__c;
                        }else if(String.isNotBlank(leadDetail.Lead_Qualifier_Call_Center__c)){
                            firstlead.OwnerId = ccmId.get(leadDetail.Lead_Qualifier_Call_Center__c).CCMQueueId__c;
                        }
                    }
                }else{ 
                    //SCAVA
                    if(flsGet(lead.OwnerId)||flsUpdateGet(lead.OwnerId)){               
                    firstlead.OwnerId = leadDetail.SDR_Lead_Owner_New__c; //APJC User Setup - MUKESH/SHIVA 19DEC14
                    }
                    }//SCAVA
                Database.SaveResult updateRejLead = Database.update(firstlead, false);
            }

            if (strAction == 'Approve' && strComment != 'Approved') {
                req.setNextApproverIds(new Id[] {strComment});//added by Bapu
                req.setComments('Approved');
            }
            Approval.ProcessResult result = Approval.process(req);
            
            
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error occured' + e.getMessage()));
        }
    }

    /**********************************************************Response and Call Script*************************************************************/

    /* @method: Encode URL to be passed when we user select refer a contact */
    public String encodeURL(String str) {
        String encodedString = str;
        if (str != NULL) {
            encodedString = EncodingUtil.urlEncode(str, 'UTF-8');
        } else {
            encodedString = '';
        }
        return encodedString;
    }
    
    //@method for Emear approval process when user submits for approval and manually choosing next approver.
    public PageReference assignvalue()
    {
         UserId=Led.OwnerId;
         Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
         req1.setObjectId(Leaddetail.id);
         if(UserId != null)
         req1.setNextApproverIds(new Id[] {UserId});
         Approval.ProcessResult result = Approval.process(req1);
         //refreshPage = true;
         
         
         PageReference acctPage = new PageReference('/'+leadDetail.id);
         acctPage.setRedirect(true);
         return acctPage;
    
    }
    //@method for drop down menu when creating a response, ghost chat/ghost call selected note dropdown menu will appear.
    public List<SelectOption> getCustomPicklistForNotes () {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('- Not Specified -','- Not Specified -'));
            options.add(new SelectOption('Technical Support','Technical Support'));
            options.add(new SelectOption('Customer Service','Customer Service'));
            options.add(new SelectOption('Other - Chat','Other - Chat'));
            options.add(new SelectOption('Partner','Partner'));
            options.add(new SelectOption('System Integrator','System Integrator'));
            options.add(new SelectOption('Complaint','Complaint'));
            options.add(new SelectOption('Customer Dropped Off','Customer Dropped Off'));
            options.add(new SelectOption('Customer Followed Up','Customer Followed Up'));
            options.add(new SelectOption('Customer made bad call','Customer made bad call'));
            return options;
    }
    /* added by gchaitha to remove "Qualified Lead" value from disposition dropdown */
    public List<SelectOption> getPickLstValue(){       
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = CC_Response__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('', '--None--')); 
        for(Schema.PicklistEntry f : ple) {            
            if(f.getValue() != 'Qualified Lead' && f.getValue() != 'Immediate Timeframe'){                
                options.add(new SelectOption(f.getValue(), f.getLabel()));                
            }            
        }         
        return options;                   
    }
}