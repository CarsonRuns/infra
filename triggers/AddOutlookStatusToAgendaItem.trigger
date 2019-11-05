/**************************************************************************************************
   @Author :Jay Dash
   @name :addOutlookStatusToAgendaItem
   @CreateDate : 08/5/2015
   @Description : This controller manages to autopopulate the outlook status in Agenda Item section of Briefing detail page
   @Version :1.0
   Modification History:
    Sudi (10/21/2015) : Put a fix for too many SOQL rows coming(i.e INC000034225757) from line 29 when CEE request has no Agenda items
                        Added null check before executing the SOQL query. 
    nmuppall(6/9/2016) : Fixed outlook status update issue on agenda item after deletion of CEE Attedee record
  *************************************************************************************************/
trigger AddOutlookStatusToAgendaItem on CEE_Invite__c (after update, after insert, after delete) {
    private static final String TAG = 'addOutlookStatusToAgendaItem - ';
    
    //update Agenda item added 8/5/15
    Set<Id> agendaUpdates = new Set<Id>();
    List<Agenda_Item__c> agendaToUpdate = new List<Agenda_Item__c>();
    Map<Id, Agenda_Item__c> agendaMap = new Map<Id, Agenda_Item__c>();
    List<String> ListAgenda;
    List<String> ListIterAgenda;
    set<string> aId = new set<string>();
    Map<id, string> mapOutLookValue = new Map<id,string>();
    List<CEE_Invite__c> lstInvite = new List<CEE_Invite__c>();
    if(!trigger.isDelete){
        for(CEE_Invite__c cInv :trigger.new){
            // Sudi Added(10/21/2015) Prod INC - INC000034225757 
            // Added null check for the soql query.  
            if(cInv.Agenda_Item__c != null){
                aId.add(cInv.Agenda_Item__c);   
            }           
        }
        // Sudi Added (10/21/2015) Prod INC - INC000034225757 
        // Added Empty list check for the soql query.           
        if(!aId.isEmpty()){
            for(CEE_Invite__c cinvs : [select Id, CEE_Attendee__c,Outlook_Status__c, Agenda_Item__c from CEE_Invite__c where Agenda_Item__c in : aId order by name]){
                if(cinvs.Agenda_Item__c != null){
                    if(mapOutLookValue.containsKey(cinvs.Agenda_Item__c)){
                        string outlkStr = mapOutLookValue.get(cinvs.Agenda_Item__c);
                        outlkStr +=','+cinvs.Outlook_Status__c;
                        mapOutLookValue.put(cinvs.Agenda_Item__c,outlkStr);         
                    }else{
                        mapOutLookValue.put(cinvs.Agenda_Item__c,cinvs.Outlook_Status__c);
                    }
                }
            }
        }
         
        for(Id agItem : mapOutLookValue.keySet()){
            Agenda_Item__c agendItem = new Agenda_Item__c();
            agendItem.id = agItem;
            agendItem.Outlook_Status__c = mapOutLookValue.get(agItem);
            agendaToUpdate.add(agendItem);
        }
    }else{
        for(CEE_Invite__c cInv :trigger.old){
            // Sudi Added(10/21/2015) Prod INC - INC000034225757 
            // Added null check for the soql query. 
            if(cInv.Agenda_Item__c != null){
                aId.add(cInv.Agenda_Item__c);  
            }           
        }
     // Sudi Added (10/21/2015) Prod INC - INC000034225757 
     // Added Empty list check for the soql query.  
     
     if(!aId.isEmpty()){
         List<CEE_Invite__c> ceeList = [select Id, CEE_Attendee__c,Outlook_Status__c, Agenda_Item__c from CEE_Invite__c where Agenda_Item__c in : aId order by name];
            if(!ceeList.isEmpty()){
                for(CEE_Invite__c cinvs :ceeList){
                    if(cinvs.Agenda_Item__c != null){
                        if(mapOutLookValue.containsKey(cinvs.Agenda_Item__c)){
                            string outlkStr = mapOutLookValue.get(cinvs.Agenda_Item__c);
                            outlkStr +=','+cinvs.Outlook_Status__c;
                            mapOutLookValue.put(cinvs.Agenda_Item__c,outlkStr);         
                        }else{
                            mapOutLookValue.put(cinvs.Agenda_Item__c,cinvs.Outlook_Status__c);
                        }
                    }
                }
            }
            //nmuppall added else part for nullifying agenda item's outlook status after deleting all CEE Invites
            else{ 
                List<Agenda_Item__c> agendaList = [Select Id,OutLook_Status__c from Agenda_Item__c where Id in :aId];
                if(!agendaList.isEmpty()){
                    for(Agenda_Item__c agenda : agendaList){
                        agenda.OutLook_Status__c = '';
                        mapOutLookValue.put(agenda.Id,agenda.OutLook_Status__c);
                    }
                }
            } 
      }
        for(Id agItem : mapOutLookValue.keySet()){
            Agenda_Item__c agendItem = new Agenda_Item__c();
            agendItem.id = agItem;
            agendItem.Outlook_Status__c =mapOutLookValue.get(agItem);
            agendaToUpdate.add(agendItem);
        }
       
    }
    
    try{
        if(!agendaToUpdate.isEmpty()) {
            update agendaToUpdate;  
        }
    } catch (Exception e){
        System.debug(TAG + e.getStackTraceString());
    }
}