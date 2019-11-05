@isTest(seealldata=true)
public class SyncOptyValuesToWS_Test{
   static testMethod void unitTest() {
     Date vCloseDate = System.today();
            //Get users default currency
            User currentUser = [select defaultCurrencyIsoCode from User where Id = :UserInfo.getUserId()];
            //Query for Pricebook2
            String defaultPricebookId;
            Pricebook2[] pricebook2 = [select id from Pricebook2];
            if(pricebook2 == null || pricebook2.size() == 0){
                Pricebook2 createDefaultPB = new Pricebook2(name='default pricebook', isActive=true);
                insert createDefaultPB;
                defaultPricebookId = createDefaultPB.Id;
            }
            else{
                defaultPricebookId = pricebook2[0].Id;

            }
            Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('End-User').getRecordTypeId();
            Account acct1 = [select id from account where RecordTypeId=:devRecordTypeId limit 1];
     Opportunity oppty1 = new Opportunity(name='Test1',Accountid=acct1.id, StageName='1 - Identify',CloseDate= vCloseDate,Competitors__c = 'A10 Networks',Expected_Product__c=2,Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode);
     Opportunity[] opptyArray = new Opportunity[]{oppty1};
     insert opptyArray;     
     date myDate = date.today();
     AT_Workspace__c at=new AT_Workspace__c(Name='Test',AT_Expected_Book_Date__c=myDate,AT_Forecast_Status__c='Commit',Opportunity__c=opptyArray[0].id);
     insert at;
     Test.startTest();
     Test.setCurrentPage(Page.SyncOptyValuesToWorkspace);
    // SyncOptyValuesToWS_CTE controller = new SyncOptyValuesToWS_CTE(new ApexPages.StandardController(at));
     ApexPages.StandardController sc = new ApexPages.standardController(at);
     SyncOptyValuesToWS_CTE ctr = new SyncOptyValuesToWS_CTE (sc);
     
     Test.stopTest();
    }
    static testMethod void unitTest1() {
        Date vCloseDate = System.today();
        //Get users default currency
        User currentUser = [select defaultCurrencyIsoCode from User where Id = :UserInfo.getUserId()];
        //Query for Pricebook2
        String defaultPricebookId;
        Pricebook2[] pricebook2 = [select id from Pricebook2];
        if(pricebook2 == null || pricebook2.size() == 0){
        Pricebook2 createDefaultPB = new Pricebook2(name='default pricebook', isActive=true);
        insert createDefaultPB;
        defaultPricebookId = createDefaultPB.Id;
        }
        else{
        defaultPricebookId = pricebook2[0].Id;
        
        }
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('End-User').getRecordTypeId();
        Account acct1 = [select id from account where RecordTypeId=:devRecordTypeId limit 1];
        Opportunity oppty1 = new Opportunity(name='Test1',Opportunity_Status__c='Booked',Accountid=acct1.id, StageName='1 - Identify',CloseDate= vCloseDate,Competitors__c = 'A10 Networks',Expected_Product__c=2,Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode);
        Opportunity[] opptyArray = new Opportunity[]{oppty1};
        Test.startTest();
        insert opptyArray;     
        date myDate = date.today();        
        AT_Workspace__c at1=new AT_Workspace__c(Name='Test',AT_Expected_Book_Date__c=myDate+1,AT_Forecast_Status__c='Commit',Opportunity__c=opptyArray[0].id);
        AT_Workspace__c at2=new AT_Workspace__c(Name='Test1',AT_Expected_Book_Date__c=myDate,AT_Forecast_Status__c='Commit',Opportunity__c=opptyArray[0].id);
        AT_Workspace__c at3=new AT_Workspace__c(Name='Test2',AT_Expected_Book_Date__c=myDate,AT_Forecast_Status__c='upside',Opportunity__c=opptyArray[0].id);
        AT_Workspace__c[] workArray = new AT_Workspace__c[]{at1,at2,at3};
        insert workArray;
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(workArray);
        stdSetController.setSelected(workArray);
        SyncOptyValuesToWS_CTE  syc = new SyncOptyValuesToWS_CTE (stdSetController);
       // syc.workspaceList =workArray; 
        syc.CopyOptyValuesToWS();
        //stdSetController.setSelected(lstAccount);
        Test.stopTest();
    }
}