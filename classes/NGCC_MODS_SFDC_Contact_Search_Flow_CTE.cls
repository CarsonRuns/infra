/***************************************************************************************************
Name    : NGCC_MODS_SFDC_Contact_Search_Flow_CTE
Author  : Gaurav Singh
Purpose : This class is controller for NGCC_MODS_SFDC_Contact_Search_FLOW VF page, it is responsible for MODS search
Date	: 29-Nov-2018

Modification History: 

*****************************************************************************************************/
public class NGCC_MODS_SFDC_Contact_Search_Flow_CTE {
    
    public String searchEmailAddress {get; set;}
    public String searchFirstName {get; set;}
    public String searchLastName {get; set;}
    public String searchCompany {get; set;}
    public String searchCity {get; set;}
    public String searchState {get; set;}
    public String searchCountryName {get; set;}
    public String searchPostalCode  {get; set;}
    public String searchPhoneNumber {get; set;}

	public String modsSearchUrl {get; set;}
    public String lightningUrl {get; set;}
    
    public String leadListJSON {get;set;}
    public List<MarketingContact> mcList;
    
    public NGCC_MODS_SFDC_Contact_Search_Flow_CTE() {
        leadListJSON = '';
        searchEmailAddress 	= ApexPages.CurrentPage().getParameters().get('emailAddress');
        searchFirstName 	= ApexPages.CurrentPage().getParameters().get('firstName');
        searchLastName 		= ApexPages.CurrentPage().getParameters().get('lastName');
        searchCompany 		= ApexPages.CurrentPage().getParameters().get('company');
        searchCity 			= ApexPages.CurrentPage().getParameters().get('city');
        searchState 		= ApexPages.CurrentPage().getParameters().get('state');
        searchCountryName 	= ApexPages.CurrentPage().getParameters().get('countryName');
        searchPostalCode  	= ApexPages.CurrentPage().getParameters().get('postalCode');
        searchPhoneNumber 	= ApexPages.CurrentPage().getParameters().get('phoneNumber');
        
        searchEmailAddress 	= (searchEmailAddress != null? EncodingUtil.urlEncode(searchEmailAddress,'UTF-8'):'');
        searchFirstName 	= (searchFirstName != null? EncodingUtil.urlEncode(searchFirstName,'UTF-8'):'');
        searchLastName 		= (searchLastName != null? EncodingUtil.urlEncode(searchLastName,'UTF-8'):'');
        searchCompany 		= (searchCompany != null? EncodingUtil.urlEncode(searchCompany,'UTF-8'):'');
        searchCity 			= (searchCity != null? EncodingUtil.urlEncode(searchCity,'UTF-8'):'');
        searchState 		= (searchState != null? EncodingUtil.urlEncode(searchState,'UTF-8'):'');
        searchCountryName 	= (searchCountryName != null? EncodingUtil.urlEncode(searchCountryName,'UTF-8'):'');
        searchPostalCode 	= (searchPostalCode != null? EncodingUtil.urlEncode(searchPostalCode,'UTF-8'):'');
        searchPhoneNumber 	= (searchPhoneNumber != null? EncodingUtil.urlEncode(searchPhoneNumber,'UTF-8'):'');
        
        List<Org_Constant_CS__c> orgCons = [SELECT Production_Value__c,Non_Production_Value__c FROM Org_Constant_CS__c where Name='NGCC MODS Contact Service'];
        if( !orgCons.isEmpty() ){
            String hostName = URL.getSalesforceBaseUrl().toExternalForm();
            if( hostname.indexOf('ww') != -1 && hostname.indexOf('ciscosales.my') != -1){
            	modsSearchUrl 	= orgCons[0].Production_Value__c;
            }else{
                modsSearchUrl 	= orgCons[0].Non_Production_Value__c;
            }
            lightningUrl	= hostName.split('\\.')[0]+'.lightning.force.com';
        }
    }
    
    public void MODS_Search() {
        Integer npages = 0;
        mcList = new List<MarketingContact>{};
        String para = Apexpages.currentPage().getParameters().get('node');
        
        if (para != null){
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
        List<Lead> leadList = new List<Lead>();
        if (npages > 0) {
            for( Integer i=0; i < mcList.size(); i++ ){
                leadList.add( prepopulatedProspect(i) );
            }
        }
        
        LeadListWrapper leadWrap = new LeadListWrapper();
        leadWrap.leadList = leadList;
        leadWrap.isSuccess = true;
        
        leadListJSON = JSON.serialize( leadWrap );
    }
    
    public Lead prepopulatedProspect( Integer index ) {
        Lead newLead = convertContact(mcList.get(index));
        newLead.Medium_Type__c = 'Inbound Chat';
        //newLead = contactLookup(newLead);             
        //newLead = campaignCrossReference(campaignId, newLead);
        
        return newLead;
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
        /*if(flsGet(Lead.Third_Party_Data_Permission_Date__c) && flsUpdateGet(Lead.Third_Party_Data_Permission_Date__c)) {
            newLead.Third_Party_Data_Permission_Date__c = getPermissionDate(input.CISCO_DATA_SHARING_TXN_DT);
        }*/
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
            newLead.MODS_Contact__c = (!String.isBlank( input.PERSON_PARTY_ID )? Decimal.valueOf(input.PERSON_PARTY_ID):null);  
        }   
		//Added by gchaitha for DE208781
		if(flsGet(Lead.Alternate_phone_number__c) && flsUpdateGet(Lead.Alternate_phone_number__c)) {
            newLead.Alternate_phone_number__c = input.ALTERNATE_PHONE_NUMBER;
        }
		
        return newLead;
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
    
    public String fullName(String input){
        if (input == 'Y'){
            return 'Yes';
        } else if (input == 'N'){
            return 'No';
        } else 
            return null;
    }
    
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
    
    public static Boolean flsGet(SObjectField field){
        return field.getDescribe().isCreateable() ? true : false;
    }
    
    // SCAVA Helper Method to validate Update Access at field level
    public static Boolean flsUpdateGet(SObjectField field){
        return field.getDescribe().isUpdateable() ? true : false;
    }
    
    public class LeadListWrapper{
        Boolean isSuccess	{get;set;}
        List<Lead> leadList {get;set;}
    }
    public class MarketingContactsList{        
        Public List<MarketingContact> CONTACT;
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
       // public String PREFERRED_LANGUAGE {get; set;}
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
        //  this.PREFERRED_LANGUAGE = plang;
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
    public class MarketingSource{
        public String Source_Record_ID {get;set;}
    }
}