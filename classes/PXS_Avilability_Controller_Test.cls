@isTest(SeeAllData = true)
private class PXS_Avilability_Controller_Test {
    
    /*@method: Load Balance VF page tests*/
    private static testMethod void pxsLoadBalanceTest() {      
        //Setup Account
        User admin = CEE_TestUtility.getUser('admin', true);
        Account a = null;
        Opportunity o = null;
        User newUser =null;   
        
           // Get user
           newUser = new User(Alias ='malrathi', Email='malrathi@cisco.com',LastName='Rathinam',TimeZoneSidKey='America/Los_Angeles',LocaleSidKey='en_US',FirstName = 'Malathi',EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US', ProfileId='00e800000014g5u', CommunityNickname='malathi', UserName='malrathi@cisco.com', Theatre__c='EMEAR');
            insert newUser;
        
            
        
            system.debug('New User =='+newUser);
           //Get account
            a = new Account(name='Test End-User Account',CRName__c ='Test End-User Account',RECORDTYPEID='0123000000004aUAAQ',Country__c='UNITED STATES');
           insert a;
           
           //Get Opportunity
           o = new Opportunity(name='Test',Accountid=a.id,StageName='2 - Qualified',CloseDate=System.today() - 50,Expected_Product__c=10.0,error_description__c='error',DealID__c='1',Opportunity_Status__c='Active',recordtypeId=utilities.getOpptyParentRecordTypeId(),Position__c='US PS Market Segment'); 
           insert o;
           
          
            
        //SETUP CASE PXS Request
        Case pxsRequest = new case();
        pxsRequest.RecordTypeId =Utilities.getRequestPXSRecordTypeId();
        pxsRequest.Subject='Test';
        pxsRequest.Status='New';
        pxsRequest.Case_Requester__c=newUser.id;
        pxsRequest.Description='Test';
        pxsRequest.Opportunity__c=o.id;
        pxsRequest.Proposal_Due_Date__c=date.Today()+10;
        pxsRequest.Type_of_Proposal__c='RFI';
        pxsRequest.Vertical_Market__c='Government';
        pxsRequest.Level_of_Service__c='Full Service';
        pxsRequest.Does_Proposal_Include_Recurring_Revenue__c='No';
        pxsRequest.createddate= Date.today(); 
                
        insert pxsRequest;
       //update pxs request
        pxsRequest.status='In Progress';
        pxsRequest.OwnerID=newUser.id;
        pxsRequest.Owner_Change_Date__c = Datetime.now();
        update pxsRequest;
        
        User pUser1=null;
        
         //pUser1 = new User(Alias ='malrathi', Email='malrathi@cisco.com',LastName='Rathinam',TimeZoneSidKey='America/Los_Angeles',LocaleSidKey='en_US',FirstName = 'Malathi',EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US', ProfileId='00e800000014g5u', CommunityNickname='malathi', UserName='malrathi@cisco.com', Theatre__c='EMEAR');
        // insert pUser1;

       //inserted Bid_manager record
       
       PXS_Bid_Manager__c bdm= new PXS_Bid_Manager__c();
        bdm.Bid_Manager__c =newUser.id;
        bdm.name='Test bdm';
        bdm.active__c='Yes';
       insert bdm;

        
        test.starttest();
        ApexPages.StandardController stdItem = new ApexPages.StandardController(pxsRequest);
        PXS_Availability_Controller balanceController = new PXS_Availability_Controller(stdItem);
        balanceController.ShowAvailability();
        balanceController.selSite ='Test bdm';
        balanceController.getBidMangerAvailability();
        balanceController.getAllColourCode();
        balanceController.getDefaultAvailability(pxsRequest,newUser);        
        //Get classes
        PXS_Availability_Controller.Header testHeader = new PXS_Availability_Controller.Header();
        PXS_Availability_Controller.Day testDay = new PXS_Availability_Controller.Day();
        PXS_Availability_Controller.BIDMAvailability testPM1 = new PXS_Availability_Controller.BIDMAvailability ();
        List<PXS_Availability_Controller.BIDMAvailability> listofBids = new List<PXS_Availability_Controller.BIDMAvailability>();
        listofBids.add(testPM1);
        balanceController.addBriefingAvailability(null,DateTime.now()+40, Date.today()+40);
        PXS_Availability_Controller.BIDMAvailability bidm = balanceController.addBriefingAvailability(Null,DateTime.now()+40, Date.today()+40);
        balanceController.setStatusColors(listofBids);
        balanceController.loadDefaultValues();
        Map<Id,Id> idMap = new Map<Id,Id>();
        Map<Id, PXS_Availability_Controller.BIDMAvailability> bidAvaila = new Map<Id, PXS_Availability_Controller.BIDMAvailability>();
        idMap.put(pxsRequest.OwnerID,pxsRequest.Id);
        bidAvaila.put(pxsRequest.Id,testPM1);
        balanceController.finalPersonalsData(idMap,bidAvaila,listofBids);
        
        //Get utility methods
        List<PXS_Availability_Controller.Header> headers = balanceController.getHeaders();
        List<PXS_Availability_Controller.BIDMAvailability> bMavailable = balanceController.setStatusColors(listofBids);
        List<SelectOption> month = balanceController.getDynMonth();
        List<PXS_Availability_Controller.BIDMAvailability> bms = balanceController.caseBIDMAvailability;
        List<SelectOption> sites = balanceController.getDynSite();
        //string selSite = balanceController.selSite;
        
        string selSite = 'GLOBAL ENTERPRISE SEGMENT';
       
        Test.stopTest();
    }
    
    
    
    
    
    
}