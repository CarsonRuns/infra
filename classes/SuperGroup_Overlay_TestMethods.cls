// This class acts as Test Class for Super_Group_Overlay_Acct, Super_Group_Overlay_Oppty, Super_Group_Overlay_Export & Super_Group_Overlay_Export_Link Classes
// Release -- FY'13 Year End Rel 

@istest(SeeAllData=true)
public class SuperGroup_Overlay_TestMethods{

    public static ApexPages.StandardController OverlaySuperGrpCon = null;
    public static PageReference OverlayPageRef = null;
    public static Super_Group__c testOverlaySuperGrp = null;
    public static List<Overlay_Acct_SuperGroup_Rel__c> testSuperGrpAcctRelList = new List<Overlay_Acct_SuperGroup_Rel__c>();
    public static List<Account> testAcctList = new List<Account>();
    public static List<Opportunity> testOpptyList = new List<Opportunity>();
    
    public static void  init(){
    
    testOverlaySuperGrp = new Super_Group__c(Name = 'TestOverlay', Type__c='Overlay');
    insert testOverlaySuperGrp; // Overlay Super Group
    
        for(Integer i=0;i<10;i++){
            testAcctList.add(new Account(Name='AccountTest'+i, RecordTypeId = '0123000000004aU',Account_Status__c='Active'));
        }
        insert testAcctList; // Account List
             
        for(Integer i=0;i<10;i++){
            testSuperGrpAcctRelList.add(new Overlay_Acct_SuperGroup_Rel__c(Account_ID__c = testAcctList[i].Id, Super_Group__c = testOverlaySuperGrp.Id));
        }
        insert testSuperGrpAcctRelList; // Overlay Super Grp Acct Relationship List
        
        for(Integer i=0;i<10;i++){
            testOpptyList.add(new Opportunity(Name='OpptyTest'+i,accountId= testAcctList[i].Id,StageName='2 - Qualification',Partner_Expected_Book_Date__c = System.today().adddays(2), CloseDate= System.today().adddays(10),Public_Sector_Funding__c='Economic Stimulus Program'));
        }
        insert testOpptyList; // Opportunity List  
        
        OverlaySuperGrpCon = new ApexPages.StandardController(testOverlaySuperGrp);
        OverlayPageRef = ApexPages.currentPage();
        OverlayPageRef.getParameters().put('id',testOverlaySuperGrp.Id); 
    }
    
    public static testMethod void  execute_Test(){
        init();
        Test.StartTest(); 
        Utilities.setIsTestMethod(true);
        Super_Group_Overlay_Acct_CTE_Test(); 
        Super_Group_Overlay_Oppty_CTE_Test();
        Super_Group_Overlay_Export_CTE_Test();
        Super_Group_Overlay_Export_Link_CTE_Test();
        Test.StopTest();
    }
    
    public static void  Super_Group_Overlay_Acct_CTE_Test(){ 
        Super_Group_Overlay_Acct_CTE classController = new Super_Group_Overlay_Acct_CTE(OverlaySuperGrpCon);
        classController.ACCTCON = null;     
        classController.sortColumnNameNew = 'Name';
        classController.getAccountRecords();
        classController.OrderData();
    }
    
    public static void  Super_Group_Overlay_Oppty_CTE_Test(){ 
        Super_Group_Overlay_Oppty_CTE classController = new Super_Group_Overlay_Oppty_CTE(OverlaySuperGrpCon);
        classController.OPPTYCON = null;     
        classController.sortColumnNameNew = 'Account.Name';
        classController.getOpptyRecords();
        classController.OrderData();
    }  
    
    public static void  Super_Group_Overlay_Export_CTE_Test(){ 
        Super_Group_Overlay_Export_CTE classController = new Super_Group_Overlay_Export_CTE(OverlaySuperGrpCon);
        classController.populateSuperGrpInfoList();
    }
    
    public static void  Super_Group_Overlay_Export_Link_CTE_Test(){ 
        Super_Group_Overlay_Export_Link_CTE classController = new Super_Group_Overlay_Export_Link_CTE(OverlaySuperGrpCon);
        classController.Save();    
    }   
 }