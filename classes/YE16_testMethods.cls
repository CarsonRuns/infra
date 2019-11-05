@isTest(seeAllData=true)
private class YE16_testMethods {
    //added by Kavya 
    static{
         Utilities.setIsTestMethod(true);
        Utilities.setValidationSkip(true);
    }
    //ends here
    //@author - majanard
    public static testMethod void EmailNotification_Batch_Test() {
       // P360EmailNotificationScheduler sh1 = new P360EmailNotificationScheduler();
        //String sch = '0 0 23 * * ?'; 
       // system.schedule('Test Check', sch, sh1); 
        }
    //@author - bdabbara    
    public static testMethod void jiggy_CustomContactsController_Test(){
        Account accObj = GenericStaticTestData.getTestEndUserAccountRecordGreen(); 
        accObj.Website = 'cisco.com';
        update accObj;
        //ApexPages.Standardcontroller stdCtlAcc = New ApexPages.StandardController(accObj);
       // jiggy_CustomContactsPreviewController jccv = new jiggy_CustomContactsPreviewController(stdCtlAcc);
        //jccv.getJson(); 
    } 
    
     private static testMethod void OpportunityForecastTest()
     {
        
         User opptyOwner = [SELECT id FROM User WHERE username LIKE 'sfdc_apex_user@cisco.com%'];
          User CurrentUser = new User(alias = 'testde',email='testdemoloan@cisco.com',emailencodingkey='UTF-8', lastname='Testing',languagelocalekey='en_US',localesidkey='en_US', profileid = '00e30000000r9aVAAQ',timezonesidkey='America/Los_Angeles',Theatre__c='Global Service Provider', username='testdemoloan@cisco.com');
        insert CurrentUser; 
         system.runAs(CurrentUser){
         Opportunity o = new Opportunity(name='Test',StageName='1 - Prospect', Position__c = 'US COMMERCIAL Dummy Territory',CloseDate=Date.today()+7, Expected_Product__c=100.0, Expected_Service__c= 100.0, Theater__c='USA', RecordTypeId='0123000000003ykAAA',OwnerId = CurrentUser.Id,Opportunity_Owner_AM__c=CurrentUser.Id);
        // commented by Kavya placed start test at line number 50    
         //test.startTest();
         insert o;
         
         Opportunity   phaseOpty = new Opportunity(name='TestQuoteOverview',StageName='1 - Prospect',CloseDate=System.today().adddays(10),Expected_Product__c=10.0,error_description__c='error',DealID__c='1',Opportunity_Status__c='Active',OwnerId = CurrentUser.Id,Opportunity_Owner_AM__c=CurrentUser.Id,Parent_Id__c=o.id,Position__c = o.id); 
            insert phaseOpty;
        //set up and insert new test price entry
        Product2 prod = new Product2(Name = 'Test Prouct', Family = 'Hardware',ProductCode ='Service');
        insert prod;
        Product2 prod1 = new Product2(Name = 'Test Prouct1', Family = 'Hardware',ProductCode ='Technology');
        insert prod1;
        ID pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2ID = pricebookId, Product2Id = prod1.Id, UnitPrice = 1000.0, IsActive = true);
        insert standardPrice; 
        PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2ID = pricebookId, Product2Id = prod.Id, UnitPrice = 1000.0, IsActive = true);
        insert standardPrice1;  
        //create a custom price book  
         //test.startTest();
         OpportunityLineItem UCS = new OpportunityLineItem(Mix__c =100, OpportunityId = o.ID, PricebookEntryId = standardPrice1.Id, Product_Family_US__c='');
         OpportunityLineItem SACHCS = new OpportunityLineItem(Mix__c =100, OpportunityId = o.ID, PricebookEntryId = standardPrice.Id, Service_Category__c = 'CST-Consulting Services Transactional', Service_Level__c = 'SP Mobility', Service_Type__c = 'AS' );
         OpportunityLineItem[] opp = new OpportunityLineItem[]{UCS, SACHCS};
         insert(opp);
         
