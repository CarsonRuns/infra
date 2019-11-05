@istest(SeeAllData=true)
private class AutomationCCOIdSearchTest{    
    private static testMethod void test(){
        test.startTest();   
        Account a = new Account(name='TestVC',RecordtypeId = '0123000000004aV');
        insert a;
        Contact co = new Contact(AccountId = a.Id, LastName = 'Test', Email = 'test@cisco.com' , RecordtypeId = '01280000000G6ti');
        insert co; 
        Case c1 = new Case(AccountId = a.Id,RecordtypeId =Utilities.getCasePHRecordTypeId(),ContactId = co.Id);
        c1.web_cco_id__c='TESTccoId1@cisco.com';
        c1.suppliedemail='TESTccoId1@cisco.com';
        c1.Case_Theater__c = 'APJC';
        insert c1; //PH case
        Vc_CT vcct =  new Vc_CT(); // Create instance of class Vc_CT
        vcct.CCO_ID = 'TESTccoId1@cisco.com';       
        vcct.SFDCChannelAccountFound  = true;
        //Automation of CCO ID search
        c1.Web_CCO_ID__c = 'minus';
        AutomationCCOIdSearch.doCCOIdSearch(c1.Id);
        c1.Web_CCO_ID__c = 'tsunilkumar';
        AutomationCCOIdSearch.doCCOIdSearch(c1.Id);
        c1.Web_CCO_ID__c = 'dameyer';
        AutomationCCOIdSearch.doCCOIdSearch(c1.Id);
        test.stopTest();    
    }
}