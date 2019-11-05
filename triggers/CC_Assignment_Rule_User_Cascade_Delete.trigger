trigger CC_Assignment_Rule_User_Cascade_Delete on User (after delete, after update) {
   //Check added by Awnish for Case # INC000032321211 [P360 User Onboarding Exception Notification]
   if(!(system.isBatch() || system.isFuture())){
    List<String> inactivated = new List<String>();
    List<CC_Assignment_Rule_Users__c> delete_list;
    if(trigger.isupdate){
        for(User u :trigger.new){
            if(u.isactive == false){
                inactivated.add(u.id);
            }
        }
        if(inactivated.size()==0){
            return;
        }
    }
    else{
        for(User u :trigger.old){
            inactivated.add(u.id);
        }
    }
    
    CC_Assignment_Rule_User_Cascade_Delete.cascade_delete(inactivated);
    }
}