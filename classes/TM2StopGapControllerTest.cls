@isTest
private class TM2StopGapControllerTest {
    testmethod private static void myTestGetSet() {
        Utilities.setIsTestMethod(true);
        Utilities.setValidationSkip(true);
        
        Org_Constant_CS__c os2 =new Org_Constant_CS__c();
        os2.Name = 'PilotProfileId';
        os2.Production_Value__c = '00e34000001aqqQ';
        os2.Non_Production_Value__c = '00e34000001aqqQ';
        insert os2;
        String profileId = Utilities.getConstant_CS('PilotProfileId');  
        
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Cisco_ADMIN' Limit 1];
        User usr = lxTestDataFactory.createSingleUser(p.Id);
        insert usr;
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('End-User').getRecordTypeId();
        Account acct1 = null;
        
        system.runAs(usr){
            
            lxTestDataFactory.createCustomSettings();
            acct1 = lxTestDataFactory.createChannelAccount(usr.Id);
            insert acct1;
        }
        //Retrieve Existing Account
        //Account acct1 = [select id from account where RecordTypeId=:devRecordTypeId limit 1];
        
        //Retrieveing Current Date
        Date vCloseDate = System.today();
        //Get users default currency
        User currentUser = [select defaultCurrencyIsoCode from User where Id = :UserInfo.getUserId()];
        
        //Query for Pricebook2
        String defaultPricebookId;
        //Pricebook2[] pricebook2 = [select id from Pricebook2 WHERE NAME = 'Standard Price Book'];
        //if(pricebook2 == null || pricebook2.size() == 0){
        Pricebook2 createDefaultPB = new Pricebook2(name='Standard Price Book', isActive=true);
        insert createDefaultPB;
        defaultPricebookId = createDefaultPB.Id;
        /*}
else{
defaultPricebookId = pricebook2[0].Id;

}*/
        //Create Opportunity 
        territory2 tr = [select id from territory2 limit 1];
        Opportunity oppty1 = new Opportunity(name='Test1',Accountid=acct1.id, StageName='3 - Proposal',
                                             CloseDate= vCloseDate-1,Competitors__c = 'A10 Networks',
                                             Expected_Product__c=2,
                                             Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode,
                                             territory2Id=tr.id);
        oppty1.Expected_Service__c = 0;
        oppty1.Expected_Product__c = 10;
        insert oppty1;
        system.runAs(usr){
            ApexPages.currentPage().getParameters().put('id', oppty1.id);
            Apexpages.StandardController sc = new Apexpages.standardController(oppty1);
            // Instantiate the extension
            TM2StopGapController ext = new TM2StopGapController(sc);
            ext.setIsOptySharecompleted();
        }
    }
    
}