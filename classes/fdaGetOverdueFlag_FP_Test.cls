@istest
public class fdaGetOverdueFlag_FP_Test {
public static testMethod void test()
{
       
        List<Territory2Type> terriType  = [SELECT id, DeveloperName from Territory2Type where  DeveloperName = 'DR' LIMIT 1];
        //insert territory model
        List<Territory2Model>   terrModel = [Select Id from Territory2Model where State = 'Active' limit 1];
        Territory2 terrData = new Territory2(
                DeveloperName = 'TestTerritory', 
                Territory2ModelId=terrModel[0].Id, Name='Parent Territory', Territory2TypeId=terriType[0].Id,AccountAccessLevel = 'All',
                OpportunityAccessLevel = 'Edit');
                insert terrData;
        List<Territory2> terr1 = new List<Territory2>();
        terr1.add(terrData);
                                                 
        Opportunity newOpportunity1 = new Opportunity(name='Test111',territory2id=terr1[0].id,StageName='2 - Qualification',dealid__c='111',opportunity_status__c = 'Active',CloseDate= Date.newInstance(2008,09,05));
        Opportunity newOpportunity2 = new Opportunity(name='Test112',territory2id=terr1[0].id,StageName='3 - Proposal',dealid__c='112',opportunity_status__c = 'Active',CloseDate= Date.newInstance(2008,09,25));
        List<Opportunity> opptyArray = new  List<Opportunity>();
        opptyArray.add(newOpportunity1);
        opptyArray.add(newOpportunity2);
        String optyflag = fdaGetOverdueFlag_FP.getOverdueflag(terr1[0].name, Date.newInstance(2008,10,05));
        optyflag = fdaGetOverdueFlag_FP.getOverdueflag(terr1[0].name, Date.newInstance(2008,10,25));
        optyflag = fdaGetOverdueFlag_FP.getOverdueflag('gcghsjj', Date.newInstance(2008,10,25));
        User newUser1 = new User(UserName='test@cisco.com.reg',IsActive=true,firstname='firstname',lastname='testContact');
        UserTerritory2association ut = new UserTerritory2Association(Territory2Id=terr1[0].id, UserId=newUser1.Id);
        optyflag = fdaGetOverdueFlag_FP.getOverdueflag('test', Date.newInstance(2008,10,05)); 
}
}