trigger OwnerAssignmentbyAT on Opportunity (before insert) {
    for (Opportunity o : Trigger.new){       
        if(o.Opportunity_Owner_AM__c != null && (UserInfo.getProfileId() == '00e30000000rrZwAAI' || Utilities.getIsTestMethod())) {
            //System.debug(Logginglevel.INFO, 'OwnerAssignment ' + o.Owner_Assignment_byAT__c);
            o.OwnerId = o.Opportunity_Owner_AM__c;
        } 
    }
}