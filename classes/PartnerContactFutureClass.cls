public class PartnerContactFutureClass {

  @future 
  public static void updateContactMapping(ID[] partnerRecordIds) {
 
      Partner_Contact_Oppty_Mapping__c[] mappingToUpdate = [Select Id From Partner_Contact_Oppty_Mapping__c Where Partner_Contact__c IN :partnerRecordIds];
      
      if(mappingToUpdate.size() > 0)
        update mappingToUpdate;
  }
}