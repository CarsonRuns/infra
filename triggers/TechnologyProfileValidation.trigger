trigger TechnologyProfileValidation on Technology_Profile__c (before insert) {
    if(trigger.isInsert && trigger.isBefore){
        List<Id> accIdList = new List<Id>(); 
        Map<Id,Technology_Profile__c> techAccMap = new Map<Id,Technology_Profile__c>();
        for(Technology_Profile__c each : Trigger.New){
            accIdList.add(each.FK_Account__c);
        }
        List<Technology_Profile__c> techProfList = [select Name,Id,FK_Account__c from Technology_Profile__c where FK_Account__c IN : accIdList];
        if(techProfList != null){
            for(Technology_Profile__c each : techProfList){
                techAccMap.put(each.FK_Account__c , each);
            }
            for(Technology_Profile__c each : Trigger.New){
                if(techAccMap.get(each.FK_Account__c) != null){
                    each.addError('Technology Profile already exists for this Account. You cannot create multiple profiles, please edit the existing profile.');
                }
            }
        }
        
    }
}