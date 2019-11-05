/*
Author          : Manikant Kella
Release         : June,2019
Created         : Manikant Kella
Functionality   : Test class for lxOptyTeamMemberOverrideEdit


Modification History:
*------------------------------------------------------------------------------------
Itrack#        Date        Author                             Change  
*------------------------------------------------------------------------------------
US291442	May 01,2019	  Manikant Kella(mkella)	   PSS - Change Specialist in Oppty Team and Specialist View
*------------------------------------------------------------------------------------
*/

@istest(SeeAllData=false)
private class lxOptyTeamMemberOverrideEdit_Test {
    private static testMethod void test(){
        
        
		Profile profile = [SELECT Id FROM Profile WHERE Name = 'Cisco_Admin' Limit 1];
        Id profileId = profile.id;
		User currentUser = new User(firstName='Test',LastName ='PA Contact', USERNAME='testpa1@cisco.com.sales.test',email='testpa232@cisco.com.test',ALIAS='testpa',COMMUNITYNICKNAME='testpa',ISACTIVE=True,
                             TIMEZONESIDKEY='America/Los_Angeles',LnP_T_C_Acepted_Date__c=Date.Today()+5,LnP_TC_Reset_Date__c=Date.Today()-5,LnP_TC_Accepted__c=true,PROFILEID =profileId ,LANGUAGELOCALEKEY ='en_US',THEATRE__C='APJC-APAC',
                             LOCALESIDKEY ='en_US',EMAILENCODINGKEY='UTF-8',Additional_User_Permissions__c='Enable EndUser ACCTCreation');
        insert currentUser;        
        User newUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        Id userId = currentUser.Id;
        
        Utilities.setIsTestMethod(true);
        Utilities.setValidationSkip(true);
        system.runAs(currentUser){
            ObjectRecordTypeIds__c  testCust = new ObjectRecordTypeIds__c ();
        testCust.AccountChannelRecordTypeId__c = '0123000000004aV';
        testCust.Contact_PDB_RecordTypeId__c='01280000000G6tn';
        insert testCust;
        
        Org_Constants__c os =new Org_Constants__c();
        os.Key__c = 'Oppty: ProfileIds to skip Triggers';
        os.non_prod_value__c = '00e30000000dcbfAAA,00e30000000dfUEAAY,00e30000000eca0AAA,00e30000000qiJjAAI,00e30000000dcbgAAA,00e30000000rrZwAAI';
        os.Prod_LT__c = 'GSTS,Data_Migration,Integration_Echo_Suppression,GSTS_Analyst,ADMIN, PSS';
        os.prod_value__c = '00e30000000dcbfAAA,00e30000000dfUEAAY,00e30000000eca0AAA,00e30000000qiJjAAI,00e30000000dcbgAAA,00e30000000rrZwAAI';
        os.Type__c = 'URL';
        insert os;
        
        
        ProfileID__c profileIds = new ProfileID__c();
        profileIds.Cisco_Renewals__c = '00e34000001CQnp';
        profileIds.Cisco_PSS__c = '00e30000000rrZw';
        insert profileIds; 
        
        PDI_Collaboration_Countries__c  testCountry = new PDI_Collaboration_Countries__c ();
        testCountry.Name =' Testing';
        testCountry.Country1__c = 'West';
        testCountry.Country2__c ='West';
        testCountry.Country3__c ='West';
        testCountry.Country4__c='West';
        insert testCountry;
        }
        Id RecordTypeIdopportunity = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Global Deal/Opportunity').getRecordTypeId();
        /*Opportunity oppty = new Opportunity(dealid__c='A111',name='Test111',StageName='2 - Qualification',CloseDate= system.today().adddays(2),
                                                      CurrencyIsoCode='USD',expected_product__c=0,expected_service__c=10,Competitors__c = 'A10 Networks',
                                                      forecast_status__c='Commit',Non_Standard_Terms_and_Conditions__c='None', 
                                                      recordtypeId='0123000000003ykAAA');
        
        insert oppty;*/
		
        Account acc= new Account(name='Test Account',BillingCity='San Francisco'); 
        insert acc;
        Opportunity oppty = new Opportunity(Theater__c = 'Americas-Canada',Name='Test', AccountId = acc.id, StageName='2 - Qualification', CloseDate=System.today() + 50, Expected_Product__c=10.0,
                                                error_description__c='error', DealID__c='1', Opportunity_Status__c='Active', recordtypeId=RecordTypeIdopportunity, Opportunity_Owner_AM__c =userId,
                                                Competitors__c = 'A10 Networks', 
                                           Is_Product_Quote_Integrated__c = 'Yes', Is_Service_Quote_Integrated__c = 'No', CCW_BOM_Integrated_Quote_Id__c = '1001',Position__c='Americas lrpearso',
                                          CurrencyIsoCode = 'USD');
        insert oppty;
        OpportunityTeamMember optyTeam = new OpportunityTeamMember();
        optyTeam.OpportunityId = oppty.id;
        optyTeam.TeamMemberRole = 'Architecture Specialist';
        optyTeam.UserId = UserInfo.getUserId();
		insert optyTeam;
        
        OpportunityTeamMember optyTeam1 = new OpportunityTeamMember();
        optyTeam1.OpportunityId = oppty.id;
        optyTeam1.TeamMemberRole = 'Incubation Specialist';
        optyTeam1.UserId = UserInfo.getUserId();
		insert optyTeam1;
        
        Test.startTest();
        Boolean value = lxOptyTeamMemberOverrideEdit.initClass(optyTeam.Id);
        String userName = lxOptyTeamMemberOverrideEdit.fetchUser(userId);
        lxOptyTeamMemberOverrideEdit.upsertOptyTeam(optyTeam.Id, optyTeam.TeamMemberRole, 'Read', userId, '', oppty.Id);
        lxOptyTeamMemberOverrideEdit.upsertOptyTeam(optyTeam.Id, optyTeam.TeamMemberRole, 'Read', 'Test', '----', oppty.Id);
        lxOptyTeamMemberOverrideEdit.upsertOptyTeam(optyTeam.Id, optyTeam.TeamMemberRole, 'Read', userId, newUser.Id, oppty.Id);
        
         lxOptyTeamMemberOverrideEdit.upsertOptyTeam(optyTeam1.Id, optyTeam1.TeamMemberRole, 'Read', userId, '', oppty.Id);
        lxOptyTeamMemberOverrideEdit.upsertOptyTeam(optyTeam1.Id, optyTeam1.TeamMemberRole, 'Read', 'Test', '----', oppty.Id);
        lxOptyTeamMemberOverrideEdit.upsertOptyTeam(optyTeam1.Id, optyTeam1.TeamMemberRole, 'Read', userId, newUser.Id, oppty.Id);
        OpportunityLinesSV__c optyLine = new OpportunityLinesSV__c();
        optyLine.Architecture_Specialist__c = userId;
        optyLine.Opportunity__c = oppty.Id;
        optyLine.Incubation_Specialist__c = userId;
        optyLine.Software_Specialist__c = userId;
        insert optyLine;
        lxOptyTeamMemberOverrideEdit.updateSpecialistView(userId, newUser.Id, oppty.Id);
        
        Test.stopTest();
    }

}