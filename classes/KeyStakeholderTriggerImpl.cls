/*
  Name        : KeyStakeholderTriggerImpl
  Author      : Serge Borysov (sborysov)
  Release     : 1.0
  Functionality   : Implementation class of Trigger Interface 
  Created      : June 13 2019
  
  Modification History:
  Date    Author      Change 
*/

public class KeyStakeholderTriggerImpl implements TriggerInterface {
    
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
        
        // checks whether or not a the primary contact has already been set for the parent Account 
        System.debug(Trigger.new);
        KeyStakeholderTriggerUtil.primaryContactExists(Trigger.new);
    }

    /**
     * @description Trigger.afterInsert methods
     */
    public void executeAfterInsert(){
        
    }

    /**
     * @description Trigger.beforeUpdate methods
     */
    public void executeBeforeUpdate(){ 
        // checks whether or not a the primary contact has already been set for the parent Account
        KeyStakeholderTriggerUtil.primaryContactExists(Trigger.new);
    }

    /**
     * @description Trigger.afterUpdate methods
     */
    public void executeAfterUpdate(){
        
        
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