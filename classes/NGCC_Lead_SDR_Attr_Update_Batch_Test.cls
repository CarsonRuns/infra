@isTest(seeAllData=true)
public class NGCC_Lead_SDR_Attr_Update_Batch_Test {
    Public static testmethod void NGCC_Lead_SDR_Attributes_Update_Batch_Test_autoAccepted(){
        
        
        Profile integrationProfile = [SELECT Id FROM Profile WHERE Name ='Cisco_Integration_Echo_Suppression'  Limit 1 ];
        User IntegrationUser = new User(Alias = 'newUser', Email = 'newIntegrationusertest@cisco.com',
                                        EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                                        LocaleSidKey = 'en_US', ProfileId = integrationProfile.Id,TimeZoneSidKey = 'America/Los_Angeles', 
                                        UserName = 'newIntegrationusertest@testorg.com', Theatre__c = 'EMEAR');
        
        insert IntegrationUser;
        
        Profile p = [SELECT Id FROM Profile WHERE Name ='Cisco_NGCC'  Limit 1 ];
        UserRole rSDR = [SELECT Id FROM UserRole WHERE Name Like '%SDR%' Limit 1];
        User SDRUser = new User(Alias = 'newUser', Email = 'newsdrusertest@cisco.com',
                                EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                                LocaleSidKey = 'en_US', ProfileId = p.Id, UserRoleId = rSDR.id,TimeZoneSidKey = 'America/Los_Angeles', 
                                UserName = 'newsdrusertest@testorg.com', Theatre__c = 'EMEAR',Marketing_Call_Center__c='N3 Atlanta');
        
        insert SDRUser;
        
        
        ObjectRecordTypeIds__c orgConstant = ObjectRecordTypeIds__c.getInstance(); 
        Id marketingRecId = orgConstant.Marketing_Lead_RecordType__c;
        Lead newlead;
        system.runAs(IntegrationUser){
            newlead = new Lead(firstName='TestFirstname',
                               LastName ='TestLastname', 
                               RECORDTYPEID=marketingRecId,
                               company='SDRtest',
                               customCountry__c = 'UNITED STATES',
                               Status='New Prospect',
                               email='testsdr@test.com',
                               Eloqua_Asset_Id__c=System.Label.NGCC_Eloqua_Asset_Id,Ownerid = [select id,Name from Group where Name like '%Callback' limit 1].id,
                               Call_Center_Vendor__c = 'N3 Atlanta',SDR_Assignment_DateTime__c=datetime.now(),SDR_Assignment_Date__c=system.today(),SDR_Lead_Owner_Email__c='testsdr@test.com',
                               SDR_Lead_Owner_New__c='testsdr',SDR_Lead_Owner_Name__c='testleadOwnerName');
            
            
            insert newlead; 
        }
        test.startTest();
        NGCC_Lead_SDR_Attributes_Update_Batch batch = new NGCC_Lead_SDR_Attributes_Update_Batch();
        database.executeBatch(batch);
        test.stopTest();
        
        Lead UpdatedLead = [select id,Call_Center_Vendor__c,SDR_Assignment_DateTime__c,SDR_Assignment_Date__c,SDR_Lead_Owner_Email__c,SDR_Lead_Owner_New__c,SDR_Lead_Owner_Name__c from Lead where id=:newlead.id limit 1];
        system.assertEquals(null, UpdatedLead.Call_Center_Vendor__c);
        system.assertEquals(null, UpdatedLead.SDR_Assignment_DateTime__c);
        system.assertEquals(null, UpdatedLead.SDR_Assignment_Date__c);
        system.assertEquals(null, UpdatedLead.SDR_Lead_Owner_Email__c);
        system.assertEquals(null, UpdatedLead.SDR_Lead_Owner_New__c);
        system.assertEquals(null, UpdatedLead.SDR_Lead_Owner_Name__c);
    }
    Public static testmethod void NGCC_Lead_SDR_Attributes_Update_Batch_Test_UserAccepted(){
        
        
        Profile integrationProfile = [SELECT Id FROM Profile WHERE Name ='Cisco_Integration_Echo_Suppression'  Limit 1 ];
        User IntegrationUser = new User(Alias = 'newUser', Email = 'newIntegrationusertest@cisco.com',
                                        EmailEncodingKey = 'UTF-8',LastName = 'Testing', LanguageLocaleKey = 'en_US',
                                        LocaleSidKey = 'en_US', ProfileId = integrationProfile.Id,TimeZoneSidKey = 'America/Los_Angeles', 
                                        UserName = 'newIntegrationusertest@testorg.com', Theatre__c = 'EMEAR');
        
        insert IntegrationUser;
        
        Profile p = [SELECT Id FROM Profile WHERE Name ='Cisco_NGCC'  Limit 1 ];
        UserRole rSDR = [SELECT Id FROM UserRole WHERE Name Like '%SDR%' Limit 1];
        User SDRUser = new User(Alias = 'newUser', Email = 'newsdrusertest@cisco.com',
                                EmailEncodingKey = 'UTF-8', Firstname='Firstname', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                                LocaleSidKey = 'en_US', ProfileId = p.Id, UserRoleId = rSDR.id,TimeZoneSidKey = 'America/Los_Angeles', 
                                UserName = 'newsdrusertest@testorg.com', Theatre__c = 'EMEAR',Marketing_Call_Center__c='N3 Atlanta');
        
        insert SDRUser;
        
        
        ObjectRecordTypeIds__c orgConstant = ObjectRecordTypeIds__c.getInstance(); 
        Id marketingRecId = orgConstant.Marketing_Lead_RecordType__c;
        Lead newlead;
        system.runAs(IntegrationUser){
            newlead = new Lead(firstName='TestFirstname',
                               LastName ='TestLastname', 
                               RECORDTYPEID=marketingRecId,
                               company='SDRtest',
                               customCountry__c = 'UNITED STATES',
                               Status='New Prospect',
                               email='testsdr@test.com',
                               Eloqua_Asset_Id__c=System.Label.NGCC_Eloqua_Asset_Id,Ownerid = SDRUser.id);
            
            
            insert newlead; 
            
            newlead.Call_Center_Vendor__c = '';
            newlead.SDR_Assignment_DateTime__c = null;
            newlead.SDR_Assignment_Date__c = null;
            newlead.SDR_Lead_Owner_Email__c = '';
            newlead.SDR_Lead_Owner_New__c = '';
            newlead.SDR_Lead_Owner_Name__c = '';
            newlead.LeadSource = 'Eloqua';
            Update newlead;
        }
        test.startTest();
        NGCC_Lead_SDR_Attributes_Update_Batch batch = new NGCC_Lead_SDR_Attributes_Update_Batch();
        database.executeBatch(batch);
        test.stopTest();
        
        Lead UpdatedLead = [select id,LeadSource,Call_Center_Vendor__c,SDR_Assignment_DateTime__c,SDR_Assignment_Date__c,SDR_Lead_Owner_Email__c,SDR_Lead_Owner_New__c,SDR_Lead_Owner_Name__c from Lead where id=:newlead.id limit 1];
        system.assertEquals(SDRUser.Marketing_Call_Center__c, UpdatedLead.Call_Center_Vendor__c);
        system.assertEquals(system.today(), UpdatedLead.SDR_Assignment_Date__c);
        system.assertEquals(SDRUser.email, UpdatedLead.SDR_Lead_Owner_Email__c);
        system.assertEquals(SDRUser.Id, UpdatedLead.SDR_Lead_Owner_New__c);
        system.assertEquals(SDRUser.FirstName+' '+SDRUser.Lastname, UpdatedLead.SDR_Lead_Owner_Name__c);
        system.assertEquals('NGCC', UpdatedLead.LeadSource);
    }
    Public static testmethod void NGCC_Lead_SDR_Attributes_Update_Schedule_Test_UserAccepted(){
        Test.StartTest();
        NGCC_Lead_SDR_Attributes_Update_Schedule sh1 = new NGCC_Lead_SDR_Attributes_Update_Schedule();      
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, sh1);
        Test.stopTest();
    }
}