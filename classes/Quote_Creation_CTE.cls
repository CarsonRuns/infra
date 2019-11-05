/************
Author: Accenture
Project: GDR
Description: Class used in NewQuoteCreatepage for passing CCW parameters to UI
***********/

public with sharing class Quote_Creation_CTE{
    /*May 2018 Lightning Release change: start*/
    /*in case 'Create New Quote' is clicked from opportunity record detail page, opptyId is passed as parameter from URL*/
    String opptyId = ApexPages.currentPage().getParameters().get('opptyId');
  /*May 2018 Lightning Release change: end*/  
    
    public Opportunity oppty {get; protected set;}
    public string pdrdown {get;set;}
    private final Quote__c Quote;
    public string isArchived {get;set;}
    public string baseURL {get;set;}
    public boolean profilecheck {get;set;}
    private List<String> fieldsToRetrieve = new List<String>{'Account_Name__c', 'Id', 'Opportunity_Name__c', 'Quote_Flags__c'};

    public PageReference check() {  
        //Added by Pradeep : null check for Opportunity_Name__c
        String opportunityName = this.Quote.Opportunity_Name__c;
        if(opportunityName != '' && opportunityName != null) {  // Checking if opportunity name is null
            init();
            return null;
        } else {
            PageReference pr = Page.OpptySearch; //redirecting to Opportunity search page
            pr.getParameters().put('retURL', ApexPages.currentPage().getParameters().get('retURL'));
            pr.getParameters().put('AccountName', this.Quote.Account_Name__c);
            return pr;
        }
    }

    public Quote_Creation_CTE(ApexPages.StandardController stdController) {
       String browserType = Apexpages.currentPage().getHeaders().get('USER-AGENT'); 
       if(browserType != null && browserType.contains('MSIE')){
            Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=Edge');
        }
        if (!Test.isRunningTest()) {
            stdController.addFields(fieldsToRetrieve); //adding list of fields to controller
        }
         /*May 2018 Lightning Release change: start*/
        //this.Quote = (Quote__c)stdController.getRecord(); //getting quote record details into Quote variable
        /*in case 'Create New Quote' is clicked from Opportunity record detail page, opptyId is passed as parameter from URL, a new quote object
         needs to be generated*/
        if (opptyId != null && opptyId != ''){   
          //Opportunity  oppty = [SELECT Id, Name FROM Opportunity WHERE Id =: opptyId];
            Quote__c quote = new Quote__c();
            quote.Opportunity_Name__c = opptyId;
            this.Quote = quote;
        }
        /*Create a new quote from Quote related list*/
        else{
           this.Quote = (Quote__c)stdController.getRecord(); //getting quote record details into Quote variable 
          // this.Quote.Opportunity_Name__c = null;
        }
        system.debug('-------this.Quote-------'+stdController.getRecord());
        /*May 2018 Lightning Release change: end*/
    }

    public void init() { // method to get Opportunity record field values to be used in vf page UI
    
        pdrdown = Utilities.getConstant_CS('PDR Down'); // getting PDR Down value from custom setting
        String PdrSkipUser =Utilities.getConstant_CS('PDR_Skip_Users');
        List<String> skipuser = PdrSkipUser.split(',');
        set<string> PdrSkipUsers = new set<string>(skipuser); 
        system.debug('PdrSkipUsers!!!'+PdrSkipUsers+' '+ userinfo.getUserid());
        Integer countArch= [SELECT Count() FROM Quote__c WHERE Quote_Flags__c = 'Archived' AND Opportunity_Name__c =: this.Quote.Opportunity_Name__c LIMIT 1]; // checking Archived quote count
        isArchived = string.valueof(countArch); // converting to string
        baseURL= Utilities.getConstant_CS('PDR URL'); //getting CCW base URL from Utilities class
        String profileName = [SELECT Name FROM Profile WHERE Id =: UserInfo.getProfileId()].Name; //Query to get current user profile name
        
        if(profileName.startsWith('QA') || PdrSkipUsers.contains(userinfo.getUserid().substring(0,15))){ // checking if current user profile not starts with QA
            profilecheck = false;
        }else{
            profilecheck = true;
        }
        // Added by pradeep : To check whether opportunity id is there or not before querying record.
        system.debug('this.Quote'+this.Quote);
        String OptyId = this.Quote.Opportunity_Name__c;
        system.debug('Opprty Id :: '+optyId + '  -- opptyId ::'+opptyId);
        if( string.isNotBlank(OptyId)){
        this.oppty = [SELECT Id, Name,RecordTypeId, DealID__c,ownerId,owner.Name,RecordType.Name, Opportunity_Status__c,Deal_Type__c, Quote_Count__c, Partner_Deal_Status__c, Contractual_Pricing_Letter_Opportunity__c,Account.Name,
             Partner_Expected_Book_Date__c,Expected_Product__c,Expected_Service__c,StageName,Forecast_Status__c,Forecast_Discount__c,Opportunity_Owner_AM__c,Position__c,Lost_Cancelled_Reason__c,Cisco_Capital_Financing__c,Installed_Base__c,Competitors__c,Global_Opportunity__c FROM Opportunity WHERE Id =: OptyId];
        }
     }
  
 
}