/***************************************************************************************************
Name    : NGCC_MODS_SFDC_Contact_Search_CTE
Author  : Serge Borysov
Purpose : This class is responsible for the invocation of the inbound call MODS Contact Search  
Created Date: 1/23/2014
Major Update: 5/15/2015
Modification History: 
Serge Borysov - Modifications to the business Rules
Serge Borysov - Modifications to the lead creation Business Rules
Serge Borysov - Expansion of lead creation functionality. 
Serge Borysov - Refer a Contact data passing as url parameters
Bapu Srigadde - Added two new fields/parameters lines from 623- 624 
Address_Line_1__c =     ApexPages.currentPage().getParameters().get('address1'),
Address_Line_2__c =     ApexPages.currentPage().getParameters().get('address2')
Serge Borysov - Live Agent Integration

Author  : Ghattamaneni Chaithanya
Purpose : Adding Dispostion and Disposition Sub Type fields to page
      Customizing picklist values for Disposition and Disposition Sub Type fields Line No#905-939
      Dispisition Sub Type Validation Line No#661-665
      Added to save the Selected Disposition and Disposition Sub Type values Line No#675-676
date    : July 19,2018

Author  : Ghattamaneni Chaithanya
Purpose : Scava Fixes
date    : Sep 18,2018

Author  : Ghattamaneni Chaithanya
Purpose : DE207038 : Added logic to map UNITED KINGDOM to GB in getCountries() method 
          DE208781 : Added ALTERNATE_PHONE_NUMBER field in convertContact(), MarketingContact methods
date    : OCT 30,2018

Author  : Ghattamaneni Chaithanya
Purpose : Added Contact Reason and Persona fields to page US291144
		  Line no: 110-113,300-303,1115-1134
date    : Jun 13,2019

*****************************************************************************************************/ 

public class NGCC_MODS_SFDC_Contact_Search_CTE {
    
    // Variables used for the Live Agent Operatoins
    public String ghostStatus {get; set;}
    public String campaignCode {get; set;}
    
    public Boolean responseDisplayed {get; set;}
    public string noteField {get;set;}//updated by Fazu&Awnish
    public String consoleChangeURL {get;set;}
    
    // variables responsible for search parameters
    public String isAutomatic {get; set;}
    public String searchEmailAddress {get; set;}
    public String searchFirstName {get; set;}
    public String searchLastName {get; set;}
    public String searchCompany {get; set;}
    public String searchCity {get; set;}
    public String searchState {get; set;}
    public String searchCountryName {get; set;}
    public String searchPostalCode  {get; set;}
    public String searchPhoneNumber {get; set;}
    public String searchAddressLine1 {get; set;}
    public String searchAddressLine2 {get; set;}
    public String searchAddressLine3 {get; set;}
    public String inboundNote {get; set;}    
    // Reference parameters based on the previous contact actions
    public String responseId {get; set;}
    public String campaignId {get; set;}
    public String keycode {get; set;}
    public String ccid {get; set;}
    public String ecid {get; set;}
    public String dtid {get; set;}
    public String oid {get; set;}
    
    // Variable responsible for error message to display incorrectly formatted components.
    public String error {get; set;}
    public String outputText {get;set;}
    
    // Error Flags and Component Visibility Flags
    public Boolean errorFlag { get; set; }
    public Boolean resultBlockFlag { get; set; }
    public Boolean noResultsFlag { get; set; }
    public Boolean serviceErrorFlag { get; set; }
    public String displayComponent {get;set;}
    public Boolean invalidInput {get; set;}
    public Boolean validInput {get; set;}
    public Boolean firstTime {get; set;}
    public Boolean consoleView {get;set;}
    
    // original passed in values from the pre-chat form
    public String origEmailAddress {get; set;}
    public String origFirstName {get; set;}
    public String origLastName {get; set;}
    public String origPhoneNumber {get; set;}
    
    // Pagination rules and limiters
    public integer npages = 0;
    public Integer PageSize = 20 ;
    
    // list and data models
    public List<Lead> leadList;
    public List<MarketingContact> mcList;
    public List<SelectOption> countries;
    public List<SelectOption> states;
    public Lead inputLead {get;set;}
    public SelectOption emptyItem;
    
    public String DispositionSubType {get; set;}
    public String disposition {get; set;}
    
    Public CC_Response__c response {get; set;}
    public boolean showContactReason {get; set;}
    public boolean showPersona {get; set;}
    public boolean showDispSubtype {get;set;}
    
    /***********
    Front-End Validation and Support
  ************/
    
    public void setConsoleView(){
        consoleView = true;
    }
    /*
    Function responsible for encoding the input values
    Encodes into UTF-8
  */
    public String symbolEncoder(String value) {
        String encodedVariable = '';
        if (value != null)
            encodedVariable = EncodingUtil.urlEncode(value,'UTF-8');
        return encodedVariable;
    }
    
