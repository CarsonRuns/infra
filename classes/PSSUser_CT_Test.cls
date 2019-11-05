@isTest(SeeAllData=true)
public class PSSUser_CT_Test {

    public static testMethod void test_PSSUser_CT()
    {
        DATE vCloseDate=system.today();
        // Cisco_US_Commercial User
        Profile p1 = [SELECT Id FROM profile WHERE name='Cisco_ADMIN'];
          
        User opptyOwner= new User(alias = 'newUser1',email='newuser1@cisco.com',emailencodingkey='UTF-8', lastname='Testing',languagelocalekey='en_US',Additional_User_Permissions__c='SE User',localesidkey='en_US', profileid = p1.Id,timezonesidkey='America/Los_Angeles',Theatre__c='Americas-US Commercial', username='newuser1@cisco.com', BA_Territories__c = 'test,sec_1');
        insert opptyOwner;
         
         // New Opportunity
        Opportunity o = new Opportunity(Forecast_Status__c='Upside', Lost_Cancelled_Reason__c='-', 
            Opportunity_Status__c='Active', Expected_Product__c=2,Expected_Service__c=3, OwnerId=opptyOwner.Id,
            Opportunity_Owner_AM__c=opptyOwner.Id,name='abc',StageName='4 - Agreement',Competitors__c='test', CloseDate= vCloseDate.adddays(2));
        insert o;
        
        AT_Workspace__c temp = new AT_Workspace__c(Name='test',Workspace_Lost_Cancelled_Reason__c='-',
               PSS_Workspace_Status__c='Active',Opportunity__c = o.ID,Sync_With_Opportunity__c=TRUE,
               AT_Forecast_Status__c='Commit',Workspace_Stage__c ='2 - Qualification',AT_Expected_Book_Date__c = System.Today(),
               AT_Team__c = 'Cisco1',Forecast_Position_ID__c = '123',AT_Technology__c ='Optical',
               AT_Sub_Technology__c = 'Optical Router',AT_Product__c ='Optical DPT/RPR Modules');
    
        insert temp;           
              
        List<Id> ids = new List<Id>();
        ids.add(o.id);
        //OpptyFutureClass.workspaceInSync(temp);        
        OpptyFutureClass.syncWorkspaceWithOpty(ids);
        
        ApexPages.StandardController sc1 = new ApexPages.StandardController(temp);
        PSSUser_CT testcl7 = new PSSUser_CT(sc1);
        testcl7.getShowSyncChkbox();
        testcl7.save();
        testcl7.cancel();
        
        AT_Workspace__c atw = [Select Id from AT_Workspace__c where Opportunity__c =: o.Id][0];
        atw.AT_Expected_Product__c = 5000;
        atw.Is_Multi_Tech__c = false;
        upsert atw;
        
        Id i = atw.Id;
        List<Id> ids2 = new List<Id>();
        ids2.add(i);   
        OpptyFutureClass.syncWorkspaceWithOpty(ids2);
        
        testcl7.PSS.Sync_With_Opportunity__c = true;
        Opportunity newO = new Opportunity(Forecast_Status__c='Upside', Lost_Cancelled_Reason__c='-', Opportunity_Status__c='Active', Expected_Product__c=2,Expected_Service__c=3, OwnerId=opptyOwner.Id,Opportunity_Owner_AM__c=opptyOwner.Id,name='abc',StageName='2 - Qualification', CloseDate= vCloseDate.adddays(2));
        insert newO;
        testcl7.PSS.Opportunity__c = newO.id;
        testcl7.save();
        
        Apexpages.currentPage().getParameters().put('id', i);     
        Apexpages.currentPage().getParameters().put('mtOpptyId',o.ID);
        ApexPages.StandardController sc2 = new ApexPages.StandardController(temp);
        PSSUser_CT testcl8 = new PSSUser_CT(sc2);
        testcl8.reset();
        testcl8.addRow();
        Workspace_Technology__c wt2 = new Workspace_Technology__c(Workspace__c = i, Expected_000__c = 40, Business_Entity__c='COLLABORATION'); 
        testcl8.WorkspaceTechList[0] = wt2;
        //testcl8.saveMultiTech();
        testcl8.saveWorkspace();
        
        Apexpages.currentPage().getParameters().put('id', i);     
        Apexpages.currentPage().getParameters().put('CF00N30000002BozE_lkid',o.ID);
        ApexPages.StandardController sc = new ApexPages.StandardController(temp);
        PSSUser_CT testcl = new PSSUser_CT(sc);
        testcl.getShowSyncChkbox();
        testcl.getforecastLOV();
        testcl.getSubtechProd();
        testcl.getTechSubtech();
        testcl.getTechUseCase();
        testcl.tempsubtech = 'Nexus 1000';
        testcl.tempproduct = 'Nexus 1000';
        testcl.tempteam = 'Cisco1';
        testcl.PSS.AT_Technology__c = 'DCS';
        testcl.save();  
               
        o.Forecast_Status__c = 'Upside';
        upsert o; 
        
        Apexpages.currentPage().getParameters().put('isNew','true');
        PSSUser_CT testcl3 = new PSSUser_CT(sc);
        testcl3.getShowSyncChkbox();
        testcl3.getforecastLOV(); 
        
        Apexpages.currentPage().getParameters().put('id',temp.id); 
        PSSUser_CT testcl1 = new PSSUser_CT(sc);
        testcl1.getShowSyncChkbox();
        testcl1.getforecastLOV(); 
        testcl1.save();   

        Apexpages.currentPage().getParameters().put('id',null); 
        PSSUser_CT testcl2 = new PSSUser_CT(sc); 
        testcl2.getShowSyncChkbox();  
        testcl2.save(); 
        
        Apexpages.currentPage().getParameters().put('mtOpptyId',o.ID);
        PSSUser_CT testcl6 = new PSSUser_CT(sc); 
        //testcl6.getNewWorkspaceId(); 
        ApexPages.currentPage().getParameters().put('rowIndex', '0');
        ApexPages.currentPage().getParameters().put('rowToDelete', '');
        testcl6.deleteRow();     
        //testcl6.saveMultiTech(); 
        testcl6.showAllFields();
        testcl6.hideAllFields();
        testcl6.saveWorkspace();
        
        testcl6.addRow();
        Workspace_Technology__c wt = new Workspace_Technology__c(Workspace__c = temp.Id, Expected_000__c = 40, Business_Entity__c='COLLABORATION'); 
        testcl6.WorkspaceTechList[0] = wt;
        
        List <Workspace_Technology__c> li = testcl6.getWorkspaceTechs();
        testcl6.saveWorkspace();
            
    }
    
