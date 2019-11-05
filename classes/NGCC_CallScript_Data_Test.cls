@isTest(SeeAllData=true)
public class NGCC_CallScript_Data_Test{
    
    // Creating Lead
    public static Lead testLead(){
        ObjectRecordTypeIds__c orgConstant = ObjectRecordTypeIds__c.getInstance(); 
        Id marketingRecId = orgConstant.Marketing_Lead_RecordType__c;
                   
        Lead l1 = new Lead(firstName='Test Call Script',
                            LastName ='Testing', 
                            RECORDTYPEID=marketingRecId,
                            company='Test End-User Account',
                            customCountry__c = 'UNITED STATES',
                            Status='New Prospect',
                            email='test@test.com.qtr');
        insert l1;
        
        return l1;
        
    }
    
    // Multiple Leads
    public static List<Lead> testMultipleLead(){
        List<Lead> lstLead = new List<Lead>();
        ObjectRecordTypeIds__c orgConstant = ObjectRecordTypeIds__c.getInstance(); 
        Id marketingRecId = orgConstant.Marketing_Lead_RecordType__c;
        
        Campaign c= new Campaign(Name='Campaign1',Program_Event_Name__c='ProgramEvent',Program_Event_Code__c='6505561241',Program_Originating_Country__c='UNITED STATES');
            insert c;
        
        
        User uSMR = NGCC_CallScript_Data_Test.testSDRUser('sdr0@cisco.com.reg');
        
        
        for (integer i = 0; i < 5; i++) {                       
                Lead l1 = new Lead(firstName='Test Call Script',
                            LastName ='Testing', 
                            RECORDTYPEID=marketingRecId,
                            company='Test End-User Account',
                            campaign_name__c = c.Id,
                            customCountry__c = 'UNITED STATES',                            
                            email='test@test.com.qtr');
                lstLead.add(l1);
            }    
        
       
        return lstLead ;
        
    }
    
    // Creating Call Script
    public static CC_Call_Script__c test_Call_Script() {
        CC_Call_Script__c testCallScript= new CC_Call_Script__c();
        testCallScript.Name = 'Testing Call Script';
        testCallScript.Status__c = 'Draft';
        testCallScript.Theater__c = 'Americas';
        
        insert testCallScript;               
        return testCallScript;
    }
    
    // Creating Campaign
    public static Campaign testCampaign(){
        Campaign  camp = new Campaign(Name='Testing Campaign',
                            Program_Event_Name__c = 'Program_Event_Name__c',
                            Offer_Description__c = 'Offer_Description__c',
                            Offer_URL__c = 'Offer_URL__c',
                            Primary_Technology__c = 'Primary_Technology__c',
                            Campaign_Code__c = 'Campaign_Code__c',
                            Description = 'Campaign_Description__c',
                            Program_Event_Description__c = 'Program_Event_Description__c',
                            Offer_Name__c = 'Offer_Name__c',
                            Offer_Architecture__c = 'Offer_Architecture__c'

        );
        insert camp;
        return camp;
    }
    
    // Creating Answers
    public static List<CC_Master_Question_Answer_Bank__c> test_CC_Master_Answer() {
        List<CC_Master_Question_Answer_Bank__c> testMasterAns = new List<CC_Master_Question_Answer_Bank__c>();
        
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.CC_Master_Question_Answer_Bank__c; 
        Map<String,Schema.RecordTypeInfo> masterQARecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        
        List<sObject> ls = Test.loadData(CC_Master_Question_Answer_Bank__c.sObjectType, 'NGCC_Master_Answer');
        
        for(sObject sObjQA : ls)
        {
            CC_Master_Question_Answer_Bank__c csMQA = (CC_Master_Question_Answer_Bank__c)sObjQA ;
            csMQA.RecordTypeId = masterQARecordTypeInfo.get('Answer').getRecordTypeId();
            testMasterAns.add(csMQA);
        }
        update testMasterAns ;
        
        return testMasterAns ;
    }
    
