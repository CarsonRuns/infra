@isTest(SeeAllData = true)
public class NGCC_Lead_Management_Test {
    
    public static testMethod void NGCC_Lead_Management_CampaignTest() {
        List < Lead > lstLead = new List < Lead > ();
        
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.NGCC_Mapping_Object__c ; 
        Map<String,Schema.RecordTypeInfo> mappingRecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id ccRecId = mappingRecordTypeInfo.get('Call Center').getRecordTypeId();
        Id ccCountry_Mapping = mappingRecordTypeInfo.get('Country Mapping').getRecordTypeId(); 
        
        
        User uSMgr = NGCC_CallScript_Data_Test.testSMUser();
        User uSDR = NGCC_CallScript_Data_Test.testSDRUser('sdr8@cisco.com.reg');
        
        NGCC_Mapping_Object__c ngccCCMO= new NGCC_Mapping_Object__c(RecordTypeId = ccRecId,Name='Alea Canada',Cisco_Contact_Center_Manager1__c = uSMgr.Id,
                                                                    Cisco_Contact_Center_Manager2__c=uSMgr.Id);
        NGCC_Mapping_Object__c ngccCountryMO= new NGCC_Mapping_Object__c(RecordTypeId = ccCountry_Mapping,Name='UNITED STATES',Theater__c='Americas',Language__c='en_US');
        insert ngccCountryMO;
        test.startTest();
        // System.runAs(uSDR) {
        List<Lead> leadCS = NGCC_CallScript_Data_Test.testMultipleLead();
        insert leadCS;
        Campaign c= new Campaign(Name='Campaign1',Program_Event_Name__c='ProgramEvent',Program_Event_Code__c='000001');
        c.Offer_Description__c = 'test Description';
        c.Offer_URL__c = 'test.com';
        insert c;
        
        for(Lead lobj : leadCS){
            lobj.Campaign_Name__c = c.Id;    
            lobj.Third_Party_Data_Permission__c = 'Yes';
            lobj.Email_Permission__c = 'Yes';
            lobj.Call_Permission__c = 'Yes';             
        }             
        update leadCS;
        
        c.Priority__c = 3;
        update c;
        
        c.Status = 'Completed';
        update c;
        
        for(Lead lobj : leadCS){
            lobj.Campaign_Name__c = null;
            lobj.Third_Party_Data_Permission__c = Null;
            lobj.Email_Permission__c = Null;
            lobj.Call_Permission__c = Null;                   
        }             
        update leadCS;        
        //  }
        test.stopTest();
    }   
    
    public static testMethod void NGCC_Lead_Management_Owner_Test() {
        List < Lead > lstLead = new List < Lead > ();
        
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.NGCC_Mapping_Object__c ; 
        Map<String,Schema.RecordTypeInfo> mappingRecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id ccRecId = mappingRecordTypeInfo.get('Call Center').getRecordTypeId();
        Id ccCountry_Mapping = mappingRecordTypeInfo.get('Country Mapping').getRecordTypeId(); 
        
        
        User uSMgr = NGCC_CallScript_Data_Test.testSMUser();
        User uSDR = NGCC_CallScript_Data_Test.testSDRUser('sdr1@cisco.com.reg');
        User uSDR2 = NGCC_CallScript_Data_Test.testSDRUser('sdr2@cisco.com.reg');
        // insert uSDR;
        NGCC_Mapping_Object__c ngccCCMO= new NGCC_Mapping_Object__c(RecordTypeId = ccRecId,Name='Alea Canada',Cisco_Contact_Center_Manager1__c = uSMgr.Id,
                                                                    Cisco_Contact_Center_Manager2__c=uSMgr.Id);
        NGCC_Mapping_Object__c ngccCountryMO= new NGCC_Mapping_Object__c(RecordTypeId = ccCountry_Mapping,Name='UNITED STATES',Theater__c='Americas',Language__c='en_US');
        NGCC_Mapping_Object__c ngccCountryMOIndia= new NGCC_Mapping_Object__c(RecordTypeId = ccCountry_Mapping,Name='India',Theater__c='APJ',Language__c='en_US');  
        test.starttest();
        // System.runAs(uSDR) {
        List<Lead> leadCS = NGCC_CallScript_Data_Test.testMultipleLead();
        leadCS[0].Lead_Contact__c = [select id from Contact limit 1].id;
        insert leadCS;
        
        for(Lead lobj : leadCS){
            lobj.Lead_Contact__c = Null;
            lobj.CustomCountry__c = 'India';
            lobj.Route_To_AM__c = userinfo.getUserId();                                  
        }             
        update leadCS;             
        //} 
        test.stopTest();
    }   
    
