@isTest(seealldata=true)
public class OpptyFutureClass_test {
     public static testMethod void test_getDealId(){ 
        List<id> opt = new List<id>(); 
        Opportunity o = new Opportunity(name='Test',StageName='1 - Prospect',CloseDate=System.today(),Expected_Product__c=10.0,DealID__c='123',Opportunity_Status__c='Active');
        Insert o;
        AT_Workspace__c atw = new AT_Workspace__c();
        atw.Opportunity__c = o.id;
        atw.AT_Competitor__c ='test';
        atw.AT_Team__c ='test';
        atw.Sync_With_Opportunity__c = true;
        insert atw;
        o.Opportunity_Status__c='booked';
        update o;       
        opt.add(o.id);
        Quote__c q = new Quote__c(Opportunity_Name__c = o.Id);     
        Insert q;     
        Opportunity op = new Opportunity(Id=o.Id,name='Test2');     
        Update op;      
        OpptyFutureClass.syncWorkspaceWithOpty(opt);
  }
  public static testMethod void test_getDealId1(){ 
        List<id> opt = new List<id>(); 
        Opportunity o = new Opportunity(name='Test',StageName='1 - Prospect',CloseDate=System.today(),Expected_Product__c=10.0,DealID__c='123',Opportunity_Status__c='Active');
        Insert o;
        opt.add(o.id);
        Quote__c q = new Quote__c(Opportunity_Name__c = o.Id);     
        Insert q;     
        Opportunity op = new Opportunity(Id=o.Id,name='Test2');     
        Update op;  
        AT_Workspace__c atw = new AT_Workspace__c();
        atw.Opportunity__c = o.id;
        atw.AT_Competitor__c ='test';
        atw.AT_Team__c ='test';
        atw.Sync_With_Opportunity__c = true;
        insert atw; 
        OpptyFutureClass.syncWorkspaceWithOpty(opt);
  }
}