@isTest(SeeAllData = true)
public class NGCC_CallScript_Test {

    // Testing the Call Script with Number Validation
    public static testMethod void test_CallScript_Number_Valdiation_Test() {

        Profile p = [SELECT Id FROM Profile WHERE Name Like '%NGCC'
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
            CC_Master_Question_Answer_Bank__c ccMQA = NGCC_CallScript_Data_Test.testNGCC_Call_Script_MasterQA('Number');
            insert ccMQA;
            
            List<RecordType> answerRec = [Select Id from RecordType where Name = 'Answer' Limit 1];
            
            CC_Question_Answer_Translations__c ccQATObj = new CC_Question_Answer_Translations__c();
            ccQATObj.CC_Master_Question_Answer_Bank__c = ccMQA.Id;
            ccQATObj.Language__c = 'English';
            ccQATObj.Language_Code__c = 'en_US';
            if(ccMQA.recordtypeId  != answerRec[0].Id)
            {
                ccQATObj.Translated_Value__c = ccMQA.Question_Text__c;    
            }else
            {
                ccQATObj.Translated_Value__c = ccMQA.Answer_Text__c;    
            }
            
            ccQATObj.MasterQuestionBankId__c = ccMQA.Id+ccQATObj.Language_Code__c;
            
            insert ccQATObj ;
            List<CC_Question_Answer_Translations__c > a=[select Id from CC_Question_Answer_Translations__c where CC_Master_Question_Answer_Bank__c =: ccMQA.id];
            system.debug('jjjjjjjj++'+a);
            CC_Call_Script__c ccCS = NGCC_CallScript_Data_Test.test_Call_Script();
            CC_Call_Script_Q_A__c ccCSQA = NGCC_CallScript_Data_Test.testNGCC_Call_Script_Call_Script_QA(ccCS, ccMQA);
            insert ccCSQA;

            ccCS.Status__c = 'Active';
            Update ccCS;

            Lead leadCS = NGCC_CallScript_Data_Test.testLead();
            Campaign camCS = NGCC_CallScript_Data_Test.testCampaign();
            camCS.Call_Script__c = ccCS.Id;
            Update camCS;

            leadCS.Campaign_Name__c = camCS.Id;
            update leadCS;


            //Creating Responses
            CC_Response__c ccRes = New CC_Response__c();
            ccRes.Name = leadCS.Name + System.Now();
            ccRes.Call_Script__c = leadCS.Campaign_Name__r.Call_Script__c;
            ccRes.Lead__c = leadCS.Id;
            ccRes.Campaign__c = leadCS.Campaign_Name__c;
            ccRes.Key_Code__c = leadCS.ProgramEvent__c;
            ccRes.Source_Event_Number__c = leadCS.Source_Event_Number__c;
            ccRes.Source_System_Name__c = 'NGCC';
            insert ccRes;

            //Creating Response Detail
            CC_Response_Detail__c newDetail = NGCC_CallScript_Data_Test.testNGCC_Call_Script_Response_Detail(ccCS, ccRes, ccCSQA);
            insert newDetail;

            //Begin Testing
            Test.startTest();

            Test.setCurrentPageReference(New PageReference('Page.NGCC_CallScript'));
            System.currentPageReference().getParameters().put('id', leadCS.Id);
            System.currentPageReference().getParameters().put('ResponseId', ccRes.Id);
            System.currentPageReference().getParameters().put('lang', 'en_US');

            ApexPages.Standardcontroller stdCtlCallScript = New ApexPages.StandardController(leadCS);
            NGCC_CallScript_CTE ccCallScript = new NGCC_CallScript_CTE(stdCtlCallScript);
            ccCallScript.getCreateDynamicComponent();



            ccCallScript.responseObj.status__c = 'Qualified Lead';
            ccCallScript.cmdSubmitCallScript();

            List < Apexpages.Message > msgs = ApexPages.getMessages();
            boolean b = false;
            for (Apexpages.Message msg: msgs) {
                if (msg.getDetail().contains('Enter value between')) b = true;
            }
            //System.AssertEquals(true, b);
        }
        Test.stopTest();
    }

