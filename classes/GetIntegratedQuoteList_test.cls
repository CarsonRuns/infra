/**
* @author       Shahrukh Sheikh
* @version      Intial version (1.0)
* @since        2019-01-23 (YYYY-MM-DD)
* @description  Manually Quote Integration from framework controller class
* @modification log
* iTrack#       Date           Author               Change
				2019-04-12     Sampoorna Bacha      Coverting vf page to lightning
**/

@isTest
global class GetIntegratedQuoteList_test{
    public static void quoteIntegrate(){
        User admin = CEE_TestUtility.getUser('admin', true);
        system.Runas(admin) {
        List<Org_Constant_CS__c> OrgCSlist = new List<Org_Constant_CS__c>();
            //Insert record in Object Record type custom setting for Account creation
            // record
            ObjectRecordTypeIds__c objR = new ObjectRecordTypeIds__c();
            objR.Opportunity_Parent_Mobile_RecordTypeId__c = '01234000000GGKw';
            insert objR;
            
             ProfileID__c pf = new ProfileID__c();
            pf.Cisco_Renewals__c = '00ec0000000QmlF';
            pf.Cisco_PSS__c = '00e30000000rrZw';       
            insert pf;
            
            //Create Org constant required for opportunity creation
            Org_Constants__c  orgC = new Org_Constants__c();
            orgC.Key__c = 'Oppty: ProfileIds to skip Triggers';
            orgC.prod_value__c = 'For testing';
            orgC.Type__c = 'URL';
            insert orgC;
                       
            Org_Constant_CS__c orgCS = new Org_Constant_CS__c();
            orgCS.Name = 'QI_Invalid_Status';
            orgCS.Production_Value__c = 'Expired,Cancelled,Rejected,Lost,Closed,Approved,Ordered';
            orgCS.Non_Production_Value__c = 'Expired,Cancelled,Rejected,Lost,Closed,Approved,Ordered';
            OrgCSlist.add(orgCS);
            
            Org_Constant_CS__c orgCS1 = new Org_Constant_CS__c();
            orgCS1.Name = 'QI_Valid_Status';
            orgCS1.Production_Value__c = 'Not Approved,Submitted,Qualification in Progress,More Information Required,Re-Opened,Approval In Progress,More Information Required - BOM,Approved Not Ready To Order,Not Submitted,Qualified';
            orgCS1.Non_Production_Value__c = 'Not Approved,Submitted,Qualification in Progress,More Information Required,Re-Opened,Approval In Progress,More Information Required - BOM,Approved Not Ready To Order,Not Submitted,Qualified';
            OrgCSlist.add(orgCS1);
            
            Org_Constant_CS__c orgCS2 = new Org_Constant_CS__c();
            orgCS2.Name = 'QI_CCW_RestAPI_URL';
            orgCS2.Production_Value__c = 'https://wsgx-test.cisco.com/ccwquote/core/acv/dataMigration';
            orgCS2.Non_Production_Value__c = 'https://wsgx-test.cisco.com/ccwquote/core/acv/dataMigration';
            OrgCSlist.add(orgCS2);
            
            Org_Constant_CS__c orgCS3 = new Org_Constant_CS__c();
            orgCS3.Name = 'QI_CCW_Webservice_Password';
            orgCS3.Production_Value__c = ',5nN%M-7d:';
            orgCS3.Non_Production_Value__c = ',5nN%M-7d:';
            OrgCSlist.add(orgCS3);
 
            Org_Constant_CS__c orgCS4 = new Org_Constant_CS__c();
            orgCS4.Name = 'QI_CCW_Webservice_Username';
            orgCS4.Production_Value__c = 'qibulkintgr.gen';
            orgCS4.Non_Production_Value__c = 'qibulkintgr.gen';
            OrgCSlist.add(orgCS4);
            
            Org_Constant_CS__c orgCS5 = new Org_Constant_CS__c();
            orgCS5.Name = 'QI_Timer_for_Payload_Method';
            orgCS5.Production_Value__c = '60000';
            orgCS5.Non_Production_Value__c = '60000';
            OrgCSlist.add(orgCS5);
    
            Org_Constant_CS__c orgCS10 = new Org_Constant_CS__c();
            orgCS10.Name = 'QI_Quote_RelatedList_URL';
            orgCS10.Production_Value__c = 'https://ciscosales--qtr.lightning.force.com/lightning/r/####/related/Partner_Quotes__r/view?ws=%2Flightning%2Fr%2FOpportunity%2F####%2Fview';
            orgCS10.Non_Production_Value__c = 'https://ciscosales--qtr.lightning.force.com/lightning/r/####/related/Partner_Quotes__r/view?ws=%2Flightning%2Fr%2FOpportunity%2F####%2Fview';
            OrgCSlist.add(orgCS10);
            
            Org_Constant_CS__c orgCS11 = new Org_Constant_CS__c();
            orgCS11.Name = 'QI_spinner_time_period';
            orgCS11.Production_Value__c = '20';
            orgCS11.Non_Production_Value__c = '20';
            OrgCSlist.add(orgCS11);
 
            
            insert OrgCSlist;
            
            //Create new Accounts
            Account acc = GenericStaticTestData.getTestEndUserAccountRecordRed();
            Account acc1 = GenericStaticTestData.gettestChannelAccountRecord1();
             String ParentRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Parent Opportunity').getRecordTypeId();
            //Create new opportunity
            Opportunity oppty1 = new Opportunity(name='Test', accountId = acc.id, StageName='2 - Qualified', CloseDate=System.today() + 50, Expected_Product__c=10.0,
                                                error_description__c='error', DealID__c='1', Opportunity_Status__c='Active', recordtypeId=ParentRecordTypeId , Opportunity_Owner_AM__c =userinfo.getUserId(),
                                                Primary_Partner__c = acc1.id, Competitors__c = 'A10 Networks', Is_Product_Quote_Integrated__c = 'Yes', Is_Service_Quote_Integrated__c = 'No' ); 
            insert oppty1;
            
            Quote__c quote1 = new Quote__c( Name = 'test1',
                                    Opportunity_Name__c  =  oppty1.Id ,
                                    DM_Quote_ID__c = '8765432109',
                                    Quote_Product_List_Amount__c= 185.0,
                                    Quote_Product_Net_Amount__c = 107.0,
                                    Quote_Service_List_Amount__c = 0.0,
                                    Quote_Service_Net_Amount__c = 0.0,
                                    CBN_Status__c = 'NOT ELIGIBLE' , 
                                    CurrencyIsoCode = 'USD',
                                    CCW_Deal_Status_MQ__c = 'Not Approved' ,
                                    Integrate_Status__c='Inprogress'
                                  );
       insert quote1 ; 
       
       
       Quote__c quote2 = new Quote__c( Name = 'test12',
                                    Opportunity_Name__c  =  oppty1.Id ,
                                    DM_Quote_ID__c = '8765432109',
                                    Quote_Product_List_Amount__c= 185.0,
                                    Quote_Product_Net_Amount__c = 107.0,
                                    Quote_Service_List_Amount__c = 0.0,
                                    Quote_Service_Net_Amount__c = 0.0,
                                    CBN_Status__c = 'NOT ELIGIBLE' , 
                                    CurrencyIsoCode = 'USD',
                                    CCW_Deal_Status_MQ__c = 'Approved' ,
                                    Integrate_Status__c='IntStatus'
                                  );
       insert quote2 ;
       
       Quote__c quote3 = new Quote__c( Name = 'test2',
                                    Opportunity_Name__c  =  oppty1.Id ,
                                    DM_Quote_ID__c = '9765432108',
                                    Quote_Product_List_Amount__c= 185.0,
                                    Quote_Product_Net_Amount__c = 107.0,
                                    Quote_Service_List_Amount__c = 0.0,
                                    Quote_Service_Net_Amount__c = 0.0,
                                    CBN_Status__c = 'NOT ELIGIBLE' , 
                                    CurrencyIsoCode = 'USD',
                                    CCW_Deal_Status_MQ__c= 'Cancelled' 
                                  );
       insert quote3 ;
                    
        }
        
        List<Opportunity> opList = new List<Opportunity>();
        List<Quote__c> quoteList = new List<Quote__c>();
        
        //List<Opportunity> opList = new List<Opportunity>();
        //List<Quote__c> quoteList = new List<Quote__c>();

    //Fetch Opportunity id from test setup
        Opportunity oppty = [select id from Opportunity where name = 'Test' limit 1];       
      opList.add(oppty); 
   
        Quote__c quot1 = [Select Id, Name,Integrate_Status__c, CCW_Deal_Status_MQ__c , 
                             CBN_Status__c, CCW_Deal_Status__c ,
                            Deal_ID__c , Initiated_By__c , Integrated_Quote__c,
                            PartnerAcctId__r.Name, Is_Collaborated__c , DM_Quote_ID__c ,
                            Quote_Summary__c,LastModifiedDate from Quote__c where Opportunity_Name__c = :oppty.Id and Name='test1'
                       ];     
                       
       quoteList.add(quot1);
       
       Quote__c quot2 = [Select Id, Name,Integrate_Status__c, CCW_Deal_Status_MQ__c , 
                             CBN_Status__c, CCW_Deal_Status__c ,
                            Deal_ID__c , Initiated_By__c , Integrated_Quote__c,
                            PartnerAcctId__r.Name, Is_Collaborated__c , DM_Quote_ID__c ,
                            Quote_Summary__c,LastModifiedDate from Quote__c where Opportunity_Name__c = :oppty.Id and Name='test2'
                       ];     
                       
       quoteList.add(quot2);
 
       Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator() ); 
              
       /*Test.StartTest();
              
        Test.setCurrentPage(Page.LtngIntegrateQuote);
        ApexPages.currentPage().getParameters().put('id', oppty.id); 
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(quoteList);
        stdSetController.setSelected(quoteList);

        ApexPages.StandardController sc = new ApexPages.StandardController(oppty);        
        GetIntegratedQuoteList objGetInteg = new  GetIntegratedQuoteList(stdSetController);
           stdSetController.getSelected();
      
         GetIntegratedQuoteList.QuotesWrapper Wrap1 = new GetIntegratedQuoteList.QuotesWrapper(quot1);
          Wrap1.selected = true;    
         objGetInteg.wrappedQuotesList.add(Wrap1);
         objGetInteg.init();
         objGetInteg.validateState();
         objGetInteg.processSelected();
         PageReference  p1 = objGetInteg.cancel();
         PageReference  p2 = objGetInteg.CheckReload();
         GetIntegratedQuoteList.flsUpdateGet(Quote__c.Integrate_Status__c);

          GetIntegratedQuoteList objGetInteg2 = new  GetIntegratedQuoteList(stdSetController);
          GetIntegratedQuoteList.QuotesWrapper Wrap2 = new GetIntegratedQuoteList.QuotesWrapper(quot2);
          wrap2.selected = true;
          objGetInteg2.wrappedQuotesList .add(wrap2);
          objGetInteg2.init();
          objGetInteg2.validateState();
          objGetInteg2.processSelected();
          PageReference  p3 = objGetInteg2.cancel();
          PageReference  p4 = objGetInteg2.CheckReload();
          //GetIntegratedQuoteList.flsUpdateGet(Quote__c.Integrate_Status__c);

          
          
       Test.StopTest();  */         
    
    }
    
    public static testMethod void findQuoteDetailsTest()
    {
        GetIntegratedQuoteList_test.quoteIntegrate();
        Opportunity oppty = [select id from Opportunity limit 1];
        GetIntegratedQuoteList.pageValidationWrapper pageValidationWrapperInstance= new GetIntegratedQuoteList.pageValidationWrapper();
        pageValidationWrapperInstance=GetIntegratedQuoteList.findQuoteDetails(oppty.Id);
        GetIntegratedQuoteList.pageValidationWrapper pageValidationWrapperInstance1= new GetIntegratedQuoteList.pageValidationWrapper();
        pageValidationWrapperInstance1=GetIntegratedQuoteList.integrateQuoteProcess(JSON.serialize(pageValidationWrapperInstance));
       // new GetIntegratedQuoteList().callPayloadService(String.valueOf([select Id from Quote__c limit 1].Id).substring(0,15) );
    }
    
    /*public static testMethod void callPayloadServiceTest()
    {
        Quote__c quot2 = [Select Id FROM Quote__c WHERE Name = 'test1' LIMIT 1];
        String returnCallPayloadService=new QI_QuoteIntegrationCls().callPayloadService(quot2.Id);
    }*/
    
    public static testMethod void newGuidTest()
    {
        String newGuidReturn=GetIntegratedQuoteList.newGuid();
    }
    
    public static testMethod void getCharAtIndexTest()
    {
        String getCharAtIndexReturn=GetIntegratedQuoteList.getCharAtIndex('',0);
    }
    
    
    global class MockHttpResponseGenerator implements HttpCalloutMock {
    
        global HTTPResponse respond(HTTPRequest req) {
            
            System.assertEquals('https://wsgx-test.cisco.com/ccwquote/core/acv/dataMigration', req.getEndpoint());
            System.assertEquals('POST', req.getMethod());
            
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"foo":"bar"}');
            res.setStatusCode(200);
            return res;
        }
    }
}