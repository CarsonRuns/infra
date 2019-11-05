trigger AT_Workspace on AT_Workspace__c (before insert, before update) {
    for (AT_Workspace__c o : Trigger.new){
        if(o.is_Multi_Tech__c == false) {
            o.Name = o.AT_Technology__c + ' -- ' + o.AT_Sub_Technology__c;
            if(o.PSS__c == null){
                o.PSS__c = UserInfo.getUserId();
            }  
        } 
    }
}