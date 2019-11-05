/*********************************************************************************************************************************
Name    : EloquaCampaignAssociationUpdateTrg_Cls
Author  : Mukesh Srivastava
Purpose : The purpose of the class to handle after insert operation on Eloqua Leads association .Updating all the eloqua leads 
          which doesnt have Program event details          
Created Date:  2/24/2015 
Modification History: 
                      
**********************************************************************************************************************************/
public class EloquaCampaignAdvanceSetupTrg_Cls{
    /* Collect all the Leads associated to Campaign*/
    public static void CampaignAdvanceSetup(List<Campaign> lstCamps){
          
    List<CampaignMemberStatus> newCampaignMemberStatus = new List<CampaignMemberStatus>();
    Map < String, EloquaCampaignMemberStatus__c> eloquaCampaignStatus = EloquaCampaignMemberStatus__c.getAll();
    Map < String, EloquaFieldUpdates__c > eloquaFieldMapping = EloquaFieldUpdates__c.getAll();
    
    List<EloquaCampaignMemberStatus__c> sf=new list<EloquaCampaignMemberStatus__c>([Select Id from EloquaCampaignMemberStatus__c]);

    for (Campaign c : lstCamps) {
        // Add campaign ids to list for removal of campaign member status values 
                     
        if(c.Eloqua_Campaign_Id__c != NULL){
            for(EloquaCampaignMemberStatus__c eCS: eloquaCampaignStatus.values()){
                    newCampaignMemberStatus.add (new CampaignMemberStatus(
                    CampaignId=c.id,
                    HasResponded=eCS.HasResponded__c,
                    IsDefault=eCS.IsDefault__c,
                    Label=eCS.Name,
                    SortOrder=eCS.SortOrder__c.intValue()));        
            }
        }
              
    }//end loop
        if(!newCampaignMemberStatus.isEmpty()){
            insert newCampaignMemberStatus;
        }
    }
}