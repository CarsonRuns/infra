@isTest

private Class ReAssignCase_Test{
     private static testMethod void test(){
        insert new ProfileID__c (SetupOwnerId=UserInfo.getOrganizationId(), Cisco_ADMIN__c='00e30000000dcbg');
     
         // Cisco_TSN User 

         User TSNUser = [select id from User where profileid=:Utilities.getTSNProfileId() and isactive=true limit 1];
         CEE_TestUtility.loadCustomSettings();
         Group gp1=new Group(name='Group1');
         insert gp1;
         Group gp2=new Group(name='Group2');
         insert gp2;
         Group gp3=new Group(name='Group3');
         insert gp3;
         System.runAs(TSNUser){
         GroupMember gm1=new GroupMember(groupId=gp1.id,userorgroupId=TSNUser.id);
         insert gm1;
         GroupMember gm2=new GroupMember(groupId=gp2.id,userorgroupId=TSNUser.id);
         insert gm2;
         }
         Case testTSNCase = new Case(RecordTypeId=Utilities.getCaseTSNRecordTypeId(),Contact_Type__c = 'Cisco',Cisco_Contact__c='abc@cisco.com',OwnerId = TSNUser.Id,team__c='Group1');
         insert testTSNCase; // TSN Case
         Case testPHCase  = new Case(RecordtypeId =Utilities.getCasePHRecordTypeId(),Contact_Type__c = 'Cisco',Cisco_Contact__c='abc@cisco.com',Case_Theater__c = 'Americas-US Commercial');
         insert testPHCase; //PH case
         
         Test.StartTest();
         ApexPages.StandardController controllerTSN = new ApexPages.StandardController(testTSNCase);      
         PageReference pageRefTSN = ApexPages.currentPage();
         pageRefTSN.getParameters().put('id',testTSNCase.Id);
         ReAssignCase_CTE reassignCaseTSN = new ReAssignCase_CTE(controllerTSN);
         reassignCaseTSN.save();
        // testTSNCase.status='Closed';
        // update testTSNCase;
         System.runAs(TSNUser)
         {
          Case testTSNCase1 = new Case(RecordTypeId=Utilities.getCaseTSNRecordTypeId(),Contact_Type__c = 'Cisco',Cisco_Contact__c='abc1@cisco.com',OwnerId = TSNUser.Id,team__c='Group1',Status='Closed',Interaction_Type__c = 'IM',Architecture__c='test');
          insert testTSNCase1; // TSN Case
          ApexPages.StandardController controllerTSN1 = new ApexPages.StandardController(testTSNCase1);      
          PageReference pageRefTSN1 = ApexPages.currentPage();
          pageRefTSN1.getParameters().put('id',testTSNCase1.Id);
          ReAssignCase_CTE reassignCaseTSN1 = new ReAssignCase_CTE(controllerTSN1);
          try{
          reassignCaseTSN1.save();
          }
          catch(Exception exc){}
        
          Case testTSNCase2 = new Case(RecordTypeId=Utilities.getCaseTSNRecordTypeId(),Contact_Type__c = 'Cisco',Cisco_Contact__c='abc1@cisco.com',status='Assigned',Architecture__c='test');
          testTSNCase2.Assigned_SLA__c= null;
          insert testTSNCase2; // TSN Case
          ApexPages.StandardController controllerTSN2 = new ApexPages.StandardController(testTSNCase2);      
          PageReference pageRefTSN2 = ApexPages.currentPage();
          pageRefTSN2.getParameters().put('isLink','1');
          pageRefTSN2.getParameters().put('id',testTSNCase2.Id);
          ReAssignCase_CTE reassignCaseTSN2 = new ReAssignCase_CTE(controllerTSN2);
          try{
          reassignCaseTSN2.save();
          }catch(Exception exc){}
        
 
          Case testTSNCase3 = new Case(RecordTypeId=Utilities.getCaseTSNRecordTypeId(),Contact_Type__c = 'Cisco',Cisco_Contact__c='abc1@cisco.com',OwnerId = TSNUser.Id,team__c='Group2',status='Assigned',Architecture__c='test');
          testTSNCase3.Assigned_SLA__c= null;
          insert testTSNCase3; // TSN Case
          ApexPages.StandardController controllerTSN3 = new ApexPages.StandardController(testTSNCase3);      
          PageReference pageRefTSN3 = ApexPages.currentPage();
  //        pageRefTSN3.getParameters().put('isLink','1');
          pageRefTSN3.getParameters().put('id',testTSNCase3.Id);
          ReAssignCase_CTE reassignCaseTSN3 = new ReAssignCase_CTE(controllerTSN3);
          try{
          reassignCaseTSN3.save();
          }catch(Exception exc){}
         }
       //  reassignCaseTSN.OwnerGroup(); 
         ApexPages.StandardController controllerPH = new ApexPages.StandardController(testPHCase);      
         PageReference pageRefPH = ApexPages.currentPage();
         pageRefPH.getParameters().put('id',testPHCase.Id);
         ReAssignCase_CTE reassignCasePH = new ReAssignCase_CTE(controllerPH);
         reassignCasePH.save();
         Test.StopTest();
    }
}