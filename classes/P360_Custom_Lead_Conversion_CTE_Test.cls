@isTest(seeAllData = TRUE)
Private Class P360_Custom_Lead_Conversion_CTE_Test{

   public Static testMethod void testLeadConversion(){

   
   Lead l = GenericStaticTestData.gettesteLeadRecord();

   Test.startTest();

   ApexPages.StandardController stdCon = new ApexPages.StandardController(l);
   ApexPages.currentPage().getParameters().put('Id',l.Id); 
   P360_Custom_Lead_Conversion_CTE leadCon = new P360_Custom_Lead_Conversion_CTE(stdCon); 
   leadCon.DoNotCreateOpportunity = FALSE;
   leadCon.SendEmailToRecordOwner = TRUE;  
   leadCon.LaunchSBC();
   leadCon.Convert();

    l = GenericStaticTestData.testManualLeadRecord();
   stdCon = new ApexPages.StandardController(l);
   ApexPages.currentPage().getParameters().put('Id',l.Id); 
   leadCon = new P360_Custom_Lead_Conversion_CTE(stdCon);
   leadCon.Convert();
   
   Org_Constant_CS__c opptyOwner1 = new Org_Constant_CS__c();
        opptyOwner1.name = 'Test1';
        opptyOwner1.Production_Value__c = '00e340000015SW4';
        opptyOwner1.Non_Production_Value__c = '00e340000015SW4';
        insert opptyOwner1 ;
        String myCCInst  =opptyOwner1.Non_Production_Value__c;
       
        List<User> users = new List<user>();
        user u1 = new user(firstName='Test',LastName ='PA Contact', USERNAME='testpa@cisco.com.sales.test',email='testpa@cisco.com.test',ALIAS='testpa',COMMUNITYNICKNAME='testpa',ISACTIVE=True,
                            TIMEZONESIDKEY='America/Los_Angeles',LnP_T_C_Acepted_Date__c=Date.Today()+5,LnP_TC_Reset_Date__c=Date.Today()-5,LnP_TC_Accepted__c=true,PROFILEID =myCCInst ,LANGUAGELOCALEKEY ='en_US',THEATRE__C='APJC-APAC',
                            LOCALESIDKEY ='en_US',EMAILENCODINGKEY='UTF-8');
   
      System.runAs(u1)
     {
      String SBCAccountId = GenericStaticTestData.gettestEndUserAccountRecordRed().id;
      ApexPages.currentPage().getParameters().put('accountid',SBCAccountId );
      leadCon = new P360_Custom_Lead_Conversion_CTE(stdCon);   
     }
    l.Deal_Id__c = '1234';
   update l;
   stdCon = new ApexPages.StandardController(l);   
   leadCon = new P360_Custom_Lead_Conversion_CTE(stdCon);
   leadCon.Convert();
   leadCon.convertLeadToAcctOpptyContact(l.Id,l.End_Customer_Account__c,Null,Null,UserInfo.getUserId(),leadCon.DoNotCreateOpportunity,leadCon.SendEmailToRecordOwner,False,l.status);
   
 Test.stoptest();
   
   
   }

}