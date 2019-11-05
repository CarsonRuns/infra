@isTest(seeAllData=true)
private class NGCC_ScheduledLeadContactInfo_Test  
{
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    static testmethod void test() 
    {
        // Fetch profile (Cisco_NGCC) Id using below code.
        Profile p = new Profile();
        p=[select Id,Name from Profile where Name=:'Cisco_NGCC'];
        // create the user with the above collected profile.
        User u = new User();
        u.FirstName='Test First';
        u.LastName='Test Last';
        u.Alias='Tes';
        u.Email='bsrigadd@cisco.com';
        u.UserName='test123@prudential.com';
        u.CommunityNickname='TestF';
        //u.UserRoleid = r.id ;
        u.Profileid=p.Id;
        u.EmailEncodingKey='UTF-8';     
        //u.Prudential_User_ID__c='X187665';
        u.TimeZoneSidKey='America/Los_Angeles';
        u.LocaleSidKey='en_US';
        u.LanguageLocaleKey='en_US';
        u.Theatre__c ='Americas-LATAM';
        insert u;
        
        Account a = new Account();
        a.Name='TestAccount';
        a.AddressLine1__c='Test';
        a.Country__c='UNITED STATES';
        a.City__c='San Jose';
        a.RecordTypeId = '0123000000004aU';
        insert a;
        contact c = new contact();
        c.Lastname='Testlastname';
        c.AccountId=a.Id;
        
        insert c;
        
        // Fetching Record type  (Prospect)
        RecordType r = new RecordType();
        r=[select Id,Name,SobjectType from RecordType where Name='Prospect' and SobjectType='Lead'];
      
        list<Lead> leads = new list<Lead>();
        for(Integer i=0;i<180;i++)
        {
            Lead l = new Lead(OwnerId=u.Id,LastName='Srigadde', Lead_Contact__c= c.Id, RecordTypeId=r.Id, Status='1 Waiting', Company='TestCompany1');
            leads.add(l);
        }
        
       // Profile pr = [SELECT Id FROM Profile WHERE Name='Cisco_NGCC'];
       // User u1 = new User();
        //u1=[select Id,isActive,ProfileId from User where ProfileId=: pr.Id and isActive = true Limit 1];
        
        //System.runAs(u1){
        insert leads;
        //update leads;
        //}

        
        
        Test.startTest();
        String jobId = System.schedule('ScheduleApexClassTest',CRON_EXP,new NGCC_ScheduledLeadContactInfo());
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];
         // Verify the expressions are the same
         System.assertEquals(CRON_EXP, ct.CronExpression);
         // Verify the job has not run 
         System.assertEquals(0, ct.TimesTriggered);
         // Verify the next time the job will run 
         System.assertEquals('2022-03-15 00:00:00', String.valueOf(ct.NextFireTime));
         NGCC_UpdateLeadContactInfo N = new NGCC_UpdateLeadContactInfo();
         ID batchprocessid = Database.executeBatch(N);
         
    }    
}