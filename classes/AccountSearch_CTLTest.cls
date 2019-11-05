@isTest
public class AccountSearch_CTLTest {
    
    private static testMethod void testMethod1()
    {
        Utilities.setIsTestMethod(true);
        Utilities.setValidationSkip(true);        
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Cisco_ADMIN' Limit 1];
        User usr = lxTestDataFactory.createSingleUser(p.Id);
        insert usr;

        lxTestDataFactory.createCustomSettings();
        Account a = lxTestDataFactory.createChannelAccount(usr.Id);
        a.Country__c ='test';
        a.City__c = 'test';
        insert a;
        
        AccountTeamMember acntTM = new AccountTeamMember();
        acntTM.TeamMemberRole = 'Cisco_Admin';
        acntTM.AccountId = a.Id;
        acntTM.UserId = usr.Id;
        insert acntTM;
        
        List<User> reportees = new List<User>();
        reportees.add(usr);
        Account acnt = [Select Id,Name,Owner.Username,Country__c,City__c,Count_of_Opportunities__c,Count_of_Active_Opps__c,All_Opportunity_Value__c,Active_Opportunity_Value__c,(select LastName from contacts) FROM Account limit 1];
        List<String> userIdLst = new List<Id>();
        AccountTeamMember atm = [Select Id,TeamMemberRole,User.Username FROM AccountTeamMember limit 1];
        userIdLst.add(usr.Id);
        
        String acc1=String.valueOf(a.id);
        String acc2='';
        List<String> reporteeList = new List<String>();
        Map<Id,Integer> accMap = new Map<Id,Integer>();
        Test.startTest();
        
        AccountSearch_CTL.fetchAccounts('','','unassociatedAccounts',userIdLst,0,'accOwner','asc');
        AccountSearch_CTL.fetchAccounts(acc1,'','unassociatedAccounts',userIdLst,0,'accOwner','desc');
        AccountSearch_CTL.accountInfo acntInfo2 = new AccountSearch_CTL.accountInfo(acnt,reportees,accMap);
        acntInfo2.compareTo(acntInfo2); 
        AccountSearch_CTL.fetchAccounts(acc1,String.valueOf(acnt.owner),'unassociatedAccounts',userIdLst,0,'city','asc');
        AccountSearch_CTL.fetchAccounts('',String.valueOf(acnt.owner),'unassociatedAccounts',userIdLst,0,'city','desc');
        AccountSearch_CTL.accountInfo acntInfo3 = new AccountSearch_CTL.accountInfo(acnt,reportees,accMap);
        acntInfo3.compareTo(acntInfo3); 
        AccountSearch_CTL.fetchAccounts('','','associatedAccounts',reporteeList,0,'country','asc');
        AccountSearch_CTL.fetchAccounts(acc1,'','associatedAccounts',reporteeList,0,'country','desc');
        AccountSearch_CTL.accountInfo acntInfo9 = new AccountSearch_CTL.accountInfo(acnt,reportees,accMap);
        acntInfo9.compareTo(acntInfo9); 
        AccountSearch_CTL.fetchAccounts('','','associatedAccounts',userIdLst,0,'cActiveOpty','asc');
        AccountSearch_CTL.fetchAccounts('',String.valueOf(acnt.owner),'associatedAccounts',reporteeList,0,'cActiveOpty','desc');
        AccountSearch_CTL.accountInfo acntInfo4 = new AccountSearch_CTL.accountInfo(acnt,reportees,accMap);
        acntInfo4.compareTo(acntInfo4); 
        AccountSearch_CTL.fetchAccounts(acc1,String.valueOf(acnt.owner),'associatedAccounts',reporteeList,0,'atvOptyVal','asc');
        AccountSearch_CTL.fetchAccounts('','','recentlyViewed',userIdLst,0,'atvOptyVal','desc');
        AccountSearch_CTL.accountInfo acntInfo5 = new AccountSearch_CTL.accountInfo(acnt,reportees,accMap);
        acntInfo5.compareTo(acntInfo5);
        AccountSearch_CTL.fetchAccounts(acc1,'','recentlyViewed',userIdLst,0,'cOpty','asc');
        AccountSearch_CTL.fetchAccounts('',String.valueOf(acnt.owner),'recentlyViewed',userIdLst,0,'cOpty','desc');
        AccountSearch_CTL.accountInfo acntInfo6 = new AccountSearch_CTL.accountInfo(acnt,reportees,accMap);
        acntInfo6.compareTo(acntInfo6);
        AccountSearch_CTL.fetchAccounts(acc1,String.valueOf(acnt.owner),'recentlyViewed',reporteeList,0,'optyVal','asc');
        AccountSearch_CTL.fetchAccounts(acc1,String.valueOf(acnt.owner),'recentlyViewed',userIdLst,0,'optyVal','desc');
        AccountSearch_CTL.accountInfo acntInfo7 = new AccountSearch_CTL.accountInfo(acnt,reportees,accMap);
        acntInfo7.compareTo(acntInfo7);
        AccountSearch_CTL.fetchAccounts('','','recentlyViewed',reporteeList,0,'redirectURL','asc');
        AccountSearch_CTL.fetchAccounts(acc1,'','recentlyViewed',reporteeList,0,'redirectURL','desc');
        AccountSearch_CTL.accountInfo acntInfo8 = new AccountSearch_CTL.accountInfo(acnt,reportees,accMap);
        acntInfo7.compareTo(acntInfo8);
        AccountSearch_CTL.fetchAccounts('',String.valueOf(acnt.owner),'recentlyViewed',reporteeList,0,'name','desc');
        
        AccountSearch_CTL.accountInfo acntInfo1 = new AccountSearch_CTL.accountInfo(acnt,atm,userIdLst,reportees,accMap);
        test.stopTest();
    }  
    
}