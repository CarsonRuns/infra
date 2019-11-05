/************************************************************************************************************************************
Name    : NGCC_CallScript_CTE
Author  : Mukesh Srivastava
Purpose : This is the main controller class for Call Script Solution. This controller class handles Q&A generation, 
            translation,validation, routing and overall call script requirement
Created Date: 3/30/2014
Modification History: 

Author  : Ghattamaneni Chaithanya
Purpose : Adding Dispostion Sub Type field to page
            Added to save the Selected Disposition Sub Type value Line No#328
            Displaying the Disposition Sub Type field based on Disposition value Line NO#637-643
            Added a method to validate the customer response for "Qualified Lead" or Immediate Timeframe" Dispositions Line No#464-491,498-504
date    : July 16,2018

Author  : Ghattamaneni Chaithanya
Purpose : Updated Outcome values to display Sub-Otcome - US291144
		  Line no: 730-736	
date    : June 13,2019
*************************************************************************************************************************************/
global class NGCC_CallScript_CTE {
 
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
    
    Public List < CC_Response_Detail__c > lstQuestion {get; set;}
    Public CC_Response__c responseObj {get; set;}
    Public Id leadId {get; set;}

    Public String dispositionStatus {get; set;}
    Public String strOthers {get; set;}
    public Boolean DescriptionShow {get; set;}

    Public List < String > checkboxSelections1 {get; set;}
    Public List < String > checkboxSelections2 {get; set;}
    Public List < String > checkboxSelections3 {get; set;}
    Public List < String > checkboxSelections4 {get; set;}
    Public List < String > checkboxSelections5 {get; set;}
    Public List < String > checkboxSelections6 {get; set;}
    Public List < String > checkboxSelections7 {get; set;}
    Public List < String > checkboxSelections8 {get; set;}
    Public List < String > checkboxSelections9 {get; set;}
    Public List < String > checkboxSelections10 {get; set;}
    Public List < String > setResponse {get; set;}
    //Deepak: Scava Fixes
    public String setResponse1{
    get{
        for(string s:setResponse){
            setResponse1 += s;
            }
            return setResponse1;
    }
    private set;
    }
    //Scava Fix End
    
    Public String strRouteToPartnerTXT {get;set;}
    Public String strRouteToAMTXT {get;set;}
    Public String strRouteToPSRTXT {get;set;}
    Public String strPreferredPartnerTXT {get;set;}
    
    Public Boolean showComment {get; set;}
    Public DateTime callBackTime {get; set;}
    Public String responseId;
    Static String langCode;
    public final String consoleMode;

    Private final Lead firstlead;
    Private Lead leadDetail;
    
    Public Boolean showComment1 {get; set;}
    public String notesStorage {get;set;}

    List < Integer > lstValidationQA = new List < Integer > ();
    List < String > lstErrors = new List < String > ();

    Set < Integer > setMultiSelect = new Set < Integer > ();

    Map < String, String > mapQATranslation = new Map < String, String > ();
    Map < Id, Integer > mapQA = new Map < Id, Integer > ();
    Map < Id, CC_Master_Question_Answer_Bank__c > mapAnswer = new Map < Id, CC_Master_Question_Answer_Bank__c > ();

    String callScriptError;
    String newDescription;
    Integer selResponse = 0;
    Integer errorCount = 0;
    String plzSelOne;
    public string defaulterror;
    public boolean showDispSubtype {get; set;}
   
    /* Constructor to get the list of Q&A for a call script and translation from Response Detail */
    public NGCC_CallScript_CTE(ApexPages.StandardController controller) {
        defaulterror = 'Input Requried for';
        this.firstlead = (Lead) controller.getRecord();
        langCode = ApexPages.currentPage().getParameters().get('lang');
        leadId = ApexPages.currentPage().getParameters().get('Id');
        responseId = ApexPages.currentPage().getParameters().get('ResponseId');
        consoleMode = ApexPages.currentPage().getParameters().get('console');
        if (consoleMode == null)
            consoleMode = 'false';
        responseObj = new CC_Response__c();
        if(flsGet(CC_Response__c.Status__c)||flsUpdateGet(CC_Response__c.Status__c)){
        responseObj.Status__c = '-- None --';
        }
        DescriptionShow = false;
        
        string queryString = 'SELECT ';
        for (Schema.FieldSetMember f: SObjectType.CC_Response_Detail__c.FieldSets.NGCCCallScriptQuery.getFields()) {
            queryString += f.getFieldPath() + ', ';
        }
        queryString += 'CC_Master_Question_Answer_Bank__r.MODS_Question_Answer_Code__c,Id FROM CC_Response_Detail__c WHERE Response_Id__c =\'' + String.escapesinglequotes(responseId)  +'\' ORDER BY Question_Category__c, Sequence__c NULLS LAST' ;            
                        
        lstQuestion = Database.Query(queryString);
        system.debug(queryString);

        if (ApexPages.currentPage().getParameters().get('Preview') != 'Yes') {
            leadDetail = [Select Id, Latest_Lead_Acceptance_Date__c, Partner_Lead_Status__c, Email,DedupeRecord__c,DeduperProcessing__c, Name, GUTC_COOKIE_ID__c, Status, Company, CustomCity__c, CustomState__c, CustomZip__c,Address_Line_1__c ,Address_Line_2__c ,Address_Line_3__c,
                Route_to_AM__r.Email, Campaign_Name__c, ProgramEvent__c, Partner_Contact_Email__r.Email,
                Description, No_of_Attempts__c, Campaign_Name__r.Call_Script__c, Campaign_Name__r.Maximum_No_Attempts__c,Medium_Type__c,
                CustomCountry__c from Lead where Id = : firstlead.Id limit 1];
                system.debug(leadDetail.GUTC_COOKIE_ID__c);
        }
        getTranslation();
    }
    // method: Returns string value of an Id
    public string getOptionId(String strOption){
        string strId = strOption.subString(strOption.indexOf(':') + 1, strOption.length());
        if(strId.length()>14){
            strId = strId;
        }else{
            strId = 'Not Valid';
        }               
        return strId;
    }
    
    /*  method: Get Translations for list of question and answer depending upon available if not available show in english */
    public void getTranslation() {
        Set < String > setAnswer = new Set < String > ();
        Set < String > SetQuestion = new Set < String > ();
        CC_Master_Question_Answer_Bank__c idPSO = [Select Id from CC_Master_Question_Answer_Bank__c where MODS_Question_Answer_Code__c = 'Please_Select_One'
            LIMIT 1];
        plzSelOne = idPSO.id;
        setAnswer.add(plzSelOne);

        Integer i = 0;
        for (CC_Response_Detail__c cc: lstQuestion) {
            mapQA.put(cc.CC_Master_Question_Answer_Bank__c, i);
            if (cc.Question_Type__c == 'Radio' || cc.Question_Type__c == 'Picklist' || cc.Question_Type__c == 'MultiSelect') {
                if (cc.Answer_Options_Id__c != Null) {
                    Set < String > strNewValue = new Set < String > (cc.Answer_Options_Id__c.split(','));
                    for (String optionName: strNewValue) {
                        string strOptId = getOptionId(optionName);
                        if(strOptId != 'Not Valid'){
                            setAnswer.add(Id.valueOf(strOptId));
                        }
                    }
                }

                if (cc.Question_Type__c == 'MultiSelect') {
                    setMultiSelect.add(i);
                }
            }
            setQuestion.add(cc.CC_Master_Question_Answer_Bank__c);
            i++;
        }

        mapAnswer = new Map < Id, CC_Master_Question_Answer_Bank__c > ([SELECT ID, Answer_Text__c, MODS_Question_Answer_Code__c from CC_Master_Question_Answer_Bank__c WHERE Id IN: setAnswer]);


        for (CC_Question_Answer_Translations__c qaTrans: [SELECT CC_Master_Question_Answer_Bank__c, Answer_Text__c, Name,
            Language__c, Language_Code__c, Id, Translated_Value__c
            FROM CC_Question_Answer_Translations__c where
            Language_Code__c = : langCode
            AND(CC_Master_Question_Answer_Bank__c IN: setAnswer OR CC_Master_Question_Answer_Bank__c IN: setQuestion)]) 
        {
            mapQATranslation.put(qaTrans.CC_Master_Question_Answer_Bank__c, qaTrans.Translated_Value__c);
            setQuestion.remove(qaTrans.CC_Master_Question_Answer_Bank__c);
            setAnswer.remove(qaTrans.CC_Master_Question_Answer_Bank__c);
        }

        for (CC_Question_Answer_Translations__c qaTrans: [SELECT CC_Master_Question_Answer_Bank__c, Answer_Text__c, Name,
            Language__c, Language_Code__c, Id, Translated_Value__c
            FROM CC_Question_Answer_Translations__c where
            Language_Code__c = 'en_US'
            AND(CC_Master_Question_Answer_Bank__c IN: setAnswer OR CC_Master_Question_Answer_Bank__c IN: setQuestion)]) 
        {
            mapQATranslation.put(qaTrans.CC_Master_Question_Answer_Bank__c, qaTrans.Translated_Value__c);
            setQuestion.remove(qaTrans.CC_Master_Question_Answer_Bank__c);
            setAnswer.remove(qaTrans.CC_Master_Question_Answer_Bank__c);
        }
    }

    /*  method: Generate List of select Options for renedering */
    public component.apex.selectOption getSelectOption(String label, String value) {
        component.apex.selectOption opt = new component.apex.selectOption();
        opt.itemLabel = label;
        opt.itemValue = value;
        return opt;
    }

    /*  method: Generating main Call Script UI with variant of Question along with its associated Tabs */
    public  Component.Apex.PageBlock getCreateDynamicComponent() {
        Component.Apex.PageBlock pB = new Component.Apex.PageBlock();
        
        setResponse = new List < String > ();
        List < String > strPG;
        Integer curMultiSelect = 0;
        
        // Adding Tab panel to the page
        component.Apex.tabPanel pTabPanel = new component.Apex.tabPanel(switchType = 'client', selectedTab = 'tab0', id = 'AccountTabPanel', tabClass = 'activeTab', inactiveTabClass = 'inactiveTab');
        pB.childComponents.add(pTabPanel);
        

        try {
            // Getting and processing the all the tabs based on Q&A Categories 
            strPG = new List < String > (lstQuestion[0].Question_Categories__c.split(','));

            for (Integer j = 0; j < strPG.size(); j++) {

                // Adding tabs to the tab panel
                component.Apex.tab pgTab = new component.Apex.tab(label = strPG[j], name = 'tab' + j, style = 'border:0px;background-color: white;height:120px;');
                pTabPanel.childComponents.add(pgTab);

                // Adding Page Block Section with 2 Column first column to show Question next Answers
                component.Apex.PageBlockSection pg = new component.Apex.PageBlockSection(Columns = 2);
                pgTab.childComponents.add(pg);

                Map < Id, String > mapDepended = new Map < Id, String > ();
                Integer sr = 1;

                // Looping the list of Questions and assigning to tab in context
                for (Integer i = 0; i < lstQuestion.size(); i++) {
                    if (lstQuestion[i].Question_Category__c.contains(strPG[j])) {
                        Component.Apex.OutputLabel label;
                        sr = i + 1;

                        // Question to the Section. If the translation exists then add the translated text else show the english
                        if (mapQATranslation.containsKey(lstQuestion[i].CC_Master_Question_Answer_Bank__c)) {

                            String strText = mapQATranslation.get(lstQuestion[i].CC_Master_Question_Answer_Bank__c);
                            String visibleText = strText;
                            if (consoleMode != 'false'){
                                   strText = strText.replace('\'', '\\\'');
                                   strText = '<a onclick="agentQuery(\''+strText+'\');return false;">' + visibleText + '</a>';
                            }
                            if (lstQuestion[i].required__c) {
                                label = new Component.Apex.OutputLabel(Value = sr + '. ' + strText + '<font color=red size=5>  *</font>', escape = false, style = 'font-size:12px;');
                            } else if (lstQuestion[i].Question_Required__c != NULL) {
                                String encodedStr;
                                if (lstQuestion[i].Help_Text__c != NULL) {
                                    encodedStr = 'Conditionally&nbsp;Requried:' + lstQuestion[i].Help_Text__c.replaceAll(' ', '&nbsp;');
                                }
                                label = new Component.Apex.OutputLabel(Value = sr + '. ' + strText + '<font color=red>  <img src=/img/alohaSkin/help_orange.png title=' + encodedStr + '/></font>', escape = false, style = 'font-size:12px;');
                            } else {
                                 label = new Component.Apex.OutputLabel(Value = sr + '. ' + strText, escape = false, style = 'font-size:12px;');
                            }
                        }
                        
                        if(label != NULL){
                            pg.childComponents.add(label);
                        } else {
                             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,
                                        'Please verify Call Script Q&A . <b>'+lstQuestion[i].Name+ 
                                        '</b> may be missing: <br/> &nbsp;&nbsp;Master Q&A Missing OR<br/>'+
                                        '&nbsp;&nbsp;Master Question English Translation is missing'));
                        }
                        
                        String strQuesType = lstQuestion[i].Question_Type__c.replaceAll('/| ', '_');
                        String strMODSCode = lstQuestion[i].CC_Master_Question_Answer_Bank__r.MODS_Question_Answer_Code__c.replaceAll('/| ', '_');

                        if (strQuesType == 'Text' || strQuesType == 'Number' || strQuesType == 'Email' || strQuesType == 'DateTime' || strQuesType == 'Long_Text') {
                            pg.childComponents.add(getTextQuestion(i, strQuesType, strMODSCode));
                        } else if (strQuesType == 'Radio') {
                            pg.childComponents.add(getRadioQuestion(i, strQuesType, strMODSCode));
                        } else if (strQuesType == 'Picklist') {
                            pg.childComponents.add(getPicklistQuestion(i, strQuesType, strMODSCode));
                        } else if (strQuesType.contains('Route')) {
                            pg.childComponents.add(getRoutingQuestion(i, strQuesType, strMODSCode));
                        } else if (strQuesType.contains('Preferred_Partner')) {
                            pg.childComponents.add(getRoutingQuestion(i, strQuesType, strMODSCode));
                        } else if (strQuesType == 'Country') {
                            pg.childComponents.add(getCountryQuestion(i, strQuesType, strMODSCode));
                        } else if (strQuesType == 'MultiSelect') {
                            curMultiSelect = curMultiSelect + 1;
                            Component.Apex.outputPanel MultiOP = new Component.Apex.outputPanel();
                            pg.childComponents.add(MultiOP);
                            MultiOP.childComponents.add(getMultiSelectQuestion(i,curMultiSelect, strQuesType, strMODSCode));
                            pg.childComponents.add(MultiOP);
                        }
                    }
                }
            }
            return pB;
        } catch (Exception e) {
            // If there is any error associated to Q&A generation then display the error with proper cause and location
            string strError = '<br/>Sorry. We are unable to launch Call Script may be due to following reasons <br/>';
            strError = strError + '1) Associated Call Script is either not Active or missing Q&A detail. <br/> ';
            strError = strError + '2) Please validate all Question Text, Questions Type, Question Category, Master Q&A Libraries including Translation details associated to Call Script.';
            strError = strError + '<br/><br/> --  If problem persist then contact administrator with this error. <b>' + e.getStackTraceString() + '</b> due to <br/><b>' + e.getCause() + '</b> causing error<b> ' + e.getMessage() + '</b>';
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, strError));
            return null;
        }
    }

    public PageReference returnToLead(){
        PageReference leadPage = new PageReference('/' + leadId);
        leadPage.setRedirect(true);
        return leadPage;
    }

    /* @ method: Submit the call script and validate the response detail before submission
    //          1) If Call In Progress then error out as this is not a valid disposition value
    //          2) If Call Back make sure call back datetime is future date
    //          3) If Qualified Lead,Responed,Partner Rep Talk or immediate timefram the ensure all validation fire and if error found display the error to user
    //          4) If Refer a Contact, then redirect the user to Search for Existing Contact UI
    //          5) During Preview just validate the response and complition then delete the response */
    public pageReference cmdSubmitCallScript() {
    try{
        lstErrors.clear();
        errorCount = 0;
        newDescription = '';
        integer errorCount = processResponseDetail();
        if (responseObj.Status__c == '-- None --') {
            errorCount = 1;
            lstErrors.add('Please select Valid Disposition Value');
        } else if (responseObj.Status__c == 'Call Back' ) {
            if(callBackTime == NULL){
                errorCount = 1;
                lstErrors.add('Please provide Call Back Time');
            }else if(callBackTime < System.Now()) {
                errorCount = 1;
                lstErrors.add('Call Back Time must be  future date/time.');
            }            
        }
        for (Integer i: setMultiSelect) {
            multiSelectProcessing(i);
        }

        if (errorCount > 0) {
            lstErrors.sort();
            processError(lstErrors);
            return null;
        } else {
            if (ApexPages.currentPage().getParameters().get('Preview') != 'Yes') {
                NGCC_QA_and_Lead_Mapping__c myCSStatus = NGCC_QA_and_Lead_Mapping__c.getValues(responseObj.Status__c);
                if(flsGet(CC_Response__c.Status__c)||flsUpdateGet(CC_Response__c.Status__c)){
                responseObj.Status__c = responseObj.Status__c;
                }
                /*responseObj.Call_Status__c = myCSStatus.Call_Status__c;
                responseObj.Call_Script_Completed__c = true;
                // Added by gchaitha to save the Disposition Sub Type value
                responseObj.Disposition_Sub_Type__c = responseObj.Disposition_Sub_Type__c;*/
                
                //SCAVA FIX
                if(flsGet(CC_Response__c.Call_Status__c)||flsUpdateGet(CC_Response__c.Call_Status__c)){
                responseObj.Call_Status__c = myCSStatus.Call_Status__c;
                }
                if(flsGet(CC_Response__c.Call_Script_Completed__c)||flsUpdateGet(CC_Response__c.Call_Script_Completed__c)){
                responseObj.Call_Script_Completed__c = true;
                }
                // Added by gchaitha to save the Disposition Sub Type value
                if(flsGet(CC_Response__c.Disposition_Sub_Type__c)||flsUpdateGet(CC_Response__c.Disposition_Sub_Type__c)){
                responseObj.Disposition_Sub_Type__c = responseObj.Disposition_Sub_Type__c;  
                }
                //SCAVA FIX
                
                Database.SaveResult[] updateResponseDetail = Database.Update(lstQuestion, false);
                processResponse();
                               
                
                //@ Start Dedupe Process for inbound call and chat
                string LeadId = ApexPages.currentPage().getParameters().get('id');
                list<Lead> leadlistUpdated = [select id,Status from Lead where id =:LeadId];
                if(leadlistUpdated.size() >0){
                    if(flsGet(lead.Status)||flsUpdateGet(lead.Status)){
                        leadDetail.Status = leadlistUpdated[0].Status;
                    }
                }                
                List<CC_Response__c> tempResponses = [Select id,Response_Type__c,Lead__c,Lead_Description__c from CC_Response__c where Lead__C = :LeadId order by CreatedDate desc Limit 1];
                
                for(CC_Response__c tempResponse: tempResponses ){
                    //leadDetail.DedupeRecord__c = null;
                    if(flsGet(Lead.Description)||flsUpdateGet(Lead.Description)){
                    leadDetail.Description = tempResponse.Lead_Description__c;
                    }
                    if(tempResponse.Response_Type__c == 'Inbound Call'){
                           if(flsGet(Lead.Medium_Type__c)||flsUpdateGet(Lead.Medium_Type__c)){
                           leadDetail.Medium_Type__c = 'Inbound Call';
                           }
                       }else if(tempResponse.Response_Type__c == 'Inbound Chat'){
                           leadDetail.Medium_Type__c = 'Inbound Chat';
                       }
                }
                List<Lead> thisLead = new List<Lead>();
                System.debug('>>><<<'+leadDetail.Medium_Type__c + 'DeduperRecord' +leadDetail.DedupeRecord__c);
                if((leadDetail.Medium_Type__c == 'Inbound Call' || leadDetail.Medium_Type__c == 'Inbound Chat') && leadDetail.DedupeRecord__c != null){
                    System.debug('Condition Satisified>>><<<'+leadDetail.Medium_Type__c +'DeduperRecord' +leadDetail.DedupeRecord__c);
                    if(flsGet(Lead.DeduperProcessing__c)||flsUpdateGet(Lead.DeduperProcessing__c)){
                    leadDetail.DeduperProcessing__c = true;
                    }
                    if(flsGet(Lead.DedupeRecord__c)||flsUpdateGet(Lead.DedupeRecord__c)){
                    leadDetail.DedupeRecord__c = null;
                    }
                    thisLead.add(leadDetail);
                }
                if(thisLead.size() > 0){
                    system.debug('thisLead.Outcome__c=='+thisLead[0].Status);
                    system.debug('LeadDetails'+thisLead);
                    NGCC_Lead_Deduper.leadDeduper(thisLead);
                }
                //@End of Dedupe process for inbound call and chat
                
                    if (responseObj.Status__c != 'Refer a New Contact') {
                        PageReference leadPage = new PageReference('/' + leadId);
                        leadPage.setRedirect(true);
                        return leadPage;
                    } else {                    
                        return redirectToSearch();
                    }
            } else {
                responseObj.Id = ApexPages.currentPage().getParameters().get('ResponseId');
                if (CC_Response__c.sObjectType.getDescribe().isDeletable()){
                Delete responseObj;
                }
                PageReference ccPage = new PageReference(ApexPages.currentPage().getParameters().get('retURL'));
                return ccPage;
            }
        }
      }catch(exception e){
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
            return null;
          
      }
    }

    /* @ method: Process the response details
    //          1) Populate English,Non-English and Id customer response
    //          2) Validate the response detail before submitting the response and response detail
    //          3) Append Q&A based on predefined Q&A to Lead Description */
    public integer processResponseDetail() {
    /*responseObj.Id = ApexPages.currentPage().getParameters().get('ResponseId');
        responseObj.Call_Back_time__c = callBackTime;
        responseObj.Notes__c = notesStorage;*/
        
        selResponse = 0;
        integer errorcountRd = 0;
        for (CC_Response_Detail__c ccRd: lstQuestion) {
            // validate if validation is required
            
            String QuestionCategory = ccRD.Question_Category__c.substring(2, ccRD.Question_Category__c.length());

            NGCC_QA_and_Lead_Mapping__c csStatus = NGCC_QA_and_Lead_Mapping__c.getValues('Call Script Completion');
            Set < String > setStatus = new Set < String > (csStatus.FieldValue__c.split(','));
            if (setStatus.contains(responseObj.Status__c)) {
                if (ccrd.Validation_Both_Conditional_or_Required__c == True || ccRD.Question_Required__c != NULL) {
                    errorcountRd = validateResponse(ccRd);
                }
            }

            if (errorcountRd == 0) {
                ccRd.Completed__c = true;
                if (ccRd.Translation_Required__c) {
                    if (ccRd.Customer_Response__c != '--Please Select--' && ccRd.Customer_Response__c != NULL) {
                        ccRd.Customer_Response_Detail__c = mapAnswer.get(ccRd.Customer_Response__c).Answer_Text__c;
                        ccRd.Customer_Response_Detail_Local__c = mapQATranslation.get(ccRd.Customer_Response__c);
                    } else {
                        ccRd.Customer_Response_Detail__c = '';
                    }
                } else {
                    if (ccRd.Question_Type__c != 'MultiSelect') {
                        if (ccRd.Customer_Response__c != '--Please Select--' && ccRd.Customer_Response__c != NULL &&
                                 !ccRd.Question_Type__c.contains('Route') && !ccRd.Question_Type__c.contains('Preferred Partner')) {
                            if(ccRd.Question_Type__c == 'DateTime'){
                                string srDTResponse = ccRd.Customer_Response__c;
                                DateTime dT = DateTime.parse(srDTResponse);
                                srDTResponse  = string.valueOf(dt.format());
                                ccRd.Customer_Response__c = srDTResponse ;
                                ccRd.Customer_Response_Detail__c = srDTResponse ;
                                ccRd.Customer_Response_Detail_Local__c = srDTResponse ;
                            }else{
                                ccRd.Customer_Response_Detail__c = ccRd.Customer_Response__c;
                                ccRd.Customer_Response_Detail_Local__c = ccRd.Customer_Response__c;
                            }
                            
                        } else if (ccRd.Question_Type__c.contains('Route')) {
                            if (ccRd.Question_Type__c == 'Route To Partner') {
                                ccRd.Customer_Response_Detail_Local__c = strRouteToPartnerTXT;
                                ccRd.Customer_Response_Detail__c = ccRd.Route_To_Partner__c;
                                ccRd.Customer_Response__c = ccRd.Route_To_Partner__c;

                            } else if (ccRd.Question_Type__c == 'Route To AM') {
                                ccRd.Customer_Response_Detail_Local__c = strRouteToAMTXT;
                                ccRd.Customer_Response_Detail__c = ccRd.Route_To_AM__c;
                                ccRd.Customer_Response__c = ccRd.Route_To_AM__c;

                            } else if (ccRd.Question_Type__c == 'Route To PSR') {
                                ccRd.Customer_Response_Detail_Local__c = strRouteToPSRTXT;
                                ccRd.Customer_Response_Detail__c = ccRd.Route_To_PSR__c;
                                ccRd.Customer_Response__c = ccRd.Route_To_PSR__c;
                            }
                        } else if(ccRd.Question_Type__c.contains('Preferred Partner')) {
                            ccRd.Customer_Response_Detail_Local__c = strPreferredPartnerTXT;
                            ccRd.Customer_Response_Detail__c = ccRd.Preferred_Partner_Account__c;
                            ccRd.Customer_Response__c = ccRd.Preferred_Partner_Account__c;
                        } else {

                            ccRd.Customer_Response_Detail__c = '';
                        }
                    }
                }
                                   
                if (ccRd.Required_on_Lead_Description__c == True) {
                    String qText = ccRd.Question_Text__c;
                    String aText = ccRd.Customer_Response_Detail__c;
                    newDescription = newDescription + '\r\nQ:' + qText + '<> A:' + aText + '; ';
                }
            }
        }
        return errorcountRd;
    }
    // added by gchaitha for validating customer response
    public Integer validateValues(CC_Response_Detail__c ccRD){
        String QuestionCategory = ccRD.Question_Category__c.substring(2, ccRD.Question_Category__c.length());
        if ((ccRD.Customer_Response__c == '' || ccRD.Customer_Response__c == '--Please Select--' || ccRD.Customer_Response__c == null)) {
             lstErrors.add(QuestionCategory + '.' + mapQATranslation.get(ccRD.CC_Master_Question_Answer_Bank__c));
                errorCount = errorCount + 1;    
        }else{
            List<CC_Master_Question_Answer_Bank__c> customerResponseList = [select Name from CC_Master_Question_Answer_Bank__c where id=:ccRD.Customer_Response__c];
            if(customerResponseList.size() > 0){
                defaulterror = 'Valid values required for Qualified Lead';
                String CustomerResponse= customerResponseList[0].Name;                
                if(ccRD.Question_Text__c == 'Do you have an upcoming network project or need (within 1 year)?' && CustomerResponse != 'YES'){
                    lstErrors.add(QuestionCategory + '.' + mapQATranslation.get(ccRD.CC_Master_Question_Answer_Bank__c));
                    errorCount = errorCount + 1;
                }else if(ccRD.Question_Text__c == 'When is your next networking project planned?' && ( CustomerResponse !='Now - 3 Months' && CustomerResponse != '4 - 6 Months' &&
                   CustomerResponse != '7 - 12 Months' && CustomerResponse != '0 - 4 MONTHS' &&  CustomerResponse != '5 - 12 MONTHS' && CustomerResponse != '0-4 MONTHS' && CustomerResponse != '5-12 MONTHS')){
                       lstErrors.add(QuestionCategory + '.' + mapQATranslation.get(ccRD.CC_Master_Question_Answer_Bank__c));
                       errorCount = errorCount + 1;                                                                                    
                }else if((ccRD.Question_Text__c == 'What is the approximate budget for this project?' || ccRD.Question_Text__c == 'What is your budget? Please check one only.') && (!CustomerResponse.contains('$'))){
                    lstErrors.add(QuestionCategory + '.' + mapQATranslation.get(ccRD.CC_Master_Question_Answer_Bank__c));
                    errorCount = errorCount + 1;
                }
            }
        }        
        return errorCount;
    }
    /* @ method: Validate Responses as defined in Call Script Q&A
    //          1) Validate Mandatory required and condition Requried
    //          2) Numeric Range Validation */
    public Integer validateResponse(CC_Response_Detail__c ccRD) {
        //Mandatory Required Questions
        String QuestionCategory = ccRD.Question_Category__c.substring(2, ccRD.Question_Category__c.length());
        // added by gchaitha to validate Mandatory fields for "Qualified Lead" or Immediate Timeframe" Disposition Values
        if(ccRD.Question_Type__C == 'Picklist' && (ccRD.Question_Text__c == 'Do you have an upcoming network project or need (within 1 year)?' || 
                                                   ccRD.Question_Text__c == 'When is your next networking project planned?' ||
                                                   ccRD.Question_Text__c == 'What is the approximate budget for this project?' ||
                                                   ccRD.Question_Text__c == 'What is your budget? Please check one only.')){
             errorCount =  validateValues(ccRD);           
        }else{
            if ((ccRD.Customer_Response__c == '' || ccRD.Customer_Response__c == '--Please Select--' || ccRD.Customer_Response__c == NULL)) {
                if (ccRD.Required__c) {
                    lstErrors.add(QuestionCategory + '.' + mapQATranslation.get(ccRD.CC_Master_Question_Answer_Bank__c));
                    errorCount = errorCount + 1;
                }
                
                if (ccRD.Question_Required__c != NULL) {
                    if (ccRD.Conditionally_Required_Criteria__c == 'NULL') {
                        if (lstQuestion[mapQA.get(ccRD.Question_Required__c)].Customer_Response__c == NULL) {
                            lstErrors.add(QuestionCategory + '.' + mapQATranslation.get(ccRD.CC_Master_Question_Answer_Bank__c));
                            errorCount = errorCount + 1;
                        }
                    } else if (ccRD.Conditionally_Required_Criteria__c == 'NOT NULL') {
                        if (mapQA.get(ccRD.Question_Required__c)!= null && lstQuestion[mapQA.get(ccRD.Question_Required__c)].Customer_Response__c != NULL) {
                            lstErrors.add(QuestionCategory + '.' + mapQATranslation.get(ccRD.CC_Master_Question_Answer_Bank__c));
                            errorCount = errorCount + 1;
                        }
                    } else {
                        Set < String > reqAnswer = new Set < String > (ccRD.Conditionaly_Required_If__c.split(','));
                        if (lstQuestion[mapQA.get(ccRD.Question_Required__c)].Customer_Response__c != NULL) {
                            if (reqAnswer.contains(mapAnswer.get(lstQuestion[mapQA.get(ccRD.Question_Required__c)].Customer_Response__c).Answer_Text__c)) {
                                lstErrors.add(QuestionCategory + '.' + mapQATranslation.get(ccRD.CC_Master_Question_Answer_Bank__c));
                                errorCount = errorCount + 1;
                            }
                        }
                    }
                }
            }
        }
        // Numberic Validation
        if (ccRD.Question_Type__c == 'Number' && ccRD.Minimum_If_Number_Validation__c != Null) {
            if (ccRD.Customer_Response__c != NULL) {
                double cusRes = double.valueOf(ccRD.Customer_Response__c);
                double MinVal = double.valueOf(ccRD.Minimum_If_Number_Validation__c);
                double MaxVal = double.valueOf(ccRD.Maximum_If_Number_Validation__c);

                if (cusRes >= MinVal && cusRes <= MaxVal) {

                } else {
                    lstErrors.add(QuestionCategory + '.' + mapQATranslation.get(ccRD.CC_Master_Question_Answer_Bank__c) + 'Enter value between ' + ccRD.Minimum_If_Number_Validation__c+ ' and ' + ccRD.Maximum_If_Number_Validation__c);
                    errorCount = errorCount + 1;
                }
            }
        }
        system.debug('lstErrors=='+lstErrors);
        return errorCount;
    }

    /* @ method: Process the response and update the response */
    public void processResponse() {
        /*responseObj.Id = ApexPages.currentPage().getParameters().get('ResponseId');
        responseObj.Call_Back_time__c = callBackTime;
        responseObj.Notes__c = notesStorage;*/
        
        responseObj.Id = ApexPages.currentPage().getParameters().get('ResponseId');
        if(flsGet(CC_Response__c.Call_Back_time__c)||flsUpdateGet(CC_Response__c.Call_Back_time__c)){
        responseObj.Call_Back_time__c = callBackTime;
        }
        if(flsGet(CC_Response__c.Notes__c)||flsUpdateGet(CC_Response__c.Notes__c)){
        responseObj.Notes__c = notesStorage;
        }
        //SCAVA FIX
        
        if(firstlead.Description != NULL){
            responseObj.Lead_Description__c = firstlead.Description + '--' + newDescription;
        }else{
        if(flsGet(CC_Response__c.Lead_Description__c)||flsUpdateGet(CC_Response__c.Lead_Description__c)){
            responseObj.Lead_Description__c = newDescription;}
        }
        //responseObj.Response_Date_Time__c = System.now();
        //SCAVA
        if(flsGet(CC_Response__c.Response_Date_Time__c)||flsUpdateGet(CC_Response__c.Response_Date_Time__c)){
        responseObj.Response_Date_Time__c = System.now();
        }
        //SCAVA
        Database.SaveResult updateResponse = Database.Update(responseObj, false);
        selResponse = 0;
    }

    /* @ method: Process all the multiselect Q&A and update the Customer Response */
    public void multiSelectProcessing(Integer qa) {

        if (setMultiSelect.contains(qa)) {
            selResponse = selResponse + 1;
            String strIds = '';
            String strEnglish = '';
            String strLocal = '';
            List < String > str = new List < String > ();
            if (selResponse == 1) {
                str = checkboxSelections1;
            } else if (selResponse == 2) {
                str = checkboxSelections2;
            } else if (selResponse == 3) {
                str = checkboxSelections3;
            } else if (selResponse == 4) {
                str = checkboxSelections4;
            } else if (selResponse == 5) {
                str = checkboxSelections5;
            } else if (selResponse == 6) {
                str = checkboxSelections6;
            } else if (selResponse == 7) {
                str = checkboxSelections7;
            } else if (selResponse == 8) {
                str = checkboxSelections8;
            } else if (selResponse == 9) {
                str = checkboxSelections9;
            } else {
                str = checkboxSelections10;
            }

            for (Integer i = 0; i < str.size(); i++) {
                If(strIds == '') {
                    strIds = str[i];
                    strEnglish = mapAnswer.get(str[i]).Answer_Text__c;
                    strLocal = mapQATranslation.get(str[i]);
                } else {
                    strIds = strIds + ',' + str[i];
                    strEnglish = strEnglish + ',' + mapAnswer.get(str[i]).Answer_Text__c;
                    strLocal = strLocal + ',' + mapQATranslation.get(str[i]);
                }
            }
            /*lstQuestion[qa].Customer_Response__c = strIds;
            lstQuestion[qa].Customer_Response_Detail__c = strEnglish;
            lstQuestion[qa].Customer_Response_Detail_Local__c = strLocal;*/
            
            //SCAVA FIX
            if(flsGet(CC_Response_Detail__c.Customer_Response__c)||flsUpdateGet(CC_Response_Detail__c.Customer_Response__c)){   
            lstQuestion[qa].Customer_Response__c = strIds;
            }
            if(flsGet(CC_Response_Detail__c.Customer_Response_Detail__c)||flsUpdateGet(CC_Response_Detail__c.Customer_Response_Detail__c)){
            lstQuestion[qa].Customer_Response_Detail__c = strEnglish;
            }
            if(flsGet(CC_Response_Detail__c.Customer_Response_Detail_Local__c)||flsUpdateGet(CC_Response_Detail__c.Customer_Response_Detail_Local__c)){
            lstQuestion[qa].Customer_Response_Detail_Local__c = strLocal;   
            }
            //SCAVA FIX
        }
    }

    /* @ method: Validate if the response status is Call Back and Nurture then display the Comment and Date time field
    // @ sets the flag to rereneder the block to show the comment and date time */
    public void statusUpdate() {
         string Outcomes = System.Label.NGCC_Disposition_SubType_Outcomes; 
         if(responseObj.status__c == 'other'){//535 line
         showComment1 = true ;
         } 
          else{ 
          showComment1 = false;  
         
         }   
        if (responseObj.status__c == 'Call Back' ) {
            showComment = true;
        } else {
            showComment = false;
        }
        
        if (responseObj.status__c == 'Qualified Lead' ){
             DescriptionShow = true;   
        } else  {
            DescriptionShow = false;
        }
        // added by gchaitha to display the Disposition Sub Type field 
        if (responseObj.status__c != null && responseObj.status__c != '' && Outcomes.containsIgnoreCase(responseObj.status__c)){
            showDispSubtype = true;
        }else {
            showDispSubtype = false;
        }
        //end
    }

    /* @ method: Process and organize the Error which occured as part of Validation specified in the call Script Q&A */
    public void processError(List < String > lstErrors) {
        callScriptError = '<font color="red"> '+ defaulterror+'<ul style="color: red;">';
        set<string> errors = new set<string>();
        errors.addAll(lstErrors);
        for (String error: errors) {
            callScriptError += '<li>' + error + '</li>';
        }
        callScriptError += '</ul></font>';
        system.debug('callScriptError==='+callScriptError);
        ApexPages.Message myErrors = new ApexPages.Message(ApexPages.severity.Info, callScriptError);
        ApexPages.addMessage(myErrors);
    }

    /* @ method: If the Response status = Refer a New Contact then redirect the user to Search for existing contact  */
    public pageReference redirectToSearch() {
        LIST < PDBCountryLookup__c > countryCode = [select name from PDBCountryLookup__c where Code_Desc__c = : leadDetail.CustomCountry__c Limit 1];
        String country;
        if (!countryCode.isEmpty()) {
            country = encodeURL(countryCode[0].name);
        } else {
            country = '';
        }
        String campaign;
        //added by Bapu
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
            if (leadDetail.Campaign_Name__c != null) {
                campaign = encodeURL(leadDetail.Campaign_Name__c);
            } else {
                campaign = '';
            }
       
        String company = encodeURL(leadDetail.company);
        String State = encodeURL(leadDetail.CustomState__c);
        String city = encodeURL(leadDetail.CustomCity__c);
        String postalCode = encodeURL(leadDetail.CustomZip__c);
    
        String redirectURL = '/apex/NGCC_MODS_SFDC_Contact_Search?ResponseId=' + ResponseId;
        redirectURL = redirectURL + '&company=' + company + '&state=' + state + '&campaign=' + campaign;
        redirectURL = redirectURL + '&countryName=' + country + '&city=' + city + '&postalCode=' + postalCode + '&address1='+address1+ '&address2='+address2+'&address3='+ address3;

        PageReference searchPage = new PageReference(redirectURL);
        searchPage.setRedirect(true);
        return searchPage;
    }

    /* @ method: Encode URL to be passed when we user select refer a contact */
    public String encodeURL(String str) {
        String encodedString = str;
        if (str != NULL) {
            encodedString = EncodingUtil.urlEncode(str, 'UTF-8');
        } else {
            encodedString = '';
        }
        return encodedString;
    }

    /* @ method: To make Remote call for CR Service for validating the address */
    @RemoteAction
    global static string validateAddress(Lead lead) {
        //HttpResponse res = NGCC_CRAddressValidationCallout.makeRequestNow(lead);
        //String result = NGCC_CRAddressValidationCallout.processXML(res, lead);
        String result = NGCC_CRAddressValidationCallout.addressValidation(lead);

        if (result.contains('error')) {
            Map < String, Object > errorMsg = (Map < String, Object > ) JSON.deserializeUntyped(result);
            String text = (String) errorMsg.get('error');
            return text;
        } else {
            String text = ('Address validated');
            return text;
        }
    }

    /* @ method: Returns inputfield for Customer response of type Text,Long Text,Email,Number and Datetime */
    public Component.Apex.InputField getTextQuestion(Integer i, String QuesType, String MODSCode) {
        Component.Apex.InputField textDT = new Component.Apex.InputField(Value = lstQuestion[i].Customer_Response__c);
        textDT.expressions.value = '{!lstQuestion[' + i + '].Customer_Response__c}';
        textDT.Id = 'QA' + i + MODSCode + QuesType;
        if (QuesType == 'Text' || QuesType == 'Email' || QuesType == 'Number') {
            textDT.style = 'width:150px;height:16px;resize: none;';
        } else if (QuesType == 'DateTime') {
            textDT.onfocus = 'DatePicker.pickDate(false, this , true)';
            textDT.style = 'width:150px;height:16px;resize: none;';
        } else {
            textDT.style = 'width:500px;height:150px';
        }
        
        if (!Test.isRunningTest())
        {
           textDT.label = ' '; 
        }
        
        return textDT;        
    }

    /* @ method: Returns Radio inputtype for Customer response of type Picklist */
    public Component.Apex.SelectRadio getRadioQuestion(Integer i, String QuesType, String MODSCode) {
        Component.Apex.SelectRadio Radio = new Component.Apex.SelectRadio(Value = lstQuestion[i].Customer_Response__c);
        Radio.expressions.value = '{!lstQuestion[' + i + '].Customer_Response__c}';
        Radio.Id = 'QA' + i + MODSCode + QuesType;
      
        
        String strOpt = lstQuestion[i].Answer_Options_Id__c;

        if (strOpt != Null) {
            List < String > strNewValue = new List < String > (strOpt.split(','));
            strNewValue.sort();
            for (String optionName: strNewValue) {
                string strOptId = getOptionId(optionName);
                if(strOptId != 'Not Valid'){
                    strOptId= Id.valueOf(strOptId);
                    if (mapQATranslation.containsKey(strOptId)) {
                        String strTextTran = mapQATranslation.get(strOptId);
                        Radio.childComponents.add(getSelectOption(strTextTran, strOptId));
                    }
                }
            }
        }
        
        if (!Test.isRunningTest())
        {
           Radio.label = ' '; 
        }
        return Radio;
    }
    
    /* @ method: Returns Lookup inputype for Customer response of type Route to Partner,AM and PSR */
    public Component.Apex.InputField getRoutingQuestion(Integer i, String QuesType, String MODSCode) {
        Component.Apex.InputField inputRouting;
       
        
        if (lstQuestion[i].Question_Type__c == 'Route To AM') {
            inputRouting = new Component.Apex.InputField(Value = lstQuestion[i].Route_To_AM__c);
            inputRouting.expressions.value = '{!lstQuestion[' + i + '].Route_To_AM__c}';
            
        } else if (lstQuestion[i].Question_Type__c == 'Route To Partner') {
            inputRouting = new Component.Apex.InputField(Value = lstQuestion[i].Route_To_Partner__c);
            inputRouting.expressions.value = '{!lstQuestion[' + i + '].Route_To_Partner__c}';

        } else if (lstQuestion[i].Question_Type__c == 'Preferred Partner') {
            inputRouting = new Component.Apex.InputField(Value = lstQuestion[i].Preferred_Partner_Account__c);
            inputRouting.expressions.value = '{!lstQuestion[' + i + '].Preferred_Partner_Account__c}';            
        } 
        else {
            inputRouting = new Component.Apex.InputField(Value = lstQuestion[i].Route_To_PSR__c);
            inputRouting.expressions.value = '{!lstQuestion[' + i + '].Route_To_PSR__c}';
        }
        inputRouting.Id = 'QA' + i + MODSCode + QuesType;
        
        if (!Test.isRunningTest())
        {
           inputRouting.label = ' '; 
        }
        
        return inputRouting;
    }

    /* @ method: Returns picklist inputype for Customer response of type Picklist */
    public Component.Apex.SelectList getPicklistQuestion(Integer i, String QuesType, String MODSCode) {
        Component.Apex.SelectList Picklist = new Component.Apex.SelectList(multiselect = false, size = 1);
        Picklist.expressions.value = '{!lstQuestion[' + i + '].Customer_Response__c}';
        Picklist.Id = 'QA' + i + MODSCode + QuesType;
        
        String strOpt = lstQuestion[i].Answer_Options_Id__c;

        if (strOpt != Null) {
            List < String > strNewValue = new List < String > (strOpt.split(','));
            /*List < String > unformattedNewValue = new List < String > (strOpt.split(','));
            for (String strNew: unformattedNewValue) {
                strNewValue.add(strNew.leftPad(21));
            } */
            strNewValue.sort();

            Picklist.childComponents.add(getSelectOption(mapQATranslation.get(plzSelOne), ''));
            for (String optionName: strNewValue) {
                string strOptId = getOptionId(optionName);
                if(strOptId != 'Not Valid'){
                    strOptId= Id.valueOf(strOptId);
                    if (mapQATranslation.containsKey(strOptId)) {
                        String strTextTran = mapQATranslation.get(strOptId);
                        Picklist.childComponents.add(getSelectOption(strTextTran, strOptId));
                    }
                }
            }
        }
        if (!Test.isRunningTest())
        {
           Picklist.label = ' '; 
        }
        return Picklist;
    }
    
    /* @ method: Returns Country inputype for Customer response of type Country */
    public Component.Apex.selectList getCountryQuestion(Integer i, String QuesType, String MODSCode) {
        Component.Apex.selectList PicklistCountry = new Component.Apex.selectList(multiselect = false, size = 1);
        PicklistCountry.expressions.value = '{!lstQuestion[' + i + '].Customer_Response__c}';
                
        for (PDBCountryLookup__c rawCountries: [select Name, Code_Desc__c from PDBCountryLookup__c order by Code_Desc__c asc]) {
            PicklistCountry.childComponents.add(getSelectOption(rawCountries.Code_Desc__c, rawCountries.Code_Desc__c));
        }
        PicklistCountry.Id = 'QA' + i + MODSCode + QuesType;
        
        if (!Test.isRunningTest())
        {
           PicklistCountry.label = ' '; 
        }
        
        return PicklistCountry;
    }

    /* @ method: Returns OutputPanel with MultiSelect inputype for Customer response of type MultiSelect */
    public Component.Apex.SelectCheckboxes getMultiSelectQuestion(Integer i,Integer curMS, String QuesType, String MODSCode) {
        Component.Apex.SelectCheckboxes MultiSelect = new Component.Apex.SelectCheckboxes(Value = lstQuestion[i].Customer_Response__c, layout = 'pageDirection', borderVisible = true,style='Width:500px;');
         MultiSelect.Id = 'QA' + i + MODSCode + QuesType;
        if (curMS== 1) {
            checkboxSelections1 = new List < String > ();
            MultiSelect.expressions.value = '{!checkboxSelections1}';
        } else if (curMS== 2) {
            checkboxSelections2 = new List < String > ();
            MultiSelect.expressions.value = '{!checkboxSelections2}';
        } else if (curMS == 3) {
            checkboxSelections3 = new List < String > ();
            MultiSelect.expressions.value = '{!checkboxSelections3}';
        } else if (curMS == 4) {
            checkboxSelections4 = new List < String > ();
            MultiSelect.expressions.value = '{!checkboxSelections4}';
        } else if (curMS == 5) {
            checkboxSelections5 = new List < String > ();
            MultiSelect.expressions.value = '{!checkboxSelections5}';
        } else if (curMS == 6) {
            checkboxSelections6 = new List < String > ();
            MultiSelect.expressions.value = '{!checkboxSelections6}';
        } else if (curMS == 7) {
            checkboxSelections7 = new List < String > ();
            MultiSelect.expressions.value = '{!checkboxSelections7}';
        } else if (curMS == 8) {
            checkboxSelections8 = new List < String > ();
            MultiSelect.expressions.value = '{!checkboxSelections8}';
        } else if (curMS == 9) {
            checkboxSelections9 = new List < String > ();
            MultiSelect.expressions.value = '{!checkboxSelections9}';
        } else {
            checkboxSelections10 = new List < String > ();
            MultiSelect.expressions.value = '{!checkboxSelections10}';
        }

        String strOpt = lstQuestion[i].Answer_Options_Id__c;

        if (strOpt != Null) {
            List < String > strNewValue = new List < String > (strOpt.split(','));
            strNewValue.sort();
            for (String optionName: strNewValue) {
                string strOptId = getOptionId(optionName);
                if(strOptId != 'Not Valid'){
                    strOptId= Id.valueOf(strOptId);
                    if (mapQATranslation.containsKey(strOptId)) {
                        String strTextTran = mapQATranslation.get(strOptId);
                        MultiSelect.childComponents.add(getSelectOption(strTextTran, strOptId));
                    }
                }                            
            }
        }
        //Setting already selected multiselect option and passing to JQuery to renender
        String strOptChecked = lstQuestion[i].Customer_Response__c;
        if (strOptChecked != Null) {
            setResponse.addAll(strOptChecked.split(','));
        }
        if (!Test.isRunningTest())
        {
           MultiSelect.label = ' '; 
        }   
        return MultiSelect;
        
    }
    
    
    
}