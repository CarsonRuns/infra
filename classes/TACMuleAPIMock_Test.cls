/*
	Name    		: TACMuleAPIMock_Test 
	Author  		: Eric Pesch (epesch)
	Release 		: 1.0
	Functionality 	: Test methods for mock tester
	Created			: Sep 14 2015
	
	Modification History:
	Date		Author			Change 
*/
@isTest
private class TACMuleAPIMock_Test {
	
	@testSetup static void setup(){
		UtilUnitTest.loadAllStaticData();
		List<Org_Constant_CS__c> newConstants = new List<Org_Constant_CS__c>();
		
		newConstants.add(new Org_Constant_CS__c(Name = 'TAC Services API Endpoint', Non_Production_Value__c = 'https://null.com', Production_Value__c = 'https://null.com'));
		newConstants.add(new Org_Constant_CS__c(Name = 'Ping Federate Endpoint', Non_Production_Value__c = 'https://null.com', Production_Value__c = 'https://null.com'));
    	insert newConstants; 
	}

    static testMethod void callTestURLs() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TACMuleAPIMock_Test_Svc());
        TACMuleAPIMock mock = new TACMuleAPIMock();
        
        
        mock.installSiteId = 'installSite';
        mock.installSiteIdBody = 'installBody';
        mock.crParty = 'cr';
        mock.crPartyBody = 'crBody';
        mock.pingToken = 'abc123';
        
        mock.getMethods(); 
        mock.callPingFederate();
        mock.callInstallSite();
        mock.callInstallSiteSearch();
        mock.callAccount();
        mock.callAccountSearch();
        
        Test.stopTest();
    }
}