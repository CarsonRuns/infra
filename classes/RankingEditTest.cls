@isTest(seeAllData=true)
private class RankingEditTest {
    
    static testMethod void testRankingEdit(){
        Test.startTest();
        Ranking__C r1 = new Ranking__C();
        r1 = [select id, theatre__C, attribute_name__C, attribute_value__C, attribute_ranking__c from ranking__C where theatre__C = 'AMERICAS' and attribute_name__C = 'LEAD CATEGORY' and attribute_value__C = 'BANT'];
        
        ApexPages.StandardController con = new Apexpages.StandardController(r1);
        
        RankingEdit r = new RankingEdit( con );
        List <Ranking__C> testRank = r.getRanks();
        for (Ranking__C rank: testRank)
        {
            system.assertequals(rank.theatre__c, 'AMERICAS');
            system.assertequals(rank.attribute_name__C, 'LEAD CATEGORY');
            
        }
        r.getRanks();
        
        r.saveRank();
        r.previous();
        r.next();
        r.first();
        r.last();
        r.refresh();
        Boolean condition = r.hasNext;
        condition = r.hasPrevious;
        system.debug('Ranks:' +r);
        Test.stopTest();
        
        
    } 

}