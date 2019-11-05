/* 
 * NGCC_Update_Lead_Attributes_Test is a test class that tests the NGCC_Update_Lead_Attributes class
 * @author: Daniel Pisciottano
 * @created date: March 28, 2014
*/ 
@isTest(SeeAllData=true) 
private class NGCC_Update_Lead_Attributes_Test {
    private static String leadRecordTypeId = ObjectRecordTypeIds__c.getInstance().Marketing_Lead_RecordType__c;
    private static Lead testLead = new Lead();
    private static CC_Response__c testResponse = new CC_Response__c();
    private static CC_Response_Detail__c testResponseDetail1 = new CC_Response_Detail__c();
    private static CC_Response_Detail__c testResponseDetail2 = new CC_Response_Detail__c();
    private static CC_Response_Detail__c testResponseDetail3 = new CC_Response_Detail__c();
    private static CC_Response_Detail__c testResponseDetail4 = new CC_Response_Detail__c();
    private static CC_Response_Detail__c testResponseDetail5 = new CC_Response_Detail__c();
    private static CC_Response_Detail__c testResponseDetail6 = new CC_Response_Detail__c();
    private static List<CC_Response_Detail__c> testResponseDetailList = new List<CC_Response_Detail__c>();
    private static CC_Master_Question_Answer_Bank__c testQABank1 = new CC_Master_Question_Answer_Bank__c();
    private static CC_Master_Question_Answer_Bank__c testQABank2 = new CC_Master_Question_Answer_Bank__c();
    private static CC_Master_Question_Answer_Bank__c testQABank3 = new CC_Master_Question_Answer_Bank__c();
    private static CC_Master_Question_Answer_Bank__c testQABank4 = new CC_Master_Question_Answer_Bank__c();
    private static CC_Master_Question_Answer_Bank__c testQABank5 = new CC_Master_Question_Answer_Bank__c();
    private static CC_Master_Question_Answer_Bank__c testQABank6 = new CC_Master_Question_Answer_Bank__c();
    private static List<CC_Master_Question_Answer_Bank__c> testQABankList = new List<CC_Master_Question_Answer_Bank__c>();
    
    /* Method that creates a test Lead object */
    static void initializeLead(){
        testLead.RecordTypeId = leadRecordTypeId;
        testLead.FirstName = 'John';
        testLead.LastName = 'Doe';
        testLead.Title = 'Engineer';
        testLead.Contact_Department__c = 'Engineering';
        testLead.Phone = '(123) 123-4567';
        testLead.Call_Permission__c = 'Yes';
        testLead.Email = 'test@test.com';
        testLead.Preferred_Language__c = 'English: en_US';
        testLead.Company = 'Dummy Company';
        testLead.Address_Line_1__c = '123 Main Street';
        testLead.Address_Line_2__c = 'Suite 123';
        testLead.Address_Line_3__c = '';
        testLead.CustomCity__c = 'Some City';
        testLead.CustomState__c = 'Some State';
        testLead.CustomCountry__c = 'United States';
        testLead.CustomZip__c = '12345';
        testLead.Project_Flag__c = 'Yes';
        testLead.QATimeFrame__c = 'Unknown';
        testLead.QABudget__c = 'Budget amount not fixed';
        testLead.Main_Technology__c = 'Computers';
        testLead.QAPartner__c = 'Tech Company #2';
        testLead.ProductAmount__c = 10000;
        testLead.ServicesAmount__c = 11;

        INSERT testLead;
    }
    static void initializeQABank(){
        testQABank1.MODS_Question_Answer_Code__c= 'First_Name_FF_V1';
        testQABank1.Name = 'First_Name_FF_V1';
        testQABankList.add(testQABank1);

        testQABank2.MODS_Question_Answer_Code__c = 'Last_Name_FF_V1';
        testQABank2.Name = 'Last_Name_FF_V1';
        testQABankList.add(testQABank2);

        testQABank3.MODS_Question_Answer_Code__c = 'Job_Title_FF_V1';
        testQABank3.Name = 'Job_Title_FF_V1';
        testQABankList.add(testQABank3);

        testQABank4.MODS_Question_Answer_Code__c = 'Contact_Site_City_FF_V1';
        testQABank4.Name = 'Contact_Site_City_FF_V1';
        testQABankList.add(testQABank4);
        
        testQABank5.MODS_Question_Answer_Code__c = 'ESTIMATED_PRODUCT_VALUE_SFDC';
        testQABank5.Name = 'ESTIMATED_PRODUCT_VALUE_SFDC';
        testQABank5.Question_Type__c ='Number';
        testQABankList.add(testQABank5);
        
        testQABank6.MODS_Question_Answer_Code__c = 'APPOINTMENT_DATE_TIME_SFDC';
        testQABank6.Name = 'APPOINTMENT_DATE_TIME_SFDC';
        testQABank6.Question_Type__c ='DateTime';
        testQABankList.add(testQABank6);
        
        INSERT testQABankList;
    }

