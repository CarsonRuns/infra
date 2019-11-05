/***************************************************************************************************
Name    : NGCCLeadScreenMashupCTL 
Author  : Mukesh Srivastava 
Purpose : This class will show the sales history of the related opportunities and Marketing history from ondemand MODS integration  
Created Date: 1/23/2014
Modification History:
	1. Author : Ramzil Cleopas - 3/11/2014 US5665: Sales History Sprint 4
                       Added code to show the sales history of the leads     
    2. Author : Serge Borysov - 3/31/2014 - US5349: Marketing History Controller 
    3. Author : Ghattamaneni Chaithanya
       Purpose : Scava Fixes
       Changes : 
          1. Added SCAVA Fixes in NGCC_LeadScreenMashupCTL() method
       date    : Oct 16,2018
*****************************************************************************************************/ 

public class NGCC_LeadScreenMashupCTL {
    Public List<MarketingActivity> activities {get;set;}
    Public List<Contact> cContact {get;set;}   
    Public Map<String, Object> contactParams = new Map<String, Object>{};
    Public Boolean showMktg {get;set;}
    Public Boolean showNoMktg {get;set;}    
    Public Integer noOfRecords{get; set;}
    Public Integer size{get;set;}
    Public String errMsgNoRecord {get;set;}
    Public Integer noOfLeadRecords{get; set;}
    Date dt = System.today() - 180;
    Private final Lead mLead;  
    Public String strTooltip {get;set;}
    
    public string MODSConstring {get;set;}
    
    /* @Class: To represents the structure of the JSON object */
    public class MarketingActivity implements Comparable{
        public String CALL_NOTES {get; set;}
        public String Call_Status {get; set;}
        public String Offer_Architecture {get; set;}
        public String Offer_Description {get; set;}
        public String Activity_Type {get; set;}
        public String Offer_Type_Name {get; set;}
        public String Person_Party_Id {get; set;}
        public String Offer_Name {get; set;}
        public String Activity_Date {get; set;}
        
        public MarketingActivity (String CALL_NOTES, String CALL_STATUS, String OFFER_ARCHITECTURE, String OFFER_DESCRIPTION, String ACTIVITY_TYPE, String OFFER_TYPE_NAME, String PERSON_PARTY_ID, String OFFER_NAME,String ACTIVITY_DATE){
            this.CALL_NOTES =  CALL_NOTES;
            this.Call_Status = CALL_STATUS;
            this.Offer_Architecture = OFFER_ARCHITECTURE;
            this.Offer_Description = OFFER_DESCRIPTION;
            this.Activity_Type = ACTIVITY_TYPE;
            this.Offer_Type_Name = OFFER_TYPE_NAME;
            this.Person_Party_Id = PERSON_PARTY_ID;
            this.Offer_Name = OFFER_NAME;
            this.Activity_Date = ACTIVITY_DATE;
        }     
        
        //descending sort
        public Integer compareTo(Object compareTo) {
            MarketingActivity compareMA = (MarketingActivity)compareTo;
            if (Activity_Date == compareMA.Activity_Date) 
                return 0;
            else if (Activity_Date < compareMA.Activity_Date) 
                return 1;
            else
                return -1;        
        }
    }   
    
    /* @Constructor to the current context record and fetch required information from the database.
    //@ Set list of leads associated to the current lead record association to sales contact
    //@ Set list of Opportunities associated to the current lead record association to sales contact */
    public NGCC_LeadScreenMashupCTL(ApexPages.StandardController controller) {
        Org_Constant_CS__c csTP = Org_Constant_CS__c.getInstance('NGCC_LeadScreenMashup');
        strTooltip  = csTP.Production_Value__c;        
        this.mLead = (Lead)controller.getRecord();
        // SCAVA Fix
        if(this.mLead.id != null){
            MODSConstring = String.valueOf([select MODS_Contact__c from Lead where id=:this.mLead.id].MODS_Contact__c);
        }
        system.debug('MODSConstring=='+MODSConstring); // SCAVA
        showMktg = false;
        errMsgNoRecord = '';
        getLeads();
        getOpptys();
    }
    
