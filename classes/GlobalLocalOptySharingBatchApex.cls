/******************************************************************************
Name    : GlobalLocalOptySharingBatchApex
Author  : Narasimharao Muppalla
Purpose : Batch class for Global local opportunity sharing logic
Created Date:  11/29/2016

*******************************************************************************/
global class GlobalLocalOptySharingBatchApex implements Database.Batchable<sObject>{
    
    // SCAVA Helper Method to validate Create Access at field level
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }
    
    public String query;
    public List<Id> globalOptyListOfIds;
    public List<Opportunity> optyList;
    public List<Opportunity> localOptys;
    public List<OpportunityShare> listOpptyTeamMem;
    String email= Apex_Batch_Job__c.getInstance('GlobalLocalOptySharing').NotificationEmailId__c;
    global GlobalLocalOptySharingBatchApex(String qry){
        query=qry;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        System.debug('Query == '+query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> scope){
        System.debug('Scope:'+scope.size());
        globalOptyListOfIds = new List<Id>();
        optyList = new List<Opportunity>();
        listOpptyTeamMem = new List<OpportunityShare>();
        localOptys = new List<Opportunity>();
        List<Id> sharesToDelete = new List<Id>();
        
        for(Opportunity opp : scope){ 
           if(opp.Global_Opportunity__c != null ){
               globalOptyListOfIds.add(opp.Global_Opportunity__c); // Getting all the Global opportunities list
           } 
        } 
        system.debug('globalOptyListOfIds=='+globalOptyListOfIds);
        //Collecting all Local opportunities corresponding to a Global Opportunity and creating Opportunity Share record
        if(globalOptyListOfIds.size()>0){
            optyList = [Select Id,Name,Global_Opportunity__c,OwnerId, (Select Name,OwnerId FROM Local_global_Opportunities__r) FROM Opportunity where Id in :globalOptyListOfIds];
            if(optyList.size()>0){
                for(Opportunity globalOpp:optyList){
                     localOptys = globalOpp.Local_global_Opportunities__r; 
                    for(Opportunity localOpp:localOptys){
                        sharesToDelete.add(localOpp.Id);
                        if(globalOpp.OwnerId != localOpp.OwnerId){
                            OpportunityShare os = new OpportunityShare();
                            //SCAVA FIX
                            if(flsGet(OpportunityShare.OpportunityId))
                            {
                            os.OpportunityId = localOpp.Id; 
                            }
                            if(flsGet(OpportunityShare.OpportunityAccessLevel))
                            {
                            os.OpportunityAccessLevel = 'read';
                            }
                            if(flsGet(OpportunityShare.UserOrGroupId))
                            {
                            os.UserOrGroupId = globalOpp.OwnerId;
                            }
                            if(flsGet(OpportunityShare.RowCause))
                            {
                            os.RowCause = 'Manual';
                            }
                            listOpptyTeamMem.add(os);
                            system.debug('userRecordAccess====='+listOpptyTeamMem);
                        }
                    }
                }
            }       
        }
        if(!sharesToDelete.isEmpty()){
            try{
            List<OpportunityShare> optyshares = [select id from OpportunityShare where OpportunityId IN :sharesToDelete and RowCause = 'Manual'];
                system.debug('optyshares'+optyshares);
                //SCAVA FIX
                if (OpportunityShare.sObjectType.getDescribe().isDeletable())
                {
                delete optyshares;
                }
               } Catch(Exception e){
                   System.debug('The following exception has occurred in delete: ' + e.getMessage());
               }
        }
        if(listOpptyTeamMem.size()>0){
            try{
               insert listOpptyTeamMem;
            } Catch(Exception e){
               System.debug('The following exception has occurred in insert: ' + e.getMessage());
            } 
        }          
    }    
    
    global void finish(Database.BatchableContext BC){
        system.debug('Job Finished at :' + system.now());
        sendEmail(BC.getJobId());
    }
        
    global void sendEmail(Id JobId){  //Email functionality after batch processing
        AsyncApexJob aaj = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors FROM AsyncApexJob WHERE ID =: JobId ];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Opportunity Sharing job - '+ System.Today());
        String MailBody = 'Status : ' + aaj.Status + '<br/>';
        MailBody = MailBody + 'Total Batches : ' + aaj.TotalJobItems + '<br/>';
        MailBody = MailBody + 'Total Batches Procesed : ' + aaj.JobItemsProcessed + '<br/>';
        MailBody = MailBody + 'Failed Batches : ' + aaj.NumberOfErrors + '<br/>';
        mail.setHtmlBody(MailBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }   
}