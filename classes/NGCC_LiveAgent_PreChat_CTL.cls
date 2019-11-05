/***
Modification History: 
**************************************
  Date:- Mar-6-2018
  Author:- Zakeer Ahmed
  Purpose:- prechat Mar-release
  Changes: 1. added optionsMap.put(status,labelValue); to get the value(label instead of Accepted) and store it in Interested field on Transcript object.
         2. created variable labeledInterest
           3. Line 343-346 added optionsInput condition to assign value to labeledInterest var.
  
  Date:- 16-APR-2018
  Author:- gchaitha
  Purpose:- Chat routing based on selected prechat option
  Changes:- 1. Added variables to store Info like GVE agent availability,Buttonvalue to route,CCOId value line no.67-72 
      2. Checking whether to display CCOId or not  Line No.171, 204-205, 251-263
      3. Validating entered CCOId Line No.282-288
      4. routing to GVE agent or Static page based on GVE agent availability Line No.366-375
      Date: May-4-2018
      5. Zakeahme: 1. Line 370 added gveOptionInput to check any GVE agent's availibility, 
             2. added from 339,347 under validation() helping VF page not to create Lead when chat is routed to GVE agent.(refer id=prechatFormPanelGVE in VF page)

Author  : Ghattamaneni Chaithanya
Purpose : DE207038 : Added logic to map UNITED KINGDOM to GB in getCountries() method 
date    : OCT 30,2018
**/
public class NGCC_LiveAgent_PreChat_CTL{ 
   
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
    public Boolean showDynamic {get;set;}       
    public Boolean headningLogo {get;set;}
    // configuration handler
    public NGCC_Pre_Chat_Configuration__c pcc {get;set;}    
    public String emailInput {get;set;}
    public String firstNameInput {get;set;}
    public String lastNameInput {get;set;}
    public String phoneInput {get;set;}
    public String countryInput {get;set;}
    public String companyInput {get;set;}
    public String optionsInput {get;set;}
    public String originatingInput {get;set;}
    public String Ecid {get;set;}
        
    public List<SelectOption> optionsAvailable {get;set;}
    public List<SelectOption> countries;
    public String redirectResult {get;set;}
    public Boolean preSalesVisitor {get;set;}
    public String language;
    
    public Map<String, String> optionsMap {get;set;}
    public String labeledInterest {get;set;}
    public String buttonIdParse {get;set;}
    
    // added by gchaitha
    public string IsGVEenAvailable {get;set;}
    public string IsGVEfrAvailable {get;set;}
    public String  CCOIdInput {get;set;}
    public Boolean CCOIDRequested {get;set;}
    public String ButtonValue {get;set;}
    //added by zakeahme
    public Boolean gveOptionInput{get;set;}
    
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

    public NGCC_LiveAgent_PreChat_CTL() {
        recordType = Schema.Sobjecttype.Lead.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();        
        renderError = false;    
        preSalesVisitor = true;
        redirectResult = null;
        success = false;
        showDynamic = true;
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
        ButtonValue = buttonId;
        buttonIdParse=buttonId;
        if (buttonId != null) {
            // Isolate button Id from the 'endpoint' parameter  
            pcc = NGCC_Pre_Chat_Configuration__c.getValues(buttonId);
            if (pcc == null){
                pcc = NGCC_Pre_Chat_Configuration__c.getValues('default');
            }
            buildPreChat(pcc);
        } else {
            pcc = NGCC_Pre_Chat_Configuration__c.getValues('default');
            buildPreChat(pcc);
        }
    }
    
    /*
        Maps the UI components to their metadata/configuration values, and sets visibility of those components.
    */
    
