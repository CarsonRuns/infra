@isTest(SeeAllData = True)
public class NGCC_Assignment_Rule_Update_Test {

      public static testMethod void countTest() {
      
        Campaign id = new Campaign(name = 'test');
        insert id;
        id.Program_Originating_Country__c = 'Testing Input';
        id.Outbound_Call_Center__c = 'Fake Input';
        update id;
        
      }
      
      public static testMethod void noCountTest() {
       Campaign id = new Campaign(name = 'test');
       insert id;
       update id;
      }
      
      public static testMethod void listGenerationTest() {
      
        Campaign id = new Campaign(name = 'test');
        insert id;
        id.Program_Originating_Country__c = 'Testing Input';
        update id;
      }
      
      public static testMethod void conditionGenerationTest() {
        Campaign[] id = new Campaign[2]; 
        Campaign id1 = new Campaign(name = 'test');
        Campaign id2 = new Campaign(name = 'test');
        id[0] = id1;
        id[1] = id2;
        insert id;
        id[0].Program_Originating_Country__c = 'Testing Input';
        id[1].Outbound_Call_Center__c = 'fake test';
        update id; 
      }
      
      public static testMethod void noConditionGenerationTest() {
      
        Campaign[] id = new Campaign[2]; 
        Campaign id1 = new Campaign(name = 'test');
        Campaign id2 = new Campaign(name = 'test');
        id[0] = id1;
        id[1] = id2;
        insert id;
        id[0].Program_Originating_Country__c = null;
        id[1].Program_Originating_Country__c = null;
        id[0].Outbound_Call_Center__c = null;
        id[1].Outbound_Call_Center__c = null;
        update id; 
      }
      
      
       public static testMethod void countryTest() {
      
        Campaign[] id = new Campaign[1]; 
        Campaign id1 = new Campaign(name = 'test');
        id[0] = id1;
        insert id;
        
        id[0].Program_Originating_Country__c = 'United States';
        id[0].Outbound_Call_Center__c = 'Convergys Manila - Global';
        update id; 
      }
      
      public static testMethod void defaultCountryEmptyTest() {
      
        Campaign[] id = new Campaign[1]; 
        Campaign id1 = new Campaign(name = 'test');
        id[0] = id1;
        insert id;
        
        id[0].Program_Originating_Country__c = null;
        id[0].Outbound_Call_Center__c = 'Convergys Manila - Global';
        update id; 
      }
}