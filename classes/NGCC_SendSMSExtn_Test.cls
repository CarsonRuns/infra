/*********************************************************************************************************
Name    : NGCC_SendSMSExtn_Test
Author  : Ghattamaneni Chaithanya
Purpose : This is the test Class for the class NGCC_SendSMSExtn
Created Date: 29 Jan 2018
Modification History: 

*********************************************************************************************************/
@isTest
public class NGCC_SendSMSExtn_Test {
    @testSetup static void leadDataSetup() {        
        //Create Test Lead
        string recordtype = Schema.Sobjecttype.Lead.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();  
        ObjectRecordTypeIds__c o = new ObjectRecordTypeIds__c();
        o.Manual_Lead_RecordTypeId__c = recordtype.subString(0,15);
        o.eLeadsRecordTypeId__c = recordtype.subString(0,15);
        o.Partner_Generated_Lead_RecordTypeId__c = recordtype.subString(0,15);
        insert o;
        Lead newLead = new Lead();
        newLead.LastName = 'TestleadSMS1';
        newLead.RecordTypeId = recordtype;
        newLead.Company = '123';
        newLead.Status = 'New Prospect';
        newLead.LeadSource = 'Web';
        newLead.CustomCountry__c = 'UNITED STATES';
        newLead.DeduperProcessing__c = true;
        insert newLead;
    }
    public static testmethod void updateLeadTest(){
        Lead testLead = [SELECT Id,MobilePhone FROM Lead WHERE Name='TestleadSMS1' LIMIT 1];
        test.startTest();
        ApexPages.StandardController sc = new ApexPages.standardController(testLead);
        NGCC_SendSMSExtn sendSMSExt = new NGCC_SendSMSExtn(sc);
        NGCC_SendSMSExtn.updatelead(testLead.id, '+1123456789');
        lead l = [select id,MobilePhone from lead where id =:testLead.id];
        test.stopTest();
        system.assertEquals('+1123456789',l.MobilePhone);
    }        
    public static testmethod void sendtestPositive(){
        Test.setMock(HttpCalloutMock.class, new NGCC_MockHttpResponseGenerator());
        NGCC_NaaS_Credentials__c userdetails = new NGCC_NaaS_Credentials__c();
        userdetails.name = 'NaaS Integration User';
        userdetails.Username__c = 'testUser';
        userdetails.Password__c =  'testPassword';
        insert userdetails;
        list<NGCC_Nass_SMS_Endpoints__c> EndPoints = new list<NGCC_Nass_SMS_Endpoints__c>();
        NGCC_Nass_SMS_Endpoints__c NaasEndpoint = new NGCC_Nass_SMS_Endpoints__c();
        NaasEndpoint.name = 'NaasURL';
        NaasEndpoint.EndpointUrl__c  = 'https://naasapi.cisco.com/rest/message'; 
        EndPoints.add(NaasEndpoint);
        insert EndPoints;
        Lead testLead = [SELECT Id,MobilePhone FROM Lead WHERE Name='TestleadSMS1' LIMIT 1];
        test.startTest();
        ApexPages.StandardController sc = new ApexPages.standardController(testLead);
        NGCC_SendSMSExtn sendSMSExt = new NGCC_SendSMSExtn(sc);
        string response =  NGCC_SendSMSExtn.Send('+911234567890','TestSMS',testLead.id);
        test.stopTest();
        system.assertEquals('200', response);
    } 
    public static testmethod void Sendtestexception(){
        Test.setMock(HttpCalloutMock.class, new NGCC_MockHttpResponseGenerator());
        list<NGCC_Nass_SMS_Endpoints__c> EndPoints = new list<NGCC_Nass_SMS_Endpoints__c>();
        NGCC_Nass_SMS_Endpoints__c NaasEndpoint = new NGCC_Nass_SMS_Endpoints__c();
        NaasEndpoint.name = 'NaasURL';
        NaasEndpoint.EndpointUrl__c  = 'https://naasapi.cisco.com/rest/message'; 
        EndPoints.add(NaasEndpoint);
        insert EndPoints;
        Lead testLead = [SELECT Id,MobilePhone FROM Lead WHERE Name='TestleadSMS1' LIMIT 1];
        User u = [select id from user where profile.name ='Cisco_ADMIN' and id!=:userinfo.getUserId() limit 1];
        
        ApexPages.StandardController sc = new ApexPages.standardController(testLead);
        NGCC_SendSMSExtn sendSMSExt = new NGCC_SendSMSExtn(sc);
        NGCC_SMS_History__c smsHis = new NGCC_SMS_History__c();
        smsHis.name__c = 'message 1';
        smsHis.Lead__c = testLead.id;
        smsHis.Sent_By__c = userinfo.getUserId();
        smsHis.Sent_Date__c = system.now();
        smsHis.Phone__c = testLead.MobilePhone;
        system.runAs(u){
            insert smsHis;
        }
        test.startTest();
        string response =  NGCC_SendSMSExtn.Send('+911234567890','TestSMS',testLead.id);
        test.stopTest();
       // system.assertEquals('\nInvalid Username or Password,please check "NGCC NaaS Credentials" Custom Settings.', response);
    }
    public static testmethod void SendtestexceptionforEndpoint(){
        Test.setMock(HttpCalloutMock.class, new NGCC_MockHttpResponseGenerator());
        Lead testLead = [SELECT Id,MobilePhone FROM Lead WHERE Name='TestleadSMS1' LIMIT 1];
        test.startTest();
        ApexPages.StandardController sc = new ApexPages.standardController(testLead);
        NGCC_SendSMSExtn sendSMSExt = new NGCC_SendSMSExtn(sc);
        string response =  NGCC_SendSMSExtn.Send('+911234567890','TestSMS',testLead.id);
        test.stopTest();
        system.assertEquals('error Argument 1 cannot be null', response);
    }
}