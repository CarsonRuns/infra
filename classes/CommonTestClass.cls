@isTest
/*Common Test class*/
//3 Feb 2012
private class CommonTestClass
 {  
 
 /*****************************Test Method for the Class CSContact**************************************/
    static testMethod void test_CSContact()
    {
        test.startTest();
        ProfileID__c profileIds = new ProfileID__c();
         profileIds.Cisco_Renewals__c = '00e34000001CQnp';
         profileIds.Cisco_PSS__c = '00e30000000rrZw';
         insert profileIds;
         ObjectRecordTypeIds__c testId  = new ObjectRecordTypeIds__c();
         testId.Opportunity_Global_RecordTypeId__c ='01234000000M5rI';
         testId.Oppty_Renewal_RecordTypeId_18__c='01234000000Boc4AAC';
         insert testId;
         Org_Constants__c  orgC = new Org_Constants__c();
         orgC.Key__c = 'Oppty: ProfileIds to skip Triggers';
         orgC.prod_value__c = 'For testing';
         orgC.Type__c = 'URL';
         insert orgC; 
         
        Deal_ID_Queue__c dealId=new Deal_ID_Queue__c(Name='Deal ID Queue 1',Deal_ID_Queue_Start__c=16040000,Deal_ID_Queue_Stop__c=21040000);
        insert dealId;
        Deal_ID_Thresholds__c dealThreshold=new Deal_ID_Thresholds__c(Name='Deal ID Queue Thresholds 1',Seventy_Percent_Email__c=true,Seventy_Percent_Email_Date__c=System.today());  
        insert dealThreshold;
        Account a = new Account(name='TestAccount',Account_Status__c='Active');
        Insert a;
        Contact c = new Contact(firstname='firstname',lastname='lastname',AccountId=a.Id,Email='firstname@xyz.com');
        Insert c;
        
        Opportunity o = new Opportunity(accountId=a.Id, name='abc', StageName='2 - Qualification',Partner_Expected_Book_Date__c = System.today().adddays(2), CloseDate= System.today().adddays(10),Public_Sector_Funding__c='Economic Stimulus Program');
        insert o;
         
        String opptyId = o.Id+'';
        String Alias = 'oAlias';
        String orderBy = 'firstname';
        String ascDesc = 'ASC';
        CSContact.searchByOpty(opptyId, c.firstname, c.lastname, c.Email,Alias, orderBy, ascDesc);
        CSContact.cdata('');
        CSContact.cdata('test'); 
        CSContact.oCreateXML('testCECId',opptyId,'Active','Test Error Message',c.Id+''); 
        CSContact.create(opptyId,'testCECId',c.firstname,c.lastname,c.Email);
        User u = new User(UserName = 'cam_unallocated',IsActive=true,firstname='firstname',lastname='testContact');
        CSContact.create(opptyId,u.UserName,c.firstname,c.lastname,c.Email);
        CSContact.createPtnrCt(opptyId, u.UserName, a.Id+'', c.firstname+' '+c.lastname, '', 'zzasasaki1', '', '', c.Email, '1397727', '', '', '');
        CSContact.createPtnrCt(opptyId, u.UserName, a.Id+'', c.firstname+' '+c.lastname, '', 'zzasasaki1', '', '', c.Email, 'abcdxyz', '', '', '');
        test.stopTest();
   }


   /********************************Test Method for the Class DuplicateLineSearch_CT*********************************/
    public static testMethod void test_DuplicateLineSearch_CT()
    {
        test.startTest(); 
        String OpptyId = 'CF00N30000';
        PageReference pageRef = new DuplicateLineSearch_CT().getDl();
        test.stopTest();
    }

    /*******************************Test Method for the Class OpptyReferencePrompt_CT*******************************/
  /*  public static testMethod void test_OpptyReferencePrompt_CT()
    {
        test.startTest();
        Account a = new Account(name='TestAccount',Partner_Account_Status__c='Active (Registered)',recordTypeId=Utilities.getAccountChannelRecordTypeId());
        Insert a;
        Opportunity o = new Opportunity(name='abc', StageName='2 - Qualification',Partner_Expected_Book_Date__c = System.today().adddays(2), CloseDate= System.today().adddays(10),Public_Sector_Funding__c='Economic Stimulus Program');
        insert o;
        AT_Workspace__c temp = new AT_Workspace__c(Name='test',AT_Flags__c='Franchise Win',Opportunity__c = o.ID,Sync_With_Opportunity__c=TRUE,AT_Forecast_Status__c='Upside',AT_Expected_Product__c = 1,AT_Expected_Book_Date__c = System.Today(),AT_Team__c = 'Cisco1',Forecast_Position_ID__c = '123',AT_Technology__c ='Optical',AT_Sub_Technology__c = 'Optical Router',AT_Product__c ='Optical DPT/RPR Modules');
        insert temp;
        Apexpages.currentPage().getParameters().put('opptyId',o.ID);
        Apexpages.currentPage().getParameters().put('acct',a.name);
        Apexpages.currentPage().getParameters().put('bookDate',o.Partner_Expected_Book_Date__c.format());
        PageReference pageRef = new OpptyReferencePrompt_CT().yes();
        PageReference pageRef1 = new OpptyReferencePrompt_CT().no();
        test.stopTest();
    }
*/
    /*****************************Test Method for the Class QuoteOverview*******************************/
    public static testMethod void test_QuoteOverview()
    {
        test.startTest(); 
         ProfileID__c profileIds = new ProfileID__c();
         profileIds.Cisco_Renewals__c = '00e34000001CQnp';
         profileIds.Cisco_PSS__c = '00e30000000rrZw';
         insert profileIds;
         ObjectRecordTypeIds__c testId  = new ObjectRecordTypeIds__c();
         testId.Opportunity_Global_RecordTypeId__c ='01234000000M5rI';
         testId.Oppty_Renewal_RecordTypeId_18__c='01234000000Boc4AAC';
         insert testId;
         Org_Constants__c  orgC = new Org_Constants__c();
         orgC.Key__c = 'Oppty: ProfileIds to skip Triggers';
         orgC.prod_value__c = 'For testing';
         orgC.Type__c = 'URL';
         insert orgC;
        Opportunity o = new Opportunity(name='TestQuoteOverview',Competitors__c='Avaya',StageName='2 - Qualified',CloseDate=System.today().adddays(10),Expected_Product__c=10.0,error_description__c='error',DealID__c='1',Opportunity_Status__c='Active',Deal_Type__c=5); 
        insert o;
        ApexPages.StandardController controller = new ApexPages.StandardController(o);
        Apexpages.currentPage().getParameters().put('id',o.ID);
        QuoteOverview qo = new QuoteOverview(controller);
        String archive = qo.getIsArchived();
        string oppids = qo.getOpptyID();
        string qstatus = qo.getQuoteStatus();
        PageReference pr = qo.getredir();
        test.stopTest();
    }
    
    /********************************Test Method for the Class TaskResource*********************************/
    public static testMethod void test_TaskResource()
    {
        test.startTest(); 
        TaskResource.doGet(new RestRequest(),new RestResponse());
        Task tk = new Task(subject='Get tech specs', status='Not Started', priority='Normal', description='Get tech specifications from IT');
        insert tk;
        TaskResource.doPost(new RestRequest(),new RestResponse(), tk.Id, tk.subject, tk.status, tk.priority, tk.description);
        test.stopTest();
    }
    
    /********************************Test Method for the Class OpportunityResource*********************************/
    public static testMethod void test_OpportunityResource()
    {
        test.startTest(); 
          ProfileID__c profileIds = new ProfileID__c();
         profileIds.Cisco_Renewals__c = '00e34000001CQnp';
         profileIds.Cisco_PSS__c = '00e30000000rrZw';
         insert profileIds;
         ObjectRecordTypeIds__c testId  = new ObjectRecordTypeIds__c();
         testId.Opportunity_Global_RecordTypeId__c ='01234000000M5rI';
         testId.Oppty_Renewal_RecordTypeId_18__c='01234000000Boc4AAC';
         testId.Account_End_User_RecordTypeId__c='0123000000004aU';
         insert testId;
         Org_Constants__c  orgC = new Org_Constants__c();
         orgC.Key__c = 'Oppty: ProfileIds to skip Triggers';
         orgC.prod_value__c = 'For testing';
         orgC.Type__c = 'URL';
         insert orgC; 
         
         Deal_ID_Queue__c dealId=new Deal_ID_Queue__c(Name='Deal ID Queue 1',Deal_ID_Queue_Start__c=16040000,Deal_ID_Queue_Stop__c=21040000);
         insert dealId;
         Deal_ID_Thresholds__c dealThreshold=new Deal_ID_Thresholds__c(Name='Deal ID Queue Thresholds 1',Seventy_Percent_Email__c=true,Seventy_Percent_Email_Date__c=System.today());  
         insert dealThreshold;
        
        
      Account newaccount = new Account();
        newaccount.name = '佳和實業股份有限公司';
        newaccount.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('End-User').getRecordTypeId(); 
        newaccount.AccountNameEnglish__c = 'Chia her industrial co. , ltd.';
        newaccount.Website = 'http://www.chiaher.com.tw/';
        newaccount.Phone = '06-5991911';
        newaccount.Industry = 'RETAIL- Other';
        newaccount.VMTOP__c = 'Manufacturing';
        newaccount.VMSUB__c = 'Consumer Products Manufacturing';
        newaccount.VMDTL__c = 'Textiles';
        newaccount.OE_Id__c = '3008263855';
        insert newaccount ;  
        
        
        String name = 'Campus and subsidiary upgrade - REMOTE';
        Date closeDate = System.today().adddays(10);
        String fPostn = 'TAIWAN _AREA Dummy Territory'; 
        String accountId = ''+newaccount.id;
        OpportunityResource.getPageSetupInfo();
        OpportunityResource.getAccountInfo(newaccount.name);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        OpportunityResource.doPost(req, res, name, closeDate, fPostn, accountId);
        req.requestURI = 'https://login.salesforce.com/services/apexrest/v.9/results/today';  
        req.httpMethod = 'GET';
        String result = OpportunityResource.doGet(req, res);
        req.requestURI = 'https://login.salesforce.com/services/apexrest/v.9/results/pageSetup';  
        String result11 = OpportunityResource.doGet(req, res);

        test.stopTest();
    }
    
    /********************************Test Method for the Class OpptyCreateDemoLoanOrderCTE and Trigger NoEPSSOpptyOwner trigger*********************************/
    public static testMethod void test_OpptyCreateDemoLoanOrderCTE()
    {    
        
        Opportunity o = null;
        test.startTest();
        User CurrentUser = new User(alias = 'testd1',email='testdemoloan2@cisco.com',emailencodingkey='UTF-8', lastname='Testing',languagelocalekey='en_US',Additional_User_Permissions__c='Enable_ePSS',localesidkey='en_US', profileid = '00e30000000r9aVAAQ',timezonesidkey='America/Los_Angeles',Theatre__c='Global Service Provider', username='testdemoloan2@cisco.com');
        insert CurrentUser; 
        //User CurrentUser= [select id from User where profileid=:Utilities.getPSSProfileId() and isactive=true limit 1];
        //Opportunity opptyOwner= [SELECT Id, OwnerId FROM Opportunity limit 1];
        User opptyOwner = [SELECT id FROM User WHERE username LIKE 'sfdc_apex_user@cisco.com%'];
        System.runAs(CurrentUser)
        {
            Org_Constants__c org = new Org_Constants__c();         
            org.key__c='Oppty: ProfileIds to skip Triggers';
            org.non_prod_value__c='00e30000000dcbfAAA';
            org.prod_value__c='00e30000000dcbfAAA';
            org.Type__c='URL';
            org.Prod_LT__c='GSTS,Data_Migration,Integration_Echo_Suppression';
            insert org;   
            ObjectRecordTypeIds__c objrecType = new ObjectRecordTypeIds__c();
            objrecType.Opportunity_Global_RecordTypeId__c ='01234000000M5rI';
            objrecType.Oppty_Renewal_RecordTypeId_18__c= '01234000000Boc4AAC';
            insert objrecType;
            profileID__c profileIds = new ProfileID__c();
            profileIds.Cisco_Renewals__c = '00e34000001CQnp';
            profileIds.Cisco_PSS__c = '00e30000000rrZw';
            insert profileIds;
            o = new Opportunity(name='TestQuoteOverview',StageName='1 - Prospect', CloseDate=System.today().adddays(10),Expected_Product__c=10.0,error_description__c='error',DealID__c='1',Opportunity_Status__c='Active',OwnerId = opptyOwner.Id,Opportunity_Owner_AM__c=opptyOwner.Id); 
            insert o;
            
        }
        //new OpptyCreateDemoLoanOrderCTE(new ApexPages.StandardController(o));            
        test.stopTest();
    }
    
    /********************************Test Method for the Class DuplicateLineBatchKickoff*********************************/
     public static testMethod void test_DuplicateLineBatchKickoff()
    {
        test.startTest(); 
        new DuplicateLineBatchKickoff().execute(null);
        test.stopTest();  
    }    
    
    /********************************Test Method for the Class Competitors_Email_CTC*********************************/
    public static testMethod void test_Competitors_Email_CTC()
    {
        List<Competitors_Email_CTC.Competitor> compList = new List<Competitors_Email_CTC.Competitor>();
        Competitor_Information__c[] ciArray = new Competitor_Information__c[]{}; 
        test.startTest(); 
        For(integer i = 1; i <=5; i++)
        {
            Competitor_Information__c CI = new  Competitor_Information__c(Competitor_Information__c='Competitor_Information_'+i, Name='Competitor_name_'+i);
            ciArray.add(CI);
        }

        insert ciArray;

        Competitors_Email_CTC cEmailCTC = new Competitors_Email_CTC();
        cEmailCTC.EnteredCompetitors = 'Competitor_name_1;Competitor_name_2;Competitor_name_3;Competitor_name_4;Competitor_name_5';
        compList = cEmailCTC.getCompetitors();
        test.stopTest();   
    } 
    
    /********************************Test Method for the class OpptyOwnerScheduleBatchApex*********************************/    
    static testMethod void OpptyOwnerScheduleBatchApexTestMethod() 
    {        
       // Account a = [SELECT name, RecordtypeId  FROM account where RecordTypeId = '0123000000004aUAAQ' limit 1 ];
        ObjectRecordTypeIds__c testOpty = new ObjectRecordTypeIds__c();
        testOpty.AccountChannelRecordTypeId__c = '0123000000004aV';
        insert testOpty;
         
        ProfileID__c profileIds = new ProfileID__c();
        profileIds.Cisco_Renewals__c = '00e34000001CQnp';
        profileIds.Cisco_PSS__c = '00e30000000rrZw';
        insert profileIds;
        
        Org_Constants__c  orgC = new Org_Constants__c();
        orgC.Key__c = 'Oppty: ProfileIds to skip Triggers';
        orgC.prod_value__c = 'For testing';
        orgC.Type__c = 'URL';
        insert orgC;
        
        Deal_ID_Queue__c dealId=new Deal_ID_Queue__c(Name='Deal ID Queue 1',Deal_ID_Queue_Start__c=16040000,Deal_ID_Queue_Stop__c=21040000);
        insert dealId; 
        Deal_ID_Thresholds__c dealThreshold=new Deal_ID_Thresholds__c(Name='Deal ID Queue Thresholds 1',Seventy_Percent_Email__c=true,Seventy_Percent_Email_Date__c=System.today());  
        insert dealThreshold;
        Account a  = GenericStaticTestData.getTestEndUserAccountRecordGreen();
        Opportunity o = new Opportunity(name ='Test' , accountId = a.Id,stagename ='1 - Prospect',closedate = System.today().adddays(10));
        insert o; 
        
         
        Test.startTest();
        
    String CRON_EXP = '0 0 0 15 3 ? *';
    Apex_Batch_Job__c apx=new Apex_Batch_Job__c(name='OpptyOwnerSync',query__c='select ownerid ,Opportunity_Owner_AM__c,Id from Opportunity where lastmodifieddate = YESTERDAY',NotificationEmailId__c='sfdc-integration-apex-exceptions@external.cisco.com');
    insert apx;
    String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, new OpptyOwnerScheduleBatchApex ());
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
     }
    // As part of code cleanup, commenting the "Calculate_AccountPotentialDollarTestMethod" method. Modified By : P R N Swamy 
    /********************************Test Method for the trigger Calculate_AccountPotentialDollar*********************************/    
    /*
    static testMethod void Calculate_AccountPotentialDollarTestMethod() 
    {        
        Test.startTest();
       // Vertical_Per_Head__c v = [SELECT Id, Industry__c, Vertical_Per_Head_Austria__c FROM Vertical_Per_Head__c where Id != null and  Industry__c != null limit 1];
        Vertical_Per_Head__c v = new Vertical_Per_Head__c();
        v.Industry__c = 'RETAIL- Other';
        v.Vertical_Per_Head_Austria__c = 317;
        insert v;
        
        string I = v.Industry__c; // assign Industry of Vertical per head to string
        //Account A = [SELECT id FROM account WHERE Country__c!=null AND NumberOfEmployees != null AND Industry != null limit 1]   ;
        Account A  = GenericStaticTestData.getTestEndUserAccountRecordGreen();
        A.Country__c = 'India';
        A.NumberOfEmployees = 10;
        //AIndustry != null;
        A.Industry = I; // assign Vertical per head industry to Account's industry
        update A; 
        Test.stopTest();    
    }
    */
      /*****************************Test Method for the Class OpportunityHandler**************************************/
    static testMethod void test_OpportunityHandlerSolutionID()
    {
        test.startTest(); 
          ProfileID__c profileIds = new ProfileID__c();
         profileIds.Cisco_Renewals__c = '00e34000001CQnp';
         profileIds.Cisco_PSS__c = '00e30000000rrZw';
         insert profileIds;
         ObjectRecordTypeIds__c testId  = new ObjectRecordTypeIds__c();
         testId.Opportunity_Global_RecordTypeId__c ='01234000000M5rI';
         testId.Oppty_Renewal_RecordTypeId_18__c='01234000000Boc4AAC';
         testId.Account_End_User_RecordTypeId__c='0123000000004aU';
         insert testId;
         Org_Constants__c  orgC = new Org_Constants__c();
         orgC.Key__c = 'Oppty: ProfileIds to skip Triggers';
         orgC.prod_value__c = 'For testing';
         orgC.Type__c = 'URL';
         insert orgC; 
          Deal_ID_Queue__c dealId=new Deal_ID_Queue__c(Name='Deal ID Queue 1',Deal_ID_Queue_Start__c=16040000,Deal_ID_Queue_Stop__c=21040000);
         insert dealId;
         Deal_ID_Thresholds__c dealThreshold=new Deal_ID_Thresholds__c(Name='Deal ID Queue Thresholds 1',Seventy_Percent_Email__c=true,Seventy_Percent_Email_Date__c=System.today());  
        insert dealThreshold;
        Account acc = new Account(name='TestAccount',Account_Status__c='Active');
        Insert acc;
        Opportunity opp = new Opportunity(accountId=acc.Id, name='abc', StageName='2 - Qualification',Partner_Expected_Book_Date__c = System.today().adddays(2), CloseDate= System.today().adddays(10),Public_Sector_Funding__c='Economic Stimulus Program', Solution_Identifier__c='Branch-In-A-Box');
        insert opp;
        
        opp.Solution_Identifier__c = 'Connected Assets';
        update opp;
        
        test.stopTest();
   }
   
   static testMethod void OpportunityTriggerIMPL_Test()
   {
       String parentMobileRecTypeId; 
    String parentRecTypeId; 
    String runningUserTheater;
       Opportunity o = null;
        test.startTest();
            OpportunityTriggerImpl t1 = new OpportunityTriggerImpl();
            t1.afterInit();
            t1.executeBeforeDelete();
            t1.executeAfterDelete();
            t1.executeUnDelete();    
       Profile p = [SELECT Id FROM Profile WHERE Name = 'Cisco_Admin' Limit 1];
        User admUser = new User(Additional_User_Permissions__c = 'Enable EndUser ACCTCreation', Alias = 'newUser', Email = 'batchJobOppty@cisco.com',
                               EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                               LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'batchJobOppty@cisco.com.testing', Theatre__c = 'Americas-US Commercial');
        insert admUser; 
        User opptyOwner = [SELECT id FROM User WHERE username LIKE 'sfdc_apex_user@cisco.com%'];
        System.runAs(admUser)
        {   
        Org_Constants__c org = new Org_Constants__c();         
            org.key__c='Oppty: ProfileIds to skip Triggers';
            org.non_prod_value__c='00e30000000dcbfAAA';
            org.prod_value__c='00e30000000dcbfAAA';
            org.Type__c='URL';
            org.Prod_LT__c='GSTS,Data_Migration,Integration_Echo_Suppression';
            insert org;   
            ObjectRecordTypeIds__c objrecType = new ObjectRecordTypeIds__c();
            objrecType.Opportunity_Global_RecordTypeId__c ='01234000000M5rI';
            objrecType.Oppty_Renewal_RecordTypeId_18__c= '01234000000Boc4AAC';
            insert objrecType;
            profileID__c profileIds = new ProfileID__c();
            profileIds.Cisco_Renewals__c = '00e34000001CQnp';
            profileIds.Cisco_PSS__c = '00e30000000rrZw';
            insert profileIds;
             objectRecordTypeIds__c obRcs = new ObjectRecordTypeIds__c(SetupOwnerId=UserInfo.getuserid());
        obRcs.Opportunity_Parent_RecordTypeId__c= String.Valueof(Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('Global Deal/Opportunity').getRecordTypeId()).substring(0,15);
        insert obRcs;
     
        system.debug('obRcs.Opportunity_Parent_RecordTypeId__c:'+obRcs.Opportunity_Parent_RecordTypeId__c);
        
            o = new Opportunity(name='TestQuoteOverview',Position__c ='test main',StageName='1 - Prospect',CloseDate=System.today().adddays(10),Expected_Product__c=10.0,error_description__c='error',DealID__c='1',Opportunity_Status__c='Active',OwnerId = opptyOwner.Id,Opportunity_Owner_AM__c=opptyOwner.Id,RecordTypeId=Id.Valueof(String.Valueof(Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('Global Deal/Opportunity').getRecordTypeId()).substring(0,15))); 
            insert o;
            system.debug('o.recordtypeid:'+o.recordtypeid);
            system.debug('o.recordtype.name:'+o.recordtype.name);
            system.debug('o.ownerid:'+o.ownerid);
        }
         Opportunity   phaseOpty = new Opportunity(name='TestQuoteOverview',StageName='1 - Prospect',CloseDate=System.today().adddays(10),Expected_Product__c=10.0,error_description__c='error',DealID__c='1',Opportunity_Status__c='Active',OwnerId = opptyOwner.Id,Opportunity_Owner_AM__c=opptyOwner.Id,Parent_Id__c=o.id,Position__c = o.id); 
            insert phaseOpty;
          system.debug('phaseOpty.recordtypeid:'+o.recordtypeid);
            system.debug('phaseOpty.recordtype.name:'+o.recordtype.name);
            system.debug('phaseOpty.ownerid:'+phaseOpty.ownerid);   
        o.OwnerId= Userinfo.getUserId();
        Update o; 
        system.debug('$$o.ownerid:'+o.ownerid);
        test.stopTest();
   }
  
}