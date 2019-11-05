/*********************************************************************************************************************************
Name    : EloquaCampaignAssociationUpdate 
Author  : Mukesh Srivastava
Purpose : The purpose of the class to handle after insert operation on Eloqua Leads association with campaign           
Created Date:  2/24/2015 
Modification History: 
                      
**********************************************************************************************************************************/

trigger EloquaCampaignAssociationUpdate on CampaignMember (after insert,after update) {
    EloquaCampaignAssociationUpdateTrg_Cls.CampaignMemberProcessing(Trigger.New);
}