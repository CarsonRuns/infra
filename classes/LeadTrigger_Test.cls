/**
 * Name : LeadTrigger_Test
 * Author :  Unit Test Generator
 * Description : Test class used for testing the LeadTrigger
 * Date : 9/16/14 2:31 PM 
 * Version : <intial Draft> 
 * Revision:
 * 02/15/2017 - Updated for Zift project
 */
@isTest(seealldata=false)
private class LeadTrigger_Test {
     static testMethod  void testLeadTrigger(){
        UtilUnitTest.loadAllStaticData();
        User pa = GenericStaticTestData.gettestPAUserRecord();
        //UtilUnitTest.setSCPtriggerFlagLead();
        System.runAs(pa){
            Id partnerAccountId = GenericStaticTestData.gettestChannelAccountRecord1().Id;
            Lead leadTest = new Lead(firstName='Test Manual',LastName ='Lead', RECORDTYPEID='0123000000004aSAAQ', Partner_Lead_Status__c = 'Partner Assigned',LeadSource='test',company='Test End-User Account',email='test@test.com.test');
            insert leadTest;
            leadTest.Channel_Partner__c = partnerAccountId; 
            update leadTest;
            //delete leadTest;
        }
    }
    
    static testMethod void testZiftFlow1(){
        UtilUnitTest.loadAllStaticData();
        User paUser = GenericStaticTestData.gettestPAUserRecord();
        List<Lead> ziftLeads = new List<Lead>();
        Contact contactId = [Select ID, Name, AccountId, CCO_ID__c from Contact where ID =:paUser.ContactId];
        Account paAccount = [Select ID, Type from Account where ID =:contactId.AccountId];
        System.runAs(paUser){           
            Lead ziftLead1 = new Lead(firstName='Test Partner Generated',LastName ='Lead', RECORDTYPEID='012300000000lFWAAY',company='Test End-User Account1',email='test1@test.com.test', CustomCountry__c='UNITED STATES', Route_to_Partner_Account_BE_GEO_ID__c = '1234', LeadSource='Zift_AQL', Source_System__c = 'PMC/Zift', Source_System_ID__c = 'ZIFT000001');
            Lead ziftLead2 = new Lead(firstName='Test Partner Generated',LastName ='Lead', RECORDTYPEID='012300000000lFWAAY',company='Test End-User Account2',email='test2@test.com.test', CustomCountry__c='UNITED STATES', Route_to_Partner_Account_BE_GEO_ID__c = '1234', LeadSource='Zift_MQL', Source_System__c = 'PMC/Zift', Source_System_ID__c = 'ZIFT000002');
            
            ziftLeads.add(ziftLead1);
            ziftLeads.add(ziftLead2);
            insert ziftLeads;
            
            ziftLeads[0].Channel_Partner__c = paAccount.Id;
            ziftLeads[1].Channel_Partner__c = paAccount.Id;
            update ziftLeads;
        }
        
        paAccount.Type = 'Distributor';
        update paAccount;
        System.runAs(paUser){
            Lead ziftLead3 = new Lead(firstName='Test Partner Generated',LastName ='Lead', RECORDTYPEID='012300000000lFWAAY',company='Test End-User Accoun3',email='test3@test.com.test', CustomCountry__c='UNITED STATES', Route_to_Partner_Account_BE_GEO_ID__c = '1234', LeadSource='Zift_Partner', Source_System__c = 'PMC/Zift', Source_System_ID__c = 'ZIFT000003');
            insert ziftLead3;
            
            ziftLead3.Channel_Partner__c = paAccount.Id;
            update ziftLead3;
        }
    }
    
