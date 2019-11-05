/************************************************************************************************************************************
Name    : AccountTriggerImpl 
Author  : Brijesh
Purpose : Trigger Handler for the Account SObject. This class implements the TriggerInterface
Created Date:  7/6/2015
Modification History: Sournaga- Code clean up,added comments

*************************************************************************************************************************************/

public class AccountTriggerImpl implements TriggerInterface
{

    public void beforeInit(){
        //initiate any required variables or data for one time caching to be used in before operations

    }

    public void afterInit(){
        //initiate any required variables or data for one time caching to be used in after operations
    }
    
    //Method to be executed on before insert event
    public void executeBeforeInsert(){
        //Copy the account phone number to jabber phone field and  clean it before saving the jabber phone number        
        new JabberPhoneCleanUpcls().JabberAccountPhoneClean(trigger.new);
        
        //PerformanceSuite® App Package event process call.
        //Commented on 10/21 as the package is not in use.
        //new UM_ITAAccountTriggerHandler(Trigger.new).fire();
        
        //Jigsaw - Account Sync status error check on insert.
        // AccountBO.jigsawImport(trigger.new);
        
        //Calculate the Account Potential Dollar based on Country, Employees & Industry selected.
        // AccountBO.AccountPotentialDollar(trigger.new);
    }

    //Method to be executed on after insert event
    public void executeAfterInsert(){
        // Create Target Prospect (TP) based on the Allocated Partners.
        //P360_TP_Created_Basedon_CI_Allocation.onCreationAndUpdation(Trigger.new, new Map<ID,Account>());
    }
    //Method to be executed on before update event
    public void executeBeforeUpdate(){
        //Update GEO location field based on the Assigned Partner CR Adress change
        AccountBO.accountGeoLocBeforeUpsertBatch(trigger.new);
        
        //Copy the Account phone number to Jabber phone field and  clean it before saving the jabber phone number
        AccountBO.jabberPhoneClean(trigger.oldMap,trigger.new);
        
        //Calculate the Account Potential Dollar based on Country, Employees & Industry selected.
       // AccountBO.AccountPotentialDollar(trigger.new);

    }
    
    //Method to be executed on after update event
    public void executeAfterUpdate(){
        //On change of Channel Partner status, update the related Contact status.
        AccountBO.channelAccountandContactSync(trigger.oldMap,trigger.new);
        
        //Calculate Partner resharing when the Account Owner is changed.
        AccountBO.P360PartnerResharing(trigger.oldMap,trigger.new);
    }
    
    //Method to be executed on before delete event
    public void executeBeforeDelete(){
        //Check if the user has permission to delete the account and display appropriate error if permission doesn't exist.
        AccountBO.accountDelete(trigger.old);
    }
    
    //Method to be executed on after delete event
    public void executeAfterDelete(){}
    
    //Method to be executed on un-delete event
    public void executeUnDelete(){}
}