    /* @method: On Demand processing of Marketing history received from the callout */
    public PageReference getMODSData(){
        activities = new List<MarketingActivity>();
        // get the JSON data
        String para = Apexpages.currentPage().getParameters().get('node');        
        
        if (para != null){
            // parse JSON data
            JSONParser parser = JSON.createParser(para);
            while (parser.nextToken() != null) {
                // Find the 'Marketing' array which contains the line items and parse them.
                if (parser.getCurrentName() == 'Marketing' && parser.nextToken() != JSONToken.VALUE_STRING) {
                    while (parser.nextToken() != null) {
                        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                            MarketingActivity mark = (MarketingActivity)parser.readValueAs(MarketingActivity.class);
                            activities.add(mark);
                            parser.skipChildren();
                        }
                    }
                }
            }
        }
        activities.sort();
        if (activities.size() > 0)
            showMktg=true;
        else{
            showNoMktg=true;
        }
        return null;
    }  
    
    /* @method: Get the list of Opportunity which are associated Sales Contact Account
    // @return: Standard Set Controller with the list of Opportunity associated Sales Contact Account */
    public ApexPages.StandardSetController setOppty {
        get{
            try{
                if(setOppty == null){
                    size = 5;
                    Lead aId=[Select Lead_Contact__r.AccountId from Lead where Id =:mLead.Id LIMIT 1];
                    
                    if(aId.Lead_Contact__r.AccountId != NULL)
                    {
                        string queryString = 'SELECT ';
                         for (Schema.FieldSetMember f: SObjectType.Opportunity.FieldSets.NGCCSalesHistory.getFields()) {
                                    queryString += f.getFieldPath() + ', ';
                         }
                        queryString += 'Id,Description FROM Opportunity Where AccountId =\'' + aId.Lead_Contact__r.AccountId +'\'  AND LastModifiedDate = LAST_N_DAYS:180  ORDER By LastModifiedDate desc' ;               
                            setOppty = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));  
                            setOppty.setPageSize(size);
                            noOfRecords = setOppty.getResultSize();
                    }
                    else
                    {
                        noOfRecords = 0;
                    }
                 }
                
            }catch(Exception e)
            {
                errMsgNoRecord = 'No Sales History to Show';
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,errMsgNoRecord  ));
            }
            return setOppty;
        }set;
    }
    
    /* @method: Pass the list of the opportunity to Visualforce page */
    public List<Opportunity> getOpptys(){
        List<Opportunity> opptyList = new List<Opportunity>();        
            if(setOppty != Null)
            {    
                for(Opportunity o : (List<Opportunity>)setOppty.getRecords())
                    opptyList.add(o);                   
            }
        return opptyList;
    }
    
    /* @method: Get the list of lead which are associated Sales Contact Account
    // @return: Standard Set Controller with the list of lead associated Sales Contact Account */ 
    public ApexPages.StandardSetController setLead {
        get{
            try{
                if(setLead == null){
                    
                    Set<Id> leadrecordtypeset = new Set<Id>();
                    
                    ObjectRecordTypeIds__c orgConstant = ObjectRecordTypeIds__c.getInstance(); 
                    String prospectrecordtype = orgConstant.Marketing_Lead_RecordType__c;
                    String qualifiedrecordtype = orgConstant.Marketing_Qualified_Lead__c; 
                    
                    leadrecordtypeset.add(prospectrecordtype);
                    leadrecordtypeset.add(qualifiedrecordtype);
                    
                    size = 5;
                    Lead aId=[Select Lead_Contact__r.AccountId,MODS_Contact__c from Lead where Id =:mLead.Id LIMIT 1];
                    
                    if(aId.Lead_Contact__r.AccountId != NULL || aId.MODS_Contact__c != NULL)
                    {
                        string queryString = 'SELECT ';
                         for (Schema.FieldSetMember f: SObjectType.Lead.FieldSets.NGCCLeadSalesHistory.getFields()) {
                                    queryString += f.getFieldPath() + ', ';
                         }
                        queryString += 'Id,Description FROM Lead Where ((';
                        
                        IF(aId.Lead_Contact__r.AccountId != NULL && aId.MODS_Contact__c != NULL){
                            queryString += 'End_Customer_Account__c =\'' + aId.Lead_Contact__r.AccountId +'\' OR'; 
                            queryString += ' MODS_Contact__c='+ aId.MODS_Contact__c;
                        }
                        else If(aId.Lead_Contact__r.AccountId != NULL)
                        {
                            queryString += 'End_Customer_Account__c =\'' + aId.Lead_Contact__r.AccountId +'\''; 
                        }else If(aId.MODS_Contact__c != NULL)
                        {
                            queryString += ' MODS_Contact__c='+ aId.MODS_Contact__c;
                        }
                        
                        queryString += ') AND RecordtypeId NOT IN:leadrecordtypeset) AND LastModifiedDate = LAST_N_DAYS:180 ORDER By LastModifiedDate' ;
                        
                        setLead = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
                        setLead.setPageSize(size);
                        noOfLeadRecords = setLead.getResultSize();
                    }
                    else
                    {
                        noOfLeadRecords= 0;
                        size=0;
                    }                        
                }    
            }catch(Exception e){
                errMsgNoRecord = 'No Sales History to Show';
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,errMsgNoRecord  ));
            }
            return setLead;
        }set;
    }
 
    /* @ method: Pass the list of the lead to Visualforce page */
    Public List<Lead> getLeads(){
        List<Lead> leadsList = new List<Lead>();
            if(setLead != Null)
            {    
                for(Lead o : (List<Lead>)setLead.getRecords())
                    leadsList.add(o);
            }
        return leadsList;
    }
}