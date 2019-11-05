trigger updatePartnerContactMapping on Partner_Contact__c (after Update) {
    
    ID[] updatedContacts = new ID[]{};
    
    for(Partner_Contact__c c  : System.Trigger.new) {
        if(c.Name != System.Trigger.oldMap.get(c.Id).Name || c.Partner_Name__c != System.Trigger.oldMap.get(c.Id).Partner_Name__c){
            updatedContacts.add(c.Id);
        }
    }
    
    Partner_Contact_Oppty_Mapping__c[] mappingToUpdate = [Select Id From Partner_Contact_Oppty_Mapping__c Where Partner_Contact__c IN :updatedContacts];       
                  
    //if bigger than 100 dml limit send to future class
    if(mappingToUpdate.size() > 99)
        PartnerContactFutureClass.updateContactMapping(updatedContacts);
    
    else if(mappingToUpdate.size() > 0)
        update mappingToUpdate;
}