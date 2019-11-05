/**
* Class OpportunityTriggerImpl
*
* Trigger Handler for the Opportunity SObject. This class implements the ITrigger
* interface to help ensure the trigger code is bulkified and all in one place.
***** Change History *****
* 9/28 - BeforeInsert & BeforeUpdate - set the Solution ID lookup value based on Picklist Value.
*
Modification History:
Itrack#        Date        		Author              		Change  
****************************************************************************
US250307     Feb 15,2019   Kavya M(kavmalli)                PSS - Edit Oppty fields except $, Book Date and Stage, Technology/Service line items
**********************************************/

public without sharing class OpportunityTriggerImpl
implements TriggerInterface
{
    private String parentMobileRecTypeId; 
    private String parentRecTypeId; 
    private String runningUserTheater;
    private Boolean isRunningUserPss = false;
    public static boolean sparkRun = false;
    
    // Constructor
    public void beforeInit(){
        //initiate any required variables or data for one time caching to be used in before operations
        this.parentMobileRecTypeId = ObjectRecordTypeIds__c.getInstance().Opportunity_Parent_Mobile_RecordTypeId__c;
        this.parentRecTypeId = ObjectRecordTypeIds__c.getInstance().Opportunity_Parent_RecordTypeId__c;
        User runningUser = [Select Theatre__c,Additional_User_Permissions__c From User where id =:UserInfo.getUserId()];
        if( runningUser != null ){
            if( runningUser.Theatre__c != null  ){
                this.runningUserTheater = runningUser.Theatre__c;
            }            
            if( runningUser.Additional_User_Permissions__c != null && runningUser.Additional_User_Permissions__c.contains('Enable_ePSS')){
                this.isRunningUserPss = true;
            }
        }     
    }
    
    public void afterInit(){
        //initiate any required variables or data for one time caching to be used in after operations
    }
    
    public void executeBeforeInsert(){
        system.debug('***Opty BEFORE INSERT****');
        OptyBO.CreteOptyUsingMobile(Trigger.new, parentMobileRecTypeId, parentRecTypeId, runningUserTheater, isRunningUserPss);
        if(!Trigger.isDelete){
            OptyBO.UpdateSolutionID(Trigger.new);           
        }
        //Added by Alekhya (Logic from OwnerAssignmentbyAT trigger)
        OptyBO.ownerAssignmentbyAT(Trigger.new);
        
        //Added by Alekhya (Logic from OpptyMandatoryCompetitor trigger)
        OptyBO.opptyMandatoryCompetitor(Trigger.new, Trigger.oldMap,Trigger.isUpdate,Trigger.isInsert);
        
        //Added by Alekhya (Logic from OpptyOwnerPostnChk trigger)
        OptyBO.opptyOwnerPostnChk(Trigger.new, Trigger.oldMap,Trigger.isInsert);
        
        //Added by Alekhya (Logic from OpptyValidationRuleChk trigger)
        OptyBO.opptyValidationRuleChk(Trigger.new, Trigger.oldMap,Trigger.isUpdate,Trigger.isInsert);
        
    }
    
    
    public void executeAfterInsert(){
        system.debug('***Opty AFTER INSERT****');
        OptyBO.NoEPSSOpptyOwner(Trigger.new);
        //Added by Alekhya (Logic from OpptyGetDealId trigger)
        OptyBO.OpptyGetDealId(Trigger.new, Trigger.oldMap, Trigger.isUpdate);
        //Added by Alekhya (Logic from PartnerUpdate trigger)
        OptyBO.partnerUpdate(Trigger.new, Trigger.oldMap,Trigger.isInsert);
        //Added by Alekhya (Logic from OpportunityExpectedAmtChanged  trigger)
        OptyBO.opportunityExpectedAmtChanged (Trigger.new, Trigger.old, Trigger.newMap,Trigger.isInsert,Trigger.isUpdate);
                
    }
    
    public void executeBeforeUpdate(){
        system.debug('***Opty BEFORE UPDATE****');  
        if(!Trigger.isDelete){
            OptyBO.UpdateSolutionID(Trigger.new);  
            
            //OptyBO.opportunitySparkRecordUpdate(Trigger.new, Trigger.oldMap);            
            //Added By: Kavya M(kavmalli)
            if(Utilities.getisPSSUser()) {
                return;
            }
            //added to check whether trigger is execute twice
            else if(!Utilities.getisTriggerRun()){
                Utilities.setisTriggerRun(true);
                String value = lxPilotUserCheck.CheckBeforeUpdate(Trigger.oldMap,Trigger.new,'noLines');  
            }
        }
        
         //Added by Alekhya (Logic from OpptyMandatoryCompetitor trigger)
        OptyBO.opptyMandatoryCompetitor(Trigger.new, Trigger.oldMap,Trigger.isUpdate,Trigger.isInsert);
        
        //Added by Alekhya (Logic from OpptyOwnerPostnChk trigger)
        OptyBO.opptyOwnerPostnChk(Trigger.new, Trigger.oldMap,Trigger.isInsert);
        
         //Added by Alekhya (Logic from OpptyValidationRuleChk trigger)
        OptyBO.opptyValidationRuleChk(Trigger.new, Trigger.oldMap,Trigger.isUpdate,Trigger.isInsert);
        
    }
    
    public void executeAfterUpdate()
    {      
        system.debug('***Opty AFTER Update****');
        //Added By: Kavya M(kavmalli)
        lxOpportunityUpdateForPB.updateRecords(Trigger.new, Trigger.oldMap);
        // Added as part of VDC Program to populate Opportunity Information on the Lead Record
        OptyBO.updateOpportunityOnLead(Trigger.new, Trigger.oldMap);
        //Added by Alekhya (Logic from OpptyGetDealId trigger)
        OptyBO.opptyGetDealId(Trigger.new, Trigger.oldMap,  Trigger.isUpdate);
        //Added by Alekhya (Logic from OpptyFutureUpdate trigger)
        OptyBO.opptyFutureUpdate(Trigger.new, Trigger.oldMap,  Trigger.isUpdate);
        //Added by Alekhya (Logic from opptyChildUpdate trigger)
        OptyBO.opptyChildUpdate(Trigger.new, Trigger.old);
        //Added by Alekhya (Logic from PartnerUpdate trigger)
        OptyBO.partnerUpdate(Trigger.new, Trigger.oldMap,Trigger.isInsert);
        //Added by Alekhya (Logic from OpportunityExpectedAmtChanged  trigger)
        OptyBO.opportunityExpectedAmtChanged (Trigger.new, Trigger.old, Trigger.newMap,Trigger.isInsert,Trigger.isUpdate);
    }
    
    
    public void executeBeforeDelete(){
        system.debug('***Opty BEFORE DELETE****'); 
        //Added by Alekhya (Logic from OpportunityBeforeDelete trigger)
        OptyBO.opportunityBeforeDelete(Trigger.old);     
    }
    
    public void executeAfterDelete(){}
    
    public void executeUnDelete(){}
}