    // Testing the overall save of Call Script with much validation
    public static testMethod void test_CallScript_Full_Launch_Test() {

        Profile p = [SELECT Id FROM Profile WHERE Name Like '%NGCC'
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
            Lead leadCS = NGCC_CallScript_Data_Test.testLead();
            Campaign camCS = NGCC_CallScript_Data_Test.testCampaign();
            camCS.Call_Script__c = ccCallScriptQA[0].Call_Script__c;
            Update camCS;
            leadCS.Campaign_Name__c = camCS.Id;
            leadCS.DedupeRecord__c ='Dedupe';
            update leadCS;

            //Activating the call Script
            CC_Call_Script__c ccCS = [Select Id from CC_Call_Script__c where Id = : ccCallScriptQA[0].Call_Script__c];
            ccCS.Status__c = 'Active';

            update ccCS;

            //Creating Responses
            CC_Response__c ccRes = New CC_Response__c();
            ccRes.Name = leadCS.Name + System.Now();
            ccRes.Call_Script__c = leadCS.Campaign_Name__r.Call_Script__c;
            ccRes.Lead__c = leadCS.Id;
            ccRes.Campaign__c = leadCS.Campaign_Name__c;
            ccRes.Key_Code__c = leadCS.ProgramEvent__c;
            ccRes.Source_Event_Number__c = leadCS.Source_Event_Number__c;
            ccRes.Source_System_Name__c = 'NGCC';
            ccRes.Response_Type__c = 'Inbound Call';
            insert ccRes;

            //Creating Response Detail

            List < CC_Response_Detail__c > newResDetail = new List < CC_Response_Detail__c > ();
            integer i = 1;

            for (CC_Call_Script_Q_A__c csQA: ccCallScriptQA) {
                CC_Response_Detail__c newDetail = NGCC_CallScript_Data_Test.testNGCC_Call_Script_Response_Detail(ccCS, ccRes, csQA);
                newResDetail.add(newDetail);
            }
            insert newResDetail;
            //Begin Testing
            Test.startTest();
            //system.assertequals(35,newResDetail.size());
            Test.setCurrentPageReference(New PageReference('Page.NGCC_CallScript'));
            System.currentPageReference().getParameters().put('id', leadCS.Id);
            System.currentPageReference().getParameters().put('ResponseId', ccRes.Id);
            System.currentPageReference().getParameters().put('lang', 'en_US');

            ApexPages.Standardcontroller stdCtlCallScript = New ApexPages.StandardController(leadCS);
            NGCC_CallScript_CTE ccCallScript = new NGCC_CallScript_CTE(stdCtlCallScript);
            ccCallScript.getCreateDynamicComponent();
            ccCallScript.responseObj.status__c = 'Qualified Lead';
            ccCallScript.cmdSubmitCallScript();
            ccCallScript.responseObj.status__c = 'No Answer';
            ccCallScript.cmdSubmitCallScript();
            ccCallScript.statusUpdate();
            ccCallScript.redirectToSearch();
            //Stop Testing
            Test.stopTest();
        }
    }

