@isTest
public class SO_DCPAttachmentHandler_Test {
    public static  List<Pricebook2> priceBkLst  = new List<Pricebook2> ();
    public static  List<Product2> prod2Lst = new List<Product2>();
    public static  List<Account> accLst = new  List<Account>();
    public static  List<Opportunity> opptyLst = new List<Opportunity>();
    
    
    public static testmethod void SO_DCPAttachmentHandler_Test() {
    
    //Load Org_Constant_CS__c custom settings records from static resource
        List<sObject> lsOrgConstantCs = Test.loadData(Org_Constant_CS__c.sObjectType, 'TestOrgConstantCS');
        List<sObject> lsOrgConstants = Test.loadData(Org_Constants__c.sObjectType, 'OrgConstants');
        insert new ObjectRecordTypeIds__c(Opportunity_Parent_Mobile_RecordTypeId__c ='0123000000003yk', Opportunity_Void_Merged_RecordTypeId__c = '012800000002e0M');
     
        //load custom settings
        User u = new User(Id = UserInfo.getUserId());
        
         Org_Constant_CS__c opptyOwner1 = new Org_Constant_CS__c();
        opptyOwner1.name = 'Test1';
        opptyOwner1.Production_Value__c = '00e340000015SW4';
        opptyOwner1.Non_Production_Value__c = '00e340000015SW4';
        insert opptyOwner1 ;
        String myCCInst  =opptyOwner1.Non_Production_Value__c;

        List<Profile> pList = [SELECT Id FROM Profile WHERE id =:myCCInst ORDER BY Name ASC limit 2];
        List<User> users = new List<User>();

        User admUser = new User();
        admUser.Alias = 'testusr3';
        admUser.Email = 'testusr3@cisco.com.test';
        admUser.EmailEncodingKey = 'UTF-8';
        admUser.LastName = 'Test3';
        admUser.FirstName = 'cecid';
        admUser.Organization__c = 'Test3';
        admUser.LanguageLocaleKey = 'en_US';
        admUser.LocaleSidKey = 'en_US';
        admUser.ProfileId = pList[0].Id;
        admUser.CommunityNickname = 'testusr3';
        admUser.TimeZoneSidKey = 'America/Los_Angeles';
        admUser.UserName = 'testusr3@cisco.com.test';
        admUser.Theatre__c = 'Americas-Canada';
        
        User stdUser1 = new User();
        stdUser1.Alias = 'testusr1';
        stdUser1.Email = 'testusr1@cisco.com.test';
        stdUser1.EmailEncodingKey = 'UTF-8';
        stdUser1.LastName = 'Test1';
        stdUser1.FirstName = 'cecid';
        stdUser1.Organization__c = 'Test1';
        stdUser1.LanguageLocaleKey = 'en_US';
        stdUser1.LocaleSidKey = 'en_US';
        stdUser1.ProfileId = pList[0].Id;
        stdUser1.CommunityNickname = 'testusr1';
        stdUser1.TimeZoneSidKey = 'America/Los_Angeles';
        stdUser1.UserName = 'testusr1@cisco.com.test';
        stdUser1.Theatre__c = 'Americas-Canada';
        
        users.add(admUser);
        users.add(stdUser1);
        System.runAs (u) {
            List<Org_Constant_CS__c> orgConstant = new List<Org_Constant_CS__c>();
            orgConstant.add(new Org_Constant_CS__c(Name='Support Profiles',Non_Production_Value__c='00e30000000dcbfAAA,00e30000000dfUEAAY,00e30000000eca0AAA,00e30000000qiJjAAI,00e30000000dcbgAAA,00e30000000r9dqAAA,04P0q000000CaSjEAK',Production_Value__c='00e30000000dcbfAAA,00e30000000dfUEAAY,00e30000000eca0AAA,00e30000000qiJjAAI,00e30000000dcbgAAA,00e30000000r9dqAAA,04P34000000Gn2iEAC'));
            Org_Constants__c orgCon = new Org_Constants__c ();
            orgCon.Key__c = 'DownloadDCPDocuments' ;
            orgCon.non_prod_value__c ='https://dcpcsprod-dev.cloudapps.cisco.com/dcpcsp/download.jsp?contentId=';
            orgCon.prod_value__c  = 'https://dcpcsprod-dev.cloudapps.cisco.com/dcpcsp/download.jsp?contentId='; 
            insert orgCon ;
            insert orgConstant;
            insert users;
            //added by Kavya
            Profile pList1 = [SELECT Id FROM Profile WHERE Name ='Cisco_Renewals' limit 1];
        	Profile pList2 = [SELECT Id FROM Profile WHERE Name ='zzDont_USE_Cisco_PSS' limit 1];
            ProfileID__c pf = new ProfileID__c();
            pf.Cisco_Renewals__c = String.valueOf(pList1.Id).substring(0, 15);
            pf.Cisco_PSS__c = String.valueOf(pList2.Id).substring(0, 15);    
            insert pf;
            //ends here  
        }
        
        Map<String,String> headerMap = new Map<String, String>{'Content-Type'=>'application/json'};
        String endPointName = 'DownloadDCPDocuments';
        String jsonString  = '{"contentListing":[{"accessGroupName":null,"accessId":0,"activityId":[],"approverId":null,"author":"idhiman","boldFlag":"N","checkedInBy":"idhiman","checkedInDate":"26-Sep-2017","checkedOutBy":null,"checkedOutDate":null,"checkoutStatus":"N","contentCategory":"Reference Material","contentId":606019,"contentSequenceId":1227470,"contributorId":null,"createdBy":null,"customerContentList":[],"customerNames":null,"customerNumbers":null,"description":null,"dirtyFlag":null,"editable":"Y","edmContentId":"versionStore://version2Store/84cec456-59de-4436-845a-b44230362b0d","eolDate":"26-Sep-2019","errorResponse":null,"extSysDocId":null,"fileName":"world-map.pdf","fileSize":"787","folderId":null,"folderName":null,"folderUpdatedDate":null,"imageGuid":null,"isComplete":"Y","justMyContent":"YES","keywords":"s1optyID:0067A000004CbGa","language":"English - Worldwide","lastCheckedInBy":"idhiman","lastDownloadedDate":null,"lastModifiedDate":"2017092607495300","linkedToMCC":"N","linkFlag":null,"massPublish":"0","massPublishGroup":null,"mimeType":"pdf","missingMetaData":"","ownerId":["jsundare"],"parentFolderId":null,"partyId":[],"projectId":null,"publishDate":"26-Sep-2017","publishFlag":null,"relatedContentStatus":"N","reviewApprovalRecipient":"","reviewerId":null,"showContentId":"Y","status":"Pre-Draft","title":"world-map","version":"0.1"}],"contentSignedList":[],"customerAcceptorList":[],"date":null,"errorResponse":null,"noOfDays":null,"statusFlag":null,"statusMessage":null,"totalRecords":1}' ;
        String method    = 'POST';

       SO_CalloutUtilities.getRequest(headerMap, endPointName, jsonString, method);
          
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://api.salesforce.com/foo/bar');
        req.setMethod('GET'); 
        
        SO_CalloutUtilities.doPost('DownloadDCPDocuments', req);
    
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        priceBkLst.add(customPB);
         
        Product2 prod = new Product2(Name = 'AS-S-ANALYTICS SVCS', Business_Entity__c = 'AS-S',CurrencyIsoCode='USD',isActive=true,ProductCode='Service',Unique_BE_SubBE__c ='ASS-ADVANCED SERVICES SUBSCRIPTION-AS SUBSCRIPTION-AS-S-ANALYTICS SVCS-Service');
        insert prod;
        prod2Lst.add(prod);
        
        PricebookEntry pbID = new PricebookEntry(
        Pricebook2Id = customPB.Id, Product2Id = prod.Id,
        UnitPrice = 12000, IsActive = true,
        BE_Sub_BE_Currency_ProductCode__c='AS-S-ANALYTICS SVCS-USD-Service');
        insert pbID;
        
        Account acc =new Account(Name='Test Account', BillingCity='San Francisco');
        accLst.add(acc);  
        
         try{
            if(accLst.size() > 0) {
                insert accLst;
            }
        }catch(Exception e) {
            System.debug('Insert Error : getAccounts'+e.getMessage());
        }   
        
        
        string parentOptyRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Parent Opportunity').getRecordTypeId();
       
        Opportunity newOpportunity = new Opportunity(
            dealid__c                            = 'A111',
            Name                                 = 'Test111',
            AccountId                            = acc.Id,
            StageName                            = '2 - Qualification',
            CloseDate                            = system.today().adddays(2),
            CurrencyIsoCode                      = 'USD',
            expected_product__c                  = 0,
            expected_service__c                  = 100,
            forecast_status__c                   = 'Commit',
            Non_Standard_Terms_and_Conditions__c = 'None',
            recordtypeid                         = parentOptyRecordTypeId,
            ownerId                              = stdUser1.Id,
            Opportunity_Owner_AM__c              = stdUser1.Id,
            Service_Source__c                    = 'New',
            Close_Probability__c                 = 75
        );
        
        opptyLst.add(newOpportunity);
        try{
            if(opptyLst.size() > 0) {
                insert opptyLst;
            }
        }catch(Exception e) {
            System.debug('Insert Error : opptyLst'+e.getMessage());
        }   
 
        System.debug('Opportunity List=>'+opptyLst);
        
        List<Opportunity>   opptyRec = [SELECT Id FROM Opportunity LIMIT 1];
        system.debug('opptyRec:'+opptyRec);
        
        test.startTest();
        PageReference pgRef = Page.SO_DCPCaseAttachments;
        Test.setCurrentPageReference(pgRef); 
            
        pgRef.getParameters().put('id',opptyRec[0].Id);
     
        System.debug('Id Of Oppty1=>'+opptyRec[0].Id);   
        
            Attachment attachment = new Attachment();
            attachment.Body =Blob.valueOf('{"recordsPerPage":500,"pageNumber":1,"source":"HOME","presetConfiguration":0,"activityId":null,"advanceFilteringRequest":[{"columnName":"contentCategory","filterValue":"{!filterKeyword}","operatorId":16},{"columnName":"status","filterValue":"Approval Not Applicable,Pre-Draft,Draft,Internal Approval Pending,Internal Approved,Internal Rejected,Customer Acceptance Pending,Customer Accepted,Customer Rejected","operatorId":8},{"columnName":"actionTaken","filterValue":"Uploaded/Checked In","operatorId":8},{"columnName":"dealId","filterValue":"{!dealID}","operatorId":8}],"advanceSortDetails":[{"columnName":"lastModifiedDate","order":"desc"}],"projectIdList":""}');       
            attachment.Name = String.valueOf('testFile');
            attachment.ParentId = accLst[0].Id;
            try{
              insert attachment;
              Id parId = [select ID,name,lastmodifieddate,parentId,body,contenttype,bodylength from attachment LIMIT 1].parentId;
              SO_DCPAttachmentHandler.getAttachment(parId);
            }catch(Exception e) {
              System.debug('Insert Error : attachment'+e.getMessage());
           } 
 
        ApexPages.StandardController cntlr = new ApexPages.StandardController(opptyRec[0]);
        System.debug('Standard Controller=>'+cntlr);
        SO_DCPAttachmentHandler dcpAttach = new SO_DCPAttachmentHandler();
        dcpAttach.JSONResponse = '{"contentListing":[{"accessGroupName":null,"accessId":0,"activityId":[],"approverId":null,"author":"idhiman1.5269077802783005E12","boldFlag":"N","checkedInBy":"idhiman","checkedInDate":"26-Sep-2017","checkedOutBy":null,"checkedOutDate":null,"checkoutStatus":"N","contentCategory":"Reference Material","contentId":606019,"contentSequenceId":1227470,"contributorId":null,"createdBy":null,"customerContentList":[],"customerNames":null,"customerNumbers":null,"description":null,"dirtyFlag":null,"editable":"Y","edmContentId":"versionStore://version2Store/84cec456-59de-4436-845a-b44230362b0d","eolDate":"26-Sep-2019","errorResponse":null,"extSysDocId":null,"fileName":"world-map.pdf","fileSize":"787","folderId":null,"folderName":null,"folderUpdatedDate":null,"imageGuid":null,"isComplete":"Y","justMyContent":"YES","keywords":"s1optyID:opptyRec[0].Id","language":"English - Worldwide","lastCheckedInBy":"idhiman","lastDownloadedDate":null,"lastModifiedDate":"2017092607495300","linkedToMCC":"N","linkFlag":null,"massPublish":"0","massPublishGroup":null,"mimeType":"pdf","missingMetaData":"","ownerId":["jsundare"],"parentFolderId":null,"partyId":[],"projectId":null,"publishDate":"26-Sep-2017","publishFlag":null,"relatedContentStatus":"N","reviewApprovalRecipient":"","reviewerId":null,"showContentId":"Y","status":"Pre-Draft","title":"world-map","version":"0.1"}],"contentSignedList":[],"customerAcceptorList":[],"date":null,"errorResponse":null,"noOfDays":null,"statusFlag":null,"statusMessage":null,"totalRecords":1}';
        dcpAttach.parseDCPResponse(); 
              
        Test.setCurrentPageReference(pgRef);            
        
        SO_DCPAttachmentHandler dcpAtt =new SO_DCPAttachmentHandler();
        dcpAtt.JSONResponse = '{"contentListing":[{"accessGroupName":null,"accessId":0,"activityId":[],"approverId":null,"author":"idhiman1.5269077802783005E12","boldFlag":"N","checkedInBy":"idhiman","checkedInDate":"26-Sep-2017","checkedOutBy":null,"checkedOutDate":null,"checkoutStatus":"N","contentCategory":"Reference Material","contentId":606019,"contentSequenceId":1227470,"contributorId":null,"createdBy":null,"customerContentList":[],"customerNames":null,"customerNumbers":null,"description":null,"dirtyFlag":null,"editable":"Y","edmContentId":"versionStore://version2Store/84cec456-59de-4436-845a-b44230362b0d","eolDate":"26-Sep-2019","errorResponse":null,"extSysDocId":null,"fileName":"world-map.pdf","fileSize":"78787","folderId":null,"folderName":null,"folderUpdatedDate":null,"imageGuid":null,"isComplete":"Y","justMyContent":"YES","keywords":"s1OpptyId:0067A000003QwkY","language":"English - Worldwide","lastCheckedInBy":"idhiman","lastDownloadedDate":null,"lastModifiedDate":"2017092607495300","linkedToMCC":"N","linkFlag":null,"massPublish":"0","massPublishGroup":null,"mimeType":"pdf","missingMetaData":"","ownerId":["jsundare"],"parentFolderId":null,"partyId":[],"projectId":null,"publishDate":"26-Sep-2017","publishFlag":null,"relatedContentStatus":"N","reviewApprovalRecipient":"","reviewerId":null,"showContentId":"Y","status":"Pre-Draft","title":"world-map","version":"0.1"}],"contentSignedList":[],"customerAcceptorList":[],"date":null,"errorResponse":null,"noOfDays":null,"statusFlag":null,"statusMessage":null,"totalRecords":1}';
        dcpAtt.bannerStatus ='Success';
        dcpAtt.bannerMsg = 'Error';
        dcpAtt.parseDCPResponse();
        dcpAtt.dcpFileList[0].mimeType ='pdf';
        dcpAtt.dcpFileList[0].fileName ='testFile';
        dcpAtt.dcpFileList[0].contentId ='123456';
        dcpAtt.dcpFileList[0].edmContentId ='12345';
        dcpAtt.dcpFileList[0].title ='123456';
        dcpAtt.dcpFileList[0].description ='12345';
        dcpAtt.dcpFileList[0].checkedInDate ='123456';
        dcpAtt.dcpFileList[0].version ='12345';
        dcpAtt.setBannerMsg();
        dcpAtt.bannerStatus ='Failed';
        dcpAtt.setBannerMsg(); 
        SO_DCPAttachmentHandler.getcecId();
        
         try{
             
              SO_DCPAttachmentHandler.getDCPContentAuthToken();
              
            }catch(Exception e) {
              System.debug('Exception in getting auth token'+e.getMessage());
           } 
           
           try{
             
              SO_DCPAttachmentHandler.getDCPUploadAuthToken();
              
            }catch(Exception e) {
              System.debug('Exception in getting auth token'+e.getMessage());
           } 
        //SO_DCPAttachmentHandler.getDCPContentAuthToken();
        //SO_DCPAttachmentHandler.getDCPUploadAuthToken();
        //SO_DCPAttachmentHandler.getDCPDownloadAuthToken();
        system.debug('$$$dcpFileList'+ dcpAtt.dcpFileList);
        
        system.assertEquals(1, dcpAtt.dcpFileList.size());
        
        
        test.stopTest();
    }
}