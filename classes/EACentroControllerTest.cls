@isTest
public class EACentroControllerTest {
public static testMethod void testEACentroController() {
PageReference pageRef = Page.EA_Centro;
Test.setCurrentPage(pageRef);
ApexPages.currentPage().getParameters().put('dashboardName', 'TopDeals');
EACentroController eac = new EACentroController ();
}
}