@isTest
public class Product_UI_Redirect_Skip_Stage1_CTE_Test
{
    public static testMethod void testInsert()
    {
        List < sObject > objRecTypeData = Test.loadData(ObjectRecordTypeIds__c.sObjectType,'GlobalTestObjectRecordTypeIds');
        List < sObject > osCSData = Test.loadData(Org_Constants__c.sObjectType,'OrgConstants');
        Org_Constant_CS__c ocs = new Org_Constant_CS__c();
        ocs.name = 'Exclude From PUI and Competitor Popup';
        ocs.Non_Production_Value__c = 'Cisco_ADMIN';
        ocs.Production_Value__c = 'Cisco_ADMIN';
        insert ocs;
        
        String testProfile = null;
        List<String> pieces = new List<String>();
 
        /*User opptyOwner = [Select id,name from user where profile.name='Cisco_ADMIN' and  IsActive = True AND  Additional_User_Permissions__c != 'Enable_ePSS' limit 1];
        opptyOwner.Position_1__c = 'test12345\n\rjdnkjsankjd';
        opptyOwner.Deployment_No__c  = 'SKIP';
        update opptyOwner;*/
        ProfileID__c pf = new ProfileID__c();
    pf.Cisco_Renewals__c = '00ec0000000QmlF';
    pf.Cisco_PSS__c = '00e30000000rrZw'; 
    insert pf;
    
    User opptyOwner = CEE_TestUtility.getUser('admin', true);
 
        test.startTest();
        System.runAs(opptyOwner){
            Opportunity oppty = new Opportunity(OwnerId=opptyOwner.Id,Position__c = '',Opportunity_Owner_AM__c=opptyOwner.Id,name='abc',StageName='2 - Qualification',CloseDate= system.today(), skipValidations__c = true);
            insert oppty;
            update oppty;
 
            Apexpages.StandardController stdController = new Apexpages.StandardController(oppty); // here oppty is the opportunity instance
            Test.setCurrentPage(new PageReference(''));
            testProfile = Utilities.getConstant_CS('CEE Outlook URL');
            pieces = testProfile.split(',');
            
            PageReference pageRef = Page.pdrDown;
            Test.setcurrentpage(pageRef);
            Apexpages.currentpage().getparameters().put('isdtp','mn'); 
            Product_UI_Redirect_Skip_Stage1_CTE puiRedirect = new Product_UI_Redirect_Skip_Stage1_CTE (stdController);
        }
        test.stopTest();
    }
    public static testMethod void testInsert1()
    {
        List < sObject > objRecTypeData = Test.loadData(ObjectRecordTypeIds__c.sObjectType,'GlobalTestObjectRecordTypeIds');
        List < sObject > osCSData = Test.loadData(Org_Constants__c.sObjectType,'OrgConstants');
        Org_Constant_CS__c ocs = new Org_Constant_CS__c();
        ocs.name = 'Exclude From PUI and Competitor Popup';
        ocs.Non_Production_Value__c = 'Cisco_PSS';
        ocs.Production_Value__c = 'Cisco_PSS';
        insert ocs;
        
        String testProfile = null;
        List<String> pieces = new List<String>();
        
        /*User opptyOwner = [Select id,name from user where profile.name='Cisco_ADMIN' and  IsActive = True AND  Additional_User_Permissions__c != 'Enable_ePSS' limit 1];
        opptyOwner.Position_1__c = 'test12345\n\rjdnkjsankjd';
        opptyOwner.Deployment_No__c  = 'SKIP';
        update opptyOwner;*/
        ProfileID__c pf = new ProfileID__c();
    pf.Cisco_Renewals__c = '00ec0000000QmlF';
    pf.Cisco_PSS__c = '00e30000000rrZw'; 
    insert pf;
    
    User opptyOwner = CEE_TestUtility.getUser('admin', true);
        
        test.startTest();
        System.runAs(opptyOwner){
            
            Opportunity oppty = new Opportunity(OwnerId=opptyOwner.Id,Position__c = '',Opportunity_Owner_AM__c=opptyOwner.Id,name='abc',StageName='2 - Qualification',CloseDate= system.today(), skipValidations__c = true);
            insert oppty;
            update oppty;
            
            Apexpages.StandardController stdController = new Apexpages.StandardController(oppty); // here oppty is the opportunity instance
            
            Test.setCurrentPage(new PageReference(''));
            testProfile = Utilities.getConstant_CS('CEE Outlook URL');
            pieces = testProfile.split(',');
            PageReference pageRef = Page.pdrDown;
            Test.setcurrentpage(pageRef);
            Apexpages.currentpage().getparameters().put('isdtp','mn'); 
            Product_UI_Redirect_Skip_Stage1_CTE puiRedirect = new Product_UI_Redirect_Skip_Stage1_CTE (stdController);
            
        }
        test.stopTest();  
    }
 
