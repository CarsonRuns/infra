/***************************************************************************************************
Name    : CPOCRoomsTriggerHandler 
Author  : Abinash Das
Purpose : Handler Class to delete Rooms once deleted from related list.  
Created Date: Apr 08 2016              
*****************************************************************************************************/

Public Class CPOCRoomsTriggerHandler{
    
    // SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdate(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }

    public List<CPOC_Room__c> listNewroomsSobject;
    public List<CPOC_Room__c> listOldroomsSobject;
    Map<Id,List<String>> mapCPOCEngagementRooms;
    
    public CPOCRoomsTriggerHandler(List<sObject> listOld, List<sObject> listNew){
        listNewroomsSobject = new List<CPOC_Room__c>();
        listOldroomsSobject = new List<CPOC_Room__c>();
        listNewroomsSobject = listNew;
        listOldroomsSobject = listOld;
    }
    /* Method to create Room data */
    public void assignRoomsOnDML( String dmlRooms ){

        Set<Id> setRoomsEventId = new Set<Id>();
        mapCPOCEngagementRooms = new Map<Id,List<String>>();
        if( dmlRooms == 'upsert' ){
            if( listNewroomsSobject != null ){
                for(CPOC_Room__c sObjroomdata : listNewroomsSobject ){
                
                    if(!setRoomsEventId.contains(sObjroomdata.Customer_Engagements_Events__c)){
                    
                        setRoomsEventId.add(sObjroomdata.Customer_Engagements_Events__c);
                    }
                }
                List<CEE__c> listCPOCroomEvents = new List<CEE__c>();
                listCPOCroomEvents = [SELECT Id, (SELECT Id, Customer_Engagements_Events__c, Room__r.Name FROM CPOC_Rooms__r) FROM CEE__c WHERE Id IN : setRoomsEventId ];
        
                for( CEE__c cpocroomEvents : listCPOCroomEvents  ){
                    
                    if(! mapCPOCEngagementRooms.keySet().contains(cpocroomEvents.Id) ){
                    
                        mapCPOCEngagementRooms.put( cpocroomEvents.Id, new List<String>() );
                        
                    }
                    
                    for( CPOC_Room__c dataRooms: cpocroomEvents.CPOC_Rooms__r ){
                        
                        mapCPOCEngagementRooms.get(cpocroomEvents.Id).add(dataRooms.Room__r.Name);
                    }
                    
                }
            }
        }else if( dmlRooms == 'delete' ){
        
            prepareTheDataForRoomDeleteProcess();
        }
        system.debug('map'+mapCPOCEngagementRooms);
        genericProcessForAllRoomDMLAction(mapCPOCEngagementRooms);
        
    }
    /* Method to delete Room if deleted from related list */
    public void prepareTheDataForRoomDeleteProcess(){
        Set<Id> setRoomsEventId = new Set<Id>();
        if( listOldroomsSobject != null ){
            for(CPOC_Room__c sObjroomdata : listOldroomsSobject ){
            
                if(!setRoomsEventId.contains(sObjroomdata.Customer_Engagements_Events__c)){
                
                    setRoomsEventId.add(sObjroomdata.Customer_Engagements_Events__c);
                }
            }
            List<CEE__c> listCPOCroomEvents = new List<CEE__c>();
            listCPOCroomEvents = [SELECT Id, (SELECT Id, Customer_Engagements_Events__c, Room__r.Name FROM CPOC_Rooms__r) FROM CEE__c WHERE Id IN : setRoomsEventId ];
    
            for( CEE__c cpocroomEvents : listCPOCroomEvents  ){
                
                if(! mapCPOCEngagementRooms.keySet().contains(cpocroomEvents.Id) ){
                
                    mapCPOCEngagementRooms.put( cpocroomEvents.Id, new List<String>() );
                    
                }
                
                for( CPOC_Room__c dataRooms : cpocroomEvents.CPOC_Rooms__r ){
                    
                    mapCPOCEngagementRooms.get(cpocroomEvents.Id).add(dataRooms.Room__r.Name);
                }
                
            }
        }

    }
     /* Method to add Rooms once added to Related List */
    public void genericProcessForAllRoomDMLAction(Map<Id,List<String>> mapCPOCEngagementRooms){
        List<CEE__c> listRoomEventsToUpdate = new List<CEE__c>();
        for( Id eventId : mapCPOCEngagementRooms.keySet() ){
            String roomsFormatted = '';
            Integer loopCounter = 0;
            if(mapCPOCEngagementRooms.get(eventId).isEmpty() ){
                CEE__c ceeObj = new CEE__c(Id=eventId);
                // SCAVA FIX
                if(flsUpdate(CEE__c.Room_Name__c))
                {
                ceeObj.Room_Name__c = ''; 
                }
                listRoomEventsToUpdate.add(ceeObj);
            }else{                                           
                 for( String roomname : mapCPOCEngagementRooms.get(eventId) ){                
                    if( loopCounter == 0 ){
                        roomsFormatted = roomname;
                    }else{
                        roomsFormatted = roomsFormatted+','+roomname;
                    }
                    loopCounter++;
                }  
                CEE__c ceeObj = new CEE__c(Id=eventId);
                // SCAVA FIX
                if(flsUpdate(CEE__c.Room_Name__c))
                {
                ceeObj.Room_Name__c  = roomsFormatted;
                }
                listRoomEventsToUpdate.add(ceeObj);
            }
            
            
        }
        update listRoomEventsToUpdate;
    }
}