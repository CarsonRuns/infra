@isTest(SeeAllData=true) 
private class User_Capitalization_Rules_Test {

    private static testMethod void validationCorrectTest(){
        List<User> testList = new List<User>();
        User newUser = new User();
        newUser.firstName = 'test';
        newUser.lastName = 'test';
        newUser.email = 'test@ciscotest.com';
        newUser.username = 'test@ciscotest.com';
        newUser.alias = 'test';
        newUser.TimeZoneSidKey ='America/Los_Angeles';
        newUser.LocaleSidKey = 'en_US';
        newUser.EmailEncodingKey ='UTF-8';
        newUser.ProfileId = '00e30000000r9dq';
        newUser.LanguageLocaleKey = 'en_US';
        newUser.Theatre__c = 'Americas-Canada';
        insert newUser; 
        testList.add(newUser);
        
        Test.startTest();
        User_Capitalization_Rules testRules = new User_Capitalization_Rules(); 
        testRules.executeCapitalizationRules(testList);
        System.assertEquals(testList.get(0).FirstName.compareTo('Test') == 0, true);
        Test.stopTest();
    }  
    
    private static testMethod void validationDashesTest(){
        List<User> testList = new List<User>();
        User newUser = new User();
        newUser.firstName = 'test-test';
        newUser.lastName = 'test-test';
        newUser.email = 'test@ciscotest.com';
        newUser.username = 'test@ciscotest.com';
        newUser.alias = 'test';
        newUser.TimeZoneSidKey ='America/Los_Angeles';
        newUser.LocaleSidKey = 'en_US';
        newUser.EmailEncodingKey ='UTF-8';
        newUser.ProfileId = '00e30000000r9dq';
        newUser.LanguageLocaleKey = 'en_US';
        newUser.Theatre__c = 'Americas-Canada';
        insert newUser; 
        testList.add(newUser);
        
        Test.startTest();
        User_Capitalization_Rules testRules = new User_Capitalization_Rules(); 
        testRules.executeCapitalizationRules(testList);
        System.assertEquals(testList.get(0).FirstName.compareTo('Test-Test') == 0, true);
        System.assertEquals(testList.get(0).LastName.compareTo('Test-Test') == 0, true);
        Test.stopTest();
    }  
    
    private static testMethod void validationSpacesTest(){
        List<User> testList = new List<User>();
        User newUser = new User();
        newUser.firstName = 'test test';
        newUser.lastName = 'test test';
        newUser.email = 'test@ciscotest.com';
        newUser.username = 'test@ciscotest.com';
        newUser.alias = 'test';
        newUser.TimeZoneSidKey ='America/Los_Angeles';
        newUser.LocaleSidKey = 'en_US';
        newUser.EmailEncodingKey ='UTF-8';
        newUser.ProfileId = '00e30000000r9dq';
        newUser.LanguageLocaleKey = 'en_US';
        newUser.Theatre__c = 'Americas-Canada';
        insert newUser; 
        testList.add(newUser);
        
        Test.startTest();
        User_Capitalization_Rules testRules = new User_Capitalization_Rules(); 
        testRules.executeCapitalizationRules(testList);
        System.assertEquals(testList.get(0).FirstName.compareTo('Test Test') == 0, true);
        System.assertEquals(testList.get(0).LastName.compareTo('Test Test') == 0, true);
        Test.stopTest();
    }  
    
    private static testMethod void validationApostropheTest(){
        List<User> testList = new List<User>();
        User newUser = new User();
        newUser.firstName = 'test-test';
        newUser.lastName = 'o\'test';
        newUser.email = 'test@ciscotest.com';
        newUser.username = 'test@ciscotest.com';
        newUser.alias = 'test';
        newUser.TimeZoneSidKey ='America/Los_Angeles';
        newUser.LocaleSidKey = 'en_US';
        newUser.EmailEncodingKey ='UTF-8';
        newUser.ProfileId = '00e30000000r9dq';
        newUser.LanguageLocaleKey = 'en_US';
        newUser.Theatre__c = 'Americas-Canada';
        insert newUser; 
        testList.add(newUser);
        
        Test.startTest();
        User_Capitalization_Rules testRules = new User_Capitalization_Rules(); 
        testRules.executeCapitalizationRules(testList);
        System.assertEquals(testList.get(0).FirstName.compareTo('Test-Test') == 0, true);
        System.assertEquals(testList.get(0).LastName.compareTo('O\'Test') == 0, true);
        Test.stopTest();
    }  
    
     private static testMethod void validationFirstNameTest(){
        List<User> testList = new List<User>();
        User newUser = new User();
        newUser.firstName =  null;
        newUser.lastName = 'o\'test';
        newUser.email = 'test@ciscotest.com';
        newUser.username = 'test@ciscotest.com';
        newUser.alias = 'test';
        newUser.TimeZoneSidKey ='America/Los_Angeles';
        newUser.LocaleSidKey = 'en_US';
        newUser.EmailEncodingKey ='UTF-8';
        newUser.ProfileId = '00e30000000r9dq';
        newUser.LanguageLocaleKey = 'en_US';
        newUser.Theatre__c = 'Americas-Canada';
        insert newUser; 
        testList.add(newUser);
        
        Test.startTest();
        User_Capitalization_Rules testRules = new User_Capitalization_Rules(); 
        testRules.executeCapitalizationRules(testList);
        System.assertEquals(testList.get(0).FirstName == null, true);
        System.assertEquals(testList.get(0).LastName.compareTo('O\'Test') == 0, true);
        Test.stopTest();
    }  
}