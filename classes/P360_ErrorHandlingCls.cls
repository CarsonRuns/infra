//** Class to process errors occured during user onboarding**/
//** Author:     Mukesh JSC Team
//** Date:       12/20/2012

public class P360_ErrorHandlingCls{

    public static Tx_Log__c[] getErrorStatus(List<User> lstUser,LIST<Database.SaveResult> dbSaveResult)
    {
        List<Tx_Log__c> errObj=new List<Tx_Log__c>();
        Integer i=0;
        for(Database.SaveResult sr : dbSaveResult){ 
            if (sr.isSuccess()==false) 
            {              
                Database.Error[] errs = sr.getErrors();
                for(Database.Error err : errs)
                {
                    Tx_Log__c newErrorRecord = new Tx_Log__c();
                    newErrorRecord.name = 'Contact: '+ lstUser[i].ContactId;
                    newErrorRecord.originated__c = 'P360_PartnerPortalUserRedesign';
                    newErrorRecord.type__c = 'P360_Contact_Job';
                    newErrorRecord.exception__c = true;
                    newErrorRecord.message__c = err.getMessage()+err.getStatusCode();
                    errObj.add(newErrorRecord);
                }
            }
            i++;
        }
        return errObj;     
    }
}