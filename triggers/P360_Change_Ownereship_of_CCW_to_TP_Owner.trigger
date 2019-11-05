trigger P360_Change_Ownereship_of_CCW_to_TP_Owner on Assigned_Partner__c (after update) {

  Map<ID,ID> mapTPIds = new Map<ID,ID>();  
  List<Multi_Object_Quote__c> lstCCW = new List<Multi_Object_Quote__c>();
  
   for(Assigned_Partner__c tp: System.Trigger.new)
   {
      if(System.Trigger.oldMap.get(tp.id).ownerid != tp.ownerid)
      {
        mapTPIds.put(tp.id,tp.ownerid);
      }      
   } 
   
   for(Multi_Object_Quote__c moq:[Select id,ownerid,Target_Prospect__c from Multi_Object_Quote__c where Target_Prospect__c IN: mapTPIds.keyset()])
   {
      if(mapTPIds.containsKey(moq.Target_Prospect__c))
       {
          moq.ownerid = mapTPIds.get(moq.Target_Prospect__c);
          lstCCW.add(moq);    
       }       
   } 
   
  try{ 
   if(!lstCCW.isEmpty())
      update lstCCW; 
    }
    catch(Exception ex)
    {
     //throw ex;    
    }
    
}