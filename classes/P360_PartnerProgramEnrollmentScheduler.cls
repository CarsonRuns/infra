global class  P360_PartnerProgramEnrollmentScheduler implements Schedulable {
    
    // SCAVA Helper Method to validate Create Access at field level
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }
    
    global void execute(SchedulableContext SC) {
        try
        {
            String query = Utilities.getConstant_CS('P360_PPEScheduler_Query');
            P360_PartnerProgramEnrollmentUpdate p = new P360_PartnerProgramEnrollmentUpdate(query);
            Database.executeBatch(p,50); 
            Tx_Log__c tl = new Tx_Log__c();
            //SCAVA FIX
            if(flsGet(Tx_Log__c.exception__c))
            {
            tl.exception__c = false;
            }
            if(flsGet(Tx_Log__c.message__c))
            {
            tl.message__c = 'Query - ' + query;
            }
            if(flsGet(Tx_Log__c.originated__c))
            {
            tl.originated__c = 'P360_PartnerProgramEnrollmentScheduler';
            }
            if(flsGet(Tx_Log__c.type__c))
            {
            tl.type__c = 'P360_Account_Job';
            }
            insert tl;
            
        }  
        Catch(Exception e)
        {
            Tx_Log__c tl = new Tx_Log__c();
            //SCAVA FIX
            if(flsGet(Tx_Log__c.exception__c))
            {
            tl.exception__c = true;
            }
            if(flsGet(Tx_Log__c.message__c))
            {
            tl.message__c = e.getMessage();
            }
            if(flsGet(Tx_Log__c.originated__c))
            {
            tl.originated__c = 'P360_PartnerProgramEnrollmentScheduler';
            }
            if(flsGet(Tx_Log__c.type__c))
            {
            tl.type__c = 'P360_Account_Job';
            }
            insert tl;
        }
    }

}