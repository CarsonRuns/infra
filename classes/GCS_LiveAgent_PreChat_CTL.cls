/*
Modification History: 
**************************************
  Date:- April-4-2019
  Author:- Zakeahme
  Purpose:- adding additional attributes to GCS form page, LiveChatTranscript and parsing it.
  Changes:- 1. added methods from line#49-55 
            2. added additional logic to DataAssignment() from lin#215-228
*/
public class GCS_LiveAgent_PreChat_CTL{
   
    // prechat ops variables
    public String submitFunction {get;set;}
    public Boolean success {get;set;}
    public String message {get; set;}
    public String endpoint {get; set;}
    public Boolean renderError {get;set;}
    public String recordType {get; set;}

    // Prechat form parameters
    public Boolean emailRequested {get;set;}
    public Boolean firstNameRequested {get;set;}
    public Boolean lastNameRequested {get;set;}
    public Boolean phoneRequested {get;set;}
    public Boolean companyRequested {get;set;}
    public Boolean countryRequested {get;set;}
    public String optionsRequested {get;set;}
    public Boolean optionsVisibility {get;set;}
    public String buttonId {get; set;}
    public String outputHTML {get; set;}
    // configuration handler
    public GCS_Pre_Chat_Configuration__c pcc {get;set;}
    
    
    public String emailInput {get;set;}
    public String firstNameInput {get;set;}
    public String lastNameInput {get;set;}
    public String phoneInput {get;set;}
    public String countryInput {get;set;}
    public String companyInput {get;set;}
    public String optionsInput {get;set;}
    public String labeledInterest {get;set;}
    public String originatingInput {get;set;}
    public String Ecid {get;set;}
    
    public String channelName {get;set;}       
    public String campName {get;set;}
    public String channelDate {get;set;}
    
    public String referrerURLInput {get;set;}  
    public String campaignNameInput {get;set;}
    public String crPartyIdInput {get;set;}
    public String offerNameInput {get;set;}
    public String sourceInput {get;set;}       
    public String contractNumberInput {get;set;}
    public String serialNumberInput {get;set;}
    
    public Map<String, String> optionsMap {get;set;}
    public List<SelectOption> optionsAvailable {get;set;}
    public List<SelectOption> countries;
    public String redirectResult {get;set;}
    public Boolean preSalesVisitor {get;set;}
    public String language;
    
    /*********************************************************************************
                   Page Initialization Functions and Procedures
    **********************************************************************************/

    /*
        Helper function responsible for returning the Select Options list used in the PreChat form.
        Requires a correct Pre-Chat Configuration setup.
    */

    public List<SelectOption> getOptionsList() {
    
        // pull the options metadata from the Pre-Chat-Configuration
        optionsRequested = pcc.Options__c;
        if (optionsRequested != null){
          List<String> optionsList = optionsRequested.split(',');
          optionsAvailable = new List<SelectOption>();
          optionsMap = new Map<String,String>();
          String result = '';
          for (String s: optionsList){ 
              List<String> components = s.split(':');
              // Parse out the Status/ Label Name mapping
              String status = components.get(0);
              String value = components.get(1);
     
              // Component Label translation. Can only be used in contructor.
              // Set outputText component value, and translates it using OOB sfdc.
              Component.Apex.OutputText output = new Component.Apex.OutputText();
              output.expressions.value = '{!$Label.'+value+'}';
              String labelValue = string.valueOf(output.value);
              
              // adds the processed values to the return list
              optionsAvailable.add(new SelectOption(status, labelValue));
              optionsMap.put(status,labelValue);
           }
         }
        
        return optionsAvailable;
    }   
   
    /*
        Public contructor for the NGCC Live Agent Pre Chat form. 
        Responsibile for initialization of the page, and initiation of the UI construction.
    */

    public GCS_LiveAgent_PreChat_CTL() {
        recordType = Schema.Sobjecttype.Contact.getRecordTypeInfosByName().get('End Customer Contact').getRecordTypeId();
      
        renderError = false;    
        preSalesVisitor = true;
        redirectResult = null;
        success = false;
        PageReference pageRef = ApexPages.currentPage(); 
        endpoint = '';
        
        if (pageRef.getParameters() != null) {
            // requires 'endpoint' parameter in passed into the Prechat form (LA requirement)
            if (pageRef.getParameters().containsKey('endpoint')) {
                if (pageRef.getParameters().get('endpoint') != null) {
                    endpoint = pageRef.getParameters().get('endpoint');
                    getButtonId();
                }
            }
        } 
    }
    
