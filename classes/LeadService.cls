public with sharing class LeadService{
    public static void preventClosedLeadUpdates(Lead oldLead, Lead udpatedLead, boolean canEditCLosedLead){
        if(oldLead.recordTypeId == ObjectRecordTypeIds__c.getInstance().Closed_Lead_RecordTypeId__c){
            if(!canEditCLosedLead){
                udpatedLead.addError(System.Label.this_lead_is_closed_for_editing);
            }
        }
    }
}