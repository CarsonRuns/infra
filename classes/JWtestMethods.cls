@istest
public class JWtestMethods{
    
    // Test Method for Set_Account_STT_Assignment
    static testMethod void createSCA() {
        
        Account newAccount = new Account(name='Test Only');
        Account[] accountArray = new Account[]{newAccount};
        insert newAccount;
        
        STT_Acct_Owner__c newSCA = new STT_Acct_Owner__c(Account__c = newAccount.id, name='test1');
        insert newSCA;
        
        newSCA.name='test2';
        update newSCA;
        
        delete newSCA;
    }
    
    static testMethod void test_AT_Workspace() {
    
        Account a = new Account( Name='AT');
        insert a;
        
        Opportunity o = new Opportunity(name='test',AccountId=a.id,CloseDate=Date.newInstance(2008,6,13),stageName='Open'); 
        insert o;
        
        AT_Workspace__c at = new AT_Workspace__c(Opportunity__c=o.id);
        insert at;
    
    }
    
    
     public static testMethod void test_OwnerAssignmentbyAT() { 
        //Test.startTest();
        Utilities.setIsTestMethod(true);

         
         User u = [select Id, UserRoleId from User where IsActive=true and Id ='0053000000102oW' limit 1];
    
         
         Account acct = New Account(Name='test');
         insert acct;
         
        Opportunity o = new Opportunity(name='test',AccountId=acct.id,CloseDate=Date.newInstance(2006,10,10),stageName='Open',Opportunity_Owner_AM__c=u.Id,Position__c='ESALES');
        insert o;
        
        Utilities.setIsTestMethod(false);
      

     }

}