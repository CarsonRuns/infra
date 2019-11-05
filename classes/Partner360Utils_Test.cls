@isTest(seeAllData = true)
Private Class Partner360Utils_Test{

 static testMethod void testP360Utils() {
    
    //Test.startTest(); Commented to reduce 101 issue moved line 38
    
    String rolePA = Partner360Utils.getPartnerAdminRole();
    String rolePSR = Partner360Utils.getPartnerSalesRepRole();
    
    Contact c = GenericStaticTestData.gettestPartnerProvidedPAContactRecord();
    System.debug('AccountID$$:'+c.AccountId + '----Admin ROle$$:'+c.Partner_Admin_Roles__c);
    System.debug('####:'+[Select Name, Id from UserRole where PortalAccountId = :c.AccountId and Name like '%Exec%' ]);
    
    Partner360Utils.getTargetArchitectureValues();
    Partner360Utils.getTargetArchitectureForTestClass();
    
    User u = GenericStaticTestData.gettestPAUserRecord();
    
    if(u!=null){
        Partner360Utils.removeAssignPartnerSharingForUser(u.id);
        Partner360Utils.removeEndUserAcctSharingForUser(u.id);
        Partner360Utils.removeRecSharing(u.id);
    }
    
    Partner360Utils.getPortalUserRole(c);
    Partner360Utils.getPortalUserRole(c);    
    
    Partner360Utils.isPartnerAdmin('TEST');
    
    Account channelAccount = GenericStaticTestData.gettestChannelAccountRecord1();    
    Account endUserAccount = GenericStaticTestData.getTestEndUserAccountRecordRed();
    Assigned_Partner__c ap1 = GenericStaticTestData.gettestTargetProspectRecord();
    
    Partner360Utils.getSandboxName();
    Partner360Utils.isProduction();
    Partner360Utils.generateRandomNumericString(2);
        Test.startTest();
    Partner360Utils.endUserAccountAssigned(channelAccount.Id,endUserAccount.Id,null);
    Partner360Utils.endUserAccountAssigned(channelAccount.Id,endUserAccount.Id,ap1.Id);
    
    GenericStaticTestData.gettestPartnerGereratedLeadRecord();
    Partner360Utils.endUserAccountAssigned(channelAccount.Id,endUserAccount.Id,ap1.Id);
    
    //c = GenericStaticTestData.gettestPartnerProvidedPSRContactRecord();
    //Partner360Utils.getPortalUserRole(c);   
    
    test.stopTest();
 }
 
 static testMethod void testP360Utils2(){
    
    Test.startTest();
    
    Contact c = GenericStaticTestData.gettestPartnerProvidedPSRContactRecord();
    User u = GenericStaticTestData.gettestPSRUserRecord();
    Partner360Utils.getPortalUserRole(c);
    Partner360Utils.getPortalUserRole(c);
    //Partner360Utils.isPSR(c.Partner_Admin_Roles__c);
    Partner360Utils.isPSR('TEST');
        
    Test.stopTest();
 
 
 }

}