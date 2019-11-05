@isTest(seeAllData=true)
public class BatchOneTimeWorkspace_Test {
    static testMethod void BatchOW() {  
    /*          
         List < sObject > osData = Test.loadData(Org_Constant_CS__c.sObjectType,'OrgConstantCS_data');
         List < sObject > osCSData = Test.loadData(Org_Constants__c.sObjectType,'OrgConstants');
         List < sObject > objRecTypeData = Test.loadData(ObjectRecordTypeIds__c.sObjectType,'ObjectRecordTypeIds');
    */              
      
         Account a = new Account(Name='Acme1', BillingCity='San Francisco', RecordtypeId =Utilities.getAccountEndUserRecordTypeId()); 
         insert a;  
        
        List < Opportunity > lstOppty = new List < Opportunity >();
        for(Integer i=0;i<5;i++){
            Opportunity oppty = new Opportunity();  
            oppty.dealid__c= 'B11'+(i+1);
            oppty.Oppty_Workspace_Based_Sharing__c='test';
            oppty.Name= 'TestT'+(i+1);
            oppty.AccountId=  a.Id;
            oppty.StageName= '2 - Qualification';
            oppty.CloseDate= system.today().adddays(2);
            oppty.CurrencyIsoCode= 'USD';
            oppty.expected_product__c= 0;
            oppty.expected_service__c= 10;
            oppty.forecast_status__c= 'test1';
            oppty.Non_Standard_Terms_and_Conditions__c = 'None';
            oppty.Service_Source__c= 'New';
            oppty.Close_Probability__c= 75;
            oppty.Opportunity_Status__c='Active';       
        lstOppty.add(oppty);
        }
        insert lstOppty; 
        
        List < AT_Workspace__c > lstATWS = new List < AT_Workspace__c >();
        for(Opportunity opp:lstOppty){                    
             //   AT_Workspace__c aWS = new AT_Workspace__c(name='test',Is_Multi_Tech__c = true,Opportunity__c=opp.Id);
                 AT_Workspace__c aWS = new AT_Workspace__c();
                 aWS.opportunity__c = opp.Id ; 
                 aWS.AT_Expected_Product__c= 15.0;
                 aWS.AT_Forecast_Status__c ='Upside';
                 aWS.AT_Optional_2__c ='15340';
                 aWS.AT_Team__c ='Securent-Theater';
                lstATWS.add(aWS);
         }            
         insert lstATWS;    
               
        PartnerNetworkConnection networkConn =[select Id from PartnerNetworkConnection where ConnectionName = 'Services One' and ConnectionStatus = 'Accepted']; 
        
        
        List<Workspace_Technology__c> wTechnologies = new List<Workspace_Technology__c>();
        for(AT_Workspace__c at:lstATWS){ 
            Workspace_Technology__c wt = new Workspace_Technology__c();
            wt.Business_Entity__c='SECURITY';
            wt.Business_Sub_Entity__c='Analytics';
            wt.Workspace__c=at.id;
            wt.Expected_000__c=1000;            
            wTechnologies.add(wt);
        }    
        insert wTechnologies;
        
         
         List<PartnerNetworkRecordConnection> insertWrkspcRecordCon = new List<PartnerNetworkRecordConnection>();
         
         for(Workspace_Technology__c  wrksptech :wTechnologies){
           PartnerNetworkRecordConnection newRecordConnection = new PartnerNetworkRecordConnection(ConnectionId = networkConn.Id, 
                                                                                                   LocalRecordId = wrksptech.Id  ,
                                                                                                   SendClosedTasks=true);
           insertWrkspcRecordCon.add(newRecordConnection ); 
         }
         try{
          INSERT insertWrkspcRecordCon;
          }catch(Exception e){}
         
        Test.startTest(); 
            BatchOneTimeWorkspace obj = new BatchOneTimeWorkspace();
            DataBase.executeBatch(obj);  
            obj.createRecordsAndLog(insertWrkspcRecordCon); 
            obj.addRecordstoList(networkConn.Id, wTechnologies[0].Id,lstATWS[0].id);          
        Test.stopTest();        
    }
}