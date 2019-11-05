@istest
private class CaseTestMethods{
    
    private static testMethod void test(){
    	Utilities.setIsTestMethod(true);
        Utilities.setValidationSkip(true);        
        //User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        //ProfileID__c profileId = new ProfileID__c(SetupOwnerId=UserInfo.getOrganizationId(), Cisco_US_Commercial__c=profileId);
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'Cisco_Admin' Limit 1];
        Id profileId = profile.id;
        //insert profileId;
        User thisUser = new User(firstName='Test',LastName ='PA Contact', USERNAME='testpa1@cisco.com.sales.test',email='testpa232@cisco.com.test',ALIAS='testpa',COMMUNITYNICKNAME='testpa',ISACTIVE=True,
                             TIMEZONESIDKEY='America/Los_Angeles',LnP_T_C_Acepted_Date__c=Date.Today()+5,LnP_TC_Reset_Date__c=Date.Today()-5,LnP_TC_Accepted__c=true,PROFILEID =profileId ,LANGUAGELOCALEKEY ='en_US',THEATRE__C='APJC-APAC',
                             LOCALESIDKEY ='en_US',EMAILENCODINGKEY='UTF-8',Additional_User_Permissions__c='Enable EndUser ACCTCreation');
        insert thisUser;
        
        system.runAs(thisUser){ 
        ObjectRecordTypeIds__c  testCust = new ObjectRecordTypeIds__c ();
        testCust.AccountChannelRecordTypeId__c = '0123000000004aV';
        testCust.Contact_PDB_RecordTypeId__c='01280000000G6tn';
        insert testCust;
        
        Org_Constants__c os =new Org_Constants__c();
        os.Key__c = 'Oppty: ProfileIds to skip Triggers';
        os.non_prod_value__c = '00e30000000dcbfAAA,00e30000000dfUEAAY,00e30000000eca0AAA,00e30000000qiJjAAI,00e30000000dcbgAAA,00e30000000rrZwAAI';
        os.Prod_LT__c = 'GSTS,Data_Migration,Integration_Echo_Suppression,GSTS_Analyst,ADMIN, PSS';
        os.prod_value__c = '00e30000000dcbfAAA,00e30000000dfUEAAY,00e30000000eca0AAA,00e30000000qiJjAAI,00e30000000dcbgAAA,00e30000000rrZwAAI';
        os.Type__c = 'URL';
        insert os;
        
        
        ProfileID__c profileIds = new ProfileID__c();
        profileIds.Cisco_Renewals__c = '00e34000001CQnp';
        profileIds.Cisco_PSS__c = '00e30000000rrZw';
        insert profileIds; 
        
        PDI_Collaboration_Countries__c  testCountry = new PDI_Collaboration_Countries__c ();
        testCountry.Name =' Testing';
        testCountry.Country1__c = 'West';
        testCountry.Country2__c ='West';
        testCountry.Country3__c ='West';
        testCountry.Country4__c='West';
        insert testCountry;
        }
        Utilities.setIsTestMethod(true);
        
         
             
Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel').getRecordTypeId();
        Id caserecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('PSTS Case').getRecordTypeId();

        
        Account a = new Account(name='TestVC',RecordtypeId = '0123000000004aV');
        insert a;
        Account a1 = new Account(name='TestVC1',RecordtypeId = '0123000000004aV'); 
        insert a1;
        Contact co = new Contact(AccountId = a.Id, LastName = 'Test', Email = 'test@cisco.com' , RecordtypeId = '01280000000G6ti');
        insert co;   
        Contact co1 = new Contact(AccountId = a.Id, LastName = 'Test2', Email = 'test2@cisco.com', RecordtypeId = '01280000000G6ti');
        insert co1;   
       
        // Cisco_TSN User  

        User currentUser = [select id from User where profileid=:Utilities.getTSNProfileId() and isactive=true limit 1];
        // updateCaseCCWDealsSection method
        //Create new opportunity
        //Id RecordTypeIdopportunity = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Global Deal/Opportunity').getRecordTypeId();
        
