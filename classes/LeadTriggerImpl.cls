/*
    Name            : LeadTriggerImpl 
    Author          : Eric Pesch (epesch)
    Release         : 1.0
    Functionality   : Trigger Handler for the Lead SObject. This class implements the TriggerInterface
    Created         : Sep 14 2015
    
    Modification History:
    Date        Author          Change 
    02/14/2017  majanard Added leadUpdateFromChannelPartner to update Lead - Theater and Funding Source based on assigned Channel Partner.
    02/14/2017  majanard Added leadApiTransformation to set Lead transformation value in BeforeInsert event.
*/
public class LeadTriggerImpl implements TriggerInterface {
    
    /**
     * @description beforeInit setup methods
     */
    public void beforeInit(){
        
    } 
    
    /**
     * @description afterInit setup methods
     */
    public void afterInit(){
    
    }
    
    /**
     * @description Trigger.beforeInsert methods
     */ 
    public void executeBeforeInsert(){
        
        // Modified By: Sudi 19 Oct 2014 
        // Release : November Sprint 3
        // User Story : US7053 
        // Below code is doing to map the Lead_From_Distributor_lookUp__c field based on Lead from BE GEO ID
        //Original work
        LeadBO.addDistributorInsert(Trigger.new);
        LeadBO.addMigratedAccount(Trigger.new); 
        
        //Original SourceFire work
        SourceFireInsertFieldsandNotifications.validateCECID(Trigger.new);
        
        //Original LeadGeoLoc work
        LeadBo.addGeoLocTag(Trigger.new, null);
        
        //9-8 TAC Lead work
        LeadBO.processTACLead(Trigger.new);
        
        //BEFORE INSERT
        LeadBO.addPartnerStatus(Trigger.new);
        //Lead Category update
        LeadBO.leadCategoryUpdate(Trigger.new);
        
        //LeadAPI Transformation Rules
        LeadBO.leadApiTransformation(Trigger.new);
    }

    /**
     * @description Trigger.afterInsert methods
     */
    public void executeAfterInsert(){
        LeadBO.touchTACLead(Trigger.new);
        //NGCC
        LeadBO.leadProspectDeduping(Trigger.new);
        
    }

    /**
     * @description Trigger.beforeUpdate methods
     */
    public void executeBeforeUpdate(){ 
        //10-15 Lead Priority work
        LeadBO.updateLeadPriority(Trigger.new);
        
        //10-13 TAC Partner Stopgap
        LeadBO.removeTACPartner(Trigger.new, Trigger.oldMap);
        
        //Original LeadHandler work
        LeadBO.addDistributorUpdate(Trigger.new, Trigger.oldMap);
        LeadBO.processPartnerLeadBefore(Trigger.new, Trigger.oldMap);
        
        //Original LeadGeoLoc work
        LeadBO.addGeoLocTag(Trigger.new, Trigger.oldMap);
        
        //Update PMC/Zift leads based on Channel Partner - Funding Source & Theater
        LeadBO.leadUpdateFromChannelPartner(Trigger.new, Trigger.oldMap);
    }

    /**
     * @description Trigger.afterUpdate methods
     */
    public void executeAfterUpdate(){
        if(!SourceFireInsertFieldsandNotifications.isSFire){ 
            SourceFireInsertFieldsandNotifications.updateStataustoSourceFire(Trigger.new);
        }   
        
        LeadBO.processPartnerLeadAfter(Trigger.new, Trigger.oldMap);        
        
    }
    
    /**
     * @description Trigger.beforeDelete methods
     */
    public void executeBeforeDelete(){
        
    }

    /**
     * @description Trigger.afterDelete methods
     */
    public void executeAfterDelete(){

    }

    /**
     * @description Trigger.undelete methods
     */
    public void executeUnDelete(){
        
    }
}