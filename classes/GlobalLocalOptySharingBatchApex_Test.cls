@isTest 
private Class GlobalLocalOptySharingBatchApex_Test
{
    static testMethod void MyTestMethod() 
    {  
            Profile p = [SELECT Id FROM Profile WHERE Name = 'Cisco_GSTS' Limit 1];
            User uAdmin = new User(Additional_User_Permissions__c = 'SE User', Alias = 'newUser', Email = 'batchJobOppty@cisco.com',
                                   EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                                   LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'batchJobOppty@cisco.com.testing', Theatre__c = 'Americas-US Commercial');                  
                                   insert uAdmin;
            ProfileID__c profileIds = new ProfileID__c();
            profileIds.Cisco_Renewals__c = '00e34000001CQnp';
            profileIds.Cisco_PSS__c = '00e30000000rrZw';
            insert profileIds;  
           
            List < sObject > osData = Test.loadData(Org_Constant_CS__c.sObjectType,'OrgConstantCS_data');
            List < sObject > osCSData = Test.loadData(Org_Constants__c.sObjectType,'OrgConstants');        
            List < sObject > objRecTypeData = Test.loadData(ObjectRecordTypeIds__c.sObjectType,'ObjectRecordTypeIds');
            List < sObject > apexBatchJob = Test.loadData(Apex_Batch_Job__c.sObjectType,'GlobalLocalOptyBatchJob');
            Id t = [Select Id from territory2 where Level_3_Territory__c='EMEAR-UKI' limit 1].id;
            Account a =  new Account(Name='AccountTest', RecordTypeId = '0123000000004aU',Account_Status__c='Active');
            insert a;
            List<Account> accList = new List<Account>();
            accList.add(a);
            
           
            ObjectTerritory2Association ota = new ObjectTerritory2Association(ObjectId=accList[0].Id, Territory2Id=t, AssociationCause='Territory2Manual');
            insert ota;     
            Opportunity o = new Opportunity(name ='Test' ,Territory2Id=t, stagename ='1 - Prospect',closedate = system.today(),OwnerId = uAdmin.id,Description ='Test',accountId = a.id);
            insert o; 
            Opportunity o1 = new Opportunity(name ='Test' ,Territory2Id=t,Global_Opportunity__c =o.Id , stagename ='1 - Prospect',closedate = system.today(), Description ='Test',RecordTypeId=Utilities.getOpptyParentRecordTypeId(),OwnerId=UserInfo.getuserId(),accountId = a.id);
            insert o1; 
            List<OpportunityShare> oppList = new List<OpportunityShare>();
            OpportunityShare oS = new OpportunityShare(OpportunityId = o1.Id,OpportunityAccessLevel ='read',UserOrGroupId=uAdmin.Id);
            insert oS;
            List<OpportunityShare> shares = [select id from OpportunityShare where OpportunityId =: o.Id];
            
            Test.startTest();
            String query1 = 'select ownerid ,Global_Opportunity__c from Opportunity where Id =\'' + o1.Id + '\'';
            GlobalLocalOptySharingBatchApex load = new GlobalLocalOptySharingBatchApex(query1);
            String sch = '0 0 8 13 2 ?';
            GlobalLocalOptySharingScheduleBatchApex gl = new GlobalLocalOptySharingScheduleBatchApex();
            gl.query =query1;
            String jobIds = System.schedule('testBasicScheduledApex',sch,gl);
            ID JobId = Database.executeBatch(load,200);  
            Test.stopTest();
    }
}