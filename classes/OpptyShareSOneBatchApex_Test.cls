@isTest(seeAllData=True)
private class OpptyShareSOneBatchApex_Test{

    public static testMethod void testDataToLoad(){
        //Load Org_Constant_CS__c custom settings records from static resource
 /*       List<sObject> lsOrgConstantCs = Test.loadData(Org_Constant_CS__c.sObjectType, 'TestOrgConstantCS');
        List<sObject> lsOrgConstants = Test.loadData(Org_Constants__c.sObjectType, 'OrgConstants');
        //List<sObject> lsOrgApexBatchJob = Test.loadData(Apex_Batch_Job__c.sObjectType, 'TestApexBatchJob');
        insert new ObjectRecordTypeIds__c(Opportunity_Parent_Mobile_RecordTypeId__c ='01234000000GGKw', Opportunity_Void_Merged_RecordTypeId__c = '012800000002e0M');
        insert new Apex_Batch_Job__c(name='StoS1OptyQuery',TimeStamp__c=Date.Today()-5);        
       insert new Apex_Batch_Job__c(name='closedate',Date_TimeStamp__c=Date.Today()-5);     
   */         
        string phaseOptyRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Phase Opportunity').getRecordTypeId();
        string partnerPhaseOptyRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Partner Phase Opportunity').getRecordTypeId();
        string parentOptyRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Parent Opportunity').getRecordTypeId();
       
        //load custom settings
        User u = new User(Id = UserInfo.getUserId());

        List<Profile> pList = [SELECT Id FROM Profile WHERE Name = 'Cisco_ADMIN' OR Name = 'Cisco_Japan' ORDER BY Name ASC limit 2];
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
            orgConstant.add(new Org_Constant_CS__c(Name='ServiceOneConnectionID',Non_Production_Value__c='04P0q000000CaSjEAK',Production_Value__c='04P34000000Gn2iEAC'));
   //         insert orgConstant;
            insert users;
        }
         Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
         insert customPB;
         
        Product2 prod = new Product2(Name = 'AS-S-ANALYTICS SVCS', Business_Entity__c = 'AS-S',CurrencyIsoCode='USD', Service_Category__c ='ASS-ADVANCED SERVICES SUBSCRIPTION',isActive=true,ProductCode='Service',Service_Program__c='AS-S-ANALYTICS SVCS',Unique_BE_SubBE__c ='ASS-ADVANCED SERVICES SUBSCRIPTION-AS SUBSCRIPTION-AS-S-ANALYTICS SVCS-Service');
        insert prod;
        
        PricebookEntry pbID = new PricebookEntry(
        Pricebook2Id = customPB.Id, Product2Id = prod.Id,
        UnitPrice = 12000, IsActive = true,
        BE_Sub_BE_Currency_ProductCode__c='AS-S-ANALYTICS SVCS-USD-Service');
        insert pbID;
        
        List<PartnerNetworkConnection> ParNetConn = [SELECT Id FROM PartnerNetworkConnection WHERE ConnectionName = 'Services One' AND ConnectionStatus = 'Accepted'];
        
        List<Account> sharedActSet = [SELECT id, name from Account WHERE id IN(SELECT LocalRecordId FROM PartnerNetworkRecordConnection WHERE ConnectionId = :ParNetConn[0].Id AND Status='Sent') LIMIT 20];
        system.debug('sharedActSet===========>'+sharedActSet);
        List<Opportunity> sharedOptyList = [SELECT id, name, DealId__c from Opportunity WHERE id IN(SELECT LocalRecordId FROM PartnerNetworkRecordConnection WHERE ConnectionId = :ParNetConn[0].Id AND Status='Sent') AND Total_AS_S__c > 0 LIMIT 2];
        system.debug('SharedOptyList===========>'+sharedOptyList );
        
        Account acc =new Account(Name='Acme1', BillingCity='San Francisco');
        system.debug('Account Details:::::::::::::'+acc);
        insert acc;
        
        String accId = null;
          
      if(sharedActSet.size()>0){
         accId = sharedActSet[0].Id;
       }else{
         accId =acc.Id;
       }
       
        Opportunity newOpportunity = new Opportunity(
            dealid__c                            = 'A111',
            Name                                 = 'Test111',
            AccountId                            = acc.Id,
            StageName                            = '2 - Qualification',
            CloseDate                            = system.today().adddays(2),
            CurrencyIsoCode                      = 'USD',
            expected_product__c                  = 0,
            expected_service__c                  = 100,
            forecast_status__c                   = 'Commit',
            Non_Standard_Terms_and_Conditions__c = 'None',
            recordtypeid                         = parentOptyRecordTypeId,
            Service_Source__c                    = 'New',
            ownerId                              = stdUser1.Id,
            Opportunity_Owner_AM__c              = stdUser1.Id,
            Close_Probability__c                 = 75
        );
        insert newOpportunity;
        
       
     
