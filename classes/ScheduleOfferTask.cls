/************************************************************************************************************************************
Name    : ScheduleOfferTask
Author  : C360 Dev team
Purpose : Contains logic to execute on creating Offer Tasks
Date    : 24/01/2019
Change History : 5/7/2019 Prod fix for Tasks creation
*************************************************************************************************************************************/
global class ScheduleOfferTask implements Database.Batchable<SObject>
 {   
 Public String query;
 global ScheduleOfferTask(String qry){
     query = qry;
 }
     global Database.queryLocator start(Database.BatchableContext ctx)
     {

        return Database.getQueryLocator(query);

     }
     global void execute(Database.BatchableContext BC, List<Offer__c> offerList)
     {
         //for creating new tsortunity.
            system.debug('offerList'+offerList);
            
            List<Task> newTasks=new List<Task>();
            List<Task_Master__c> tsMasterList = new List<Task_Master__c>();
            Map<string,List<Task_Master__c>> mapOfferMaster = new Map<string,List<Task_Master__c>>();
            
              //tsMasterList =[select name,Task_Name__c,Task_Stage__c,Task_Type__c,Offer_Name__c from Task_Master__c];
              tsMasterList = Database.query( Apex_Batch_Job__c.getInstance('ScheduleOfferTask').query1__c);
             for(Task_Master__c tsMaster:tsMasterList){
                 if(!mapOfferMaster.containskey(tsMaster.Offer_Name__c)){
                     List<Task_Master__c> taskMasterList= new List<Task_Master__c>();
                     taskMasterList.add(tsMaster);
                     mapOfferMaster.put(tsMaster.Offer_Name__c,taskMasterList);
                 } 
                 else {
                     List<Task_Master__c> taskMast = mapOfferMaster.get(tsMaster.Offer_Name__c);
                     taskMast.add(tsMaster);
                     mapOfferMaster.put(tsMaster.Offer_Name__c,taskMast);
                 }
             }
         system.debug('mapOfferMaster'+mapOfferMaster);
         system.debug('offerList'+offerList);
            List<Offer__c> offerUpdate = new List<Offer__c>();
            for(Offer__c c: offerList ){
                   List<Task_Master__c> tsmList = new List<Task_Master__c>();
                   tsmList = mapOfferMaster.get(c.Offer_Level_1_Name__c);
                system.debug('tsmList'+tsmList);
                   if(tsmList != null){
                       for(Task_Master__c tsm:tsmList){
                            Task ts1=new Task();
                            ts1.Task_Name__c=tsm.Task_Name__c;
                            ts1.Task_Stage__c=tsm.Task_Stage__c;
                            ts1.Task_Type__c=tsm.Task_Type__c;
                            ts1.WhatId=c.Id;
                            ts1.Subject=tsm.Task_Name__c;
                            newTasks.add(ts1);
                       }
                      c.Task_Created__c = false; 
                   }
            }
            if(newTasks.size() > 0){
            
                insert newTasks;
            }
            if (offerList.size()>0){
                  update offerList;
            }
            
     }
     global void finish(Database.BatchableContext BC)
     {

     }
}