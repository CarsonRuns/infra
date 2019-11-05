@isTest(SeeAllData = true)
public class NGCC_CallScript_Previewer_Test {

    // Testing the overall save of Call Script with much validation
    public static testMethod void test_CallScript_Full_Launch_Test() {

        Profile p = [SELECT Id FROM Profile WHERE Name Like '%NGCC%'
            Limit 1
        ];
        UserRole r = [SELECT Id FROM UserRole WHERE Name Like '%Site Manager Alea (Canada)%'
            Limit 1
        ];
        UserRole rSDR = [SELECT Id FROM UserRole WHERE Name Like '%SDR Alea (Canada)%'
            Limit 1
        ];

        User uSMgr = new User(Alias = 'newUser', Email = 'newuserSM@cisco.com.qtr',
            EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p.Id, UserRoleId = r.id,
            TimeZoneSidKey = 'America/Los_Angeles', UserName = 'newuserSM@testorg.com', Theatre__c = 'EMEAR');
        insert uSMgr;
        
        PermissionSet ps = [SELECT Id from PermissionSet where Name like '%NGCC_Call_Script_Super_User%'];
        PermissionSetAssignment psAssignment = new PermissionSetAssignment();
        psAssignment.AssigneeId = uSMgr.Id;
        psAssignment.PermissionSetId = ps.Id;
        insert psAssignment;

        System.runAs(uSMgr) {

            List < CC_Call_Script_Q_A__c > ccCallScriptQA = NGCC_CallScript_Data_Test.testCall_Script_QA();

            Test.startTest();
            CC_Response__c ccRes = new CC_Response__c();
                Test.setCurrentPageReference(New PageReference('Page.NGCC_CallScript_Preview_Mgmt'));
                System.currentPageReference().getParameters().put('CallScript', ccCallScriptQA[0].Call_Script__c);
                System.currentPageReference().getParameters().put('Theater', 'Americas');
                
                ApexPages.Standardcontroller stdCtlCallScriptPreviewer = New ApexPages.StandardController(ccRes);
                NGCC_CallScript_Preview_Mgmt_CTE ccCallScriptPreviewer = new NGCC_CallScript_Preview_Mgmt_CTE(stdCtlCallScriptPreviewer);
                ccCallScriptPreviewer.validateCallScript();   
                PageReference pageRef  = ccCallScriptPreviewer.launchCallScript();  
                //System.assertEquals('/apex/NGCC_CallScript_Preview',pageRef.getUrl());
                 
                 String urlNewPage = pageRef.getUrl();
                 urlNewPage.substring(urlNewPage.indexOf('?')+1);
                 map<string,String> mapQueryString = new map<string,string>();
                 List<String> lstString = urlNewPage.split('&');
                 for(String l:lstString){
                     List<string> lstPar = l.split('=');
                     mapQueryString.put(lstPar[0],lstPar[1]);
                 }
                 
                 Test.setCurrentPageReference(New PageReference('Page.NGCC_CallScript_Preview'));
            System.currentPageReference().getParameters().put('preview', 'yes');
            System.currentPageReference().getParameters().put('ResponseId', mapQueryString.get('ResponseId'));
            System.currentPageReference().getParameters().put('lang', 'en_US');
            System.currentPageReference().getParameters().put('retURL',  mapQueryString.get('retURL'));
            Lead leadCS = new Lead();
            
            ApexPages.Standardcontroller stdCtlCallScript = New ApexPages.StandardController(leadCS);
            NGCC_CallScript_CTE ccCallScript = new NGCC_CallScript_CTE(stdCtlCallScript);
            ccCallScript.getCreateDynamicComponent();
            ccCallScript.cmdSubmitCallScript();
            
            //Stop Testing
            Test.stopTest();
        }
    }    
}