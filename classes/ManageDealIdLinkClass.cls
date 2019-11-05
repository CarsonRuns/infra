/************
Author: Accenture
Project: GDR
Description: Class used for InvitationDealIdLinkPage of Quote Invitation Object. When user click on 'CCW Deal Id' link works this code
***********/

public class ManageDealIdLinkClass{
    public Opportunity oppty {get; protected set;}
    public string opportunityId{get;set;}
    public string quoteid{get;set;}
    public string dealType{get;set;}
    public string ccwdealid{get;set;}
    public string pdrdown {get;set;}    
    public string baseURL {get;set;}
    public boolean profilecheck {get;set;}
    public ManageDealIdLinkClass(ApexPages.StandardSetController controller) {
        this.opportunityId = ApexPages.currentPage().getParameters().get('oppid'); //getting OpportunityId from URL
    }
  public void manageDealIdLink(){  // Method to get all the Opportunity fields to pass VF page.
           pdrdown = Utilities.getConstant_CS('PDR Down'); // getting PDR DOWN value from custom setting
           baseURL= Utilities.getConstant_CS('PDR URL');
           dealType= ApexPages.currentPage().getParameters().get('dealtype'); //getting dealType from current page
           quoteid = ApexPages.currentPage().getParameters().get('quoteid'); //getting quoteId from current page
           ccwdealid= ApexPages.currentPage().getParameters().get('ccwdealid');//getting CCWDealId from current page
           opportunityId = ApexPages.currentPage().getParameters().get('oppid');//getting OptyId from current page
           String profileName = [SELECT Name FROM Profile WHERE Id =: UserInfo.getProfileId()].Name; //getting current user profile name
           if(profileName.startsWith('QA')){  // check if profile name not starts with QA
               profilecheck = false;
           }
           else{
               profilecheck = true;
           }
           if(string.isNotBlank(opportunityId)){ // checking if Opportunity is not blank
               this.oppty = [SELECT Id, Name,DealID__c,Deal_Type__c,Opportunity_Status__c,RecordTypeId,Quote_Count__c,Partner_Deal_Status__c,Contractual_Pricing_Letter_Opportunity__c,IS_FA_FLAG__c FROM Opportunity WHERE Id=: opportunityId];   
           }
  }      
}