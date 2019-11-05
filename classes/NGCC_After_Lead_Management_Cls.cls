/*********************************************************************************************************************************
Name    : NGCC_After_Lead_Management_Cls
Author  : Mukesh Srivastava
Purpose : The purpose of the class to handle after insert and update operation on Marketing Leads
            1) Create Campaign member Record when a lead is associated to campaign
            2) Update membership if the record is disassocaited
            
Created Date:  6/20/2014 
Modification History: 
                      
**********************************************************************************************************************************/
public class NGCC_After_Lead_Management_Cls{

     // SCAVA Helper Method
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }
    
    // SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdateGet(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }
    
    /* method: Process all the new lead created for Marketing*/
    public static void NGCC_Lead_Campaign_Association(List<Lead> newLstLead,Map<Id, Lead> mapOldLead)
    {
        List<Lead> lstNewLead= new List<Lead>();
        Map<Id,Id> mapRemoveLeadCamp = new Map<Id,Id>();
        String mktgLeadRecType;
        ObjectRecordTypeIds__c orgConstant = ObjectRecordTypeIds__c.getInstance();    // initiate custom setting contain object record type
        mktgLeadRecType = orgConstant.Marketing_Lead_RecordType__c;                   // assign marketing lead recordtype to variable
        
        for(Lead ldObj : newLstLead){
            if(ldObj.RecordTypeId == mktgLeadRecType)
            {
                if(mapOldLead == NULL){
                    if(ldObj.Campaign_Name__c != NULL){
                        lstNewLead.add(ldObj);
                    }
                }else{
                    if(ldObj.Campaign_Name__c != mapOldLead.get(ldObj.Id).Campaign_Name__c){
                        if(ldObj.Campaign_Name__c != NULL){
                            lstNewLead.add(ldObj);
                        }else{
                            mapRemoveLeadCamp.put(ldObj.Id,mapOldLead.get(ldObj.Id).Campaign_Name__c);
                        }                    
                    }
                }
            }
        }
        if(!lstNewLead.isEmpty()){
            NGCC_Add_Lead_Campaign_Member(lstNewLead);
        }
        if(!mapRemoveLeadCamp.isEmpty()){
            NGCC_Remove_Lead_Campaign_Member(mapRemoveLeadCamp);
        }
    }
  /* method: To add new campaign Member to the campaign*/
  public static void NGCC_Add_Lead_Campaign_Member(List<Lead> lstProcessCampMember){
      List<CampaignMember> lstCampMem= new List<CampaignMember>();
      
      for(Lead l: lstProcessCampMember){
          CampaignMember cmObj= new CampaignMember();
           //SCAVA FIX
           if(flsGet(CampaignMember.LeadId)||flsUpdateGet(CampaignMember.LeadId)){
           cmObj.LeadId = l.Id;      
          }
          //SCAVA FIX
          if(flsGet(CampaignMember.CampaignId)||flsUpdateGet(CampaignMember.CampaignId)){
          cmObj.CampaignId = l.Campaign_Name__c;
          }
          lstCampMem.add(cmObj);
          
      }
      
      Database.SaveResult[] dbInserMember = Database.Insert(lstCampMem, false);
  }
  
  /* method: To Remove existing lead from campaign member*/
  public static void NGCC_Remove_Lead_Campaign_Member(Map<Id,Id> mapRemoveCampMember){
      List<CampaignMember> lstCampMem= [Select Id,LeadId,CampaignID from CampaignMember where LeadId IN : mapRemoveCampMember.keySet()];
      //SCAVA
      if (CampaignMember.sObjectType.getDescribe().isDeletable()){
      Database.DeleteResult[] dbRemoveMember = Database.Delete(lstCampMem, false);
  }
 }
}