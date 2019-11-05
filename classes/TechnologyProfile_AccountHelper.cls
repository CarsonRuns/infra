public with sharing class TechnologyProfile_AccountHelper
{
    
    public static void createTechnologyProfile(List<Account> lstAccounts)
    {
   
        List<Technology_Profile__c> lstTechprofile = new List<Technology_Profile__c>();
        List<Recordtype> recordId = [select id,Name from Recordtype where name = 'End-User' LIMIT 1];
                
        for(Account account:lstAccounts) {        
        if (account.RecordtypeId == recordId[0].Id) {
        Technology_Profile__c techprofile = new Technology_Profile__c();
        system.debug('here1-->'+account.Id);
        techprofile.FK_Account__c = account.Id;
        lstTechprofile.add(techprofile);
        }
        }
        system.debug('here2-->'+lstTechprofile.size());
        if(lstTechprofile.size() > 0) {
            insert lstTechprofile;
        }
        
        
    }
    
}