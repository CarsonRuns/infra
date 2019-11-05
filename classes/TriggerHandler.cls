/************************************************************************************************************************************
Name    : TriggerHandler
Author  : Bramhananda Naidu Dabbara
Purpose : Handler Class to invoke the trigger event functions.
Created Date:  7/6/2015
Modification History:
- 9/16 INC000033970568 - Changed to without sharing.
*************************************************************************************************************************************/

public without sharing class TriggerHandler
{

    static TriggerInterface triggerImpl = null;

    public static Integer beforeTriggerExecute = 0;

    public static Integer afterTriggerExecute = 0;
    
    private static TriggerInterface getImplClass(Type implClass)
    {
        // Instantiate the type
        Object o = implClass.newInstance();
 
        // if its not an instance of TriggerInterface return null
        if (!(o instanceOf TriggerInterface))
        {
            return null;
        }
 
        return (TriggerInterface)o;     
    }

/************************************************************************************************************************************
Main execute method that will be called from Trigger and will instantiate the main implementation class and invoke the right event type
*************************************************************************************************************************************/
    public static void execute(Type implClass)
    {
        //instantiate the implemetnation class
        triggerImpl = getImplClass(implClass);

        if (Trigger.isBefore)
        {
            //increment the number of before Trigger execution
            beforeTriggerExecute++;
            beforeInit();
            if(Trigger.isInsert)
            {
                executeBeforeInsert();
            }
            else if(Trigger.isUpdate)
            {
                executeBeforeUpdate();
            }
            else if(Trigger.isDelete)
            {
                executeBeforeDelete();
            }

        }
        else if(Trigger.isAfter)
        {
            afterTriggerExecute++;

            if(Trigger.isInsert)
            {
                executeAfterInsert();
            }
            else if(Trigger.isUpdate)
            {
                executeAfterUpdate();
            }
            else if(Trigger.isDelete)
            {
                executeAfterDelete();
            }

        }
        else if(Trigger.isUndelete)
        {
            executeUnDelete();
        }
        //print the number of times the event has executed
        System.debug('Class ='+implClass + '  beforeTriggerExecute='+beforeTriggerExecute + ' afterTriggerExecute='+afterTriggerExecute );
    }

/************************************************************************************************************************************
init method is called once on before trigger call so as to cache any data to be used across trigger before transaction
*************************************************************************************************************************************/

    public static void beforeInit(){
        if(beforeTriggerExecute==1){
            triggerImpl.beforeInit();
        }
    }

/************************************************************************************************************************************
init method is called once on before trigger call so as to cache any data to be used across trigger after transaction
*************************************************************************************************************************************/
    public static void afterInit(){
        if(afterTriggerExecute==1){
            triggerImpl.afterInit();
        }
    }
/************************************************************************************************************************************
Trigger before insert event
*************************************************************************************************************************************/

    public static void executeBeforeInsert(){
        triggerImpl.executeBeforeInsert();
    }

/************************************************************************************************************************************
Trigger after insert event
*************************************************************************************************************************************/

    public static void executeAfterInsert(){
        triggerImpl.executeAfterInsert();
    }

/************************************************************************************************************************************
Trigger before update event
*************************************************************************************************************************************/

    public static void executeBeforeUpdate(){
        triggerImpl.executeBeforeUpdate();
    }
/************************************************************************************************************************************
Trigger after update event
*************************************************************************************************************************************/
    public static void executeAfterUpdate(){
        triggerImpl.executeAfterUpdate();
    }

/************************************************************************************************************************************
Trigger before delete event
*************************************************************************************************************************************/
    public static void executeBeforeDelete(){
        triggerImpl.executeBeforeDelete();
    }

/************************************************************************************************************************************
Trigger after delete event
*************************************************************************************************************************************/
    public static void executeAfterDelete(){
        triggerImpl.executeAfterDelete();
    }
/************************************************************************************************************************************
Trigger un delete event
*************************************************************************************************************************************/
    public static void executeUnDelete(){
        triggerImpl.executeUnDelete();
    }
}