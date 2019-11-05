@isTest(seeAllData=true)
private class LPExtensionTest {
    
    
    static testMethod void testCalcScore(){
        
        
        
        //Create Test Lead
        RecordType r = new RecordType();
        r=[select Id,Name from RecordType where Name='Manual' and SobjectType='Lead' limit 1];  
        
        
        Lead testLead = new Lead();
        testLead.RecordtypeId=r.Id;// recordtype
        testLead.Status = '1 waiting';
        testLead.LastName='Test1';
        testLead.company='csc';
        testLead.CustomCountry__c = 'AUSTRIA';
        testLead.Theater__c = 'EMEAR';// lead theater
        testLead.Originating_Marketing_Pipeline__c = 4000;
        testLead.Lead_Category__c = 'BANT';
        testLead.LeadSource = 'Bluebird Lead';
        testLead.QATimeFrame__c = '5-12 MONTHS';
        testLead.Estimated_Product_Amount_USD__c = 2000;
        testLead.Estimated_Service_Amount_USD__c = 2000;
        testLead.TotalValue__c = 30000;
        testLead.Main_Technology__c = 'AGGREGATION';
        testLead.Job_Role__c = '';
        testLead.inbound_program__c = 'Yes';
        testLead.Has_Purchased_from_Cisco_Before__c = 'Yes';
        insert testLead;
        
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
        
        //Verify Score for the test lead
         Test.startTest();
        testlead = [select Name, lead_prioritization_score__C from lead where id = :testLead.id];
        System.assert(testLead.Lead_Prioritization_Score__c >= 0, 'Test Passed');
        testlead1 = [select Name, lead_prioritization_score__C from lead where id = :testLead1.id];
        System.assert(testLead1.Lead_Prioritization_Score__c >= 0, 'Test Passed');
        
        Map<String, Integer> scoremap1 = new Map<String, Integer> ();
        LPExtension obj2 = new LPExtension();
        List <Lead> LeadObj1 = [select ID,Lead_Prioritization_Score__c,customCountry__c  from lead where id = :testlead1.ID]; 
        if (LeadObj1[0].Id != null)
        scoremap1 = obj2.Calcscore(LeadObj1);
        System.assertequals(scoremap1.get(testLead1.Id), testLead1.Lead_Prioritization_Score__c, 'Test case passed');
       
        Map<String, Integer> scoremap = new Map<String, Integer> ();
        LPExtension obj1 = new LPExtension();
        List <Lead> LeadObj = [select ID,Lead_Prioritization_Score__c,customCountry__c  from lead where id = :testlead.ID]; 
        if (LeadObj[0].Id != null)
        scoremap = obj1.Calcscore(LeadObj);
        System.assertequals(scoremap.get(testLead.Id), testLead.Lead_Prioritization_Score__c, 'Test case passed');
        
        testLead.TotalValue__c = 1000;
        update testLead;
        scoremap = obj1.Calcscore(LeadObj); 
        System.assertequals(scoremap.get(testLead.Id), testLead.Lead_Prioritization_Score__c, 'Test case passed');
        
         testLead.TotalValue__c = 6000;
        update testLead;
        scoremap = obj1.Calcscore(LeadObj); 
        System.assertequals(scoremap.get(testLead.Id), testLead.Lead_Prioritization_Score__c, 'Test case passed');
        
         testLead.TotalValue__c = 12000;
        update testLead;
        scoremap = obj1.Calcscore(LeadObj); 
        System.assertequals(scoremap.get(testLead.Id), testLead.Lead_Prioritization_Score__c, 'Test case passed');
        
         testLead.TotalValue__c = 45000;
        update testLead;
        scoremap = obj1.Calcscore(LeadObj); 
        System.assertequals(scoremap.get(testLead.Id), testLead.Lead_Prioritization_Score__c, 'Test case passed');
        
        testLead.TotalValue__c = 55000;
        update testLead;
        scoremap = obj1.Calcscore(LeadObj); 
        System.assertequals(scoremap.get(testLead.Id), testLead.Lead_Prioritization_Score__c, 'Test case passed');
       
        
         testLead.TotalValue__c = 100001;
        update testLead;
        scoremap = obj1.Calcscore(LeadObj); 
        System.assertequals(scoremap.get(testLead.Id), testLead.Lead_Prioritization_Score__c, 'Test case passed');
        
        Test.stopTest();
    }
    
    
  
}