public class User_Capitalization_Rules  implements TriggerInterface {
    /**
     * @description beforeInit setup methods
     */
    public void beforeInit(){

        
    } 
    
    /**
     * @description afterInit setup methods
     */
    public void afterInit(){
    
    }
    
    /**
     * @description Trigger.beforeInsert methods
     */ 
    public void executeBeforeInsert(){
        executeCapitalizationRules(Trigger.new);
        
       
    }

    /**
     * @description Trigger.afterInsert methods
     */
    public void executeAfterInsert(){
        
    }

    /**
     * @description Trigger.beforeUpdate methods
     */
    public void executeBeforeUpdate(){ 
          executeCapitalizationRules(Trigger.new);
    }

    /**
     * @description Trigger.afterUpdate methods
     */
    public void executeAfterUpdate(){ 
    }
    
    /**
     * @description Trigger.beforeDelete methods
     */
    public void executeBeforeDelete(){
        
    }

    /**
     * @description Trigger.afterDelete methods
     */
    public void executeAfterDelete(){

    }

    /**
     * @description Trigger.undelete methods
     */
    public void executeUnDelete(){
        
    }
    
    public void executeUpdate(){
        //String userList = 'Select Id,FirstName,LastName From User where Id in (Select ownerid from account where ( NOT Owner.Name Like \'%DUMMY%\')) AND IsActive = true ';
        //User[] objDBList = Database.query(userList);

        //System.debug(objDBList.size());
    }
    
    public void executeCapitalizationRules(List<User> newUserLst){
        for (User user: newUserLst){
            //Zak: Added && ignoreCaseRules in condition
            if (user.FirstName != null && user.IgnoreCaseRule__c !=TRUE ){
                String userFirstName = firstNameManipulation(user.FirstName);
                user.FirstName = userFirstName;
            }
            //Zak: Added IgnoreCaseRules IF-Condition
            if(user.IgnoreCaseRule__c !=TRUE){
            String userLastName = lastNameManipulation(user.LastName);
            user.LastName= userLastName;
            }
        }
       
    }
    
    public String lastNameManipulation(String userLastName){
            userLastName = firstNameManipulation(userLastName);
            userLastName = capitalizeAll(userLastName, '\'');
            
            return userLastName;
    }
    
    public String firstNameManipulation(String userFirstName){
            userFirstName = userFirstName.toLowerCase();
            userFirstName = capitalizeAll(userFirstName, ' ');
            userFirstName = capitalizeAll(userFirstName, '-');
            return userFirstName;
    }
    
    public String capitalizeAll(String firstName, String symbol){
        String newFirstName = '';
        if (firstName.contains(symbol)){
                String[] splitName = firstName.split(symbol);
                for (String s: splitName){
                    newFirstName = newFirstName + s.capitalize() + symbol;
                }
                newFirstName = newFirstName.substring(0, newFirstName.length()-1);
        } else{
            newFirstName = firstName.capitalize();
        }
        return newFirstName;
    }

}