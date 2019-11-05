@isTest
private class Request_SE_Resource_Test {
    private static Resource_Request_Assignment__c prepareData(boolean withoutTerritory) {
        //Load Org_Constants__c contants records from static resource
        List<sObject> lsOrgConstants = Test.loadData(Org_Constants__c.sObjectType, 'OrgConstants');
        insert new ObjectRecordTypeIds__c(Opportunity_Parent_Mobile_RecordTypeId__c ='0123000000003yk', Opportunity_Void_Merged_RecordTypeId__c = '012800000002e0M');
        
        //load custom settings
        Territory2 newTerritory;
        User u = new User(Id = UserInfo.getUserId());

        Profile pList = [SELECT Id FROM Profile WHERE Name ='Cisco_ADMIN' limit 1];
        User newUser = new User();
        newUser.Alias = 'testusr';
        newUser.Email = 'testusr@cisco.com.test';
        newUser.EmailEncodingKey = 'UTF-8';
        newUser.LastName = 'Test';
        newUser.FirstName = 'cecid';
        newUser.Organization__c = 'Test';
        newUser.LanguageLocaleKey = 'en_US';
        newUser.LocaleSidKey = 'en_US';
        newUser.ProfileId = pList.Id;
        newUser.CommunityNickname = 'testusr';
        newUser.TimeZoneSidKey = 'America/Los_Angeles';
        newUser.UserName = 'testusr@cisco.com.test';
        newUser.Theatre__c = 'Americas-Canada';
        
        System.runAs (u) {
            List<Org_Constant_CS__c> orgConstant = new List<Org_Constant_CS__c>();
            orgConstant.add(new Org_Constant_CS__c(Name='wwwin-tools',Non_Production_Value__c='https://wwwin-tools-stage.cisco.com/',Production_Value__c='https://wwwin-tools.cisco.com/'));
            orgConstant.add(new Org_Constant_CS__c(Name='ProfileIds_for_Delete',Non_Production_Value__c='00e30000000dcbg;00e30000000dfUE;00e30000000eca0',Production_Value__c='00e30000000dcbg;00e30000000dfUE;00e30000000eca0'));
            insert orgConstant;
            
            ProfileID__c profileIds = new ProfileID__c();
            profileIds.Cisco_Renewals__c = '00e34000001CQnp';
            profileIds.Cisco_PSS__c = '00e30000000rrZw';
            insert profileIds;
          
            List<Territory2Type> terriType  = [SELECT id, DeveloperName from Territory2Type where  DeveloperName = 'DR' LIMIT 1];
            
            //insert territory model
            List<Territory2Model>   terrModel = [Select Id from Territory2Model where State = 'Active' limit 1];
      
            
            //insert territory
            if (withoutTerritory) {
                newTerritory = new Territory2(
                DeveloperName = 'TestTerritory', 
                Territory2ModelId=terrModel[0].Id, Name='Parent Territory', Territory2TypeId=terriType[0].Id,AccountAccessLevel = 'All',
                OpportunityAccessLevel = 'Edit');
                insert newTerritory;
                system.debug('territory'+newTerritory.Id);
            }
            insert newUser;
        }
        
        Account a =  new Account(Name='AccountTest', RecordTypeId = '0123000000004aU',Account_Status__c='Active');
        insert a;
        List<Account> accList = new List<Account>();
        accList.add(a);
        
        ObjectTerritory2Association ota = new ObjectTerritory2Association(ObjectId=accList[0].Id, Territory2Id=newTerritory.Id, AssociationCause='Territory2Manual');
        insert ota;

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
            ownerId                              = newUser.Id,
            Opportunity_Owner_AM__c              = newUser.Id,
            Close_Probability__c                 = 75,
            AccountId = a.id
        );
        if (withoutTerritory) {
            newOpportunity.Territory2Id = newTerritory.Id;
        }
        insert newOpportunity;

