@isTest
public with sharing class Renewals_TestUtility {
    
    // SCAVA Helper Method to validate Update Access at field level
    public static Boolean flsUpdateGet(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }
    
    
    /*@method: get Account record type*/
    public static RecordType getAccountRecordType(){
        RecordType channelAcct =  new RecordType();
        channelAcct.id = ObjectRecordTypeIds__c.getOrgDefaults().AccountChannelRecordTypeId__c;
        channelAcct.name = 'Channel';
        
        return channelAcct;
    }
    
    /*@method: get Account*/
    public static Account getAccount(String prefix, Boolean isInsert){
        Account acct = new Account();
        acct.name = prefix+'Test Partner Account';
        acct.RecordTypeId = CEE_TestUtility.getAccountRecordType().Id;
        acct.Country__c = 'UNITED STATES';
        
        if(isInsert){
            insert acct;
            
            //Setup super group
            Super_Group__c superGroup = new Super_Group__c();
            superGroup.FDEV_Super_Group_ID__c = '42';
            superGroup.Type__c = 'Overlay';
            insert superGroup;
            
            Overlay_Acct_SuperGroup_Rel__c acctSuper = new Overlay_Acct_SuperGroup_Rel__c();
            acctSuper.Account_ID__c = acct.Id;
            acctSuper.Super_Group__c = superGroup.Id;
            insert acctSuper;
        }
        
        return acct;
    }
    
    /*@method: get User*/
    public static User getUser(String cecid, Boolean isInsert){
        //Profile pList = [SELECT Id FROM Profile WHERE Name ='Cisco_ADMIN' limit 1];
        Id ciscoAdminProfile = '00e30000000dcbgAAA';
        
        User newUser = new User();
        newUser.Alias = cecid;
        newUser.Email = cecid + '@cisco.com.test';
        newUser.EmailEncodingKey = 'UTF-8';
        newUser.LastName = 'Test';
        newUser.FirstName = 'cecid';
        newUser.Organization__c = 'Test';
        newUser.LanguageLocaleKey = 'en_US';
        newUser.LocaleSidKey = 'en_US';
        newUser.ProfileId = ciscoAdminProfile;
        newUser.CommunityNickname = cecid;
        newUser.TimeZoneSidKey = 'America/Los_Angeles';
        newUser.UserName = cecid + '@cisco.com.test';
        newUser.Theatre__c = 'Americas-Canada';
        newUser.Additional_User_Permissions__c = 'Enable EndUser ACCTCreation';
        
        User myUser = new User();
        myUser.Id = UserInfo.getUserId(); //[ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs (myUser) {
            if(isInsert){
                insert newUser;
            }
        }
        
        return newUser;
    }
    
    public static Opportunity getOpty(){
        Org_Constants__c os =new Org_Constants__c();
        os.Key__c = 'Oppty: ProfileIds to skip Triggers';
        os.non_prod_value__c = '00e30000000dcbfAAA,00e30000000dfUEAAY,00e30000000eca0AAA,00e30000000qiJjAAI,00e30000000dcbgAAA,00e30000000rrZwAAI';
        os.Prod_LT__c = 'GSTS,Data_Migration,Integration_Echo_Suppression,GSTS_Analyst,ADMIN, PSS';
        os.prod_value__c = '00e30000000dcbfAAA,00e30000000dfUEAAY,00e30000000eca0AAA,00e30000000qiJjAAI,00e30000000dcbgAAA,00e30000000rrZwAAI';
        os.Type__c = 'URL';
        insert os;
        //Account act = GenericStaticTestData.gettestChannelAccountRecord1();
        Date vCloseDate = System.today();
        //User currentUser = [select defaultCurrencyIsoCode from User where Id = :UserInfo.getUserId()];      
        List<Opportunity> oppty= new List<Opportunity>();
        
        Opportunity opppt = new Opportunity(name='singthavo',StageName='2 - Qualified', CloseDate= vCloseDate, 
                                            Expected_Product__c=10.0,error_description__c='error', DealID__c='1', Opportunity_Status__c='Active', 
                                            recordtypeId='01234000000Boc4AAC', Opportunity_Owner_AM__c =userinfo.getUserId(),Competitors__c = 'A10 Networks',
                                            Is_Product_Quote_Integrated__c = 'Yes', Is_Service_Quote_Integrated__c = 'No' ); 
        oppty.add(opppt);
        insert oppty;
        
        return oppty[0];
        
    }
    public static id getOptyrenewals(String userName , String OptyName){
        User newUser = new User();
        newUser.Alias = userName;
        newUser.Email = userName+ '@cisco.com.test';
        newUser.EmailEncodingKey = 'UTF-8';
        newUser.LastName = 'Test';
        newUser.FirstName = 'cecid';
        newUser.Organization__c = 'Test';
        newUser.LanguageLocaleKey = 'en_US';
        newUser.LocaleSidKey = 'en_US';
        newUser.ProfileId = '00e30000000rrZw';
        newUser.CommunityNickname = userName;
        newUser.TimeZoneSidKey = 'America/Los_Angeles';
        newUser.UserName = userName + '@cisco.com.test';
        newUser.Theatre__c = 'Americas-Canada';
        newUser.Additional_User_Permissions__c = 'Enable EndUser ACCTCreation';
        newUser.isactive=true;
        newUser.renewal_ib_updates__c=true;
        insert newUser;
        Opportunity opppt=new Opportunity();
        system.Runas(newUser) {        
            Account acc = new Account();
            acc.Name = 'customer acc';
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            //insert acc;
            date startDate =  System.today()-365 ;
            date endDate =  System.today() ;
            opppt = new Opportunity(name='renewalsTestOpportunity', StageName='1 - Prospect', CloseDate= System.today() + 50, 
                                    Expected_Product__c=10.0,error_description__c='error', DealID__c='1', Opportunity_Status__c='Active', 
                                    recordtypeId='01234000000Boc4AAC', Opportunity_Owner_AM__c =userinfo.getUserId(),Competitors__c = 'A10 Networks',
                                    Is_Product_Quote_Integrated__c = 'Yes', Is_Service_Quote_Integrated__c = 'No', Start_Date__c =startDate , 
                                    End_Date__c = endDate,last_ib_refresh__c=System.today()-1);
            getRenewalsCustValues();
            insert opppt;
        }
        return opppt.id;
    }
    
    
        
   
    
    public static id getOptyrenewalsNew(String userName , String OptyName){
        User newUser = new User();
        newUser.Alias = userName;
        newUser.Email = userName+ '@cisco.com.test';
        newUser.EmailEncodingKey = 'UTF-8';
        newUser.LastName = 'Test';
        newUser.FirstName = 'cecid';
        newUser.Organization__c = 'Test';
        newUser.LanguageLocaleKey = 'en_US';
        newUser.LocaleSidKey = 'en_US';
        newUser.ProfileId = '00e30000000rrZw';
        newUser.CommunityNickname = userName;
        newUser.TimeZoneSidKey = 'America/Los_Angeles';
        newUser.UserName = userName + '@cisco.com.test';
        newUser.Theatre__c = 'Americas-Canada';
        newUser.Additional_User_Permissions__c = 'Enable EndUser ACCTCreation';
        
        insert newUser;
        Opportunity opppt=new Opportunity();
        system.Runas(newUser) {
            Account acc = new Account();
            acc.Name = 'customer acc';
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            //insert acc;
            Org_Constants__c ob=new Org_Constants__c();
            ob.Key__c='Oppty: ProfileIds to skip Triggers'+OptyName;
            ob.prod_value__c='Test '+OptyName;
            insert ob;
            ProfileID__c ProfileIDOb=new ProfileID__c();
            ProfileIDOb.Cisco_Renewals__c='00e34000001CQnp';
            ProfileIDOb.Cisco_PSS__c='00e30000000rrZw';
            insert ProfileIDOb;
            
            ObjectRecordTypeIds__c ob3=new ObjectRecordTypeIds__c();
            ob3.Opportunity_Parent_Mobile_RecordTypeId__c='01234000000GGKw';
            insert ob3;
            //boolean currentUserBDRORLDR=true;
            //List<Opportunity> oppty= new List<Opportunity>();
            date startDate =  System.today()-365 ;
            date endDate =  System.today() ;
            opppt = new Opportunity(name=OptyName+':renewalsTestOpportunity', StageName='1 - Prospect', CloseDate= System.today() + 50, 
                                    Expected_Product__c=10.0,error_description__c='error', DealID__c='1', Opportunity_Status__c='Active', 
                                    recordtypeId='01234000000Boc4AAC', Opportunity_Owner_AM__c =userinfo.getUserId(),Competitors__c = 'A10 Networks',
                                    Is_Product_Quote_Integrated__c = 'Yes', Is_Service_Quote_Integrated__c = 'No', Start_Date__c =startDate , 
                                    End_Date__c = endDate); 
            //oppty.add(opppt);
            system.debug('------------opportunity in utlity class  is ---'+opppt);  
            insert opppt;
            system.debug('---opppt id ---'+opppt.id);
            
            
        }
        return opppt.id;
    }
    
    public static void getRenewalsCustValues(){   
            Org_Constants__c ob=new Org_Constants__c();
            ob.Key__c='Oppty: ProfileIds to skip Triggers';
            ob.prod_value__c='testingg';
            insert ob;
            ProfileID__c ProfileIDOb=new ProfileID__c();
            ProfileIDOb.Cisco_Renewals__c='00e34000001CQnp';
            ProfileIDOb.Cisco_PSS__c='00e30000000rrZw';
            insert ProfileIDOb;
            
            ObjectRecordTypeIds__c ob3=new ObjectRecordTypeIds__c();
            ob3.Opportunity_Parent_Mobile_RecordTypeId__c='01234000000GGKw';
            insert ob3;
            
            Renewals_Portfolio__c Renewals_PortfolioOb=new Renewals_Portfolio__c();
            Renewals_PortfolioOb.Opty_limit__c='20';
            Renewals_PortfolioOb.RM_Notif_mail_body__c = 'The following renewal opportunities have been updated based on Contract and Installed Base changes:|mail_body|For more information, please review the Field History within the renewal opportunity.';
            insert Renewals_PortfolioOb;   
        
        
        
        }   
    
    
    public static id getTerritory (String userName , Decimal TerrLevel ){
        User newUser = new User();
        newUser.Alias = userName;
        newUser.Email = userName+ '@cisco.com.test';
        newUser.EmailEncodingKey = 'UTF-8';
        newUser.LastName = 'Test';
        newUser.FirstName = 'cecid';
        newUser.Organization__c = 'Test';
        newUser.LanguageLocaleKey = 'en_US';
        newUser.LocaleSidKey = 'en_US';
        newUser.ProfileId = '00e30000000rrZw';
        newUser.CommunityNickname = userName;
        newUser.TimeZoneSidKey = 'America/Los_Angeles';
        newUser.UserName = userName + '@cisco.com.test';
        newUser.Theatre__c = 'Americas-Canada';
        newUser.Additional_User_Permissions__c = 'Enable EndUser ACCTCreation';
        insert newUser;
        Opportunity opppt=new Opportunity();
        system.Runas(newUser) {
            
            list<Territory2> terrList = [select id from territory2 where territory_level__c = :TerrLevel limit 1] ;
            ID TerrId ;
            for (Territory2 terr : terrList){
                
               TerrId = terr.id ; 
            }
            
            RenewalUserTerritoryMapping__c userTerr = new RenewalUserTerritoryMapping__c (CurrencyIsoCode = 'USD' , OwnerId=newUser.id , TerritoryID__c = TerrId , user__C =newUser.id ) ;
            insert userTerr;
            
        }
        return newUser.id;
    }
    
    //To insert opportunity line items
    public static ID insertLineItems(Id optyId){
        User admin = CEE_TestUtility.getUser('admin', true);
        system.Runas(admin) { 
            String currencyIsoCode = 'USD';
            String service = 'Service';
            String technology = 'Technology'; 
            Product2[] p2 = new Product2[]{};
           /*     
                Renewals_Portfolio__c renewalPortfoloi = new Renewals_Portfolio__c();
            renewalPortfoloi.products__c = 'product1';
            renewalPortfoloi.services__c = 'service1';
            renewalPortfoloi.Default_Timeline__c = 'default';
            renewalPortfoloi.Stages__c = 'stage1';
            renewalPortfoloi.Timelines__c = 'timeline';
            insert renewalPortfoloi;
            */
            //Create new product2                                 
            Product2 p2Tmp = new Product2(ProductCode=Technology,
                                          Name = 'TechName',
                                          Product_Family_1__c='pf1',
                                          Product_Family_2__c='pf2',
                                          Product_Family_3__c='pf3', 
                                          Product_Family_4__c='pf4',
                                          isactive=true);
            p2.add(p2Tmp);      
            insert p2;    
            
            //Create default pricebook    
            Pricebook2 createDefaultPB = new Pricebook2(name='Standard Price Book', isActive=true);
            insert createDefaultPB;
            
            //Create pricebook entry
            PricebookEntry pbeTech = new PricebookEntry();
            pbeTech.Pricebook2Id = createDefaultPB.id;
            pbeTech.Product2Id = p2[0].id;
            pbeTech.IsActive = true;
            pbeTech.UnitPrice = 100;
            insert pbeTech;  
            
            //Create opportunity line item
            OpportunityLineItem opli = new OpportunityLineItem();
            opli.UnitPrice = 57;
            opli.Quantity = 12;
            opli.OpportunityId=optyId;
            opli.PricebookEntryId=pbeTech.id;
            
            insert opli;
            
            
        }
        return optyId ;
    } 
}