    static testMethod void testBulkInsert(){
        UtilUnitTest.loadAllStaticData();
        Id endCustomerAccountId = GenericStaticTestData.getTestEndUserAccountRecordRed().Id;
        List<Lead> bulkLead = new List<Lead>();
        for(integer i=0; i<100; i++){
            bulkLead.add(new Lead(
            //RECORDTYPEID='01280000000G6tnAAC',
            LASTNAME  = 'Yalamanchi',
            FIRSTNAME  = 'Srikanth',
            COMPANY  = 'Lead Test Data ' + i,
            STATUS  = '1 Waiting',
            ACCOUNT_NAME_ENGLISH__C  = 'Hero',
            TotalValue__c  = 89,
            Address_Line_1__c  = 'Cisco Way 0001',
            CustomCity__c  = 'San Jose',
            CustomCountry__c  = 'United States',
            End_Customer_Account__c  = endCustomerAccountId,
            LeadSource  = 'Bullseye',
            Program_Event_Name__c  = 'GO! Scale US Q2 FY13 - BE6K in UC Whitespace Q2FY14',
            QATimeFrame__c  = 'Over 12 Months',
            QABudget__c  = '$100,000+',
            Main_Technology__c  = 'UNIVERSAL DIAL ACCESS SOLUTIONS'
            ));
        }
        
        Lead newLead1 = new Lead(RECORDTYPEID='0123000000004aRAAQ',
            LASTNAME  = 'Yalamanchi',
            FIRSTNAME  = 'Srikanth',
            COMPANY  = 'Lead Test Data' ,
            STATUS  = '1 Waiting',
            ACCOUNT_NAME_ENGLISH__C  = 'Hero',
            TotalValue__c  = 89,
            Address_Line_1__c  = 'Cisco Way 0001',
            CustomCity__c  = 'San Jose',
            CustomCountry__c  = 'United States',
            End_Customer_Account__c  = endCustomerAccountId,
            LeadSource  = 'Global Eloqua Scored Lead',
            Program_Event_Name__c  = 'GO! Scale US Q2 FY13 - BE6K in UC Whitespace Q2FY14',
            QATimeFrame__c  = 'Over 12 Months',
            QABudget__c  = '$100,000+',
            Main_Technology__c  = 'UNIVERSAL DIAL ACCESS SOLUTIONS');
        
        Lead newLead2 = new Lead(RECORDTYPEID='0123000000004aRAAQ',
            LASTNAME  = 'Yalamanchi',
            FIRSTNAME  = 'Srikanth',
            COMPANY  = 'Lead Test Data' ,
            STATUS  = '1 Waiting',
            ACCOUNT_NAME_ENGLISH__C  = 'Hero',
            TotalValue__c  = 89,
            Address_Line_1__c  = 'Cisco Way 0001',
            CustomCity__c  = 'San Jose',
            CustomCountry__c  = 'United States',
            End_Customer_Account__c  = endCustomerAccountId,
            LeadSource  = 'Global Eloqua Hand Raiser',
            Program_Event_Name__c  = 'GO! Scale US Q2 FY13 - BE6K in UC Whitespace Q2FY14',
            QATimeFrame__c  = 'Over 12 Months',
            QABudget__c  = '$100,000+',
            Main_Technology__c  = 'UNIVERSAL DIAL ACCESS SOLUTIONS');

        bulkLead.add(newLead1);
        bulkLead.add(newLead2);
        
        Test.startTest();
            insert bulkLead;
        Test.stopTest();
    }
    
    static testMethod void testBulkUpdate(){
        UtilUnitTest.loadAllStaticData();
        Id partnerAccountId = GenericStaticTestData.gettestChannelAccountRecord1().Id;
        Id endCustomerAccountId = GenericStaticTestData.getTestEndUserAccountRecordRed().Id;
        List<Lead> bulkLead = new List<Lead>();
        for(integer i=0; i<100; i++){
            bulkLead.add(new Lead(
            //RECORDTYPEID='01280000000G6tnAAC',
            LASTNAME  = 'Yalamanchi',
            FIRSTNAME  = 'Srikanth',
            COMPANY  = 'Lead Test Data ' + i,
            STATUS  = '1 Waiting',
            ACCOUNT_NAME_ENGLISH__C  = 'Hero',
            TotalValue__c  = 89,
            Address_Line_1__c  = 'Cisco Way 0001',
            CustomCity__c  = 'San Jose',
            CustomCountry__c  = 'United States',
            End_Customer_Account__c  = endCustomerAccountId,
            LeadSource  = 'Bullseye',
            Program_Event_Name__c  = 'GO! Scale US Q2 FY13 - BE6K in UC Whitespace Q2FY14',
            QATimeFrame__c  = 'Over 12 Months',
            QABudget__c  = '$100,000+',
            Main_Technology__c  = 'UNIVERSAL DIAL ACCESS SOLUTIONS'
            ));
        }
        insert bulkLead;
        for(Lead l:bulkLead){
            l.CHANNEL_PARTNER__C = partnerAccountId;
            l.Lead_From_Distributor_BE_GEO_ID_PDB__c = '12345';
        }
        
        
        Test.startTest();
            update bulkLead;
        Test.stopTest();
    }
    
