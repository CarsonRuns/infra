/**
 * Name : TaskTrigger_Test
 * Author :  Unit Test Generator
 * Description : Test class used for testing the TaskTrigger
 * Date : 9/16/14 2:31 PM 
 * Version : <intial Draft> 
 */
@isTest(seeAllData=true)
private class TaskTrigger_Test { 
     static testMethod  void testTaskTrigger(){
        Task taskTest =  new Task();
        insert taskTest;
        update taskTest;
        //delete taskTest;
    }
    static testmethod void autotask(){
   
               
                Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('End-User').getRecordTypeId();
                
                Account acc = new Account(Name = 'test',recordtypeid=devRecordTypeId ,CSCSiteID__c ='5555',CSCID__c = '5555',AddressLine1__c='Test123',AddressLine1_English__c='Test231',AddressLine2__c='Testqa1',AddressLine2_English__c='Testqa123',City__c='UN',City_English__c='Test',State__c= 'AP',State_Province_English__c='ENDTESt',Country__c='INDIA',Country_English__c='INDIA',TOKENID__c='12333',ZipPostalCode__c='847733',Zip_Postal_Code_English__c='766644' );
                insert acc;
 
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
            Map<String,Schema.RecordTypeInfo> OppRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();    
             Id rtId = OppRecordTypeInfo.get('Global Deal/Opportunity').getRecordTypeId();
            //Create new opportunity
            Opportunity oppty = new Opportunity(name='Test', accountId = acc.id,stagename='1 - Prospect', CloseDate=System.today() + 50, Expected_Product__c=10.0,
                                                error_description__c='error', DealID__c='1233',
                                                 Competitors__c = 'A10 Networks'); 
            insert oppty; 
            system.debug('oppty.Opportunity_Status__c@@@>'+oppty.Opportunity_Status__c);
            system.debug('oppty.stagename@@@>>' + oppty.stagename);
            oppty.stagename='5 - Closed Won';
           oppty.Opportunity_Status__c ='Booked';
           update oppty;
            system.debug('oppty.Opportunity_Status__c>>'+oppty.Opportunity_Status__c);
            system.debug('oppty.stagename>>' + oppty.stagename);
           List<Task> Tasklist = new List<Task>(); 
        Task taskTest =  new Task();
        taskTest.WhatId=oppty.id;
        taskTest.Subject = 'Keep Customer Warm for Deal ID ::';
        taskTest.Category_Type__c='Follow Up Engagement';
         taskTest.Theater__c='EMEAR';
         taskTest.ActivityDate=Date.Today()+90;
        insert taskTest;
        
        
         Tasklist.add(taskTest); 
         Test.StartTest();
         TaskHandler t1 = new TaskHandler();
         t1.autoTaskCreation(Tasklist);
         Test.StopTest();
        }
    
}