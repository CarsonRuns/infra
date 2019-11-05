trigger P360_CCW_Ownership_Change on Multi_Object_Quote__c (before insert ,before update) {

  Map<ID,ID> mapTPIds = new Map<ID,ID>(); 
  Set<ID> setTPIds = new Set<ID>(); 
  
   for(Multi_Object_Quote__c moq: Trigger.new)
   {
     if(moq.Target_Prospect__c != null)
      {
         setTPIds.add(moq.Target_Prospect__c);
      }     
   } 
   
  for(Assigned_Partner__c tp:[select id,ownerid from Assigned_Partner__c where Id IN: setTPIds])
  {
    mapTPIds.put(tp.id,tp.ownerid);
  }
   
  for(Multi_Object_Quote__c moq: Trigger.new)
   {
     if(moq.Target_Prospect__c != null)
      {
         moq.ownerid = mapTPIds.get(moq.Target_Prospect__c);
      }     
   }    
   
}