        Resource_Request_Assignment__c newResourceRequestAssignment = new Resource_Request_Assignment__c(
            Opportunity_Name__c = newOpportunity.Id,
           Resource_Name__c    = UserInfo.getUserId(),
           Assignment_Type__c  = 'Partner Secondary',
           Resource_Status__c  = 'Direct Assignment'
        );
       // insert newResourceRequestAssignment;
        return newResourceRequestAssignment;       
    }

    private static Boolean checkErrorMessage(String errorMsg) {
        for (ApexPages.Message msg: ApexPages.getMessages()) {
            if (msg.getSeverity() == ApexPages.Severity.Error && msg.getSummary() == errorMsg) {
                return true;
            }
        }
        return false;
    }

    @isTest static void test_method_one() {       
       Resource_Request_Assignment__c RRA = prepareData(true);
       Test.setCurrentPage(Page.Request_SE_Resource);
       Request_SE_Resource_CTE  RREController = new Request_SE_Resource_CTE (new ApexPages.StandardController(RRA));
        
        System.assertEquals(false, RREController.error);
        System.assertEquals(null, RREController.errorMsg);
        System.assertNotEquals(null, RREController.iframeUrl);

        String baseUrl   = Utilities.getConstant_CS('wwwin-tools');
        String hostname  = Url.getSalesforceBaseUrl().toExternalForm();
        List<Opportunity> opportunities = [SELECT Id, Territory2Id FROM Opportunity WHERE Id =: RRA.Opportunity_Name__c];
        PageReference pr = RREController.iframeUrl;
       
       Map<String, String> urlParameters = pr.getParameters();
        
        System.assert(pr.getUrl().startsWith(baseUrl + 'WWSPS/SECCI/protected/specialization.do'));
        System.assertEquals('showPage', urlParameters.get('action'));
        System.assertEquals([SELECT Salesforce_API_Session__c FROM User WHERE Id =: UserInfo.getUserId()].Salesforce_API_Session__c, urlParameters.get('sessionId'));
        System.assertEquals(hostname + '/' + RRA.Opportunity_Name__c, urlParameters.get('cancelURL'));
        System.assertEquals(hostname + '/services/Soap/u/45.0/' + UserInfo.getOrganizationId().substring(0,15), urlParameters.get('apiServerUrl'));
        System.assertEquals('true', urlParameters.get('profileId'));
        System.assertEquals(UserInfo.getProfileId() == Utilities.getTSNProfileId() ? 'true': 'false', urlParameters.get('profileFlag'));             
        System.assertEquals(UserInfo.getUserId(), urlParameters.get('userId'));
        System.assertEquals(opportunities[0].Id, urlParameters.get('opptyId'));
        System.assertEquals(opportunities[0].Territory2Id, urlParameters.get('TerrId'));
        System.assertEquals(UserInfo.getUserName(), urlParameters.get('userName'));       
        //System.assertEquals(opportunities[0].Name, urlParameters.get('opptyName'));       
    }
    
    @isTest static void test_method_two() {
        Resource_Request_Assignment__c RRA = prepareData(true);
        Test.setCurrentPage(Page.Request_SE_Resource);

        Request_SE_Resource_CTE  RREController = new Request_SE_Resource_CTE (new ApexPages.StandardController(RRA));
       // System.assertEquals(false, RREController.error);
        System.assertEquals(null, RREController.errorMsg);
       // System.assertNotEquals(null, RREController.iframeUrl);

        String baseUrl   = Utilities.getConstant_CS('wwwin-tools');
        String hostname  = Url.getSalesforceBaseUrl().toExternalForm();
        List<Opportunity> opportunities = [SELECT Id, Territory2Id FROM Opportunity WHERE Id =: RRA.Opportunity_Name__c];
        PageReference pr = RREController.iframeUrl;
       // Map<String, String> urlParameters = pr.getParameters();
        /*
        System.assert(pr.getUrl().startsWith(baseUrl + 'WWSPS/SECCI/protected/specialization.do'));
        System.assertEquals('getRequestDetails', urlParameters.get('action'));
        System.assertEquals([SELECT Salesforce_API_Session__c FROM User WHERE Id =: UserInfo.getUserId()].Salesforce_API_Session__c, urlParameters.get('sessionId'));
        System.assertEquals(hostname + '/' + RRA.Opportunity_Name__c, urlParameters.get('cancelURL'));
        System.assertEquals(hostname + '/services/Soap/u/17.0/' + UserInfo.getOrganizationId().substring(0,15), urlParameters.get('apiServerUrl'));
        System.assertEquals(UserInfo.getUserId(), urlParameters.get('userId'));
        System.assertEquals(UserInfo.getUserName(), urlParameters.get('userName'));
        System.assertEquals(opportunities[0].Id, urlParameters.get('selectedOpptyId'));
        System.assertEquals(null, urlParameters.get('territoryId'));
        System.assertEquals(RRA.Id, urlParameters.get('selectedRequestId'));
        System.assertEquals(RRA.Resource_Status__c, urlParameters.get('selectedRequestStatus'));
        System.assertEquals('true', urlParameters.get('link'));
*/
    }

    
    @isTest static void test_method_three() {
        //invalid opportunity
        Resource_Request_Assignment__c RRA = prepareData(true);
        Test.setCurrentPage(Page.Request_SE_Resource );
        delete [SELECT Id, Territory2Id FROM Opportunity WHERE Id =: RRA.Opportunity_Name__c];

        Request_SE_Resource_CTE  RREController = new Request_SE_Resource_CTE (new ApexPages.StandardController(RRA));
        System.assertEquals(true, RREController.error);
       // System.assert(checkErrorMessage('Invalid opportunity Id'));
    }

    @isTest static void test_method_four() {
        //missing object Id
        Resource_Request_Assignment__c RRA = new Resource_Request_Assignment__c();
        Test.setCurrentPage(Page.Request_SE_Resource );

        Request_SE_Resource_CTE  RREController = new Request_SE_Resource_CTE (new ApexPages.StandardController(RRA));
        System.assertEquals(true, RREController.error);
        //System.assert(checkErrorMessage('Missing object Id'));
    }

}