    public static testMethod void NGCC_Lead_Management_SalesRejection_Test() {
        List < Lead > lstLead = new List < Lead > ();
        
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Lead; 
        Map<String,Schema.RecordTypeInfo> leadRecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id eleadRecId = leadRecordTypeInfo.get('eLeads').getRecordTypeId(); 
        
        Schema.DescribeSObjectResult cfrSchemaMapping = Schema.SObjectType.NGCC_Mapping_Object__c ; 
        Map<String,Schema.RecordTypeInfo> mappingRecordTypeInfo = cfrSchemaMapping.getRecordTypeInfosByName(); 
        Id ccRecId = mappingRecordTypeInfo.get('Call Center').getRecordTypeId();
        Id ccCountry_Mapping = mappingRecordTypeInfo.get('Country Mapping').getRecordTypeId(); 
        
        User uSMgr = NGCC_CallScript_Data_Test.testSMUser();
        User uSDR = NGCC_CallScript_Data_Test.testSDRUser('sdr1@cisco.com.reg');
        User uSDR2 = NGCC_CallScript_Data_Test.testSDRUser('sdr2@cisco.com.reg');
        insert uSDR2;
        insert uSMgr;
        user uAM = new user(firstName='Test',LastName ='AM', USERNAME='testam@cisco.com.sales.test',email='testam@cisco.com.test',ALIAS='testam',COMMUNITYNICKNAME='testam',ISACTIVE=True,
                            TIMEZONESIDKEY='America/Los_Angeles',PROFILEID = '00e30000000qhPXAAY',LANGUAGELOCALEKEY ='en_US',THEATRE__C='APJC-APAC',
                            LOCALESIDKEY ='en_US',EMAILENCODINGKEY='UTF-8');
        
        
        NGCC_Mapping_Object__c ngccCCMO= new NGCC_Mapping_Object__c(RecordTypeId = ccRecId,Name='Alea Canada',Cisco_Contact_Center_Manager1__c = uSMgr.Id,
                                                                    Cisco_Contact_Center_Manager2__c=uSMgr.Id);
        NGCC_Mapping_Object__c ngccCountryMO= new NGCC_Mapping_Object__c(RecordTypeId = ccCountry_Mapping,Name='UNITED STATES',Theater__c='Americas',Language__c='en_US');
        NGCC_Mapping_Object__c ngccCountryMOIndia= new NGCC_Mapping_Object__c(RecordTypeId = ccCountry_Mapping,Name='India',Theater__c='APJ',Language__c='en_US');  
        
        List<Lead> lsteLead = new List<Lead>();
        DateTime dtCreated = system.now();
        
        System.runAs(uAM) {
            for(integer i = 0; i < 5; i++){
                Lead l1 = new Lead(firstName='Test Call Script',
                                   LastName ='Testing'+i, 
                                   RECORDTYPEID=eleadRecId,
                                   Status = '1 Waiting',
                                   company='Test End-User Account',
                                   Address_Line_1__c = '175 West Tasman',
                                   Address_Line_2__c = 'West',
                                   CustomCity__c = 'San Jose',
                                   CustomState__c = 'CA',
                                   CustomZip__c = '95134',
                                   customCountry__c = 'UNITED STATES',
                                   MQL_Created_Date__c = dtCreated ,
                                   Call_Center_Vendor__c = 'Alea Canada',
                                   SDR_Lead_Owner_New__c = uSDR2.id,
                                   email='test@test.com.qtr');
                lsteLead.add(l1);
            }
            insert lsteLead ;             
            
            for(Lead l:lsteLead){
                if(!l.LastName.contains('1')){
                    l.Status = '3.12 Rejected-No Valid Project';
                }else{
                    l.Status = '3.5 Rejected-Project Canceled';
                }
                
            }                       
            
            update lsteLead;
        }
    }
    
    public static testMethod void NGCC_Lead_Management_Partners_Update_Test() {
        Lead l = NGCC_CallScript_Data_Test.testLead();
        GenericStaticTestData.insertTestUserRecords();
        Account a=GenericStaticTestData.gettestChannelAccountRecord1();
        a.Partner_Account_Status__c = 'Active (Registered)';
        update a;
        
        l.Cisco_Rec_PSR__c = GenericStaticTestData.testPSRUserRecord.id;
        l.Channel_Partner__c = a.id;
        l.Preferred_Partner__c = a.id;
        test.startTest();
        Update l;
        test.stopTest();         
    }
    
    public static testMethod void NGCC_Lead_Management_Partners_Insert_Test() {
        
        GenericStaticTestData.insertTestUserRecords();
        Account a=GenericStaticTestData.gettestChannelAccountRecord1();
        a.Partner_Account_Status__c = 'Active (Registered)';
        update a;
        
        ObjectRecordTypeIds__c orgConstant = ObjectRecordTypeIds__c.getInstance(); 
        Id marketingRecId = orgConstant.Marketing_Lead_RecordType__c;
        
        Lead l1 = new Lead(firstName='Test Call Script',
                           LastName ='Testing', 
                           RECORDTYPEID=marketingRecId,
                           company='Test End-User Account',
                           customCountry__c = 'UNITED STATES',
                           Status='New Prospect',
                           Cisco_Rec_PSR__c = GenericStaticTestData.testPSRUserRecord.id,
                           Channel_Partner__c = a.id,
                           Preferred_Partner__c = a.id,
                           email='test@test.com.qtr');
        
        test.startTest();
        insert l1;            
        test.stopTest();         
    }
    
    public static testMethod void NGCC_Lead_Management_Partners_Removal_Test() {
        
        GenericStaticTestData.insertTestUserRecords();
        Account a=GenericStaticTestData.gettestChannelAccountRecord1();
        a.Partner_Account_Status__c = 'Active (Registered)';
        update a;
        
        ObjectRecordTypeIds__c orgConstant = ObjectRecordTypeIds__c.getInstance(); 
        Id marketingRecId = orgConstant.Marketing_Lead_RecordType__c;
        
        Lead l1 = new Lead(firstName='Test Call Script',
                           LastName ='Testing', 
                           RECORDTYPEID=marketingRecId,
                           company='Test End-User Account',
                           customCountry__c = 'UNITED STATES',
                           Status='New Prospect',
                           Cisco_Rec_PSR__c = GenericStaticTestData.testPSRUserRecord.id,
                           Channel_Partner__c = a.id,
                           Preferred_Partner__c = a.id,
                           email='test@test.com.qtr');
        
        insert l1;                    
        test.startTest();
        l1.Cisco_Rec_PSR__c = NULL;
        l1.Channel_Partner__c = NULL;
        l1.Preferred_Partner__c = NULL;
        update l1;
        test.stopTest();         
    }
}