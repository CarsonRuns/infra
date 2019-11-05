@isTest
private class SO_ForwardRecordtoConnection_Test {

    public static testMethod void testDataToLoad(){
        //Load Org_Constant_CS__c custom settings records from static resource
        List<sObject> lsOrgConstantCs = Test.loadData(Org_Constant_CS__c.sObjectType, 'TestOrgConstantCS');
        List<sObject> lsOrgConstants = Test.loadData(Org_Constants__c.sObjectType, 'OrgConstants');
        //List<sObject> lsOrgApexBatchJob = Test.loadData(Apex_Batch_Job__c.sObjectType, 'TestApexBatchJob');
        insert new ObjectRecordTypeIds__c(Opportunity_Parent_Mobile_RecordTypeId__c ='0123000000003yk', Opportunity_Void_Merged_RecordTypeId__c = '012800000002e0M');
        insert new Apex_Batch_Job__c(name='StoS1OptyQuery',TimeStamp__c=Date.Today()-5);        
        insert new Apex_Batch_Job__c(name='closedate',Date_TimeStamp__c=Date.Today()-5);        
       
        //load custom settings
        User u = new User(Id = UserInfo.getUserId());
        
         Org_Constant_CS__c opptyOwner1 = new Org_Constant_CS__c();
        opptyOwner1.name = 'Test1';
        opptyOwner1.Production_Value__c = '00e340000015SW4';
        opptyOwner1.Non_Production_Value__c = '00e340000015SW4';
        insert opptyOwner1 ;
        String myCCInst  =opptyOwner1.Non_Production_Value__c;

        List<Profile> pList = [SELECT Id FROM Profile WHERE id =:myCCInst  ORDER BY Name ASC limit 2];
        List<User> users = new List<User>();

        User admUser = new User();
        admUser.Alias = 'testusr3';
        admUser.Email = 'testusr3@cisco.com.test';
        admUser.EmailEncodingKey = 'UTF-8';
        admUser.LastName = 'Test3';
        admUser.FirstName = 'cecid';
        admUser.Organization__c = 'Test3';
        admUser.LanguageLocaleKey = 'en_US';
        admUser.LocaleSidKey = 'en_US';
        admUser.ProfileId = pList[0].Id;
        admUser.CommunityNickname = 'testusr3';
        admUser.TimeZoneSidKey = 'America/Los_Angeles';
        admUser.UserName = 'testusr3@cisco.com.test';
        admUser.Theatre__c = 'Americas-Canada';
        
        User stdUser1 = new User();
        stdUser1.Alias = 'testusr1';
        stdUser1.Email = 'testusr1@cisco.com.test';
        stdUser1.EmailEncodingKey = 'UTF-8';
        stdUser1.LastName = 'Test1';
        stdUser1.FirstName = 'cecid';
        stdUser1.Organization__c = 'Test1';
        stdUser1.LanguageLocaleKey = 'en_US';
        stdUser1.LocaleSidKey = 'en_US';
        stdUser1.ProfileId = pList[0].Id;
        stdUser1.CommunityNickname = 'testusr1';
        stdUser1.TimeZoneSidKey = 'America/Los_Angeles';
        stdUser1.UserName = 'testusr1@cisco.com.test';
        stdUser1.Theatre__c = 'Americas-Canada';
        
        User stdUser2 = new User();
        stdUser2.Alias = 'testusr2';
        stdUser2.Email = 'testusr2@cisco.com.test';
        stdUser2.EmailEncodingKey = 'UTF-8';
        stdUser2.LastName = 'Test2';
        stdUser2.FirstName = 'cecid';
        stdUser2.Organization__c = 'Test2';
        stdUser2.LanguageLocaleKey = 'en_US';
        stdUser2.LocaleSidKey = 'en_US';
        stdUser2.ProfileId = pList[0].Id;
        stdUser2.CommunityNickname = 'testusr2';
        stdUser2.TimeZoneSidKey = 'America/Los_Angeles';
        stdUser2.UserName = 'testusr2@cisco.com.test';
        stdUser2.Theatre__c = 'Americas-Canada';
        
        users.add(admUser);
        users.add(stdUser1);
        users.add(stdUser2);
        System.runAs (u) {
            List<Org_Constant_CS__c> orgConstant = new List<Org_Constant_CS__c>();
            orgConstant.add(new Org_Constant_CS__c(Name='Support Profiles',Non_Production_Value__c='00e30000000dcbfAAA,00e30000000dfUEAAY,00e30000000eca0AAA,00e30000000qiJjAAI,00e30000000dcbgAAA,00e30000000r9dqAAA',Production_Value__c='00e30000000dcbfAAA,00e30000000dfUEAAY,00e30000000eca0AAA,00e30000000qiJjAAI,00e30000000dcbgAAA,00e30000000r9dqAAA'));
            insert orgConstant;
            insert users;
            //added by Kavya
            Profile pList1 = [SELECT Id FROM Profile WHERE Name ='Cisco_Renewals' limit 1];
        	Profile pList2 = [SELECT Id FROM Profile WHERE Name ='zzDont_USE_Cisco_PSS' limit 1];
            ProfileID__c pf = new ProfileID__c();
            pf.Cisco_Renewals__c = String.valueOf(pList1.Id).substring(0, 15);
            pf.Cisco_PSS__c = String.valueOf(pList2.Id).substring(0, 15);    
            insert pf;
            //ends here  
        }
         Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
         insert customPB;
         
        Product2 prod = new Product2(Name = 'AS-S-ANALYTICS SVCS', Business_Entity__c = 'AS-S', Family = 'Hardware',isActive=true,ProductCode='Service');
        insert prod;
        
        PricebookEntry pbID = new PricebookEntry(
        Pricebook2Id = customPB.Id, Product2Id = prod.Id,
        UnitPrice = 12000, IsActive = true);
        insert pbID;
        
        Opportunity newOpportunity = new Opportunity(
            dealid__c                            = 'A111',
            Name                                 = 'Test111',
            StageName                            = '2 - Qualification',
            CloseDate                            = system.today().adddays(2),
            CurrencyIsoCode                      = 'USD',
            expected_product__c                  = 0,
            expected_service__c                  = 10,
            forecast_status__c                   = 'Commit',
            Non_Standard_Terms_and_Conditions__c = 'None',
            recordtypeid                         = '0123000000003ykAAA',
            Service_Source__c                    = 'New',
            ownerId                              = stdUser1.Id,
            Opportunity_Owner_AM__c              = stdUser1.Id,
            Close_Probability__c                 = 75
        );
        insert newOpportunity;
        
         Opportunity newOpportunity1 = new Opportunity(
            dealid__c                            = 'A111',
            Name                                 = 'Test111',
            StageName                            = '2 - Qualification',
            CloseDate                            = system.today().adddays(2),
            CurrencyIsoCode                      = 'USD',
            expected_product__c                  = 0,
            expected_service__c                  = 10,
            forecast_status__c                   = 'Commit',
            Non_Standard_Terms_and_Conditions__c = 'None',
            recordtypeid                         = '0123000000003ykAAA',
            Service_Source__c                    = 'New',
            ownerId                              = stdUser1.Id,
            Opportunity_Owner_AM__c              = stdUser1.Id,
            Close_Probability__c                 = 75
        );
        insert newOpportunity1;

        AT_Workspace__c newWorkspace = new AT_Workspace__c(
            AT_Technology__c         = 'UC',
            AT_Expected_Product__c   = 1,
            PSS__c                   = UserInfo.getUserId(),
            AT_Expected_Book_Date__c = System.today(),
            AT_Forecast_Status__c    = 'Upside',
            Opportunity__c           = newOpportunity.Id,
            AT_Team__c               = 'test',
            Sync_With_Opportunity__c = true
        );
        
        AT_Workspace__c newWorkspace1 = new AT_Workspace__c(
            AT_Technology__c         = 'UC1',
            AT_Expected_Product__c   = 1,
            PSS__c                   = UserInfo.getUserId(),
            AT_Expected_Book_Date__c = System.today(),
            AT_Forecast_Status__c    = 'Upside',
            Opportunity__c           = newOpportunity.Id,
            AT_Team__c               = 'test1',
            Sync_With_Opportunity__c = false
        );
        insert newWorkspace;
        insert newWorkspace1;
        
        OpportunityLineItem optylneItm = new OpportunityLineItem(
            OpportunityId = newOpportunity.Id,
            Business_Entity__c ='AS-S',
            //ProductCode ='Service',
            Product_Family__c =null,
            PricebookEntryId  = pbID.Id,
            Mix__c=100.0,
            Opportunity_Line_Value__c = 10           
            
        );
        insert optylneItm;
            Test.StartTest();
            
            OpptyShareSOneBatchApex ops = new OpptyShareSOneBatchApex(); 
            Database.executeBatch(ops,2000);  
            set<id> setid = new set<id>();
            setid.add(newOpportunity.Id);             
           // ops.sharedAccOptySet = new Set<Id>{newOpportunity.Id}; 
            try{
            // ops.testMetho();
            ops.shareLinitems(setid); 
            }catch(Exception e){
            }                      
            set<id> setid1 = new set<id>();
            
            setid1.add(newOpportunity.Id);
            try{
            ops.shareWorkspceTech(setid1,'04P4F0000008OIe');
            }catch(Exception e){}
            try{            
            ops.shareRelatedRecordShare(new Set<String>{'A111'},new Set<Id>{newOpportunity.AccountId},new Set<Id>{newOpportunity1.id},new Set<Id>{newOpportunity.Id},new Set<Id>{newOpportunity.AccountId});
              }catch(exception e){
            }   
            
            Test.StopTest();
           
    }
    public static testMethod void testDataToLoad1(){
        //Load Org_Constant_CS__c custom settings records from static resource
        List<sObject> lsOrgConstantCs = Test.loadData(Org_Constant_CS__c.sObjectType, 'TestOrgConstantCS');
        List<sObject> lsOrgConstants = Test.loadData(Org_Constants__c.sObjectType, 'OrgConstants');
        //List<sObject> lsOrgApexBatchJob = Test.loadData(Apex_Batch_Job__c.sObjectType, 'TestApexBatchJob');
        insert new ObjectRecordTypeIds__c(Opportunity_Parent_Mobile_RecordTypeId__c ='0123000000003yk', Opportunity_Void_Merged_RecordTypeId__c = '012800000002e0M');
        insert new Apex_Batch_Job__c(name='StoS1OptyQuery',TimeStamp__c=Date.Today()-5);        
        insert new Apex_Batch_Job__c(name='closedate',Date_TimeStamp__c=Date.Today()-5);        
       
        //load custom settings
        User u = new User(Id = UserInfo.getUserId());
        
        Org_Constant_CS__c opptyOwner1 = new Org_Constant_CS__c();
        opptyOwner1.name = 'Test1';
        opptyOwner1.Production_Value__c = '00e340000015SW4';
        opptyOwner1.Non_Production_Value__c = '00e340000015SW4';
        insert opptyOwner1 ;
        String myCCInst  =opptyOwner1.Non_Production_Value__c;

        List<Profile> pList = [SELECT Id FROM Profile WHERE id = :myCCInst   ORDER BY Name ASC limit 2];
        List<User> users = new List<User>();

        User admUser = new User();
        admUser.Alias = 'testusr3';
        admUser.Email = 'testusr3@cisco.com.test';
        admUser.EmailEncodingKey = 'UTF-8';
        admUser.LastName = 'Test3';
        admUser.FirstName = 'cecid';
        admUser.Organization__c = 'Test3';
        admUser.LanguageLocaleKey = 'en_US';
        admUser.LocaleSidKey = 'en_US';
        admUser.ProfileId = pList[0].Id;
        admUser.CommunityNickname = 'testusr3';
        admUser.TimeZoneSidKey = 'America/Los_Angeles';
        admUser.UserName = 'testusr3@cisco.com.test';
        admUser.Theatre__c = 'Americas-Canada';
        
        User stdUser1 = new User();
        stdUser1.Alias = 'testusr1';
        stdUser1.Email = 'testusr1@cisco.com.test';
        stdUser1.EmailEncodingKey = 'UTF-8';
        stdUser1.LastName = 'Test1';
        stdUser1.FirstName = 'cecid';
        stdUser1.Organization__c = 'Test1';
        stdUser1.LanguageLocaleKey = 'en_US';
        stdUser1.LocaleSidKey = 'en_US';
        stdUser1.ProfileId = pList[0].Id;
        stdUser1.CommunityNickname = 'testusr1';
        stdUser1.TimeZoneSidKey = 'America/Los_Angeles';
        stdUser1.UserName = 'testusr1@cisco.com.test';
        stdUser1.Theatre__c = 'Americas-Canada';
        
        User stdUser2 = new User();
        stdUser2.Alias = 'testusr2';
        stdUser2.Email = 'testusr2@cisco.com.test';
        stdUser2.EmailEncodingKey = 'UTF-8';
        stdUser2.LastName = 'Test2';
        stdUser2.FirstName = 'cecid';
        stdUser2.Organization__c = 'Test2';
        stdUser2.LanguageLocaleKey = 'en_US';
        stdUser2.LocaleSidKey = 'en_US';
        stdUser2.ProfileId = pList[0].Id;
        stdUser2.CommunityNickname = 'testusr2';
        stdUser2.TimeZoneSidKey = 'America/Los_Angeles';
        stdUser2.UserName = 'testusr2@cisco.com.test';
        stdUser2.Theatre__c = 'Americas-Canada';
        
        users.add(admUser);
        users.add(stdUser1);
        users.add(stdUser2);
        System.runAs (u) {
            List<Org_Constant_CS__c> orgConstant = new List<Org_Constant_CS__c>();
            orgConstant.add(new Org_Constant_CS__c(Name='Support Profiles',Non_Production_Value__c='00e30000000dcbfAAA,00e30000000dfUEAAY,00e30000000eca0AAA,00e30000000qiJjAAI,00e30000000dcbgAAA,00e30000000r9dqAAA',Production_Value__c='00e30000000dcbfAAA,00e30000000dfUEAAY,00e30000000eca0AAA,00e30000000qiJjAAI,00e30000000dcbgAAA,00e30000000r9dqAAA'));
            insert orgConstant;
            insert users;
            //added by Kavya
            Profile pList1 = [SELECT Id FROM Profile WHERE Name ='Cisco_Renewals' limit 1];
        	Profile pList2 = [SELECT Id FROM Profile WHERE Name ='zzDont_USE_Cisco_PSS' limit 1];
            ProfileID__c pf = new ProfileID__c();
            pf.Cisco_Renewals__c = String.valueOf(pList1.Id).substring(0, 15);
            pf.Cisco_PSS__c = String.valueOf(pList2.Id).substring(0, 15);    
            insert pf;
            //ends here  
        }
         Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
         insert customPB;
         
        Product2 prod = new Product2(Name = 'AS-S-ANALYTICS SVCS', Business_Entity__c = 'AS-S', Family = 'Hardware',isActive=true,ProductCode='Service');
        insert prod;
        
        PricebookEntry pbID = new PricebookEntry(
        Pricebook2Id = customPB.Id, Product2Id = prod.Id,
        UnitPrice = 12000, IsActive = true);
        insert pbID;
        set<id> lstparent=new set<id>();
        Opportunity newOpportunity = new Opportunity(
            dealid__c                            = 'A111',
            Name                                 = 'Test111',
            StageName                            = '2 - Qualification',
            CloseDate                            = system.today().adddays(2),
            CurrencyIsoCode                      = 'USD',
            expected_product__c                  = 0,
            expected_service__c                  = 10,
            forecast_status__c                   = 'Commit',
            Non_Standard_Terms_and_Conditions__c = 'None',
            recordtypeid                         = '0123000000003ykAAA',
            Service_Source__c                    = 'New',
            ownerId                              = stdUser1.Id,
            Opportunity_Owner_AM__c              = stdUser1.Id,
            Close_Probability__c                 = 75,
            Opportunity_Status__c                = 'Booked'
        );
        insert newOpportunity;
        lstparent.add(newOpportunity.id);
        set<string> lstphase=new set<string>();
        Opportunity newOpportunityPhase = new Opportunity(
            dealid__c                            = 'A111',
            Name                                 = 'testPhase',
            StageName                            = '2 - Qualification',
            CloseDate                            = system.today().adddays(2),
            CurrencyIsoCode                      = 'USD',
            expected_product__c                  = 0,
            expected_service__c                  = 10,
            forecast_status__c                   = 'Commit',
            Non_Standard_Terms_and_Conditions__c = 'None',
            recordtypeid                         = '0128000000020Dq',
            Service_Source__c                    = 'New',
            ownerId                              = stdUser1.Id,
            Opportunity_Owner_AM__c              = stdUser1.Id,
            Close_Probability__c                 = 75,
            Opportunity_Status__c                = 'Booked'
        );
        insert newOpportunityPhase;
        lstphase.add(newOpportunityPhase.id);
        
         Opportunity newOpportunity1 = new Opportunity(
            dealid__c                            = 'A111',
            Name                                 = 'Test111',
            StageName                            = '2 - Qualification',
            CloseDate                            = system.today().adddays(2),
            CurrencyIsoCode                      = 'USD',
            expected_product__c                  = 0,
            expected_service__c                  = 10,
            forecast_status__c                   = 'Commit',
            Non_Standard_Terms_and_Conditions__c = 'None',
            recordtypeid                         = '0123000000003ykAAA',
            Service_Source__c                    = 'New',
            ownerId                              = stdUser1.Id,
            Opportunity_Owner_AM__c              = stdUser1.Id,
            Close_Probability__c                 = 75,
            Opportunity_Status__c                = 'Cancelled'
        );
        insert newOpportunity1;

        AT_Workspace__c newWorkspace = new AT_Workspace__c(
            AT_Technology__c         = 'UC',
            AT_Expected_Product__c   = 1,
            PSS__c                   = UserInfo.getUserId(),
            AT_Expected_Book_Date__c = System.today(),
            AT_Forecast_Status__c    = 'Upside',
            Opportunity__c           = newOpportunity.Id,
            AT_Team__c               = 'test',
            Sync_With_Opportunity__c = true
        );
        
        AT_Workspace__c newWorkspace1 = new AT_Workspace__c(
            AT_Technology__c         = 'UC1',
            AT_Expected_Product__c   = 1,
            PSS__c                   = UserInfo.getUserId(),
            AT_Expected_Book_Date__c = System.today(),
            AT_Forecast_Status__c    = 'Upside',
            Opportunity__c           = newOpportunity.Id,
            AT_Team__c               = 'test1',
            Sync_With_Opportunity__c = false
        );
        insert newWorkspace;
        insert newWorkspace1;
        
        OpportunityLineItem optylneItm = new OpportunityLineItem(
            OpportunityId = newOpportunity.Id,
            Business_Entity__c ='AS-S',
            //ProductCode ='Service',
            Product_Family__c =null,
            PricebookEntryId  = pbID.Id,
            Mix__c=100.0,
            Opportunity_Line_Value__c = 10           
            
        );
        insert optylneItm;
        Test.StartTest();            
        OptyTransferBatch ops = new OptyTransferBatch(); 
        Database.executeBatch(ops,2000);        
       // ops.shareOpportunities(lstphase,lstparent,'04P4F0000008OIo');
        Test.StopTest();
           
    }

    
}