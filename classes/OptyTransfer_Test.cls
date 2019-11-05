@isTest(SeeAllData=True)
private class OptyTransfer_Test {
    public static testMethod void testData(){
 /*       //Load Org_Constant_CS__c custom settings records from static resource
        List<sObject> lsOrgConstantCs = Test.loadData(Org_Constant_CS__c.sObjectType, 'TestOrgConstantCS');
        List<sObject> lsOrgConstants = Test.loadData(Org_Constants__c.sObjectType, 'OrgConstants');
        //List<sObject> lsOrgApexBatchJob = Test.loadData(Apex_Batch_Job__c.sObjectType, 'TestApexBatchJob');
        insert new ObjectRecordTypeIds__c(Opportunity_Parent_RecordTypeId__c ='0123000000003yk', Opportunity_Phase_RecordTypeId__c ='012300000000CDL', Opportunity_Parent_Mobile_RecordTypeId__c ='0123000000003yk', Opportunity_Void_Merged_RecordTypeId__c = '012800000002e0M');        
        insert new Apex_Batch_Job__c(name='StoS1OptyQuery',TimeStamp__c=Date.Today()-5);        
        insert new Apex_Batch_Job__c(name='closedate',Date_TimeStamp__c=Date.Today()-5);  
 */ 
         Test.startTest();          
            
        Account a32= new Account(name='Test Account',BillingCity='San Francisco');
        insert a32;
        
        PartnerNetworkConnection networkConn =[select Id from PartnerNetworkConnection where ConnectionName = 'Services One' and ConnectionStatus = 'Accepted']; 
        PartnerNetworkRecordConnection newConnection1 = new PartnerNetworkRecordConnection(ConnectionId = networkConn.Id, LocalRecordId = a32.Id,RelatedRecords='Opportunity',SendClosedTasks=true);
        try{
         insert newConnection1; 
        }catch(Exception e){
        } 
        
         Account acc = [select id ,name from Account where id=:a32.id];
         
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        Id RecordTypeIdopportunity = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Parent Opportunity').getRecordTypeId();  
        List<opportunity> opplist1 = new List<opportunity>();
        
        for(integer i=0;i<2;i++){
        opportunity opp = new opportunity();
        opp.Accountid = acc.id;
        opp.Theater__c = 'Americas-Canada';
        opp.recordtypeid=RecordTypeIdopportunity ;
        opp.Name= 'TestAccount';
        opp.StageName ='2 - Qualification';
        opp.CloseDate= System.today() + 50;
        opp.Expected_Product__c=10.0;
        opp.error_description__c='error';
        opp.DealID__c='18022972';
        opp.Opportunity_Status__c='active';
        opp.Position__c='Americas lrpearso';
        opp.CurrencyIsoCode = 'USD';  
        opplist1.add(opp);
        } 
        insert opplist1 ;
        
        opportunity oppty = [select id ,name, DealID_Utilized__c,IsDeleted,Past_Due_Days__c  from opportunity where id=:opplist1[0].id]; 
        
        
        Product2 prod = new Product2(Name = 'Laptop X200', Family = 'Hardware',isActive=true,ProductCode='AS-200');
        insert prod;
        
        PricebookEntry pbID = new PricebookEntry(
        Pricebook2Id = customPB.Id, Product2Id = prod.Id,
        UnitPrice = 12000, IsActive = true);
        insert pbID;
        
        OpportunityLineItem olli = new OpportunityLineItem (Quantity=2, OpportunityId=opplist1[0].Id, TotalPrice=10, PriceBookEntryId =pbID.Id,business_Entity__c='AS-S',Opportunity_Line_Value__c = 100); 
        insert olli ;
        
        PartnerNetworkRecordConnection newConnection2 = new PartnerNetworkRecordConnection(ConnectionId = networkConn.Id, LocalRecordId = opplist1[0].Id,ParentRecordId=a32.id,RelatedRecords=olli.id);
        try{
        insert newConnection2;
        }catch(Exception e){}
        
        Set<String> phaseOptyIds = new Set<String>();
        phaseOptyIds.add(opplist1[0].DealId__c);
        
        Set<Id> parentIds = new Set<ID>();
        parentIds.add(opplist1[0].id);
        try{  
            OptyTransferBatch obj = new OptyTransferBatch(); 
            DataBase.executeBatch(obj,50);              
            obj.shareOpportunities(phaseOptyIds,parentIds,networkConn.Id);
            obj.addsareReecordToList(networkConn.Id,opplist1[0].id);
            obj.addReecordToList(networkConn.Id, opplist1[0].id, acc.id);
            OptyTransferBatch.flsUpdateGet(Opportunity.AccountId);
        }catch(Exception e){}
        Test.stopTest();   
    
    }
}