    // Testing the Call Script with Number Validation
    public static testMethod void test_CallScript_ReferAContact_Test() {

        Profile p = [SELECT Id FROM Profile WHERE Name Like '%NGCC'
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

            CC_Master_Question_Answer_Bank__c ccMQA = NGCC_CallScript_Data_Test.testNGCC_Call_Script_MasterQA('Text');
            insert ccMQA;
            
            List<RecordType> answerRec = [Select Id from RecordType where Name = 'Answer' Limit 1];
            
            CC_Question_Answer_Translations__c ccQATObj = new CC_Question_Answer_Translations__c();
            ccQATObj.CC_Master_Question_Answer_Bank__c = ccMQA.Id;
            ccQATObj.Language__c = 'English';
            ccQATObj.Language_Code__c = 'en_US';
            if(ccMQA.recordtypeId  != answerRec[0].Id)
            {
                ccQATObj.Translated_Value__c = ccMQA.Question_Text__c;    
            }else
            {
                ccQATObj.Translated_Value__c = ccMQA.Answer_Text__c;    
            }
            
            ccQATObj.MasterQuestionBankId__c = ccMQA.Id+ccQATObj.Language_Code__c;
            
            insert ccQATObj ;

            CC_Call_Script__c ccCS = NGCC_CallScript_Data_Test.test_Call_Script();
            CC_Call_Script_Q_A__c ccCSQA = NGCC_CallScript_Data_Test.testNGCC_Call_Script_Call_Script_QA(ccCS, ccMQA);
            insert ccCSQA;

            ccCS.Status__c = 'Active';
            Update ccCS;

            Lead leadCS = NGCC_CallScript_Data_Test.testLead();
            Campaign camCS = NGCC_CallScript_Data_Test.testCampaign();
            camCS.Call_Script__c = ccCS.Id;
            Update camCS;

            leadCS.Campaign_Name__c = camCS.Id;
            update leadCS;

            //Creating Responses
            CC_Response__c ccRes = New CC_Response__c();
            ccRes.Name = leadCS.Name + System.Now();
            ccRes.Call_Script__c = leadCS.Campaign_Name__r.Call_Script__c;
            ccRes.Lead__c = leadCS.Id;
            ccRes.Campaign__c = leadCS.Campaign_Name__c;
            ccRes.Key_Code__c = leadCS.ProgramEvent__c;
            ccRes.Source_Event_Number__c = leadCS.Source_Event_Number__c;
            ccRes.Source_System_Name__c = 'NGCC';
            insert ccRes;

            //Creating Response Detail
            CC_Response_Detail__c newDetail = NGCC_CallScript_Data_Test.testNGCC_Call_Script_Response_Detail(ccCS, ccRes, ccCSQA);
            insert newDetail;
            
            //Begin Testing
            Test.startTest();

            Test.setCurrentPageReference(New PageReference('Page.NGCC_CallScript'));
            System.currentPageReference().getParameters().put('id', leadCS.Id);
            System.currentPageReference().getParameters().put('ResponseId', ccRes.Id);
            System.currentPageReference().getParameters().put('lang', 'en_US');

            ApexPages.Standardcontroller stdCtlCallScript = New ApexPages.StandardController(leadCS);
            NGCC_CallScript_CTE ccCallScript = new NGCC_CallScript_CTE(stdCtlCallScript);
            ccCallScript.getCreateDynamicComponent();

            //Testing the Call In Progress
            ccCallScript.responseObj.status__c = 'Call in Progress';
            ccCallScript.cmdSubmitCallScript();

            //Testing the Call Back Status
            ccCallScript.responseObj.status__c = 'Call Back';
            ccCallScript.callBackTime = System.Now() - 1;
            ccCallScript.cmdSubmitCallScript();

            List < Apexpages.Message > msgsCallBack = ApexPages.getMessages();
            boolean bCallBack = false;
            for (Apexpages.Message msg: msgsCallBack) {
                if (msg.getDetail().contains('Call Back')) bCallBack = true;
            }
            //System.AssertEquals(true, bCallBack);


            //Tesing Refer a New Contact
            ccCallScript.responseObj.status__c = 'Refer a New Contact';
            PageReference ref = ccCallScript.cmdSubmitCallScript();
            //boolean b = false;
            //if (ref.getUrl().contains('/apex/NGCC_MODS_SFDC_Contact_Search')) b = true;
            //System.AssertEquals(true, b);
            //StopTesting
            Test.stopTest();
        }
    }
    // Testing the Call Script with Number Validation
    public static testMethod void test_CallScript_ReferAContact_Pos_Test() {

        Profile p = [SELECT Id FROM Profile WHERE Name Like '%NGCC'
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

            CC_Master_Question_Answer_Bank__c ccMQA = NGCC_CallScript_Data_Test.testNGCC_Call_Script_MasterQA('Text');
            insert ccMQA;
            
            List<RecordType> answerRec = [Select Id from RecordType where Name = 'Answer' Limit 1];
            
            CC_Question_Answer_Translations__c ccQATObj = new CC_Question_Answer_Translations__c();
            ccQATObj.CC_Master_Question_Answer_Bank__c = ccMQA.Id;
            ccQATObj.Language__c = 'English';
            ccQATObj.Language_Code__c = 'en_US';
            if(ccMQA.recordtypeId  != answerRec[0].Id)
            {
                ccQATObj.Translated_Value__c = ccMQA.Question_Text__c;    
            }else
            {
                ccQATObj.Translated_Value__c = ccMQA.Answer_Text__c;    
            }
            
            ccQATObj.MasterQuestionBankId__c = ccMQA.Id+ccQATObj.Language_Code__c;
            
            insert ccQATObj ;

            CC_Call_Script__c ccCS = NGCC_CallScript_Data_Test.test_Call_Script();
            CC_Call_Script_Q_A__c ccCSQA = NGCC_CallScript_Data_Test.testNGCC_Call_Script_Call_Script_QA(ccCS, ccMQA);
            insert ccCSQA;

            ccCS.Status__c = 'Active';
            Update ccCS;

            Lead leadCS = NGCC_CallScript_Data_Test.testLead();
            Campaign camCS = NGCC_CallScript_Data_Test.testCampaign();
            camCS.Call_Script__c = ccCS.Id;
            Update camCS;

            leadCS.Campaign_Name__c = camCS.Id;
            leadCS.Address_Line_1__c = '175';
            leadCS.Address_Line_2__c = 'West';
            leadCS.Address_Line_3__c = 'Tasman';
            leadCS.CustomCountry__c = 'UNITED STATES';
            leadCS.CustomCity__c = 'SAN JOSE';
            leadCS.CustomState__c = 'CA';
            leadCS.Description = 'TEsting for all';
            update leadCS;

            //Creating Responses
            CC_Response__c ccRes = New CC_Response__c();
            ccRes.Name = leadCS.Name + System.Now();
            ccRes.Call_Script__c = leadCS.Campaign_Name__r.Call_Script__c;
            ccRes.Lead__c = leadCS.Id;
            ccRes.Campaign__c = leadCS.Campaign_Name__c;
            ccRes.Key_Code__c = leadCS.ProgramEvent__c;
            ccRes.Source_Event_Number__c = leadCS.Source_Event_Number__c;
            ccRes.Source_System_Name__c = 'NGCC';
            insert ccRes;

            //Creating Response Detail
            CC_Response_Detail__c newDetail = NGCC_CallScript_Data_Test.testNGCC_Call_Script_Response_Detail(ccCS, ccRes, ccCSQA);
            insert newDetail;
            
            //Begin Testing
            Test.startTest();

            Test.setCurrentPageReference(New PageReference('Page.NGCC_CallScript'));
            System.currentPageReference().getParameters().put('id', leadCS.Id);
            System.currentPageReference().getParameters().put('ResponseId', ccRes.Id);
            System.currentPageReference().getParameters().put('lang', 'en_US');

            ApexPages.Standardcontroller stdCtlCallScript = New ApexPages.StandardController(leadCS);
            NGCC_CallScript_CTE ccCallScript = new NGCC_CallScript_CTE(stdCtlCallScript);
            ccCallScript.getCreateDynamicComponent();

            //Testing the Call In Progress
            ccCallScript.responseObj.status__c = 'Call in Progress';
            ccCallScript.cmdSubmitCallScript();

            List < Apexpages.Message > msgsInProgress = ApexPages.getMessages();
            boolean bInProgress = false;
            for (Apexpages.Message msg: msgsInProgress) {
                if (msg.getDetail().contains('Please select Valid Disposition Value')) bInProgress = true;
            }
            //System.AssertEquals(true, bInProgress);

            //Testing the Call Back Status
            ccCallScript.responseObj.status__c = 'Call Back';
            
            
            ccCallScript.callBackTime = NULL;
            ccCallScript.cmdSubmitCallScript();
            

            List < Apexpages.Message > msgsCallBack = ApexPages.getMessages();
            boolean bCallBack = false;
            for (Apexpages.Message msg: msgsCallBack) {
                if (msg.getDetail().contains('Call Back')) bCallBack = true;
            }
            //System.AssertEquals(true, bCallBack);
            
            ccCallScript.callBackTime = System.Now() - 1;
            ccCallScript.cmdSubmitCallScript();
            
            List < Apexpages.Message > msgsCallBackPastDate = ApexPages.getMessages();
            boolean bCallBackPastDate = false;
            for (Apexpages.Message msg: msgsCallBackPastDate ) {
                if (msg.getDetail().contains('Call Back')) bCallBackPastDate = true;
            }
            //System.AssertEquals(true, bCallBackPastDate );


            //Tesing Refer a New Contact
            ccCallScript.responseObj.status__c = 'Refer a New Contact';
            PageReference ref = ccCallScript.cmdSubmitCallScript();
            boolean b = false;
           // if (ref.getUrl().contains('/apex/NGCC_MODS_SFDC_Contact_Search')) b = true;
            //System.AssertEquals(true, b);
            //StopTesting
            Test.stopTest();
        }

    }   
    
