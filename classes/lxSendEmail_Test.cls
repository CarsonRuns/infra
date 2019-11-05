/*
Author          : Shivi Srivastava
Release         : March 29, 2019 Release
Created         : March 26, 2019
Functionality   : lxSendEmail Test Class


Modification History:
Itrack#        Date        Author              Change  
*/
@isTest(seealldata=true)
public class lxSendEmail_Test {
    
    static testMethod void setup(){
        User admin = CEE_TestUtility.getUser('admin', true);
        system.Runas(admin) {
            
            /*List<Org_Constant_CS__c> OrgCSlist = new List<Org_Constant_CS__c>();
            Org_Constant_CS__c orgCS = new Org_Constant_CS__c();
            orgCS.Name = 'OrgWideAddress';
            orgCS.Production_Value__c = '[{"id":"0D2800000004DKj","Name":"Cisco Case Admin","Email":"cisco_sales_case_management@external.cisco.com"}]';
            orgCS.Non_Production_Value__c = '[{"id":"0D2800000004DKj","Name":"Cisco Case Admin","Email":"cisco_sales_case_management@external.cisco.com"}]';
            
            Org_Constant_CS__c orgCS1 = new Org_Constant_CS__c();
            orgCS1.Name = 'CiscoSalesCases';
            orgCS1.Production_Value__c = '12dssss';
            orgCS1.Non_Production_Value__c = '12eeess';
            
            OrgCSlist.add(orgCS);
            OrgCSlist.add(orgCS1);
            if(Utilities.getConstant_CS('OrgWideAddress')==null){
                
                insert orgCSlist;
            }
*/
            /*Case cse=new Case();
cse.Contact_Type__c='Cisco';
cse.Subject ='Test';
cse.Service_Type__c='Cisco BoM';
cse.Architecture__c='xyz';
cse.Technology__c='xyz';
cse.Status='New';
cse.Assigned_SLA__c='def';
cse.Requested_Due_Date__c =Date.newInstance(2019, 12, 9);
cse.Team__c = 'ksjdks';
cse.Origin='SFDC';
cse.Country__c ='sdfe';
cse.Description='Test';
insert cse;

EmailTemplate e = new EmailTemplate (developerName = 'test', FolderId = UserInfo.getUserId(), TemplateType= 'Text', Name = 'GVE'); 
insert e;

Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('End-User').getRecordTypeId();*/
            /*Account acc = [Select id from Account limit 1];
Contact con= new Contact(LastName='Test', AccountId=acc.id);
insert con;
*/
            
        }
        Case ce=[Select id from Case limit 1];
        String caseId=String.valueOf(ce.id);
        EmailTemplate et=[Select id from EmailTemplate where Name like '%GVE%' limit 1];
        String et1= String.valueOf(et.id);
        Contact co=[Select id from Contact where Email!='' limit 1];
        String co1=String.valueOf(co.id);
        List<String> cStr=new List<String>();
        cStr.add(co1);
        
        EmailMessage se=[Select id from EmailMessage limit 1];
        List<ContentVersion> cv=[Select Title,FileExtension,VersionData from ContentVersion limit 1];
        
        String myString = 'StringToBlob';
        Blob myBlob = Blob.valueof(myString);
        String attach = '[{'+
            '                    \"id\": \"23444\",'+
            '                    \"Name\": \"eudatamanager\",'+
            '                    \"Email\": \"atm@xyz.com\",'+
            '                    \"Title\": \"xyz\",' +
            '                \"VersionData\":\"xyz\"' +
            '                }]';
        //String objectStr = 'xyz@abc.com';
        
        String mapCreate='{'+
            '                    \"To\": \"xyz@abc.com\",'+
            '                    \"addCC\": \"xyz@abc.com\",'+
            '                    \"addBCC\":\"xyz@abc.com\",'+
            '                    \"Case\": \"'+caseId+'\"'+
            '                }';
        
        Map<String,Object> m=(Map<String,Object>)JSON.deserializeUntyped(mapCreate);
        //System.debug(mapCreate);
        Map<String,Object>values=new Map<String,Object>();
        List<Object> str=new List<object>();
        str.add(m.get('To'));
        values.put('To',str);
        values.put('addCC',str);
        values.put('addBCC',str);
        values.put('Case',m.get('Case'));
        System.debug(values);
        EmailTemplate eTemp = [SELECT Id,HTMLValue,Name FROM EmailTemplate limit 1];
        
        List<Messaging.SingleEmailMessage> mails= new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = cStr;
        message.optOutPolicy = 'FILTER';
        message.subject = 'Opt Out Test Message';
        message.plainTextBody = 'This is the message body.';
        mails.add(message);
        List <String> returnList=new List<String>();
        
        returnList.add(message.getSubject());
        returnList.add(message.getHtmlBody());
        //lxSendEmail.insertAttachment mtr= new lxSendEmail.insertAttachment(se.id,cv);
        Test.startTest();
        lxSendEmail.fetchFromValues();
        lxSendEmail.fetchAttachments('abc');
        lxSendEmail.setEmailBody(et1,caseId,co1);
        lxSendEmail.setEmailBody(eTemp.Id,caseId,co1);
        lxSendEmail.getCaseUserInfo(caseId);
        lxSendEmail.sendEmail(values,attach,et1,caseId,co1);
        lxSendEmail.insertMailRecord(values,returnList,cv,mails);
        Test.stopTest();
    }
}