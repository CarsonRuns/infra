/************************************************************************************************************************************
Name    : ExceptionUtilities
Author  : Sournaga
Purpose : To store all exceptions occured during DAL operations by end user actions.
Created Date:  9/1/2015
Modification History: N/A 

*************************************************************************************************************************************/
Public class ExceptionUtilities{
    
    
    // SCAVA Helper Method to validate Create Access at field level
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }

    //Insert the exception details in exception object
    public void insertException(Exception e, string objName){
        Exception_Log__c exp= new Exception_Log__c();
        //SCAVA FIX
               if(flsGet(Exception_Log__c.sObject_Name__c))
                {
                    exp.sObject_Name__c = objName;

                }
                if(flsGet(Exception_Log__c.Running_User__c))
                {
                    exp.Running_User__c = UserInfo.getUserId();
                }
                if(flsGet(Exception_Log__c.Exception_Message__c))
                {
                    exp.Exception_Message__c ='Message: '+ e.getMessage()+', Cause: '+e.getCause()+', Stack trace: '+e.getStackTraceString();
                }
        Database.SaveResult SR = Database.insert(exp);   
    }
}