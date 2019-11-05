/************************************************************************************************************************************
Name    : C360_CXResourcesControllerTest
Author  : C360 Dev team
Purpose : Test Class to cover C360_CXResourcesController class.
Date    : 28/06/2019
Change History : none
*************************************************************************************************************************************/
@isTest
public class C360_CXResourcesControllerTest {
    Integer num = 5;
    static testMethod void Method1() {  
        Test.startTest();
        List<C360_CXResources__mdt> listofCX = C360_CXResourcesController.getCXResources(5);
        List<C360_CXResources__mdt> listCX = C360_CXResourcesController.getCXResourcesIL();
        Integer count = C360_CXResourcesController.CountCXResources();
        Integer count1 = C360_CXResourcesController.CountCXResources();
        system.assertEquals(count, count1);
        system.assertEquals(listCX[0].MasterLabel,listofCX[0].MasterLabel );
        Test.stopTest();
    }
}