    /*
    Function responsible for decoding UTF-8 into regular text.
  */
    public String symbolDecoder(String value) {
        String decodedVariable = '';
        if (value != null)
            decodedVariable = EncodingUtil.urlDecode(value, 'UTF-8');
        return decodedVariable;
    }    
    /*
    Formats all of the submitted values
  */
    public void fieldFormat(){
        searchFirstName = symbolEncoder(searchFirstName);
        searchLastName = symbolEncoder(searchLastName);
        searchCompany = symbolEncoder(searchCompany);
        searchCity = symbolEncoder(searchCity);
        searchState = symbolEncoder(searchState);
        searchPostalCode = symbolEncoder(searchPostalCode);
        searchPhoneNumber = symbolEncoder(searchPhoneNumber);
        if (searchCountryName == null){
            searchCountryName = '';    
        }
    }    
    /*
    Deformats all of the search values.
  */
    public void fieldDeformat(){
        searchFirstName = symbolDecoder(searchFirstName);
        searchLastName = symbolDecoder(searchLastName);
        searchCompany = symbolDecoder(searchCompany);
        searchCity = symbolDecoder(searchCity);
        searchState = symbolDecoder(searchState);
        searchPostalCode = symbolDecoder(searchPostalCode);
        searchPhoneNumber = symbolDecoder(searchPhoneNumber);
    }
    /*
        Function responsible for validating the correctness of the submitted values.
        Sets passed in values during the very first run of the app
    */
    public void validation() {
        errorFlag = false;
        noResultsFlag = false;
        // save the original passed in values to retrieve the lead created in pre-chat form        
        if (firstTime == true){
            firstTime = false;
            origEmailAddress = searchEmailAddress;
            origFirstName = searchFirstName;
            origPhoneNumber = searchPhoneNumber;       
        }        
        serviceErrorFlag = false;
        responseDisplayed = false;
        fieldFormat();
        if (validateDataFields(searchEmailAddress, searchFirstName,
                               searchLastName, searchCompany, searchCity,
                               searchState, searchCountryName,
                               searchPostalCode, searchPhoneNumber) == true) {                                   
                                   outputText = '<script> ' +
                                       + 'MODS_Search(\''+EncodingUtil.urlEncode(searchEmailAddress, 'UTF-8')+'\',\''+ EncodingUtil.urlEncode(searchFirstName, 'UTF-8')+'\',\''  
                                       + EncodingUtil.urlEncode(searchLastName, 'UTF-8')+'\',\''+ EncodingUtil.urlEncode(searchCompany, 'UTF-8')+'\',\''+ EncodingUtil.urlEncode(searchCity, 'UTF-8')+'\',\''
                                       +                 EncodingUtil.urlEncode(searchState, 'UTF-8')+'\',\''+ EncodingUtil.urlEncode(searchCountryName, 'UTF-8')+'\',\''  
                                       +                EncodingUtil.urlEncode(searchPostalCode, 'UTF-8')+'\',\''+ EncodingUtil.urlEncode(searchPhoneNumber, 'UTF-8')+'\'); </script>';
                                       
                               } else if (validInput == false && invalidInput == false) {
                                   errorFlag = true;
                               } 
        fieldDeformat();
    }    
    /*
    Function responsible for evaluation of the Business Rules
  */
  public Boolean validateDataFields(String searchEmailAddress,
                   String searchFirstName, String searchLastName,String  searchCompany,
                    String searchCity, String searchState, String searchCountryName,
                    String searchPostalCode, String searchPhoneNumber) {                                          
          error = 'Please correct following fields: ';
          validInput = false;
          invalidInput = false;    
          if (!validateEmail(symbolDecoder(searchEmailAddress))
              && searchEmailAddress != '') {
                  error += ' Email ';
                  invalidInput = true;
              }
          if (searchLastName.length() < 2 && searchLastName != '') {
              error += ' Last Name ';
              invalidInput = true;
          }
          if (searchCompany.length() < 2 && searchCompany != '') {
              error += ' Company ';
              invalidInput = true;
          }
          if (searchCity.length() < 3 && searchCity != '') {
              error += ' City ';
              invalidInput = true;
          }
          if (searchState.length() < 2 && searchState != '') {
              error += ' State ';
              invalidInput = true;
          }          
          if ((searchPhoneNumber.length() < 7
               && searchPhoneNumber != '') || !(symbolDecoder(searchPhoneNumber).containsOnly('01234566789()-+# '))) {
                   error += ' PhoneNumber ';   
                   invalidInput = true;
               }
          if (invalidInput == false) {
              error = '';
              if (searchPhoneNumber != ''
                  || searchEmailAddress != ''
                  || ((searchFirstName != '' || searchLastName != '')     && searchCompany != '' && searchCountryName != '')
                  || (searchFirstName != '' && searchLastName != '' && searchCountryName != 'CN' && searchCountryName !='')
                  || (searchLastName != '' && (searchCountryName == 'TW'
                                               || searchCountryName == 'MO' 
                                               || searchCountryName == 'HK'
                                               || searchCountryName == 'CN')) 
                  && searchCountryName != '') {
                      validInput = true;
                  } 
          }
          return validInput;
  }
    
    /*
        Function responsible for the validation of the email format.
        Regex Reference: http://blog.shivanathd.com/2013/09/RegexInSalesforce.html
  */
    public Boolean validateEmail(String email) {
        Boolean res = true;
        String emailRegex = '[a-zA-Z0-9\\.\\!\\#\\$\\%\\&\\*\\/\\=\\?\\^\\_\\+\\-\\`\\{\\|\\}\\~\'._%+-]+@[a-zA-Z0-9\\-.-]+\\.[a-zA-Z]+';
        Pattern regexPattern = Pattern.compile(emailRegex);
        Matcher emailMatcher = regexPattern.matcher(email);       
        if (!emailMatcher.matches()) 
            res = false;
        return res;
    }
    /*
    Function responsible for printing countries. Uses a select statement due to need to sort by Full name rather than the code. (Names are reversed in SFDC) 
  */
    public List<SelectOption> getCountries(){
        countries = new List<SelectOption>();
        List<PDBCountryLookup__c> rawCountries = new List<PDBCountryLookup__c>();
        // selects from a custom setting object, can't use oob select due to sorting based on Code_desc instead of name. 
        rawCountries = [select PDBCountryLookup__c.Name, PDBCountryLookup__c.Code_Desc__c from PDBCountryLookup__c order by PDBCountryLookup__c.Code_Desc__c asc ];
        // Create the Select Options.       
        for (PDBCountryLookup__c countryName : rawCountries) {
            countries.add(new SelectOption(countryName.Name,countryName.Code_Desc__c));
        }
        return countries;
    }    
    /*
    Function responsible for returning list of states. 
  */
    public List<SelectOption> getStates(){
        states = new List<SelectOption>();
        List<NGCC_State_List__c> rawStates = new List<NGCC_State_List__c>();        
        rawStates = NGCC_State_List__c.getall().values();
        for (NGCC_State_List__c c: rawStates) {
            states.add(new SelectOption(c.Code__c,c.Name));
        }
        states.sort();
        return states;
    }
    /***********************************
    Search Logic
  ***********************************/
    public NGCC_MODS_SFDC_Contact_Search_CTE(ApexPages.StandardController controller) {
        firstTime = true;
        displayComponent = 'false';
        showPersona = false;
        showContactReason = false;
        showDispSubtype  = false;
        response = new CC_Response__c();
        // prepopulate the search fields from the URL Parameters
        searchEmailAddress = ApexPages.CurrentPage().getParameters().get('emailAddress');
        searchFirstName = ApexPages.CurrentPage().getParameters().get('firstName');
        searchLastName = ApexPages.CurrentPage().getParameters().get('lastName');
        searchCompany = ApexPages.CurrentPage().getParameters().get('company');
        searchCity = ApexPages.CurrentPage().getParameters().get('city');
        searchState = ApexPages.CurrentPage().getParameters().get('state');
        searchCountryName = ApexPages.CurrentPage().getParameters().get('countryName');
        searchPostalCode  = ApexPages.CurrentPage().getParameters().get('postalCode');
        searchPhoneNumber = ApexPages.CurrentPage().getParameters().get('phoneNumber');
        searchAddressLine1 = ApexPages.CurrentPage().getParameters().get('address1');
        searchAddressLine2 = ApexPages.CurrentPage().getParameters().get('address2');
        searchAddressLine3 = ApexPages.CurrentPage().getParameters().get('address3');
        campaignId = ApexPages.CurrentPage().getParameters().get('campaign');
        responseId = ApexPages.CurrentPage().getParameters().get('ResponseId');        
        keycode = ApexPages.CurrentPage().getParameters().get('keycode');
        ecid = ApexPages.CurrentPage().getParameters().get('ecid');
        ccid = ApexPages.CurrentPage().getParameters().get('ccid');
        oid = ApexPages.CurrentPage().getParameters().get('oid');
        dtid = ApexPages.CurrentPage().getParameters().get('dtid');
        system.debug('>>KeyCode Search 311 <<' +keycode + ' >>> Ecid '+ecid);
        system.debug(campaignCode+ 'CampaignCodeZak');
        if (searchCountryName == 'US'){
            displayComponent = 'true';
        }      
        isAutomatic = ApexPages.CurrentPage().getParameters().get('automatic');  
        system.debug('automatic1 : ' + isAutomatic);
        if (isAutomatic == 'true'){
            validation();
        }
    }
    
