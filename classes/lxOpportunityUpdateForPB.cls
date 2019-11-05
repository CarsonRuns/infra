/**************************************
Author          : Debesh 
Release         : Mar Release version 1
Created         : Feb 07,2019
Functionality   : Generic class for Opportunity Process Builder

Modification History:
Itrack#        Date        		Author              		Change  
****************************************************************************
DE229809     Feb 07 ,2019  Debesh				           	Initial draft
			March 18, 2019 Kavya M                          to Call updateRecords method from Trigger instead of Process Builder
**********************************************/

public class lxOpportunityUpdateForPB {
    public static void updateRecords(List<Opportunity> op, Map<id,sobject> oldOppMap) {
        Set<String> updatedOpptyIdSet = new set<String>();         
        String flag;
        
        for (Opportunity opp : op) {
            //Here we use the Opp id, to get the older version of record.
            Opportunity oppOld = (Opportunity)oldOppMap.get(opp.ID);
            if(oppOld.Services_All_Multiyear__c!=opp.Services_All_Multiyear__c) {
                if(opp.Services_All_Multiyear__c == true){
                    updatedOpptyIdSet.add(opp.id);
                    flag='true';
                }
                else
                {
                    updatedOpptyIdSet.add(opp.id);
                    flag='false';
                }
            } 
        }
        system.debug('------updatedOpptyIdSet------'+updatedOpptyIdSet);
        updateOptyLineItems(updatedOpptyIdSet, flag);
    }
    
    public static void updateOptyLineItems(Set<String> ids, String flag) {
        
        List<OpportunityLineItem> optylineitems = [SELECT Id,OpportunityId,Opty_Services_All_Multiyear__c 
                                                   FROM OpportunityLineItem WHERE OpportunityId IN:ids];
        
        if(optylineitems.size()>0) {
            List<OpportunityLineItem> updateOptylineitems = new List<OpportunityLineItem>();
            
            for(OpportunityLineItem optylineitem : optylineitems) {                
                if(flag=='true') {
                    optylineitem.Opty_Services_All_Multiyear__c = 'True';  
                    updateOptylineitems.add(optylineitem);
                }
                else {
                    optylineitem.Opty_Services_All_Multiyear__c = 'False';
                    updateOptylineitems.add(optylineitem);
                }
            }  
            system.debug('------updateOptylineitems------'+updateOptylineitems);
            update updateOptylineitems;
        }        
    }
  
}