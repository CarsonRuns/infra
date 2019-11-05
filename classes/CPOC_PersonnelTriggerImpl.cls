/************************************************************************************************************************************
Name    : CPOC_PersonnelTriggerImpl 
Author  : Priyanka
Purpose : Trigger Handler for the CPOC_Personnel__c SObject. This class implements the TriggerInterface
Created Date:  28/7/2016
Modification History:

*************************************************************************************************************************************/

public class CPOC_PersonnelTriggerImpl implements TriggerInterface
{

    public void beforeInit(){
        //initiate any required variables or data for one time caching to be used in before operations

    }

    public void afterInit(){
        //initiate any required variables or data for one time caching to be used in after operations
    }
    
    //Method to be executed on before insert event
    public void executeBeforeInsert(){}

    //Method to be executed on after insert event
    public void executeAfterInsert(){
        // Calling handler class
    String dmlAction;
        
            dmlAction = 'upsert';
            new CPOCPersonnelTriggerHandler(Trigger.Old,Trigger.New).assignEngineerOnDML(dmlAction);    
        
    }
    //Method to be executed on before update event
    public void executeBeforeUpdate(){}
    
    //Method to be executed on after update event
    public void executeAfterUpdate(){}
    
    //Method to be executed on before delete event
    public void executeBeforeDelete(){}
    
    //Method to be executed on after delete event
    public void executeAfterDelete(){
    //Calling handler class
    String dmlAction;
        
            dmlAction = 'delete';
            new CPOCPersonnelTriggerHandler(Trigger.Old,Trigger.New).assignEngineerOnDML(dmlAction);    
       
    }
    
    //Method to be executed on un-delete event
    public void executeUnDelete(){}
}