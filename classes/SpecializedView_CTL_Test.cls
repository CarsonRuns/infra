/*
Author          : Awnish Kumar
Release         : PSS MVP March 29, 2019 Release
Created         : Feb 11, 2019
Functionality   : SpecializedView_CTL Test Class


Modification History:
Itrack#        Date        Author              Change 
US291448	   2/5/2019    Kavya M			PSS - Quote Overwrite Specialist View
*/
@isTest
public class SpecializedView_CTL_Test {
    
    static testMethod void specialistViewTest(){
        
        Utilities.setIsTestMethod(true);
        Utilities.setValidationSkip(true);
        
        Org_Constant_CS__c os2 =new Org_Constant_CS__c();
        os2.Name = 'PilotProfileId';
        os2.Production_Value__c = '00e34000001aqqQ';
        os2.Non_Production_Value__c = '00e34000001aqqQ';
        insert os2;
        String profileId = Utilities.getConstant_CS('PilotProfileId');  
        
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Cisco_ADMIN' Limit 1];
        User usr = lxTestDataFactory.createSingleUser(p.Id);
        insert usr;
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('End-User').getRecordTypeId();
        Account acct1 = null;
        
        system.runAs(usr){
            
            lxTestDataFactory.createCustomSettings();
            acct1 = lxTestDataFactory.createChannelAccount(usr.Id);
            insert acct1;
        }
        //Retrieve Existing Account
        //Account acct1 = [select id from account where RecordTypeId=:devRecordTypeId limit 1];
        
        //Retrieveing Current Date
        Date vCloseDate = System.today();
        //Get users default currency
        User currentUser = [select defaultCurrencyIsoCode from User where Id = :UserInfo.getUserId()];
        
        //Query for Pricebook2
        String defaultPricebookId;
        //Pricebook2[] pricebook2 = [select id from Pricebook2 WHERE NAME = 'Standard Price Book'];
        //if(pricebook2 == null || pricebook2.size() == 0){
        Pricebook2 createDefaultPB = new Pricebook2(name='Standard Price Book', isActive=true);
        insert createDefaultPB;
        defaultPricebookId = createDefaultPB.Id;
        /*}
else{
defaultPricebookId = pricebook2[0].Id;

}*/
        //Create Opportunity 
        Opportunity oppty1 = new Opportunity(name='Test1',Accountid=acct1.id, StageName='3 - Proposal',
                                             CloseDate= vCloseDate-1,Competitors__c = 'A10 Networks',
                                             Expected_Product__c=2,
                                             Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode);
        oppty1.Expected_Service__c = 0;
        oppty1.Expected_Product__c = 10;
        insert oppty1;
        
        //Summary View logic
        lxSpecializedViewSummaryController.getSummaryViewList(oppty1.Id);
        
        //Create Opportunity Team
        OpportunityTeamMember optyTeam = new OpportunityTeamMember();
        optyTeam.OpportunityId = oppty1.id;
        optyTeam.TeamMemberRole = 'Architecture Specialist';
        optyTeam.UserId = UserInfo.getUserId();
        insert optyTeam;        
        
        // Create Opportunity Line Items 
        /*PricebookEntry pbeTech = [select id, PriceBook2.Id from pricebookentry where pricebook2.Name = 'Standard Price Book' 
and IsActive=true and CurrencyIsoCode=:currentUser.defaultCurrencyIsoCode limit 1]; */                               
        
        //Create new Technology and Service                                
        Product2 pr2 = new Product2(ProductCode='Technology',
                                    Name = 'COMPUTING SYSTEMS',
                                    Business_Entity__c = 'COMPUTING SYSTEMS',
                                    Product_Family_1__c='pf1',
                                    Product_Family_2__c='pf2',
                                    Product_Family_3__c='pf3', 
                                    Product_Family_4__c='pf4',
                                    isactive=true,
                                    searchable__c='Yes');
        insert pr2;
        
        Product2 pr21 = new Product2(ProductCode='Service',
                                     Name = 'COMPUTING SYSTEMS',
                                     Business_Entity__c = 'COMPUTING SYSTEMS',
                                     Product_Family_1__c='pf1',
                                     Product_Family_2__c='pf2',
                                     Product_Family_3__c='pf3', 
                                     Product_Family_4__c='pf4',
                                     isactive=true,
                                     searchable__c='Yes',
                                     SERVICE_LEVEL_1__c='TECHNICAL SUPPORT;test2');
        insert pr21;
        // Id pricebookId = Test.getStandardPricebookId();
        // 
        Product_Family__c prodFamily = new Product_Family__c();
        prodFamily.IsActive__c = true;
        prodFamily.Name='test';
        prodFamily.Searchable__c = 'Yes';
        prodFamily.Product_Family_Description__c ='test';
        prodFamily.Product__c = pr2.Id;
        insert prodFamily;
        
        Service_Level__c serviceLevel = new Service_Level__c();
        serviceLevel.Name = 'test';
        serviceLevel.Product__c = pr21.Id;
        serviceLevel.Service_Level_Description__c ='TECHNICAL SUPPORT';
        insert serviceLevel;
        
        PricebookEntry pbeTech = new PricebookEntry(
            Pricebook2Id = createDefaultPB.Id, Product2Id = pr2.Id,
            UnitPrice = 10000, IsActive = true);
        insert pbeTech;
        
        PricebookEntry pbeService = new PricebookEntry(
            Pricebook2Id = createDefaultPB.Id, Product2Id = pr21.Id,
            UnitPrice = 10000, IsActive = true);
        insert pbeService;
        //Create SpeclialistLine JSON - Architecture Specialist
        JSONGenerator gen = JSON.createGenerator(true);
        SpecialistViewJSON specialistJSON = new SpecialistViewJSON();
        specialistJSON.role = 'archspecialist';
        SpecialistViewJSON.LineItems lItem1 = new SpecialistViewJSON.LineItems();
        lItem1.category = 'Technology';
        lItem1.besubbe = pr2.Id;
        lItem1.productfamily = 'pf1';
        lItem1.expectedProductvalue = 100;
        lItem1.bookdate = vCloseDate+3;
        lItem1.stage = '3 - Proposal';
        SpecialistViewJSON.LineItems lItem2 = new SpecialistViewJSON.LineItems();
        lItem2.category = 'Technology';
        lItem2.besubbe = pr21.Id;
        lItem2.productfamily = 'pf1';
        lItem2.expectedProductvalue = 100;
        lItem2.bookdate = vCloseDate;
        lItem2.stage = '1 - Prospect';
        SpecialistViewJSON.LineItems lItem21 = new SpecialistViewJSON.LineItems();
        lItem21.category = 'Service';
        lItem21.besubbe = pr2.Id;
        lItem21.productfamily = 'pf1';
        lItem21.expectedServicevalue = 100;
        lItem21.bookdate = vCloseDate;
        lItem21.stage = '1 - Prospect';
        SpecialistViewJSON.LineItems lItem22 = new SpecialistViewJSON.LineItems();
        lItem22.category = 'Service';
        lItem22.besubbe = pr21.Id;
        lItem22.productfamily = 'pf1';
        lItem22.expectedServicevalue = 100;
        lItem22.bookdate = vCloseDate;
        lItem22.stage = '1 - Prospect';
        List<SpecialistViewJSON.LineItems> lItems = new List<SpecialistViewJSON.LineItems>();
        lItems.add(lItem1);
        lItems.add(lItem2);
        lItems.add(lItem21);
        lItems.add(lItem22);
        specialistJSON.lineItems = lItems;
        gen.writeObject(specialistJSON);
        String SpeclialistLineJSON = gen.getAsString();
        system.debug('SpeclialistLineJSON--'+SpeclialistLineJSON);
        
        //Create SpeclialistLine JSON - Incubation Specialist
        JSONGenerator gen1 = JSON.createGenerator(true);
        SpecialistViewJSON specialistJSON1 = new SpecialistViewJSON();
        specialistJSON1.role = 'incubationspecialist';
        SpecialistViewJSON.LineItems lItem3 = new SpecialistViewJSON.LineItems();
        lItem3.category = 'Technology';
        lItem3.besubbe = pr2.Id;
        lItem3.productfamily = 'pf1';
        lItem3.expectedProductvalue = 100;
        lItem3.bookdate = vCloseDate;
        lItem3.stage = '3 - Proposal';
        SpecialistViewJSON.LineItems lItem4 = new SpecialistViewJSON.LineItems();
        lItem4.category = 'Technology';
        lItem4.besubbe = pr21.Id;
        lItem4.productfamily = 'pf1';
        lItem4.expectedProductvalue = 100;
        lItem4.bookdate = vCloseDate;
        lItem4.stage = '1 - Prospect';
        SpecialistViewJSON.LineItems lItem31 = new SpecialistViewJSON.LineItems();
        lItem31.category = 'Service';
        lItem31.besubbe = pr21.Id;
        lItem31.productfamily = 'pf1';
        lItem31.expectedProductvalue = 100;
        lItem31.bookdate = vCloseDate;
        lItem31.stage = '1 - Prospect';
        SpecialistViewJSON.LineItems lItem41 = new SpecialistViewJSON.LineItems();
        lItem41.category = 'Service';
        lItem41.besubbe = pr21.Id;
        lItem41.productfamily = 'pf1';
        lItem41.expectedProductvalue = 100;
        lItem41.bookdate = vCloseDate;
        lItem41.stage = '1 - Prospect';
        List<SpecialistViewJSON.LineItems> lItems1 = new List<SpecialistViewJSON.LineItems>();
        lItems1.add(lItem3);
        lItems1.add(lItem4);
        lItems1.add(lItem31);
        lItems1.add(lItem41);
        specialistJSON1.lineItems = lItems1;
        gen1.writeObject(specialistJSON1);
        String SpeclialistLineJSON1 = gen1.getAsString();
        
        
        
        JSONGenerator gen2 = JSON.createGenerator(true);
        SpecialistViewJSON specialistJSON2 = new SpecialistViewJSON();
        specialistJSON2.role = 'softwarespecialist';
        SpecialistViewJSON.LineItems lItem6 = new SpecialistViewJSON.LineItems();
        lItem6.category = 'Technology';
        lItem6.besubbe = pr2.Id;
        lItem6.productfamily = 'pf1';
        lItem6.expectedProductvalue = 100;
        lItem6.bookdate = vCloseDate;
        lItem6.stage = '3 - Proposal';
        SpecialistViewJSON.LineItems lItem7 = new SpecialistViewJSON.LineItems();
        lItem7.category = 'Technology';
        lItem7.besubbe = pr21.Id;
        lItem7.productfamily = 'pf1';
        lItem7.expectedProductvalue = 100;
        lItem7.bookdate = vCloseDate;
        lItem7.stage = '1 - Prospect';
        SpecialistViewJSON.LineItems lItem61 = new SpecialistViewJSON.LineItems();
        lItem61.category = 'Service';
        lItem61.besubbe = pr21.Id;
        lItem61.productfamily = 'pf1';
        lItem61.expectedProductvalue = 100;
        lItem61.bookdate = vCloseDate;
        lItem61.stage = '1 - Prospect';
        SpecialistViewJSON.LineItems lItem71 = new SpecialistViewJSON.LineItems();
        lItem71.category = 'Service';
        lItem71.besubbe = pr21.Id;
        lItem71.productfamily = 'pf1';
        lItem71.expectedProductvalue = 100;
        lItem71.bookdate = vCloseDate;
        lItem71.stage = '1 - Prospect';
        List<SpecialistViewJSON.LineItems> lItems3 = new List<SpecialistViewJSON.LineItems>();
        lItems3.add(lItem6);
        lItems3.add(lItem7);
        lItems3.add(lItem61);
        lItems3.add(lItem71);
        specialistJSON2.lineItems = lItems3;
        gen2.writeObject(specialistJSON2);
        String SpeclialistLineJSON2 = gen2.getAsString();
        
        //Creating Technology Line 
        OpportunityLineItem oli1 = new OpportunityLineItem();
        oli1.Mix__c= 100;
        oli1.Business_Entity__c = 'COMPUTING SYSTEMS';
        oli1.Product2Id = pr2.id;
        oli1.OpportunityId=oppty1.Id;
        oli1.PricebookEntryId = pbeTech.id;
        oli1.Quantity=1;
        oli1.Product_Family__c='pf1';
        insert oli1;
        
        OpportunityLineItem oli2 = new OpportunityLineItem();
        oli2.Mix__c= 100;
        oli2.Business_Entity__c = 'COMPUTING SYSTEMS';
        oli2.Product2Id = pr21.id;
        oli2.OpportunityId=oppty1.Id;
        oli2.PricebookEntryId = pbeService.id;
        oli2.Quantity=1;
        oli2.Product_Family__c='pf1';
        insert oli2;
        
        OpportunityLinesSV__c oppLineSSV = new OpportunityLinesSV__c();
        oppLineSSV.Technology_Service__c = oli1.Product2Id;
        oppLineSSV.Opportunity__c = oppty1.Id;
        oppLineSSV.Incubation_Specialist__c = userInfo.getUserId();
        oppLineSSV.Opportunity_Stage__c = '2 - Qualification';    
        oppLineSSV.Expected_Book_Date__c = system.today();  
        oppLineSSV.Expected_000_Value__c = 100;
        oppLineSSV.Product_Family__c = prodFamily.Id;//oli1.Product_Family__c;
        oppLineSSV.Product_Code__c = 'Technology';//oli1.PriceBookEntry.ProductCode;
        //oppLineSSV.Business_Entity__c = 'COMPUTING SYSTEMS';
        insert oppLineSSV;
        
        OpportunityLinesSV__c oppLineSSV2 = new OpportunityLinesSV__c();
        oppLineSSV2.Technology_Service__c = oli2.Product2Id;
        oppLineSSV2.Opportunity__c = oppty1.Id;
        oppLineSSV2.Incubation_Specialist__c = userInfo.getUserId();
        oppLineSSV2.Opportunity_Stage__c = '2 - Qualification';    
        oppLineSSV2.Expected_Book_Date__c = system.today();  
        oppLineSSV2.Expected_000_Value__c = 100;
        oppLineSSV2.Product_Family__c = 'pf1';//oli1.Product_Family__c;
        oppLineSSV2.Product_Code__c = 'Service';//oli1.PriceBookEntry.ProductCode;
        //oppLineSSV.Business_Entity__c = 'COMPUTING SYSTEMS';
        insert oppLineSSV2;
        
        //Executing Tests
        Test.startTest();
        
        //Checking PSS pilot permission
        Boolean pilotUser = SpecializedView_CTL.checkPilotUserPermission();
        Opportunity opty = SpecializedView_CTL.getOpportunityDetails(oppty1.Id);
        //Checking User Read Permission on the Opportunity
        Boolean checkUserPermission  = SpecializedView_CTL.checkUserViewPermission(oppty1.Id);
        Map<String,String>  techLines = SpecializedView_CTL.getTechnologyLines();
        Map<String,String>  serviceLines = SpecializedView_CTL.getServiceLines('TECHNICAL SUPPORT');
        
        // Architecture Specialist
        // Insert New Lines to Specialist View
        Map<String,List<String>> ouput1 = SpecializedView_CTL.saveSpecializedLine(oppty1.Id,SpeclialistLineJSON);
        
        //Update existing lines in Specialist View
        Map<String,List<String>> ouput2 = SpecializedView_CTL.saveSpecializedLine(oppty1.Id,SpeclialistLineJSON);
        
        //Incubation Specialist
        // Insert New Lines to Specialist View
        Map<String,List<String>> ouput3 = SpecializedView_CTL.saveSpecializedLine(oppty1.Id, SpeclialistLineJSON1);
        //Update existing lines in Specialist View
        Map<String,List<String>> ouput4 = SpecializedView_CTL.saveSpecializedLine(oppty1.Id, SpeclialistLineJSON1);
        
        Map<String,List<String>> ouput5 = SpecializedView_CTL.saveSpecializedLine(oppty1.Id, SpeclialistLineJSON2);
        //Update existing lines in Specialist View
        Map<String,List<String>> ouput6 = SpecializedView_CTL.saveSpecializedLine(oppty1.Id, SpeclialistLineJSON2);
        
        //Specialist Form Add Tech Line
        set<String> techKeys = techLines.keySet();
        String techId ='';
        for (string techKey : techKeys) {
            techId = techKey;
            break;
        }
        List<String> techLine = techId.split('\\|');
        OpportunityLinesSV__c oppLineSSV1 = new OpportunityLinesSV__c();
        oppLineSSV1.Technology_Service__c = techLine[0];
        oppLineSSV1.Opportunity__c = oppty1.Id;
        oppLineSSV1.Incubation_Specialist__c = userInfo.getUserId();
        oppLineSSV1.Opportunity_Stage__c = '2 - Qualification';    
        oppLineSSV1.Expected_Book_Date__c = system.today();  
        oppLineSSV1.Expected_000_Value__c = 100;
        oppLineSSV1.Product_Family__c = techLine[1];//oli1.Product_Family__c;
        oppLineSSV1.Product_Code__c = 'Technology';//oli1.PriceBookEntry.ProductCode;
        oppLineSSV1.RecordTypeId = ObjectRecordTypeIds__c.getInstance().Architecture_Specialist_Record_Type__c;
        //oppLineSSV.Business_Entity__c = 'COMPUTING SYSTEMS';
        insert oppLineSSV1;
        System.debug('Kavya techId'+techId);
        String status1 = SpecializedView_CTL.saveSpecializedViewTech(oppty1.Id,'Architecture Specialist', techId, 200.01, '2019-03-03', '1 - Prospect');
        String status2 = SpecializedView_CTL.saveSpecializedViewTech(oppty1.Id,'Incubation Specialist', techId, 200.01, '2019-03-03', '1 - Prospect');
        String status10 = SpecializedView_CTL.saveSpecializedViewTech(oppty1.Id,'Software Specialist', techId, 200.01, '2019-03-03', '1 - Prospect');
        
        
        //Specialist Form Add Service Line
        set<String> serviceKeys = serviceLines.keySet();
        String serviceId ='';
        for (string serviceKey : serviceKeys) {
            serviceId = serviceKey;
            break;
        }
        String status3 = SpecializedView_CTL.saveSpecializedViewService(oppty1.Id,'Architecture Specialist', serviceId, 200.01, '2019-03-03', '1 - Prospect');
        String status4 = SpecializedView_CTL.saveSpecializedViewService(oppty1.Id,'Incubation Specialist', serviceId, 200.01, '2019-03-03', '1 - Prospect');
        String status9 = SpecializedView_CTL.saveSpecializedViewService(oppty1.Id,'Software Specialist', techId, 200.01, '2019-03-03', '1 - Prospect');
        
        String existingSpecialistLineId = '';
        List<OpportunityLinesSV__c> specialistLines = SpecializedView_CTL.getSpecializedLines(oppty1.Id);
        System.debug('Kavya specialistline'+specialistLines);
        if(!specialistLines.isEmpty()){
            existingSpecialistLineId = specialistLines[0].id;
        }
        
        
        String status5 = SpecializedView_CTL.saveSpecializedViewTech(oppty1.Id,'Architecture Specialist', techId, 200.01, '2019-03-03', '1 - Prospect');
        String status6 = SpecializedView_CTL.saveSpecializedViewTech(oppty1.Id,'Incubation Specialist', techId, 200.01, '2019-03-03', '1 - Prospect');
        
        String status7 = SpecializedView_CTL.saveSpecializedViewService(oppty1.Id,'Architecture Specialist', serviceId, 200.01, '2019-03-03', '1 - Prospect');
        String status8 = SpecializedView_CTL.saveSpecializedViewService(oppty1.Id,'Incubation Specialist', serviceId, 200.01, '2019-03-03', '1 - Prospect');
		String status11 = SpecializedView_CTL.saveSpecializedViewService(oppty1.Id,'Software Specialist', serviceId, 200.01, '2019-03-03', '1 - Prospect');

        //Update existing line
        SpecializedView_CTL.saveExistingSpecializedViewTechServiceLines(existingSpecialistLineId,'Architecture Specialist','100.00','','2019-03-03', '1 - Prospect');
        SpecializedView_CTL.saveExistingSpecializedViewTechServiceLines(existingSpecialistLineId,'Incubation Specialist','100.00','','2019-03-03', '1 - Prospect');
        SpecializedView_CTL.saveExistingSpecializedViewTechServiceLines(existingSpecialistLineId,'Software Specialist','100.00','','2019-03-03', '1 - Prospect');
        oppty1.StageName = '3 - Proposal';
        update oppty1;
        //Summary View logic
        lxSpecializedViewSummaryController.getSummaryViewList(oppty1.Id);
        
        // Get Existing Specialist Line 
        OpportunityLinesSV__c existingSpecialistLine  = SpecializedView_CTL.getExistingSpecialistLine(existingSpecialistLineId);
        for(OpportunityLinesSV__c specialistLine : specialistLines){
            specialistLine.Expected_000_Value__c = null;
            specialistLine.Architecture_Specialist__c =null;
        }
        update specialistLines;
        if(!specialistLines.isEmpty()){
            existingSpecialistLineId = specialistLines[0].id;
        }
         SpecializedView_CTL.saveExistingSpecializedViewTechServiceLines(specialistLines[0].id,'Architecture Specialist','100.00','','2019-03-03', '1 - Prospect');
        
        List<OpportunityLinesSV__c> specialistLines2 = SpecializedView_CTL.getSpecializedLines(oppty1.Id);
        //Delete Specialist Lines
        SpecializedView_CTL.deleteSpecializedLine(existingSpecialistLineId);
        
        //Get Specialist Role
        String userTeamRole  = SpecializedView_CTL.getSpecialistRole(oppty1.Id);
        
        //added by Kavya to remove all lines
        SpecializedView_CTL.RemoveAllSpecialistLine(oppty1.Id);
        SpecializedView_CTL.CheckSpecialistLineExist(oppty1.Id);
        SpecializedView_CTL.checkEAOppty(oppty1.Id);
        Test.stopTest();
        
    } 
    
}