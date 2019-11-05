@isTest
private class RankingVForceTest {
    
    static testMethod void testRankingVForce(){
        Test.startTest();
        
        Lead_prioritization_model__c model = new Lead_prioritization_model__c();
        model.theatre__C = 'AMERICAS';
        model.Annual_Revenue_Weight__c = 5;
        model.Budget_Weight__c = 5;
        model.Buyer_Stage_Weight__c = 5;
        model.Cisco_Architecture_Weight__c = 5;
        model.Contact_Engagement_Weight__c = 5;
        model.Eloqua_Lead_Source_Weight__c = 5;
        model.Eloqua_Lead_Score_Weight__c = 5;
        model.Job_Role_Weight__c = 5;
        model.Vertical_Market_Weight__c = 5;
        model.Timeframe_Weight__c = 5;
        model.Lead_Category_Weight__c = 5;
        model.Lead_Source_Weight__c = 5;
        model.Main_Product_Weight__c = 5;
        model.Number_of_Employees_Weight__c = 5;
        model.Offer_Type_Weight__c = 5;
        model.Project_Flag_Weight__c = 5;
        model.Services_Value_Weight__c = 5;
        model.SAVM_Segment_Weight__c = 5;
        model.Product_Value_Weight__c = 5;
        model.medium_type_weight__c = 5;
       
       
        insert model;
        
        
            
        ApexPages.StandardController con = new Apexpages.StandardController(model);
        
        RankingVForce r = new RankingVForce( con ); 
        List <Ranking__C> testRank = r.getRanks();
        for (Ranking__C rank: testRank)
        {
            system.assertequals(rank.theatre__c, 'AMERICAS');
            
        }
        r.previous();
        r.next();
        r.first();
        r.last();
        r.refresh();
        r.Search();
        Boolean condition = r.hasNext;
        condition = r.hasPrevious;
       	Integer pageNum = r.pageNumber;
        Test.stopTest();
        
        
    } 

}