        /*
        Multi_Object_Quote__c existingCCWRecord = [select id, Opportunity_Name__c from Multi_Object_Quote__c where Opportunity_Name__c != null limit 1];
        Quote__c quote = [select id, Opportunity_Name__c from Quote__c where Opportunity_Name__c != null AND Integrated_Quote__c = 'Yes' limit 1];
        */

       Group gp1=new Group(name='Front Line');
       insert gp1;
       Group gp2=new Group(name='Group2');
       insert gp2;
       Group gp3=new Group(name='Group3');
       insert gp3;
       Group gp4=new Group(name='GVE Tier I');
       insert gp4;
       System.runAs(currentUser){
       GroupMember gm1=new GroupMember(groupId=gp1.id,userorgroupId=currentUser.id);
       insert gm1;
       GroupMember gm2=new GroupMember(groupId=gp2.id,userorgroupId=currentUser.id);
       insert gm2;
       GroupMember gm3=new GroupMember(groupId=gp4.id,userorgroupId=currentUser.id);
       insert gm3;
       GroupMember gm4=new GroupMember(groupId=gp4.id,userorgroupId=currentUser.id);
       insert gm4;
       
       String str = CaseBO.getGroupName(gm4.Id);
     }
       
        System.runAs(currentUser){
          GroupMember gm1=new GroupMember(groupId=gp1.id,userorgroupId=currentUser.id);
          insert gm1;
           
        }
        
        
        Utilities.setValidationSkip(true);//skips validation rules
        // updateCaseCCWDealsSection method
        Id RecordTypeIdopportunity = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Global Deal/Opportunity').getRecordTypeId();
        Account acc= new Account(name='Test Account',BillingCity='San Francisco'); 
        insert acc;
        
        Opportunity opty = new Opportunity(Theater__c = 'Americas-Canada',Name='Test', AccountId = acc.id, StageName='2 - Qualification', CloseDate=System.today() + 50, Expected_Product__c=10.0,
                                                error_description__c='error', DealID__c='1', Opportunity_Status__c='Active', recordtypeId=RecordTypeIdopportunity, Opportunity_Owner_AM__c =thisUser.id,
                                                Competitors__c = 'A10 Networks', 
                                           Is_Product_Quote_Integrated__c = 'Yes', Is_Service_Quote_Integrated__c = 'No', CCW_BOM_Integrated_Quote_Id__c = '1001',Position__c='Americas lrpearso',
                                          CurrencyIsoCode = 'USD'); 
        insert opty;
        //Opportunity_Owner_AM__c =userinfo.getUserId(),
        Quote__c quote = new Quote__c(Opportunity_Name__c=opty.id, DM_Quote_ID__c = '1001');
        insert quote;
        
        Multi_Object_Quote__c existingCCWRecord = new Multi_Object_Quote__c(Opportunity_Name__c=opty.id,Deal_ID__c= opty.DealID__c);
        insert existingCCWRecord;
        
        
        
        Opportunity opty1 = new Opportunity(Theater__c = 'Americas-Canada',Name='Test', AccountId = acc.id, StageName='2 - Qualification', CloseDate=System.today() + 50, Expected_Product__c=10.0,
                                                error_description__c='error', DealID__c='1', Opportunity_Status__c='Active', recordtypeId=RecordTypeIdopportunity, Opportunity_Owner_AM__c =thisUser.id,
                                                Competitors__c = 'A10 Networks', 
                                           Is_Product_Quote_Integrated__c = 'Yes', Is_Service_Quote_Integrated__c = 'No', CCW_BOM_Integrated_Quote_Id__c = '1002',Position__c='Americas lrpearso',
                                          CurrencyIsoCode = 'USD'); 
        insert opty1;
        
        Quote__c quote1 = new Quote__c(Opportunity_Name__c=opty1.id, DM_Quote_ID__c = '1002');
        insert quote1;
        
        Id tsnRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GVE Case').getRecordTypeId();
        Id pstsRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('PSTS Case').getRecordTypeId();
        Id phRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('PH Case').getRecordTypeId();
        
        //Case c1 = new Case(AccountId = a.Id,RecordtypeId =Utilities.getCasePSTSRecordTypeId(),ContactId = co.Id,status='New');
        Case c1 = new Case(AccountId = a.Id,RecordtypeId =pstsRecTypeId,ContactId = co.Id,status='New');
        //getCasePHRecordTypeId
        c1.web_cco_id__c='TESTccoId1@cisco.com';
        c1.suppliedemail='TESTccoId1@cisco.com';
        insert c1; //PH case
       
