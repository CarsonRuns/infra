@isTest(seeAllData=true)
private class  ASWorkspaceSharingBatch_Test {

    public static testMethod void testDataToLoad(){
        //Load Org_Constant_CS__c custom settings records from static resource
/*       
        insert new Apex_Batch_Job__c(name='closedate',Date_TimeStamp__c=Date.Today()-5); 
        insert new Apex_Batch_Job__c(name='EngageCaseTimestamp',TimeStamp__c=Date.Today()-5);       
 */      
        //load custom settings
        User u = new User(Id = UserInfo.getUserId());

        List<Profile> pList = [SELECT Id FROM Profile WHERE Name = 'Cisco_ADMIN' OR Name = 'Cisco_Japan' ORDER BY Name ASC limit 2];
        List<User> users = new List<User>();

        For(Integer i=0;i<pList.size();i++){
           User usr = new User(Alias = 'testusr'+(i+1),
                               Email = 'testusr'+(i+1)+'@cisco.com.test',
                               EmailEncodingKey = 'UTF-8',
                               LastName = 'Test'+(i+1),
                               FirstName = 'cecid',
                               Organization__c = 'Test'+(i+1),
                               LanguageLocaleKey = 'en_US',
                               LocaleSidKey = 'en_US',
                               ProfileId = pList[i].Id,
                               CommunityNickname = 'testusr'+(i+1),
                               TimeZoneSidKey = 'America/Los_Angeles',
                               UserName = 'testusr'+(i+1)+'@cisco.com.test',
                               Theatre__c = 'Americas-Canada');
           users.add(usr);
        }
        
        System.runAs (u) {
            List<Org_Constant_CS__c> orgConstant = new List<Org_Constant_CS__c>();
            orgConstant.add(new Org_Constant_CS__c(Name='ServiceOneConnectionID',Non_Production_Value__c='04P0q000000CaSjEAK',Production_Value__c='04P34000000Gn2iEAC'));
//          INSERT orgConstant;
            INSERT users;
        }
    
         PartnerNetworkConnection networkConn =[select Id from PartnerNetworkConnection where ConnectionName = 'Services One' and ConnectionStatus = 'Accepted'];
    //  string networkId = Utilities.getConstant_CS('ServiceOneConnectionID'); 
     
        String ParentRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Parent Opportunity').getRecordTypeId();

        List<Account> accList = new List<Account>(); 
        List<Opportunity> oppList = new List<Opportunity>();
        List<AT_Workspace__c> WorkspaceList = new List<AT_Workspace__c>();
        List<Workspace_Technology__c> WorkspaceTechList = new List<Workspace_Technology__c>();
        
        Account acc = new Account(Name='Acme1', BillingCity='San Francisco'); 
        INSERT acc;
        accList.add(acc);
        accList.addAll([SELECT id, name from Account WHERE id IN(SELECT LocalRecordId FROM PartnerNetworkRecordConnection WHERE ConnectionId = :networkConn.Id AND Status='Sent') LIMIT 3]);
        integer accloopcount =0;
        if(accList.size()==1){
          accloopcount =1;
        }else{
          accloopcount =2;
        }
        
        for(Integer j=0;j<accloopcount ;j++){
        
           if(accList.size()>0){
           
            Opportunity opty = new Opportunity(dealid__c= 'B11'+(j+1),
                                               Name= 'TestT'+(j+1),
                                               AccountId=  accList[j].Id,
                                               StageName= '2 - Qualification',
                                               CloseDate= system.today().adddays(2),
                                               CurrencyIsoCode= 'USD',
                                               expected_product__c= 0,
                                               expected_service__c= 10,
                                               forecast_status__c= 'test',
                                               Non_Standard_Terms_and_Conditions__c = 'None',
                                               recordtypeid= ParentRecordTypeId,
                                               Service_Source__c= 'New',
                                               ownerId= users[0].Id,
                                               Opportunity_Owner_AM__c= users[0].Id,
                                               Close_Probability__c= 75
                                               );       
            INSERT opty;
            
            oppList.add(opty);
            }
        }
        oppList.addAll([SELECT id, name from Opportunity WHERE id IN(SELECT LocalRecordId FROM PartnerNetworkRecordConnection WHERE ConnectionId = :networkConn.Id AND Status='Sent') LIMIT 3]);
  
         integer opploopcount =0;
        if(oppList.size()==1){
          opploopcount =1;
        }else{
          opploopcount =4;
        }
        
        if(accList.size()>1){
          Opportunity phaseOpportunity = new Opportunity(dealid__c= oppList[1].dealid__c ,
                                                       Name= 'TestT2',
                                                       AccountId=  accList[1].Id,
                                                       StageName= '2 - Qualification',
                                                       CloseDate= system.today().adddays(2),
                                                       CurrencyIsoCode= 'USD',
                                                       expected_product__c= 0,
                                                       expected_service__c= 10,
                                                       forecast_status__c= 'test',
                                                       Non_Standard_Terms_and_Conditions__c = 'None', 
                                                       Service_Source__c= 'New',
                                                       ownerId= users[0].Id,
                                                       Opportunity_Owner_AM__c= users[0].Id,
                                                       Close_Probability__c= 75,
                                                       Parent_Id__c= oppList[1].Id
                                                       );
         INSERT phaseOpportunity;      
        }
        for(Integer K=0;k<opploopcount ;k++){
        
         if(oppList.size()>0){
           AT_Workspace__c Workspace = new AT_Workspace__c( AT_Technology__c= 'UC', 
                                                            AT_Expected_Product__c= 1, 
                                                            PSS__c= UserInfo.getUserId(), 
                                                            AT_Expected_Book_Date__c = System.today(), 
                                                            AT_Forecast_Status__c= 'Upside', 
                                                            Opportunity__c= oppList[k].Id, 
                                                            AT_Team__c= 'test', 
                                                            Sync_With_Opportunity__c = true
                                                            ); 
              WorkspaceList.add(Workspace);
           }
        }
        INSERT WorkspaceList;
        
        for(Integer l=0;l<opploopcount ;l++){
          Workspace_Technology__c wrksptech= new Workspace_Technology__c(Workspace__c = WorkspaceList[l].Id, 
                                                                         business_Entity__c = 'CSS-Security Services', 
                                                                         Expected_000__c = 100
                                                                         );
          WorkspaceTechList.add(wrksptech);
       }        
        INSERT WorkspaceTechList;
        
        if(WorkspaceTechList.size()>3){  
                PartnerNetworkRecordConnection networkConnRecord1 =new PartnerNetworkRecordConnection();
                networkConnRecord1 .ConnectionId = networkConn.Id ;
                networkConnRecord1 .LocalRecordId = WorkspaceTechList[3].Id;
                try{
                    insert networkConnRecord1;
                }catch(Exception e){ }  
        }
        Test.StartTest();
            
            ASWorkspaceSharingBatch ASWrksp = new ASWorkspaceSharingBatch();
            Database.executeBatch(ASWrksp);            
            Set<Id> workspIdSet = new Set<Id>();
            Set<String> dealIdSet = new Set<String>();
            
            for(AT_Workspace__c wrksp :[SELECT ID, Opportunity__c FROM AT_Workspace__c Where Id IN :WorkspaceList]){
               workspIdSet.add(wrksp.Id);
            }
            for(Opportunity opp :[SELECT ID, dealid__c FROM Opportunity Where Id IN :OppList]){
               dealIdSet.add(opp.dealid__c);
            }
            
          try{
                ASWrksp.shareWorkspaceTechForSharedWorkspace(workspIdSet, networkConn.Id  );
            }catch(Exception e){}
            try{ 
               ASWrksp.shareRelatedOpty(dealIdSet, networkConn.Id,  new Set<Id>{oppList[1].AccountId});             
              }catch(exception e){
            }   
            Test.StopTest();          
    }   
}