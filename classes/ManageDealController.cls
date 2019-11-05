/************
Author: Accenture
Project: GDR
Description: Class used for ManageInvitePage and ManageDealPage Buttons of Quote Invitation Object
***********/

public class ManageDealController{
    public Opportunity oppty {get; protected set;}
    public string opptyid;
    public string pdrdown {get;set;}    
    public string baseURL {get;set;}
    public boolean profilecheck {get;set;}
    public ManageDealController(ApexPages.StandardSetController controller) {
        opptyid = ApexPages.currentPage().getParameters().get('id'); // getting opportunity Id from the URL after click of Manage Invite/Manage deal buttons.
    }
  public void manageDealinfo(){  // Method to get all the Opportunity fields to pass VF page.
           pdrdown = Utilities.getConstant_CS('PDR Down'); // getting PDR DOWN value from custom setting
           baseURL= Utilities.getConstant_CS('PDR URL');
           String profileName = [SELECT Name FROM Profile WHERE Id =: UserInfo.getProfileId()].Name;
            String PdrSkipUser =Utilities.getConstant_CS('PDR_Skip_Users');
            List<String> skipuser = PdrSkipUser.split(',');
            set<string> PdrSkipUsers = new set<string>(skipuser); 
           if(profileName.startsWith('QA') || pdrskipusers.contains(userinfo.getUserid().substring(0,15))){
               profilecheck = false;
           }
           else{
               profilecheck = true;
           }
           if(string.isNotBlank(opptyid)){ // checking if Opportunity is not blank
               this.oppty = [SELECT Id, Name,DealID__c,Deal_Type__c,Opportunity_Status__c,RecordTypeId,Quote_Count__c,Partner_Deal_Status__c,Contractual_Pricing_Letter_Opportunity__c,IS_FA_FLAG__c,Global_Opportunity__c FROM Opportunity WHERE Id=: opptyid];   
           }
  }      
}