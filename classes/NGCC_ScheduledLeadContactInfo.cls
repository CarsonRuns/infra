global class NGCC_ScheduledLeadContactInfo implements Schedulable {
   global void execute(SchedulableContext SC) {
      NGCC_UpdateLeadContactInfo objLdCont = new NGCC_UpdateLeadContactInfo(); 
       Database.executeBatch(objLdCont);
   }
   
}