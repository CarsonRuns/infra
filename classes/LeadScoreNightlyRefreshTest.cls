@isTest(seeAllData=true)
private class LeadScoreNightlyRefreshTest {
    
    
    static testMethod void testNightlyRefresh(){
        RecordType r = new RecordType();
        r=[select Id,Name from RecordType where Name='Manual' and SobjectType='Lead' limit 1];  
        
        List <Lead_Prioritization_Model__c> model = [select ID, theatre__c,sub_region__c,lastmodifieddate from lead_prioritization_model__C limit 10];
        update model;
        
        Lead testLead1 = new Lead();
        testLead1.RecordtypeId=r.Id;// recordtype
        testLead1.Status = '1 waiting';
        testLead1.LastName='Test1';
        testLead1.company='csc';
        testLead1.CustomCountry__c = 'UNITED STATES';
        testLead1.Theater__c = 'AMERICAS';// lead theater
        testLead1.Originating_Marketing_Pipeline__c = 4000;
        testLead1.Lead_Category__c = 'BANT';
        testLead1.LeadSource = 'Bluebird Lead';
        testLead1.QATimeFrame__c = '5-12 MONTHS';
        testLead1.Estimated_Product_Amount_USD__c = 2000;
        testLead1.Estimated_Service_Amount_USD__c = 2000;
        testLead1.TotalValue__c = 30000;
        testLead1.Main_Technology__c = 'AGGREGATION';
        testLead1.Job_Role__c = '';
        testLead1.inbound_program__c = 'Yes';
        testLead1.Has_Purchased_from_Cisco_Before__c = 'Yes';
        insert testLead1;
        
        Test.startTest();
        Id batchInstanceId = Database.executeBatch(new LeadScoreNightlyRefresh(),5);
        Test.stopTest();
        
        
    }
    
}