         ApexPages.currentPage().getParameters().put('id', o.id); 
         test.startTest();       
         ApexPages.StandardController sc = new ApexPages.StandardController(o);         
         OpportunityForecastPosition_CT testOppForecast= new OpportunityForecastPosition_CT(sc);
         Opportunity_Forecasting_Position_CT testOppForecast2 = new Opportunity_Forecasting_Position_CT(sc);
             
         testOppForecast.getForecastPositionOptions();
         
         testOppForecast.saveDesc();
          OpportunityForecastPosition_CT testOppForecast4= new OpportunityForecastPosition_CT(sc);
         testOppForecast.uiTheme = 'Theme4d';
         testOppForecast.saveRecord();
         testOppForecast.cancel();
         OpportunityForecastPosition_CT.updateForecastingPosition(o.id,'US COMMERCIAL Dummy Territory');
         try{
             OpportunityForecastPosition_CT.updateForecastingPosition(o.id,'@@#$##$%%7');
         }
         catch(Exception e){
             System.debug(e.getMessage());
         }
         
         OpportunityForecastPosition_CT.updateForecastingPosition(o.id,'a');
         String RTech = testOppForecast2.redirectTechnology1 = 'true';
         String RServ = testOppForecast2.redirectService1 = 'true';
         String hasFP = testOppForecast2.hasForecastingPosition1;
         testOppForecast.cancel();
         Opportunity_Forecasting_Position_CT testOppForecast3 = new Opportunity_Forecasting_Position_CT(sc);
         testOppForecast3.redirectTechnology1 = 'false';
             Test.stopTest();
         }
    
    
    }
    
    //Added by Pradeep
    private static testMethod void OpportunityForecastTest2()
     {
         User opptyOwner = [SELECT id,Position_1__c FROM User WHERE username LIKE 'sfdc_apex_user@cisco.com%'];

         User CurrentUser = new User(alias = 'testde',email='testdemoloan@cisco.com',emailencodingkey='UTF-8', lastname='Testing',languagelocalekey='en_US',localesidkey='en_US', profileid = '00e30000000r9aVAAQ',timezonesidkey='America/Los_Angeles',Theatre__c='Global Service Provider', username='testdemoloan@cisco.com');
        insert CurrentUser;
         //added by Kavya as DML operation on setup object is not permitted after you have updated a non-setup object (or vice versa)
         system.runAs(CurrentUser){
         Opportunity o = new Opportunity(name='Test',StageName='1 - Prospect', CloseDate=Date.today()+7, Expected_Product__c=100.0, Expected_Service__c= 100.0, Theater__c='USA', RecordTypeId='0123000000003ykAAA',OwnerId = CurrentUser.Id,Opportunity_Owner_AM__c=CurrentUser.Id);
         test.startTest();
         insert o;
         
         Opportunity   phaseOpty = new Opportunity(name='TestQuoteOverview',StageName='1 - Prospect',CloseDate=System.today().adddays(10),Expected_Product__c=10.0,error_description__c='error',DealID__c='1',Opportunity_Status__c='Active',OwnerId = CurrentUser.Id,Opportunity_Owner_AM__c=CurrentUser.Id,Parent_Id__c=o.id,Position__c = o.id); 
            insert phaseOpty;
        //set up and insert new test price entry
        Product2 prod = new Product2(Name = 'Test Prouct', Family = 'Hardware',ProductCode ='Service');
        insert prod;
        Product2 prod1 = new Product2(Name = 'Test Prouct1', Family = 'Hardware',ProductCode ='Technology');
        insert prod1;
        ID pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2ID = pricebookId, Product2Id = prod1.Id, UnitPrice = 1000.0, IsActive = true);
        insert standardPrice; 
        PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2ID = pricebookId, Product2Id = prod.Id, UnitPrice = 1000.0, IsActive = true);
        insert standardPrice1;  
        //create a custom price book  
         
         OpportunityLineItem UCS = new OpportunityLineItem(Mix__c =100, OpportunityId = o.ID, PricebookEntryId = standardPrice1.Id, Product_Family_US__c='');
         OpportunityLineItem SACHCS = new OpportunityLineItem(Mix__c =100, OpportunityId = o.ID, PricebookEntryId = standardPrice.Id, Service_Category__c = 'CST-Consulting Services Transactional', Service_Level__c = 'SP Mobility', Service_Type__c = 'AS' );
         OpportunityLineItem[] opp = new OpportunityLineItem[]{UCS, SACHCS};
         insert(opp);
         ApexPages.currentPage().getParameters().put('id', o.id);         
         ApexPages.StandardController sc = new ApexPages.StandardController(o);
         OpportunityForecastPosition_CT testOppForecast= new OpportunityForecastPosition_CT(sc);
         Opportunity_Forecasting_Position_CT testOppForecast2 = new Opportunity_Forecasting_Position_CT(sc);
         testOppForecast.getForecastPositionOptions();
         testOppForecast.saveDesc();
         testOppForecast.saveRecord();
         OpportunityForecastPosition_CT.saveRecordUpdated(o.id,'b');
         OpportunityForecastPosition_CT.updateForecastingPosition(o.id,'a');
         String RTech = testOppForecast2.redirectTechnology1 = 'true';
         String RServ = testOppForecast2.redirectService1 = 'true';
         String hasFP = testOppForecast2.hasForecastingPosition1;
         testOppForecast.cancel();
         Opportunity_Forecasting_Position_CT testOppForecast3 = new Opportunity_Forecasting_Position_CT(sc);
         testOppForecast3.redirectTechnology1 = 'false';
         }
    
    }
    
    
    private static testMethod void AddTecgnologyTest(){
    
        Opportunity o = new Opportunity(name='Test',StageName='1 - Prospect', Position__c = 'US COMMERCIAL Dummy Territory',CloseDate=Date.today()+7, Expected_Product__c=100.0, Expected_Service__c= 100.0, Theater__c='USA', RecordTypeId='0123000000003ykAAA');
         test.startTest();
         insert o;
         
        //set up and insert new test price entry
        Product2 prod = new Product2(Name = 'Test Prouct', Family = 'Hardware',ProductCode ='Service');
        insert prod;
        Product2 prod1 = new Product2(Name = 'Test Prouct1', Family = 'Hardware',ProductCode ='Technology');
        insert prod1;
        ID pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2ID = pricebookId, Product2Id = prod1.Id, UnitPrice = 1000.0, IsActive = true);
        insert standardPrice; 
        PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2ID = pricebookId, Product2Id = prod.Id, UnitPrice = 1000.0, IsActive = true);
        insert standardPrice1;  
        //create a custom price book  
         
         OpportunityLineItem UCS = new OpportunityLineItem(Mix__c =100, OpportunityId = o.ID, PricebookEntryId = standardPrice1.Id, Product_Family_US__c='');
         OpportunityLineItem SACHCS = new OpportunityLineItem(Mix__c =100, OpportunityId = o.ID, PricebookEntryId = standardPrice.Id, Service_Category__c = 'CST-Consulting Services Transactional', Service_Level__c = 'SP Mobility', Service_Type__c = 'AS' );
         OpportunityLineItem[] opp = new OpportunityLineItem[]{UCS, SACHCS};
         insert(opp);
         OpportunityLineItem UCS1 = new OpportunityLineItem(Mix__c =100, OpportunityId = o.ID, PricebookEntryId = standardPrice1.Id, Product_Family_US__c='');
         OpportunityLineItem SACHCS1 = new OpportunityLineItem(Mix__c =100, OpportunityId = o.ID, PricebookEntryId = standardPrice.Id, Service_Category__c = 'CST-Consulting Services Transactional', Service_Level__c = 'SP Mobility', Service_Type__c = 'AS' );

         OpportunityLineItem[] opp2 = new OpportunityLineItem[]{UCS1, SACHCS1};
         
    
         ApexPages.currentPage().getParameters().put('id', opp[0].id);         
         ApexPages.StandardController sc = new ApexPages.StandardController(opp[0]);
         AddTechnology testOppForecast= new AddTechnology(sc);

         AddTechnology.SaveOppLineItems(opp2,opp,o.id);
         

    }
    
     private static testMethod void AddTecgnologyServiceTest(){
    
        Opportunity o = new Opportunity(name='Test',StageName='1 - Prospect', Position__c = 'US COMMERCIAL Dummy Territory',CloseDate=Date.today()+7, Expected_Product__c=100.0, Expected_Service__c= 100.0, Theater__c='USA', RecordTypeId='0123000000003ykAAA');
         test.startTest();
         insert o;
         Quote__c qt = new Quote__c();
            qt.Opportunity_Name__c = o.ID;
          
         insert qt;
         
        //set up and insert new test price entry
        Product2 prod = new Product2(Name = 'Test Prouct', Family = 'Hardware',ProductCode ='Service');
        insert prod;
        Product2 prod1 = new Product2(Name = 'Test Prouct1', Family = 'Hardware',ProductCode ='Technology');
        insert prod1;
        ID pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2ID = pricebookId, Product2Id = prod1.Id, UnitPrice = 1000.0, IsActive = true);
        insert standardPrice; 
        PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2ID = pricebookId, Product2Id = prod.Id, UnitPrice = 1000.0, IsActive = true);
        insert standardPrice1;  
        //create a custom price book  
         
         OpportunityLineItem UCS = new OpportunityLineItem(Mix__c =100, OpportunityId = o.ID, PricebookEntryId = standardPrice1.Id, Product_Family_US__c='');
         OpportunityLineItem SACHCS = new OpportunityLineItem(Mix__c =100, OpportunityId = o.ID, PricebookEntryId = standardPrice.Id, Service_Category__c = 'CST-Consulting Services Transactional', Service_Level__c = 'SP Mobility', Service_Type__c = 'AS' );
         OpportunityLineItem[] opp = new OpportunityLineItem[]{UCS, SACHCS};
         insert(opp);
         OpportunityLineItem UCS1 = new OpportunityLineItem(Mix__c =100, OpportunityId = o.ID, PricebookEntryId = standardPrice1.Id, Product_Family_US__c='');
         OpportunityLineItem SACHCS1 = new OpportunityLineItem(Mix__c =100, OpportunityId = o.ID, PricebookEntryId = standardPrice.Id, Service_Category__c = 'CST-Consulting Services Transactional', Service_Level__c = 'SP Mobility', Service_Type__c = 'AS' );

         OpportunityLineItem[] opp2 = new OpportunityLineItem[]{UCS1, SACHCS1};
         ApexPages.currentPage().getParameters().put('id', o.id);         
         ApexPages.StandardController sc = new ApexPages.StandardController(o);
         AddTechnologyServices_CT testOppForecast= new AddTechnologyServices_CT(sc); 
    }

    private static testMethod void ModifyUserforecast_Test () {    
    
        ModifyUserForecastCtrl mu=new ModifyUserForecastCtrl();
        mu.newdefault();
        ModifyUserForecastCtrl.updateDefaultForecastingPosition('a');    
    }

    private static testmethod void CEERecordSelect(){
        
        User admin = CEE_TestUtility.getUser('admin', true);
        Account acct =null;
        System.runAs(admin){
          // CEE_TestUtility.loadCustomSettings();
           acct = CEE_TestUtility.getAccount('cee', true);
        }
        User CurrentUser = new User(alias = 'testde',email='testdemoloan@cisco.com',emailencodingkey='UTF-8', lastname='Testing',languagelocalekey='en_US',localesidkey='en_US', profileid = '00e30000000r9aVAAQ',timezonesidkey='America/Los_Angeles',Theatre__c='Global Service Provider', username='testdemoloan@cisco.com');
        insert CurrentUser; 
        Opportunity o = null;
        CEE_Location__c loc = new CEE_Location__c();
         //added by Kavya as DML operation on setup object is not permitted after you have updated a non-setup object (or vice versa)
         
        system.runAs(CurrentUser){
         o = new Opportunity(name='Test',StageName='1 - Prospect', Position__c = 'US COMMERCIAL Dummy Territory',CloseDate=Date.today()+7, Expected_Product__c=100.0, Expected_Service__c= 100.0, Theater__c='USA',CurrencyIsocode = 'USD',OwnerId = CurrentUser.Id,Opportunity_Owner_AM__c=CurrentUser.Id);
        insert o;
    
        /*CEE_Location__c loc = [select Id, Name, Address_Line_1__c, Address_Line_2__c, City__c, Country__c, Department_Code__c,
                            ITCE_Scheduler__c, Languages__c, Location_Type__c, Postal_code__c, Site_Close_Time__c, Site_Open_Time__c,
                            Site_Time_Zone__c, State_Province__c, Primary_Scheduler__c, Secondary_Scheduler__c, Primary_Scheduler_Email__c,
                            Secondary_Scheduler_Email__c from CEE_Location__c where (NOT Name Like '%CPOC%') limit 1];*/
                           //  CEE_Location__c loc = CEE_TestUtility.getLocation('brief', true, 'EBC/EC');
        //CEE_TestUtility.getLocation('brief', true, 'EBC/EC'); 
           
        loc.Name = 'CISCONYR';
        loc.Is_Location_Active__c = 'Yes';
        loc.Location_Type__c = 'CPOC';
        User primaryScheduler = CEE_TestUtility.getUser('CPOC'+'1', true);
        User secondScheduler = CEE_TestUtility.getUser('CPOC'+'2', true);
        loc.Primary_Scheduler__c = primaryScheduler.id;
        loc.Secondary_Scheduler__c = secondScheduler.id;
        loc.Primary_Scheduler_Email__c = primaryScheduler.Email;
        loc.Secondary_Scheduler_Email__c = secondScheduler.Email;
        insert loc;
         }      
        CEE__c briefing = CEE_TestUtility.getBriefing('brief', true, 'Outcome Based Experience (OBX)', acct, o, loc);
         briefing.RecordTypeId = '01280000000GFZz';
        ApexPages.StandardController sc = new ApexPages.StandardController(briefing);
        CEERecordTypeSelection_CTE testCEERecordTypeSel= new CEERecordTypeSelection_CTE(sc);
        testCEERecordTypeSel.ceeRec=briefing ;
        testCEERecordTypeSel.getRecTypeInfoList();        
        testCEERecordTypeSel.GetSf1CeeRecTypeIdsCsv();
        try{
        CEERecordTypeSelection_CTE.fetchRecordTypeList();
        testCEERecordTypeSel.getUserDefaultOpportunityRecordType();
        testCEERecordTypeSel.setRecordType();
        }catch(Exception e){
        }
        
     }
     
      public static testMethod void CEEReportingHelperClass_testmethod(){
    Date todayDate = Date.today();
     Set<String> ceeJiffleEventURLSet = new Set<String>();
        ceeJiffleEventURLSet.add('https://cisco.jifflenow.com/mwc2015/');
        ceeJiffleEventURLSet.add('https://cisco.jifflenow.com/cisco_mwc2015/');
        ceeJiffleEventURLSet.add('https://cisco.jifflenow.com/ces2015/');
        
       Map<String, List<CEE__c>> ceeNewOppMap = new Map<String, List<CEE__c>>();
        Map<String, CEEJiffleEvent__c> ceeJiffleEventURLObjMap = new Map<String, CEEJiffleEvent__c>();
        List<CEEJiffleEvent__c> ceeJiffleEventList = new List<CEEJiffleEvent__c>();
        
        
        List<CEE__c> ceeObj = new List<CEE__c>([Select ID, Opportunity__c, Request_status__c, Meeting_Requestor__c, 
            opportunity_value_Status_not_booked__c, 
            Opportunity_value_from_any_Status_to_Boo__c
            from CEE__c where Opportunity__c != null limit 100]);
      
        for(CEE__c ceeM :ceeObj){
              List<CEE__c> ceeNewOppList = new List<CEE__c>();
              ceeNewOppList.add(ceeM);
         }  
        
       ceeJiffleEventList = [SELECT Id,Active_Opportunities_List_Before_Event__c,Jifflenow_Event_URL__c, 
                                     Booked_Opportunities_List_After_180_Days__c, 
                                     Booked_Opportunities_List_After_30_Days__c,
                                     Booked_Opportunities_List_After_90_Days__c,New_Opportunities_After_Event__c, 
                                     Cancelled_Opportunities_List_After_180_D__c,
                                     Lost_Opportunities_List_After_180_Days__c,Opportunities_List_After_180_Days__c,
                                     Opportunities_List_After_30_Days__c,Opportunities_List_After_90_Days__c,
                                     Opportunities_List_Before_Event__c, Opportunities_List_Before_Event_Not_Book__c,New_Opportunities_List__c,
                                      Opp_Value_Before_Expected_Date__c,
                                     Before_Event_Total_Opportunity_Amount__c,
                                     opportunity_value_Status_not_booked__c,Opportunity_Value_From_Booked_Status__c, 
                                     Existing_Opportunities_Before_Event__c, Opportunities_List_Before_Expected_Date__c
                                     FROM CEEJiffleEvent__c WHERE Jifflenow_Event_URL__c IN: ceeJiffleEventURLSet limit 100];
                                                                     
        for(CEEJiffleEvent__c ceeJiffleEventObj: ceeJiffleEventList) {
            ceeJiffleEventURLObjMap.put(ceeJiffleEventObj.Jifflenow_Event_URL__c, ceeJiffleEventObj);   
        }       
           
    }
    
    public static testMethod void unitTest1(){
         Opportunity o = new Opportunity(name='Test',StageName='1 - Prospect', Position__c = 'US COMMERCIAL Dummy Territory',CloseDate=Date.today()+7, Expected_Product__c=100.0, Expected_Service__c= 100.0, Theater__c='USA', RecordTypeId='0123000000003ykAAA',DealId__c ='877633');
         insert o;
         Quote__c quoteId= new Quote__c();
         quoteId.Opportunity_Name__c =o.id;
         quoteId.DM_Quote_ID__c = '1232444';
         insert quoteId;
         ApexPages.Standardcontroller stdCtlQct = New ApexPages.StandardController(quoteId);
         PageReference pr = page.OpptySearch; //redirecting to Opportunity search page
         Test.setCurrentPageReference(pr);
         System.currentPageReference().getParameters().put('retURL',ApexPages.currentPage().getParameters().get('retURL'));
         System.currentPageReference().getParameters().put('AccountName', quoteId.Account_Name__c); 
         Quote_Creation_CTE qcc = new Quote_Creation_CTE(stdCtlQct);
         qcc.check();
         qcc.init();
         boolean boolcheck =qcc.profilecheck;
        
        Quote__c quoteId2= new Quote__c();
         quoteId2.DM_Quote_ID__c = '1232444';
        // insert quoteId2;
         ApexPages.Standardcontroller stdCtlQct2 = New ApexPages.StandardController(quoteId2);
         PageReference pr2 = page.OpptySearch; //redirecting to Opportunity search page
         Test.setCurrentPageReference(pr2);
         System.currentPageReference().getParameters().put('retURL',ApexPages.currentPage().getParameters().get('retURL'));
         System.currentPageReference().getParameters().put('AccountName', quoteId2.Account_Name__c); 
         Quote_Creation_CTE qcc2 = new Quote_Creation_CTE(stdCtlQct2);
         qcc2.check();
         qcc2.init();
         boolean boolcheck2 =qcc2.profilecheck;
    }
    public static testMethod void PartnerQuoteRedirectCTETest()
    {
    Opportunity o = new Opportunity(name='Test',StageName='1 - Prospect', Position__c = 'US COMMERCIAL Dummy Territory',CloseDate=Date.today()+7, Expected_Product__c=100.0, Expected_Service__c= 100.0, Theater__c='USA', RecordTypeId='0123000000003ykAAA',DealId__c ='877633');
         insert o;

      //  Quote__c quoterec=[select id,PartnerAcctId__c,Opportunity_Name__c,DM_Quote_ID__c,Deal_ID__c,Opportunity_Name__r.RecordTypeId,CCW_Deal_Status_MQ__c,Quote_Flags__c,Opportunity_deal_Type__c,Opportunity_Name__r.DealID__c from Quote__c limit 1];
         List<Quote__c> quotelist = new List<Quote__c>();
         Quote__c quoterec= new Quote__c();
         quoterec.Opportunity_Name__c =o.id;
         quoterec.DM_Quote_ID__c = '1232444';
         insert quoterec;
         quotelist.add(quoterec);
         Quote__c quoterec1= new Quote__c();
         quoterec1.Opportunity_Name__c =o.id;
         quoterec1.DM_Quote_ID__c = '1232444';
         quoterec1.CCW_Deal_Status_MQ__c = 'DELETED';
         insert quoterec1;
         quotelist.add(quoterec1);

         ApexPages.Standardcontroller stdCtlQctCTE = New ApexPages.StandardController(quotelist[0]);
         ApexPages.Standardcontroller stdCtlQctCTE1 = New ApexPages.StandardController(quotelist[1]);
         Partner_Quote_Redirect_CTE pQRCTE =new Partner_Quote_Redirect_CTE(stdCtlQctCTE);
         Partner_Quote_Redirect_CTE pQRCTE1 =new Partner_Quote_Redirect_CTE(stdCtlQctCTE1);
         string msg ='testwe';
         pQRCTE.redirect(); 
         pQRCTE1.redirect(); 
         boolean b = pQRCTE.hasMessage;
         pQRCTE.setmessage(msg,true);
    } 
     public static testMethod void ManageDealIdLinkClassTest(){
        List<Opportunity> optList= new List<Opportunity>();
         Opportunity o = new Opportunity(name='Test',StageName='1 - Prospect', Position__c = 'US COMMERCIAL Dummy Territory',CloseDate=Date.today()+7, Expected_Product__c=100.0, Expected_Service__c= 100.0, Theater__c='USA', RecordTypeId='0123000000003ykAAA',DealId__c ='877633');
         optList.add(o);
         insert optList;
         List<Quote__c> qtList = new List<Quote__c>();
         Quote__c qt = new Quote__c();
         qt.Opportunity_Name__c = optList[0].ID;
         qt.DM_Quote_ID__c = '1232444';
         qtList.add(qt);
         insert qtList; 
         PageReference pref = page.InvitationDealIdLinkPage;
         Test.setcurrentpage(pref); 
         Apexpages.currentpage().getparameters().put('oppid',qtList[0].Opportunity_Name__c);
         Apexpages.currentpage().getparameters().put('quoteid' , qtList[0].id);
         Apexpages.currentpage().getparameters().put('ccwdealid' , o.DealId__c);
         Apexpages.currentpage().getparameters().put('dealtype' , '1');
         ApexPages.Standardsetcontroller stdController = New ApexPages.StandardsetController(qtList);
         ManageDealIdLinkClass quoteDealValidate=new ManageDealIdLinkClass(stdController);
         quoteDealValidate.manageDealIdLink(); 
    }
    public static testMethod void ManageDealControllerTest(){
         string pd='';
         string opty='';
         Opportunity Opt;
         boolean boolcheck=false;
         List<Opportunity> optList= new List<Opportunity>();
         Opportunity o = new Opportunity(name='Test',StageName='1 - Prospect', Position__c = 'US COMMERCIAL Dummy Territory',CloseDate=Date.today()+7, Expected_Product__c=100.0, Expected_Service__c= 100.0, Theater__c='USA', RecordTypeId='0123000000003ykAAA',DealId__c ='877633');
         optList.add(o);
         insert optList;
         List<Quote__c> qtList = new List<Quote__c>();
         Quote__c qt = new Quote__c();
         qt.Opportunity_Name__c = optList[0].ID;
         qt.DM_Quote_ID__c = '1232444';
         qtList.add(qt);
         insert qtList; 
         PageReference pref = page.ManageDealPage;
         pref.getparameters().put('id' , optList[0].Id);
         ApexPages.Standardsetcontroller stdCtlQctCTE = New ApexPages.StandardsetController(qtList);
         ManageDealController mDC=new ManageDealController(stdCtlQctCTE);
         mDC.manageDealinfo();
         pd = mDC.pdrdown;
         opty =mDC.opptyid;
         opt = mDC.oppty;
         boolcheck =mDc.profilecheck;
    }
}