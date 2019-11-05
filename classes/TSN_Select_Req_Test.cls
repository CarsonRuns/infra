/***************************************************************************************************************************
Modification History

Shivi Srivastava    Removed SeeAllData=True    16-Apr-2019
****************************************************************************************************************************/
@isTest(SeeAllData=false)

private Class TSN_Select_Req_Test{
    private static testMethod void test(){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Cisco_Admin' Limit 1];
        User admUser = new User(Additional_User_Permissions__c = 'Enable EndUser ACCTCreation', Alias = 'newUser', Email = 'batchJobOppty@cisco.com',
                                EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                                LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'batchJobOppty@cisco.com.testing', Theatre__c = 'Americas-US Commercial');
        insert admUser; 
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel').getRecordTypeId();
        ObjectRecordTypeIds__c o = new ObjectRecordTypeIds__c();
        o.AccountChannelRecordTypeId__c = devRecordTypeId;
        insert o;
        System.runAs(admUser){
            Org_Constants__c os =new Org_Constants__c();
            os.Key__c = 'Oppty: ProfileIds to skip Triggers';
            os.non_prod_value__c = '00e30000000dcbfAAA,00e30000000dfUEAAY,00e30000000eca0AAA,00e30000000qiJjAAI,00e30000000dcbgAAA,00e30000000rrZwAAI';
            os.Prod_LT__c = 'GSTS,Data_Migration,Integration_Echo_Suppression,GSTS_Analyst,ADMIN, PSS';
            os.prod_value__c = '00e30000000dcbfAAA,00e30000000dfUEAAY,00e30000000eca0AAA,00e30000000qiJjAAI,00e30000000dcbgAAA,00e30000000rrZwAAI';
            os.Type__c = 'URL';
            insert os;
            
            Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel').getRecordTypeId();
            Account a = new Account(Name = 'test',recordtypeid=RecordTypeIdAccount ,CSCSiteID__c ='5555',CSCID__c = '5555',ownerid = admUser.id,AddressLine1__c='Test123',AddressLine1_English__c='Test231',AddressLine2__c='Testqa1',AddressLine2_English__c='Testqa123',City__c='UN',City_English__c='Test',State__c= 'AP',State_Province_English__c='ENDTESt',Country__c='INDIA',Country_English__c='INDIA',TOKENID__c='12333',ZipPostalCode__c='847733',Zip_Postal_Code_English__c='766644');
            insert a;  
            
            Account acct = new Account(Name='Testing');
            insert acct;
            
            list<contact> conlist = new list<contact>();
            contact con = new contact(lastName= 'Test contact');
            insert con;
            conlist.add(con);
            // Cisco_US_Commercial User
            //@@ 10/05 - Added Additional User Permission check.
            //User opptyOwner = [Select id from user where profile.name='Cisco_US_Commercial' and IsActive = True AND Additional_User_Permissions__c excludes ('Enable_ePSS') limit 1];
            
            // Cisco_Sales_Cases User
            Profile pro = [SELECT Id FROM Profile WHERE Name = 'Cisco_Sales_Cases' Limit 1];
            User currentUser = new User( Alias = 'newUse', Email = 'batchJobOppty@cisco.com',
                                        EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                                        LocaleSidKey = 'en_US', ProfileId = pro.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'batchJobOppty1@cisco.com.testing', Theatre__c = 'Americas-US Commercial');
            insert currentUser;
            //User currentUser = [Select id from user where profileid=:Utilities.getTSNProfileId() and IsActive = True limit 1];
            ProfileID__c pf = new ProfileID__c();
            pf.Cisco_Renewals__c = '00ec0000000QmlF';
            pf.Cisco_PSS__c = '00e30000000rrZw';       
            insert pf;
            Opportunity oppty = new Opportunity(OwnerId=currentUser.Id,Opportunity_Owner_AM__c=currentUser.Id,name='test_oppty',stageName='1 - Prospect',CloseDate=Date.today().addDays(2),Expected_Product__c = 11,AccountID= acct.ID,Theater__c = 'Americas-US Commercial',Competitors__c = 'Adobe');
            insert oppty;
            Id PSTSRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('PSTS Case').getRecordTypeId();
            Id GVERecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GVE Case').getRecordTypeId();
            Id CustSuccessRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer Success Adoption Request').getRecordTypeId();
            Id EngageSerResRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AS Pre Sales Engagement Request').getRecordTypeId();
            
            Case c1 = new Case(AccountId = a.Id,recordtypeid=PSTSRecordTypeId,OwnerId = currentUser.Id);
            insert c1; // PH Case 
            
            Case c2 = new Case(AccountId = a.Id,recordtypeid=GVERecordTypeId,OwnerId = currentUser.Id);
            //insert c2; // TSN Case 
            
            Case c3 =  new Case(AccountId = a.Id,recordtypeid=GVERecordTypeId,OwnerId = currentUser.Id,contactId= con.id);
            
            Case c4 = new Case();
            
            Case c5 = new Case(AccountId = a.Id,recordtypeid=CustSuccessRecordTypeId,OwnerId = currentUser.Id); 
            
            Case c6 = new Case(Opportunity__c=oppty.id, AccountId = a.Id,recordtypeid=EngageSerResRecordTypeID,OwnerId = currentUser.Id); 
            
            
            Case[] cs = new Case[]{c1,c2,c3,c4,c5,c6};
                
                Test.StartTest();
            
            System.currentPageReference().getParameters().put('id', c1.id);
            System.currentPageReference().getParameters().put('RecordType',PSTSRecordTypeId);
            
            
            ApexPages.StandardController stdCon = new ApexPages.StandardController(c1); 
            TSN_SelectReq_CTE selectreq= new TSN_SelectReq_CTE(stdCon);
            selectreq.redirect();       
            selectreq.cancel();
            selectreq.Contacttype = 'test';
            selectreq.Name = 'test'; 
            selectreq.Title = 'test';
            selectreq.wpn = 'test';
            selectreq.ipn = 'test';
            selectreq.mn = 'test';
            selectreq.country = 'test';
            selectreq.ciscoid = 'bdabbara';  
            
            /////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            
            System.currentPageReference().getParameters().put('id', c2.id);
            System.currentPageReference().getParameters().put('RecordType',GVERecordTypeId);
            //System.currentPageReference().getParameters().put('00N80000004S02p','susv@cisco.com');
            System.currentPageReference().getParameters().put('def_account_id',a.Id);  
            System.currentPageReference().getParameters().put('userTheme','Theme3');
            
            
            ApexPages.StandardController stdCon1 = new ApexPages.StandardController(c2); 
            TSN_SelectReq_CTE selectreq1= new TSN_SelectReq_CTE(stdCon1);
            
            selectreq1.redirect();
            
            
            selectreq1.setContype('Partner');
            selectreq1.getContype();
            
            selectreq1.setConname('susv@cisco.com');
            selectreq1.getConname();
            
            selectreq1.getCecval();
            
            selectreq1.setCaseval(c4);
            selectreq1.getCaseval();
            
            selectreq1.Save();
            
            selectreq1.setContype('Cisco');
            selectreq1.getContype();
            
            selectreq1.setConname('susv@cisco.com');
            selectreq1.getConname();
            
            selectreq1.id = c2.id;
            
            selectreq1.setCaseval(c4);
            selectreq1.getCaseval();
            
            selectreq1.Save();
            
            
            
            // selectreq1.contype = 'Cisco';
            selectreq1.setContype('Cisco');
            selectreq1.getContype();
            
            selectreq1.getItems();
            
            
            
            
            
            
            
            /////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            
            System.currentPageReference().getParameters().put('id', c3.id);
            System.currentPageReference().getParameters().put('RecordType',GVERecordTypeId);
            System.currentPageReference().getParameters().put('Cecid','susv@cisco.com');
            System.currentPageReference().getParameters().put('def_parent_id',c1.id);
            System.currentPageReference().getParameters().put('CF00NS0000000wTX4',oppty.Name);
            System.currentPageReference().getParameters().put('CF00NS0000000wTX4_lkid',oppty.Id);
            System.currentPageReference().getParameters().put('def_account_id',a.Id);
            System.currentPageReference().getParameters().put('def_contact_id',con.Id);  
            System.currentPageReference().getParameters().put('userTheme','Theme4u');
            
            
            
            //System.currentPageReference().getParameters().put('CF00N80000004w7Ao_lkid','12345678');
            
            
            
            
            ApexPages.StandardController stdCon2 = new ApexPages.StandardController(c3); 
            TSN_SelectReq_CTE selectreq2= new TSN_SelectReq_CTE(stdCon2);
            
            selectreq2.redirect();
            selectreq2.setCaseval(c4);
            selectreq2.getCaseval();
            
            selectreq2.setThemeFromSession();    
            
            selectreq2.setCount(true);
            selectreq2.getCount();
            
            selectreq2.setConname('susv@cisco.com');
            selectreq2.getConname();
            
            selectreq2.getCecval();
            
            selectreq2.cancel();
            
            selectreq2.setContype('Cisco');
            selectreq2.getContype();
            selectreq2.Save();
            
            
            
            System.currentPageReference().getParameters().put('id', c6.id);
            System.currentPageReference().getParameters().put('RecordType',EngageSerResRecordTypeID);
            System.currentPageReference().getParameters().put('Cecid','susv@cisco.com');
            System.currentPageReference().getParameters().put('def_parent_id',c1.id);
            System.currentPageReference().getParameters().put('CF00NS0000000wTX4',oppty.Name);
            System.currentPageReference().getParameters().put('CF00NS0000000wTX4_lkid',oppty.Id);
            System.currentPageReference().getParameters().put('def_account_id',a.Id);
            System.currentPageReference().getParameters().put('def_contact_id',con.Id);    
            System.currentPageReference().getParameters().put('userTheme','Theme4u');   
            
            ApexPages.StandardController stdCon6 = new ApexPages.StandardController(c6); 
            TSN_SelectReq_CTE selectreq6= new TSN_SelectReq_CTE(stdCon6);
            selectreq6.rType=null;
            selectreq6.redirect();       
            
            ApexPages.StandardController stdCon3 = new ApexPages.StandardController(c6); 
            TSN_SelectReq_CTE selectreq3= new TSN_SelectReq_CTE(stdCon3);
            
            selectreq3.redirect();
            selectreq3.getId(); 
            selectreq3.setId(c6.Id);          
            selectreq3.setCaseval(c6);
            selectreq3.getCaseval();
            selectreq3.contactName = 'Test';
            selectreq3.accountId = a.Id;    
            selectreq3.setThemeFromSession();    
            
            selectreq3.setCount(true);
            selectreq3.getCount();
            
            selectreq3.setConname('susv@cisco.com');
            selectreq3.getConname();
            
            selectreq3.getCecval();
            
            selectreq3.cancel();
            
            selectreq3.setContype('Cisco');
            selectreq3.getContype();
            selectreq3.Save();
            
            System.currentPageReference().getParameters().put('RecordType',PSTSRecordTypeId);
            
            TSN_SelectReq_CTE selectreq4= new TSN_SelectReq_CTE(stdCon3);
            selectreq4.rType = null; 
            selectreq4.Org = '';
            selectreq4.contacts = conlist;
            selectreq4.contacts1 = conlist;
            selectreq4.query = '';
            selectreq4.redirect();
            selectreq4.getId(); 
            selectreq4.setId(c6.Id);          
            selectreq4.setCaseval(c6);
            selectreq4.getCaseval();
            selectreq4.contactName = 'Test';
            selectreq4.accountId = a.Id;    
            selectreq4.setThemeFromSession();    
            
            selectreq4.setCount(true);
            selectreq4.getCount();
            
            selectreq4.setConname('susv@cisco.com');
            selectreq4.getConname();
            
            selectreq4.getCecval();
            
            selectreq4.cancel();
            
            selectreq4.setContype('Cisco');
            selectreq4.getContype();
            selectreq4.Save();
            
            
            
            
            
            
            Test.StopTest();
            
        }
    }
}