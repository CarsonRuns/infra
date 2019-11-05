/************************************************************************************************************************************
Name    : ScheduleOfferTaskTest
Author  : C360 Dev team
Purpose : Contains logic to execute test case for a Batch class which works on Offer Task
Date    : 24/01/2019
*************************************************************************************************************************************/
@isTest(SeeallData=False)
public class ScheduleOfferTaskTest {

static testMethod void testMethod1() 
    {
        List<Offer__c> lstOffer= new List<Offer__c>();
        for(Integer i=0 ;i <2;i++)
        {
            Offer__c off = new Offer__C();
            off.Name ='OfferName'+i;
            off.Offer_Level_1_Name__c='OfferName'+i;
            lstOffer.add(off);
        }
        
        insert lstOffer;
         List<ID> offerId  = new List<ID>();
        for( Offer__c offid : lstOffer )
        {
            offerId.add(offid.Id);
         
        }       
        
        List<Task_Master__c> Tsm = new List<Task_Master__c>();
        for(Integer i=0; i<5;i++)
        {
            Task_Master__C ts = new Task_Master__C();
            ts.Task_Name__c ='TaskName'+i;
            
            
            ts.Offer_Name__c ='OfferName'+i;
            Tsm.add(ts);
        }
        insert tsm;
        
        List<Task> Ots = new List<Task>();
        for(Offer__c off : lstOffer )
        for(Task_Master__c ts : tsm)
        {
            if(off.Offer_Level_1_Name__c == ts.Offer_Name__c){
            Task ts1 = new Task();
            ts1.Task_Name__c=ts.Task_Name__c;
               ts1.Task_Stage__c='Purchase';
               ts1.Task_Type__c='ACTIVITIES';
              
               
                
              
               ots.add(ts1);
            }
        }
        insert ots;
         List<Task> Ots2 = new List<Task>();
        {
           Task ts1 = new Task();
               ts1.Task_Stage__c='Implement' ;
            ts1.Description='Additional Notes Text';
            ts1.Id=ots[1].Id;
               ots2.add(ts1);
            
        }
        
        update ots2;
        
         Offer__c off = new Offer__C();
            off.Name ='OfferName';
            off.Offer_Level_1_Name__c='OfferName';
        off.Annual_Recurring_Revenue_ARR__c = 100000;
            off.Tier_Support__c = 'Level1';
            off.Term_Length__c = '2 Years';
            off.Next_Contract_Renewal_Date__c =system.Today();
        insert off;
          
      Id offID = off.Id;
        
        String Stage='Purchase';
        String NullString ='';
        
        Set<string> subjectSet = new Set<string>();      
       for(Task t : [SELECT Id,WhatId FROM Task where What.Type='Offer__c']){
       subjectSet.add(t.WhatId);
       }
       
        Apex_Batch_Job__c setting = new Apex_Batch_Job__c();
        setting.Name = 'ScheduleOfferTask';
        setting.query__c = 'SELECT Id,Name, Offer_Level_1_Name__c FROM Offer__c limit 1';
        setting.query1__c = 'SELECT name,Task_Name__c,Task_Stage__c,Task_Type__c,Offer_Name__c FROM Task_Master__c WHERE IsNewTask__c = False';
        insert setting;
        
        
        Test.startTest();
            //Apex_Batch_Job__c abj = Apex_Batch_Job__c.getValues('Test Setting'); 
           // system.debug('abj--->'+abj);
           // String query = abj.query__c;
            ScheduleOfferTaskScheduleBatchApex sOffer = new ScheduleOfferTaskScheduleBatchApex();
            String sch = '0 0 8 13 2 ?';
            //ScheduleOfferTask obj = new ScheduleOfferTask(query);
            String jobIds = System.schedule('testBasicScheduledApex',sch,sOffer);
            //Id JobId = DataBase.executeBatch(obj,200);
            
        Test.stopTest();
    }
}