        //Case c2 = new Case(AccountId = a.Id,RecordtypeId =Utilities.getCasePSTSRecordTypeId(),ContactId = co.Id);
        Case c2 = new Case(AccountId = a.Id,RecordtypeId =pstsRecTypeId,ContactId = co.Id);
        c2.web_cco_id__c='TESTccoId2@cisco.com';
        c2.suppliedemail='TESTccoId2@cisco.com';
        insert c2; // PDI Case

        //Case c3 = new Case(AccountId = a.Id,RecordtypeId =Utilities.getCaseTSNRecordTypeId(),ContactId = co.Id,Contact_Type__c = 'Partner',Country__c = 'Albania', Origin = 'Web');
        Case c3 = new Case(AccountId = a.Id,RecordtypeId =tsnRecTypeId,ContactId = co.Id,Contact_Type__c = 'Partner',Country__c = 'Albania', Origin = 'Web');
        c3.web_cco_id__c='TESTccoId3@cisco.com';
        c3.suppliedemail='TESTccoId3@cisco.com';
        //c3.ownerId=currentUser.id;
        c3.Architecture__c='Test';
        insert c3; // TSN Case
       
       

        //Automation of CCO ID search
        c1.Web_CCO_ID__c = 'minus';
        AutomationCCOIdSearch.doCCOIdSearch(c1.Id);
        c1.Web_CCO_ID__c = 'tsunilkumar';
        AutomationCCOIdSearch.doCCOIdSearch(c1.Id);
        c1.Web_CCO_ID__c = 'dameyer';
        AutomationCCOIdSearch.doCCOIdSearch(c1.Id);
        
        //May release fix to just moved start test so that governer limit refreshes from line 41
        Test.startTest();

        //Route Web Case
        c1.suppliedemail ='test@cisco.com';
        c1.Case_Language__c = 'English';
        c1.category_PDI__c ='Physical Security';
        c1.country__c ='India';
        List<case> clist1 =  new List<case>();
        clist1.add(c1);
        
        //RouteWebCase.updatePDICase(clist1);

        c1.Case_Language__c = 'Simplified Chinese';
        c1.category_PDI__c = 'Data Center';
        List<case> clist2 =  new List<case>();
        clist2.add(c1);
        //RouteWebCase.updatePDICase(clist2);

        c1.Case_Language__c = 'Portuguese (Brazil)';
        c1.category_PDI__c = 'Smart Grid';
        List<case> clist3 =  new List<case>();
        clist3.add(c1);
        //RouteWebCase.updatePDICase(clist3);

        c1.Case_Language__c = 'Spanish (LATAM)';
        c1.category_PDI__c = 'Collaboration';
        List<case> clist4 =  new List<case>();
        clist4.add(c1);
        //RouteWebCase.updatePDICase(clist4);
        
        //CaseCloseEmailBounce 
        CaseCloseEmailBounce.sendCloseCaseBounceEmail(c1.Id,'test@test.com','SubjectTest','TesttextBody','testFromName'); 
        CaseCloseEmailBounce.sendOwnerEmail(c3.Id,'newuser@test.com','TestName','test@test.com','SubjectTest','TesttextBody'); 
        CaseCloseEmailBounce.sendReplyForDeletedCases('test@test.com','SubjectTest','TesttextBody'); 
       
        // Email Trigger
        EmailMessage msg1 = new EmailMessage(ParentId=c1.Id, FromName = 'Cisco Case Management', Incoming = True, TextBody = 'TestBody' ); 
        Insert msg1;
        EmailMessage msg2 = new EmailMessage(ParentId=c2.Id, FromName = 'Cisco Case Management', Incoming = True, TextBody = 'TestBody' ); 
        Insert msg2;
        EmailMessage msg3 = new EmailMessage(ParentId=c3.Id, FromName = 'Cisco Case Management', Incoming = True, TextBody = 'TestBody' ); 
        Insert msg3;
          
       
       //TSN Prevent Parent Case Close
       Case ch = new Case(Status='New',ParentId=c3.id);
       ch.Architecture__c='Test';
       ch.Assigned_SLA__c = '6 hr';
       insert ch;
       c3.Status = 'Resolved Pending';
       c3.Status_Reason__c='Resolved Successfully';
        try{
            update c3;
        }catch (System.dmlException e1){
            System.assertEquals('Parent case cannot be in Resolved Pending or Closed status when Child cases are open!',e1.getDmlMessage(0));
        } 
       update ch;
       
