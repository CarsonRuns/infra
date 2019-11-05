/************************************************************************************************************************************
Name    : Oppty_OpptyWorkspace_BatchUpdate 
Author  : Mukesh Srivastava
Purpose : This Test class are to validate Oppty_OpptyWorkspace_BatchUpdate sharing 
Created Date: 1/19/2017
Modification History: 

*************************************************************************************************************************************/
@isTest
public class Oppty_OpptyWorkspace_BatchUpdate_Test{
    //Setting Up data for This test class
    @testSetup static void setupTestData() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Cisco_Admin' Limit 1];
        User uAdmin = new User(Additional_User_Permissions__c = 'Enable EndUser ACCTCreation', Alias = 'newUser', Email = 'batchJobOppty@cisco.com',
                               EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                               LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'batchJobOppty@cisco.com.testing', Theatre__c = 'Americas-US Commercial');
		
        //added by ratharik
            Profile pList1 = [SELECT Id FROM Profile WHERE Name ='Cisco_Renewals' limit 1];
        	Profile pList2 = [SELECT Id FROM Profile WHERE Name ='zzDont_USE_Cisco_PSS' limit 1];
            ProfileID__c pf = new ProfileID__c();
            pf.Cisco_Renewals__c = String.valueOf(pList1.Id).substring(0, 15);
            pf.Cisco_PSS__c = String.valueOf(pList2.Id).substring(0, 15);    
            insert pf;
        
        
        system.RunAs(uAdmin){   
            List < sObject > osData = Test.loadData(Org_Constant_CS__c.sObjectType,'OrgConstantCS_data');
            List < sObject > osCSData = Test.loadData(Org_Constants__c.sObjectType,'OrgConstants');
            List < sObject > objRecTypeData = Test.loadData(ObjectRecordTypeIds__c.sObjectType,'ObjectRecordTypeIds');
            List < sObject > apexJob = Test.loadData(Apex_Batch_Job__c.sObjectType, 'OpptyWorkspaceUpdates_ApexJobs'); //Creating ApexJob
            List < Opportunity > lstOppty = new List < Opportunity >();
            List < AT_Workspace__c > lstATWS = new List < AT_Workspace__c >();
            
            Account a = new Account(name='TestBatchAccount',RecordtypeId =Utilities.getAccountEndUserRecordTypeId());
            insert a;  
            
            for(Integer i=0;i<20;i++){
                Opportunity oppty;
                if(i==2){                
                    oppty = new Opportunity(name ='Test' , Oppty_Workspace_Based_Sharing__c='test',accountId = a.Id,stagename ='1 - Prospect',closedate = system.today());
                }else{
                    oppty = new Opportunity(name ='Test' , accountId = a.Id,stagename ='1 - Prospect',closedate = system.today());
                }
                
                lstOppty.add(oppty);
            }
            insert lstOppty; 
            
            Map<String,Apex_Batch_Job__c> apexJobMap = Apex_Batch_Job__c.getall();
            
            String strOppty_WS_Keys = apexJobMap.get('Oppty_WS_Keys').query__c;
            String[] arrOppty_WS_Keys = strOppty_WS_Keys.split(',');
            Map<String,String> mapOppty_WS_Keys = new map<String,String>();
            for(String str:arrOppty_WS_Keys){
                mapOppty_WS_Keys.put(str.split(':')[0],str.split(':')[1]);
            }
            Integer i=0;
            for(Opportunity opp: [Select Id from Opportunity Limit 20]){
                for(String key : mapOppty_WS_Keys.keySet()){
                    String newValue = mapOppty_WS_Keys.get(key);
                    String[] arrNewVal =  newValue.split('_');
                    
                    AT_Workspace__c aWS = new AT_Workspace__c(name='test',Is_Multi_Tech__c = true,Opportunity__c=opp.Id,AT_Team__c=key,Software_Buying_Model__c='Flex EA (Collab Only)');
                    lstATWS.add(aWS);
                }
            }            
            system.debug(lstATWS);
            insert lstATWS;            
        }        
    }
    
    //@ Testing Oppty_OpptyWorkspace_BatchUpdate batch class for making sure Eloqua details are copied to Duplicate leads
    static testMethod void testLeadScoreBatchUpdate() {
        Test.startTest();
            Map<String,Apex_Batch_Job__c> apexJob = Apex_Batch_Job__c.getall();
            
            Oppty_OpptyWorkspace_BatchUpdate opptyWSUpdate = new Oppty_OpptyWorkspace_BatchUpdate();
            Id batchinstanceid;
            batchinstanceid = database.executeBatch(opptyWSUpdate, 20);        
        Test.stopTest();
    }
}