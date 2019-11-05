/***************************************************************************************************
Name    : CEE_AgendaItemController 
Author  : Bramha
Purpose : Batch class to update CEE Roomname frm Related Lists
Created Date: Dec 1 2014
Modification History: 
May'2015 WR-01089 - bdabbara : Added doSaveNew() method for new "Save & New" button action
*****************************************************************************************************/ 
global with sharing class RoomUpdateBatch implements Database.Batchable<sObject>{
      
        private final string query;
        
        global RoomUpdateBatch(String query)
        {
            this.query = query;
        } 
        
        global Database.QueryLocator start(Database.BatchableContext BC)
        {     
            system.debug('query-->'+query);    
            return Database.getQueryLocator(query);             
        }
                
        global void execute(Database.BatchableContext BC, List<sObject> scope)
        { 
            
            set<string> ceeIDs = new set<string>();       
            List<cee__c> updateCECS  = new List<cee__c>();
            List<cee__c> updateCECS1  = new List<cee__c>();
            Map<string,string> agendaRoomsMapNew=new Map<string,string>();
            string obxTypeId = ObjectRecordTypeIds__c.getorgdefaults().CEE_OBX_Record_Type_ID__c;   
            for(Agenda_Room__c aNew: (List<Agenda_Room__c>)scope){ 
                if(aNew.Room_Name_Dataloder__c != null){                                  
                    ceeIDs.add(aNew.Customer_Engagements_Events__c);                    
                    agendaRoomsMapNew.put(aNew.Customer_Engagements_Events__c,aNew.Room_Name_Dataloder__c);  
                            
                }
            }
            
            if(!ceeIDs.isEmpty()){
                updateCECS = [select room_name__c,id from cee__c where id in :ceeIDs and RecordTypeId =: obxTypeId ];                
                system.debug('%%updateCECS'+updateCECS);
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
                    update updateCECS;
                }catch(Exception e){
                    system.debug('Exception'+e);
                }
            }   
        }
        global void finish(Database.BatchableContext BC)
        {
           System.debug('Job Completed');  
        }   
    }