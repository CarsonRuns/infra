@isTest(seeAllData=true)
Public class AccTransferBatchTest{
    public static testMethod void accBatchTest()
    {        
     
        //List < sObject > osData = Test.loadData(Org_Constant_CS__c.sObjectType,'OrgConstantCS_data');
        //List < sObject > osCSData = Test.loadData(Org_Constants__c.sObjectType,'OrgConstants');
        //List < sObject > objRecTypeData = Test.loadData(ObjectRecordTypeIds__c.sObjectType,'ObjectRecordTypeIds');
         
        Account acc = new Account();
        acc.name = 'TestAccount123';
        insert acc;
        
        opportunity opp = new opportunity();
        opp.Accountid = acc.id;
        opp.Name= 'TestAccount';
        opp.StageName ='2 - Qualification';
        opp.CloseDate= System.today() + 50;
        opp.Expected_Product__c=10.0;
        opp.error_description__c='error';
        opp.DealID__c='1321';
        opp.Opportunity_Status__c='Active';
        opp.Position__c='Americas lrpearso';
        insert opp;
          
        //opportunity oppty = [select id ,name, DealID_Utilized__c,IsDeleted,Past_Due_Days__c  from opportunity where id=:opp.id];
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        //Id pricebookId = Test.getStandardPricebookId();
        
        Product2 prod = new Product2(Name = 'AS-S-ANALYTICS SVCS', Business_Entity__c = 'AS-S',CurrencyIsoCode='USD', Service_Category__c ='ASS-ADVANCED SERVICES SUBSCRIPTION',isActive=true,ProductCode='Service',Service_Program__c='AS-S-ANALYTICS SVCS',Unique_BE_SubBE__c ='ASS-ADVANCED SERVICES SUBSCRIPTION-AS SUBSCRIPTION-AS-S-ANALYTICS SVCS-Service');
        insert prod;
        
        PricebookEntry pbID = new PricebookEntry(
        Pricebook2Id=customPB.Id,Product2Id = prod.Id,
        UnitPrice = 12000, IsActive = true,
        BE_Sub_BE_Currency_ProductCode__c='AS-S-ANALYTICS SVCS-USD-Service1');
        Upsert pbID;
        
        OpportunityLineItem optylneItm = new OpportunityLineItem(
            OpportunityId = opp.id,
            Business_Entity__c ='AS-S',
            Product_Family__c =null,
            PricebookEntryId  = pbID.Id,
            Mix__c=100.0,
            Opportunity_Line_Value__c = 100           
            
        );       
        insert optylneItm;
       //system.assertEquals(opp.DealID_Utilized__c ,'Yes');
       //system.assertEquals(opp.IsDeleted,false);
        
        PartnerNetworkConnection networkConn =[select Id from PartnerNetworkConnection where ConnectionName = 'Services One' and ConnectionStatus = 'Accepted']; 
        List<PartnerNetworkRecordConnection> partnetlist = new List<PartnerNetworkRecordConnection>();
        PartnerNetworkRecordConnection newConnection = new PartnerNetworkRecordConnection(ConnectionId = networkConn.Id, LocalRecordId = acc.Id);
        try{
         insert newConnection;
         }catch(Exception e){
         }
        partnetlist.add(newConnection);
       
        Test.startTest();
        AccTransferBatch atb = new AccTransferBatch();
        DataBase.executeBatch(atb); 
        AccTransferBatch.flsUpdateGet(Opportunity.AccountId);
        AccTransferBatch.flsCreateGet(Opportunity.AccountId);
        Test.StopTest();
        try{
        atb.createRecordsAndLog(partnetlist);
        }catch(Exception e){}                 
    }
}