trigger PartnerContactMapping on Partner_Contact_Oppty_Mapping__c (before insert, before update) {

    Set<ID> pContactIds = new Set<ID>();

    for(Partner_Contact_Oppty_Mapping__c p  : System.Trigger.new) {
        pContactIds.add(p.Partner_Contact__c);
    }
    
    Map<Id, Partner_Contact__c> partnerC = new Map<Id, Partner_Contact__c>([Select Id, Name, Partner_Name__c FROM Partner_Contact__c WHERE Id IN :pContactIds]);

    for(Partner_Contact_Oppty_Mapping__c p  : System.Trigger.new) {
        if(partnerC.containsKey(p.Partner_Contact__c)){
            p.PartnerName__c = partnerC.get(p.Partner_Contact__c).Partner_Name__c;
            p.Name = partnerC.get(p.Partner_Contact__c).Name;
        } 
    }    

}