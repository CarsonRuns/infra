trigger OpportunityLineItemMixPctChange on OpportunityLineItem bulk (before insert, before update) 
{     

    /*      
        This trigger identifies any new or updated OpportunityLineItem records. It then has to query the related
        Opportunity to get the Expected_Product__c and Expected_Service__c fields. Next, it queries the PricebookEntry 
        to get the ProductCode which identifies if the line item is a 'Technology' or 'Service'. Finally, the Mix % is 
        applied to the TotalPrice and Opportunity Line Item Value field.     
    */

     System.debug('Trigger OpportunityLineItemMixPctChange launched....');
    Utilities.setValidationSkip(true);
  //Check the packages global variable to see if we need to still process the line items
/*     if(MixPctPackage.processLineItems == true) */
     if(MixPct.getProcessLineItems() == true)
        System.debug('Global variable is set to TRUE. Continue to process the OpportunityLineItems');
     else
        System.debug('Global variable is set to FALSE. Do not continue to process the OpportunityLineItems. Stop processing.');   
        
     //Check to see if this trigger was simply caused by the OpportunityExpectedAmtChanged trigger.
     //No need to reprocess line items - do nothing. 
/*  if(MixPctPackage.processLineItems == true){ */
  if(MixPct.getProcessLineItems() == true){ 


     //OpportunityLineItem[] newArray = Trigger.new; 
    OpportunityLineItem[] newArray = new OpportunityLineItem[]{};
    
    PricebookEntry[] pbeIds = new PricebookEntry[]{};
    Opportunity[] opptyIds = new Opportunity[]{}; 
  
    Integer x = 0;


    //Code Added 7.10. by Andrew Albert. 
    //Handle the updates differently than the inserts    
    //Performance enhancement. 
    //Only want to process Updates if the Mix__c field has changed. 
    //For creates, need to apply logic to all records. 
    if(Trigger.isUpdate){
          // Code Added 05-20-2015 by Sudi
          // This code set the salesforce1 flag when line items updated from mobile for reporting purpose.
          // if SalesForce1_Created_Updated__c == '1' means this line item is updated in Salesforce1 Mobile app
          for(OpportunityLineItem newOppline : Trigger.new){
              OpportunityLineItem oldOppLine = Trigger.oldMap.get(newOppline.Id);
              if(newOppline.SalesForce1_Created_Updated__c == '1'){                 
                    // This code is for Updated opportunity line items for services to set the flag
                    if((newOppline.Service_Level__c != oldOppline.Service_Level__c) || (newOppline.Mix__c != oldOppline.Mix__c) 
                      || newOppline.Service_Category__c != oldOppline.Service_Category__c){                     
                        newOppline.SalesForce1_Flag__c = true;
                    }   
                    // This code is for Updated opportunity line items for technology to set the flag
                    if((newOppline.Product_Family_US__c != oldOppline.Product_Family_US__c) || (newOppline.Mix__c != oldOppline.Mix__c)){                       
                        newOppline.SalesForce1_Flag__c = true;
                    }
              }
        }
        for(x=0;x<Trigger.new.size();x++){
          if(Trigger.new[x].Mix__c != Trigger.old[x].Mix__c){
              newArray.add(Trigger.new[x]);
              System.debug('Trigger.new['+x+'] changed the Mix %. Perform Mix % calculation');  
          }
          else{
             System.debug('Trigger.new['+x+'] does not need the Mix % logic recalculated');  
          }      
        } //end for loop
    } // end if trigger.isUpdate 
    
    else{
      System.debug('This is a create call. All records must process the Mix % logic');
        newArray = Trigger.new; 
        // Code Added 05-20-2015 by Sudi
        // This code set the salesforce1 flag when line items Inserted from mobile for reporting purpose.
        // if SalesForce1_Created_Updated__c == '1' means this line item is updated in Salesforce1 Mobile app
        for(OpportunityLineItem oppline : Trigger.new){
            if(oppLine.SalesForce1_Created_Updated__c == '1'){
                oppLine.SalesForce1_Flag__c = true;
            }
        }
    }
        
    
    for(x=0;x<newArray.size();x++){
      
      //Build an array of PricebookEntry records. Default the Id to LineItem.PricebookEntryIds
      PricebookEntry tempPBE = new PricebookEntry(id=newArray[x].pricebookEntryId);
        pbeIds.add(tempPBE); //Get a list of PricebookEntrys that were in the OpportunityLineItem trigger array. Need to differentiate between Service and Technology ProductCodes later on
       
         //Build an array of Opportunity records. Default the Id to the LineItem.OpportunityId 
        Opportunity tempOPPTY = new Opportunity(id=newArray[x].OpportunityId);
        opptyIds.add(tempOPPTY); //Get a list of Opportunities that had LineItems in the trigger array.
    }
    

      System.debug('Going to process [' + newArray.size() + '] OpportunityLineItems which have been inserted or updated....');

    //Now go query for the  Opportunity records related to these LineItems
    Map<Id,Opportunity> relatedOpptys = MixPct.getRelatedOpptys(opptyIds);
    
    //Now go query for the PricebookEntry records related to these LineItems
    Map<Id,PricebookEntry> relatedPricebookEntries = MixPct.getRelatedPriceBookEntries(pbeIds);
    
    
    //For each OpportunityLineItem
    for(x=0;x<newArray.size();x++){
      if(relatedOpptys.containsKey(newArray[x].OpportunityId) && relatedOpptys.get(newArray[x].OpportunityId).recordtypeid==Utilities.getOpptyRenewalRecordTypeId())
        continue;    //katandon 2/17/2019
      
      if(newArray[x].priceBookEntryId == null){
        System.debug('OpportunityLineItemMixPctChange Trigger caught exception: PricebookEntryId is null. This is a required field. ');
        newArray[x].addError('OpportunityLineItemMixPctChange Trigger caught exception: PricebookEntryId is null. This is a required field. ');
        continue;
      }
      else if(newArray[x].OpportunityId==null){            
        System.debug('OpportunityLineItemMixPctChange Trigger caught exception: OpportunityId is null. This is a required field. ');
        newArray[x].addError('OpportunityLineItemMixPctChange Trigger caught exception: OpportunityId is null. This is a required field. ');
        continue;
      }
      else{

      //Get the ProductCode value from the PricebookEntry to determine if its a Service or Technology      
//      String productCode = MixPct.getProductCode(newArray[x].priceBookEntryId,relatedPricebookEntries);  
      String productCode = MixPct.getProductCode(newArray[x].priceBookEntryId,
                                relatedPricebookEntries, 
                                newArray[x].OpportunityId, 
                                newArray[x].Id,
                                newArray[x].Mix__c);                              
       
      //Get the appropriate Expected Amt value from the Opportunity header information
      //If productCode = 'Service', then return the Expected_Service__c
      //If productcode = 'Technology' then return the Expected_Product__c'
      Double expectedAmt = MixPct.getExpectedAmt(productCode, newArray[x].opportunityId,relatedOpptys);
      
      //Handle the case where expectedAmt is null or 0
      if(expectedAmt == null || expectedAmt == 0)
        newArray[x].TotalPrice=0;
      else{
        //Handle the case where Mix__c is null or 0  
        if(newArray[x].Mix__c == null || newArray[x].Mix__c == 0)   {          
           newArray[x].TotalPrice = 0;
           newArray[x].Opportunity_Line_Value__c = 0;
        }
        else {
           //Apply the Mix % calculation. 
           newArray[x].TotalPrice = expectedAmt * (newArray[x].Mix__c/100);      
           newArray[x].Opportunity_Line_Value__c = expectedAmt * (newArray[x].Mix__c/100);      
        }
       
      }
      
     }
      
    
    }//end for loop
  
  
      
  }else{
       
       System.debug('Trigger OpportunityLineItemMixPctChange suppressed since this was re-triggered from the Opportunity trigger....');    
  }

  System.debug('Trigger OpportunityLineItemMixPctChange done processing....');    

}