@isTest
public class LxNewRequestResource_CTE_Test {
    public static testMethod void getRecordTypesMethod(){
        //bypass validation rules
        Utilities.setIsTestMethod(true);
        Utilities.setValidationSkip(true);
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Cisco_ADMIN' Limit 1];
        User usr = lxTestDataFactory.createSingleUser(p.Id);
        insert usr;
        Account acc=Null;

        system.runAs(usr){
            
			lxTestDataFactory.createCustomSettings();
            acc = lxTestDataFactory.createChannelAccount(usr.Id);
            insert acc;
            Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel').getRecordTypeId();
        	Account acc1 = new Account(Name = 'test1',Partner_Account_Status__c='Active (Registered)',recordtypeid=RecordTypeIdAccount ,CSCSiteID__c ='5555',CSCID__c = '5555',ownerid = usr.id,AddressLine1__c='Test123',AddressLine1_English__c='Test231',AddressLine2__c='Testqa1',AddressLine2_English__c='Testqa123',City__c='UN',City_English__c='Test',State__c= 'AP',State_Province_English__c='ENDTESt',Country__c='INDIA',Country_English__c='INDIA',TOKENID__c='12333',ZipPostalCode__c='847733',Zip_Postal_Code_English__c='766644'); 
            insert acc1;            
            String ParentRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Parent Opportunity').getRecordTypeId();

			Opportunity opp = new Opportunity(name='Test', accountId = acc.id, StageName='2 - Qualified', CloseDate=System.today() + 50, Expected_Product__c=10.0,
                                               error_description__c='error', DealID__c='1', Opportunity_Status__c='Active', recordtypeId=ParentRecordTypeId , Opportunity_Owner_AM__c =userinfo.getUserId(),
                                                Primary_Partner__c = acc1.id, Competitors__c = 'A10 Networks', Is_Product_Quote_Integrated__c = 'Yes', Is_Service_Quote_Integrated__c = 'No' );        
            list<Opportunity> OppList= new list<Opportunity>();
        OppList.add(opp);
        insert OppList;
        LxNewRequestResource_CTE.getRecordTypeNames();
        LxNewRequestResource_CTE.oppWrapper oo= new LxNewRequestResource_CTE.oppWrapper();
        oo.opp=opp;
        oo.usr=usr;
        LxNewRequestResource_CTE.oppWrapper.getDetails(opp.id);
    }
    }}