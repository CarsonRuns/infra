@isTest
public class CIContactLookup_Test{

    public static testMethod void testCtrlExtn() {
        PageReference pageRef = Page.CIContactLookup;
        pageRef.getParameters().put('contact_name', 'Dow Jones');
        pageRef.getParameters().put('email', 'test@test.com');
        pageRef.getParameters().put('job_title', 'Engineer');
        pageRef.getParameters().put('person_party_id', '123456');
        pageRef.getParameters().put('cr_party_id', '95432');
        Test.setCurrentPage(pageRef);
        Test.startTest();
            Contact c = new Contact();
            ApexPAges.StandardController sc = new ApexPages.StandardController(c);
            CIContactLookup_Ctrl pageCtrl = new CIContactLookup_Ctrl(sc);
            pageCtrl.lookupContact();
        Test.stopTest();
    }
}