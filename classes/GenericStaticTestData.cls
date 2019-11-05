/* Revision History Start */
// 05.02.2015 - Added the LeadScore to Lead insert to satisfy the validation rule.
/* Revision History End */


@isTest(SeeAllData=true) 
public class GenericStaticTestData {

    public static Account testPartnerCompanyAccountRecord = null;
    public static Account testChannelAccountRecord1 = null;
    public static Account testChannelAccountRecord2 = null;
    public static Account testEndUserAccountRecordRed = null;
    public static Account testEndUserAccountRecordGreen = null;
    public static Account testEndUserAccountRecordYellow = null;
    
    public static Lead testeLeadRecord = null;
    public static Lead testManualLeadRecord = null;
    public static Lead testPartnerGereratedLeadRecord = null;
    public static Assigned_partner__c testTargetProspectRecord = null;
    public static Contact testPartnerProvidedPAContactRecord = null;
    public static Contact testPartnerProvidedPSRContactRecord = null;
    public static Contact testEndUserContactRecord = null;
    public static User testAMUserRecord = null;
    public static User testPAUserRecord = null;
    public static User testPSRUserRecord = null;
    public Static Opportunity testParentOpportunityRecord = null;
    
    public Static Account getTestPartnerCompanyAccountRecord()
    {
        if (!Test.isRunningTest()) {
            throw new TestClassException('This method can only be called from a Test method');          
        }  
        
        if(testPartnerCompanyAccountRecord!= null)
        {
            return testPartnerCompanyAccountRecord;
        }
        else
        {
            insertTestAccountRecords();
            return testPartnerCompanyAccountRecord;
        }           
    }
    
    public Static Account gettestChannelAccountRecord1()
    {
        if (!Test.isRunningTest()) {
            throw new TestClassException('This method can only be called from a Test method');          
        }  
        
        if(testChannelAccountRecord1!= null)
        {
            return testChannelAccountRecord1;
        }
        else
        {
            insertTestAccountRecords();            
            return testChannelAccountRecord1;
        }           
    }
    public Static Account gettestChannelAccountRecord2()
    {
        if (!Test.isRunningTest()) {
            throw new TestClassException('This method can only be called from a Test method');          
        }  
        
        if(testChannelAccountRecord2!= null)
        {
            return testChannelAccountRecord2;
        }
        else
        {
            insertTestAccountRecords();            
            return testChannelAccountRecord2;
        }           
    }
    
    
    public Static Account getTestEndUserAccountRecordRed()
    {
        if (!Test.isRunningTest()) {
            throw new TestClassException('This method can only be called from a Test method');          
        }  
        
        if(testEndUserAccountRecordRed!= null)
        {
            return testEndUserAccountRecordRed;
        }
        else
        {
            insertTestAccountRecords();
            return testEndUserAccountRecordRed;
        }           
    }
    
    public Static Account getTestEndUserAccountRecordGreen()
    {
        if (!Test.isRunningTest()) {
            throw new TestClassException('This method can only be called from a Test method');          
        }  
        
        if(testEndUserAccountRecordGreen!= null)
        {
            return testEndUserAccountRecordGreen;
        }
        else
        {
            insertTestAccountRecords();
            return testEndUserAccountRecordGreen;
        }           
    }
        public Static Account getTestEndUserAccountRecordYellow()
    {
        if (!Test.isRunningTest()) {
            throw new TestClassException('This method can only be called from a Test method');          
        }  
        
        if(testEndUserAccountRecordYellow!= null)
        {
            return testEndUserAccountRecordYellow;
        }
        else
        {
            insertTestAccountRecords();
            return testEndUserAccountRecordYellow;
        }           
    }
    
    public Static Lead gettesteLeadRecord()
    {
        if (!Test.isRunningTest()) {
            throw new TestClassException('This method can only be called from a Test method');          
        }  
        
        if(testeLeadRecord!= null)
        {
            return testeLeadRecord;
        }
        else
        {
            insertTestLeadRecords();
            return testeLeadRecord;
        }           
    }
    
    public Static Lead gettestPartnerGereratedLeadRecord()
    {
        if (!Test.isRunningTest()) {
            throw new TestClassException('This method can only be called from a Test method');          
        }  
        
        if(testPartnerGereratedLeadRecord!= null)
        {
            return testPartnerGereratedLeadRecord;
        }
        else
        {
            insertTestLeadRecords();
            return testPartnerGereratedLeadRecord;
        }           
    }
    
