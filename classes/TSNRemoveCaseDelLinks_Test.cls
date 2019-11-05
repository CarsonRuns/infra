@isTest

private Class TSNRemoveCaseDelLinks_Test{
     private static testMethod void test(){
         
         // Cisco_Sales_Cases User         
         User TSNUser = [Select id, Email,isactive from user where profileid=:Utilities.getTSNProfileId() and IsActive = True and Email != null limit 1];
         CEE_TestUtility.loadCustomSettings();
         Group gp1=new Group(name='Group1');
         insert gp1;
         
         System.runAs(TSNUser){
             GroupMember gm1=new GroupMember(groupId=gp1.id,userorgroupId=TSNUser.id);
             insert gm1;
         }
         
         Case testTSNCase = new Case(RecordTypeId=Utilities.getCaseTSNRecordTypeId(),Contact_Type__c = 'Cisco',Cisco_Contact__c='abc@cisco.com',OwnerId = TSNUser.Id,Team__c='Group1');
         insert testTSNCase; // TSN Case
         Test.StartTest();
         ApexPages.StandardController controller = new ApexPages.StandardController(testTSNCase);      
         PageReference pageRef = ApexPages.currentPage();
         pageRef.getParameters().put('id',testTSNCase.Id);
         TSNRemoveCaseDelLinks_CTE rcd = new TSNRemoveCaseDelLinks_CTE(controller);
         Test.StopTest();
    }
}