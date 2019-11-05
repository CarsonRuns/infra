@istest(SeeAllData=true)
private class PartyHierarchyTestMethods{
    private static testMethod void test_Party_Hierarchy_CT(){
       
    test.startTest();
           
    ApexPages.StandardController con = new ApexPages.StandardController(new Account());
    Party_Hierarchy_CT controller = new Party_Hierarchy_CT(con);
    controller.getCscURL();
          
    test.stopTest();
    }
}