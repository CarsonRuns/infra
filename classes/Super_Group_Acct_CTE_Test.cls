// This class acts as Test Class for Super_Group_Acct Class
// Release -- FY'13 Year End Rel 

@istest(SeeAllData=true)
public class Super_Group_Acct_CTE_Test{

    public static ApexPages.StandardController AcctCon = null;
    public static PageReference AcctPageRef = null;
    public static Account testAcct = null;
    public static List<Super_Group__c> testDirectSuperGrpList = new List<Super_Group__c>();
    public static List<Super_Group__c> testOverlaySuperGrpList = new List<Super_Group__c>();
    public static List<Account_Group__c> testSAVList = new List<Account_Group__c>();
    public static List<Account_Group_Relationship__c> testSAVAcctRelList = new List<Account_Group_Relationship__c>();
    public static List<Direct_SAV_SuperGroup_Rel__c> testSuperGrpSAVRelList = new List<Direct_SAV_SuperGroup_Rel__c>();
    public static List<Overlay_Acct_SuperGroup_Rel__c> testSuperGrpAcctRelList = new List<Overlay_Acct_SuperGroup_Rel__c>();
    
    public static void  init(){
    
    testAcct = new Account(Name='AccountTest', RecordTypeId = '0123000000004aU',Account_Status__c='Active');
    insert testAcct; // End User Account
       
        for(Integer i=0;i<10;i++){
            testDirectSuperGrpList.add(new Super_Group__c(Name = 'TestDirectSuper'+ i, Type__c='Direct'));
        }
        insert testDirectSuperGrpList; // Direct Super Group List
        
        for(Integer i=0;i<10;i++){
            testOverlaySuperGrpList.add(new Super_Group__c(Name = 'TestOverlaySuper'+ i, Type__c='Overlay'));
        }
        insert testOverlaySuperGrpList; // Overlay Super Group List
        
        for(Integer i=0;i<10;i++){
            testSAVList.add(new Account_Group__c(Name='TestSAV'+i));
        }
        insert testSAVList; // Sales Account List
        
        for(Integer i=0;i<10;i++){
            testSAVAcctRelList.add(new Account_Group_Relationship__c (Account_Group__c = testSAVList[i].Id, Account_ID__c = testAcct.Id));
        }
        insert testSAVAcctRelList; // Account Grp Relationship List
        
        for(Integer i=0;i<10;i++){
            testSuperGrpSAVRelList.add(new Direct_SAV_SuperGroup_Rel__c (Account_Group__c = testSAVList[i].Id, Super_Group__c = testDirectSuperGrpList[i].Id));
        }
        insert testSuperGrpSAVRelList; // Direct SuperGrp SAV Relationship List
        
        for(Integer i=0;i<10;i++){
            testSuperGrpAcctRelList.add(new Overlay_Acct_SuperGroup_Rel__c(Account_ID__c = testAcct.Id, Super_Group__c = testOverlaySuperGrpList[i].Id));
        }
        insert testSuperGrpAcctRelList; // Overlay Super Grp Acct Relationship List
        
        AcctCon = new ApexPages.StandardController(testAcct);
        AcctPageRef = ApexPages.currentPage();
        AcctPageRef.getParameters().put('id',testAcct.Id); 
    }
   
    public static testMethod void  execute_Test(){
        init();
        Test.StartTest(); 
        Utilities.setIsTestMethod(true); 
        Super_Group_Acct_Test();
        Test.StopTest();
    }  
    
    public static void  Super_Group_Acct_Test(){ 
        Super_Group_Acct_CTE classController = new Super_Group_Acct_CTE(AcctCon);
        classController.con = null; 
        classController.DirectSuperGrpAccountData();  
        classController.SuperGroupData();
        classController.getSuperGroupRecords();
        classController.Paging();
    }
}