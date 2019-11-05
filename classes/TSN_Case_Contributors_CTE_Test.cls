@isTest
public class TSN_Case_Contributors_CTE_Test{ 
  static testMethod void runTestCases()
   {

     // TSN User     
     User TSNUser = [Select id from user where profileid=:Utilities.getTSNProfileId() and IsActive = True limit 1];
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
     System.runAs(TSNUser){
     Case testCase1=new Case(team__c='Group2',case_Contributors__c='ALAIN MEYRAN,Ana Abogado,Aico Wei,ALEXANDER LAGIER');
     testCase1.Contact_Type__c='Cisco';
     testCase1.recordTypeId=Utilities.getCaseTSNRecordTypeId();
     testCase1.Cisco_Contact__c='abc@cisco.com.reg';
     testCase1.Subject='test Case TSn';
     testCase1.Service_Type__c='Collaboration';
     testCase1.Architecture__c='Service Provider';
     testCase1.Case_Language__c='English';
     testCase1.Description='desc';
     testCase1.status='Assigned';
     testCase1.Assigned_Priority__c='P3';
     testCase1.Assigned_SLA__c='4 hr';
     testCase1.Requested_Due_Date__c=System.today() + 4;
     testCase1.ownerId=TSNUser.id;
     testCase1.Team__c='Group2';
     insert testCase1;
     ApexPages.StandardController controller=new ApexPages.StandardController(testCase1);
     TSN_Case_Contributors_CTE testClassObject=new TSN_Case_Contributors_CTE(controller);
     testClassObject.setListOfUsersForTeam();
     testClassObject.save();
     testClassObject.selectclick();
     testClassObject.unselectclick();
     testClassObject.getleftValuesSet();
     testClassObject.getrightValuesSet();
     testClassObject.cancel();

     
     }
   }
}