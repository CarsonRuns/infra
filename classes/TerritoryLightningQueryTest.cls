@isTest(seeAllData=true)
public class TerritoryLightningQueryTest 
{
    static testMethod void testMethodTerritory() 
    {   
        List<profile> profile = [select id from profile where name = 'Cisco_ADMIN'];
        List<Account> testAccount = [select id from Account where createdby.profileId =: profile[0].id limit 1];

        system.debug('??'+testAccount);
        PageReference pageRef = Page.TerritoryLightning;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',testAccount[0].id);
            
        Test.StartTest(); 
           		TerritoryLightningQuery testQuery = new TerritoryLightningQuery();
        		testQuery.territoryName='ABBOTT REMOTE';
         
        Test.StopTest();
    }
    
    static testMethod void testMethodNoTerritory() 
    {   
        List<Account> testAccount = [select id from Account limit 1];
            
        Test.StartTest(); 
            TerritoryLightningQuery testNullQuery = new TerritoryLightningQuery();
            testNullQuery.terr = null;
        Test.StopTest();
    }
}