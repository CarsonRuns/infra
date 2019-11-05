/**************************************
Author          : R.Hari Krishna
Created         : Feb 13,2019
Functionality   : Generic test class to create dummy data

Modification History:
Date                Author                      Change  
****************************************************************************
Feb 13,2019   R. Hari Krishna(ratharik)         Initial draft
**********************************************/
@isTest
public class lxTestDataFactory {
    
    public static User getLoggedInUser() {
        //Get users default currency
        User currentUser = [select defaultCurrencyIsoCode from User where Id = :UserInfo.getUserId() AND isActive=true];
        return currentUser;
    }
    
    
    public static Product2 createSingleProduct() {
        Product2 pr2 = new Product2(ProductCode='Technology',
                                    Name = 'COMPUTING SYSTEMS',
                                    Business_Entity__c = 'COMPUTING SYSTEMS',
                                    Product_Family_1__c='pf1',
                                    Product_Family_2__c='pf2',
                                    Product_Family_3__c='pf3', 
                                    Product_Family_4__c='pf4',
                                    Service_Program__c = 'servProg',
                                    Service_Category__c = 'serCat',
                                    Service_Level_Name_1__c = 'serLevel',
                                    isactive=true);
        return pr2;
    }
    
    public static Opportunity createSingleOpportunity(Id accId, Id pricebookId, id userID) {
        
        User currentUser = lxTestDataFactory.getLoggedInUser();
        //Create Opportunity 
        Opportunity oppty = new Opportunity(name='Test1',Accountid=accId, StageName='3 - Proposal',
                                            CloseDate= System.Today(),Competitors__c = 'A10 Networks',Expected_Product__c=2,
                                            Pricebook2Id=pricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode,OwnerId=userID);
        
        return oppty;
    }
    
    public static opportunity createSingleOppty() {
        Opportunity newOpportunity = new Opportunity(dealid__c='A111',name='Test111',StageName='2 - Qualification',CloseDate= system.today().adddays(2),
                                                      CurrencyIsoCode='USD',expected_product__c=0,expected_service__c=10,
                                                      forecast_status__c='Commit',Non_Standard_Terms_and_Conditions__c='None', 
                                                      recordtypeid='0123000000003ykAAA');
        return newOpportunity;
    }
    
    public static PricebookEntry createSinglePricebookEntry(Id Pricebook2Id,Id product2Id) {         
        //Create pricebook entry
        PricebookEntry pbeTech = new PricebookEntry();
        pbeTech.Pricebook2Id = Pricebook2Id;
        pbeTech.Product2Id = product2Id;
        pbeTech.IsActive = true;
        pbeTech.UnitPrice = 100;
        return pbeTech;
    }
    
    public static OpportunityLineItem createSingleOpportunityLineItem(Id product2Id,Id optyId, Id priceBookEntryId) {         
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.Mix__c= 100;
        oli.Business_Entity__c = 'COMPUTING SYSTEMS';
        oli.Product2Id = product2Id;
        oli.OpportunityId=optyId;
        oli.PricebookEntryId=priceBookEntryId;
        oli.Quantity=1;
        oli.Product_Family__c='pf1';
        oli.Opportunity_Line_Value__c = 100;
        return oli;
    }
    
    public static OpportunityLinesSV__c createSingleOpportunityLineSSV_c(OpportunityLineItem oli,Id OptyId) { 
        OpportunityLinesSV__c oppLineSSV = new OpportunityLinesSV__c();
        oppLineSSV.Technology_Service__c = oli.Product2Id;
        oppLineSSV.Opportunity__c = OptyId;
        oppLineSSV.Incubation_Specialist__c = userInfo.getUserId();
        oppLineSSV.Opportunity_Stage__c = '2 - Qualification';    
        oppLineSSV.Expected_Book_Date__c = system.today();  
        oppLineSSV.Expected_000_Value__c = 100;
        oppLineSSV.Product_Family__c = oli.Product_Family__c;
        oppLineSSV.Product_Code__c = 'Technology';//oli1.PriceBookEntry.ProductCode;
        return oppLineSSV;
    }
    
    public static Contact createSingleContact() { 
        contact c1 = new contact(firstName='Test',LastName ='PA Contact123', RECORDTYPEID='01280000000G6tnAAC',email='testpa@test.com.test');
        return c1;
    }
    
    public static User createSingleUser(String profileId) {         
        User user = new User(firstName='Test',LastName ='PA Contact', USERNAME='testpa1@cisco.com.sales.test',email='testpa232@cisco.com.test',ALIAS='testpa',COMMUNITYNICKNAME='testpa',ISACTIVE=True,
                             TIMEZONESIDKEY='America/Los_Angeles',LnP_T_C_Acepted_Date__c=Date.Today()+5,LnP_TC_Reset_Date__c=Date.Today()-5,LnP_TC_Accepted__c=true,PROFILEID =profileId ,LANGUAGELOCALEKEY ='en_US',THEATRE__C='APJC-APAC',
                             LOCALESIDKEY ='en_US',EMAILENCODINGKEY='UTF-8',Additional_User_Permissions__c='Enable EndUser ACCTCreation',
                            Notification_Entity__c='Case; Opportunity',Notification_Platform__c='Email; WebEx Teams',Notification_Preference__c='Daily Digest'
                            );
        return user;
    }
    
