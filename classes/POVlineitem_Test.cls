/**
   @Author <Lakshmisetty.Suresh>
   @name <POVlineitem_Test>
   @CreateDate <11/10/2014>
   @Description <Testclass for Povlineitem>
   @Version <1.0>
  */
  @isTest(seealldata=true)
 private class POVlineitem_Test{
 static testmethod void unitTest(){
    List<user> us = [SELECT Id from user where isactive=true Limit 1]; 
    Contact cnt = GenericStaticTestData.gettestEndUserContactRecord();
    Opportunity opt = GenericStaticTestData.gettestParentOpportunityRecord();
    Proof_of_Value__c povr = new Proof_of_Value__c();     
    povr.Name ='TestMon11';
    povr.Ship_to_Address__c ='Test Addresss';
    povr.Ship_to_Contact_Email__c= 'test@gmail.com';  
    povr.Ship_to_Contact_Name__c= 'Test User';
    povr.Ship_to_Contact_Phone__c= '1223456673';
    povr.POV_Description__c= 'Testing';
    povr.Products__c='AMP';
    povr.PoV_Order_Category__c='POV Security';
    povr.POV_Type__c='strategic';    
    povr.POV_Start_Date__c =system.Today();
    povr.Decision_Date__c =system.Today();
    povr.POV_Duration_Days__c = 45;
    povr.Expected_Bookings__c= 1;
    povr.Lead_SE__c =us[0].id;
    povr.Security_AM__c =us[0].id;
    povr.POV_Contact__c =cnt.id; 
    povr.Plan_to_Win__c =us[0].id;     
    povr.Supporting_Opportunity__c = opt.id;
    povr.POV_Approval_Status__c = 'SAM Work in Progress';
    String cfField = Utilities.getConstant_CS('povcustomfieldname');
    Test.startTest();
    insert povr;
    ApexPages.StandardController povltobj= new ApexPages.StandardController(povr);
    PageReference pageRef = Page.POVeStarLineItem;
    pageRef.getParameters().put(cfField,opt.name);
    Test.setCurrentPage(pageRef);
    POVlineitem plt = new POVlineitem(povltobj);
    plt.getValuesfromdlp();
    plt.getIsDisable();
    plt.getDlpPage();
    plt.redirect();
    plt.getMySessionID();      
    Test.stopTest();     
   }
    
 static testmethod void unitTest1(){
    List<user> us = [SELECT Id from user where isactive=true Limit 1]; 
    Contact cnt = GenericStaticTestData.gettestEndUserContactRecord();
    Opportunity opt = GenericStaticTestData.gettestParentOpportunityRecord();
    Proof_of_Value__c povr = new Proof_of_Value__c();     
    povr.Name ='TestMon11';
    povr.Ship_to_Address__c ='Test Addresss';
    povr.Ship_to_Contact_Email__c= 'test@gmail.com';  
    povr.Ship_to_Contact_Name__c= 'Test User';
    povr.Ship_to_Contact_Phone__c= '1223456673';
    povr.POV_Description__c= 'Testing';
    povr.Products__c='AMP';
    povr.PoV_Order_Category__c='POV Security';
    povr.POV_Type__c='strategic';    
    povr.POV_Start_Date__c =system.Today();
    povr.Decision_Date__c =system.Today();
    povr.POV_Duration_Days__c = 45;
    povr.Expected_Bookings__c= 1;
    povr.Lead_SE__c =us[0].id;
    povr.Security_AM__c =us[0].id;
    povr.POV_Contact__c =cnt.id; 
    povr.Plan_to_Win__c =us[0].id;     
    povr.Supporting_Opportunity__c = opt.id; 
    povr.POV_Approval_Status__c = 'SE Manager Rejected';
    Test.startTest();
    insert povr;
    ApexPages.StandardController povltobj= new ApexPages.StandardController(povr);
    POVlineitem plt = new POVlineitem(povltobj);
    plt.getValuesfromdlp();
    plt.getIsDisable();
    plt.getDlpPage();
    plt.redirect();
    plt.getMySessionID();      
    Test.stopTest();
   }
}