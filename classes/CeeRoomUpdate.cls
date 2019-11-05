/***************************************************************************************************
Name    : CEE_AgendaItemController 
Author  : Sourabha
Created Date: June 16 2015
Purpose : Update CEE Room Name value from the list of Rooms added to the briefing.
Modification History: 
*****************************************************************************************************/ 

public  class CeeRoomUpdate{
    public static boolean runOnce = false;
    public static void RoomUpdate(List<Agenda_Room__c> rsNew, List<Agenda_Room__c> rsOld){
        List<CEE__c> updateCEC = new List<CEE__c>();
        List<CEE__c> updateCECS = new List<CEE__c>();
        List<id> ceeID = new List<ID>();
        List<id> ceeIDs = new List<ID>();
        List<Agenda_Room__c> agendaRoomLst=new List<Agenda_Room__c>();
        Map<string,string> agendaRoomMap=new Map<string,string>();
        Map<string,string> agendaRoomsMapNew=new Map<string,string>();
        Map<string,string>agendaRoomsMapOld=new Map<string,string>();
        string obxTypeId = ObjectRecordTypeIds__c.getorgdefaults().CEE_OBX_Record_Type_ID__c; 
        
        system.debug('$$rsOld'+rsOld);
        if(trigger.isDelete){
            for(Agenda_Room__c a: rsOld){        
                ceeID.add(a.Customer_Engagements_Events__c);            
                agendaRoomMap.put(a.Customer_Engagements_Events__c,a.room_name__c);
            }
            system.debug('$ceeID'+ceeID);            
            if(!ceeID.isEmpty() ){
                updateCEC=[select room_name__c,id from cee__c where id in :ceeID and RecordTypeId =: obxTypeId];
                system.debug('$$CEC id'+updateCEC);
                for(cee__c c:updateCEC){
                    String name=c.room_name__c;
                    system.debug('$$ name'+Name);
                    if(name!=null ){
                        if( name.contains(agendaRoomMap.get(c.id)+',')){
                            c.room_name__c=name.remove(agendaRoomMap.get(c.id)+',');
                        }
                        else if( name.contains(', '+agendaRoomMap.get(c.id))){
                            c.room_name__c=name.remove(', '+agendaRoomMap.get(c.id));
                        }
                        else{ 
                            c.room_name__c=name.remove(agendaRoomMap.get(c.id));                    
                            system.debug('$$room name'+c.room_name__c);
                        }
                    }
                }   
            }
            try{   
                runOnce = true;
                update updateCEC;
            }catch(Exception e){
                system.debug('Exception' + e);
            }
        }

        //TJ - Uncommented Line# 49, 50
        if(trigger.isUpdate){           
            agendaRoomLst=[select id,Customer_Engagements_Events__c, room_name__c from Agenda_Room__c where id in :rsNew];
            for(Agenda_Room__c aNew: agendaRoomLst){ 
                if(aNew.room_name__C != null){
                    Agenda_Room__c aOld  = (Agenda_Room__c)trigger.oldmap.get(aNew.id); 
                    if(aNew.room_name__c != aOld.room_name__c){                        
                    system.debug('**aNew' + aNew);
                    system.debug('**aOld' + aOld);
                        ceeIDs.add(aNew.Customer_Engagements_Events__c);            
                        agendaRoomsMapNew.put(aNew.Customer_Engagements_Events__c,aNew.room_name__c);                       
                    }
                }
            }
        }
        //TJ - Uncommented Line# 49, 50
        if(trigger.isInsert){  
            system.debug('**insert');         
            agendaRoomLst=[select id,Customer_Engagements_Events__c, room_name__c from Agenda_Room__c where id in :rsNew];
            system.debug('%%agendaRoomLst'+agendaRoomLst);
            for(Agenda_Room__c aNew: agendaRoomLst){ 
                if(aNew.room_name__C != null){                                        
                    ceeIDs.add(aNew.Customer_Engagements_Events__c);            
                    agendaRoomsMapNew.put(aNew.Customer_Engagements_Events__c,aNew.room_name__c);   
                }
            }
        }   
           
        system.debug('%%agendaRoomsMapNew'+agendaRoomsMapNew);
        if(!ceeIDs.isEmpty() && agendaRoomsMapNew.size()!=0 ){
        system.debug('%%obxTypeId'+obxTypeId);
        system.debug('%%ceeIDs'+ceeIDs);
            try{
                updateCECS = [select room_name__c,id from cee__c where id =:ceeIDs and RecordTypeId =: obxTypeId];               
                system.debug('%%updateCECS'+updateCECS);
            }catch(Exception e){system.debug('%%exception on query'+updateCECS);}
            
            for(cee__c c:updateCECS){                    
                if(c.room_name__c==null){
                    c.room_name__c=agendaRoomsMapNew.get(c.id);
                }
                else{
                    if(!c.room_name__c.contains(agendaRoomsMapNew.get(c.id)))
                        c.room_name__c=c.room_name__c+', '+agendaRoomsMapNew.get(c.id);                            
                }                   
            }            
            try{      
                system.debug( updateCECS); 
                runOnce = true; 
                update updateCECS;
            }catch(Exception e){
                system.debug('Exception' + e);
            }
        }
    } 
}