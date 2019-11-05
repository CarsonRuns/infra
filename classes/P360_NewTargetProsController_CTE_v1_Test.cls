//** This Test Class is used to TP Creation from Account Page**/
//** Author:     Mukesh JSC Team
//** Date:       01/16/2013


@isTest(SeeAllData=True)
public class P360_NewTargetProsController_CTE_v1_Test{

    public static testMethod void testP360_NewTargetProsController_CTE_v1_PositiveTest() 
    {
        
        
        user u = new user(firstName='Test',LastName ='AM', USERNAME='testam@cisco.com.sales.test',email='testam@cisco.com.test',ALIAS='testam',COMMUNITYNICKNAME='testam',ISACTIVE=True,
                            TIMEZONESIDKEY='America/Los_Angeles',PROFILEID = '00e30000000qhPXAAY',LANGUAGELOCALEKEY ='en_US',THEATRE__C='APJC-APAC',
                            LOCALESIDKEY ='en_US',EMAILENCODINGKEY='UTF-8');
        
             
        insert u;
       
        u.Additional_User_Permissions__c='Enable Target Prospect Creation';
        update u;
        Test.startTest();
                
        Assigned_Partner__c TPPos = GenericStaticTestData.gettestTargetProspectRecord();       

        System.RunAs(u){

        /////////Positive Test /////////////////////////
        Test.setCurrentPageReference(New PageReference('Page.P360_NewTargetProspectPagev1'));
        System.currentPageReference().getParameters().put('CF00N80000004wXYC', 'Testing');
        ApexPages.Standardcontroller stdCtlTPCreatePos = New ApexPages.StandardController(TPPos);
        
        P360_NewTargetProsController_CTE_v1 contTPCreatePos=new P360_NewTargetProsController_CTE_v1(stdCtlTPCreatePos);
        system.debug('TP Account'+TPPos.Customer_Account__c);

        contTPCreatePos.getCreateNewValidity();
        contTPCreatePos.accountPageRedirect();
        
        /////////Negative Test /////////////////////////
        Test.setCurrentPageReference(New PageReference('Page.P360_NewTargetProspectPagev1'));
        
        P360_NewTargetProsController_CTE_v1 contTPCreateNeg=new P360_NewTargetProsController_CTE_v1();
        
        contTPCreateNeg.getCreateNewValidity();
        contTPCreateNeg.accountPageRedirect();
        contTPCreateNeg.PageRedirect();
                
        }
        
       Test.stopTest();
    }
    
    public static testMethod void testP360_NewTargetProsController_CTE_v1_NegativeTest() 
    {
        
        Assigned_Partner__c TPPos = GenericStaticTestData.gettestTargetProspectRecord();
        
        user u = new user(firstName='Test',LastName ='AM', USERNAME='testam@cisco.com.sales.test',email='testam@cisco.com.test',ALIAS='testam',COMMUNITYNICKNAME='testam',ISACTIVE=True,
                            TIMEZONESIDKEY='America/Los_Angeles',PROFILEID = '00e30000000qhPXAAY',LANGUAGELOCALEKEY ='en_US',THEATRE__C='APJC-APAC',
                            LOCALESIDKEY ='en_US',EMAILENCODINGKEY='UTF-8');
        
             
        insert u;
       
        
        Test.startTest();
        System.RunAs(u){
        
        /////////Positive Test /////////////////////////
        Test.setCurrentPageReference(New PageReference('Page.P360_NewTargetProspectPagev1'));
        ApexPages.Standardcontroller stdCtlTPCreatePos = New ApexPages.StandardController(TPPos);
        
        P360_NewTargetProsController_CTE_v1 contTPCreatePos=new P360_NewTargetProsController_CTE_v1(stdCtlTPCreatePos);
        
        contTPCreatePos.getCreateNewValidity();
        contTPCreatePos.accountPageRedirect();
        /*
        /////////Negative Test /////////////////////////
        Test.setCurrentPageReference(New PageReference('Page.P360_NewTargetProspectPagev1'));
        
        P360_NewTargetProsController_CTE_v1 contTPCreateNeg=new P360_NewTargetProsController_CTE_v1();
        
        contTPCreateNeg.getCreateNewValidity();
        contTPCreateNeg.accountPageRedirect();
        contTPCreateNeg.PageRedirect();
          */      
        }
        
       Test.stopTest();
    }
    
    
}