trigger PartnerUpdate on Opportunity (after insert, after update) {
 
    if(OpptyPartnerUpdate.getOpptyPartnerUpdated() == false) {
        OpptyPartnerUpdate.setOpptyPartnerUpdated(true);
 
    Partner[] partnerToUpdate = new Partner[]{}; 
    Map<String, ID> opptyPartnerAcct = new Map<String, ID>();

    
    for(Opportunity o : System.Trigger.new) {
        
        if(Trigger.isInsert){
            Partner newPartner;
            if(o.Primary_Partner__c != null)
                partnerToUpdate.add(new Partner(AccountToId=o.Primary_Partner__c, OpportunityId=o.Id, Role=o.Primary_Partner_Role__c, IsPrimary=true));
            if(o.Partner_2__c != null)
                partnerToUpdate.add(new Partner(AccountToId=o.Partner_2__c, OpportunityId=o.Id, Role=o.Role_2__c));
            if(o.Partner_3__c != null)
                partnerToUpdate.add(new Partner(AccountToId=o.Partner_3__c, OpportunityId=o.Id, Role=o.Role_3__c));
            if(o.Partner_4__c != null)
                partnerToUpdate.add(new Partner(AccountToId=o.Partner_4__c, OpportunityId=o.Id, Role=o.Role_4__c));
            if(o.Partner_5__c != null)
                partnerToUpdate.add(new Partner(AccountToId=o.Partner_5__c, OpportunityId=o.Id, Role=o.Role_5__c));         
        }
        else{
            if(o.Primary_Partner__c != System.Trigger.oldMap.get(o.Id).Primary_Partner__c || o.Partner_2__c != System.Trigger.oldMap.get(o.Id).Partner_2__c || o.Partner_3__c != System.Trigger.oldMap.get(o.Id).Partner_3__c || o.Partner_4__c != System.Trigger.oldMap.get(o.Id).Partner_4__c || o.Partner_5__c != System.Trigger.oldMap.get(o.Id).Partner_5__c)
            {
                if(o.Primary_Partner__c != System.Trigger.oldMap.get(o.Id).Primary_Partner__c){
                    if(o.Primary_Partner__c != null){
                        partnerToUpdate.add(new Partner(AccountToId=o.Primary_Partner__c, OpportunityId=o.Id, Role=o.Primary_Partner_Role__c, IsPrimary=true));
                        if(System.Trigger.oldMap.get(o.Id).Primary_Partner__c != null){
                            opptyPartnerAcct.put(o.Id + '-' + System.Trigger.oldMap.get(o.Id).Primary_Partner__c + '-' + System.Trigger.oldMap.get(o.Id).Primary_Partner_Role__c, o.Id);    
                        }
                    }
                    else{
                        opptyPartnerAcct.put(o.Id + '-' + System.Trigger.oldMap.get(o.Id).Primary_Partner__c + '-' + System.Trigger.oldMap.get(o.Id).Primary_Partner_Role__c, o.Id);
                    }   
                }
                if(o.Partner_2__c != System.Trigger.oldMap.get(o.Id).Partner_2__c){
                    if(o.Partner_2__c != null){
                        Partner p = new Partner(AccountToId=o.Partner_2__c, OpportunityId=o.Id, Role=o.Role_2__c);
                        partnerToUpdate.add(p);
                        if(System.Trigger.oldMap.get(o.Id).Partner_2__c != null){
                            opptyPartnerAcct.put(o.Id + '-' + System.Trigger.oldMap.get(o.Id).Partner_2__c + '-' + System.Trigger.oldMap.get(o.Id).Role_2__c, o.Id);
                        }
                    }
                    else{
                        opptyPartnerAcct.put(o.Id + '-' + System.Trigger.oldMap.get(o.Id).Partner_2__c + '-' + System.Trigger.oldMap.get(o.Id).Role_2__c, o.Id);
                    }
                }
                if(o.Partner_3__c != System.Trigger.oldMap.get(o.Id).Partner_3__c){
                    if(o.Partner_3__c != null){
                        Partner p = new Partner(AccountToId=o.Partner_3__c, OpportunityId=o.Id, Role=o.Role_3__c);
                        partnerToUpdate.add(p);
                        if(System.Trigger.oldMap.get(o.Id).Partner_3__c != null){
                            opptyPartnerAcct.put(o.Id + '-' + System.Trigger.oldMap.get(o.Id).Partner_3__c + '-' + System.Trigger.oldMap.get(o.Id).Role_3__c, o.Id);
                        }
                    }
                    else{
                        opptyPartnerAcct.put(o.Id + '-' + System.Trigger.oldMap.get(o.Id).Partner_3__c + '-' + System.Trigger.oldMap.get(o.Id).Role_3__c, o.Id);
                    }
                }
                if(o.Partner_4__c != System.Trigger.oldMap.get(o.Id).Partner_4__c){
                    if(o.Partner_4__c != null){ 
                        Partner p = new Partner(AccountToId=o.Partner_4__c, OpportunityId=o.Id, Role=o.Role_4__c);
                        partnerToUpdate.add(p);
                        if(System.Trigger.oldMap.get(o.Id).Partner_4__c != null){
                            opptyPartnerAcct.put(o.Id + '-' + System.Trigger.oldMap.get(o.Id).Partner_4__c + '-' + System.Trigger.oldMap.get(o.Id).Role_4__c, o.Id);
                        }                
                    }
                    else{
                        opptyPartnerAcct.put(o.Id + '-' + System.Trigger.oldMap.get(o.Id).Partner_4__c + '-' + System.Trigger.oldMap.get(o.Id).Role_4__c, o.Id);
                    }
                }
                if(o.Partner_5__c != System.Trigger.oldMap.get(o.Id).Partner_5__c){
                    if(o.Partner_5__c != null){
                        Partner p = new Partner(AccountToId=o.Partner_5__c, OpportunityId=o.Id, Role=o.Role_5__c);
                        partnerToUpdate.add(p);
                        if(System.Trigger.oldMap.get(o.Id).Partner_5__c != null){
                            opptyPartnerAcct.put(o.Id + '-' + System.Trigger.oldMap.get(o.Id).Partner_5__c + '-' + System.Trigger.oldMap.get(o.Id).Role_5__c, o.Id);
                        }
                    }
                    else{
                        opptyPartnerAcct.put(o.Id + '-' + System.Trigger.oldMap.get(o.Id).Partner_5__c + '-' + System.Trigger.oldMap.get(o.Id).Role_5__c, o.Id);
                    }
                }
            }
            
            if(o.Primary_Partner_Role__c != System.Trigger.oldMap.get(o.Id).Primary_Partner_Role__c || o.Role_2__c != System.Trigger.oldMap.get(o.Id).Role_2__c || o.Role_3__c != System.Trigger.oldMap.get(o.Id).Role_3__c || o.Role_4__c != System.Trigger.oldMap.get(o.Id).Role_4__c || o.Role_5__c != System.Trigger.oldMap.get(o.Id).Role_5__c) {
                
                if(o.Primary_Partner_Role__c != System.Trigger.oldMap.get(o.Id).Primary_Partner_Role__c && o.Primary_Partner__c == System.Trigger.oldMap.get(o.Id).Primary_Partner__c && o.Primary_Partner__c != null){
                    partnerToUpdate.add(new Partner(AccountToId=o.Primary_Partner__c, OpportunityId=o.Id, Role=o.Primary_Partner_Role__c, IsPrimary=true));
                    opptyPartnerAcct.put(o.Id + '-' + System.Trigger.oldMap.get(o.Id).Primary_Partner__c + '-' + System.Trigger.oldMap.get(o.Id).Primary_Partner_Role__c, o.Id);    
                }
                if(o.Role_2__c != System.Trigger.oldMap.get(o.Id).Role_2__c && o.Partner_2__c == System.Trigger.oldMap.get(o.Id).Partner_2__c && o.Partner_2__c != null){
                    partnerToUpdate.add(new Partner(AccountToId=o.Partner_2__c, OpportunityId=o.Id, Role=o.Role_2__c));
                    opptyPartnerAcct.put(o.Id + '-' + System.Trigger.oldMap.get(o.Id).Partner_2__c + '-' + System.Trigger.oldMap.get(o.Id).Role_2__c, o.Id);    
                }
                if(o.Role_3__c != System.Trigger.oldMap.get(o.Id).Role_3__c && o.Partner_3__c == System.Trigger.oldMap.get(o.Id).Partner_3__c && o.Partner_3__c != null){
                    partnerToUpdate.add(new Partner(AccountToId=o.Partner_3__c, OpportunityId=o.Id, Role=o.Role_3__c));
                    opptyPartnerAcct.put(o.Id + '-' + System.Trigger.oldMap.get(o.Id).Partner_3__c + '-' + System.Trigger.oldMap.get(o.Id).Role_3__c, o.Id);    
                }
                if(o.Role_4__c != System.Trigger.oldMap.get(o.Id).Role_4__c && o.Partner_4__c == System.Trigger.oldMap.get(o.Id).Partner_4__c && o.Partner_4__c != null){
                    partnerToUpdate.add(new Partner(AccountToId=o.Partner_4__c, OpportunityId=o.Id, Role=o.Role_4__c));
                    opptyPartnerAcct.put(o.Id + '-' + System.Trigger.oldMap.get(o.Id).Partner_4__c + '-' + System.Trigger.oldMap.get(o.Id).Role_4__c, o.Id);    
                }                                
                if(o.Role_5__c != System.Trigger.oldMap.get(o.Id).Role_5__c && o.Partner_5__c == System.Trigger.oldMap.get(o.Id).Partner_5__c && o.Partner_2__c != null){
                    partnerToUpdate.add(new Partner(AccountToId=o.Partner_5__c, OpportunityId=o.Id, Role=o.Role_5__c));
                    opptyPartnerAcct.put(o.Id + '-' + System.Trigger.oldMap.get(o.Id).Partner_5__c + '-' + System.Trigger.oldMap.get(o.Id).Role_5__c, o.Id);    
                }                
            }
            
        } // Update
    
    }// for loop
    
    
    if(opptyPartnerAcct.size() > 0) {
        Partner[] partnersToRemove = new Partner[]{};

        for(Partner p: [Select Id, AccountToId, OpportunityId, Role From Partner Where OpportunityId IN :opptyPartnerAcct.values()]) {
            if(opptyPartnerAcct.containsKey(p.OpportunityId + '-' + p.AccountToId + '-' + p.Role)){
                Partner p2 = new Partner(Id=p.Id);
                partnersToRemove.add(p2);
            }
        }

        if(partnersToRemove.size() > 0){
            delete partnersToRemove;
        } 
    }
    if(partnerToUpdate.size() > 0) {
        insert partnerToUpdate;
    }
    
    } // opptyPartnerUpdated
   
}