    private static testMethod void unitTestCancel(){
          DATE vCloseDate=system.today();
      // Cisco_US_Commercial User
        Profile p1 = [SELECT Id FROM profile WHERE name='Cisco_ADMIN'];
          
        User opptyOwner= new User(alias = 'newUser1',email='newuser1@cisco.com',emailencodingkey='UTF-8', lastname='Testing',languagelocalekey='en_US',Additional_User_Permissions__c='SE User',localesidkey='en_US', profileid = p1.Id,timezonesidkey='America/Los_Angeles',Theatre__c='Americas-US Commercial', username='newuser1@cisco.com');
        insert opptyOwner;
         
    
    // New Opportunity
        Opportunity o = new Opportunity(Forecast_Status__c='Upside', Lost_Cancelled_Reason__c='-', 
            Opportunity_Status__c='Active', Expected_Product__c=2,Expected_Service__c=3, OwnerId=opptyOwner.Id,
            Opportunity_Owner_AM__c=opptyOwner.Id,name='abc',StageName='4 - Agreement',Competitors__c='test', CloseDate= vCloseDate.adddays(2));
        insert o;
        
        
        
          AT_Workspace__c temp = new AT_Workspace__c(Name='test',Workspace_Lost_Cancelled_Reason__c='-',
               PSS_Workspace_Status__c='Active',Opportunity__c = o.ID,Sync_With_Opportunity__c=TRUE,
               AT_Forecast_Status__c='Commit',Workspace_Stage__c ='2 - Qualification',AT_Expected_Book_Date__c = System.Today(),
               AT_Team__c = 'Cisco1',Forecast_Position_ID__c = '123',AT_Technology__c ='Optical',
               AT_Sub_Technology__c = 'Optical Router',AT_Product__c ='Optical DPT/RPR Modules');
    
        insert temp;
        
        AT_Workspace__c atw = [Select Id from AT_Workspace__c where Opportunity__c =: o.Id][0];
        atw.AT_Expected_Product__c = 5000;
        atw.Is_Multi_Tech__c = false;
        upsert atw;
        
        Id i = atw.Id;
        
        Apexpages.currentPage().getParameters().put('id', i);     
        Apexpages.currentPage().getParameters().put('CF00N30000002BozE_lkid',o.ID);
        ApexPages.StandardController sc = new ApexPages.StandardController(temp);   
        Apexpages.currentPage().getParameters().put('id',temp.id); 
        PSSUser_CT testcl1 = new PSSUser_CT(sc);
               
         AT_Workspace__c temp1 = new AT_Workspace__c(Name='test',Opportunity__c = o.ID,Sync_With_Opportunity__c=false,AT_Forecast_Status__c='Upside',AT_Expected_Product__c = 1,AT_Expected_Book_Date__c = System.Today(),AT_Team__c = 'Cisco1',Forecast_Position_ID__c = '123',AT_Technology__c ='Optical',AT_Sub_Technology__c = 'Optical Router',AT_Product__c ='Optical DPT/RPR Modules');
        insert temp1;
        AT_Workspace__c temp2 = new AT_Workspace__c(Name='test',Opportunity__c = o.ID,Sync_With_Opportunity__c=false,AT_Forecast_Status__c='Upside',AT_Expected_Product__c = 1,AT_Expected_Book_Date__c = System.Today(),AT_Team__c = 'Cisco1',Forecast_Position_ID__c = '123',AT_Technology__c ='Optical',AT_Sub_Technology__c = 'Optical Router',AT_Product__c ='Optical DPT/RPR Modules');
        delete temp;
        AT_Workspace__c temp3 = new AT_Workspace__c(Name='test',Opportunity__c = o.ID,Sync_With_Opportunity__c=false,AT_Forecast_Status__c='Upside',AT_Expected_Product__c = 1,AT_Expected_Book_Date__c = System.Today(),AT_Team__c = 'Cisco1',Forecast_Position_ID__c = '123',AT_Technology__c ='Optical',AT_Sub_Technology__c = 'Optical Router',AT_Product__c ='Optical DPT/RPR Modules');
        insert temp3; 
        delete temp1;
        
        o.Forecast_Status__c = 'Upside';
        o.CloseDate = vCloseDate;
        upsert o;           
                         
        testcl1.cancel();
    }
}