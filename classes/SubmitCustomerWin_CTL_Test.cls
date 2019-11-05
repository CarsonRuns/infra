@isTest(SeeAllData = true)
public class SubmitCustomerWin_CTL_Test {
    static testmethod void getOpportunityDetailsTest(){
        
        Id RecordTypeIdopportunity = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Parent Opportunity').getRecordTypeId();
        Utilities.setValidationSkip(true);
        Account acc= new Account(name='Test Account',BillingCity='San Francisco');
        insert acc; 
        opportunity opty1 = new opportunity();
        opty1.AccountId = acc.id;
        opty1.Theater__c = 'Americas-Canada';
        opty1.recordtypeid=RecordTypeIdopportunity ;
        //opty1.recordtypeid=recordID.id;
        opty1.Name= 'TestAccount';
        opty1.StageName ='2 - Qualification';
        opty1.CloseDate= System.today() + 50;
        opty1.Expected_Product__c=10.0;
        opty1.error_description__c='error';
        opty1.DealID__c='18022972';
        opty1.Opportunity_Status__c='active';
        opty1.Position__c='Americas lrpearso';
        opty1.CurrencyIsoCode = 'USD';
        opty1.Competitors__c = 'HPE';
        insert opty1;
        SubmitCustomerWin_CTL.getOpportunityDetails(opty1.id);
        /*String dyUN = UserInfo.getOrganizationId() + System.now().millisecond();
        Profile p = [SELECT Id FROM Profile WHERE name='Cisco_Admin' limit 1];
        System.debug('profileId--->'+p.id);
        User usr = new User();
        usr.FirstName = 'Abcd';
        usr.LastName = 'Defg';
        usr.ProfileId = p.Id;
        usr.Additional_User_Permissions__c='Enable EndUser ACCTCreation';
        usr.Theatre__c = 'EMEAR';
        usr.Username= dyUN + 'abc@xyz.com';
        usr.alias ='abcd';
            usr.Email ='abc@cisco.com';
            usr.CommunityNickname='ghghg';
            usr.TimeZoneSidKey ='America/Los_Angeles';
            usr.LocaleSidKey ='en_US';
            usr.LanguageLocaleKey='en_US';
            usr.EmailEncodingKey ='ISO-8859-1';
            usr.IsActive=true;
        insert usr;
        system.runAs(usr){
           /* Account acc = new Account();
            acc.Name = 'abcd';
            acc.City__c = 'Bangalore';
            acc.Country__c = 'India';
            acc.AddressLine1__c = 'Test';
            acc.RecordTypeId='0123000000004aVAAQ';
            insert acc;*/
           //String recId=Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Channel').getRecordTypeId();
           //Account acc=[Select Id from Account where RecordTypeId='0123000000004aVAAQ' limit 1];
          /* Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('End-User').getRecordTypeId();
            Account acc = new Account(Name = 'test',recordtypeid=devRecordTypeId ,CSCSiteID__c ='5555',CSCID__c = '5555',ownerid = usr.id,AddressLine1__c='Test123',AddressLine1_English__c='Test231',AddressLine2__c='Testqa1',AddressLine2_English__c='Testqa123',City__c='UN',City_English__c='Test',State__c= 'AP',State_Province_English__c='ENDTESt',Country__c='INDIA',Country_English__c='INDIA',TOKENID__c='12333',ZipPostalCode__c='847733',Zip_Postal_Code_English__c='766644' );
            insert acc;*/
            
           /* Opportunity opty = new Opportunity();
            opty.name = 'efgh';
            opty.StageName = '1 - Prospect';
            opty.DealID__c = 'abcd';
            opty.AccountId = acc.Id;
            opty.Installed_Base__c = 'New Base';
            opty.Expected_Product__c = 500;
            opty.Expected_Service__c = 500;
            opty.CloseDate = system.today();
            opty.Opportunity_Owner_AM__c = userinfo.getUserid();
            insert opty;
            SubmitCustomerWin_CTL.getOpportunityDetails(opty.id);*/
        //}        
        
       /* Profile p = [SELECT Id FROM Profile WHERE Name = 'Cisco_Admin' Limit 1];
        User admUser = new User(Additional_User_Permissions__c = 'Enable EndUser ACCTCreation', Alias = 'newUser', Email = 'batchJobOppty@cisco.com',
                                EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                                LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'batchJobOppty@cisco.com.testing', Theatre__c = 'Americas-US Commercial');
        insert admUser; 
        System.runAs(admUser){
            //List<Account> acclist = new List<Account>();                
            
            Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('End-User').getRecordTypeId();
            User admUser1 =[Select id, Dummy_User__c,username from User where id=:admUser.Id];
            admUser1.Dummy_User__c=true;
            update admUser1;
            Account acc = new Account(Name = 'test',recordtypeid=devRecordTypeId ,CSCSiteID__c ='5555',CSCID__c = '5555',ownerid = admUser.id,AddressLine1__c='Test123',AddressLine1_English__c='Test231',AddressLine2__c='Testqa1',AddressLine2_English__c='Testqa123',City__c='UN',City_English__c='Test',State__c= 'AP',State_Province_English__c='ENDTESt',Country__c='INDIA',Country_English__c='INDIA',TOKENID__c='12333',ZipPostalCode__c='847733',Zip_Postal_Code_English__c='766644' );
            insert acc;
            Test.startTest();
            Opportunity opty = new Opportunity();
            opty.name = 'efgh';
            opty.StageName = '1 - Prospect';
            opty.DealID__c = 'abcd';
            opty.AccountId = acc.Id;
            opty.Installed_Base__c = 'New Base';
            opty.Expected_Product__c = 500;
            opty.Expected_Service__c = 500;
            opty.CloseDate = system.today();
            opty.Opportunity_Owner_AM__c = userinfo.getUserid();
            insert opty;
            SubmitCustomerWin_CTL.getOpportunityDetails(opty.id);
            Test.StopTest();
            
        }
    }*/
        
        /*Profile p = [SELECT Id FROM Profile WHERE Name = 'Cisco_Admin' Limit 1];
        User admUser = new User(Additional_User_Permissions__c = 'Enable EndUser ACCTCreation', Alias = 'newUser', Email = 'batchJobOppty@cisco.com',
                               EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                               LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'batchJobOppty@cisco.com.testing', Theatre__c = 'Americas-US Commercial');
        insert admUser; 
          System.runAs(admUser){
               //List < sObject > osData = Test.loadData(Org_Constant_CS__c.sObjectType,'OrgConstantCS_data');
               // ObjectRecordTypeIds__c objectnew = new ObjectRecordTypeIds__c(SetupOwnerId=UserInfo.getOrganizationId(), AccountChannelRecordTypeId__c='0123000000004aV');
                //insert objectnew;
                //List < sObject > objRecTypeData = Test.loadData(ObjectRecordTypeIds__c.sObjectType,'ObjectRecordTypeIds');
                List<Account> acclist = new List<Account>();                
               
                String devRecordTypeId = '0123000000004aUAAQ';//Schema.SObjectType.Account.getRecordTypeInfosByName().get('End-User').getRecordTypeId();
                
                Account acc = new Account(Name = 'test',recordtypeid=devRecordTypeId ,CSCSiteID__c ='5556',CSCID__c = '5555',ownerid = admUser.id,AddressLine1__c='Test123',AddressLine1_English__c='Test231',AddressLine2__c='Testqa1',AddressLine2_English__c='Testqa123',City__c='UN',City_English__c='Test',State__c= 'AP',State_Province_English__c='ENDTESt',Country__c='INDIA',Country_English__c='INDIA',TOKENID__c='12333',ZipPostalCode__c='847733',Zip_Postal_Code_English__c='766644' );
                insert acc;

                Account acc1 = new Account(Name = 'test1',recordtypeid=devRecordTypeId ,CSCSiteID__c ='5555',CSCID__c = '555',ownerid = admUser.id,AddressLine1__c='Test123',AddressLine1_English__c='Test231',AddressLine2__c='Testqa1',AddressLine2_English__c='Testf123',City__c='UN',City_English__c='Test',State__c= 'AP',State_Province_English__c='ENDTESt',Country__c='INDIA',Country_English__c='INDIA',TOKENID__c='74588',ZipPostalCode__c='84782',Zip_Postal_Code_English__c='888866');
                //insert acc1;
                acclist.add(acc);
                //acclist.add(acc1);                 
                List<Account> acclist1 = new List<Account>() ;
                Account acc3 = new Account(Name = 'test1',recordtypeid=devRecordTypeId ,CSCSiteID__c ='10000023',CSCID__c = '10000023',ownerid = admUser.id,AddressLine1__c='Test123',AddressLine1_English__c='Test231',AddressLine2__c='Testqa1',AddressLine2_English__c='Testf123',City__c='UN',City_English__c='Test',State__c= 'NH',State_Province_English__c='NH',Country__c='TESTARUBA',Country_English__c='TESTARUBA',TOKENID__c='74588',ZipPostalCode__c='1016CG',Zip_Postal_Code_English__c='94134');
                //Account acc4 = new Account(Name = 'test1',recordtypeid=devRecordTypeId ,CSCSiteID__c ='1240220',CSCID__c = '1224020',ownerid = admUser.id,AddressLine1__c='Test123',AddressLine1_English__c='Test231',AddressLine2__c='Testqa1',AddressLine2_English__c='Testf123',City__c='UN',City_English__c='Test',State__c= 'NH',State_Province_English__c='NH',Country__c='ARUBA',Country_English__c='ARUBA',TOKENID__c='74588',ZipPostalCode__c='1016CG',Zip_Postal_Code_English__c='94134');
                
                acclist1.add(acc3);
                //insert acclist1;
                //List<sObject> lsOrgConstants = Test.loadData(Org_Constants__c.sObjectType, 'OrgConstants');
                string inputxml1 ='<CSCLIST><CSCID>1000000023</CSCID><AccountInfo><Name>test1</Name><AddressLine1__c>HERENGRACHT 352 </AddressLine1__c><AddressLine1_English__c>Meander725_Eng</AddressLine1_English__c><AddressLine2__c>bldg 10</AddressLine2__c><AddressLine2_English__c>bldg10_eng</AddressLine2_English__c><CSCSiteID__c>1000000023</CSCSiteID__c><CSCID__c>1000000023</CSCID__c><City__c>AMSTERDAM</City__c><City_English__c>San Jose</City_English__c><State__c>NH</State__c><State_Province_English__c>Gelderland_eng</State_Province_English__c><Country__c>ARUBA</Country__c><Country_English__c>ARUBA</Country_English__c><TOKENID__c></TOKENID__c><ZipPostalCode__c>1016CG</ZipPostalCode__c><Zip_Postal_Code_English__c>94134</Zip_Postal_Code_English__c></AccountInfo><CRCountry__c>ARUBA</CRCountry__c></CSCLIST>';
                
                Test.startTest();
                AccountSearch.sitelookup(acclist[0].CSCSiteID__c,acclist[0].ownerid);
                AccountSearch.sitelookupWDummy(acclist[0].CSCSiteID__c,acclist[0].ownerid,true);
                AccountSearch.sitelookupWDummy('1231',acclist[0].ownerid,true);
                AccountSearch.sitelookup(acclist[0].CSCSiteID__c='5555',acclist[0].ownerid);
                        
                AccountSearch.CompanyLookup(inputxml1,acclist1 [0].ownerid);       
                Test.StopTest();
                AccountSearch.sitelookupWDummy('15555',acclist[0].ownerid,true);
                
                User admUser1 =[Select id, Dummy_User__c,username from User where id=:admUser.Id];
                admUser1.Dummy_User__c=true;
                update admUser1;        
                Account acc5 = new Account(Name = 'test1',recordtypeid=devRecordTypeId ,CSCSiteID__c ='1000000023',CSCID__c = '1000000023',ownerid = admUser1.id,AddressLine1__c='Test123',AddressLine1_English__c='Test231',AddressLine2__c='Testqa1',AddressLine2_English__c='Testf123',City__c='UN',City_English__c='Test',State__c= 'NH',State_Province_English__c='NH',Country__c='ARUBA',Country_English__c='ARUBA',TOKENID__c='74588',ZipPostalCode__c='1016CG',Zip_Postal_Code_English__c='94134',CRCountry__c ='ARUBA');
                Account acc7 = new Account(Name = 'test1',recordtypeid=devRecordTypeId ,CSCSiteID__c ='1000000023',CSCID__c = '1000000023',ownerid = admUser1.id,AddressLine1__c='Test123',AddressLine1_English__c='Test231',AddressLine2__c='Testqa1',AddressLine2_English__c='Testf123',City__c='UN',City_English__c='Test',State__c= 'NH',State_Province_English__c='NH',Country__c='ARUBA',Country_English__c='ARUBA',TOKENID__c='74588',ZipPostalCode__c='1016CG',Zip_Postal_Code_English__c='94134',CRCountry__c ='ARUBA');
                insert acc5;
                insert acc7;
                AccountSearch.CompanyLookupCreate(inputxml1,acc5.ownerid,true,admUser1.username);
                        
                AccountSearch.CompanyLookupCreate(inputxml1,'batchJobOppty',false,admUser1.username);*/
              
      }  
}