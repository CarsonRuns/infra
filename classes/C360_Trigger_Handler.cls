/************************************************************************************************************************************
Name    : C360_Trigger_Handler
Author  : C360 Dev team
Purpose : Interface for triggers, moving forward all object need to implement this interface
Date	: 22/05/2019
Change History : None
*************************************************************************************************************************************/

public interface C360_Trigger_Handler {

	/** 
    * @description Called by the trigger framework to fetch records before trigger actions get started.
    */
    void preProcess();
    
    /** 
    * @description Called by the trigger framework to carry out the actions before the records are inserted.
    */
    void processBeforeInsert();
    
    /** 
    * @description Called by the trigger framework to carry out the actions before the records are updated. 
    */
    void processBeforeUpdate();
    
    /** 
    * @description Called by the trigger framework to carry out the actions before the records are deleted.
    */
    void processBeforeDelete();
    
    /** 
    * @description Called by the trigger framework to carry out the actions after the records are inserted.
    */
    void processAfterInsert();
    
    /** 
    * @description Called by the trigger framework to carry out the actions after the records are updated.
    */
    void processAfterUpdate();
    
    /** 
    * @description Called by the trigger framework to carry out the actions after the records are deleted.
    */
    void processAfterDelete();
    
    /** 
    * @description Called by the trigger framework to carry out the actions after the records are undeleted.
    */
    void processAfterUnDelete();
    
    /** 
    * @description Called by the trigger framework to commit changes to the SFDC after trigger actions completed.
    */
    void postProcess();
  
}