@isTest(SeeAllData=true) 
private class GVE_LiveAgent_PreChat_Test {

    private static testMethod void noCharactersTest(){
        PageReference current = ApexPages.currentPage();
        
        GVE_LiveAgent_PreChat_CTL prechat = new GVE_LiveAgent_PreChat_CTL();
        
    }
    
    private static testMethod void visibilityFormatTest(){
        GVE_LiveAgent_PreChat_CTL prechat = new GVE_LiveAgent_PreChat_CTL();
        
        System.assertEquals(prechat.visibilityFormat(true), 'block');
        System.assertEquals(prechat.visibilityFormat(false), 'none');          
    }
    
    /*private static testMethod void validateEmailTest(){
        NGCC_LiveAgent_PreChat_CTL prechat = new NGCC_LiveAgent_PreChat_CTL();
        
        System.assertEquals(prechat.validateEmail('test@test.com'), true);
        System.assertEquals(prechat.validateEmail('test@test_com'), false);          
    }*/
    
    private static testMethod void validateLAITest(){
        GVE_LiveAgent_PreChat_CTL prechat = new GVE_LiveAgent_PreChat_CTL();
        
        String[] tf;
        String value = 'test';
        String label = 'test';
        
        GVE_LiveAgent_PreChat_CTL.LiveAgentInput la = new GVE_LiveAgent_PreChat_CTL.LiveAgentInput(tf,value,label,tf);
        
        System.assertNotEquals(la, null);
    }

    private static testMethod void getLanguageTest(){
       PageReference p = new PageReference('https://ngccp2-ngccp2-liveagent.cs1.force.com/chat/apex/NGCC_Pre_Chat_Form_Mobile?endpoint=https%3A%2F%2Fon7.la1cs.salesforceliveagent.com%2Fcontent%2Fs%2Fchat%3Flanguage%3Den_US%23deployment_id%3D572S0000000CaVd%26org_id%3D00DS0000003KncP%26button_id%3D573S0000000Cau3%26session_id%3D0e3febb3-a92f-423c-928e-e99e6fbbb8ed');
       Test.setCurrentPage(p);
       GVE_LiveAgent_PreChat_CTL prechat = new GVE_LiveAgent_PreChat_CTL();
       Test.startTest();
       String prechatLang = prechat.getLanguage();
       System.assertEquals(prechatLang, 'en_US');
       Test.stopTest();
    }
    
    private static testMethod void getCountriesList(){
       GVE_LiveAgent_PreChat_CTL prechat = new GVE_LiveAgent_PreChat_CTL();
       Test.startTest();
       List<SelectOption> gc = prechat.getCountries();
       System.assertNotEquals(gc.size(), 0);
       Test.stopTest();
    }    
    
    private static testMethod void dataAssignmentTest(){
       GVE_LiveAgent_PreChat_CTL prechat = new GVE_LiveAgent_PreChat_CTL();
       Test.startTest();
       
       //prechat.dataAssignment('EmailAddressInput', 'test');
       //System.assertEquals( prechat.emailInput ,'test');
       prechat.dataAssignment('FirstNameInput', 'test');
       System.assertEquals( prechat.firstNameInput ,'test');
       prechat.dataAssignment('LastNameInput', 'test');
       System.assertEquals( prechat.lastNameInput ,'test');
       //prechat.dataAssignment('PhoneInput', 'test');
       //System.assertEquals(  prechat.phoneInput ,'test');
       prechat.dataAssignment('CountryInput', 'test');
       System.assertEquals( prechat.countryInput,'test');
       //prechat.dataAssignment('CompanyInput', 'test');
       //System.assertEquals( prechat.companyInput ,'test');
       
       Test.stopTest();
    } 
    
    /*private static testMethod void getOptionsTest(){
       NGCC_LiveAgent_PreChat_CTL prechat = new NGCC_LiveAgent_PreChat_CTL();
       Test.startTest();
       NGCC_Pre_Chat_Configuration__c conf = new NGCC_Pre_Chat_Configuration__c();
       conf.Name = 'test';
       conf.Options__c = 'Accepted:NGCC_Negative';
       insert conf;
       prechat.pcc = conf;
       
       List<SelectOption> gc = prechat.getOptionsList();
       System.assertNotEquals(gc.size(), 0);
       
       Test.stopTest();
    }    */
    
    private static testMethod void initDataParseTest(){
       GVE_LiveAgent_PreChat_CTL prechat = new GVE_LiveAgent_PreChat_CTL();
       
       PageReference current = ApexPages.currentPage();
       current.getParameters().put('node', '[{"transcriptFields":[],"value":"Information","label":"FirstNameInput","entityMaps":[]},{"transcriptFields":[],"value":"Services","label":"LastNameInput","entityMaps":[]},{"transcriptFields":[],"value":"US","label":"CountryInput","entityMaps":[]},{"transcriptFields":[],"value":"0000295337","label":"Keycode","entityMaps":[]},{"transcriptFields":[],"value":"abcd-abcd-abcd-abcd","label":"CookieInput","entityMaps":[]}]');
       Test.setCurrentPage(current);
       Test.startTest();
       prechat.initDataParse();
       Test.stopTest();
    }
    
    private static testMethod void validationTest(){
       GVE_LiveAgent_PreChat_CTL prechat = new GVE_LiveAgent_PreChat_CTL();
     
       Test.startTest();
       //prechat.emailRequested = true;
       //prechat.emailInput = 'test@test_com';
       prechat.firstNameRequested = true;
       prechat.firstNameInput = '';
       prechat.lastNameRequested = true;
       prechat.lastNameInput = '';
       //prechat.optionsVisibility = true;
       //prechat.optionsInput = '';
       //prechat.companyRequested = true;
       //prechat.companyInput = '';
       prechat.countryRequested = true;
       prechat.countryInput = '';
       //prechat.phoneRequested = true;
       //prechat.phoneInput = '';
       
       prechat.validation();
       
       System.assertEquals(prechat.success, false);
     
       Test.stopTest();
    }  
        
    private static testMethod void validationCorrectTest(){
       GVE_LiveAgent_PreChat_CTL prechat = new GVE_LiveAgent_PreChat_CTL();
     
       Test.startTest();
       //prechat.emailRequested = true;
       //prechat.emailInput = 'test@test.com';
       //prechat.optionsInput = 'Accepted';
       prechat.validation();
       
       System.assertEquals(prechat.success, true);
     
       Test.stopTest();
    }  
}