    /* Method initializes response object and corresponding detail objects */
    static void initializeResponse(){
        testResponse.Lead__c = testLead.Id;
        testResponse.Status__c = 'Qualified Lead';
        INSERT testResponse;

        testResponseDetailList.clear();
        testResponseDetail1.Response_Id__c = testResponse.Id;
        testResponseDetail1.CC_Master_Question_Answer_Bank__c = testQABank1.Id;
        testResponseDetail1.Customer_Response_Detail__c = 'Joe';
        testResponseDetailList.add(testResponseDetail1);
        
        testResponseDetail2.Response_Id__c = testResponse.Id;
        testResponseDetail2.CC_Master_Question_Answer_Bank__c = testQABank2.Id;
        testResponseDetail2.Customer_Response_Detail__c = 'Shmoe';
        testResponseDetailList.add(testResponseDetail2);
        
        testResponseDetail3.Response_Id__c = testResponse.Id;
        testResponseDetail3.CC_Master_Question_Answer_Bank__c = testQABank3.Id;
        testResponseDetail3.Customer_Response_Detail__c = 'Engineer Lead';
        testResponseDetailList.add(testResponseDetail3);
        
        testResponseDetail4.Response_Id__c = testResponse.Id;
        testResponseDetail4.CC_Master_Question_Answer_Bank__c = testQABank4.Id;
        testResponseDetail4.Customer_Response_Detail__c = 'Another City';
        testResponseDetailList.add(testResponseDetail4);
        
        Double varEst = 9999;
        string varStrEst = string.valueof(varEst);
        testResponseDetail5.Response_Id__c = testResponse.Id;
        testResponseDetail5.CC_Master_Question_Answer_Bank__c = testQABank5.Id;
        testResponseDetail5.Customer_Response_Detail__c = varStrEst ;
        testResponseDetail5.Customer_Response__c = varStrEst;
        testResponseDetailList.add(testResponseDetail5);
        
        testResponseDetail6.Response_Id__c = testResponse.Id;
        testResponseDetail6.CC_Master_Question_Answer_Bank__c = testQABank6.Id;
        testResponseDetail6.Customer_Response_Detail__c = '9/25/2014 3:47 PM';
        testResponseDetailList.add(testResponseDetail6);
        
                
        INSERT testResponseDetailList;
    }
    
    /* Method that updates the testResponse object with a call status of nurture which should not allow for further processing */
    static void initializeDataStatusNurture(){
        testResponse.Call_Back_Time__c = System.now() + 200;
        testResponse.Status__c = 'Call Back';
        testResponse.Call_Status__c = 'Call Back Later';
        UPDATE testResponse;
    }
    
    /* Method that updates the testResponse object with a call status of call completed which should allow for further processing */
    static void initializeDataStatusContacted(){
        testResponse.Call_Status__c = 'Call Completed';
        testResponse.Call_Script_Completed__c = True;
        UPDATE testResponse;
    }
    
    /* Method that updates the testResponse object with a call status of call completed which should allow for further processing */
    static void initializeCSContacted(){
        testResponse.Call_Status__c = 'Call Completed';
        testResponse.Status__c = 'Qualified Lead';
        testResponse.Call_Script_Completed__c = True;
        UPDATE testResponse;
    }
    
    /* Main test method */
    static testMethod void UpdateLeadAttributesTest(){
        initializeQABank();
        initializeLead();
        initializeResponse();
        system.debug('testResponseDetailList'+testResponseDetailList);
        
        Test.startTest();
        
        System.Debug('Lead Initialized');
        Lead l = [SELECT Id, FirstName, LastName, Title, CustomCity__c FROM Lead WHERE Lead.Id = :testLead.Id];
        System.Debug(l);
        
        initializeDataStatusNurture();

        System.Debug('Lead After Call Status Nurture');

        l = [SELECT Id, FirstName, LastName, Title, CustomCity__c FROM Lead WHERE Lead.Id = :testLead.Id];
        System.Debug(l);
        
        initializeDataStatusContacted();
        
        System.Debug('Lead After Call Status Call Completed');
        
        Lead lt = [SELECT Id,ProductAmount__c,ServicesAmount__c FROM Lead WHERE Lead.Id = :testLead.Id];
        System.Debug(lt);
        
        testResponseDetailList[4].Customer_Response_Detail__c = NULL;
        testResponseDetailList[4].Customer_Response__c = NULL;
        testResponseDetailList[5].Customer_Response_Detail__c = NULL;
        testResponseDetailList[5].Customer_Response__c = NULL;
        update testResponseDetailList;
        initializeCSContacted();
        
        testResponseDetailList[0].Customer_Response_Detail__c = 'This is not valid scenario so that trigger to update the lead';
        testResponseDetailList[0].Customer_Response__c = 'This is not valid scenario so that trigger to update the lead';
        update testResponseDetailList;
        initializeCSContacted();
        
        Test.stopTest();
    }
    // added by gchaitha to increase code coverage
    public static testmethod void additionalmethod(){
        NGCC_Update_Lead_Attributes.flsUpdateGet(lead.Outcome__c);
    }     
}