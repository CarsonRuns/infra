@isTest
public class Alekhya_RecordAccess_Test {

    
    @isTest static void checkAccess_Account(){
        Test.startTest();
        Utilities.setIsTestMethod(true);
        Utilities.setValidationSkip(true);
        Utilities.setSkipFuture(true);
        lxTestDataFactory.createCustomSettings();
        Opportunity testOpty = lxTestDataFactory.createSingleOppty();
        list <string> accId = new list<string>();
        accId.add(testOpty.id);
        Alekhya_RecordAccess.AccessTest a = new Alekhya_RecordAccess.AccessTest();
		//Alekhya_RecordAccess.AccessTest a = new Alekhya_RecordAccess.AccessTest();
		Map<String, String> m = a.checkAccess('Opportunity', accId);
        
        Alekhya_RecordAccess.checkMultiple('Opportunity', accId);
        
        
        Alekhya_RecordAccess.check('Opportunity', testOpty.id);
        Map<String, String> p = new Map<String, String>();
        p.put(testOpty.id,'Error');
        System.assert(m == p);
        Test.stopTest();
    }

}