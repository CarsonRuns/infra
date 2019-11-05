public class GVE_LiveAgent_PreChat_CTL{
   
    // prechat ops variables
    public String submitFunction {get;set;}
    public Boolean success {get;set;}
    public String message {get; set;}
    public String endpoint {get; set;}
    public Boolean renderError {get;set;}
    public String recordType {get; set;}

    // Prechat form parameters
    public Boolean firstNameRequested {get;set;}
    public Boolean lastNameRequested {get;set;}
    public Boolean ccoIDRequested {get;set;}
    public Boolean countryRequested {get;set;}

    public String buttonId {get; set;}
    public String outputHTML {get; set;}
    // configuration handler
    public NGCC_Pre_Chat_Configuration__c pcc {get;set;}
    
    
    public String firstNameInput {get;set;}
    public String lastNameInput {get;set;}
    public String ccoIDInput {get;set;}
    public String countryInput {get;set;}
    public String optionsInput {get;set;}
    
    public List<SelectOption> optionsAvailable {get;set;}
    public List<SelectOption> countries;
    public String redirectResult {get;set;}
    public Boolean preSalesVisitor {get;set;}
    public String language;
    
    /*********************************************************************************
                   Page Initialization Functions and Procedures
    **********************************************************************************/
   
    /*
        Public contructor for the NGCC Live Agent Pre Chat form. 
        Responsibile for initialization of the page, and initiation of the UI construction.
    */

    public GVE_LiveAgent_PreChat_CTL() {
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
        ccoIDRequested = pc.CCO_ID__c;
        firstNameRequested = pc.First_Name__c;
        lastNameRequested = pc.Last_Name__c;
        countryRequested = pc.Country__c;
    }
    /*
        Parses the data from Cisco.com that's passed from live agent and inputs it into the form.
    */
    public void initDataParse(){
        System.debug(Apexpages.currentPage().getParameters().get('node'));
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
        if (label == 'CCOIDInput')
             ccoIDInput = value;
        else if (label == 'FirstNameInput')
            firstNameInput = value;
        else if (label == 'LastNameInput')
            lastNameInput = value;
        else if (label == 'CountryInput')
            countryInput= value;
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
        String errorText = 'Please correct the following fields:';
        
        if (ccoIDRequested==true){
            if (ccoIDInput.trim() == ''){
                success = false;
                errorText = errorText + ' CCO ID ';
            }
        }
        if (firstNameRequested==true){
            if(firstNameInput.trim() == '' ){
                success = false;
                errorText = errorText + ' First Name ';
            } 
        }
        if (lastNameRequested==true){
            if(lastNameInput.trim() == ''){
                success = false;
                errorText = errorText + ' Last Name ';
            } 
        }
 
        if (countryRequested==true){
            if (countryInput.trim() == ''){
                success = false;
                errorText = errorText + ' Country Name ';
            } 
        }     
        if (success == true){
           if (lastNameInput == '' || lastNameInput == null){
               lastNameInput = 'Please Update';
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
        string amperLang=chatURL.substringBetween('language=','&');
        string hashLang=chatURL.substringBetween('language=','#');
        if(hashLang==null || hashLang.length()>6){
            return amperLang;
        }
           return hashLang;
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