    public Static Lead testManualLeadRecord()
    {
        if (!Test.isRunningTest()) {
            throw new TestClassException('This method can only be called from a Test method');          
        }  
        
        if(testManualLeadRecord!= null)
        {
            return testManualLeadRecord;
        }
        else
        {
            insertTestLeadRecords();
            return testManualLeadRecord;
        }       
    }
    
    public Static Assigned_Partner__c gettestTargetProspectRecord()
    {
        if (!Test.isRunningTest()) {
            throw new TestClassException('This method can only be called from a Test method');          
        }  
        
        if(testTargetProspectRecord!= null)
        {
            return testTargetProspectRecord;
        }
        else
        {
            insertTestTargetProspectRecords();            
            return testTargetProspectRecord;
        }       
    }
    

    
    public Static Contact gettestPartnerProvidedPAContactRecord()
    {
        if (!Test.isRunningTest()) {
            throw new TestClassException('This method can only be called from a Test method');          
        }  
        
        if(testPartnerProvidedPAContactRecord!= null)
        {
            return testPartnerProvidedPAContactRecord;
        }
        else
        {
            insertTestContactRecords();
            testPartnerProvidedPAContactRecord.accountId = gettestChannelAccountRecord1().id;
            testPartnerProvidedPAContactRecord.Partner_Admin_Roles__c = 'PARTNER_LED_APP_ADMIN';
            return testPartnerProvidedPAContactRecord;
        }       
    }
        
        
    public Static Contact gettestPartnerProvidedPSRContactRecord()
    {
        if (!Test.isRunningTest()) {
            throw new TestClassException('This method can only be called from a Test method');          
        }  
        
        if(testPartnerProvidedPSRContactRecord!= null)
        {
            return testPartnerProvidedPSRContactRecord;
        }
        else
        {
            insertTestContactRecords();
            testPartnerProvidedPSRContactRecord.accountId = gettestChannelAccountRecord1().id;
            testPartnerProvidedPSRContactRecord.Partner_Admin_Roles__c = 'PARTNER_LED_APP_USER';
            return testPartnerProvidedPSRContactRecord;
        }       
    }   
    
    public Static Contact gettestEndUserContactRecord()
    {
        if (!Test.isRunningTest()) {
            throw new TestClassException('This method can only be called from a Test method');          
        }  
        
        if(testEndUserContactRecord!= null)
        {
            return testEndUserContactRecord;
        }
        else
        {
            insertTestContactRecords();
            return testEndUserContactRecord;
        }       
    }   
    
   public Static User gettestAMUserRecord()
    {
        if (!Test.isRunningTest()) {
            throw new TestClassException('This method can only be called from a Test method');          
        }  
        
        if(testAMUserRecord!= null)
        {
            return testAMUserRecord;
        }
        else
        {
            insertTestUserRecords();
            return testAMUserRecord;
        }       
    }
    
    public Static User gettestPAUserRecord()
    {
        if (!Test.isRunningTest()) {
            throw new TestClassException('This method can only be called from a Test method');          
        }  
        
        if(testPAUserRecord!= null)
        {
            return testPAUserRecord;
        }
        else
        {
            insertTestUserRecords();
            return testPAUserRecord;
        }           
    }

    public Static User gettestPSRUserRecord()
    {
        if (!Test.isRunningTest()) {
            throw new TestClassException('This method can only be called from a Test method');          
        }  
        
        if(testPSRUserRecord!= null)
        {
            return testPSRUserRecord;
        }
        else
        {
            insertTestUserRecords();
            return testPSRUserRecord;
        }       
    }

    
    public Static Opportunity gettestParentOpportunityRecord()
    {
       
        if (!Test.isRunningTest()) {
            throw new TestClassException('This method can only be called from a Test method');          
        }         
        if(testParentOpportunityRecord!= null)
        {       
            return testParentOpportunityRecord;
        }
        else
        {            
            insertTestOpptyRecords();
            return testParentOpportunityRecord;
        }       
    }
    
    
    
    public class TestClassException extends Exception {} 
    