    /************************************************************* Creating Single Master Question Answer ***********************************/
    public static CC_Master_Question_Answer_Bank__c testNGCC_Call_Script_MasterQA(String dataType){
    
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.CC_Master_Question_Answer_Bank__c; 
        Map<String,Schema.RecordTypeInfo> masterQARecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id recId = masterQARecordTypeInfo.get('Question').getRecordTypeId();
        List<CC_Master_Question_Answer_Bank__c> testMasterAnswer = test_CC_Master_Answer();

        
        CC_Master_Question_Answer_Bank__c ccMQA = new CC_Master_Question_Answer_Bank__c();
        ccMQA.Name = 'Sample Question';
        ccMQA.MODS_Question_Answer_Code__c = 'Sample Question';
        ccMQA.Question_Category__c = '1:Account Information';
        ccMQA.Question_Text__c = 'This is the Sample Question';
        ccMQA.Question_Type__c = dataType;
        ccMQA.RecordTypeId = recId;
        if(dataType == 'Picklist')
        {
            string strAnswerIds = '';
            for(Integer i=1;i<10;i++)
            {
                strAnswerIds = strAnswerIds+i+':'+testMasterAnswer[i].Id+',';
            }
            ccMQA.Answer_Options_Id__c = strAnswerIds;
        }else if(dataType == 'Radio')
            {
                string strAnswerIds = '';
                for(Integer i=11;i<14;i++)
                {
                    strAnswerIds = strAnswerIds+i+':'+testMasterAnswer[i].Id+',';
                }
                ccMQA.Answer_Options_Id__c = strAnswerIds;
        }else if(dataType == 'MultiSelect')
            {
                string strAnswerIds = '';
                for(Integer i=15;i<30;i++)
                {
                    strAnswerIds = strAnswerIds+i+':'+testMasterAnswer[i].Id+',';
                }
                ccMQA.Answer_Options_Id__c = strAnswerIds;
            }
        return   ccMQA;
    }
    
    /************************************************************* Creating Call Script Q&A ****************************************************/
    public static CC_Call_Script_Q_A__c  testNGCC_Call_Script_Call_Script_QA(CC_Call_Script__c callScriptObj, CC_Master_Question_Answer_Bank__c ccMQA){
         CC_Call_Script_Q_A__c ccCSQA = new CC_Call_Script_Q_A__c();        
            ccCSQA.Call_Script__c = callScriptObj.Id;
            ccCSQA.CC_Master_Question_Bank__c = ccMQA.Id;
            ccCSQA.Question_Text__c = ccMQA.Question_Text__c ;
            ccCSQA.Question_Type__c = ccMQA.Question_Type__c ;
            ccCSQA.Question_Category__c = ccMQA.Question_Category__c;
            ccCSQA.Answer_Options__c = ccMQA.Answer_Options_Id__c; 
            
            if(ccMQA.Question_Type__c == 'Number')
            {
                ccCSQA.Minimum_If_Number_Validation__c = 1;
                ccCSQA.Maximum_If_Number_Validation__c = 100;
                ccCSQA.Validation_Both_Conditional_or_Required__c = true;
            }else if(ccMQA.Question_Type__c == 'Text')
            {
                ccCSQA.Required__c = true;
                ccCSQA.Validation_Both_Conditional_or_Required__c = true;
                ccCSQA.Required_on_Lead_Description__c = true;
            }        
            return ccCSQA;
    }   
    
