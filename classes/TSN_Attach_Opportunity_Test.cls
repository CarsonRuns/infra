@isTest(SeeallData=true)

private Class TSN_Attach_Opportunity_Test{
     private static testMethod void test(){
          Account a = new Account(name='TestVC',RecordtypeId = '0123000000004aV');
        insert a;
        Contact co = new Contact(AccountId = a.Id, LastName = 'Test', Email = 'test@cisco.com' , RecordtypeId = '01280000000G6ti');
        insert co; 
        Case testTSNCase1 = new Case(AccountId = a.Id,RecordtypeId =Utilities.getCaseTSNRecordTypeId(),ContactId = co.Id,Contact_Type__c = 'Partner',Country__c = 'Albania', Origin = 'Web');
        testTSNCase1.web_cco_id__c='TESTccoId3@cisco.com';
        testTSNCase1.suppliedemail='TESTccoId3@cisco.com';
        testTSNCase1.team__c='GVE Tier I';
        testTSNCase1.Architecture__c='Test';
        insert testTSNCase1; // TSN Case
        Case testTSNCase2 = new Case(AccountId = a.Id,RecordtypeId =Utilities.getCaseTSNRecordTypeId(),ContactId = co.Id,Contact_Type__c = 'Partner',Country__c = 'Albania', Origin = 'Web');
        testTSNCase2.web_cco_id__c='TESTccoId3@cisco.com';
        testTSNCase2.suppliedemail='TESTccoId3@cisco.com';
        testTSNCase2.team__c='GVE Tier I';
        testTSNCase2.Architecture__c='Test';
        insert testTSNCase2;
        
        Case testTSNCase3 = new Case(AccountId = a.Id,RecordtypeId =Utilities.getCaseTSNRecordTypeId(),ContactId = co.Id,Contact_Type__c = 'Partner',Country__c = 'Albania', Origin = 'Web');
        testTSNCase3.web_cco_id__c='TESTccoId3@cisco.com';
        testTSNCase3.suppliedemail='TESTccoId3@cisco.com';
        testTSNCase3.team__c='GVE Tier I';
        testTSNCase3.Architecture__c='Test';
        insert testTSNCase3;
        
        
          Utilities.setValidationSkip(true);
         Test.StartTest();
         PageReference pageRef1 = ApexPages.currentPage();
         pageRef1.getParameters().put('id',testTSNCase1.Id);
         ApexPages.StandardController controller1 = new ApexPages.StandardController(testTSNCase1);       
         
         
        // Cisco_Sales_Cases User  
         //User currentUser = [Select id from user where profileid=:Utilities.getTSNProfileId() and IsActive = True limit 1];
         User currentUser = [Select id from user where username like 'sfdc_apex_user@cisco.com%'];
         Group gp1=new Group(name='GVE Tier I');
         insert gp1;
         Group gp2=new Group(name='Front Line');
         insert gp2;
         TSN_Attach_Opportunity_CTE addopty1;
         String optyId;
         System.runAs(currentUser)
         {
            GroupMember gm1=new GroupMember(groupId=gp1.id,userorgroupId=currentUser.id);
            insert gm1;
            testTSNCase1.ownerId=currentUser.Id;
            testTSNCase1.team__c='GVE Tier I';
            
            update testTSNCase1;
            addopty1 = new TSN_Attach_Opportunity_CTE(controller1);           
             addopty1.searchDealId='123';
             addopty1.searchOptyName='test';
             addopty1.searchOptyOwner='';             
             addopty1.doAdvanceSearch();
             addopty1.next();
             addopty1.previous();
             if(addopty1.getHasNext())
                addopty1.next();
                
             if(addopty1.getHasPrevious())
                addopty1.previous();   
                
             List<Opportunity> optyList=addopty1.getResults();
             addopty1.setPageSize(40);
             addopty1.getPageSize();
             
             system.debug('!! optyList.size()='+optyList.size());
             system.debug('!! optyList='+optyList);
             List<Opportunity> optyList1=addopty1.getResults();
             if(optyList1.size()>0)
             {
                 optyId=optyList1[0].id;
                 pageRef1.getParameters().put('opptyId',optyId);
             }
             else{
                 List<Multi_object_Quote__c> moqList1=addopty1.getMOQResults();
                 if(moqList1.size()>0)
                 {
                     if(moqList1[0].Opportunity_Name__c != null)
                     {
                         optyId=moqList1[0].Opportunity_Name__c;
                         pageRef1.getParameters().put('opptyId',optyId);
                     }
                     else
                     {
                         pageRef1.getParameters().put('QuoteId',moqList1[0].id);
                     }
                 }
             }
    
             pageRef1.getParameters().put('opptyId',optyId);
             System.debug('Before first save');             
             addopty1.save();
            string strjson =  '{"responseId":"111111","status":1,"data":{"endCustAddressLine1":"562 WELLINGTON ST","dealName":"check_reject","expectedServiceListAmount":0,"quoteId":4713141787,"endCustCity":"LONDON","dealExpirationDate":"2017-01-28","quoteServiceListAmount":0,"dealCreatedOn":"2016-09-16","quoteProductListAmount":433,"endCustCountry":"","endCustZipCode":"","dealId":22969560,"endCustAddressLine2":"","endCustAddressLine3":"","CCWDealStatus":"Approval In Progress","promotionId":0,"discountType":"None","endCustAccountName":"GOOGLE","endCustProvince":"ON","quoteProdNetAmt":82,"expectedProductListAmount":0,"endCustAccountSiteID":218544736,"quoteServNetAmt":0,"dealStatus":"Rejected"},"statusMsg":"SUCCESS"}';
             pageRef1.getParameters().put('node', strjson);
             addopty1.IWantToDebug(); 
             addopty1.ClearDeal();
             addopty1.OwnerGroup();  
         }              
         pageRef1 = ApexPages.currentPage();
         pageRef1.getParameters().put('id',testTSNCase2.Id);
         ApexPages.StandardController controller2 = new ApexPages.StandardController(testTSNCase2); 
         System.runAs(currentUser)
         {
            addopty1 = new TSN_Attach_Opportunity_CTE(controller2);
            addopty1.searchDealId='12344444';
            addopty1.searchOptyName='';
            addopty1.searchOptyOwner='';
            addopty1.doAdvanceSearch();
         }
         
         List<Opportunity> optyList1=addopty1.getResults();
         if(optyList1.size()>0)
         {
             optyId=optyList1[0].id;
             pageRef1.getParameters().put('opptyId',optyId);
         }
         else{
             List<Multi_object_Quote__c> moqList1=addopty1.getMOQResults();
             if(moqList1.size()>0)
             {
                 if(moqList1[0].Opportunity_Name__c != null)
                 {
                     optyId=moqList1[0].Opportunity_Name__c;
                     pageRef1.getParameters().put('opptyId',optyId);
                 }
                 else
                 {
                     pageRef1.getParameters().put('QuoteId',moqList1[0].id);
                 }
             }
         }
         pageRef1.getParameters().put('opptyId',optyId);
         System.debug('Before first save');
         System.runAs(currentUser)
         {
             addopty1.save();
         }
         Test.StopTest();
    }
    private static testMethod void test1(){
         Account a = new Account(name='TestVC',RecordtypeId = '0123000000004aV');
        insert a;
        Contact co = new Contact(AccountId = a.Id, LastName = 'Test', Email = 'test@cisco.com' , RecordtypeId = '01280000000G6ti');
        insert co; 
        Case testTSNCase1 = new Case(AccountId = a.Id,RecordtypeId =Utilities.getCaseTSNRecordTypeId(),ContactId = co.Id,Contact_Type__c = 'Partner',Country__c = 'Albania', Origin = 'Web');
        testTSNCase1.web_cco_id__c='TESTccoId3@cisco.com';
        testTSNCase1.suppliedemail='TESTccoId3@cisco.com';
        testTSNCase1.team__c='GVE Tier I';
        testTSNCase1.Architecture__c='Test';
        insert testTSNCase1; // TSN Case
        Case testTSNCase2 = new Case(AccountId = a.Id,RecordtypeId =Utilities.getCaseTSNRecordTypeId(),ContactId = co.Id,Contact_Type__c = 'Partner',Country__c = 'Albania', Origin = 'Web');
        testTSNCase2.web_cco_id__c='TESTccoId3@cisco.com';
        testTSNCase2.suppliedemail='TESTccoId3@cisco.com';
        testTSNCase2.team__c='GVE Tier I';
        testTSNCase2.Architecture__c='Test';
        insert testTSNCase2;
        
        Case testTSNCase3 = new Case(AccountId = a.Id,RecordtypeId =Utilities.getCaseTSNRecordTypeId(),ContactId = co.Id,Contact_Type__c = 'Partner',Country__c = 'Albania', Origin = 'Web');
        testTSNCase3.web_cco_id__c='TESTccoId3@cisco.com';
        testTSNCase3.suppliedemail='TESTccoId3@cisco.com';
        testTSNCase3.team__c='GVE Tier I';
        testTSNCase3.Architecture__c='Test';
        insert testTSNCase3;
        
          Utilities.setValidationSkip(true);
         Test.StartTest();
         PageReference pageRef1 = ApexPages.currentPage();
         pageRef1.getParameters().put('id',testTSNCase1.Id);
         ApexPages.StandardController controller1 = new ApexPages.StandardController(testTSNCase1);       
        
         User currentUser = [Select id from user where username like 'sfdc_apex_user@cisco.com%'];
         TSN_Attach_Opportunity_CTE addopty1;
         String optyId;
         System.runAs(currentUser)
         {
            testTSNCase1.ownerId=currentUser.Id;
            testTSNCase1.team__c='GVE Tier I';
            
            update testTSNCase1;
            addopty1 = new TSN_Attach_Opportunity_CTE(controller1);           
            addopty1.searchDealId='9999';
            addopty1.searchOptyName='';
            addopty1.searchOptyOwner='';
            addopty1.setPageSize(1);
            addopty1.getPageSize(); 
            addopty1.doAdvanceSearch();
            
            List<Opportunity> optyList=addopty1.getResults();
            system.debug('===111111===>'+optyList);
            
             if(optyList.size()>0)
             {
                 optyId=optyList[0].id;
                 pageRef1.getParameters().put('opptyId',optyId);
             }
            try{
            addopty1.save();
            }catch(Exception e){}
        }    
    }        
}