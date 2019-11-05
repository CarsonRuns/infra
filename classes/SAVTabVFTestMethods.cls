@istest(SeeAllData=true)
private class SAVTabVFTestMethods{
    private static testMethod void test_SAVTab_VF_CT(){
       
    test.startTest();
           
    SAVTab_VF_CT controller = new SAVTab_VF_CT();
    controller.getMslURL();
    controller.getUserPermission();
          
    test.stopTest();
    }
}