@isTest (SeeAllData = true)
private class CsOptyUtill_Test{
    private static testMethod void testMthod(){
        Account a = new Account(name='TestVC',RecordtypeId = '0123000000004aU');
        insert a;
        Date d = System.Today();
        Opportunity op = new Opportunity(Name='test' , accountid=a.Id, StageName= '1 - Prospect', CloseDate=d);
        insert op;
        Opportunity op1 = new Opportunity(Name='test2' , accountid=a.Id, StageName= '1 - Prospect', CloseDate=d);
        insert op1;
        AT_Workspace__c ws = new AT_Workspace__c(Name='test', Opportunity__c = op.id, Is_Multi_Tech__c = true); 
        insert ws;
        Event eventUpdate = new Event();
        eventUpdate.Subject='test';
        eventUpdate.WhatId = op.id;
        eventUpdate.DurationInMinutes = 60;
        eventUpdate.ActivityDateTime = system.now()+2;
        insert eventUpdate;
        Blob b = Blob.valueOf('Test Data');        
        Attachment attachment = new Attachment();
        attachment.ParentId = op.Id;
        attachment.Name = 'Test Attachment for Parent';
        attachment.Body = b;         
        insert(attachment); 
        Task taskRec = new Task();
        taskRec.ActivityDate = Date.today();
        taskRec.Subject = 'Call';
        taskRec.Phone_Number__c = '123456786';        
        taskRec.Type = 'Call';
        taskRec.CallDurationInSeconds = 0;
        taskRec.WhatId = op.id;
        insert taskRec;
               
        CSOptyUtils.createNote('test',op.id,'testt1');
        CSOptyUtils.copyResourceRequestAss(op.id,op1.id);
        CSOptyUtils.copyContactRole(op.id,op1.id);
        CSOptyUtils.copyEvent(op.id,op1.id);
        CSOptyUtils.copyTask(op.id,op1.id);
        CSOptyUtils.copyNote(op.id,op1.id);
        CSOptyUtils.copyATWorkspace(op.id,op1.id);
        CSOptyUtils.copyAttachments(op.id,op1.id);
        CSOptyUtils.getTerrIdByPostn('postman'); 
        CSOptyUtils.copySE(op.id,op1.id);     
    }
}