    public static void insertTestAccountRecords()
    {       
        if (!Test.isRunningTest()) {
            throw new TestClassException('This method can only be called from a Test method');          
        }   
       // List<Account> accounts = Test.loadData(Account.sObjectType, 'TestAccounts');        
   
        List<Account> accounts = new List<Account>();     
        Account a1 = new Account(name='Test Partner Company Account123',RECORDTYPEID='01280000000G6tsAAC',Country__c='UNITED STATES',ownerid ='00530000000fb2q');
        accounts.add(a1);
        Account a21 = new Account(name='Test Channel Account12',RECORDTYPEID='0123000000004aVAAQ',Country__c='UNITED STATES',ownerid ='00530000000fb2q',Partner_Locations_Number__c=1);
        accounts.add(a21);
        Account a22 = new Account(name='Test Channel Account13',RECORDTYPEID='0123000000004aVAAQ',Country__c='UNITED STATES',ownerid ='00530000000fb2q');
        accounts.add(a22);
        Account a31 = new Account(name='Test End-User Account14',CRName__c ='Test End-User Account',RECORDTYPEID='0123000000004aUAAQ',Country__c='UNITED STATES',ownerid ='00530000000fb2q',Partner_Locations_Number__c=1);
        accounts.add(a31);
        Account a32 = new Account(name='Test End-User Account15',CRName__c ='Test End-User Account',RECORDTYPEID='0123000000004aUAAQ',Country__c='UNITED STATES',ownerid ='00530000000fb2q');
        accounts.add(a32);
        Account a33 = new Account(name='Test End-User Account16',CRName__c ='Test End-User Account',RECORDTYPEID='0123000000004aUAAQ',Country__c='UNITED STATES',ownerid ='00530000000fb2q');
        accounts.add(a33);
        insert(accounts);  
        
        Partner_Program_Enrollment__c PPE = new Partner_Program_Enrollment__c(Name='Cisco Sales Collaboration Platform',PROGRAM_ENROLLMENT_STATUS__C='Active');
        PPE.PARTNER_COMPANY__C = accounts[0].id;
        insert PPE;
        
        accounts[1].parentid = accounts[0].id;
        accounts[1].ispartner = true;
        accounts[2].parentid = accounts[0].id;
        accounts[2].ispartner = true;
        accounts[3].Release_to_Unallocated_Pool__c = 'Yes';
        accounts[3].Unallocated_Account__c ='Yes';
        accounts[4].Allocated_Partner_1__c = accounts[1].id;
        accounts[5].Allocated_Partner_1__c = accounts[1].id;
        accounts[5].Allocated_Partner_1__c = accounts[2].id;        
        update accounts;
        
        testPartnerCompanyAccountRecord = accounts[0];
        testChannelAccountRecord1 = [Select id,Name,Country__c,Partner_Assignment_Eligible__c from account where id =:accounts[1].id];
        testChannelAccountRecord2 = [Select id,Name,Country__c,Partner_Assignment_Eligible__c from account where id =:accounts[2].id];
        testEndUserAccountRecordRed = accounts[3];
        testEndUserAccountRecordGreen = accounts[4];
        testEndUserAccountRecordYellow = accounts[5];
 
    }   
    
    public static void insertTestLeadRecords()
    {       
        if (!Test.isRunningTest()) {
            throw new TestClassException('This method can only be called from a Test method');          
        }   
        //List<Lead> leads = Test.loadData(Lead.sObjectType, 'TestLeads');
        
        List<Lead> leads = new List<Lead>();
        Lead l1 = new Lead(firstName='Test Manual',LastName ='Lead', RECORDTYPEID='0123000000004aSAAQ',company='Test End-User Account',email='test@test.com.test', LeadSource='eLeads');
        leads.add(l1);
        Lead l2 = new Lead(firstName='Test eLead',LastName ='Lead', RECORDTYPEID='0123000000004aRAAQ',company='Test End-User Account',email='test@test.com.test', LeadSource='eLeads');
        leads.add(l2);
        Lead l3 = new Lead(firstName='Test Partner Generated',LastName ='Lead', RECORDTYPEID='012300000000lFWAAY',company='Test End-User Account',email='test@test.com.test', LeadSource='eLeads');
        leads.add(l3);                  
        insert(leads);
        
        l2.channel_partner__c = gettestChannelAccountRecord1().id;
        l3.channel_partner__c = gettestChannelAccountRecord1().id;
        l2.end_customer_account__c = gettestEndUserAccountRecordRed().id;
        l3.end_customer_account__c = gettestEndUserAccountRecordRed().id;
        update leads;
        
        testeLeadRecord = leads[1];
        testManualLeadRecord = leads[0];
        testPartnerGereratedLeadRecord = leads[2];
    }   
    
