/***Modification History:
Itrack#        Date             Author                      Change  
****************************************************************************
US250307     March 20 ,2019  Kavya                         Setting a isPSSuser Variable

**********************************************/
trigger OpptyValidationRuleChk on Opportunity (before insert, before update) {
    
    boolean checkBox = false;
    Set<Opportunity> opptyObjectId = new Set<Opportunity>();
    Set<Opportunity> opptyObjectIdDelete = new Set<Opportunity>();
    
    if(Utilities.getValidationSkip())
        checkBox = true;
    //added by Kavya to set the flag to allow pss user to create opportunity
    if(Trigger.isInsert)
       Utilities.setisPSSUser(true);
       //ends here
    for(Opportunity o : System.Trigger.new) {
         o.skipValidations__c = checkBox;
         
         //Cloud Demand field removal
        if (Trigger.isUpdate && System.Trigger.oldMap.get(o.id).Cloud_Demand_Partner_Service_OfferLookup__c != null && o.Cloud_Demand_Partner_Service_OfferLookup__c == null) { 
            opptyObjectIdDelete.add(o);
        }
        
        //Cloud Demand fields that need to be populated
        if(o.Cloud_Demand_Partner_Service_OfferLookup__c != null  && ((Trigger.isUpdate && System.Trigger.oldMap.get(o.id).Cloud_Demand_Partner_Service_OfferLookup__c != o.Cloud_Demand_Partner_Service_OfferLookup__c) || Trigger.isInsert)){
            opptyObjectId.add(o);
        }
    }

    //Cloud Demand Processing
    opptyCloudDemand cd = new opptyCloudDemand();
    
    if(opptyObjectId.size() > 0)
        cd.cloudDemandPopulate(opptyObjectId);
        
    if(opptyObjectIdDelete.size() > 0)
        cd.cloudDemandDelete(opptyObjectIdDelete);

    OpptyCloudDemandProjectedValue cDProjVal = new OpptyCloudDemandProjectedValue();
    cDProjVal.updateCloudProjectedValue(trigger.new);
              
}