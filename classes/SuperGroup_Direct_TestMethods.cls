// This class acts as Test Class for Super_Group_Direct_SAV,Super_Group_Direct_Acct, Super_Group_Direct_Oppty , Super_Group_Direct_Export_CTE & Super_Group_Direct_Export_Link_CTE Classes
// Release -- FY'13 Year End Rel 

@istest(SeeAllData=true)
public class SuperGroup_Direct_TestMethods{

    public static ApexPages.StandardController DirectSuperGrpCon = null;
    public static PageReference DirectPageRef = null;
    public static Super_Group__c testDirectSuperGrp = null;
    public static List<Account_Group__c> testSAVList = new List<Account_Group__c>();
    public static List<Account_Group_Relationship__c> testSAVAcctRelList = new List<Account_Group_Relationship__c>();
    public static List<Direct_SAV_SuperGroup_Rel__c> testSuperGrpSAVRelList = new List<Direct_SAV_SuperGroup_Rel__c>();
    public static List<Account> testAcctList = new List<Account>();
    public static List<Opportunity> testOpptyList = new List<Opportunity>();
    
    public static void  init(){
    
    testDirectSuperGrp = new Super_Group__c(Name = 'TestDirectSuper', Type__c='Direct');
    insert testDirectSuperGrp; // Direct Super Group
    
        for(Integer i=0;i<10;i++){
            testSAVList.add(new Account_Group__c(Name='TestSAV'+i));
        }
        insert testSAVList; // Sales Account List
        
        for(Integer i=0;i<10;i++){
            testAcctList.add(new Account(Name='AccountTest'+i, RecordTypeId = '0123000000004aU',Account_Status__c='Active'));
        }
        insert testAcctList; // Account List
             
        for(Integer i=0;i<10;i++){
            testSAVAcctRelList.add(new Account_Group_Relationship__c (Account_Group__c = testSAVList[i].Id, Account_ID__c = testAcctList[i].Id));
        }
        insert testSAVAcctRelList; // Account Grp Relationship List
        
        for(Integer i=0;i<10;i++){
            testSuperGrpSAVRelList.add(new Direct_SAV_SuperGroup_Rel__c (Account_Group__c = testSAVList[i].Id, Super_Group__c = testDirectSuperGrp.Id));
        }
        insert testSuperGrpSAVRelList; // Direct SuperGrp SAV Relationship List
        
        for(Integer i=0;i<10;i++){
            testOpptyList.add(new Opportunity(Name='OpptyTest'+i,Account_Group__c = testSAVList[i].Id, accountId= testAcctList[i].Id,StageName='2 - Qualification',Partner_Expected_Book_Date__c = System.today().adddays(2), CloseDate= System.today().adddays(10),Public_Sector_Funding__c='Economic Stimulus Program'));
        }
        insert testOpptyList; // Opportunity List  
        
        DirectSuperGrpCon = new ApexPages.StandardController(testDirectSuperGrp);
        DirectPageRef = ApexPages.currentPage();
        DirectPageRef.getParameters().put('id',testDirectSuperGrp.Id); 

    }
    
   public static testMethod void  execute_Test(){
        init();
        Test.StartTest();  
        Utilities.setIsTestMethod(true);
        Super_Group_Direct_SAV_CTE_Test();
        Super_Group_Direct_Acct_CTE_Test();
        Super_Group_Direct_Oppty_CTE_Test();
        Super_Group_Direct_Export_CTE_Test();
        Super_Group_Direct_Export_Link_CTE_Test();
        Test.StopTest();
    }  
    
   public static void  Super_Group_Direct_SAV_CTE_Test(){ 
        Super_Group_Direct_SAV_CTE classController = new Super_Group_Direct_SAV_CTE(DirectSuperGrpCon);
        classController.SAVCON = null;     
        classController.sortColumnNameNew = 'Name';
        classController.getAccountGroupRecords();
        classController.OrderData();
        
    }
    
   public static void  Super_Group_Direct_Acct_CTE_Test(){ 
        Super_Group_Direct_Acct_CTE classController = new Super_Group_Direct_Acct_CTE(DirectSuperGrpCon);
        classController.ACCTCON = null;  
        classController.sortColumnNameNew = 'Name';
        classController.SuperGrpAccountData();
        classController.getAccountRecords();
        classController.OrderData();
        classController.Paging('Select Id, Name,Owner.Name,HQ_Party_ID__c,CSCSiteID__c,DUNSNumber__c,AddressLine1__c,City__c,State__c,Country__c from Account order by Name LIMIT 2');
    }
    
   public static void  Super_Group_Direct_Oppty_CTE_Test(){ 
        Super_Group_Direct_Oppty_CTE classController = new Super_Group_Direct_Oppty_CTE(DirectSuperGrpCon);
        classController.OPPTYCON = null;     
        classController.sortColumnNameNew = 'Account.Name';
        classController.getOpptyRecords();
        classController.OrderData();
    }  
        
   public static void  Super_Group_Direct_Export_CTE_Test(){ 
        Super_Group_Direct_Export_CTE classController = new Super_Group_Direct_Export_CTE(DirectSuperGrpCon);
        classController.createOpptyMap();    
        classController.createAcctMap();
        classController.populateSuperGrpInfoList();
    }
    public static void  Super_Group_Direct_Export_Link_CTE_Test(){ 
        Super_Group_Direct_Export_Link_CTE classController = new Super_Group_Direct_Export_Link_CTE(DirectSuperGrpCon);
        classController.Save();    
    }   
}