/***************************************************************************************************
Name    : NGCC_VDC_DRTLeadsUpdate_Batch
Author  : Zakeahmed
Purpose : This class is responsible for processing VDC leads in a Batch ( Updates all VDC recordType leads)
Created Date: 05/20/2019
Go Live: May-31st-2019
****************************************************************************************************/
global class NGCC_VDC_DRTLeadsUpdate_Batch implements Database.Batchable<sObject> {
    
    Id recordTypeIdProspect = Schema.getGlobalDescribe().get('Lead').getDescribe().getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
    Id recordTypeIdClosed = Schema.getGlobalDescribe().get('Lead').getDescribe().getRecordTypeInfosByName().get('Closed').getRecordTypeId();
    //Id recordTypeIdVDC = Schema.getGlobalDescribe().get('Lead').getDescribe().getRecordTypeInfosByName().get('VDC').getRecordTypeId();
    String recordTypeNameVDC = 'VDC';
    
    global Database.QueryLocator start(Database.BatchableContext BC) {    
        String query = 'SELECT Id, Status, VDC_Decision__c, RecordType.Name FROM Lead WHERE RecordType.Name =:recordTypeNameVDC AND VDC_Decision__c!=NULL';
        return Database.getQueryLocator(query);
    }
     
    global void execute(Database.BatchableContext BC, List<Lead> leadsList) {
        for(Lead l : leadsList)
        {
            if((l.VDC_Decision__c=='DRT' || l.VDC_Decision__c=='Skipped Scoring') && l.Status=='New Prospect'){
                l.RecordTypeId = recordTypeIdProspect;
                l.ETL_Load_Flag__c = true;
                
            }
            else if(l.VDC_Decision__c=='Nurture' && l.Status=='New Prospect'){
                l.RecordTypeId = recordTypeIdClosed;
                l.VDC_Decision__c = 'Nurture';
                l.Status = 'Closed For Nurture';
                
            }
            else if(l.VDC_Decision__c=='Suppress' && l.Status=='New Prospect'){
                l.RecordTypeId = recordTypeIdClosed;
                l.VDC_Decision__c = 'Suppress';
                l.Status = 'Closed For Suppress';
                
            }
        }
            // Update the Lead Records
             Database.SaveResult[] updateLeads = new Database.SaveResult[]{};
            if(leadsList.size() > 0){
                updateLeads = Database.update(leadsList, false);
                
            }      
            for (Database.SaveResult leadResult : updateLeads) {
                if (leadResult.isSuccess()) {
                    //system.debug('IsSuccess'+leadResult.isSuccess()+'Successfully Updated Lead:' + leadResult.getId());
                }
                else {               
                    for(Database.Error err : leadResult.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Lead fields that affected this error: ' + err.getFields());
                    }
                }
            }
    }   
     
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations
  }
 
}