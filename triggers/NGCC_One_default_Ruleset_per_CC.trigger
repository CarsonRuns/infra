trigger NGCC_One_default_Ruleset_per_CC on CC_Assignment_Ruleset__c (before insert, before update) {

    if(trigger.isUpdate){
        Integer updatecount=0;
        for(CC_Assignment_Ruleset__c rs: trigger.new){
            if(rs.isDefault__c == true && (trigger.oldMap.get(rs.id).isDefault__c != rs.isDefault__c)){
                updatecount++;
            }
        }
        if(updatecount==0){
            return;
        }
    }
    
    List<CC_Assignment_Ruleset__c> defaults = [Select id, name, Contact_Center__r.name, Contact_Center__c from CC_Assignment_Ruleset__c where isDefault__c = true];

    for(CC_Assignment_Ruleset__c newRuleset: trigger.new){
        for(CC_Assignment_Ruleset__c checked :defaults){
            if(newRuleset.isDefault__c == true && (newRuleset.Contact_Center__c == checked.Contact_Center__c)){
                String sBreak = '';
                String msg = 'The Contact Center "' + checked.Contact_Center__r.name + '" already has a default Ruleset: ' + checked.name + '(' + checked.id + ').';
                newRuleset.addError(msg + sBreak +' Please uncheck the "Default" checkbox for "' + checked.name + '(' + checked.id + ')' + '" before making this one the default.');
            }
        }
    }
}