        public static testMethod void test_CallScript_Missing_Launch_Test() {

        Profile p = [SELECT Id FROM Profile WHERE Name Like '%NGCC'
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
            CC_Master_Question_Answer_Bank__c ccMQA = NGCC_CallScript_Data_Test.testNGCC_Call_Script_MasterQA('Number');
            insert ccMQA;
            
            List<RecordType> answerRec = [Select Id from RecordType where Name = 'Answer' Limit 1];
            
            CC_Question_Answer_Translations__c ccQATObj = new CC_Question_Answer_Translations__c();
            ccQATObj.CC_Master_Question_Answer_Bank__c = ccMQA.Id;
            ccQATObj.Language__c = 'English';
            ccQATObj.Language_Code__c = 'en_US';
            if(ccMQA.recordtypeId  != answerRec[0].Id)
            {
                ccQATObj.Translated_Value__c = ccMQA.Question_Text__c;    
            }else
            {
                ccQATObj.Translated_Value__c = ccMQA.Answer_Text__c;    
            }
            
            ccQATObj.MasterQuestionBankId__c = ccMQA.Id+ccQATObj.Language_Code__c;
            
            insert ccQATObj ;

            CC_Call_Script__c ccCS = NGCC_CallScript_Data_Test.test_Call_Script();
            CC_Call_Script_Q_A__c ccCSQA = NGCC_CallScript_Data_Test.testNGCC_Call_Script_Call_Script_QA(ccCS, ccMQA);
            insert ccCSQA;
            
            ccCSQA.Question_Type__c = '';
            update ccCSQA ;
            
            Lead leadCS = NGCC_CallScript_Data_Test.testLead();
            Campaign camCS = NGCC_CallScript_Data_Test.testCampaign();
            camCS.Call_Script__c = ccCS.Id;
            Update camCS;

            leadCS.Campaign_Name__c = camCS.Id;
            update leadCS;

            //Creating Responses
            CC_Response__c ccRes = New CC_Response__c();
            ccRes.Name = leadCS.Name + System.Now();
            ccRes.Call_Script__c = leadCS.Campaign_Name__r.Call_Script__c;
            ccRes.Lead__c = leadCS.Id;
            ccRes.Campaign__c = leadCS.Campaign_Name__c;
            ccRes.Key_Code__c = leadCS.ProgramEvent__c;
            ccRes.Source_Event_Number__c = leadCS.Source_Event_Number__c;
            ccRes.Source_System_Name__c = 'NGCC';
            insert ccRes;

            //Creating Response Detail
            CC_Response_Detail__c newDetail = NGCC_CallScript_Data_Test.testNGCC_Call_Script_Response_Detail(ccCS, ccRes, ccCSQA);
            insert newDetail;

            //Begin Testing
            Test.startTest();

            Test.setCurrentPageReference(New PageReference('Page.NGCC_CallScript'));
            System.currentPageReference().getParameters().put('id', leadCS.Id);
            System.currentPageReference().getParameters().put('ResponseId', ccRes.Id);
            System.currentPageReference().getParameters().put('lang', 'en_US');

            ApexPages.Standardcontroller stdCtlCallScript = New ApexPages.StandardController(leadCS);
            NGCC_CallScript_CTE ccCallScript = new NGCC_CallScript_CTE(stdCtlCallScript);
            ccCallScript.getCreateDynamicComponent();
			ccCallScript.validateValues(newDetail);
        }
        Test.stopTest();
    }


}