    public void buildPreChat(NGCC_Pre_Chat_Configuration__c pc){
        // Map boolean values
        emailRequested = pc.Email__c;
        firstNameRequested = pc.First_Name__c;
        lastNameRequested = pc.Last_Name__c;
        phoneRequested = pc.Phone__c;
        companyRequested = pc.Company__c;
        countryRequested = pc.Country__c;
        headningLogo = pc.Headling_Logo__c;
        // added by gchaitha - fetching CCOId boolean value from Custom setting
        CCOIDRequested = pc.CCO_ID__c;
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
        system.debug('>>><<<'+laList);
        for (LiveAgentInput a : laList){
           dataAssignment(a.label, a.value);
        }
    }
    /*
        Assigns the passed in values from Cisco.com into the pre-chat form. 
    */
    public void dataAssignment(String label, String value){
        system.debug('label==='+label+','+'value===='+value);
        if (label == 'EmailAddressInput')
            emailInput = value;
        else if (label == 'CCOIDInput')   // added by gchaitha to get CCOId
            CCOIdInput = value;
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
            countries.add(new SelectOption(countryName.Name,countryName.Code_Desc__c));
        }
        return countries;
    }    
    
    // Added by gchaitha to show and hide CCOId field 
    public PageReference selectedOption(){
        renderError = false;
        system.debug('ZZZ---Line254'+optionsInput);
        system.debug('ZZZ---Line255'+(optionsInput=='Option-0147'));
        if(optionsInput=='Option-0147'){
            system.debug('ZZZ---Line260'+optionsInput);
           CCOIDRequested = True;
           lastNameRequested = True;
        }
       else {
           system.debug('ZZZ---Line262'+optionsInput);
            CCOIDRequested = False;
            lastNameRequested = pcc.Last_Name__c;
       }
        return null;
    }
    
    /*********************************************************************************
                   Page Operations Functions and Procedures
    **********************************************************************************/
    
    /*
       Input validation and business logic. Only runs the check if the field is 'activated' in the build/init phase.
    */
     public PageReference validation() {
         success = true;
         String errorText;
         if (optionsInput == 'Default1') {
             success = false;
             errorText = System.label.NGCC_Default_Message;
             renderError = true;
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, errorText));
         } else {
             errorText = System.label.NGCC_ErrorText;
             // added by gchaitha to Validate CCOId
             if (CCOIDRequested==true){
                 if (CCOIdInput.trim() == ''){
                     success = false;
                     errorText = errorText + ' '+System.Label.GVE_CCO_ID+' ';
                 }
             }
             if (firstNameRequested==true){
                 if(firstNameInput.trim() == '' ){
                     success = false;
                     errorText = errorText + ' '+System.Label.NGCC_ErrorText_FirstName+' ';
                 } 
             }
             if (lastNameRequested==true){
                 if(lastNameInput.trim() == ''){
                     success = false;
                     errorText = errorText + ' '+System.Label.NGCC_ErrorText_Last_Name+' ';
                 } 
             }
             if (emailRequested==true){
                 if (!validateEmail(emailInput) ){
                     success = false;
                     errorText = errorText + ' '+System.Label.NGCC_ErrorText_Email+' ';
                 }
             }
             if (optionsVisibility==true){
                 if (optionsInput == ''){
                     success = false;
                     errorText = errorText + ' '+System.Label.NGCC_ErrorText_Interest_Selection+' ';
                 } 
             }
             if (companyRequested==true){
                 if (companyInput.trim() == ''){
                     success = false;
                     errorText = errorText + ' '+System.Label.NGCC_ErrorText_CompanyName+' ';
                 } 
             }
             if (countryRequested==true){
                 if (countryInput.trim() == ''){
                     success = false;
                     errorText = errorText + ' '+System.Label.NGCC_ErrorText_CountryName+' ';
                 } 
             }
             if (phoneRequested==true){
                 if ((phoneInput == '' || !containsNoCharacters(phoneInput)) && phoneRequested == true){
                     success = false;
                     errorText = errorText + ' '+System.Label.NGCC_ErrorText_Phone+' ';
                 }
             }
             if (optionsVisibility==true){
                 success = optionsHandler(success);
             }
             
            if(success == true){
                 renderError = false;
                 if (lastNameInput == '' || lastNameInput == null){
                     lastNameInput = 'Please Update';
                 }
                 if (companyInput == '' || companyInput == null){
                     companyInput = 'Please Update';
                 } 
                 if(gveOptionInput == true){
                     success = false;  
                   //  submitFunction = 'jQuery(\'*[id*=prechatForm]\').submit();'; 
                 }
                 if (optionsInput != null){
                     labeledInterest = optionsMap.get(optionsInput);
                     System.Debug('LabeledInterest variable' +labeledInterest );
                 }
                 submitFunction = 'jQuery(\'*[id*=prechatForm]\').submit();';               
             }
             else {
                 renderError = true;
                 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, errorText));
             }
         }
         return null;
     }
    
    /*
        Checks that the input option allows the user to chat with agent. Alternatively, redirects the user to a new page.
    */
    public Boolean optionsHandler(Boolean input){
        if(optionsMap != Null && optionsInput !=null && optionsInput !='' && optionsMap.containsKey(optionsInput)){
            labeledInterest = optionsMap.get(optionsInput);
        }
        if (optionsInput !=null && optionsInput !='' && !optionsInput.contains('Accepted')){
            // added by gchaitha to route to GVE agent or Static page based on GVE agent availability
            if(optionsInput == 'Option-0147'){
                if(pcc !=null && pcc.Mapping_GVE_Skill__c!=null && (IsGVEenAvailable == pcc.Mapping_GVE_Skill__c || IsGVEfrAvailable == pcc.Mapping_GVE_Skill__c)){
                    //Zak
                    gveOptionInput=true;
                    ButtonValue = pcc.Mapping_GVE_Skill__c;
                }else{
                    input = checkRedirect(input);
                }
            }else{  
                input = checkRedirect(input);
            }
        }
        return input;
    }
    
    public boolean checkRedirect(Boolean input){
        preSalesVisitor = false;
        input = false;
        redirectResult = optionsProvider(optionsInput);
        showDynamic = false;
        
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
        string amperLang=chatURL.substringBetween('language=','&');
        string hashLang=chatURL.substringBetween('language=','#');
        if(hashLang==null || hashLang.length()>6){
            //system.debug('Length***'+hashLang.length());
            system.debug('Lang***'+hashLang);
            System.debug('NEWLogicZZZ---LanguageWithAmper&&&&Line417: '+amperLang);
            return amperLang;
        }
            System.debug('ZZZ---LanguageWithHash#####: '+hashLang);
            return hashLang;
            //chatURL.substringBetween('language=','#');
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
        //public String Message {get; set;}
        
        public LiveAgentInput(String[] transcriptFields, String value, String label, String[] entityMaps){
           this.value = value;
           this.label = label;
           this.transcriptFields = transcriptFields;
          // this.CONTACT = li.clone();
        }
    }  
}