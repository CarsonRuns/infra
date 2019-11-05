/* 
    Name            : LeadTACDuplicateBatchApex 
    Author          : Eric Pesch (epesch)
    Release         : 1.0
    Functionality   : Batchable class to de-dupe TAC Generated Leads
    Created         : Sep 14 2015
    
    Modification History:
    Date        Author          Change 
*/

global class LeadTACDuplicateBatchApex implements Database.Batchable<sObject>{
    private final static String TAG = '[LeadTACDuplicateBatchApex] - ';
    
    /*
     * @description Dummy creation class
     */
    global LeadTACDuplicateBatchApex(){ }

    /*
     * @description Override on the Batchable start method
     * 
     * @param bc Batchable Context
     *
     * @return QueryLocator to the batches
     */
    global Database.QueryLocator start(Database.BatchableContext bc){
        DateTime createDateLimit;
        createDateLimit = DateTime.now();
        createDateLimit = createDateLimit.addDays(-Integer.valueOf(Utilities.getConstant_CS('Lead TAC Duplicate Delete Days')));
        
        System.debug(TAG + 'Current Date filter - ' + createDateLimit.formatGmt('yyyy-MM-dd HH:mm:ss'));
        System.debug(TAG + 'Current Date filter TZ - ' + createDateLimit.format('yyyy-MM-dd HH:mm:ss'));
        /*
        String query = 'select Id, LeadSource, Status '
            + 'from Lead '
            + 'where LeadSource = \'' + System.label.Lead_TAC_Generated_Source + '\' '
            + 'and Status = \'' + System.label.Lead_TAC_Reject_Status + '\' ' 
            + 'and CreatedDate < ' + createDateLimit.formatGmt('yyyy-MM-dd') + 'T' 
            + createDateLimit.formatGmt('HH:mm') + ':00.000Z ';
            
        //Only filter to those whose owner are still the Connection User
        //Prevents those manually moved to rejected to be deleted
        if(!Test.isRunningTest()){
            query += 'and LastModifiedBy.Name = null';
        }
        */
        //Quering as per the Confirm_Duplicate__c check box
        String query = 'select Id, LeadSource, Status '
            + 'from Lead '
            + 'where LeadSource = \'' + System.label.Lead_TAC_Generated_Source + '\' '
            + 'and Status = \'' + System.label.Lead_TAC_Reject_Status + '\' ' 
            + 'and Confirm_Duplicate__c=true';
        System.debug(TAG + 'Query - ' + query);
        
        return Database.getQueryLocator(query);
    }
    
    /*
     * @description Override on the execute method per batch
     * 
     * @param bc Batchable Context
     * @param scope List of Leads
     */
    global void execute(Database.BatchableContext bc, List<Lead> scope){
        System.debug(TAG + 'Start Execute');
        
        try {
            delete scope;
        } catch (Exception e){
            System.debug(TAG + 'Exception deleting Leads - ' + e.getStackTraceString());
        }
    }
    
    /*
     * @description Override on the finish method (after all batches completed)
     *
     * @param bc Batchable Context
     */
    global void finish(Database.BatchableContext bc){
        System.debug(TAG + 'End Execute');
    }
}