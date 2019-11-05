trigger P360_Multi_Quote_After_Trg on Multi_Object_Quote__c (after insert,after update) {
    Set<Id> setTPs = new Set<Id>();
    
    for(Multi_Object_Quote__c objMOQ: Trigger.New){
        if(objMOQ.Target_Prospect__c != null || objMOQ.Target_Prospect__c == ''){
            setTPs.add(objMOQ.Target_Prospect__c);
        }
    }

    P360_Multi_Quote_After_Trg_Cls.dealCreationDateUpdateOnTP(setTPs);

}