    /************************************************************* Creating Single Response Detail ***********************************/
    public static CC_Response_Detail__c testNGCC_Call_Script_Response_Detail(CC_Call_Script__c cSObj,CC_Response__c ccRes,CC_Call_Script_Q_A__c ccCSQA){
        CC_Response_Detail__c newDetail = new CC_Response_Detail__c();
            
            newDetail.Name = ccCSQA.Name;
                        
            newDetail.CC_Master_Question_Answer_Bank__c = ccCSQA.CC_Master_Question_Bank__c;            
            newDetail.Question_Category__c = ccCSQA.Question_Category__c;
            newDetail.Question_Text__c =  ccCSQA.Question_Text__c ;
            newDetail.Question_Type__c  = ccCSQA.Question_Type__c  ;
            newDetail.Answer_Options_Id__c = ccCSQA.Answer_Options__c;
            system.debug('llllllllllllllll'+newDetail.Answer_Options_Id__c);
            newDetail.Question_Category__c = ccCSQA.Question_Category__c;
            newDetail.Sequence__c = ccCSQA.Sequence__c;

            newDetail.Validation_Both_Conditional_or_Required__c = ccCSQA.Validation_Both_Conditional_or_Required__c;            
            newDetail.Required__c = true;
            newDetail.Required_on_Lead_Description__c = ccCSQA.Required_on_Lead_Description__c;
            
            newDetail.Minimum_If_Number_Validation__c = ccCSQA.Minimum_If_Number_Validation__c ;
            newDetail.Maximum_If_Number_Validation__c = ccCSQA.Maximum_If_Number_Validation__c;

            newDetail.Conditionaly_Required_If__c = ccCSQA.Conditionaly_Required_If__c;
            newDetail.Question_Required__c = ccCSQA.Question_Required__c;
            newDetail.Conditionally_Required_Criteria__c = ccCSQA.Conditionally_Required_Criteria__c;
            newDetail.Help_Text__c = ccCSQA.Help_Text__c;
            
            newDetail.Call_Script__c = cSObj.Id;
            newDetail.Response_Id__c = ccRes.Id;
            
            
            if(ccCSQA.Question_Type__c == 'Number')
            {
                newDetail.Customer_Response__c = '200';
            }else if(ccCSQA.Question_Type__c == 'Picklist')
            {
                List < String > strNewValue = new List < String > (ccCSQA.Answer_Options__c.split(','));
                newDetail.Customer_Response__c = Id.valueOf(strNewValue[0].subString(strNewValue[0].indexOf(':')+1,strNewValue[0].length()));
            }else if(ccCSQA.Question_Type__c == 'MultiSelect')
            {
                newDetail.Customer_Response__c = ccCSQA.Answer_Options__c;
            }
            
            return newDetail ;
    }
    
    
    /******************************************************** Bulk Testing  for Call Script*******************************************************/
    public static List<CC_Master_Question_Answer_Bank__c> test_CC_Master_Question() {
        List<CC_Master_Question_Answer_Bank__c> testMasterQues= new List<CC_Master_Question_Answer_Bank__c>();
        List<CC_Master_Question_Answer_Bank__c> testMasterAnswer = test_CC_Master_Answer();
        
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.CC_Master_Question_Answer_Bank__c; 
        Map<String,Schema.RecordTypeInfo> masterQARecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        
        List<sObject> ls = Test.loadData(CC_Master_Question_Answer_Bank__c.sObjectType, 'NGCC_Master_Question');
        
        for(sObject sObjQA : ls)
        {
            CC_Master_Question_Answer_Bank__c csMQA = (CC_Master_Question_Answer_Bank__c)sObjQA;
            csMQA.RecordTypeId = masterQARecordTypeInfo.get('Question').getRecordTypeId();
            if(csMQA.Question_Type__c == 'Picklist')
            {
                string strAnswerIds = '';
                for(Integer i=1;i<10;i++)
                {
                    strAnswerIds = strAnswerIds+i+':'+testMasterAnswer[i].Id+',';
                }
                csMQA.Answer_Options_Id__c = strAnswerIds;
            }else if(csMQA.Question_Type__c == 'Radio')
            {
                string strAnswerIds = '';
                for(Integer i=11;i<14;i++)
                {
                    strAnswerIds = strAnswerIds+i+':'+testMasterAnswer[i].Id+',';
                }
                csMQA.Answer_Options_Id__c = strAnswerIds;
            }else if(csMQA.Question_Type__c == 'MultiSelect')
            {
                string strAnswerIds = '';
                for(Integer i=15;i<30;i++)
                {
                    strAnswerIds = strAnswerIds+i+':'+testMasterAnswer[i].Id+',';
                }
                csMQA.Answer_Options_Id__c = strAnswerIds;
            }
            testMasterQues.add(csMQA);
        }
        
        update testMasterQues;
        system.debug('qqqqqqq'+testMasterQues);
        system.debug('aaaaaaaaaaaaaaaaaa'+testMasterAnswer);
        return testMasterQues;
    }
    
