@isTest(seeAllData=true)
private class  EngageCaseSharingBatch_Test {

    public static testMethod void testDataToLoad(){
        //Load Org_Constant_CS__c custom settings records from static resource
        /*List<sObject> lsOrgConstantCs = Test.loadData(Org_Constant_CS__c.sObjectType, 'TestOrgConstantCS');
        List<sObject> lsOrgConstants = Test.loadData(Org_Constants__c.sObjectType, 'OrgConstants');
        insert new ObjectRecordTypeIds__c(Opportunity_Parent_Mobile_RecordTypeId__c ='0123000000003yk', Opportunity_Void_Merged_RecordTypeId__c = '012800000002e0M',Engage_Services_Resources__c = '0125B0000008jn6');        
        insert new Apex_Batch_Job__c(name='closedate',Date_TimeStamp__c=Date.Today()-5); 
        insert new Apex_Batch_Job__c(name='EngageCaseTimestamp',TimeStamp__c=Date.Today()-5);       
        */
        //load custom settings
        User u = new User(Id = UserInfo.getUserId());

        List<Profile> pList = [SELECT Id FROM Profile WHERE Name = 'Cisco_ADMIN' OR Name = 'Cisco_Japan' ORDER BY Name ASC limit 2];
        List<User> users = new List<User>();

        For(Integer i=0;i<pList.size();i++){
           User usr = new User(Alias = 'testusr'+(i+1),Email = 'testusr'+(i+1)+'@cisco.com.test',EmailEncodingKey = 'UTF-8',LastName = 'Test'+(i+1),FirstName = 'cecid',Organization__c = 'Test'+(i+1),LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US',ProfileId = pList[i].Id,CommunityNickname = 'testusr'+(i+1),TimeZoneSidKey = 'America/Los_Angeles',UserName = 'testusr'+(i+1)+'@cisco.com.test',Theatre__c = 'Americas-Canada');
           users.add(usr);
        }
        
        System.runAs (u) {
            List<Org_Constant_CS__c> orgConstant = new List<Org_Constant_CS__c>();
            orgConstant.add(new Org_Constant_CS__c(Name='Support Profiles',Non_Production_Value__c='00e30000000dcbfAAA,00e30000000dfUEAAY,00e30000000eca0AAA,00e30000000qiJjAAI,00e30000000dcbgAAA,00e30000000r9dqAAA,04P0q000000CaSjEAK',Production_Value__c='00e30000000dcbfAAA,00e30000000dfUEAAY,00e30000000eca0AAA,00e30000000qiJjAAI,00e30000000dcbgAAA,00e30000000r9dqAAA,04P34000000Gn2iEAC'));
            orgConstant.add(new Org_Constant_CS__c(Name='ServiceOneConnectionID',Non_Production_Value__c='04P0q000000CaSjEAK',Production_Value__c='04P34000000Gn2iEAC'));
            //INSERT orgConstant;
            INSERT users;
        }
    
         PartnerNetworkConnection networkConn =[select Id from PartnerNetworkConnection where ConnectionName = 'Services One' and ConnectionStatus = 'Accepted'];
    //  string networkId = Utilities.getConstant_CS('ServiceOneConnectionID'); 
     
        String engageCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AS Pre Sales Engagement Request').getRecordTypeId();
        String ParentRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Parent Opportunity').getRecordTypeId();

        List<Account> accList = new List<Account>(); 
        List<Opportunity> oppList = new List<Opportunity>();
        List<Case> caseList = new List<Case>();
        
        Account acc = new Account(Name='Acme1', BillingCity='San Francisco'); 
        INSERT acc;
        Account acc1 = new Account(Name='Acme2', BillingCity='San Francisco'); 
        INSERT acc1;
        accList.add(acc);
        accList.addAll([SELECT id, name from Account WHERE id IN(SELECT LocalRecordId FROM PartnerNetworkRecordConnection WHERE ConnectionId = :networkConn.Id AND Status='Sent') LIMIT 20]);
        //String accid;
        if(accList.size()<2){
           accList.add(acc1);           
        }
       
       
            Opportunity opty1 = new Opportunity(dealid__c= 'B111',Name= 'TestT1',AccountId=  accList[0].Id,StageName= '2 - Qualification',CloseDate= system.today().adddays(2),CurrencyIsoCode= 'USD',expected_product__c= 0,expected_service__c= 10,forecast_status__c= 'test',Non_Standard_Terms_and_Conditions__c = 'None',recordtypeid= ParentRecordTypeId,Service_Source__c= 'New',ownerId= users[0].Id,Opportunity_Owner_AM__c= users[0].Id,Close_Probability__c= 75);
            Opportunity opty2 = new Opportunity(dealid__c= 'B112',Name= 'TestT2',AccountId=  accList[1].Id,StageName= '2 - Qualification',CloseDate= system.today().adddays(2),CurrencyIsoCode= 'USD',expected_product__c= 0,expected_service__c= 10,forecast_status__c= 'test',Non_Standard_Terms_and_Conditions__c = 'None',recordtypeid= ParentRecordTypeId,Service_Source__c= 'New',ownerId= users[0].Id,Opportunity_Owner_AM__c= users[0].Id,Close_Probability__c= 75);       
            
            oppList.add(opty1);
            oppList.add(opty2);
            try{
            Insert oppList;
            }
            catch(DMLException e){
            System.debug('Error========>'+e.getMessage());}
        oppList.addAll([SELECT id, name from Opportunity WHERE id IN(SELECT LocalRecordId FROM PartnerNetworkRecordConnection WHERE ConnectionId = :networkConn.Id AND Status='Sent') LIMIT 20]);
          //string opID;
          Opportunity opty3 = new Opportunity(dealid__c= 'B113',Name= 'TestT3',AccountId=  accList[0].Id,StageName= '2 - Qualification',CloseDate= system.today().adddays(2),CurrencyIsoCode= 'USD',expected_product__c= 0,expected_service__c= 10,forecast_status__c= 'test',Non_Standard_Terms_and_Conditions__c = 'None',recordtypeid= ParentRecordTypeId,Service_Source__c= 'New',ownerId= users[0].Id,Opportunity_Owner_AM__c= users[0].Id,Close_Probability__c= 75);       
          Opportunity opty4 = new Opportunity(dealid__c= 'B114',Name= 'TestT4',AccountId=  accList[1].Id,StageName= '2 - Qualification',CloseDate= system.today().adddays(2),CurrencyIsoCode= 'USD',expected_product__c= 0,expected_service__c= 10,forecast_status__c= 'test',Non_Standard_Terms_and_Conditions__c = 'None',recordtypeid= ParentRecordTypeId,Service_Source__c= 'New',ownerId= users[0].Id,Opportunity_Owner_AM__c= users[0].Id,Close_Probability__c= 75);       
          if(oppList.size() < 3){
          oppList.add(opty3);
          oppList.add(opty4);
          
          }
        Opportunity phaseOpportunity = new Opportunity(dealid__c= oppList[1].dealid__c ,Name= 'TestT2',AccountId=  accList[1].Id,StageName= '2 - Qualification',CloseDate= system.today().adddays(2),CurrencyIsoCode= 'USD',expected_product__c= 0,expected_service__c= 10,forecast_status__c= 'test',Non_Standard_Terms_and_Conditions__c = 'None', Service_Source__c= 'New',ownerId= users[0].Id,Opportunity_Owner_AM__c= users[0].Id,Close_Probability__c= 75,Parent_Id__c= oppList[1].Id);
        INSERT phaseOpportunity;      

        AT_Workspace__c Workspace = new AT_Workspace__c( AT_Technology__c= 'UC', AT_Expected_Product__c= 1, PSS__c= UserInfo.getUserId(), AT_Expected_Book_Date__c = System.today(), AT_Forecast_Status__c= 'Upside', Opportunity__c= oppList[0].Id, AT_Team__c= 'test', Sync_With_Opportunity__c = true); 
        INSERT Workspace;
        
        //for(Integer k=0;k<4;k++){
          Case engCs = new Case(Opportunity__c = oppList[0].Id, Status= 'Draft', RecordTypeId= engageCaseRecordTypeId, Country_Where_Services_will_be_Deliver__c = 'Africa', Theatre_Where_Service_will_be_Delivered__c = 'Americas', Region_Where__c = 'LATAM', Theatre__c = 'Americas', Does_This_Deal_Contain_a_Multi_Element_A__c = 'No');      
          caseList.add(engCs) ;
        //}        
       INSERT caseList;
       Case engCs1 = new Case(Opportunity__c = oppList[1].Id, Status= 'Draft', RecordTypeId= engageCaseRecordTypeId, Country_Where_Services_will_be_Deliver__c = 'Africa', Theatre_Where_Service_will_be_Delivered__c = 'Americas', Region_Where__c = 'LATAM', Theatre__c = 'Americas', Does_This_Deal_Contain_a_Multi_Element_A__c = 'No');     
       INSERT engCs1; 
       
        PartnerNetworkRecordConnection networkConnRecord1 =new PartnerNetworkRecordConnection();
        networkConnRecord1 .ConnectionId = networkConn.Id ;
        networkConnRecord1 .LocalRecordId = caseList[0].Id;
        networkConnRecord1 .parentRecordId= oppList[0].Id;
   //     networkConnRecord1 .LocalRecordId = caseList[0].Id;
        try{
            insert networkConnRecord1;
        }catch(Exception e){ }  
        
        Test.StartTest();
        
        EngageCaseSharingBatch css = new EngageCaseSharingBatch(); 
        Database.executeBatch(css,2000);  
        Map<Id, Case> mapcase= new Map<Id, Case>([SELECT Id, Opportunity__c FROM Case Where ID IN :caseList]);           
       
        try{
                css.shareWorkspceTech(new Set<String>{oppList[0].dealid__c}, networkConn.Id );
        }catch(Exception e){}
        try{ 
                css.shareCaseOpty(mapCase, new Set<Id>{caseList[0].Opportunity__c,caseList[1].Opportunity__c,caseList[2].Opportunity__c}, new Set<Id>{caseList[0].AccountId,caseList[1].AccountId,caseList[2].AccountId},networkConn.Id);             
        }catch(exception e){ }   
         
        SO_BatchUtilityClass.flsUpdateGet(Opportunity.AccountId);
        ScheduleCaseShareSOneBatchApex CaseBatchSchedule = new ScheduleCaseShareSOneBatchApex();
        system.schedule('Case JOB1', '0 0 * * * ?', CaseBatchSchedule );
        Test.StopTest();          
    }   
}