    public static void insertTestTargetProspectRecords()
    {       
        if (!Test.isRunningTest()) {
            throw new TestClassException('This method can only be called from a Test method');          
        }   
        //List<Assigned_partner__c> TPs = Test.loadData(Lead.sObjectType, 'Assigned_Partner__c');
        List<Assigned_partner__c> TPs = new List<Assigned_partner__c>();
        Assigned_partner__c t1 = new Assigned_partner__c(Name='Test Target Prospect Record',TARGET_ARCHITECTURE__C='Any/All Technologies',TARGET_DESCRIPTION__C='Test Target Prospect Record');
        TPs.add(t1);        

        insert TPs;
        
        t1.Assigned_partner__c = gettestChannelAccountRecord1().id;
        t1.customer_account__c = gettestEndUserAccountRecordRed().id;

 
        update TPs;
        testTargetProspectRecord = TPs[0];

        
    
    }
    public static void insertTestContactRecords()
    {       
        if (!Test.isRunningTest()) {
            throw new TestClassException('This method can only be called from a Test method');          
        }   
        //List<Contact> ls = Test.loadData(Contact.sObjectType, 'TestContacts');
        List<Contact> contacts = new List<contact>();
        contact c1 = new contact(firstName='Test',LastName ='PA Contact123', RECORDTYPEID='01280000000G6tnAAC',email='testpa@test.com.test');
        contacts.add(c1);
        contact c2 = new contact(firstName='Test',LastName ='PSR Contact123', RECORDTYPEID='01280000000G6tnAAC',email='testpsr@test.com.test');
        contacts.add(c2);
        contact c3 = new contact(firstName='Test',LastName ='End User Contact123', RECORDTYPEID='0123000000004aTAAQ',email='test@test.com.test');
        contacts.add(c3);
        insert(contacts);
        
        c1.accountId=gettestChannelAccountRecord1().id;       
        c2.accountId=gettestChannelAccountRecord1().id;
        c3.accountId=gettestEndUserAccountRecordRed().id;
        update contacts;
        
        testPartnerProvidedPAContactRecord = contacts[0];
        testPartnerProvidedPSRContactRecord = contacts[1];
        testEndUserContactRecord = contacts[2];
    }   
    
