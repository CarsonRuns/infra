/*********************************************************************************************************************************
Name    : EloquaCampaignAssociationUpdateTrg_Cls
Author  : Mukesh Srivastava
Purpose : The purpose of the class to handle after insert operation on Eloqua Leads association .Updating all the eloqua leads 
          which doesnt have Program event details          
Created Date:  2/24/2015 
Modification History: 
                      
**********************************************************************************************************************************/
public class EloquaCampaignAssociationUpdateTrg_Cls{
     
    /* Collect all the Leads associated to Campaign*/
    public static void CampaignMemberProcessing(List<CampaignMember> newLstCM)
    {
            map<Id,CampaignMember> mapOfLead = new map<Id,CampaignMember>();
            Set<Id> setCampaign = new Set<Id>();
                    
            for(CampaignMember cmObj : newLstCM){
                if(cmObj.Eloqua_Campaign__c){
                    if(cmObj.LeadId != Null){
                        mapOfLead.put(cmObj.LeadId,cmObj); //Collecting map of Lead Id and Campaign Member Object
                        setCampaign.add(cmObj.CampaignId); //Collecting Set of Campaign Id for pulling Campaign details
                    }
                }
            }         
            
            if(!mapOfLead.isEmpty()){
                UpdateCampaignName(mapOfLead,setCampaign);
            }
    }
    /* Update the Leads attribute if the campaign detail at Lead level is blank*/
    public static void UpdateCampaignName(map<Id,CampaignMember> newCM_C,Set<Id> setOfCamp)
    {
        //Querying List of Campaigns used for member association
        Map<Id,Campaign> mapIdCampaign = new Map<Id,Campaign>([SELECT Id,Name,Description,Program_Event_Code__c from Campaign where Id IN :setOfCamp]);
        
        String userName = 'eloqua_integration@cisco.com';
        
        if(Test.isRunningTest()){
            userName = 'eloqua_integration@cisco.com.testing';
        }
       
        //Pull Lead detail which need the update
        List<Lead> lstLead = [Select Id,Program_Event_Name__c,ProgramEvent__c,Program_Event_Description__c,Campaign_Description__c from Lead where Id IN : newCM_C.keySet() AND CreatedBy.UserName=:userName];
        
        //Updating Lead detail with Campaign Information only if the details are missing.
        for(Lead lObj : lstLead){
            if(lObj.Program_Event_Name__c == NULL){
               lObj.Program_Event_Name__c = mapIdCampaign.get(newCM_C.get(lObj.Id).CampaignId).Name;
            }
            
            if(lObj.ProgramEvent__c == NULL){
              lObj.ProgramEvent__c = mapIdCampaign.get(newCM_C.get(lObj.Id).CampaignId).Program_Event_Code__c; 
            }
            
            if(lObj.Campaign_Description__c == NULL){                
                lObj.Campaign_Description__c = mapIdCampaign.get(newCM_C.get(lObj.Id).CampaignId).Description;
            }            
        }
        //Updating the updated list
        Database.SaveResult[] lstEloquaSaveResult = Database.update(lstLead, true);
    }
}