    /*
        Function responsible for parsing the JSON object. 
        Populates the List of Leads with newly created leads from the JSON object.
    */
    public PageReference MODS_Search() {
        npages = 0;
        errorFlag = false;
        resultBlockFlag = true;
        noResultsFlag = true;
        outputText = '';
        mcList = new List<MarketingContact>{};
        String para = null;
        // get the JSON object
        para = Apexpages.currentPage().getParameters().get('node');
        system.debug('para==='+para);
        if (para != null){
            invalidInput = false;
            JSONParser parser = JSON.createParser(para);
            // parse the JSON input
            List<MarketingContactsList> modsResponse = new List<MarketingContactsList>();
            while (parser.nextToken() != null) {
                if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                    MarketingContactsList mark = (MarketingContactsList)parser.readValueAs(MarketingContactsList.class);
                    modsResponse.add(mark);
                }
            }
            // check whether the JSON input returns any results, else set the total returned size to 0
            if (modsResponse.get(0).CONTACT != null){
                for (Integer i = 0; (modsResponse.get(0).CONTACT.size() > i && i<20) ; i++){
                    MarketingContact mc = modsResponse.get(0).CONTACT.get(i);
                    mc.index = i;
                    mcList.add(mc);
                }
                npages = modsResponse.get(0).Total_Contacts;
            } else {
                npages = 0;
            }           
        } 
        // if there were no results,  display 'no result' error.
        if (npages == 0) {
            resultBlockFlag = false;
            noResultsFlag = true;
        } else {
            // unblock the display
            resultBlockFlag = true;
            noResultsFlag = false;
            // if the request came from the pre-chat form and only 1 record was returned, execute a lead creation step
            if (isAutomatic == 'true' && npages == 1){
                return automaticProspect(mcList.get(0));
            }
        }
        return null;
    }

    /*
    Function responsible for returning a page reference to the ?Create new Prospect? page in salesforce. 
  */
    public PageReference newProspect() { 
    system.debug('automatic2 : ' + isAutomatic);
        PageReference p = null;        
        String countryNameString = null;
        if (searchCountryName != '' && searchCountryName != null){
            if (searchCountryName == 'UK'){
                searchCountryName = 'GB';
            }
            list<PDBCountryLookup__c> countryName = [select Code_Desc__c from PDBCountryLookup__c where name = :searchCountryName Limit 1];
            countryNameString = countryName[0].Code_Desc__c;
        } else {
            countryNameString = '';
        }        
        Lead newLead = new Lead();
        if(flsGet(Lead.RecordTypeId) && flsUpdateGet(Lead.RecordTypeId)){
            newLead.RecordTypeId = Schema.Sobjecttype.Lead.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        }
        if(flsGet(Lead.Status) && flsUpdateGet(Lead.Status)) {
            newLead.Status = 'New Prospect';
        }
        if(flsGet(Lead.DedupeRecord__c) && flsUpdateGet(Lead.DedupeRecord__c)) {
            newLead.DedupeRecord__c = 'Dedupe';
        }
        if(flsGet(Lead.FirstName) && flsUpdateGet(Lead.FirstName)) {
            newLead.FirstName = searchFirstName;
        }
        if(flsGet(Lead.LastName) && flsUpdateGet(Lead.LastName)) {
            newLead.LastName = forceNonNull(searchLastName);
        }
        if(flsGet(Lead.CustomCity__c) && flsUpdateGet(Lead.CustomCity__c)) {
            newLead.CustomCity__c = searchCity;
        }
        if(flsGet(Lead.CustomState__c) && flsUpdateGet(Lead.CustomState__c)) {
            newLead.CustomState__c = searchState;
        }
        if(flsGet(Lead.CustomCountry__c) && flsUpdateGet(Lead.CustomCountry__c)) {
            newLead.CustomCountry__c = countryNameString;
        }
        if(flsGet(Lead.CustomZip__c) && flsUpdateGet(Lead.CustomZip__c)) {
            newLead.CustomZip__c = searchPostalCode;
        }
        if(flsGet(Lead.Email) && flsUpdateGet(Lead.Email)) {
            newLead.Email =  searchEmailAddress;
        }
        if(flsGet(Lead.Company) && flsUpdateGet(Lead.Company)) {
            newLead.Company = forceNonNull(searchCompany);
        }
        if(flsGet(Lead.Phone) && flsUpdateGet(Lead.Phone)) {
            newLead.Phone = searchPhoneNumber;
        }
        if(flsGet(Lead.Address_Line_1__c) && flsUpdateGet(Lead.Address_Line_1__c)) {
            newLead.Address_Line_1__c = searchAddressLine1;//searchAddressLine1,searchAddressLine2,searchAddressLine3 Added by Bapu
        }
        if(flsGet(Lead.Address_Line_2__c) && flsUpdateGet(Lead.Address_Line_2__c)) {
            newLead.Address_Line_2__c = searchAddressLine2;
        }
        if(flsGet(Lead.Address_Line_3__c) && flsUpdateGet(Lead.Address_Line_3__c)) {
            newLead.Address_Line_3__c = searchAddressLine3;
        }
        //system.debug('>>><<<'+TestChat);        
        newLead = campaignCrossReference(campaignId, newLead);
        system.debug('>>>419<<<' +ecid +'>>419<<'+keycode);        
        try {            
            if (isAutomatic == 'true'){
                List<Lead> inputLead = [select Id from Lead where Email = :origEmailAddress and FirstName = :origFirstName and LastName= :origLastName and Phone = :origPhoneNumber order by CreatedDate desc limit 1];
                if (inputLead.size() > 0){  
                    newLead.Id = inputLead[0].Id;
                    if(flsUpdateGet(Lead.Medium_Type__c)){  
                        newLead.Medium_Type__c = 'Inbound Chat';
                    }
                    update newLead;
                    //p = new PageReference('/'+newLead.id+'/e?retURL=%2F'+newLead.id);
                    p = Page.NGCC_SFDC_Subtab_Redirect; 
                    p.getParameters().put('ID', newLead.Id); 
                    p.setRedirect(true);                     
                } else {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, 'First name ' + origFirstName +' Last name ' + origLastName + ' origPhone ' + origPhoneNumber + ' Email ' + origEmailAddress));
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, 'Failed to insert a lead. Please wait a few moments and try again.'));
                }
            } else {
                insert newLead;
                //p = new PageReference('/'+newLead.id+'/e?retURL=%2F'+newLead.id);
                p = Page.NGCC_SFDC_Subtab_Redirect; 
                p.getParameters().put('ID', newLead.Id); 
                p.setRedirect(true);                 
                if (consoleView == true){
                    consoleChangeURL = '/'+newLead.id+'/e?retURL=%2F'+newLead.id;
                    outputText = '<script>openNewTab();</script>';
                    p = null;
                }
                responseUpdate(searchFirstName, searchLastName, searchEmailAddress, searchPhoneNumber);
            }
        } catch (DMLException e){
            System.debug('ERROR - ' + e);
            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, 'First name ' + origFirstName +'Last name ' + origLastName + 'origPhone ' + origPhoneNumber + 'Email ' + origEmailAddress));
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, 'Failed to insert a lead. Please refer to you training documents.'));            
        }
        system.debug('automatic3 : ' + isAutomatic);
        return p;
    }
    
    public Lead campaignCrossReference (String campaignId, Lead newLead){
        system.debug('>>454 ECID<<'+ecid +'  DTID>> '+dtid+'  CCID>> '+ccid+' OID >> '+oid);
        System.Debug('CampaignID: Line#456' +campaignID);
        System.Debug('KeyCode: Line#457' +keycode);
        if(ccid !='undefined'){
            // SCAVA Fix by gchaitha
            if(flsGet(Lead.Eloqua_CC_Id__c) && flsUpdateGet(Lead.Eloqua_CC_Id__c)){
                newLead.Eloqua_CC_Id__c = ccid;
            }
        }
        if(dtid !='undefined'){
            // SCAVA Fix by gchaitha
            if(flsGet(Lead.Eloqua_Drive_To_ID__c) && flsUpdateGet(Lead.Eloqua_Drive_To_ID__c)){
                newLead.Eloqua_Drive_To_ID__c = dtid;
            }            
        }
        if(oid !='undefined'){
            // SCAVA Fix by gchaitha
            if(flsGet(Lead.Eloqua_Offer_Id__c) && flsUpdateGet(Lead.Eloqua_Offer_Id__c)){
                newLead.Eloqua_Offer_Id__c = oid;
            }
        }          
        //newLead.ProgramEvent__c = ecid;
        System.Debug('TEST 472');
        if (campaignId != null && campaignId!='null' && campaignId!=''){
            Campaign campName = [select Id,Campaign_Code__c,Program_Event_Name__c,Program_Event_Code__c from Campaign where Id=:campaignId];
            system.debug('campaingCross>> '+campName);
            // SCAVA Fix by gchaitha
            if(flsGet(Lead.Campaign_Code__c) && flsUpdateGet(Lead.Campaign_Code__c)){
                newLead.Campaign_Code__c = campName.Campaign_Code__c; 
            }
            if(flsGet(Lead.Campaign_Name__c) && flsUpdateGet(Lead.Campaign_Name__c)){
                newLead.Campaign_Name__c = campName.Id; 
            }
            if(flsGet(Lead.Program_Event_Name__c) && flsUpdateGet(Lead.Program_Event_Name__c)){
                newLead.Program_Event_Name__c = campName.Program_Event_Name__c; 
            }
            // SCAVA Fix by gchaitha
            if(flsGet(Lead.ProgramEvent__c) && flsUpdateGet(Lead.ProgramEvent__c)){
                newLead.ProgramEvent__c = campName.Program_Event_Code__c; 
            }
        }       
        else if (ecid != null && ecid !='null' && ecid != '' && ecid !='undefined' && !ecid.isWhitespace()){
            //newLead.ProgramEvent__c = ecid;
            String ecid1=ecid.trim();
            ecid=ecid1;
            system.debug('ECIDZ '+ecid);
            Campaign[] campName = [select Id,Campaign_Code__c,Program_Event_Name__c,Program_Event_Code__c from Campaign where Program_Event_Code__c=:ecid and Campaign_source__c ='Global Eloqua'];
            system.debug('campNameZ ' +campName);
            if (campName.size() > 0){
                newLead.Campaign_Code__c = campName[0].Campaign_Code__c;
                newLead.Campaign_Name__c = campName[0].Id;
                newLead.Program_Event_Name__c = campName[0].Program_Event_Name__c;
                newLead.ProgramEvent__c = campName[0].Program_Event_Code__c;
            }            
            else if (keycode != null && keycode !='null' && keycode != '' && !keycode.isWhitespace()){
                System.Debug('Line497' +keycode);
                String keycode1=keycode.trim();
                keycode=keycode1;
                system.debug('keycodeZ ' +keycode);
                // SCAVA Fix by gchaitha
                if(flsGet(Lead.Chat_Keycode__c) && flsUpdateGet(Lead.Chat_Keycode__c)){
                    newLead.Chat_Keycode__c = keycode; 
                }
                Campaign[] campName1 = [select Id,Campaign_Code__c,Program_Event_Name__c,Program_Event_Code__c from Campaign where Program_Event_Code__c=:keycode];        
                system.debug('campNameZ1 ' +campName1);
                if (campName1.size() > 0){          
                    newLead.Campaign_Code__c = campName1[0].Campaign_Code__c;
                    newLead.Campaign_Name__c = campName1[0].Id;               
                    newLead.Program_Event_Name__c = campName1[0].Program_Event_Name__c;
                    newLead.ProgramEvent__c = campName1[0].Program_Event_Code__c;
                }
            }            
        }
        else if (keycode != null && keycode !='null' && keycode != '' && !keycode.isWhitespace()){
            System.Debug('Line514' +keycode);
            String keycode1=keycode.trim();
            keycode=keycode1;
            system.debug('keycodeZ ' +keycode);
            // SCAVA Fix by gchaitha
            if(flsGet(Lead.Chat_Keycode__c) && flsUpdateGet(Lead.Chat_Keycode__c)){
                newLead.Chat_Keycode__c = keycode; 
            }
            Campaign[] campName1 = [select Id,Campaign_Code__c,Program_Event_Name__c,Program_Event_Code__c from Campaign where Program_Event_Code__c=:keycode];        
            system.debug('campNameZ1 ' +campName1);
            if (campName1.size() > 0){          
                newLead.Campaign_Code__c = campName1[0].Campaign_Code__c;
                newLead.Campaign_Name__c = campName1[0].Id;               
                newLead.Program_Event_Name__c = campName1[0].Program_Event_Name__c;
                newLead.ProgramEvent__c = campName1[0].Program_Event_Code__c;
            }
        }
        return newLead;
    }
        
    /**************************************************  
    Lead Creation Logic
  **************************************************/    
    public String fullName(String input){
        if (input == 'Y'){
            return 'Yes';
        } else if (input == 'N'){
            return 'No';
        } else 
            return null;
    }
    
    public Lead convertContact(MarketingContact input){
        Lead newLead = new Lead();   
        if(flsGet(Lead.RecordTypeId) && flsUpdateGet(Lead.RecordTypeId)) {
            newLead.RecordTypeId = Schema.Sobjecttype.Lead.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        }
        if(flsGet(Lead.Status) && flsUpdateGet(Lead.Status)) {
            newLead.Status = 'New Prospect';
        }
        if(flsGet(Lead.FirstName) && flsUpdateGet(Lead.FirstName)) {
            newLead.FirstName = input.FIRST_NAME;
        }
        if(flsGet(Lead.LastName) && flsUpdateGet(Lead.LastName)) {
            newLead.LastName = forceNonNull(input.LAST_NAME);
        }
        if(flsGet(Lead.Address_Line_1__c) && flsUpdateGet(Lead.Address_Line_1__c)){
            newLead.Address_Line_1__c = input.Address_line_1;
        }
        if(flsGet(Lead.Address_Line_2__c) && flsUpdateGet(Lead.Address_Line_2__c)){
            newLead.Address_Line_2__c = input.Address_line_2;
        }
        if(flsGet(Lead.CustomCity__c) && flsUpdateGet(Lead.CustomCity__c)) {
            newLead.CustomCity__c = input.City;
        }
        if(flsGet(Lead.DedupeRecord__c) && flsUpdateGet(Lead.DedupeRecord__c)) {
            newLead.DedupeRecord__c = 'Dedupe';
        }
        if(flsGet(Lead.CustomState__c) && flsUpdateGet(Lead.CustomState__c)) {
            newLead.CustomState__c = input.State;
        }
        if(flsGet(Lead.CustomCountry__c) && flsUpdateGet(Lead.CustomCountry__c)) {
            newLead.CustomCountry__c = input.ISO_COUNTRY_NAME;
        }
        if(flsGet(Lead.CustomZip__c) && flsUpdateGet(Lead.CustomZip__c)) {
            newLead.CustomZip__c = input.POSTAL_CODE;
        }
        if(flsGet(Lead.Email) && flsUpdateGet(Lead.Email)) {
            newLead.Email = input.EMAIL_ADDRESS;
        }
        if(flsGet(Lead.Company) && flsUpdateGet(Lead.Company)) {
            newLead.Company = input.reported_company_name;
        }
        if(flsGet(Lead.Call_Permission__c) && flsUpdateGet(Lead.Call_Permission__c)){
            newLead.Call_Permission__c = fullName(input.Phone_opt_in);
        }
        if(flsGet(Lead.Call_Permission_Date__c) && flsUpdateGet(Lead.Call_Permission_Date__c)) {
            newLead.Call_Permission_Date__c = getPermissionDate(input.phone_opt_in_date);
        }
        if(flsGet(Lead.Email_Permission__c) && flsUpdateGet(Lead.Email_Permission__c)){
            newLead.Email_Permission__c = fullName(input.Email_address_opt_in);
        }
        if(flsGet(Lead.Email_Permission_Date__c) && flsUpdateGet(Lead.Email_Permission_Date__c)){
            newLead.Email_Permission_Date__c = getPermissionDate(input.Email_opt_in_dt);
        }
        if(flsGet(Lead.Third_Party_Data_Permission__c) && flsUpdateGet(Lead.Third_Party_Data_Permission__c)) {
            newLead.Third_Party_Data_Permission__c = fullName(input.DATA_SHARING_PERMISSION_FLAG);
        }
        if(flsGet(Lead.Third_Party_Data_Permission_Date__c) && flsUpdateGet(Lead.Third_Party_Data_Permission_Date__c)) {
            newLead.Third_Party_Data_Permission_Date__c = getPermissionDate(input.CISCO_DATA_SHARING_TXN_DT);
        }
        if(flsGet(Lead.MobilePhone) && flsUpdateGet(Lead.MobilePhone)) {
            newLead.MobilePhone = input.MOBILE_NUMBER;
        }
        if(flsGet(Lead.Title) && flsUpdateGet(Lead.Title)) {
            newLead.Title = input.JOB_TITLE;
        }
        if(flsGet(Lead.MODS_Site_Id__c) && flsUpdateGet(Lead.MODS_Site_Id__c)){
            newLead.MODS_Site_Id__c = input.ORG_PARTY_ID;
        }
        if(flsGet(Lead.Phone) && flsUpdateGet(Lead.Phone)) {
            newLead.Phone = input.PHONE_NUMBER;
        }
        if(flsGet(Lead.MODS_Contact__c) && flsUpdateGet(Lead.MODS_Contact__c)) {
            newLead.MODS_Contact__c = Decimal.valueOf(input.PERSON_PARTY_ID);  
        }   
        //Added by gchaitha for DE208781
        if(flsGet(Lead.Alternate_phone_number__c) && flsUpdateGet(Lead.Alternate_phone_number__c)) {
            newLead.Alternate_phone_number__c = input.ALTERNATE_PHONE_NUMBER;
        }
        
        return newLead;
    }
    
    public PageReference automaticProspect(MarketingContact mc) {
        Lead newLead = convertContact(mc);
        responseDisplayed = false;
        if(flsGet(Lead.Medium_Type__c) && flsUpdateGet(Lead.Medium_Type__c)){
            newLead.Medium_Type__c = 'Inbound Chat';
        }        
        newLead = contactLookup(newLead);
        newLead = campaignCrossReference(campaignId, newLead);
        PageReference p = null;        
        try {
            if (isAutomatic == 'true'){
                
                List<Lead> inputLead = [select Id from Lead where Email = :origEmailAddress and FirstName = :origFirstName and LastName= :origLastName and Phone = :origPhoneNumber order by CreatedDate desc limit 1];
                if (inputLead.size() > 0){
                    if(flsUpdateGet(Lead.Medium_Type__c)){
                      newLead.Medium_Type__c = 'Inbound Chat';
                    }
                    newLead.Id = inputLead[0].Id;
                    update newLead;
                    p = new PageReference('/'+newLead.id+'/e?retURL=%2F'+newLead.id);
                }
                else {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, 'Failed to insert a lead. Please wait a few moments and try again.'));
                }
            } else {
                insert newLead;
                p = new PageReference('/'+newLead.id+'/e?retURL=%2F'+newLead.id);
                
            }
        } catch (DMLException e){
            System.debug('ERROR - ' + e);
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, 'Failed to insert a lead. Please refer to you training documents.'));
        }        
        return p;
    }    
    public PageReference prepopulatedProspect() {
        responseDisplayed = false;
        Integer index = Integer.valueOf(ApexPages.currentPage().getParameters().get('index'));
        Lead newLead = convertContact(mcList.get(index));        
        newLead = contactLookup(newLead);             
        newLead = campaignCrossReference(campaignId, newLead);
        PageReference p = null;
        try {
            if (isAutomatic == 'true'){
                List<Lead> inputLead = [select Id from Lead where Email = :origEmailAddress and FirstName = :origFirstName and LastName= :origLastName and Phone = :origPhoneNumber order by CreatedDate desc limit 1];
                if (inputLead.size() > 0){
                    if(flsUpdateGet(Lead.Medium_Type__c)){
                        newLead.Medium_Type__c = 'Inbound Chat';
                    }
                    newLead.Id = inputLead[0].Id;
                    update newLead;
                    //p = new PageReference('/'+newLead.id+'/e?retURL=%2F'+newLead.id);
                    p = Page.NGCC_SFDC_Subtab_Redirect; 
                    p.getParameters().put('ID', newLead.Id); 
                    p.setRedirect(true);                     
                } else{
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, 'Failed to insert a lead. Please wait a few moments and try again.'));                    
                }
            } else {
                insert newLead;
                //p = new PageReference('/'+newLead.id+'/e?retURL=%2F'+newLead.id);
                p = Page.NGCC_SFDC_Subtab_Redirect; 
                p.getParameters().put('ID', newLead.Id); 
                p.setRedirect(true);                 
                if (consoleView == true){
                    consoleChangeURL = '/'+newLead.id+'/e?retURL=%2F'+newLead.id;
                    outputText = '<script>openNewTab();</script>';
                    p = null;
                }
                responseUpdate(ApexPages.currentPage().getParameters().get('firstName'), 
                               ApexPages.currentPage().getParameters().get('lastName'), 
                               ApexPages.currentPage().getParameters().get('email'),
                               ApexPages.currentPage().getParameters().get('phone'));
            }
        } catch (DMLException e){
            System.debug('ERROR - ' + e);
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, 'Failed to insert a lead. Please refer to you training documents.'));
        }        
        return p;
    }
    
    public void responseUpdate(String firstname, String lastname, String email, String phone){
        if (responseId != null){
            CC_Response__c response = [select Notes__c from CC_Response__c where Id = :responseId];
            // check that a valid id has been passed
            if (response != null){
                // check that the notes are not not null, set variable first. 
                if (response.Notes__c == null){
                    response.Notes__c = '';
                } else {
                    response.Notes__c = response.Notes__c+'\n';
                }
                // SCAVA Fix by gchaitha
                if(flsUpdateGet(CC_Response__c.Notes__c)){
                    response.Notes__c = response.Notes__c+ 'Follow Up Info: Name: ' + firstname+ ' '+ lastname + 
                    + ' Email: '+email + ' Phone: ' + phone;
                }  
                try {
                    update response;
                } catch (DMLException e){
                    System.debug('ERROR - ' + e);
                }
            }
        }
    }
    
    public Boolean sourceIdEmpty(){
        return (ApexPages.currentPage().getParameters().get('sourceId') == '' || ApexPages.currentPage().getParameters().get('sourceId') == null);
    }
    
    /**
    GHOST CALL SCENARIO
  */    
    public void createGhostResponse(){ 
        campaignCode = campaignCode;
        if (disposition == '' ||disposition == '- Not Specified -'){
            responseDisplayed = false;
             ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You must select a value for Outcome field.');
            ApexPages.addMessage(msg);
           // return;
        }// added by gchaitha to validate Disposition Sub Type
        else if((disposition != '' && disposition != '- Not Specified -' && disposition != 'Lead Escalation') && (DispositionSubType== '--None--' || DispositionSubType== null)){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You must select a value for Sub-Outcome field.');
            ApexPages.addMessage(msg);
           // return;
        }
        else{
            //responseDisplayed = true;
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Response Saved.');
            ApexPages.addMessage(msg);
            CC_Response__c newResponse = new CC_Response__c();
            // SCAVA Fix by gchaitha
            if(flsGet(CC_Response__c.Lead__c)){
                newResponse.Lead__c = Org_Constant_CS__c.getInstance('NGCC_Ghost_Lead').Production_Value__c;
            }         
            if(flsGet(CC_Response__c.Key_Code__c)){
                newResponse.Key_Code__c = campaignCode;
            }
            if(flsGet(CC_Response__c.Name)){
                newResponse.Name = disposition + DateTime.Now();
            }
            // added by gchaitha to save the selected Disposition and Disposition Sub Type values to response
            if(flsGet(CC_Response__c.Status__c)){
                newResponse.Status__c = disposition;
            }
            if(flsGet(CC_Response__c.Disposition_Sub_Type__c)){
                newResponse.Disposition_Sub_Type__c = DispositionSubType;
            } 
            // SCAVA Fix by gchaitha
            if(flsGet(CC_Response__c.Response_Date_Time__c)){
                newResponse.Response_Date_Time__c = DateTime.Now();
            } 
            // Added by gchaitha to map Contact Reason and Persona fields - US291144
            if(flsGet(CC_Response__c.Contact_Reason__c)){
                newResponse.Contact_Reason__c = response.Contact_Reason__c;
            } 
            if(flsGet(CC_Response__c.Persona__c)){
                newResponse.Persona__c = response.Persona__c;
            }
            // end
            if (ghostStatus == 'Disposition Call'){
                newResponse.Response_Type__c = 'Inbound Call';
            } 
            else {
                newResponse = ghostChatLeadUpdate(newResponse);
            }
            if (newResponse.Lead__c != null){
                try {
                    insert newResponse;
                    //added by Bapu
                    campaignCode = '';
                    disposition = '';
                    noteField = '';
                    showPersona = false;
                    showContactReason = false;
                    showDispSubtype = false;
                } catch (DMLException e){
                    System.debug('ERROR - ' + e);
                }
            }
        }
    }
    public CC_Response__c ghostChatLeadUpdate(CC_Response__c newResponse){
        // SCAVA Fix by gchaitha
        if(flsGet(CC_Response__c.Response_Type__c)){
            newResponse.Response_Type__c = 'Inbound Chat';
        }
        if(flsGet(CC_Response__c.Call_Status__c)){
            newResponse.Call_Status__c = 'Invalid';
        }
        if (isAutomatic == 'true'){
            List<Lead> inputLead = [select Id from Lead where Email = :origEmailAddress and FirstName = :origFirstName and LastName= :origLastName and Phone = :origPhoneNumber order by CreatedDate desc limit 1];
            if (inputLead.size() > 0){
                newResponse.Lead__c = inputLead[0].Id;
                // SCAVA Fix by gchaitha
                if(flsGet(CC_Response__c.Source_Event_Number__c)){
                    newResponse.Source_Event_Number__c = inputLead[0].Id; 
                }                
                Lead updateLead = inputLead[0];
                // SCAVA Fix by gchaitha
                if(flsUpdateGet(Lead.Status)){                    
                  updateLead.Status = 'Marketing Unqualified';
                }
                if(flsUpdateGet(Lead.No_of_Attempts__c)){                    
                  updateLead.No_of_Attempts__c = 1;
                }
                if(flsUpdateGet(Lead.Outcome__c)){                    
                  updateLead.Outcome__c = disposition;
                }
                if(flsUpdateGet(Lead.Disposition_Sub_Type__c)){                    
                  updateLead.Disposition_Sub_Type__c = DispositionSubType;
                }
                // SCAVA Fix by gchaitha
                if(flsUpdateGet(Lead.Lead_Prospect_Close_Date__c)){
                    updateLead.Lead_Prospect_Close_Date__c = DateTime.Now();
                }
                // SCAVA Fix by gchaitha
                if(flsUpdateGet(Lead.Call_Status__c)){
                    updateLead.Call_Status__c = 'Invalid';
                }
                update updateLead;
            } else{
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, 'Failed to insert a Disposition Chat. Please wait a few moments and try again.'));
            }
        }
        return newResponse;
    }    
    /************************************************************
    Helper Functions
  *************************************************************/
    public Lead contactLookup(Lead newLead){
        if(sourceIdEmpty() == false){
            List<Contact> contactInfo = [select Contact.Account.Name, Contact.AccountId from Contact where Contact.Id = :ApexPages.currentPage().getParameters().get('sourceId') ];
            if(contactInfo.size() > 0){
                String name = contactInfo[0].Account.Name;
                String id = contactInfo[0].AccountId;
                // SCAVA Fix by gchaitha
                if(flsGet(Lead.Lead_Contact__c) && flsUpdateGet(Lead.Lead_Contact__c)){
                    newLead.Lead_Contact__c = ApexPages.currentPage().getParameters().get('sourceId');
                }                
                // SCAVA Fix by gchaitha
                if(flsGet(Lead.End_Customer_Account__c) && flsUpdateGet(Lead.End_Customer_Account__c)){
                    newLead.End_Customer_Account__c = id;
                }
            }
        }
        return newLead;
    }
    /*
        Function responsible for setting the Boolean ?resultBlockFlag?. 
        Always sets the Boolean variable to false. Used in the display variable for visibility purposes.
    */
    public void setBlockFlag() {
        resultBlockFlag = false;
    }
    /*
        Helper function responsible for returning the list of leads to the visual force page. 
        Maximum number of results is 20. This is determined by MODS_Search() and the SFDC_Search() functions. 
  */
    public List<MarketingContact> getResults() {
        return mcList;
    }
    /*
        Helper function responsible for returning the number of results. 
        Will potentially return a size larger than 20 for MODS search. 
  */
    public Integer getResultSize() {
        if(mcList == null){
            return 0;
        } else {
            return npages;
        }
    }
    /*
        Helper function for clearing the List of Leads, blocking the display, and setting the results size to 0. 
  */
    public void clearResults() {
        mcList = new List<MarketingContact>{};
        resultBlockFlag = false;
        npages = 0;
    }
    public void clearInput (){
        responseDisplayed = false;
        searchEmailAddress= '';
        searchFirstName= '';
        searchLastName= '';
        searchCompany= '';
        searchCity= '';
        searchState= '';
        searchCountryName= '';
        searchPostalCode = '';
        searchPhoneNumber= '';
    }
    public String forceNonNull(String input){
        String output = '';
        if (input == '' || input == null || input == 'null' || input==' '){
            output = 'Please Update';
        } else{
            output = input;
        }        
        return output;   
    }
    /*
        Function responsible for returning a blank option for dropdown lists.
    */
    public SelectOption getemptyItem (){
        return new SelectOption('',' ');
    }
    /*
        Function responsible for setting the Boolean ?errorFlag?. 
        The function always sets the flag to true to indicate an error. Used for error display.
    */
    public void setErrorFlag(){
        errorFlag = true;
    }
    /*
        Helper function responsible for changing the string representation
        of the date/time parameter into an actual DateTime variable.
    */
    public DateTime getPermissionDate(String input){        
        // remove the trailing period and everything after it. 
        if (input != null){
            if (input.contains('.')){
                List<String> parts = input.split('\\.',2);
                String stringDate = parts[0];
                return DateTime.valueOf(stringDate);
            } else {
                return null;
            }
        }
        return null;
    }
    /*
        Sets the error flag if there is a service outage.
    */
    public void setServiceErrorFlag(){
        serviceErrorFlag = true;
    }
    public class MarketingContactsList{        
        public List<MarketingContact> CONTACT;
        public String Status {get; set;}
        public Integer Total_Contacts {get; set;}
        public String Message {get; set;}        
        public MarketingContactsList(String status, Integer total, String message, List<MarketingContact> li){
            this.Status = status;
            this.Total_Contacts = total;
            this.Message = message;
            this.CONTACT = li.clone();
        }
    }    
    public class MarketingContact {
        public Integer index {get; set;}
        public String EMAIL_ADDRESS {get; set;}
        public String FIRST_NAME {get; set;}
        public String LAST_NAME {get; set;}
      //  public String PREFERRED_LANGUAGE {get; set;}
        public String ISO_COUNTRY_NAME {get; set;}
        public String PHONE_NUMBER {get; set;}
        public String Address_line_1 {get; set;}
        public String Address_line_2 {get; set;}
        public String Address_line_3 {get; set;}
       // public String LINE_4_ADDRESS {get; set;}
        public String City {get; set;}
        public String POSTAL_CODE {get; set;}
        public String reported_company_name {get; set;}
        public String SITE_ISO_COUNTRY_NAME {get; set;}
        public String State {get; set;}
        public List<MarketingSource> SOURCE = new List<MarketingSource>();
        public String PERSON_PARTY_ID {get; set;}
        public String ORG_PARTY_ID {get; set;}
        public String MOBILE_NUMBER {get; set;}
        public String JOB_TITLE {get; set;}
        public String Email_address_opt_in {get; set;}
        public String Email_opt_in_dt {get; set;}
        public String Phone_opt_in {get; set;}
        public String phone_opt_in_date {get; set;}
        public String DATA_SHARING_PERMISSION_FLAG {get; set;}
        public String CISCO_DATA_SHARING_TXN_DT {get; set;}
        //Added by gchaitha for DE208781
        public String ALTERNATE_PHONE_NUMBER {get; set;}
        
        public MarketingContact(String email,String fname,String lname,String plang,String country,String phone,
                                String address1,String address2,String address3,String address4,String city,
                                String zip,String companyName,String countryName,String state, List<MarketingSource> sourceList,        
                                String modsId,String orgId,String mobile,String title,        
                                String emailPermission,String emailDate,String  phonePermission,
                                String phoneDate,String dataPermisison,String dataDate,string altPhone){
          this.EMAIL_ADDRESS = email;
          this.FIRST_NAME = fname;
          this.LAST_NAME = lname;
         // this.PREFERRED_LANGUAGE = plang;
          this.ISO_COUNTRY_NAME = country;
          this.PHONE_NUMBER = phone;            
          this.Address_line_1 = address1;
          this.Address_line_2 = address2;
          this.Address_line_3 = address3;
         // this.LINE_4_ADDRESS = address4;
          this.City = city;           
          this.POSTAL_CODE = zip;
          this.reported_company_name = companyName;
          this.SITE_ISO_COUNTRY_NAME = countryName;
          this.State = state;
          this.SOURCE = sourceList.clone();                    
          this.PERSON_PARTY_ID = modsId;
          this.ORG_PARTY_ID = orgId;
          this.MOBILE_NUMBER = mobile;
          this.JOB_TITLE = title;                    
          this.Email_address_opt_in = emailPermission;
          this.Email_opt_in_dt = emailDate;
          this.Phone_opt_in =  phonePermission;
          this.phone_opt_in_date = phoneDate;
          this.DATA_SHARING_PERMISSION_FLAG = dataPermisison;
          this.CISCO_DATA_SHARING_TXN_DT = dataDate;
          //Added by gchaitha for DE208781
          this.ALTERNATE_PHONE_NUMBER = altPhone;
    }      
  }
    public List<SelectOption> getDispositionSubTypes()
    {
        List<SelectOption> options = new List<SelectOption>();
        return options;
    }
    public class MarketingSource{
        public String Source_Record_ID {get;set;}
    }
    // added by gchaitha to customized picklist values for Disposition field
    public List<SelectOption> getItems () {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('- Not Specified -','- Not Specified -'));
        options.add(new SelectOption('Customer Dropped Off','Customer Dropped Off'));
        return options;
    } 
    //Added by gchaitha to display Contact Reason and Persona fields - US291144
    public void statusUpdate() {
        string Outcomes = System.Label.NGCC_Disposition_SubType_Outcomes; 
        response.Status__c = disposition;
        if (disposition != null && disposition != '' && Outcomes.containsIgnoreCase(disposition)){
            showDispSubtype = true;
            response.Disposition_Sub_Type__c = '--None--';
        }else {
            showDispSubtype = false;
        }
        showContactReason = false;
        showPersona = false;
    }
     
    public void DispositionChange() {
        DispositionSubType = response.Disposition_Sub_Type__c;
        showContactReason = true;
        showPersona = true;
    }
    // end
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
}