    public static  void insertTestUserRecords()
    {       
        if (!Test.isRunningTest()) {
            throw new TestClassException('This method can only be called from a Test method');          
        }   
        //List<User> ls = Test.loadData(User.sObjectType, 'TestUsers');
       
    /* Org_Constant_CS__c opptyOwner1 = new Org_Constant_CS__c();
        opptyOwner1.name = 'Cisco_portal_id123';
        opptyOwner1.Production_Value__c = '00e800000011h7J';
        opptyOwner1.Non_Production_Value__c = '00e800000011h7J';
        insert opptyOwner1 ;
        String myCCInst1 =opptyOwner1.Production_Value__c;*/
        
        //  Org_Constant_CS__c myCS2 = Org_Constant_CS__c.getInstance('Cisco_portal_id');
         // String myCCInst1 = myCS2.Non_Production_Value__c ;
            
        // List<Org_Constant_CS__c>  orgcons1= [select id,name,Production_Value__c,Non_Production_Value__c from Org_Constant_CS__c where name ='Cisco_portal_id'];
        // String myCCInst1 = orgcons1[0].Non_Production_Value__c ;
          
          
        String myCCInst1 = system.label.Partner360_Portal_Profile;
      
       system.debug('myCCInst1:'+myCCInst1);
        List<User> users = new List<user>();
        user u1 = new user(firstName='Test',LastName ='PA Contact', USERNAME='testpa1@cisco.com.sales.test',email='testpa232@cisco.com.test',ALIAS='testpa',COMMUNITYNICKNAME='testpa',ISACTIVE=True,
                            TIMEZONESIDKEY='America/Los_Angeles',LnP_T_C_Acepted_Date__c=Date.Today()+5,LnP_TC_Reset_Date__c=Date.Today()-5,LnP_TC_Accepted__c=true,PROFILEID =myCCInst1 ,LANGUAGELOCALEKEY ='en_US',THEATRE__C='APJC-APAC',
                            LOCALESIDKEY ='en_US',EMAILENCODINGKEY='UTF-8',Additional_User_Permissions__c='Enable EndUser ACCTCreation' );
        users.add(u1);
        user u2 = new user(firstName='Test',LastName ='PSR Contact', USERNAME='testpsr32@cisco.com.sales.test',email='testpsrq23@cisco.com.test',ALIAS='testpsr',COMMUNITYNICKNAME='testpsr',ISACTIVE=True,
                            TIMEZONESIDKEY='America/Los_Angeles',LnP_T_C_Acepted_Date__c=Date.Today()+5,LnP_TC_Reset_Date__c=Date.Today()-5,LnP_TC_Accepted__c=true,PROFILEID = myCCInst1 ,LANGUAGELOCALEKEY ='en_US',THEATRE__C='APJC-APAC',
                            LOCALESIDKEY ='en_US',EMAILENCODINGKEY='UTF-8',Additional_User_Permissions__c='Enable EndUser ACCTCreation');
           users.add(u2);
                        
                            
       user u3 = new user(firstName='Test',LastName ='AM', USERNAME='testam32@cisco.com.sales.test',email='testam322@cisco.com.test',ALIAS='testam',COMMUNITYNICKNAME='testam',ISACTIVE=True,
                            TIMEZONESIDKEY='America/Los_Angeles',PROFILEID =myCCInst1 ,LANGUAGELOCALEKEY ='en_US',THEATRE__C='APJC-APAC',
                            LOCALESIDKEY ='en_US',EMAILENCODINGKEY='UTF-8',Additional_User_Permissions__c='Enable EndUser ACCTCreation'); 
      users.add(u3);  
        
      //  u1.contactid= '00330000005eUljAAE';
      //   u2.contactid = '00330000005eUllAAE';
        u1.contactid = gettestPartnerProvidedPAContactRecord().id; 
        system.debug(' u1.contactid:>>>'+ u1.contactid);
        u2.contactid = gettestPartnerProvidedPSRContactRecord().id; 
          system.debug('u2.contactid:>>>'+ u1.contactid);
        u3.contactid =  gettestEndUserContactRecord().id;   
        insert users;
       
         // u1.userroleId = '00E80000001tuiuEAA';
         //  u2.userroleId = '00E34000001pwmREAQ';    
        u1.userroleId = [select id from userrole where portalaccountid =:gettestChannelAccountRecord1().id and Name like '%Partner Executive' limit 1].Id; 
        u2.userroleId = [select id from userrole where portalaccountid =:gettestChannelAccountRecord1().id and Name like '%Partner User' limit 1].Id;
        
        system.runas(users[1])
        {
           update users;
        }
         
       
        
        
        testPAUserRecord = users[0];
        testPSRUserRecord = users[1];
        testAMUserRecord = users[2];
    }   

    
   public static  void insertTestOpptyRecords()
    {       
        if (!Test.isRunningTest()) {
            throw new TestClassException('This method can only be called from a Test method');          
        } 
        Date vCloseDate = System.today();
        //Get users default currency
        User currentUser = [select defaultCurrencyIsoCode from User where Id = :UserInfo.getUserId()];
        
        //Query for Pricebook2
        String defaultPricebookId;
        Pricebook2[] pricebook2 = [select id from Pricebook2];
        if(pricebook2 == null || pricebook2.size() == 0){
        Pricebook2 createDefaultPB = new Pricebook2();
            
       	//Scava Fix  
        if(Schema.sObjectType.Pricebook2.fields.Name.isCreateable()){
        	createDefaultPB.Name = 'default pricebook';
        }   

        if(Schema.sObjectType.Pricebook2.fields.isActive.isCreateable()){
        	createDefaultPB.IsActive = true;
        }
        insert createDefaultPB;
        defaultPricebookId = createDefaultPB.Id;
        }
        else{
        defaultPricebookId = pricebook2[0].Id;        
        }  
       
        List<Opportunity> oppty= new List<Opportunity>();
        Opportunity  oppty1 = new Opportunity();
        
        //Scava Fix
        if(flsGet(Opportunity.Name)){
            oppty1.Name = 'Test1';
        }
        if(flsGet(Opportunity.StageName))
        {
            oppty1.StageName = '1 - Prospect';
        }
        if(flsGet(Opportunity.CloseDate)){
        	oppty1.CloseDate = vCloseDate;
        }
        if(flsGet(Opportunity.Expected_Product__c)){
        	oppty1.Expected_Product__c = 2;
        }
        if(flsGet(Opportunity.Pricebook2Id)){
        	oppty1.Pricebook2Id = defaultPricebookId;
        }
        if(flsGet(Opportunity.CurrencyIsoCode)){
        	oppty1.CurrencyIsoCode = currentUser.defaultCurrencyIsoCode;
        }
        oppty.add(oppty1);
        insert oppty;
        testParentOpportunityRecord = oppty[0];
    }   
    
     // SCAVA Helper Method
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }

    
}