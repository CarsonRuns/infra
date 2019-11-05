@isTest(seeAllData=false)
public class NBM_Qualification_Controller_Test{    
    private static testMethod void test_NBM_Qualification_Controller() 
    {
        User testUser = new User();
        testUser.firstname = 'Test1000';
        testUser.lastname = 'Userdummy1000';
        testUser.username = 'testuserdummy1000@cisco.com';
        testUser.Additional_User_Permissions__c = 'GSPO_BDM';
        testUser.ProfileId = [Select Id from Profile where name ='Cisco_ADMIN'].Id;
        
        testUser.Theatre__c = 'Americas-US Public Sector';
        testUser.email = 'testuser@cisco.com';
        testUser.alias = 'testuser';
        testUser.TimeZoneSidKey = 'America/Los_Angeles';
        testUser.LocaleSidKey = 'en_US';
        testUser.LanguageLocaleKey = 'en_US';
        testUser.EmailEncodingKey = 'UTF-8';  
        //mkella
        //testUser.UserInfo.getUiThemeDisplayed() = 'Theme4d';
        //mkella
        Insert testUser;
        
        Utilities.setIsTestMethod(true);
        Utilities.setValidationSkip(true);
        System.RunAs(testUser){
            //mkella- changes Start
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
            //mkella- changes End
            Account acct = new Account(Name='Testing');
            insert acct;
            //mkella- Start
            Id RecordTypeIdopportunity = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Global Deal/Opportunity').getRecordTypeId();
            Id userId = testUser.Id;
            /*Opportunity oppty = new Opportunity(Theater__c = 'Americas-US Commercial',Name='Test', AccountId = acct.id, StageName='Open', 
                                                CloseDate=Date.newInstance(2010,12,12),
                                                error_description__c='error', DealID__c='1', 
                                                Opportunity_Owner_AM__c =userId,
                                                Competitors__c = 'A10 Networks', 
                                           Position__c='Americas lrpearso',
                                          CurrencyIsoCode = 'USD');
        	insert oppty;*/
            Opportunity oppty = new Opportunity(dealid__c='A111',name='Test111',StageName='2 - Qualification',CloseDate= system.today().adddays(2),
                                                      CurrencyIsoCode='USD',expected_product__c=0,expected_service__c=10,
                                                      forecast_status__c='Commit',Non_Standard_Terms_and_Conditions__c='None', 
                                                      recordtypeid=RecordTypeIdopportunity);
        	insert oppty;
            //mkella- End
            /*Opportunity oppty = new Opportunity(name='test_oppty',stageName='Open',CloseDate=Date.newInstance(2010,12,12),AccountID= acct.ID,Theater__c = 'Americas-US Commercial');
            insert oppty;*/
            
            /*Qualification__c temp = new Qualification__c(Name = 'TestMethod',Requester_Name__c = UserInfo.getUserId(), Customer_Name__c = 'TestMethod',Theater__c = 'Americas-US Commercial',Architecture__c = 'Borderless Networks',Segment__c = 'Commercial',Status__c = 'Screen 1',Contact_Name__c = 'TestMethod',Customer_Vision__c = 'TestMethod',Solution_Delivery__c = System.Today(),Contract_Value__c = 123,Countries_Covered__c = '1-3 years',Solution_Delivery_Date__c = System.Today(),RecordTypeId = Utilities.getNBMQualificationId(),Opportunity__c = oppty.id);
            insert temp;*/
            
            Qualification__c temp = new Qualification__c(Name = 'TestMethod',Partner__c = 'Microsoft', 
                                                         RecordTypeId = Utilities.getNBMQualificationId(),
                                                         Theater__c = 'Americas-US Commercial');
            insert temp;
            /*temp.Opportunity__c = oppty.id;
            update temp;*/
            ApexPages.currentPage().getParameters().put('id',Null);
            //ApexPages.currentPage().getParameters().put('comtext', '');
            ApexPages.StandardController sc = new ApexPages.StandardController(temp);
            NBM_Qualification_Controller controller1 =new NBM_Qualification_Controller(sc);
            //controller1.attachopty2();
         	//controller1.quallification.opportunity__c = oppty.ID;
              
            Qualification__c nbm1 = new Qualification__c(Name = 'TestMethod',Customer_Name__c = 'TestMethod',
            Requester_Name__c = UserInfo.getUserId(),
            Theater__c = 'Americas-US Commercial',
            Architecture__c = 'Borderless Networks',
            Segment__c = 'Commercial',
            Status__c = 'Screen 1',
            Contact_Name__c = 'TestMethod',
            Customer_Vision__c = 'TestMethod',
            Solution_Delivery__c = System.Today(),
            Contract_Value__c = 123,
            Countries_Covered__c = '1-3 years',
            Solution_Delivery_Date__c = System.Today(),
            RecordTypeId = Utilities.getNBMQualificationId()) ;
            insert nbm1;   
            
            System.currentPageReference().getParameters().put('id', nbm1.id);
            System.currentPageReference().getParameters().put('comtext', 'CreateOppty');
            ApexPages.StandardController sc1 = new ApexPages.StandardController(nbm1);    
            NBM_Qualification_Controller controller2 =new NBM_Qualification_Controller(sc1);
            controller2.getlead();
            controller2.getrelated();
            controller2.attachopty2();   
            controller2.quallification.opportunity__c = oppty.ID;
            controller2.quallification.opportunity__c = oppty.ID;
            
            Qualification__c gspo2 = new Qualification__c(Name = 'TestMethod',Partner__c = 'Microsoft', Opportunity__c = oppty.id, RecordTypeId = Utilities.getGSPOrecordtypeId());
            insert gspo2;
            ApexPages.StandardController sc3 = new ApexPages.StandardController(gspo2);    
            NBM_Qualification_Controller controller4 =new NBM_Qualification_Controller(sc3); 
            
            controller4.getContype();
            controller4.setContype('Consumer');     
            controller4.redirect();     
            
            Qualification__c gspo = new Qualification__c(Name = 'TestMethod',Partner__c = 'Microsoft', Opportunity__c = oppty.id, RecordTypeId = Utilities.getGSPOrecordtypeId());
            insert gspo;
            
            System.currentPageReference().getParameters().put('RecordType',Utilities.getGSPOrecordtypeId());
            System.currentPageReference().getParameters().put('CF00N80000004IXXz', oppty.Name);
            System.currentPageReference().getParameters().put('CF00N80000004IXXz_lkid', oppty.Id);
            
            ApexPages.StandardController sc2 = new ApexPages.StandardController(gspo);    
            NBM_Qualification_Controller controller3 =new NBM_Qualification_Controller(sc2);
            controller3.isLightningOptyId = True;
            controller3.redirect();
            
            User u = new User(Id=UserinFo.getUserId());
            u.Additional_User_Permissions__c = '';
            update u;       
            
            Qualification__c gspo3 = new Qualification__c(Name = 'TestMethod',Partner__c = 'Microsoft', RecordTypeId = Utilities.getNBMQualificationId(),Theater__c = 'Americas-US Commercial');
            insert gspo3;
            
            System.currentPageReference().getParameters().put('RecordType',Utilities.getNBMQualificationId());
            sc2 = new ApexPages.StandardController(gspo3);    
            controller3 =new NBM_Qualification_Controller(sc2);   
            
            controller3.redirect();
            System.currentPageReference().getParameters().put('comments', 'CreateOppty');
            //mkella- Start
            //controller3.UserInfo.getUiThemeDisplayed() = 'Theme4d';
            controller3.isLightningOptyId = True;
            controller3.redirect();
            
            
            Boolean lightningOpptyId = controller3.getisLightningOptyId();
            //mkella- End
        }
    } 
}