public class CC_Assignment_Rule_User_Cascade_Delete 
{

    @future(callout=false)
    public static void cascade_delete(List<string> inactivated){
        List<CC_Assignment_Rule_Users__c> delete_list = [Select id from CC_Assignment_Rule_Users__c where user__c in :inactivated];
        //SCAVA FIX
            if (CC_Assignment_Rule_Users__c.sObjectType.getDescribe().isDeletable())
               {
                delete delete_list;
               }
    }

}