         Opportunity newOpportunity1 = new Opportunity(
                dealid__c                            = 'B111',
                Name                                 = 'Test222',
                StageName                            = '2 - Qualification',
                AccountId                            = accId ,
                CloseDate                            = system.today().adddays(2),
                CurrencyIsoCode                      = 'USD',
                expected_product__c                  = 0,
                expected_service__c                  = 100,
                forecast_status__c                   = 'Commit',
                Non_Standard_Terms_and_Conditions__c = 'None',
                recordtypeid                         = parentOptyRecordTypeId,
                Service_Source__c                    = 'New',
                ownerId                              = stdUser1.Id,
                Opportunity_Owner_AM__c              = stdUser1.Id,
                Close_Probability__c                 = 75
            );
            insert newOpportunity1;
           
        
          String parentOptyId= null;
          
          if(sharedOptyList.size()>0){
             parentOptyId= sharedOptyList[0].Id;
           }else{
             parentOptyId=newOpportunity.Id;
           }
           
            Opportunity newOpportunity2 = new Opportunity(
                dealid__c                            = 'A111',
                AccountId                            =  acc.id,
                Name                                 = 'Test111',
                StageName                            = '2 - Qualification',
                CloseDate                            = system.today().adddays(2),
                CurrencyIsoCode                      = 'USD',
                expected_product__c                  = 0,
                expected_service__c                  = 100,
                forecast_status__c                   = 'Commit',
                Non_Standard_Terms_and_Conditions__c = 'None',
                recordtypeid                         =  phaseOptyRecordTypeId,
                Service_Source__c                    = 'New',
                ownerId                              = stdUser1.Id,
                Opportunity_Owner_AM__c              = stdUser1.Id,
                Close_Probability__c                 = 75,
                Parent_Id__c                         = parentOptyId
            );
          insert newOpportunity2;
         
        
        PartnerNetworkRecordConnection networkConnRecord1 =new PartnerNetworkRecordConnection(
            ConnectionId = ParNetConn[0].id,
            LocalRecordId = acc.Id
        );
           
        
        PartnerNetworkRecordConnection networkConnRecord2 =new PartnerNetworkRecordConnection(
            ConnectionId = ParNetConn[0].id,
            LocalRecordId = newOpportunity2.Id,
          ParentRecordId = acc.Id
            );
        try
        {
            insert networkConnRecord1;
        }
        catch(DMLException e)
        {
            system.debug('Error');
        }
        
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
            Opportunity__c           = newOpportunity1.Id,
            AT_Team__c               = 'test1',
            Sync_With_Opportunity__c = false
        );
        insert newWorkspace;
        insert newWorkspace1;
        
        OpportunityLineItem optylneItm = new OpportunityLineItem(
            OpportunityId = newOpportunity.id,
            Business_Entity__c ='AS-S',
            Product_Family__c =null,
            PricebookEntryId  = pbID.Id,
            Mix__c=100.0,
            Opportunity_Line_Value__c = 100           
            
        );       
        insert optylneItm;
 
        OpportunityLineItem optylneItm1 = new OpportunityLineItem(
            OpportunityId = newOpportunity.id,
            Business_Entity__c ='AS-S',
           // ProductCode ='Service',
            Product_Family__c =null,
            PricebookEntryId  = pbID.Id,
            Mix__c=100.0,
            Opportunity_Line_Value__c = 100           
            
        );
        insert optylneItm1;
                 
       Test.StartTest();
            
            OpptyShareSOneBatchApex ops = new OpptyShareSOneBatchApex(); 
            Database.executeBatch(ops);  
            set<id> setid = new set<id>();
            setid.add(newOpportunity.Id); 
            if(sharedOptyList.size()>0){ 
                setid.add(sharedOptyList[0].id);
                setid.add(sharedOptyList[1].id);
            }
            set<string> setDealId = new set<string>();
            setDealId.add(newOpportunity.DealId__c);  
            if(sharedOptyList.size()>0){
                    setDealId.add(sharedOptyList[0].DealId__c);
                    setDealId.add(sharedOptyList[1].DealId__c);
            }
        system.debug('SetId========>'+setDealid);
           // ops.sharedAccOptySet = new Set<Id>{newOpportunity.Id}; 
            try{
            ops.shareLinitems(setid); 
            }catch(Exception e){
            }                      
            
            try{
                ops.shareWorkspceTech(setid,ParNetConn[0].id);
            }catch(Exception e){}
            try{            
            ops.shareRelatedRecordShare(new Set<String>{'A111'},new Set<Id>{newOpportunity.AccountId},new Set<Id>{newOpportunity1.id},new Set<Id>{newOpportunity.Id},new Set<Id>{newOpportunity.AccountId});
              }catch(exception e){
            }
        try{
            ops.getRelatedOptyStatus(setDealId,ParNetConn[0].id);
                }
        catch(exception e){}
            Test.StopTest();        
    }   
}