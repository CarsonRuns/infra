trigger OpportunityExpectedAmtChanged on Opportunity bulk (after insert, after update) {


    /*  
       This trigger identifies new or updated Opportunity records. It checks to see if the 
        Expected_Product__c or Expected_Service__c fields have been changed. If yes, it then
        retrieves related OpportunityLineItem and applies the Mix % to the TotalPrice and 
        Opportunity Line Item Value fields. 
       
    */
    
/*  MixPctPackage.processLineItems() = false;*///Set the global variable to suppress the OpportunityLineItem trigger from executing.
    MixPct.setProcessLineItems(false);
    
    Opportunity[] opportunityNewArrayToUpdate = Trigger.new;
    Opportunity[] opportunityOldArrayToUpdate = Trigger.old;
    OpportunityLineItem[] updateLineItems = new OpportunityLineItem[]{}; 
    Opportunity[] opptyToProcessArray = new Opportunity[]{};
    Integer x;
     
    System.debug('Trigger OpportunityExpectedAmtChanged launched....');
    System.debug('Going to process [' + Trigger.new.size() + '] Opportunities which have been updated....');

 
    //Handle the updates differently than the inserts
    //For updates, we need to check if the Expected Prodcut or Expected Service values changed
    if(Trigger.isUpdate){
            
        for(x=0;x<opportunityNewArrayToUpdate.size();x++){
                
            if (opportunityOldArrayToUpdate[x].Expected_Product__c != opportunityNewArrayToUpdate[x].Expected_Product__c || opportunityOldArrayToUpdate[x].Expected_Service__c != opportunityNewArrayToUpdate[x].Expected_Service__c) {
                //The expected service or expected product value changed. Need to process this Opportunity and related LineItems.
                opptyToProcessArray.add(opportunityNewArrayToUpdate[x]);
            }
        }
        
    } //Trigger.isUpdate

    //When the trigger is an insert, all records need to be processed. 
    if(Trigger.isInsert){  
        opptyToProcessArray = Trigger.new;
    }   
    
    
    if(opptyToProcessArray!=null && opptyToProcessArray.size() > 0){
            
            //Get all related OpportunityLineItems. Differentiate between Technology and Service lineitems by the ProductCode
            OpportunityLineItem[] technologyRelatedOpptyLineItems = [select o.Id, o.Opportunity_Line_Value__c, o.OpportunityId, o.Mix__c, o.UnitPrice, Expected_TCV_000s__c from OpportunityLineItem o where o.OpportunityId IN :opptyToProcessArray and o.PricebookEntry.ProductCode= 'Technology'];
            OpportunityLineItem[] serviceRelatedOpptyLineItems = [select o.Id, o.Opportunity_Line_Value__c, o.OpportunityId, o.Mix__c, o.UnitPrice, Expected_TCV_000s__c from OpportunityLineItem o where o.OpportunityId IN :opptyToProcessArray and o.PricebookEntry.ProductCode= 'Service'];        

        
            //Process all technology related line items
            for(OpportunityLineItem oliTechnology : technologyRelatedOpptyLineItems){
                
               Opportunity opptyObj = Trigger.newMap.get(oliTechnology.OpportunityId);
               
               if(opptyObj.RecordTypeId==Utilities.getOpptyRenewalRecordTypeId()){
                   system.debug('Renewal Opportunity..');               
                   if(opptyObj.Expected_Product__c == null || opptyObj.Expected_Product__c == 0 || oliTechnology.Expected_TCV_000s__c==null){
                  // if(opptyObj.Expected_Product__c == null || opptyObj.Expected_Product__c == 0){                 
                               oliTechnology.TotalPrice = 0;
                               oliTechnology.Opportunity_Line_Value__c = 0;
                               oliTechnology.Mix__c = 0;
                               oliTechnology.Expected_TCV_000s__c = 0;
                   }
                   else{
                               Double expprdopp = opptyObj.Expected_Product__c;Double exptcvline = oliTechnology.Expected_TCV_000s__c;
                               Double mixline = exptcvline/expprdopp*100; Decimal mixline2 = ((decimal)mixline).setScale(2);
                               
                               oliTechnology.Mix__c = mixline2;
                   }
               }
               else{
                   if(opptyObj.Expected_Product__c == null || opptyObj.Expected_Product__c == 0 || oliTechnology.Mix__c == null || oliTechnology.Mix__c == 0){
                               oliTechnology.TotalPrice = 0;
                               oliTechnology.Opportunity_Line_Value__c = 0;
                   }
                   else {
                               oliTechnology.TotalPrice = (oliTechnology.Mix__c/100) * opptyObj.Expected_Product__c;
                               oliTechnology.Opportunity_Line_Value__c = (oliTechnology.Mix__c/100) * opptyObj.Expected_Product__c;
                   }
               } 
               updateLineItems.add(oliTechnology);
               if(updateLineItems.size() == 100){
                   update updateLineItems;
                   updateLineItems.clear();
               }
                    
            }
            
            //Process all service related line items
            for(OpportunityLineItem oliService : serviceRelatedOpptyLineItems){
                
               Opportunity opptyObj = Trigger.newMap.get(oliService.OpportunityId);
            
               if(opptyObj.RecordTypeId==Utilities.getOpptyRenewalRecordTypeId()){
                       system.debug('Renewal Opportunity..');               
                       if(opptyObj.Expected_Service__c == null || opptyObj.Expected_Service__c == 0 || oliService.Expected_TCV_000s__c == null){
                    //   if(opptyObj.Expected_Service__c == null || opptyObj.Expected_Service__c == 0){
                               oliService.TotalPrice = 0;
                               oliService.Opportunity_Line_Value__c = 0;
                               oliService.Mix__c = 0;
                               oliService.Expected_TCV_000s__c = 0;
                       }
                       else{
                               Double expservopp = opptyObj.Expected_Service__c;Double exptcvline = oliService.Expected_TCV_000s__c;
                               Double mixline = exptcvline/expservopp*100; Decimal mixline2 = ((decimal)mixline).setScale(2);
                               
                               oliService.Mix__c = mixline2;
                       }
                }
                else{
                       if(opptyObj.Expected_Service__c == null || opptyObj.Expected_Service__c == 0 || oliService.Mix__c == null || oliService.Mix__c == 0){
                                    oliService.TotalPrice = 0;
                                    oliService.Opportunity_Line_Value__c = 0;
                       }
                       else{
                                    oliService.TotalPrice = (oliService.Mix__c/100) * opptyObj.Expected_Service__c;
                                    oliService.Opportunity_Line_Value__c = (oliService.Mix__c/100) * opptyObj.Expected_Service__c;
                       }                
                }    
                updateLineItems.add(oliService);
                if(updateLineItems.size() == 100){
                    update updateLineItems;
                    updateLineItems.clear();
                }
            }
            
    }

    //Check to see if any OpportunityLineItems need to be updated. Send in bulk.
    if(updateLineItems != null && updateLineItems.size() > 0){
            System.debug('About to update [' + updateLineItems.size() + '] OpportunityLineItems.....');
            //Update OpportunityLineItems
            update updateLineItems;
            System.debug('Completed the update of [' + updateLineItems.size() + '] OpportunityLineItems...');
        }
        else{
            System.debug('No Opportunity Line Items need to be updated');
        }
    System.debug('Trigger OpportunityExpectedAmtChanged exiting....');
    MixPct.setProcessLineItems(true);
    
}