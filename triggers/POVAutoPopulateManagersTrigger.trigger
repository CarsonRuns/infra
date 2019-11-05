/** 
   * Author: Jay Dash
   * Description: Auto populate manager fields in pov detail page 
   * Date Created: 9/11/2014 
   * Version: 0.1
   */

trigger POVAutoPopulateManagersTrigger on Proof_of_Value__c(before insert,before update,after update){
      
   if(trigger.isBefore){
       AutoPopulateManager.autoPopulate(trigger.new);
   }
    
    if(trigger.isUpdate && trigger.isAfter){
   
   AutoPopulateManager.submitForApproval(trigger.new,trigger.OldMap);
    
    }
}