       //TSN_CaseOwnerSyncWithTeam
      
       ch.ownerId=currentUser.id;
       ch.team__c='Group2';
       update ch;
       try{
       ch.team__c='Group4';
       update ch;
       }catch(Exception exc){}



       //TSN_ChildCase_ParentCase_OwnerEmailIdPopulation
       System.runAs(currentUser)
       {
       //Case c4 = new Case(RecordtypeId =Utilities.getCaseTSNRecordTypeId());
       Case c4 = new Case(RecordtypeId =tsnRecTypeId);
       c4.ownerId=currentUser.id;
       c4.team__c='Group2';
       c4.Origin ='Web';
       c4.Assigned_SLA__c = '4 hr';
       c4.Architecture__c='Test';
       insert c4; // TSN Case
       BusinessHours  bs = caseBO.busHours;
       BusinessHours bhour = CaseBO.getBusinessHours();
       
       //Case ch1 = new Case(ParentId=c4.id,RecordtypeId =Utilities.getCaseTSNRecordTypeId());
           Case ch1 = new Case(ParentId=c4.id,RecordtypeId =tsnRecTypeId);
       ch1.ownerId=currentUser.id;
       ch1.team__c='Group2';
       ch1.Architecture__c='Test';       
       insert ch1;
       List<Case> caseList= new List<Case>();
       caseList.add(c4);
       caseList.add(ch1);
       CaseBO.VcPDBUpdate(caseList);
       caseBO.flsGet(case.Deal_Created_Date__c);
}


   //TSN_Update_Contact_Flags_For_Partner_Contacts
          //Case c4=new Case(AccountId = a.Id,RecordtypeId =Utilities.getCaseTSNRecordTypeId(),ContactId = co.Id);
        Case c4=new Case(AccountId = a.Id,RecordtypeId =tsnRecTypeId,ContactId = co.Id);
          c4.Architecture__c='Test';          
          insert c4;
          c4.contactId=co1.id;
          c4.accountId=a1.id;
          c4.Assigned_SLA__c = '48 hr';
          update c4;

   //PreventCaseDeletion    
     System.runAs(currentUser)
       {
        try{
            delete c4; 
        }
        catch(Exception exc){}
       } 
          
  //UpdateAccountContactByCCOIdContactSearch
          Contact contact1 = new Contact(AccountId = a.Id, LastName = 'Test', Email = 'test@cisco.com' , RecordtypeId = '01280000000G6tn');
          contact1.CCO_ID__c='testUser1,testuser,testuser3';
          contact1.email='testuser@gmail.com';
          insert contact1; 
          
          //Case c5=new Case(RecordtypeId =Utilities.getCaseTSNRecordTypeId());
          Case c5=new Case(RecordtypeId =tsnRecTypeId);
          c5.Web_CCO_ID__c='testuser';
          c5.Origin ='Web';
          c5.suppliedemail='testuser@gmail.com';
          c5.Architecture__c='Test';   
          c5.Assigned_SLA__c = '1 hr';
          //c5.Status = 'New';
          insert c5;
          //mkella
          /*c5.Status = 'Assigned';
          c5.OwnerId = '00580000007kt0u';
          update c5;*/
          
          //Case c6=new Case(RecordtypeId =Utilities.getCasePSTSRecordTypeId());
          Case c6=new Case(RecordtypeId =pstsRecTypeId);
          c6.contactId=co.id;
          c6.Web_CCO_ID__c='testuser6';
          c6.Origin ='Web';
          c6.Opportunity__c = opty1.Id;
          c6.suppliedemail='testuser@gmail.com';
          insert c6;
  