    static testMethod void testBulkUpdatePA(){
        UtilUnitTest.loadAllStaticData();
        Id partnerAccountId = GenericStaticTestData.gettestChannelAccountRecord1().Id;
        Id endCustomerAccountId = GenericStaticTestData.getTestEndUserAccountRecordRed().Id;
        User pa = GenericStaticTestData.gettestPAUserRecord();
        List<Lead> bulkLead = new List<Lead>();
        for(integer i=0; i<100; i++){
            bulkLead.add(new Lead(
            //RECORDTYPEID='01280000000G6tnAAC',
            LASTNAME  = 'Yalamanchi',
            FIRSTNAME  = 'Srikanth',
            COMPANY  = 'Lead Test Data ' + i,
            STATUS  = '1 Waiting',
            ACCOUNT_NAME_ENGLISH__C  = 'Hero',
            TotalValue__c  = 89,
            Address_Line_1__c  = 'Cisco Way 0001',
            CustomCity__c  = 'San Jose',
            CustomCountry__c  = 'United States',
            End_Customer_Account__c  = endCustomerAccountId,
            LeadSource  = 'Bullseye',
            Program_Event_Name__c  = 'GO! Scale US Q2 FY13 - BE6K in UC Whitespace Q2FY14',
            QATimeFrame__c  = 'Over 12 Months',
            QABudget__c  = '$100,000+',
            Main_Technology__c  = 'UNIVERSAL DIAL ACCESS SOLUTIONS',
            CHANNEL_PARTNER__C = partnerAccountId
            ));
        }
        insert bulkLead;
        system.debug(bulkLead);
        Test.startTest();
            //UtilUnitTest.setSCPtriggerFlagTP();
            System.runAs(pa){
                for(Lead l:bulkLead){
                    l.SCP_Partner_Lead_Status__c = 'Actively Working';
                    l.ProductAmount__c = 12823;
                    l.ServicesAmount__c = 354;
                }
               // update bulkLead;
            }
        Test.stopTest();
    }
    
    static testMethod void testBulkDelete(){
        UtilUnitTest.loadAllStaticData();
        Id partnerAccountId = GenericStaticTestData.gettestChannelAccountRecord1().Id;
        Id endCustomerAccountId = GenericStaticTestData.getTestEndUserAccountRecordRed().Id;
        List<Lead> bulkLead = new List<Lead>();
        for(integer i=0; i<100; i++){
            bulkLead.add(new Lead(
            //RECORDTYPEID='01280000000G6tnAAC',
            LASTNAME  = 'Yalamanchi',
            FIRSTNAME  = 'Srikanth',
            COMPANY  = 'Lead Test Data ' + i,
            STATUS  = '1 Waiting',
            ACCOUNT_NAME_ENGLISH__C  = 'Hero',
            TotalValue__c  = 89,
            Address_Line_1__c  = 'Cisco Way 0001',
            CustomCity__c  = 'San Jose',
            CustomCountry__c  = 'United States',
            End_Customer_Account__c  = endCustomerAccountId,
            LeadSource  = 'Bullseye',
            Program_Event_Name__c  = 'GO! Scale US Q2 FY13 - BE6K in UC Whitespace Q2FY14',
            QATimeFrame__c  = 'Over 12 Months',
            QABudget__c  = '$100,000+',
            Main_Technology__c  = 'UNIVERSAL DIAL ACCESS SOLUTIONS'
            ));
        }
        insert bulkLead;
        for(Lead l:bulkLead){
            l.CHANNEL_PARTNER__C = partnerAccountId;
        }
        update bulkLead;
        Test.startTest();
            delete bulkLead;
        Test.stopTest();
    }
}