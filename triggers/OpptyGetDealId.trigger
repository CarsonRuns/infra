/**

* @release - MAY Q4FY14
* @author - majanard
* @date - 09-May-2014
* @description  - This trigger is updated to call the AccountTeamMember update class for Work Request - WR-00626.
*/ 

trigger OpptyGetDealId on Opportunity (after insert, after update) {

    if (!Utilities.getskipFuture() ){
        //WR-0480 :: commented below query whihc is not using 7/1/2016    
        ID[] opptys = new ID[]{};
        Opportunity[] opptyStatusUpdates = new Opportunity[]{};
        Map<id,Opportunity> mapOptysDelIdObj = new Map<id,Opportunity>();
        Opportunity[] optysDelId = new Opportunity[]{};


        for(Opportunity o : System.Trigger.New) {        
            //US7979: Updating if condition to check if opportunity has line items to allow deal id to be generated for opportunity
            //GDM change for deal Id generation for Global Opportunity recordtype 
            //Quote Integration: Enabling Deal Id generation even without Tech & Service in Stage 1
            if(o.dealID__c == null && o.Deal_Id_Status__c == null &&
               (o.RecordTypeId == Utilities.getOpptyParentRecordTypeId() || o.RecordTypeId == Utilities.getOpptyGlobalRecordTypeId()
                   || o.RecordTypeId == Utilities.getOpptyRenewalRecordTypeId()) && 
               o.Position__c != null){
                // Oppty_deal_id_processing_time__c and Processing time custom fields added on Opportunity object for WR-00851
                Opportunity o2 = new Opportunity(Id=o.Id, Timestamp_DealID_Status_SetTo_Processing__c = DateTime.now());
                if(o.StageName != '1 - Prospect' && OpportunityService.hasValidTechnology(o) && OpportunityService.hasValidService(o)){                    
                    opptyStatusUpdates.add(o2);
                    opptys.add(o.Id);
                    mapOptysDelIdObj.put(o.id,o);
                } else{
                    opptyStatusUpdates.add(o2);
                    opptys.add(o.Id);
                    mapOptysDelIdObj.put(o.id,o);
                }
               
            }
        }
            
        // 7/7/2015 Changed this line for batch size. Will flux when testing bulk upload (clv)
        if(opptys.size()>0) {
            Utilities.setValidationSkip(true);//skips validation rules
            Utilities.setSkip(true);//skips certain trigger functionality
            Utilities.setskipFuture(true);//skips more future calls            
            OpptyGetDealId.assignDealids(mapOptysDelIdObj);
            Update opptyStatusUpdates;            
        }
        
    }

    if(System.Trigger.isUpdate){
        ID[] opptysNewDealIds = new ID[]{};
        for(Opportunity o : System.Trigger.New) {
            if(o.dealID__c != null && System.Trigger.oldMap.get(o.Id).dealID__c == null){
                opptysNewDealIds.add(o.Id);
            }           
            // majanard - moved the Account trigger call position so it will trigger only during Security contact updates 5/21
            if(o.Security_SE__c != System.Trigger.oldMap.get(o.ID).Security_SE__c || o.Security_AM__c != System.Trigger.oldMap.get(o.ID).Security_AM__c){
                // This trigger is updated to call the AccountTeamMember update class for Work Request - WR-00626. 
                // Purpose: Adding the Securit contacts to Account and AccountTeamMember from Opportunity.
                Oppty_SecurityRoles_AccountTeamUpdate actUpdate = new Oppty_SecurityRoles_AccountTeamUpdate();
                actUpdate.UpdateAccount(Trigger.new);
            } 
         }
        if(opptysNewDealIds.size()>0){
            Oppty_Deal_ID_Failure_Log__c[] failureLogInserts = new Oppty_Deal_ID_Failure_Log__c[]{};
            Opptys_Requiring_DealIDs__c[] ordToDelete = new Opptys_Requiring_DealIDs__c[]{};             
            for(Opptys_Requiring_DealIDs__c ord: [Select Id, Opportunity__c, attempts__c, error__c from Opptys_Requiring_DealIDs__c where Opportunity__c IN :opptysNewDealIds]){
                Oppty_Deal_ID_Failure_Log__c logTemp = new Oppty_Deal_ID_Failure_Log__c(Opportunity__c=ord.Opportunity__c, attempts__c=ord.attempts__c, error__c=ord.error__c);
                failureLogInserts.add(logTemp);
                ordToDelete.add(ord);
            }                
            if(failureLogInserts.size() > 0)
                Insert failureLogInserts;
                     
            if(ordToDelete.size() > 0)
                Delete ordToDelete;
        }
    }
}