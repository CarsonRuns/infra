global class opptyCloudDemand { 
     
    public void cloudDemandPopulate(Set<Opportunity> opptyObjectId) { 
        Set<Id> cloudObjectId = new Set<Id>();
    
        for(Opportunity o: opptyObjectId) {
                 
            if(o.Cloud_Demand_Partner_Service_OfferLookup__c != null){
                cloudObjectId.add(o.Cloud_Demand_Partner_Service_OfferLookup__c);
            }
       }
        //Cloud Demand fields that need to be populated
        if(!cloudObjectId.isEmpty()){
            Map<Id,Cloud_Demand_Partner_Service_Offer__c> cdps = new Map<Id,Cloud_Demand_Partner_Service_Offer__c>([Select Id, Cloud_Demand_Partner__c, 
            Cloud_Demand_Model__c, Cloud_Demand_Offer__c, Cloud_Demand_Proxy__c, Cloud_Demand_Units__c from Cloud_Demand_Partner_Service_Offer__c where Id IN :cloudObjectId]);
            
            for(Opportunity oppty: opptyObjectId) {
                if (!cdps.isEmpty()){
                    oppty.Cloud_Demand_Partner__c = cdps.get(oppty.Cloud_Demand_Partner_Service_OfferLookup__c).Cloud_Demand_Partner__c;
                    oppty.Cloud_Demand_Model__c = cdps.get(oppty.Cloud_Demand_Partner_Service_OfferLookup__c).Cloud_Demand_Model__c;
                    oppty.Cloud_Demand_Offer__c = cdps.get(oppty.Cloud_Demand_Partner_Service_OfferLookup__c).Cloud_Demand_Offer__c;
                    oppty.Cloud_Demand_Proxy__c = String.valueOf(cdps.get(oppty.Cloud_Demand_Partner_Service_OfferLookup__c).Cloud_Demand_Proxy__c);
                    oppty.Cloud_Demand_Units__c = cdps.get(oppty.Cloud_Demand_Partner_Service_OfferLookup__c).Cloud_Demand_Units__c;
                }
            }
        } 
      }
      //Cloud Demand field removal
      public void cloudDemandDelete(Set<Opportunity> opptyObjectIdDelete) { 
          for(Opportunity o: opptyObjectIdDelete) {
              o.Cloud_Demand_Partner__c = null;
              o.Cloud_Demand_Model__c = null;
              o.Cloud_Demand_Offer__c = null;
              o.Cloud_Demand_Proxy__c = null;
              o.Cloud_Demand_Units__c = null;
              o.Cloud_Demand_Term_Months__c = null;
              o.Cloud_Number_of_Units__c = null;
          }
          
      } 
 }