    public static testMethod void testInsert2()
    {
        List < sObject > objRecTypeData = Test.loadData(ObjectRecordTypeIds__c.sObjectType,'GlobalTestObjectRecordTypeIds');
        List < sObject > osCSData = Test.loadData(Org_Constants__c.sObjectType,'OrgConstants');
        Org_Constant_CS__c ocs = new Org_Constant_CS__c();
        ocs.name = 'Exclude From PUI and Competitor Popup';
        ocs.Non_Production_Value__c = 'Cisco_PSS';
        ocs.Production_Value__c = 'Cisco_PSS';
        insert ocs;
        
        String testProfile = null;
        List<String> pieces = new List<String>();
        
        /*User opptyOwner = [Select id,name from user where profile.name='Cisco_ADMIN' and  IsActive = True AND  Additional_User_Permissions__c != 'Enable_ePSS' limit 1];
        opptyOwner.Position_1__c = 'test12345\n\rjdnkjsankjd';
        opptyOwner.Deployment_No__c  = 'SKIP';
        update opptyOwner;*/
        ProfileID__c pf = new ProfileID__c();
    pf.Cisco_Renewals__c = '00ec0000000QmlF';
    pf.Cisco_PSS__c = '00e30000000rrZw'; 
    insert pf;
    
    User opptyOwner = CEE_TestUtility.getUser('admin', true);
 
        test.startTest();
        System.runAs(opptyOwner){
            Opportunity oppty = new Opportunity(OwnerId=opptyOwner.Id,Position__c = '',Opportunity_Owner_AM__c=opptyOwner.Id,name='abc',StageName='1 - Prospect',CloseDate= system.today(), skipValidations__c = true);
            insert oppty;
            update oppty;
 
            Apexpages.StandardController stdController = new Apexpages.StandardController(oppty); // here oppty is the opportunity instance
            Test.setCurrentPage(new PageReference(''));
            testProfile = Utilities.getConstant_CS('CEE Outlook URL');
            pieces = testProfile.split(',');            
            PageReference pageRef = Page.pdrDown;
            Test.setcurrentpage(pageRef);
            Apexpages.currentpage().getparameters().put('isdtp','mn'); 
            Product_UI_Redirect_Skip_Stage1_CTE puiRedirect = new Product_UI_Redirect_Skip_Stage1_CTE (stdController);
        }
        test.stopTest(); 
    }
    public static testMethod void testStateInitialization(){
        List < sObject > objRecTypeData = Test.loadData(ObjectRecordTypeIds__c.sObjectType,'GlobalTestObjectRecordTypeIds');
        List < sObject > osCSData = Test.loadData(Org_Constants__c.sObjectType,'OrgConstants');
        Org_Constant_CS__c ocs = new Org_Constant_CS__c();
        ocs.name = 'Exclude From PUI and Competitor Popup';
        ocs.Non_Production_Value__c = 'Cisco_PSS';
        ocs.Production_Value__c = 'Cisco_PSS';
        insert ocs;
        
        String testProfile = null;
        List<String> pieces = new List<String>();
        
       /* User opptyOwner = [Select id,name from user where profile.name='Cisco_ADMIN' and  IsActive = True AND  Additional_User_Permissions__c != 'Enable_ePSS' limit 1];
        opptyOwner.Position_1__c = 'test12345\n\rjdnkjsankjd';
        opptyOwner.Deployment_No__c  = 'SKIP';
        update opptyOwner; */
        ProfileID__c pf = new ProfileID__c();
            pf.Cisco_Renewals__c = '00ec0000000QmlF';
            pf.Cisco_PSS__c = '00e30000000rrZw';       
            insert pf;

        User opptyOwner= CEE_TestUtility.getUser('admin', true);
        
        test.startTest();
        System.runAs(opptyOwner){
            Opportunity oppty = new Opportunity(OwnerId=opptyOwner.Id,Position__c = '',Opportunity_Owner_AM__c=opptyOwner.Id,name='abc',StageName='1 - Prospect',CloseDate= system.today(), skipValidations__c = true);
            insert oppty;
            update oppty;

            Apexpages.StandardController stdController = new Apexpages.StandardController(oppty); // here oppty is the opportunity instance
            Test.setCurrentPage(new PageReference(''));
            testProfile = Utilities.getConstant_CS('CEE Outlook URL');
            pieces = testProfile.split(',');            
            PageReference pageRef = Page.pdrDown;
            Test.setcurrentpage(pageRef);
            Apexpages.currentpage().getparameters().put('isdtp','mn'); 
            Product_UI_Redirect_Skip_Stage1_CTE puiRedirect = new Product_UI_Redirect_Skip_Stage1_CTE (stdController);
            puiRedirect.ProductRedirect1 = '';
            String redirect = puiRedirect.ProductRedirect1;
            puiRedirect.PUI_URL1 = '';
           String puiUrl = puiRedirect.PUI_URL1;
            puiRedirect.FP_URL1 = '';
            String fpUrl = puiRedirect.FP_URL1;
            puiRedirect.ProductRedirect = false;
            Boolean redirectProd = puiRedirect.ProductRedirect;
            puiRedirect.ForcastRedirect = false;
            Boolean redirectForcast = puiRedirect.ForcastRedirect;
            puiRedirect.ForcastRedirect1 = 'false';
            String redirectForcast1 = puiRedirect.ForcastRedirect1;
            puiRedirect.ProductRedirect1 = 'false';
            String redirectProd1 = puiRedirect.ProductRedirect1;
           /* puiRedirect.PUI_URL = '';
            String puiUrl1 = puiRedirect.PUI_URL;
            puiRedirect.FP_URL = '';
            String fpUrl1 = puiRedirect.FP_URL; */
        }
        test.stopTest(); 
        
    }
    
    
}