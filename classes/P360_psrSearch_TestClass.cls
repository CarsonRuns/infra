@isTest
private class P360_psrSearch_TestClass {

   
    public static testmethod void testPSRSearchTP()
    {
       
        Account channelAccount = GenericStaticTestData.gettestChannelAccountRecord1();        
        Account endUserAccount = GenericStaticTestData.gettestEndUserAccountRecordRed();  
        Assigned_Partner__c ap1 = GenericStaticTestData.gettestTargetProspectRecord();    
        
        Test.startTest();  
        
        ApexPages.currentPage().getParameters().put('Id', ap1.Id);
        Apexpages.currentPage().getParameters().put('apId',ap1.id);
        ApexPages.currentPage().getParameters().put('testId', channelAccount.Id);
        Apexpages.currentPage().getParameters().put('psr', '1');
        Apexpages.currentPage().getParameters().put('group1', GenericStaticTestData.gettestPSRUserRecord().Id);
        
        psrSearch_CT controller = new psrSearch_CT();
        
        controller.getPsrName();
        controller.getPsrName2();
        controller.getPsrName3();
        controller.getPsrRecommended();
        
        controller.getIsPartnerAdmin();
        
        User u = GenericStaticTestData.gettestPAUserRecord();
        System.runAs(u){
          controller.getIsPartnerAdmin();        
        }
        
        u = GenericStaticTestData.gettestAMUserRecord();
        System.runAs(u){
          controller.getIsPartnerAdmin();        
        }
        
        controller.methodOne();
        controller.methodTwo();
        //controller.methodThree();
        controller.methodFour();
        
        controller.getUserSet();
        controller.psrSearchPage();
        controller.cancel();
        controller.save();
        
        /*
        Apexpages.currentPage().getParameters().put('psr', '2');
        controller.save();
        
        Apexpages.currentPage().getParameters().put('psr', '3');
        controller.save();
        
        Apexpages.currentPage().getParameters().put('psr', '4');
        controller.save();      
        */
                
        Test.stopTest();     
       
    }
    
    public static testmethod void testPSRSearchLead()
    {   
        Account channelAccount = GenericStaticTestData.gettestChannelAccountRecord1();        
        Account endUserAccount = GenericStaticTestData.gettestEndUserAccountRecordRed();
        Lead l = GenericStaticTestData.gettestPartnerGereratedLeadRecord();
        
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('Id', l.Id);
        Apexpages.currentPage().getParameters().put('apId',l.id);
        ApexPages.currentPage().getParameters().put('testId', channelAccount.Id);
        Apexpages.currentPage().getParameters().put('psr', '1');
        Apexpages.currentPage().getParameters().put('group1', GenericStaticTestData.gettestPSRUserRecord().Id);
        
        psrSearch_CT controller = new psrSearch_CT(null);
                
        controller.getPsrName();
        controller.getPsrName2();
        controller.getPsrName3();
        controller.getPsrRecommended();
        
        controller.methodOne();
        controller.methodTwo();
        //controller.methodThree();
        controller.methodFour();
        controller.save();
        /*
        Apexpages.currentPage().getParameters().put('psr', '2');
        controller.save();
        
        Apexpages.currentPage().getParameters().put('psr', '3');
        controller.save();
        
        Apexpages.currentPage().getParameters().put('psr', '4');
        controller.save();
        */
        Test.stopTest();

    }
    
    public static testmethod void testPSRSearch()
    {
       /*Assigned_Partner__c ap1 = GenericStaticTestData.gettestTargetProspectRecord();    
        Lead l = GenericStaticTestData.gettestPartnerGereratedLeadRecord();
        
        Test.startTest();  
         
        ApexPages.currentPage().getParameters().put('Id', ap1.Id);        
        psrSearch_CT controller = new psrSearch_CT(null);        
        controller.methodThree();
        
        ApexPages.currentPage().getParameters().put('Id', l.Id);        
        controller.methodThree();
        
        Test.stopTest();*/
    }
}