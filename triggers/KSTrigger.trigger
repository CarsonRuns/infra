/*
  Name        : KS Trigger 
  Author      : Serge Borysov (sborysov)
  Release     : 1.0
  Functionality   : Trigger for Key Stakeholders
  Created      : June 13 2019
  
  Modification History:
  Date    Author      Change 
*/

trigger KSTrigger on Key_Stakeholders__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
        TriggerHandler.execute(KeyStakeholderTriggerImpl.class);
}