    public static ProfileID__c createSingleProfile()  {
        
        String proflie= UserInfo.getProfileId();
        String profileId = proflie.substring(0,proflie.length()-3);                                                      
        ProfileID__c profile = new ProfileID__c(SetupOwnerId=UserInfo.getOrganizationId(), Cisco_US_Commercial__c=profileId);
        return profile;
    }
    
    public static Account createChannelAccount(String ownerIds){
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('End-User').getRecordTypeId();
        Account acc = new Account(Name = 'test',recordtypeid=RecordTypeIdAccount ,CSCSiteID__c ='5555',CSCID__c = '5555',ownerid = ownerIds,AddressLine1__c='Test123',AddressLine1_English__c='Test231',AddressLine2__c='Testqa1',AddressLine2_English__c='Testqa123',City__c='UN',City_English__c='Test',State__c= 'AP',State_Province_English__c='ENDTESt',Country__c='INDIA',Country_English__c='INDIA',TOKENID__c='12333',ZipPostalCode__c='847733',Zip_Postal_Code_English__c='766644');
        return acc;  
        
    }
    
    public static Pricebook2 createPriceBook2() {
        Pricebook2 createDefaultPB = new Pricebook2(name='default pricebook', isActive=true);
        return createDefaultPB;
    }
    
    public static PricebookEntry createPriceBookEntry(id idPricebook2,id IdProduct2) {
        PricebookEntry pbeTech = new PricebookEntry(
            Pricebook2Id = idPricebook2, Product2Id = IdProduct2,
            UnitPrice = 10000, IsActive = true);
        return pbeTech;
    }
    
    public static void createCustomSettings(){
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel').getRecordTypeId();
        
        ObjectRecordTypeIds__c o = new ObjectRecordTypeIds__c();
        o.AccountChannelRecordTypeId__c = devRecordTypeId;
        //o.Architecture_Specialist_Record_Type__c =  Schema.SObjectType.OpportunityLinesSV__c.getRecordTypeInfosByName().get('Architecture_and_Incubation_Specialist_Lines').getRecordTypeId();
       // o.Software_Specialist_Record_Type__c =  Schema.SObjectType.OpportunityLinesSV__c.getRecordTypeInfosByName().get('Software_Specialist_Lines').getRecordTypeId();
        o.Architecture_Specialist_Record_Type__c = [SELECT Id, DeveloperName,name, SobjectType FROM RecordType where sobjectType = 'OpportunityLinesSV__c'  and DeveloperName = 'Architecture_and_Incubation_Specialist_Lines'].Id;
         o.Software_Specialist_Record_Type__c = [SELECT Id, DeveloperName,name, SobjectType FROM RecordType where sobjectType = 'OpportunityLinesSV__c'  and DeveloperName = 'Software_Specialist_Lines'].Id;  
        insert o;
        
        Deal_ID_Queue__c dealIdQ = new Deal_ID_Queue__c();
        dealIdQ.name ='Deal ID Queue 1';
        dealIdQ.Deal_ID_Queue_Start__c = 32;
        dealIdQ.Deal_ID_Queue_Stop__c = 120;
        insert dealIdQ;
        
        Org_Constants__c os =new Org_Constants__c();
        os.Key__c = 'Oppty: ProfileIds to skip Triggers';
        os.non_prod_value__c = '00e30000000dcbfAAA,00e30000000dfUEAAY,00e30000000eca0AAA,00e30000000qiJjAAI,00e30000000dcbgAAA,00e30000000rrZwAAI';
        os.Prod_LT__c = 'GSTS,Data_Migration,Integration_Echo_Suppression,GSTS_Analyst,ADMIN, PSS';
        os.prod_value__c = '00e30000000dcbfAAA,00e30000000dfUEAAY,00e30000000eca0AAA,00e30000000qiJjAAI,00e30000000dcbgAAA,00e30000000rrZwAAI';
        os.Type__c = 'URL';
        insert os;
        
        Org_Constant_CS__c os1 =new Org_Constant_CS__c();
        os1.Name = 'CRMDBPermissionSets';
        String val = Userinfo.getOrganizationId();
        os1.Production_Value__c = val + ',' + val;
        os1.Non_Production_Value__c = val + ',' + val;
        insert os1;
        
        Org_Constant_CS__c os2 =new Org_Constant_CS__c();
        os2.Name = 'NGCC_LDR_BDR_Permission_Set';
        os2.Production_Value__c = 'NGCC_DRR';
        os2.Non_Production_Value__c = 'NGCC_DRR';
        insert os2;
        
        Org_Constant_CS__c os10 =new Org_Constant_CS__c();
        os10.Name = 'Resource Assignement Statuses';
        os10.Production_Value__c = 'Assigned,Declined - Approved,Declined - Pending,Direct Assignment,Requested';
        os10.Non_Production_Value__c = 'Assigned,Declined - Approved,Declined - Pending,Direct Assignment,Requested';
        insert os10;
        
        ProfileID__c pf = new ProfileID__c();
        pf.Cisco_Renewals__c = '00ec0000000QmlF';
        pf.Cisco_PSS__c = '00e30000000rrZw';       
        insert pf;
    }
    
    public static Resource_Request_Assignment__c createSingleResourceRqstAssgmnt(Id opptyId,Id userId) {
        Resource_Request_Assignment__c resourceReqAssign = new Resource_Request_Assignment__c(Opportunity_Name__c = opptyId,
                                                                             Resource_Name__c =userId,
                                                                             Assignment_Type__c='Partner Secondary');
        return resourceReqAssign; 
    }
}