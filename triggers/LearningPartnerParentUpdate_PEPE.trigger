/* This trigger has been deveoped by PEPE Dev team for May 2014 Release

It does following job:

A.  When an Admin accpets the Quote on LP, It updates the Siblings to "Quote Rejected" and updates Parent TR fields.
B.  When an Admin revised the Quote on LP, It just updated the Parent TR fields. */

trigger LearningPartnerParentUpdate_PEPE on PEPE_Learning_Partner__c (after update) {
 
// This will stop recurring behaviour of Trigger
 if(ContextUtility_PEPE.isFirstRun()) {
      

    //Variables declaration and initialization 
    Set<Id> trId = new Set<Id>();
    Set<Id> trId2 = new Set<Id>(); 
    Map<Id, Set<PEPE_Learning_Partner__c>> trLpMap = new Map<Id, Set<PEPE_Learning_Partner__c>>();
    List<PEPE_Learning_Partner__c> lpSiblingUpdate = new List<PEPE_Learning_Partner__c>();
    List<PEPE_Training_Request__c> lpParentUpdate = new List<PEPE_Training_Request__c>();
    
    final String QUOTE_ACCEPTED = 'Quote Accepted';
    final String REVISED_DETAILS_REQUESTED = 'Revised Details Requested';
    final String QUOTE_REJECTED = 'Quote Rejected';

    ContextUtility_PEPE lpProcessing = new ContextUtility_PEPE (); 
      
    //This for loop helps to prepare the Sets of records which will be used in query
    for(PEPE_Learning_Partner__c l : System.Trigger.new) {
        
            if(l.Status__c != System.Trigger.oldMap.get(l.Id).Status__c && l.Status__c == QUOTE_ACCEPTED) { 
                
               if(l.Training_Request_Id__c != null) {
                    trId.add(l.Training_Request_Id__c) ;
               }     
                   
            }
            
            if(l.Status__c != System.Trigger.oldMap.get(l.Id).Status__c && l.Status__c == QUOTE_ACCEPTED || l.Status__c == REVISED_DETAILS_REQUESTED) {
               
                if(l.Training_Request_Id__c != null) {
                    trId2.add(l.Training_Request_Id__c) ;
                }    
                   
            }
        }  
      
      
    // This contains all the parent TRs which can be updated based on LP status change  
    Map<Id, PEPE_Training_Request__c> trMap = new Map<Id, PEPE_Training_Request__c>([SELECT Id, Training_Offering_Id__r.Platform__c, Local_Contact_Email__c, Learning_Partner_Cost__c, Status__c, Name FROM PEPE_Training_Request__c where Id in: trId2]);
    
    // This provides all the LPs
    List<PEPE_Learning_Partner__c> lpList = [SELECT Id,  Learning_Partner_Cost__c, Training_Request_Id__c, Status__c, Name FROM PEPE_Learning_Partner__c where Training_Request_Id__c  in: trId];  
    
    //This for loop prepares the Siblings for a parent TR        
    for(PEPE_Learning_Partner__c lp : lpList) {
        
        if(trLpMap.containsKey(lp.Training_Request_Id__c)){
            trLpMap.get(lp.Training_Request_Id__c).add(lp);
        }
        else {
            trLpMap.put(lp.Training_Request_Id__c, new set <PEPE_Learning_Partner__c> { lp });
        }
    }
    
    //This is Main for loop where TRs and LPs get updated
    for(PEPE_Learning_Partner__c l1 : System.Trigger.new) {
        //logic A, When an Admin accpets the Quote on LP, It updates the Siblings to "Quote Rejected" and updates Parent TR fields.
        if(l1.Status__c != System.Trigger.oldMap.get(l1.Id).Status__c && l1.Status__c == QUOTE_ACCEPTED) {
            
            Set<PEPE_Learning_Partner__c> lpSiblings = trLpMap.get(l1.Training_Request_Id__c);
            
                for(PEPE_Learning_Partner__c l2 :  lpSiblings) {
                    if(l1.id != l2.id) {
                        l2.Status__c = QUOTE_REJECTED;
                        lpSiblingUpdate.add(l2);
                                            
                    }
                    // Using the Quote Accepted flag for applying subsequent statuses - added by Meghna 30-JUL-2015
                  if(l1.id == l2.id) {
                        l2.QUOTE_ACCEPTED_FLAG__c = 'Y';
                        lpSiblingUpdate.add(l2);
                                            
                    }
                }
            
            PEPE_Training_Request__c trRec = trMap.get(l1.Training_Request_Id__c);
            
            system.debug('trRec from trigger@@@@ '+trRec);
            
            //Updating the parent TR with the Quote details provided in child Record
            lpProcessing.updateQuoteFields(trRec, l1);
            
            //Adding Parent TR record into lpParentUpdate TR list for update instruction
            lpParentUpdate.add(trRec);
            
        } else   
        
        // logic B, When an Admin revised the Quote on LP, It just updated the Parent TR fields. 
        if(l1.Status__c != System.Trigger.oldMap.get(l1.Id).Status__c && l1.Status__c == REVISED_DETAILS_REQUESTED) {
            PEPE_Training_Request__c trRec = trMap.get(l1.Training_Request_Id__c);
            
            //Updating the parent TR with Null values for the Quote detail fields 
            lpProcessing.emptyQuoteFields(trRec);
             
            //Adding Parent TR record into lpParentUpdate TR list for update instruction
            lpParentUpdate.add(trRec);
            
        }
    }
    
    // Update call for LPs
    if(!lpSiblingUpdate.IsEmpty()) {
        try{
            ContextUtility_PEPE.setFirstRunFalse();
            update lpSiblingUpdate;
        }
        Catch(Exception e) {
       }
    }
    
    
    //Update call for LPs
    if(!lpParentUpdate.IsEmpty()) {
        try{
            update lpParentUpdate;
        }
        Catch(Exception e) {
        }
    }  
         
}
  

}