    public static List<CC_Call_Script_Q_A__c> testCall_Script_QA(){
        CC_Call_Script__c testCallScript = test_Call_Script();
        List<CC_Master_Question_Answer_Bank__c > ccMasterQA = test_CC_Master_Question();
        List<RecordType> answerRec = [Select Id from RecordType where Name = 'Answer' Limit 1];
        List<CC_Question_Answer_Translations__c > lstNewQATrans= new List<CC_Question_Answer_Translations__c >();
        for(CC_Master_Question_Answer_Bank__c cMQA: ccMasterQA ){

            
            CC_Question_Answer_Translations__c ccQATObj = new CC_Question_Answer_Translations__c();
            ccQATObj.CC_Master_Question_Answer_Bank__c = cMQA.Id;
            ccQATObj.Language__c = 'English';
            ccQATObj.Language_Code__c = 'en_US';
            if(cMQA.recordtypeId  != answerRec[0].Id)
            {
                ccQATObj.Translated_Value__c = cMQA.Question_Text__c;    
            }else
            {
                ccQATObj.Translated_Value__c = cMQA.Answer_Text__c;    
            }
            
            ccQATObj.MasterQuestionBankId__c = cMQA.Id+ccQATObj.Language_Code__c;
        
            lstNewQATrans.add(ccQATObj);
        }
        
        insert lstNewQATrans;
        
        
        List<CC_Call_Script_Q_A__c> ccCSQA = new List<CC_Call_Script_Q_A__c>();
        
        for(CC_Master_Question_Answer_Bank__c ccMQA: ccMasterQA)
        {
            CC_Call_Script_Q_A__c csQAObj = new CC_Call_Script_Q_A__c();
            csQAObj.Call_Script__c = testCallScript.Id;
            csQAObj.CC_Master_Question_Bank__c = ccMQA.Id;
            csQAObj.Question_Text__c = ccMQA.Question_Text__c ;
            csQAObj.Question_Type__c = ccMQA.Question_Type__c ;
            if(csQAObj.Question_Type__c == 'Text')
            {
                csQAObj.Required__c = true;
                csQAObj.Validation_Both_Conditional_or_Required__c = true;
                csQAObj.Required_on_Lead_Description__c = true;                
            }
            csQAObj.Local_to_SFDC__c = ccMQA.Local_to_SFDC__c;
            csQAObj.Answer_Options__c = ccMQA.Answer_Options_Id__c;
            csQAObj.Question_Category__c = ccMQA.Question_Category__c;
            ccCSQA.add(csQAObj);
        }
        
        insert ccCSQA;
        system.debug('kkkkkkkkkkkkkkkk'+ccCSQA);
        return ccCSQA;
    }
    
    public static User testSDRUser(String uName){
        Profile p = [SELECT Id FROM Profile WHERE Name Like '%NGCC'
            Limit 1
        ];
        
        UserRole rSDR = [SELECT Id FROM UserRole WHERE Name Like '%SDR Alea (Canada)%'
            Limit 1
        ];
        
        User uSDR = new User(Alias = uName.substring(0,4), Email = uName,
            EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p.Id, UserRoleId = rSDR.id,Marketing_Call_Center__c = 'Alea Canada',
            TimeZoneSidKey = 'America/Los_Angeles', UserName = uName, Theatre__c = 'Americas-US Commercial');
        
        return uSDR;
    }
    
    public static User testSMUser(){
        Profile p = [SELECT Id FROM Profile WHERE Name Like '%NGCC'
            Limit 1
        ];
        
        UserRole rSM = [SELECT Id FROM UserRole WHERE Name Like '%Site Manager Alea (Canada)%'
            Limit 1
        ];
        
        User uSM = new User(Alias = 'newUser', Email = 'newuserSM@cisco.com.reg',
            EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p.Id, UserRoleId = rSM.id,Marketing_Call_Center__c = 'Alea Canada',
            TimeZoneSidKey = 'America/Los_Angeles', UserName = 'newuserSM@cisco.com.reg', Theatre__c = 'Americas-US Commercial');
        
        return uSM;
    }
    
    
}