    /*
        Private helper function used to get the ButtonID used by the constructor. 
    */
    
    private void getButtonId(){
        String chatURL=EncodingUtil.urlDecode(ApexPages.currentPage().getUrl(),'UTF-8');
        String buttonId = chatURL.substringBetween('button_id=','&');
        if (buttonId != null) {
            // Isolate button Id from the 'endpoint' parameter  
            pcc = GCS_Pre_Chat_Configuration__c.getValues(buttonId);
            if (pcc == null){
                pcc = GCS_Pre_Chat_Configuration__c.getValues('default');
            }
            buildPreChat(pcc);
        } else {
            pcc = GCS_Pre_Chat_Configuration__c.getValues('default');
            System.debug(pcc.Email__c);
            buildPreChat(pcc);
            System.debug(emailRequested);
        }
    }
     
    /*
        Maps the UI components to their metadata/configuration values, and sets visibility of those components.
    */
    
    public void buildPreChat(GCS_Pre_Chat_Configuration__c pc){
        // Map boolean values
        emailRequested = pc.Email__c;
        firstNameRequested = pc.First_Name__c;
        lastNameRequested = pc.Last_Name__c;
        phoneRequested = pc.Phone__c;
        companyRequested = pc.Company__c;
        countryRequested = pc.Country__c;
        optionsRequested = pc.Options__c;
        if (optionsRequested != null){
            optionsVisibility = true;
        } else {
           optionsVisibility = false;
        }
    }
    /*
        Parses the data from Cisco.com that's passed from live agent and inputs it into the form.
    */
    public void initDataParse(){
    System.debug('>>><<'+Apexpages.currentPage().getParameters().get('node'));
        JSONParser parser = JSON.createParser(Apexpages.currentPage().getParameters().get('node'));
        List<LiveAgentInput> laList = new List<LiveAgentInput>();
         while (parser.nextToken() != null) {
                if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                     LiveAgentInput laInput = (LiveAgentInput)parser.readValueAs(LiveAgentInput.class);
                     laList.add(laInput);
                }
        }
        for (LiveAgentInput a : laList){
           dataAssignment(a.label, a.value);
           
        }
    }
    /*
        Assigns the passed in values from Cisco.com into the pre-chat form. 
    */
    public void dataAssignment(String label, String value){
        if (label == 'EmailAddressInput')
            emailInput = value;
        else if (label == 'FirstNameInput')
            firstNameInput = value;
        else if (label == 'LastNameInput')
            lastNameInput = value;
        else if (label == 'PhoneInput')
             phoneInput = value;
        else if (label == 'CountryInput')
            countryInput= value;
        else if (label == 'CompanyInput')
            companyInput = value;
        else if (label == 'OriginatingURL')
            originatingInput = value;
        else if (label == 'Ecid')
            originatingInput = value;
        else if (label == 'chan')
            channelName = value;
        else if (label == 'camp')
            campName = value;
        else if (label == 'date')
            channelDate= value;
        else if (label == 'ReferrerURL')
            referrerURLInput= value;
        else if (label == 'CampaignNameInput')
            campaignNameInput= value;
        else if (label == 'CrPartyIdInput')
            crPartyIdInput= value;
        else if (label == 'OfferNameInput')
            offerNameInput= value;
        else if (label == 'SourceInput')
            sourceInput= value;
        else if (label == 'ContractNumberInput')
            contractNumberInput= value;
        else if (label == 'SerialNumberInput')
            serialNumberInput= value;
    }
    
    /*
        Formats block visibility based on boolean value.
    */
    public String visibilityFormat (Boolean input){
        if (input == true){
            return 'block';
        } else 
            return 'none';
    }
    
       
    /*
       Helper function responsible for outputing the countries picklist. 
    */
    public List<SelectOption> getCountries(){
        countries = new List<SelectOption>();
        
        List<PDBCountryLookup__c> rawCountries = new List<PDBCountryLookup__c>();
        rawCountries = [select PDBCountryLookup__c.Name, PDBCountryLookup__c.Code_Desc__c from PDBCountryLookup__c order by PDBCountryLookup__c.Code_Desc__c asc ];
        
        // Create the Select Options.
        for (PDBCountryLookup__c countryName : rawCountries) {
            // GB gets replaced to be UK to adhere to MODS requirement
            if (countryName.Name != 'GB')
                countries.add(new SelectOption(countryName.Name,countryName.Code_Desc__c));
            else {
                countries.add(new SelectOption('UK',countryName.Code_Desc__c));
            }
        }
        return countries;
    }    
    
    
    /*********************************************************************************
                   Page Operations Functions and Procedures
    **********************************************************************************/
    
    /*
       Input validation and business logic. Only runs the check if the field is 'activated' in the build/init phase.
    */
    public PageReference validation() {
        success = true;
        System.debug(originatingInput);
        String errorText = 'Please correct the following fields:';
        
        if (emailRequested==true){
            if (!validateEmail(emailInput) ){
                success = false;
                errorText = errorText + ' Email ';
            }
        }
        if (lastNameRequested==true){
            if(lastNameInput.trim() == ''){
                success = false;
                errorText = errorText + ' Last Name ';
            } 
        }
        if (optionsVisibility==true){
            if (optionsInput == ''){
                success = false;
                errorText = errorText + ' Interest Selection ';
            } 
        }
        if (companyRequested==true){
            if (companyInput.trim() == ''){
                success = false;
                errorText = errorText + ' Company Name ';
            } 
        }
        if (countryRequested==true){
            if (countryInput.trim() == ''){
                success = false;
                errorText = errorText + ' Country Name ';
            } 
        }
        if (phoneRequested==true){
            if ((phoneInput == '' || !containsNoCharacters(phoneInput)) && phoneRequested == true){
                success = false;
                errorText = errorText + ' Phone ';
            }
        }
        
        if (optionsVisibility==true){
            success = optionsHandler(success);
             
        }
        
        if (success == true){
           if (lastNameInput == '' || lastNameInput == null){
               lastNameInput = 'Please Update';
           }
           if (optionsInput != null){
               labeledInterest = optionsMap.get(optionsInput);
           }
           submitFunction = 'jQuery(\'*[id*=prechatForm]\').submit();';
        } else {
           renderError = true;
           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, errorText));
        }
        
        return null;
    }
    
    /*
        Checks that the input option allows the user to chat with agent. Alternatively, redirects the user to a new page.
    */
    public Boolean optionsHandler(Boolean input){
       if (!optionsInput.contains('Accepted')){
           preSalesVisitor = false;
           input = false;
           redirectResult = optionsProvider(optionsInput);
       } 
       
       return input;
    }
    
    /*
       Handles the user redirection for LA Prechat form. Outputs a rejection message. 
    */
    public String optionsProvider(String input){
       String result = null;
       List<CC_PreChat_Option__c> options = [Select OptionValue__c from CC_PreChat_Option__c where Name=:input];
       if (options.size() > 0){
           result = (options[0].OptionValue__c);
       }
       return result;
    }

    /*
        Pulls in and parses the visualforce page data to get the language parameter. 
    */
    public string getLanguage(){
        string chatURL=EncodingUtil.urlDecode(ApexPages.currentPage().getUrl(),'UTF-8');
        return chatURL.substringBetween('language=','#');
    }
    
    /**************************************************************
            Validation Helper Functions
    ***************************************************************/

    /*
        Vadidation function responsible for checking format type. 
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
        Vadidation function responsible for checking the absence of characters out of the phone input.
    
    */
    public Boolean containsNoCharacters(String input){
        return input.containsOnly('01234566789()-+# ');
    }
    
    /****************************************************************
                   Live Agent Input JSON Structure
    *****************************************************************/
    
     public class LiveAgentInput{
        
        public String[] transcriptFields;
        public String value {get; set;}
        public String label {get; set;}
        
        public LiveAgentInput(String[] transcriptFields, String value, String label, String[] entityMaps){
           this.value = value;
           this.label = label;
           this.transcriptFields = transcriptFields;
           
        }
    }
    
}