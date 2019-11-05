/***************************************************************************************************
Name    : CPOCRoomsTriggerHandler 
Author  : Abinash Das
Purpose : Handler Class to delete Personnel once deleted from related list.  
Created Date: Apr 08 2016              
*****************************************************************************************************/

Public Class CPOCPersonnelTriggerHandler{
    
    // SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdate(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }

    public List<CPOC_Personnel__c> listNewSobject;
    public List<CPOC_Personnel__c> listOldSobject;
    Map<Id,List<String>> mapCPOCEngagementPersonnel;
    
    public CPOCPersonnelTriggerHandler(List<sObject> listOld, List<sObject> listNew){
        listNewSobject = new List<CPOC_Personnel__c>();
        listOldSobject = new List<CPOC_Personnel__c>();
        listNewSobject = listNew;
        listOldSobject = listOld;
    }
    /* Method to create Personnel data */
    public void assignEngineerOnDML( String dmlType ){

        Set<Id> setPersonnelEventId = new Set<Id>();
        mapCPOCEngagementPersonnel = new Map<Id,List<String>>();
        if( dmlType == 'upsert' ){
            if( listNewSobject != null ){
                for(CPOC_Personnel__c sObjdata : listNewSobject ){
                
                    if(!setPersonnelEventId.contains(sObjdata.Customer_Engagements_Events__c)){
                    
                        setPersonnelEventId.add(sObjdata.Customer_Engagements_Events__c);
                    }
                }
                List<CEE__c> listCPOCEvents = new List<CEE__c>();
                listCPOCEvents = [SELECT Id, (SELECT Id, Customer_Engagements_Events__c, Personnel__r.User__r.alias FROM CPOC_Personnels__r) FROM CEE__c WHERE Id IN : setPersonnelEventId ];
        
                for( CEE__c cpocEvents : listCPOCEvents  ){
                    
                    if(! mapCPOCEngagementPersonnel.keySet().contains(cpocEvents.Id) ){
                    
                        mapCPOCEngagementPersonnel.put( cpocEvents.Id, new List<String>() );
                        
                    }
                    
                    for( CPOC_Personnel__c dataPersonnel : cpocEvents.CPOC_Personnels__r ){
                        
                        mapCPOCEngagementPersonnel.get(cpocEvents.Id).add(dataPersonnel.Personnel__r.User__r.alias);
                    }
                    
                }
            }
        }else if( dmlType == 'delete' ){
        
            prepareTheDataForDeleteProcess();
        }
        genericProcessForAllDMLAction(mapCPOCEngagementPersonnel);
        
    }
    /* Method to delete Personnel if deleted from related list */
    public void prepareTheDataForDeleteProcess(){
        Set<Id> setPersonnelEventId = new Set<Id>();
        if( listOldSobject != null ){
            for(CPOC_Personnel__c sObjdata : listOldSobject ){
            
                if(!setPersonnelEventId.contains(sObjdata.Customer_Engagements_Events__c)){
                
                    setPersonnelEventId.add(sObjdata.Customer_Engagements_Events__c);
                }
            }
            List<CEE__c> listCPOCEvents = new List<CEE__c>();
            listCPOCEvents = [SELECT Id, (SELECT Id, Customer_Engagements_Events__c, Personnel__r.User__r.alias FROM CPOC_Personnels__r) FROM CEE__c WHERE Id IN : setPersonnelEventId ];
    
            for( CEE__c cpocEvents : listCPOCEvents  ){
                
                if(! mapCPOCEngagementPersonnel.keySet().contains(cpocEvents.Id) ){
                
                    mapCPOCEngagementPersonnel.put( cpocEvents.Id, new List<String>() );
                    
                }
                
                for( CPOC_Personnel__c dataPersonnel : cpocEvents.CPOC_Personnels__r ){
                    
                    mapCPOCEngagementPersonnel.get(cpocEvents.Id).add(dataPersonnel.Personnel__r.User__r.alias);
                }
                
            }
        }

    }
    /* Method to add Personnel once added to Related List */
    public void genericProcessForAllDMLAction(Map<Id,List<String>> mapCPOCEngagementPersonnel){
        List<CEE__c> listEventsToUpdate = new List<CEE__c>();
        for( Id eventId : mapCPOCEngagementPersonnel.keySet() ){
            String aliasFormatted = '';
            Integer loopCounter = 0;
            if(mapCPOCEngagementPersonnel.get(eventId).isEmpty() ){
                CEE__c ceeObj = new CEE__c(Id=eventId);
                // SCAVA FIX
                if(flsUpdate(CEE__c.Assigned_Engineer__c))
                {
                ceeObj.Assigned_Engineer__c = '';
                }
                listEventsToUpdate.add(ceeObj);
                
            }else{                                           
                for( String aliasname : mapCPOCEngagementPersonnel.get(eventId) ){
                    if( loopCounter == 0 ){
                        aliasFormatted = aliasname;
                    }else{
                        aliasFormatted = aliasFormatted+','+aliasname;
                    }
                    loopCounter++;
                }  
                CEE__c ceeObj = new CEE__c(Id=eventId);
                // SCAVA FIX
                if(flsUpdate(CEE__c.Assigned_Engineer__c))
                {
                ceeObj.Assigned_Engineer__c = aliasFormatted;
                }
                listEventsToUpdate.add(ceeObj);
            }
            
            
        }
        update listEventsToUpdate;
    }
}