          Case c7=new Case(RecordtypeId =phRecTypeId);
        //Case c7=new Case(RecordtypeId =Utilities.getCasePHRecordTypeId());
          c7.Web_CCO_ID__c='testuser6';
          c7.Origin ='Web';
          c7.suppliedemail='testuser@gmail.com';
          c7.Opportunity__c = opty.Id;
          insert c7;
        
          Id cicRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CIC Security & Trust Customer Engagement Request').getRecordTypeId();
          Case c8=new Case(recordTypeId =cicRecordTypeId);
          //c8.Web_CCO_ID__c='testuser8';
          //c8.Origin ='Web';
          //c8.suppliedemail='testuser@gmail.com';
          c8.AccountId = a.Id;
          c8.Opportunity__c = opty.Id;
          
          c8.OwnerId = '00580000007kt0u';
          // c8.CreatedById = Utilities.getConstant_CS('ConnectionUserId');
          // c8.Architecture__c='Test';          
          insert c8;
          c8.Status = 'Cancelled';
          update c8;
        
        // Case testCase = c7;
        // List<String> globalTriggers =  Spark_System_Config.listTrigger();
        String caseObjTestId = c7.id;
        String testRoomId   = 'Y2lzY29zcGFyazovL3VzL1JPT00vYmNhMTdkNDAtMjQzNy0xMWU2LTk0NmQtN2Y0YWMxYTQwOWFl';
        String mid          = 'Y2lzY29zcGFyazovL3VzL01FTUJFUlNISVAvYzhkMTNmOWQtYzcxMy00NjE5LWEwMDMtZmMxNDhmOWMyZTU1OjlhY2Y3YTQwLTlmNDAtMTFlNS1iMTcxLTMxMTEzZTM4YzhhMQ';
        
        String uniqueLocalKey = UserInfo.getOrganizationId().left(15)+'_'+caseObjTestId.left(15);
        
        
        Spark_Conversation__c sparkObj = new Spark_Conversation__c();
        sparkObj.Spark_Id__c   = testRoomId;
        sparkObj.ObjectId__c   = caseObjTestId;
        sparkObj.TriggerFields__c = '{"Case.Team__c":"GVE Tier I","Case.Origin":"Email","Case.Status":"Assigned"}';
        // sparkObj.Unique_Key__c = uniqueLocalKey;
        insert sparkObj;
        c7.OwnerId          = '00580000007kt0u';
        c7.Architecture__c  = 'Security'; 
      	update c7;
       // delete c7;
          
        //Utilities.setValidationSkip(true);
        // updateCaseCCWDealsSection method test
        /* Case c8=new Case(RecordtypeId =Utilities.getCaseTSNRecordTypeId());
          c8.Web_CCO_ID__c='testuser8';
          c8.Origin ='Web';
          c8.suppliedemail='testuser@gmail.com';
          c8.Opportunity__c = existingCCWRecord.Opportunity_Name__c;
          c8.Architecture__c='Test'; 
          c8.CreatedById = Utilities.getConstant_CS('ConnectionUserId');
          insert c8; 
        // updateCaseCCWDealsSection method test
          Case c81=new Case(RecordtypeId =Utilities.getCaseTSNRecordTypeId());
          c81.Web_CCO_ID__c='testuser8';
          c81.Origin ='Web';
          c81.suppliedemail='testuser@gmail.com';
          c81.Opportunity__c = opty.Id;
          c81.Architecture__c='Test';          
          insert c81;
        */
          Case c9=new Case(RecordtypeId =tsnRecTypeId);
        //Case c9=new Case(RecordtypeId =Utilities.getCaseTSNRecordTypeId());
          c9.Web_CCO_ID__c='testuser9';
          c9.Origin ='Web';
          c9.suppliedemail='testuser@gmail.com';
          c9.Architecture__c='Test';
          c9.Opportunity__c = opty1.Id;
          c9.Assigned_SLA__c = '24 hr';
          c9.Status = 'New';
                    
          insert c9;
          c9.Status = 'Monitor';
          update c9;
        
        string uId =UserInfo.getUserId();
        List<User> userList = CaseBO.getUserNamesFromId(uId,uId);
       Test.stopTest();
       
    }    
}